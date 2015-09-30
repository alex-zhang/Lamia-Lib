/**
 * User: alex
 * Date: 15/9/30
 * Time: 10:31
 */
package {
  public class console {
    static public function log(...args):void {
      trace.apply(null, ['[log] '].concat(args))
    }

    static public function error(...args):void {
      trace.apply(null, ['[error] '].concat(args))
    }
  }
}
