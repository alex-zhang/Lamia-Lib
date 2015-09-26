package {
  import com.lamia.Promise;

  import flash.display.Sprite;
  import flash.utils.describeType;
  import flash.utils.getTimer;

  public class Main extends Sprite {
    public function Main() {
      super();

      var testMethods:Array = [];
      for each ( var m:XML in describeType(this)..method) {
        var methodName:String = m.@name;
        if(methodName.indexOf('test_') === 0) {
          testMethods.push([methodName, this[methodName]]);
        }
      }

      trace('---------------------------------');
      trace('start: ');
      var at:int = getTimer();
      Promise.queue(testMethods.map(function(...args) {
//        trace(fn.name);
        var fnName:String = args[0][0];
        var fn:Function = args[0][1];
        trace('------- ' + fnName + ' start ');
        var t:int = getTimer();
        return fn().final(function() {
          trace('------- ' + fnName + ' end  time: ' + (getTimer() - t) * 0.001 + ' s');
        });
      }))
      .final(function():void {
          trace('End ! time: ' + (getTimer() - at) * 0.001 + ' s');
        })
    }


    //----------------------------------------------------------------

    public function test_Promise_constractor_resolve():Promise {
      return new Promise(function(resolve:Function, reject:Function):void {
        resolve("hello");
      });
    }

    public function test_Promise_constractor_reject():Promise {
      return new Promise(function(resolve:Function, reject:Function):void {
        reject("test");
      });
    }

  }
}