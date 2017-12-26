package 
{
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	/**
	 * ...
	 * @author jo
	 */
	public class YesNotification extends Notification 
	{
		/*Creates a Notification object, but takes input from the user.
		 * @param text Text in the notification.
		 * @param format Formats the text, chooses appropriate sizing, color, etc...
		 * @param maxWidth The maximum width of the notification.
		 * @param choose This function is called when the user selects positively.*/
		public function YesNotification(text:String, format:TextFormat, maxWidth:uint, choose:Function):void {
			super(text, format, maxWidth, 0);
			removeEventListener(MouseEvent.CLICK, setClick);
			var shape:Shape = Shape(getChildAt(0));
			var no:TextField = new TextField();
			no.embedFonts = true;
			no.selectable = false;
			no.defaultTextFormat = format;
			no.text = "CLICK HERE TO ACCEPT";
			no.width = no.textWidth + 2;
			no.height = no.textHeight + 2;
			no.x = shape.x + (shape.width - no.width)/2;
			no.y = shape.y + shape.height - 5;
			shape.height += 10 + no.textHeight;
			addChild(no);
			no.addEventListener(MouseEvent.CLICK, function():void { choose(); setClick() } );
		}
	}
	
}