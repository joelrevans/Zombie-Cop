package 
{
	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author jo
	 */
	public class Shake 
	{
		/*The target objec to be shaken.*/
		public var target : DisplayObject;
		
		private var timer : Timer;
		private var mags : uint;
		private var tape : Number;
		
		private var anchor : Point;
		private var relAnchor : Point;
		private var complete : Function;
		
		public function Shake():void {
			timer = new Timer(17);
			timer.addEventListener(TimerEvent.TIMER, shaker);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, callsComplete);
			complete = new Function();
		}
		/*Starts the shaking.
		 * @param magnitude The magnitude of distance, in pixels, across which the object may be shaken.
		 * @param taper The magnitude will be multiplied by this number at 60 hertz.
		 * @param duration The time over which the shaking occurs, in milliseconds.*/
		public function start(magnitude : uint, taper : Number, duration : uint):void {
			if (running){
				target.x = anchor.x;
				target.y = anchor.y;
			}
			timer.reset();
			timer.repeatCount = duration / 60;
			timer.start();
			mags = magnitude;
			tape = taper;
			anchor = new Point(target.x, target.y);
			relAnchor = new Point();
		}
		/*Stops the shaking.*/
		public function stop():void {
			target.x = anchor.x;
			target.y = anchor.y;
			timer.stop();
			tape = 0;
			mags = 0;
		}
		public function get taper() : Number {
			return tape;
		}
		public function get magnitude() : Number {
			return mags;
		}
		public function get running() : Boolean {
			return timer.running;
		}
		public function set onComplete(value : Function) : void {
			if (value == null) {
				complete = new Function();
			}else {
				complete = value;
			}
		}
		private function callsComplete(e : TimerEvent) : void {
			target.x = anchor.x;
			target.y = anchor.y;
			complete();
		}
		private function shaker(e:TimerEvent):void {
			/*Using relAnchor allows the object to be repositioned while being shaken.*/
			anchor.x = target.x - relAnchor.x;
			anchor.y = target.y - relAnchor.y;
			
			mags *= tape;
			
			var theta : Number = Math.random() * Math.PI;
			var dist : Number = Math.random() * mags;
			
			relAnchor.x = Math.cos(theta) * dist;
			relAnchor.y = Math.sin(theta) * dist;
			
			target.x = anchor.x + relAnchor.x;
			target.y = anchor.y + relAnchor.y;
		}
	}
	
}