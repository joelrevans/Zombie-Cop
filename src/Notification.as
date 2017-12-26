package 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import flash.events.MouseEvent;
	/**
	 * ...
	 * @author ...
	 */
	public class Notification extends Sprite
	{
		private var td:uint
		//protected var textField:TextField;
		/*If Timerdelay set to zero, will require an on-click event.*/
		/*Borders set to 10 by default, rounded edges are at 5.*/
		/*Average tween-in time is 350.*/
		public function Notification(text:String, format:TextFormat, maxWidth:uint, timerDelay:uint = 0):void {
			var textField:TextField = new TextField();
			textField.defaultTextFormat = format;
			textField.embedFonts = true;
			textField.selectable = false;
			textField.width = maxWidth;
			textField.wordWrap = true;
			textField.height = 500;
			textField.text = text;
			textField.width = textField.textWidth;
			textField.height = textField.textHeight + 5;
			textField.x = textField.y = 5;
			
			var shp:Shape = new Shape();
			shp.graphics.beginFill(0xFFFFFF, .85);
			shp.graphics.drawRoundRect(0, 0, textField.width + 20, textField.height + 20, 5, 5);
			shp.graphics.endFill();
			
			addChild(shp);
			addChild(textField);
			
			x = -width;
			y = (500 - height)  / 2;
			if(timerDelay){
				SmoothTween.add(this, new Point((500 - width) / 2, (500 - height) / 2), 350, setTimer);
				td = timerDelay;
			}else {
				SmoothTween.add(this, new Point((500 - width) / 2, (500 - height) / 2), 350, function():void {
					addEventListener(MouseEvent.CLICK, setClick);
					var bck:Shape = new Shape();	//here to insure that notification isnt ignored.
					bck.graphics.lineStyle(0, 0, 0);
					bck.graphics.beginFill(0, 0);
					bck.graphics.drawRect(-500, -500, 1000, 1000);
					bck.graphics.endFill();
					addChild(bck);
					} );
			}
		}
		protected function setClick(...args):void {
			removeEventListener(MouseEvent.CLICK, setClick);
			exit();
		}
		private function setTimer():void {
			var t:Timer = new Timer(td, 1);
			t.addEventListener(TimerEvent.TIMER, exit);
			t.start();
			var bck:Shape = new Shape();	//here to insure that notification isnt ignored.
			bck.graphics.lineStyle(0, 0, 0);
			bck.graphics.beginFill(0, 0);
			bck.graphics.drawRect(-500, -500, 500, 500);
			bck.graphics.endFill();
			addChild(bck);
		}
		private function exit(...args):void {
			SmoothTween.add(this, new Point(500, y), 350, rmove);
		}
		private function rmove():void {
			parent.removeChild(this);
		}
	}
	
}