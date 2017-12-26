/*Bug--The TIMER_COMPLETE is called before TIMER, so the onComplete function is called just before the final frame is displayed.  If you have a loop, this is problematic.*/

package 
{
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class Clip extends Sprite 
	{
		private var frames:Array;
		private var current:uint = 0;
		private var frameTimer:Timer = new Timer(10, 1);	//repeat count will be recalculated, but it must not be set to zero or 1, or loop will equal true.
		private var complete:Function;
		
		public function Clip(framesPerSecond:int = 0, initFrames:Array = null):void {
			frameTimer.addEventListener(TimerEvent.TIMER, callTick);
			frames = initFrames == null ? new Array(): initFrames;	//frames is an array typed DisplayObject
			if (frames.length) {
				addChild(frames[0]);
				insertFrame = insertFramePrimary;
			}else {
				insertFrame = insertFrameInit;
			}
			frameRate = framesPerSecond;
		}
		
		
		/*Inserts a frame at the specified index location, moving the frame at the index and all elevated indicies upward.*/
		public var insertFrame:Function;
		/*The initial insertion function.  Adds a frame to the stage if none have been added previously.*/
		private function insertFrameInit(obj:DisplayObject, index:uint):void {
			frames.splice(index, 0, obj);
			addChild(obj);
			insertFrame = insertFramePrimary;
		}
		
		
		/*The primary insertion function.  Does not add frames to the stage, because the stage is already occupied if frames.length > 0*/
		private function insertFramePrimary(obj:DisplayObject, index:uint):void {
			frames.splice(index, 0, obj);
			loop = loop; //Forces frametimer recaclulation.
		}
		
		
		/*Removes a frame from the clip.*/
		public function removeFrame(index:uint):void {
			frames.splice(index, 1);
			if (frames.length < 2) {
				frameRate = 0;
				loop = false;
				if (frames.length==0) {
					insertFrame = insertFrameInit;
					removeChildAt(0);
				}
			}else {
				loop = loop; //Forces frametimer recaclulation.
			}
		}
		
		
		public function getFrame(index:uint):DisplayObject {
			return frames[index];
		}
		
		
		/*Moves directly to display the specified frame number.*/
		public function set currentFrame(value:uint):void {
			gotoframe = value;
			loop = loop; //Forces frametimer recaclulation.
		}
		
		
		public function get currentFrame():uint {
			return current;
		}
		
		
		/*If true, the clip will restart when it reaches its final frame, running indefinitely.*/
		public function set loop(value:Boolean):void {
			if (value) {
				frameTimer.repeatCount = 0;
			}else if (frameRate) {	//framerate must not be zero. if framerate is zero and current == 0, it will recalculate the loop, even though a loop was not specified. 
				/*designed to recalculate the loop counter when the framerate changes, because it is actively dependent on loop, framerate, currentframe, and frames.length properties*/
				frameTimer.repeatCount = frameTimer.currentCount + (frameRate > 0 ? frames.length - 1 - current : current);	//timer will end at last frame and stop.  Default conditional is frameRate > 0 (as oppose to frameRate >=0) because its result is more intense.
			}
		}
		
		
		public function get loop():Boolean {
			return frameTimer.repeatCount == 0;
		}
		
		
		/*The number of clip frames that display every second.*/
		public function set frameRate(value:int):void {
			if (value && frames.length > 1) {
				frameTimer.delay = Math.abs(1000 / value);
				frameTick = value > 0 ? plus : minus;
				frameTimer.start();
				loop = loop; //Forces frametimer recaclulation.
			}else {
				frameTimer.stop();
			}
		}
		
		
		public function get frameRate():int {
			return frameTimer.running ? (Math.round(1000 / frameTimer.delay) * (frameTick == plus ? 1:-1)) : 0;	//nested ternary
		}
		
		
		/*Returns the total number of frames in the clip.*/
		public function get totalFrames():uint {
			return frames.length;
		}
		
		
		/*Function called upon completion of a clip, if the loop property is false.*/
		public function set onComplete(value:Function):void {
			if (value != null) {
				complete = value;
				frameTimer.addEventListener(TimerEvent.TIMER_COMPLETE, callComplete);
			}else {
				frameTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, callComplete);
			}
		}
		
		
		public function get onComplete():Function {
			return complete;
		}
		
		
		private function callComplete(e:TimerEvent):void {complete()}	//calls oncomplete, takes the args
		/*Called during every frame change.  Supposed to be overriden.*/
		private function callTick(e:TimerEvent):void {frameTick()}
		private var frameTick:Function = new Function();
		private function plus():void { gotoframe = (current+1)%frames.length};
		private function minus():void { gotoframe = (current - 1 + frames.length) % frames.length; };
		/*Used to replace currentFrame, because when used privately, loop = loop should not be called.*/
		private function set gotoframe(value:uint):void {
			removeChildAt(0);
			addChild(frames[value]);
			current = value;
		}
	}
	
}