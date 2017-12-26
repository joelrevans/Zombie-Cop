package 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Joel Evans
	 */
	public class Clip extends Sprite
	{
		public var loop:Boolean = false;
		private var frameTimer:Timer = new Timer(0);
		private var frames:Array;
		private var current:uint = 0;
		
		/*Creates a new Clip object.
		 * @param rate The rate at which frames play within the clip.
		 * @param frames Adds the following displayObjects to the frame list.  Invalid objects are removed.*/
		public function Clip(rate:uint = 0, ...frameList):void {
			frameTimer.start();
			frames = frameList;
			frameRate = rate;
			if (frames.length == 0) {
				frameTimer.stop();
				return;
			}
			if (frames.length == 1) {
				frameTimer.stop();
			}
			addChild(frames[0]);
		}
		/*Rotates the clip about the provided point.
		 * @param point The point around which to rotate the clip.
		 * @param radians The number of radians to rotate the clip by.*/
		public function rotateAroundPoint(point:Point, radians:Number):void {
			var mag:Number = Point.distance(new Point(x, y), point);
			var dir:Number = Math.atan2(y - point.y, x - point.x) + radians;
			x = point.x + Math.cos(dir) * mag;
			y = point.y + Math.sin(dir) * mag;
			rotation -= radians * 180 / Math.PI;	//It's subtracted since rotation goes clockwise.
		}
		/*Returns The frame corresponding with the provided frame number.
		 * @param index The destination (on the timeline) of the frame to retrieve.*/
		public function getFrame(index:uint):DisplayObject {
			if (index >= totalFrames) {
				return null;
			}
			return frames[index];
		}
		/*Inserts a frame at (before) the specified frame number.  All frames >= frameNumber above are moved to the (n + 1) position.
		 * @param obj DisplayObject to be inserted into the list of frames.
		 * @param frameNumber The location for the new displayObject to be inserted into.
		 * @param others Adds a list additional frames into the clip, if specified.*/
		public function insertFrame(obj:DisplayObject, frameNumber:uint, ...others):void {
			if (frames.length < 2) {
				frameTimer.start();
			}
			others.push(obj);
			for (var a:uint = 0; a < others.length; a++) {
				frames.splice(frameNumber + a, 0, others[a]);	
			}
			if (frames.length - others.length == 0) {
				current = 0;
				addChild(frames[0]);
			}
		}
		/*Removes the specified frame from the clip.
		 * @param frameNumber A number, specifying the location of the frame to be removed from the clip.*/
		public function removeFrame(frameNumber:uint):void {
			frames.splice(frameNumber, 1);
			if (frames.length < 2) {
				frameTimer.stop();
			}
		}
		/*Controls the speed at which the clip plays.  Set to zero to stop the clip.*/
		public function set frameRate(value:int):void {
			if (value > 0) {
				frameTimer.removeEventListener(TimerEvent.TIMER, lastFrame);
				frameTimer.addEventListener(TimerEvent.TIMER, nextFrame);
			}else if(value < 0){
				frameTimer.removeEventListener(TimerEvent.TIMER, nextFrame);
				frameTimer.addEventListener(TimerEvent.TIMER, lastFrame);
			}else{
				frameTimer.removeEventListener(TimerEvent.TIMER, nextFrame);
				frameTimer.removeEventListener(TimerEvent.TIMER, lastFrame);
				return;
			}
			frameTimer.delay = Math.abs(1000 / value);				
		}
		/*Returns number of frames that play per scond.*/
		public function get frameRate():int {
			if (frameTimer.hasEventListener(TimerEvent.TIMER) == false || frameTimer.running == false) {
				return 0;
			}else{
				frameTimer.removeEventListener(TimerEvent.TIMER, nextFrame);
				if (frameTimer.hasEventListener(TimerEvent.TIMER) == false) {
					frameTimer.addEventListener(TimerEvent.TIMER, nextFrame);
					return 1000 / frameTimer.delay;
				}else {
					return -1000 / frameTimer.delay;
				}
			}
		}
		/*Skips to display a different frame within the clip.*/
		public function set currentFrame(value:uint):void {
			removeChild(frames[current]);
			current = value;
			addChild(frames[value]);
		}
		/*Returns the clip's currently displayed frame.*/
		public function get currentFrame():uint {
			return current;
		}
		/*Returns the total number of frames int he clip.*/
		public function get totalFrames():uint {
			return frames.length;
		}
		private function nextFrame(e:TimerEvent):void {
			removeChild(frames[current]);
			if (current >= frames.length - 1) {
				onComplete();
				if (loop == false) {
					addChild(frames[current]);
					frameRate = 0;
					return;
				}
				current = 0;
			}else{
				current++;
			}
			addChild(frames[current]);
		}
		private function lastFrame(e:TimerEvent):void {
			removeChild(frames[current]);
			if (current <= 0) {
				onComplete();
				if (loop == false) {
					addChild(frames[0]);
					current = 0;
					frameRate = 0;
					return;
				}
				current = frames.length - 1;
			}else {
				current--;
			}
			addChild(frames[current]);
		}
		/*This function is called whenever a loop is completed.  It is meant to be set to the value of other functions.*/
		public var onComplete:Function = new Function();
	}
	
}