//INSECURITIES
//If the user changes the bitmapdtata during execution, it could cause a crash.

package
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	
	/**
	 * ...
	 * @author Joel Evans
	 */
	public class DiffusionMap extends Bitmap 
	{
		
		private var data:BitmapData;  //Holds the original data.
		private var expire:uint;  //The number of cycles before removal.
		private var expandX:Number;  //The rate at which the particles move out.
		private var expandY:Number;
		private var dPose:Boolean; //Decides the decomposition of the object.
		
		private var hertz:Timer = new Timer(20);
		
		/*@param bitmap The object image to be diffused.*/
		public function DiffusionMap(disp:IBitmapDrawable):void {
			if (disp is BitmapData) {
				data = BitmapData(disp);
			}else{
				rotation = DisplayObject(disp).rotation;
				if(disp is Bitmap){
					data = Bitmap(disp).bitmapData;
				}else {
					data = new BitmapData(DisplayObject(disp).width, DisplayObject(disp).height, true, 0);
					data.draw(disp,  new Matrix(1, 0, 0, 1, DisplayObject(disp).width / 2, DisplayObject(disp).height / 2));
				}
				x = DisplayObject(disp).x + DisplayObject(disp).width / 2;
				y = DisplayObject(disp).y + DisplayObject(disp).height / 2;
				data = data.clone();
				bitmapData = data;
				
			}
		}
		
		/*Begins the diffusion process
		 * @param expire The number of 20ms cycles to execute before terminating the map.  
		 * If set to zero, expansion will continue forever, until the reset or freeze methods are called.
		 * @param expansionX The rate at which the horizontal boundaries expand from the focus.
		 * @param expansionY The rate at which the vertial boundaries expand from the focus.
		 * @param fade If this value is set to true, the image will fade as it approaches expiration.
		 * @param Eilminates the object from memory completely after it expires.  The object cannot be reset if this is called.*/
		public function start(expire:uint, expansionX:Number, expansionY:Number, fade:Boolean, dispose:Boolean = false):void {
			
			/*Safety for expansion*/
			expandX = Math.abs(expansionX); 
			expandY = Math.abs(expansionY);
			/*End Safety*/
			
			/*Safety for expire*/
			this.expire = expire;
			/*End Safety*/
			
			/*Set the bitmapdata*/
			bitmapData = new BitmapData(data.width + expandX * expire, data.height + expandY * expire, true, 0);
			x += expandX * expire / 2;
			y += expandY * expire / 2;
			
			/*Safety for hertz*/
			hertz.repeatCount = expire;
			hertz.addEventListener(TimerEvent.TIMER_COMPLETE, clean);
			hertz.addEventListener(TimerEvent.TIMER, motion);
			if (fade == true) {
				hertz.addEventListener(TimerEvent.TIMER, fader);
			}else {
				hertz.removeEventListener(TimerEvent.TIMER, fader);
			}
			hertz.start();
			/*End Safety*/
			
			dPose = dispose;
		}
		/*Freezes the fountain.  The resume() function unfreezes.*/
		public function freeze():void {
			hertz.stop();
		}
		/*Unfreezes the function if it is frozen.*/
		public function resume():void {
			hertz.start();
		}
		/*Resets the DiffusionMap to its original form.*/
		public function reset():void {
			bitmapData = data;
			hertz.stop();
			alpha = 1;
		}
		
		/*Private functions.  Do not Disturb.*/
		private function fader(e:TimerEvent):void {
			alpha -= 1 / expire;
		}
		private function motion(e:TimerEvent):void {
			bitmapData.fillRect(bitmapData.rect, 0);
			var ex:Number = expandX * hertz.currentCount + data.width;
			var ey:Number = expandY * hertz.currentCount + data.height;
			for (var ix:uint = 0; ix < data.width; ix++) {
				for (var iy:uint = 0; iy < data.height; iy++) {
					var dx:Number = (ex / data.width * ix) + (expire * expandX + data.width - ex) / 2;
					var dy:Number = (ey / data.height * iy) + (expire * expandY + data.height - ex) / 2;
					bitmapData.setPixel32(dx, dy, data.getPixel32(ix, iy));
				}
			}
		}
		/*Cleans up timers, and if dPose is true, garbageCollects.*/
		private function clean(e:TimerEvent):void {
			hertz.removeEventListener(TimerEvent.TIMER, fader);
			hertz.removeEventListener(TimerEvent.TIMER, motion);
			hertz.removeEventListener(TimerEvent.TIMER_COMPLETE, clean);
			hertz.reset();
			if (dPose == true) {
				data.dispose();
				bitmapData.dispose();
				for (var i:String in this) {
					this[i] = null;
				}
			}
		}
	}
}