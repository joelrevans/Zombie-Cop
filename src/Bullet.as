package 
{
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Bullet extends Sprite 
	{
		private var components:Point;
		private var terminal:Point;
		private var alphaStep:Number;
		/*Creates a visual bullet object.
		 * @param path The path that the bullet will travel.
		 * @param speed The speed of the bullet, in px/sec.
		 * @param length Length of the bullet in pixels.
		 * @param width Width of the bullet, as a function of line thickness.
		 * @param fade If true, the bullet will fade with distance.*/
		public function Bullet(path:LinearVector, speed:uint, length:uint, width:uint, fade:Boolean):void {
			x = path.anchor.x;
			y = path.anchor.y;
			rotation = path.direction * 180 / Math.PI - 90;
			var v:Timer = new Timer(30, Math.ceil(path.magnitude / speed * 30));
			v.addEventListener(TimerEvent.TIMER, travel);
			v.addEventListener(TimerEvent.TIMER_COMPLETE, finish);
			v.start();
			components = new Point(-Math.sin(270 / 180 * Math.PI + path.direction) * speed / 30, Math.cos(270 / 180 * Math.PI + path.direction) * speed / 30);
			terminal = path.destination;
			if(fade){
				alphaStep = 1 / v.repeatCount;
			}else {
				alphaStep = 0;
			}
			graphics.moveTo(0, 0);
			graphics.lineStyle(width, 0xFFFFFF, 1);
			graphics.lineTo(0, length);
		}
		private function travel(e:TimerEvent):void {
			x += components.x;
			y += components.y;
			alpha -= alphaStep;
		}
		private function finish(e:TimerEvent):void {
			if (parent != null) {
				parent.removeChild(this);
				components = null;
				terminal = null;
			}
		}
	}
	
}