package
{
	import com.lamia.Promise;

	import flash.display.Sprite;

	public class Main extends Sprite
	{
		public function Main()
		{
			super();

			init();
		}

		private function init():void
		{
			trace('================================');

			function add2(value:int):int
			{
				return value + 2;
			}

			function add5(value:int):int
			{
				return value + 5;
			}

			Promise.resolve(3)
				.then(add2).then(add5).then(function(value:*):void {
						trace(value);
					}).then(function(value2:*):void {
						trace(value2);
						throw new Error('1')
					}).then(function(v3:*) {
						trace('0000');
					}, function(error:*) {
						trace(3);
					}).then(function(v3:*) {
						trace('0000');
					}, function(error:*) {
						trace(3);
					})
		}
	}
}