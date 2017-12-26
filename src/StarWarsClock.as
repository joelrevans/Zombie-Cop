package 
{
	import flash.display.Sprite;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class StarWarsClock extends Sprite 
	{
		private var maxwidth:Number;
		private var currentNum:uint;
		private var textField:TextField;
		private var time:Timer;
		private var complete:Function;
		public function StarWarsClock(format:TextFormat, maxwidth:uint, topNum:uint, onComplete:Function = null):void {
			complete = onComplete;
			
			this.maxwidth = maxwidth;
			currentNum = topNum;
			
			textField = new TextField();
			textField.defaultTextFormat = format;
			textField.selectable = false;
			textField.embedFonts = true;
			addChild(textField);
			setNewTimer();
		}
		private function setNewTimer(...args):void {
			if (currentNum == 0) { 
				if (complete != null) {
					complete();
				}
				if (parent != null) {
					parent.removeChild(this);
				}
				return; 
			}
			textField.text = String(currentNum--);
			time = new Timer(34, 29);
			time.addEventListener(TimerEvent.TIMER_COMPLETE, setNewTimer);
			time.addEventListener(TimerEvent.TIMER, update);
			time.start();
		}
		private function update(e:TimerEvent):void {
			width = maxwidth * (time.repeatCount - time.currentCount) / time.repeatCount;
			scaleY = scaleX;
			//textField.x = textField.width / -2;
			//textField.y = textField.height / -2;
		}
		
	}
	
}