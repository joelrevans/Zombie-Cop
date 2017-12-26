package 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	import flash.ui.Mouse;
	/**
	 * ...
	 * @author ...
	 */
	public class Button extends Sprite
	{
		public function Button():void {
			tgt = this;
		}
		/*Defines the tooltip object.*/
		private var ttp:DisplayObject = null;
		/*A DisplayObject which defines the appearance of the tooltip.*/
		public function set toolTip(value:DisplayObject):void {
			if (value != null) {
				if (toolTip == null) {
					ttp = value;
					target.addEventListener(MouseEvent.ROLL_OVER, activateToolTip);
				}else {
					if (toolTip.parent == this) {	//Simply used to track whether the tooltip is activated or not.
						/*Like deactivateToolTip, but doesn't re-add an event listener.*/
						target.removeEventListener(MouseEvent.ROLL_OUT, deactivateToolTip);
						target.removeEventListener(MouseEvent.MOUSE_MOVE, mouseTip);
						removeChild(toolTip);
						/*end*/
						ttp = value;
						activateToolTip();
					}else{
						ttp = value;
					}
				}
			}else {
				if (toolTip != null) {
					if (target.hitTestPoint(target.parent.mouseX, target.parent.mouseY, true)) {
						deactivateToolTip();
					}
					target.removeEventListener(MouseEvent.ROLL_OVER, activateToolTip);
					ttp = null;
				}
			}
		}
		public function get toolTip():DisplayObject {
			return ttp;
		}
		private function activateToolTip(...args):void {
			target.addEventListener(MouseEvent.MOUSE_MOVE, mouseTip);
			target.addEventListener(MouseEvent.ROLL_OUT, deactivateToolTip);
			target.removeEventListener(MouseEvent.ROLL_OVER, activateToolTip);
			addChild(toolTip);
			mouseTip();	//If left out, there can be some flickering and temporary disposition of the image, before it moves to its correct location.
		}
		private function deactivateToolTip(...args):void {
			target.addEventListener(MouseEvent.ROLL_OVER, activateToolTip);
			target.removeEventListener(MouseEvent.ROLL_OUT, deactivateToolTip);
			target.removeEventListener(MouseEvent.MOUSE_MOVE, mouseTip);
			if (toolTip.parent == this) {
				removeChild(toolTip);
			}
		}
		private function mouseTip(...args):void {
			toolTip.x = mouseX;
			toolTip.y = mouseY;
		}
		/*Defines the target area (hitArea) of the button.*/
		private var tgt:DisplayObject;
		/*The target represents the area over which the button is active.*/
		public function set target(value:DisplayObject):void {
			if (release != null) {
				target.removeEventListener(MouseEvent.MOUSE_UP, callRelease);
				value.addEventListener(MouseEvent.MOUSE_UP, callRelease);
			}
			if (press != null) {
				target.removeEventListener(MouseEvent.MOUSE_DOWN, callPress);
				value.addEventListener(MouseEvent.MOUSE_DOWN, callPress);
			}
			if (rollOver != null) {
				target.removeEventListener(MouseEvent.ROLL_OVER, callRollOver);
				value.addEventListener(MouseEvent.ROLL_OVER, callRollOver);
			}
			if (rollOut != null) {
				target.removeEventListener(MouseEvent.ROLL_OUT, callRollOut);
				value.addEventListener(MouseEvent.ROLL_OUT, callRollOut);
			}
			if (toolTip != null) {
				if (target.hitTestPoint(target.parent.mouseX, target.parent.mouseY, true)) {
					target.removeEventListener(MouseEvent.ROLL_OUT, deactivateToolTip);
					target.removeEventListener(MouseEvent.MOUSE_MOVE, mouseTip);
					value.addEventListener(MouseEvent.ROLL_OUT, deactivateToolTip);
					value.addEventListener(MouseEvent.MOUSE_MOVE, mouseTip);
				}else {
					target.removeEventListener(MouseEvent.ROLL_OVER, activateToolTip);
					value.addEventListener(MouseEvent.ROLL_OVER, activateToolTip);
				}
			}
			tgt = value;
		}
		public function get target():DisplayObject {
			return tgt;
		}
		//ONPRESS
		private var onPress:Function = null;
		/*This function is called when the mouse is pressed over the button.  Functions must not require parameters.*/
		public function set press(value:Function):void {
			if (value != null) {
				if (onPress == null) {
					target.addEventListener(MouseEvent.MOUSE_DOWN, callPress);
				}
				onPress = value;
			}else {
				if (press != null) {
					target.removeEventListener(MouseEvent.MOUSE_DOWN, callPress);
					press = null;
				}
			}
		}
		public function get press():Function {
			return onPress;
		}
		/*Calls the onPress function because it cant necessarily handle the extra MouseEvent argument.*/
		private function callPress(e:MouseEvent):void {
			onPress();
		}
		/*ON RELEASE*/
		private var onRelease:Function = null;	//stores the function value;
		/*This function is called when the mouse is released over the button.  Functions must not require parameters.*/
		public function set release(value:Function):void {
			if (value != null) {
				if (onRelease == null) {
					target.addEventListener(MouseEvent.MOUSE_UP, callRelease);
				}
				onRelease = value;
			}else {
				if (onRelease != null) {
					target.removeEventListener(MouseEvent.MOUSE_UP, callRelease);
					onRelease = null;
				}
			}
		}
		public function get release():Function {
			return onRelease;
		}
		/*Calls the onRelease function because it cant necessarily handle the extra MouseEvent argument.*/
		private function callRelease(e:MouseEvent):void {
			onRelease();
		}
		/*ON ROLLOVER*/
		private var onRollOver:Function = null;
		/*This function is called when the mouse rolls over the button.  Functions must not require parameters.*/
		public function set rollOver(value:Function):void {
			if (value != null) {
				if (onRollOver == null) {
					target.addEventListener(MouseEvent.ROLL_OVER, callRollOver);
				}
				onRollOver = value;
			}else {
				if (onRollOver != null) {
					target.removeEventListener(MouseEvent.ROLL_OVER, callRollOver);
					onRollOver = null;
				}
			}
		}
		public function get rollOver():Function {
			return onRollOver;
		}
		/*Calls the onRollOver function because it cant necessarily handle the extra MouseEvent argument.*/
		private function callRollOver(e:MouseEvent):void {
			rollOver();
		}
		/*ON ROLLOUT*/
		private var onRollOut:Function = null;
		/*This function is called when the mouse rolls out of the button.  Functions must not require parameters.*/
		public function set rollOut(value:Function):void {
			if (value != null) {
				if (onRollOut == null) {
					target.addEventListener(MouseEvent.ROLL_OUT, callRollOut);
				}
				onRollOut = value;
			}else {
				if (onRollOut != null) {
					target.removeEventListener(MouseEvent.ROLL_OUT, callRollOut);
					onRollOut = null;
				}
			}
		}
		public function get rollOut():Function {
			return onRollOut;
		}
		/*Calls the onRollOut function because it cant necessarily handle the extra MouseEvent argument.*/
		private function callRollOut(e:MouseEvent):void {
			onRollOut();
		}
	}
}