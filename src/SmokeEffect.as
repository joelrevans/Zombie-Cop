package 
{
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class SmokeEffect extends Clip
	{
		[Embed(source = '../graphics/smokeEffect/frame1.png')]private static const frame1:Class;
		[Embed(source = '../graphics/smokeEffect/frame3.png')]private static const frame3:Class;
		[Embed(source = '../graphics/smokeEffect/frame5.png')]private static const frame5:Class;
		[Embed(source = '../graphics/smokeEffect/frame7.png')]private static const frame7:Class;
		[Embed(source = '../graphics/smokeEffect/frame9.png')]private static const frame9:Class;
		[Embed(source = '../graphics/smokeEffect/frame11.png')]private static const frame11:Class;
		[Embed(source = '../graphics/smokeEffect/frame13.png')]private static const frame13:Class;
		[Embed(source = '../graphics/smokeEffect/frame15.png')]private static const frame15:Class;
		//private var duration:uint;
		private var t:Timer;
		/*Creates a new SmokeEffect object.
		 * @param fadeDuration The amount of time it takes the effect to fade out after completion.
		 * @param rate The framerate at which the clip will play.*/
		public function SmokeEffect(fadeDuration:uint = 10000, rate:Number = 18):void {
			super(rate, [new frame1(), new frame3(), new frame5(), new frame7(), new frame9(),new frame11(), new frame13(), new frame15()]); 
			for (var i:uint = 0; i < totalFrames; i++) {
				getFrame(i).x = -getFrame(i).width / 2;
				getFrame(i).y = -getFrame(i).height / 2;
			}
			//loop = false;
			//duration = fadeDuration;
			/*
			if (fadeDuration == 0) {
				cleanUp();
				return;
			}*/
			t = new Timer(100, Math.ceil(fadeDuration / 100));
			t.addEventListener(TimerEvent.TIMER, fadeOut);
			t.addEventListener(TimerEvent.TIMER_COMPLETE, cleanUp);
			t.start();
		}
		private function fadeOut(e:TimerEvent):void {
			alpha = 1 - t.currentCount / t.repeatCount;
		}
		private function cleanUp(e:TimerEvent):void {
			t.removeEventListener(TimerEvent.TIMER_COMPLETE, cleanUp);
			t.removeEventListener(TimerEvent.TIMER, fadeOut);
			t = null;
			if (parent != null) {
				parent.removeChild(this);
			}
		}
	}
	
}