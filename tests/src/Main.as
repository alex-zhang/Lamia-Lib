package {
  import com.lamia.Promise;

  import flash.display.Sprite;
  import flash.utils.describeType;
  import flash.utils.getTimer;
  import flash.utils.setTimeout;

  public class Main extends Sprite {
    public function Main() {
      super();

//Basic
//      basicUse();
//      basicUseWidthError();

//Then
//        useThenBasic();
//        useThenReturnValue();
//        useThenWithError();


//catch
//        useCatchBasic();

//final
//        usefinalBasic();

//Resolve
//      useResolveBasic();
//      resolveArray();
//      resolvePromise();
//      resolveThenable();
//      resolveThenableAndTrowError1();
//      resolveThenableAndTrowError2();


//Reject
//        useRejectBasic();


//All
//      useAllBasic();
//      useAllBasicWithError();


//Race
//        useRaceBasic();

//Qqueue
        useQueueBasic();
        useQueueWithError();
    }




//Basic
//======================================================================================================================
    function basicUse() {
      var p = new Promise(function(resolve, rejecr) {
        resolve(3);
      })

      p.then(function(value) {
        console.log(value);
      })
    }

    function basicUseWidthError() {
      var p = new Promise(function (resolve, rejecr) {
        throw new Error('Error')
        resolve(3);
      })
      .then(
        function () {
          console.log('============== ')
        },
        function (value) {
          console.log('---------- ', value)
        }
      )
    }

//Then
//======================================================================================================================

    function useThenBasic() {
      new Promise(function(resolve, rejecr) {
        resolve();
      })
      .then(function() {
        console.log('Step1');
      })
      .then(function(value) {
        console.log('Step2');
      })
    }

    function useThenReturnValue() {
      new Promise(function(resolve, rejecr) {
        resolve(3);
      })
      .then(function(value) {
        console.log('Step1', value);
         return value + 2;
       })
      .then(function(value) {
        console.log('Step2', value);
        return new Promise(function(resolve, reject) {
          resolve(value + ' - ');
        })
      })
      .then(function(value) {
          console.log('Step3', value);
       })
    }

    function useThenWithError() {
      new Promise(function(resolve, reject) {
        reject(3);
      })
      .then(
        function(value) {
          console.log('step 1 success ', value);
        },
        function(error) {
          console.log('step 1 error ', error);
        }
      )
      .then(function(value) {
        throw new Error('--------------------');
        console.log('step 2 success', value)
      })
      .then(
        function(value) {
          console.log('step 3 success', value)
        },
        function(error) {
          console.log('step 3 error', error)
        }
      )
    }

//catch
//======================================================================================================================

    function useCatchBasic() {
      new Promise(function(resolve, reject) {
        reject(3);
      })
      .caught(function(error) {
        console.log('------------------', error)
      })
    }


//final
//======================================================================================================================
    function usefinalBasic() {
      new Promise(function(resolve, reject) {
        reject(3);
      })
      .final(function(error) {
        console.log('------------------', error)
      })
    }

    function asyncExcuteExample() {
      new Promise(function(resolve, reject) {
        trace(1);
        reject(3);
        trace(2);
      })
      .then(function() {
        trace(3);
      })
    }

    function laterCallSetteldPromise() {
      var p = new Promise(function(resolve) {
        trace(1);
        resolve(3);
        trace(2);
      })
      .then(function() {
      });
//      trace(3);
    }

    //==================================================================================================================
    //Promise.resolve
    //使用静态方法Promise.resolve
    function useResolveBasic() {
      Promise.resolve("Success")
      .then(
        function(value) {
          console.log(value); // "Success"
        },
        function(value) {
          // not called
        }
      );
    }

    //以一个数组进行resolve
    function resolveArray() {
      var p = Promise.resolve([1,2,3]);
      p.then(function(v) {
        console.log(v[0]); // 1
      });
    }

    //resolve另一个Promise对象
    function resolvePromise() {
      var original = Promise.resolve(true);
      var cast = Promise.resolve(original);
      cast.then(function(v) {
        console.log(v); // true
      });
    }

    function resolveThenable() {
      var p:Promise = Promise.resolve({
        then:function (a, b) {
          a(3);
        }
      })

      p.then(function(value) {
        console.log(value)
      })
    }

    //resolve thenable的对象们并抛出错误
    function resolveThenableAndTrowError1() {
      var thenable = { then: function(resolve) {
          resolve("Resolving");
          throw new TypeError("Throwing");
      }};

      var p3 = Promise.resolve(thenable);
      p3.then(function(v) {
        console.log(v); // "Resolving"
      }, function(e) {
        // 不会被调用
      });
    }

    function resolveThenableAndTrowError2() {
      var thenable = { then: function(resolve) {
        throw new TypeError("Throwing");
        resolve("Resolving");
      }};

      var p3 = Promise.resolve(thenable);
      p3.then(function(v) {
        // 不会被调用
      }, function(e) {
        console.log(e);
      });
    }

//Reject
//======================================================================================================================
    function useRejectBasic() {
      Promise.reject(3).caught(function(error) {
        console.log(error)
      })
    }


    function useAllBasic() {
      Promise.all([
              'hello',
              Promise.resolve(3),

              {then: function(resolve) {
                resolve('中国');
              }},

              new Promise(function(resolve, reject) {
                setTimeout(function() {
                  console.log('settimeout')
                  resolve(10);
                } , 3000)
              })
      ])
      .final(function(value) {
        console.log('=============================', value);
      })
    }


    function useAllBasicWithError() {
      Promise.all([
        'hello',

        {then: function(resolve, reject) {
          setTimeout(function() {
            reject('中国');
          }, 3000);
        }},
      ])
      .final(function(value) {
        console.log('=============================', value);
      })
    }

//Race
//======================================================================================================================
    function useRaceBasic() {
      Promise.race([
        new Promise(function(resovle) {
          setTimeout(function() {
            resovle('step 1');
          }, 3000)
        }),

        new Promise(function(resovle) {
          setTimeout(function() {
            resovle('step 2');
          }, 2000)
        }),
      ])
      .final(function(value) {
        console.log('=============================', value);
      })
    }


//Queue
//======================================================================================================================
    function useQueueBasic() {
      Promise.queue([
        'hello',

        new Promise(function(resolve) {
          setTimeout(function() {
            console.log('step1 ')
            resolve(3);
          }, 3000);
        }),

        new Promise(function(resolve) {
          setTimeout(function() {
            console.log('step5 ')
            resolve(5);
          }, 1000);
        }),

        new Promise(function(resolve) {
          console.log('step3 ')
          resolve(6);
        }),
      ])
      .final(function(value) {
        console.log('===========================', value);
      })
    }



    function useQueueWithError() {
      Promise.queue([
        "hello",

        new Promise(function(resolve) {
          setTimeout(function() {
            console.log('step2 ')
            resolve(5);
          }, 1000);
        }),
      ])
      .final(function(value) {
        console.log('===========================', value);
      })
    }
  }
}