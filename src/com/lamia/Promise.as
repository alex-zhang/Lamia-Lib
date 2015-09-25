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
	 */
	final public class Promise {
		static public const VERSION:String = "0.0.1";

		static public const PENDING_STATE:int = 0;
		static public const FULLFILLED_STATE:int = 1;
		static public const REJECTED_STATE:int = 2;

		static public function resolve(value:*):Promise {
			return new Promise(function(resolve:Function, reject:Function) {
				resolve(value);
			});
		}

		static public function reject(reason:*):Promise {
			return new Promise(function(resolve:Function, reject:Function) {
				reject(reason);
			});
		}

		static public function all(iterable:*):Promise {
			var len:int = iterable ? iterable.length : 0;
			var deferred:Object = Promise.deferred();
			var results:Array = [];
			iterable.forEach(
				function(p:Promise, index:int):void {
					p.then(
						function(value:*):void {
							results[index] = value;
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

		static public function delay(time:int):Promise {
			return new Promise(function(resolve:Function) {
				setTimeout(reject, time);
			});
		}

		static public function deferred():Object {
			var deferred:Object = {};
			deferred.promise = new Promise(function(resolve:Function = null, reject:Function = null):void {
				deferred.resolve = resolve;
				deferred.reject = reject;
			});
			return deferred;
		}

		//--------------------------------------------------------------------------------------------------------------

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
			var deferred:Object = Promise.deferred();
			deferred.onFulfilled = onFulfilled;
			deferred.onRejected = onRejected;
			//In IOS void to use push.
			mQueue[mQueue.length] = deferred;
			return deferred.promise;
		}

		//catch is key word.
		public function caught(onRejected:Function):Promise {
			return then(null, onRejected);
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
					for(var i:int = 0, n:int = mQueue.length; i < n; i++) {
						deferred = mQueue[i];
						//here will consider the state change.
						//---------------------------------------------------
						// (parent-promise)[    *    ] + (current-promise)<        NaN  |     NaN    > = (current-promise)[    *    ]

						// (parent-promise)[fulfilled] + (current-promise)<onfulFulled* | onRejected > = (current-promise)[fulfilled]
						// (parent-promise)[fulfilled] + (current-promise)<onfulFulled* |     NaN    > = (current-promise)[fulfilled]
						// (parent-promise)[fulfilled] + (current-promise)<        NaN  | onRejected > = (current-promise)[fulfilled]

						// (parent-promise)[rejected ] + (current-promise)<onfulFulled  |     NaN    > = (current-promise)[rejected ]
						// (parent-promise)[rejected ] + (current-promise)<        NaN  | onRejected*> = (current-promise)[fulfilled]

						// (parent-promise)[    *    ] + (current-promise)<onComplete* throw Error   > = (current-promise)[rejected ]
						// (parent-promise)[    *    ] + (current-promise)<onComplete* return Promise> = (current-promise)[return Promise[*]]

						if(mCompletedState === FULLFILLED_STATE) {
							completeStateFn = deferred.resolve;
							onCompleteFn = deferred.onFulfilled;
						} else {
							onCompleteFn = deferred.onRejected;
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