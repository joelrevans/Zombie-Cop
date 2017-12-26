package 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class WaterEffect extends Sprite 
	{
		[Embed(source = '../graphics/environment/water/frame1.png')]private static const water1:Class;
		[Embed(source = '../graphics/environment/water/frame2.png')]private static const water2:Class;
		[Embed(source = '../graphics/environment/water/frame3.png')]private static const water3:Class;
		[Embed(source = '../graphics/environment/water/frame4.png')]private static const water4:Class;
		
		private var frameList:Array;
		private var alphaStep:Number;
		private var cycle:Timer = new Timer(17);
		
		/* Creates a new WaterEffect.
		 * @param frameRate The rate at which each water phase occurs.
		 * @param fadeStep The number of cycles required to fade from one frame to another., At 60hz*/
		public function WaterEffect(fadeStep:uint):void {			
			frameList = [new water1(), new water2(), new water3(), new water4()];
			
			addChild(frameList[2]);
			addChild(frameList[1]);
			addChild(frameList[0]);
			alphaStep = 1 / fadeStep;
			
			cycle.addEventListener(TimerEvent.TIMER, cycler);
			cycle.start();
		}
		private function cycler(e:TimerEvent):void {
			if (frameList[0].alpha <= alphaStep) {
				frameList[0].alpha = 1;			//if transparency is at a minimum, will refresh things.
			}else {
				frameList[0].alpha -= alphaStep;	//Decrements transparency.
				frameList[1].alpha -= alphaStep / 2;
				return;
			}
			frameList[0].alpha = 1;
			removeChild(frameList[0]);
			removeChild(frameList[1]);
			removeChild(frameList[2]);
			frameList.push(frameList.shift());
			addChild(frameList[2]);
			addChild(frameList[1]);
			addChild(frameList[0]);
		}
	}
	
}