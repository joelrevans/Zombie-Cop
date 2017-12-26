package 
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class ProximitySpawnPoint
	{
		public static var target:Destructable;
		public static var proximity:uint = 0;
		public static var parent:DisplayObjectContainer;
		public static var spawnOwner:Owner;
		public static var spawnPath:CachedPath;
		public static var queue:Array = new Array();
		public static var spawnTimer:Timer = new Timer(350);
		spawnTimer.addEventListener(TimerEvent.TIMER, spawn);
		spawnTimer.start();
		
		/*Adds new units to the spawn queue.*/
		public static function addSpawn(value:Array):void {
			queue.push(value);
		}
		/*The delay between spawns.*/
		public static function set spawnDelay(value:uint):void {
			spawnTimer.delay = value;
		}
		public static function get spawnDelay():uint {
			return spawnTimer.delay;
		}
		public static function clearSpawns():void {
			queue = new Array();
		}
		private static function spawn(...args):void {
			if (queue.length == 0) {
				return;
			}
			var cla:Class;
			var zombie:DestructableWalker;
			var v:LinearVector;
			//var ln:uint = queue[0].length;
			//for (var i:uint = 0; i < ln; i++) {
			while(queue[0].length){	
				cla = queue[0].pop();
				zombie = new cla(spawnOwner);
				parent.addChild(zombie);
				v = new LinearVector(new Point(target.x, target.y), new Point());
				v.magnitude = proximity;
				do{
					v.direction = Math.random() * 2 * Math.PI;
					if (v.getFirstCollider(Hero.staticObstacles) == null) {
						zombie.x = v.destination.x;
						zombie.y = v.destination.y;
						//zombie.health += zombie.health * Math.log(Global.level) / 2;
						//zombie.moveSpeed += zombie.moveSpeed * Math.log(Global.level) / 6;
						break;
					}
				}while (true);	//well its always going to run at least once, might as well make it a do{}while
			}
			queue.shift();
		}
	}
	
}