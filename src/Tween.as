//NO KNOWN ISSUES
//RATED SOLID
package
{
	import flash.display.DisplayObject;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Joel Evans
	 */
	public class Tween
	{
		private static var object:Array = new Array();
		private static var functions:Array = new Array();
		private static var speed:Array = new Array();
		private static var expire:Array = new Array();
		
		private static var hertz:Timer = new Timer(20);
		hertz.addEventListener(TimerEvent.TIMER, motion);
		hertz.start();
		
		/*Begins movement of an object to a desired location.
			 * @param obj The DisplayObject to be moved.
			 * @param destination The destination point for the DisplayObject to be moved to.
			 * @param time The lenght of time, in milliseconds, during which the tranlsation of the DisplayObject will occur.
			 * @param onComplete Function to be called upon completion of the tween.*/
		public static function add(obj:DisplayObject, dest:Point, duration:uint, onComplete:Function = null):void{
			object.push(obj);
			expire.push(Math.ceil(duration / 20));
			speed.push(new Point((dest.x - obj.x) / Math.ceil(duration / 20), (dest.y - obj.y) / Math.ceil(duration / 20)));
			if(onComplete != null){
				functions.push(onComplete);
			}else {
				functions.push(function():void{});
			}
		}
		/*Stops movement of an object that has been added to the tween list.
		 * Returns true if the object was removed from the list, false otherwise.
		 * @param obj The displayObject to be removed.
		 * @param complete If set to true, calls the tweened object's onComplete method.*/
		public static function remove(obj:DisplayObject, complete:Boolean = false):Boolean {
			for (var i:uint = 0; i < object.length; i++){
				if (object[i] == obj) {
					if (complete == true) {
						functions[i]();	
					}
					object.splice(i, 1);
					expire.splice(i, 1);
					speed.splice(i, 1);
					functions.splice(i, 1);
					return true;
				}
			}
			return false;
		}
		private static function motion(e:TimerEvent):void {
			for (var i:uint = 0; i < object.length; i++) {
				object[i].x += speed[i].x;
				object[i].y += speed[i].y;
				if (--expire[i]<=0) {
					object.splice(i, 1);
					expire.splice(i, 1);
					speed.splice(i, 1);
					functions[i]();
					functions.splice(i, 1);
				}
			}
		}
	}
}