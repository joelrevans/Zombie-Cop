package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.ColorTransform;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class Camera extends Bitmap 
	{
		private var hertz:Timer;
		private var source:DisplayObject;
		private var inp:Rectangle;
		
		public static var PRE_RENDER_EVENT : String = "PRE_RENDER";
		public static var POST_RENDER_EVENT : String = "POST_RENDER";
		
		/*Causes the camera to follow a particular DisplayObject.  Stops following if null is supplied.*/
		public var follow:DisplayObject;
		
		//private var smoothing:Boolean;
		/*Creates a new Camera object.
		 * @param output Represents the area where the image will be output to display.
		 * @param inp Represents the area which will be drawn from the source image.
		 * @param source The source object from which to draw a display image.
		 * @param refresh The number of times per second to update the display.*/
		public function Camera(output:Rectangle, input:Rectangle, source:DisplayObject, refresh:uint) {
			super(new BitmapData(output.width, output.height, true, 0));
			x = output.x;
			y = output.y;
			inp = input;
			this.transform.matrix = new Matrix(output.width / inp.width, 0, 0, output.height / inp.height, output.x - inp.x, output.y - inp.y);
			this.source = source;
			hertz = new Timer(1000 / refresh);
			hertz.addEventListener(TimerEvent.TIMER, update);
			hertz.start();
		}
		public function update(...args):void {
			if (follow != null) {
				focus = new Point(follow.x, follow.y);
			}
			dispatchEvent(new Event(PRE_RENDER_EVENT));
			bitmapData.fillRect(bitmapData.rect, 0);
			bitmapData.draw(source, new Matrix(width / inp.width, 0, 0, height / inp.height, x - inp.x, y - inp.y), null, null, new Rectangle(0, 0, inp.width, inp.height), false);
			dispatchEvent(new Event(POST_RENDER_EVENT));
		}
		/*Set's the camera's focal point upon a different location.*/
		public function set focus(value:Point):void {
			inp.x = value.x - inp.width / 2;
			inp.y = value.y - inp.height / 2;
		}
		/*Returns the focal point of the input area.*/
		public function get focus():Point {
			return new Point(inp.x + inp.width / 2, inp.y + inp.height / 2);
		}
	}
	
}