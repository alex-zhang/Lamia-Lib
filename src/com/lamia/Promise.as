/**
 * User: alex
 * Date: 15/9/25
 * Time: 13:00
 */
package com.lamia {
	import flash.utils.setTimeout;

	/**
	 * Promise/A+ 规范
	 * @see https://leohxj.gitbooks.io/front-end-database/content/javascript-asynchronous/promise-standard.html
	 *
	 * issue
	 * + unhandled rejection
	 * 	use settimeout throw error.
	 *
	 */
	final public class Promise {
		static public const VERSION:String = "0.0.1";

		static public const PENDING_STATE:int = 0;
		static public const FULLFILLED_STATE:int = 1;
		static public const REJECTED_STATE:int = 2;

		static public function resolve(value:*):Promise {
			if(Promise.isThenable(value)) {
				var deferred:Object = Promise.deferred();
				value.then(
						function(value:*):void {
							deferred.resolve(value);
						},
						function(reason:*):void {
							deferred.reject(reason);
						}
				)
				return deferred.promise;
			} else {
				return new Promise(function(resolve:Function, reject:Function):void {
					resolve(value);
				});
			}
		}

		static private function isThenable(value:Boolean):Boolean {
			if(value.hasOwnProperty('then') && value['then'] is Function) {
				return true;
			}
			return false;
		}

		static public function reject(reason:*):Promise {
			return new Promise(function(resolve:Function, reject:Function):void {
				reject(reason);
			});
		}

		static public function all(iterable:*):Promise {
			var len:int = iterable ? iterable.length : 0;
			var deferred:Object = Promise.deferred();
			var results:Array = [];
			iterable.forEach(
				function(p:*, idx:int):void {
					if(!(p is Promise)) {
						p = Promise.resolve(p);
					}
					p.then(
						function(value:*):void {
							results[idx] = value;
							len--;
							if(len === 0) {
								deferred.resolve(results);
							}
						},
						function(reson:*):void {
							deferred.reject(reson);
						})
			});
			return deferred.promise;
		}

		//Not standard
		static public function queue(iterable:*):Promise {
			var len:int = iterable ? iterable.length : 0;
			var deferred:Object = Promise.deferred();
			var results:Array = [];
			var idx:int = -1;

			next();

			function next():void {
				idx++;
				if(idx < len) {
					var p:* = iterable[idx];
					if(!(p is Promise)) {
						p = Promise.resolve(p);
					}
					p.then(
						function(value:*):void {
							results[idx] = value;
							next();
						},
						function(reson:*):void {
							deferred.reject(reson);
						})
				} else {
					deferred.resolve(results);
				}
			}

			return deferred.promise;
		}

		//Not standard
		static public function delay(time:int):Promise {
			return new Promise(function(resolve:Function):void {
				setTimeout(reject, time);
			});
		}

		// Any Promise is Completed, and will not stop the others.
		static public function race(iterable:*):Promise {
			var deferred:Object = Promise.deferred();
			var firstP:Promise;
			iterable.forEach(
				function(p:*, idx:int):void {
					if(!(p is Promise)) {
						p = Promise.resolve(p);
					}
					p.then(
						function(value:*):void {
							if(!firstP) {
								firstP = p;
								deferred.resolve(value);
							}
						},
						function(reson:*):void {
							if(!firstP) {
								firstP = p;
								deferred.reject(reson);
							}
						}
					)
				});
			return deferred.promise;
		}

		static public function deferred():Object {
			var deferred:Object = {};
			deferred.promise = new Promise(function(resolve:Function = null, reject:Function = null):void {
				deferred.resolve = resolve;
				deferred.reject = reject;
			});
			return deferred;
		}

		//----------------------------------------------------------------------

		private var mQueue:Array = [];
		//default pendding.
		private var mCompletedState:int = PENDING_STATE;
		//when fulfilled state it's `eventual value` when rejected state it's `reason`
		private var mCompletedData:*;

		public function Promise(resolver:Function) {
			super();
			//resolver has no context of this.
			resolver.call(null,
				function():void {
					completeState(FULLFILLED_STATE, arguments[0]);
				},
				function():void {
					completeState(REJECTED_STATE, arguments[0]);
				}
			);
		}

		public function then(onFulfilled:Function = null, onRejected:Function = null):Promise {
			return next(onFulfilled, onRejected, null);
		}

		//catch is key word.
		public function caught(onRejected:Function):Promise {
			return next(null, onRejected, null);
		}

		//finally is key word
		public function final(onCompleted:Function = null):Promise {
			return next(null, null, onCompleted);
		}

		private function next(onFulfilled:Function = null, onRejected:Function = null, onCompleted:Function = null):Promise {
			var deferred:Object = Promise.deferred();
			deferred.onFulfilled = onFulfilled;
			deferred.onRejected = onRejected;
			deferred.onCompleted = onCompleted;
			//In IOS void to use push.
			mQueue[mQueue.length] = deferred;
			return deferred.promise;
		}

		private function completeState(state:int, data:* = undefined):void {
			if(mCompletedState === PENDING_STATE) {
				mCompletedState = state;
				mCompletedData = data;

				var deferred:Object;
				//completeStateFn must not null here.
				var completeStateFn:Function;
				var onCompleteFn:Function;
				var completedData:*;

				//this call later is important!
				setTimeout(function():void {
					for(var idx:int = 0, len:int = mQueue.length; idx < len; idx++) {
						deferred = mQueue[idx];

						//here will consider the state change.
						//Normal Rule
						//---------------------------------------------------
						// (parent-promise)[    *    ] + (current-promise)<        NaN  |     NaN     |    NaN       > = (current-promise)[    *    ]

						// (parent-promise)[fulfilled] + (current-promise)<onfulFulled* | onRejected  | onCompleted  > = (current-promise)[fulfilled]
						// (parent-promise)[fulfilled] + (current-promise)<onfulFulled* | onRejected  |    NaN  		 > = (current-promise)[fulfilled]
						// (parent-promise)[fulfilled] + (current-promise)<onfulFulled* |     NaN     | onCompleted  > = (current-promise)[fulfilled]
						// (parent-promise)[fulfilled] + (current-promise)<onfulFulled* |     NaN     |    NaN       > = (current-promise)[fulfilled]
						// (parent-promise)[fulfilled] + (current-promise)<        NaN  | onRejected  | onCompleted* > = (current-promise)[fulfilled]
						// (parent-promise)[fulfilled] + (current-promise)<        NaN  | onRejected  |    NaN       > = (current-promise)[fulfilled]
						// (parent-promise)[fulfilled] + (current-promise)<        NaN  |     NaN     | onCompleted* > = (current-promise)[fulfilled]

						// (parent-promise)[rejected ] + (current-promise)<onfulFulled  | onRejected* | onCompleted  > = (current-promise)[fulfilled]
						// (parent-promise)[rejected ] + (current-promise)<onfulFulled  | onRejected* |    NaN       > = (current-promise)[fulfilled]
						// (parent-promise)[rejected ] + (current-promise)<onfulFulled  |     NaN     |    NaN       > = (current-promise)[rejected ]
						// (parent-promise)[rejected ] + (current-promise)<onfulFulled  |     NaN     | onCompleted* > = (current-promise)[fulfilled]
						// (parent-promise)[rejected ] + (current-promise)<        NaN  | onRejected*	| onCompleted  > = (current-promise)[fulfilled]
						// (parent-promise)[rejected ] + (current-promise)<        NaN  | onRejected* | 	 NaN       > = (current-promise)[fulfilled]
						// (parent-promise)[rejected ] + (current-promise)<        NaN  |     NaN     | onCompleted* > = (current-promise)[fulfilled]

						//Super Rule
						//---------------------------------------------------
						// (parent-promise)[    *    ] + (current-promise)<              onFnExecute* throw Error     > = (current-promise)[rejected ]
						// (parent-promise)[    *    ] + (current-promise)<              onFbExecute* return Promise  > = (current-promise)[return Promise[*]]
						//---------------------------------------------------

						if(mCompletedState === FULLFILLED_STATE) {
							completeStateFn = deferred.resolve;
							onCompleteFn = deferred.onFulfilled || deferred.onCompleted;
						} else {//rejected state
							onCompleteFn = deferred.onRejected || deferred.onCompleted;
							if(onCompleteFn != null) {
								completeStateFn = deferred.reject;
							} else {
								completeStateFn = deferred.resolve;
							}
						}

						//here to execute the then callback.
						try {
							if(onCompleteFn != null) {
								completedData = onCompleteFn.call(null, mCompletedData);
							}
						} catch(error:Error) {
							completeStateFn = deferred.reject;
							completedData = error;
						}

						if(completedData is Promise) {
							Promise(completedData).then(
								function(value:*):void {
									completedData = value === undefined ? mCompletedData : value;
									completeStateFn = deferred.resolve;
									completeStateFn(completedData);
								},
								function(reson:*):void {
									completedData = reson === undefined ? mCompletedData : reson;
									completeStateFn = deferred.reject;
									completeStateFn(completedData);
								}
							);
						} else {
							completedData = completedData === undefined ? mCompletedData : completedData;
							completeStateFn(completedData);
						}
					}
					//clear the queue.
					mQueue.length = 0;
				}, 0)
			}
		}
	}
}