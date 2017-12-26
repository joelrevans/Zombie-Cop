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
	public class SmoothTween
	{
		private static var object:Array = new Array();
		private static var origin:Array = new Array();
		private static var k:Array = new Array();
		private static var t:Array = new Array();
		private static var t0:Array = new Array();
		private static var trig:Array = new Array();
		private static var functions:Array = new Array();
		
		private static var hertz:Timer = new Timer(20);
		hertz.addEventListener(TimerEvent.TIMER, motion);
		hertz.start();
		
		/*Begins movement of an object to a desired location.
			 * @param obj The DisplayObject to be moved.
			 * @param destination The destination point for the DisplayObject to be moved to.
			 * @param time The lenght of time, in milliseconds, during which the tranlsation of the DisplayObject will occur.
			 * @param onComplete Function to be called upon completion of the tween.*/
		public static function add(obj:DisplayObject, dest:Point, duration:uint, onComplete:Function = null):void {
			if (obj.x == dest.x && obj.y == dest.y) {
				return;
			}
			object.push(obj);
			var time:Number = duration / 1000;
			var dt:Number = Math.sqrt(Math.pow(dest.x - obj.x, 2) + Math.pow(dest.y - obj.y, 2));
			///var d2:Number = -time * time * time / 3 + time * time * time / 2;
			var d2 : Number = Math.pow(time, 3) / 6;
			k.push(dt / d2);
			t.push(0);
			t0.push(time);
			origin.push(new Point(obj.x, obj.y));
			trig.push(new Point((dest.x - obj.x) / dt, (dest.y - obj.y) / dt));
			if(onComplete != null){
				functions.push(onComplete);
			}else {
				functions.push(function():void{ });
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
					origin.splice(i, 1);
					k.splice(i, 1);
					t.splice(i, 1);
					t0.splice(i, 1);
					trig.splice(i, 1);
					functions.splice(i, 1);
					return true;
				}
			}
			return false;
		}
		private static function motion(e:TimerEvent):void {
			for (var i:uint = 0; i < object.length; i++) {
				t[i] += .02;
				object[i].x = trig[i].x * (-Math.pow(t[i], 3) / 3 + Math.pow(t[i], 2) / 2 * t0[i]) * k[i] + origin[i].x;
				object[i].y = trig[i].y * (-Math.pow(t[i], 3) / 3 + Math.pow(t[i], 2) / 2 * t0[i]) * k[i] + origin[i].y; 
				if (t[i] >= t0[i]) {
					functions[i]();
					object.splice(i, 1);
					origin.splice(i, 1);
					k.splice(i, 1);
					t.splice(i, 1);
					t0.splice(i, 1);
					trig.splice(i, 1);
					functions.splice(i, 1);
				}
			}
		}
	}
}