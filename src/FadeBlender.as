package 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class FadeBlender extends Sprite
	{
		protected var images:Array;	//Holds a list of images to be blended
		protected var ages:Array = new Array();	//Holds the ages of all the active images
		
		protected var T:Number;		//The total time it takes an image to fade in and out.
		
		protected var maxTransparency:Number;	//The maximum transparency to fade up to.
		
		protected var hertz:Timer = new Timer(17);	//The timer which gradually adjusts transparency.		
		protected var adder:Timer;		//Adds new images to the stage.
		
		/*Creates a new FadeBlender object.
		 * @param images A list of DisplayObjects to be faded together, starting with the zero index on top.
		 * @param maxTransparency The highest transparency that images fade up to.  This will increase the opacity of certain frames.
		 * @param activeFrames The number of active frames on the stage at any one time.  Zero includes all frames.  Numbers that exceed the boundaries also include all frames.
		 * @param fadeSpeed The number of cycles which are needed to fully fade an image in and out, in milliseconds*/
		public function FadeBlender(images:Array, maxTransparency:Number, activeFrames:uint, fadeSpeed:Number):void {
			this.images = images;
			this.maxTransparency = maxTransparency;
			activeFrames = (activeFrames == 0 || activeFrames > images.length) ? images.length : activeFrames;
			//working variables used in the fade process
			T = fadeSpeed;
			//Timer which adds new images.
			adder = new Timer(fadeSpeed / activeFrames);
			adder.addEventListener(TimerEvent.TIMER, add);
			adder.start();
			//fade timer
			hertz.addEventListener(TimerEvent.TIMER, fader);
			hertz.start();
		}
		protected function add(e:TimerEvent):void {
			var image:DisplayObject = images.pop();
			image.alpha = 0;
			if (image.parent != null) {
				image.parent.removeChild(image);
				ages.pop();
			}
			addChild(image);
			ages.unshift(getTimer());
			images.unshift(image);
		}
		protected function fader(e:TimerEvent):void {
			var time:Number;
			for (var i:uint = 0; i < ages.length; i++) {
				time = getTimer() - ages[i];
				if (time >= T) {	//removal
					images[i].parent.removeChild(images[i]);
					ages.pop();
					return;
				}
				images[i].alpha = (.25 - Math.pow((time - T / 2) / T, 2)) * 4 * maxTransparency;
			}
		}
	}
}