package {
  import com.lamia.Promise;

  import flash.display.Sprite;
  import flash.utils.describeType;
  import flash.utils.getTimer;
  import flash.utils.setTimeout;

  public class Main extends Sprite {
    public function Main() {
      super();

      var p:Promise = new Promise(function(resolve:Function, reject:Function):void {
        reject(3);
      })

//      p.then(function():* {
//        trace('1');
//      });
//
//      return;

      setTimeout(function() {
        p.then(function(value:*):* {
          trace('-----------------', value)
        }
        ).then(null, function(value:*):void {
              trace('--------2---------', value)
        }).then(function(value:*) {
              trace(value);
            }).final(function() {
              trace(arguments)
            });
      }, 1000)

    }
  }
}