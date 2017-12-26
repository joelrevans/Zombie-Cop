package {
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author ...
	 */
	public class Spawnpoint 
	{
		protected var queue:Array = new Array();
		protected var spawner:Timer;
		protected var owner:Owner;
		
		/*The level parameter provided to new units to determine unit strength.*/
		public var level:uint;		
		/*The container on which new units are added.*/
		public var parent:DisplayObjectContainer;
		/*The point at which the units will spawn.*/
		public var position:Point;
		
		/*Creates an object that spawns new units.
		 * @param spawnDelay The delay between spawn cycles.
		 * @param parent The container on which to add the new units.
		 * @param position the position to add the new units at.
		 * @param owner The owner parameter to supply to the new units.
		 * @pararm level The level parameter to supply to the new units.*/
		public function Spawnpoint(spawnDelay:uint, parent:DisplayObjectContainer, position:Point, owner:Owner):void {
			this.owner = owner;
			spawner = new Timer(spawnDelay);
			spawner.addEventListener(TimerEvent.TIMER, spawn);
			this.parent = parent;
			this.position = position;
		}
		/*Adds a unit onto the spawn queue.
		 * @param unit The unit's class to create.
		 * @param cluster Will add multiple untis at once.*/
		public function add(unit:Class, ...cluster):void {
			for (var i:uint = 0; i < cluster.length; i++) {
				if (cluster[i] is Class == false) {
					cluster.splice(i, 1);
					i--;
				}
			}
			cluster.push(unit);
			queue.push(cluster);
			spawner.repeatCount = spawner.currentCount + queue.length;
			if (spawner.running == false) {
				spawner.start();
			}
		}
		/*Decides whether the point is actively spawning.  True spawns, false stop spawning.*/
		public function set running(value:Boolean):void {
			if (value == true) {
				spawner.start();
			}else {
				spawner.stop();
			}
		}
		/*Decides whether the point is actively spawning.  True spawns, false stop spawning.*/
		public function get running():Boolean {
			return spawner.running;
		}
		/*Sets the time period between unit spawns, in milliseconds.*/
		public function set spawnDelay(value:uint):void {
			spawner.delay = value;
		}
		/*Returns the time period between unit spawns, in milliseconds*/
		public function get spawnDelay():uint {
			return spawner.delay;
		}
		protected function spawn(e:TimerEvent):void {
			for (var i:uint = 0; i < queue[0].length; i++) {
				var cla:Class = queue[0].pop();
				var zombie:Destructable = new cla(owner);
				parent.addChild(zombie);
				zombie.x = position.x;
				zombie.y = position.y;
			}
			queue.shift();
		}
	}
}