package 
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class DeferredVariable
	{
		private var obj:Object;
		private var tgt:Object;
		/*Redefines a provided variable after a specified period of time.
		 * @param value The new value to apply to the variable.
		 * @param target The variable to be overwritten.
		 * @param time The time, in millseconds, to wait before applying the new value to the variable.
		 * @param snapShot Determines whether the value parameter is copied as soon as the DeferredVariable Object is created, or if changes are allowed until the time expires.*/
		public function DeferredVariable(value:Object, target:Object, time:uint):void {
			obj = value;
			tgt = target;
			var t:Timer = new Timer(time, 1);
			t.addEventListener(TimerEvent.TIMER, caller);
			t.start();
		}
		private function caller(e:TimerEvent):void {
			tgt = obj;
		}
	}
	
}