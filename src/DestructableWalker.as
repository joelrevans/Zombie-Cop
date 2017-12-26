package 
{
	import flash.display.DisplayObjectContainer;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import org.flashdevelop.utils.FlashConnect;
	import Path;
	import flash.utils.getTimer;
	/**
	 * ...
	 * @author Joel Evans
	 */
	public class DestructableWalker extends DestructableUnit 
	{	
		public static var prePath:CachedPath;
		
		public static var total:Number = 0;
		public static var count:uint = 0;
		
		public static var nodes:Array = new Array();
		private static var statObs:Array = new Array();
		private static var dynObs:Array = new Array();
		protected var lineOfSight:Number;	//The area visible by unit.  Will also affect distance of attack.
		private var leader:DestructableUnit;	//The unit that is being followed, if following is engaged.
		protected var followTimer:Timer;	//Determins the refresh rate for the unit to follow.
		protected var path:Array;	//The path that the unit will follow when moving.
		protected var moveTimer:Timer = new Timer(10);	//Refreshes actions every 10ms.
		protected var speedMultiplier : Number = 1.0;
		/*Creates a new DestructableWalker object
		 * @param still The default animation for units which are not moving.
		 * @param transit The clip to be played when the unit is in motion.
		 * @param radius Defines the physical area of the unit.
		 * @param speed Unit's rate of movement, in pixels/second
		 * @param health The health of the unit.
		 * @param followRefresh The rate at which a following unit has its path updated.*/
		public function DestructableWalker(owner:Owner, still:Clip, transit:Clip, radius:Number, lineOfSight:Number, speed:Number, health:Number, followRefresh:uint):void {
			super(owner, still, radius, health);
			moveSpeed = speed;
			this.lineOfSight = lineOfSight;
			this.transit = transit;						//Plays when unit is moving
			followTimer = new Timer(followRefresh);		//Higher number == better performance when following is engaged.
			dynamicObstacles.push(border);
			
			moveTimer.addEventListener(TimerEvent.TIMER, followPath);
			followTimer.addEventListener(TimerEvent.TIMER, updateFollow);
		}
		/*Set obstacles that don't change, such as walls or buildings.*/
		public static function set staticObstacles(obs:Array):void {
			for (var i:uint = 0; i < obs.length; i++) {
				if ((obs[i] is Vector) == false) {
					obs.splice(i, 1);
					i--;
				}
			}
			statObs = obs;
		}
		/*Returns all static Obstacles.*/
		public static function get staticObstacles():Array {
			return statObs;
		}
		/*Sets dynamic, changing obstacles, such as moving units.*/
		public static function set dynamicObstacles(obs:Array):void {
			for (var i:uint = 0; i < obs.length; i++) {
				if ((obs[i] is DestructableWalker) == false) {
					obs.splice(i, 1);
					i--;
				}
			}
			dynObs = obs;
		}
		/*Returns all dynamic obstacles.*/
		public static function get dynamicObstacles():Array {
			return dynObs;
		}
		/*Sets the movement speed of a unit, in pixels/second.*/
		public function set moveSpeed(value:Number):void {
			movementSpeed = Math.abs(value / 1000 * moveTimer.delay) * speedMultiplier;
		}
		/*Returs the movement speedof a unit.*/
		public function get moveSpeed():Number {
			return movementSpeed * 1000 / moveTimer.delay;
		}
		/*Orders the unit to move to a specified destination.*/
		override public function move(destination:Point):void {
			if (destination == null) {
				//trace(Math.random());
				path = [new Point(x, y)];
				return;
			}
			if (destination.equals(border.anchor)) {
				removeChildAt(0);
				addChildAt(still, 0);
				still.x = -still.width / 2;
				still.y = -still.height / 2;
				moveCompleted();
				moveTimer.stop();
				return;
			}
			
			path = prePath.findPath(new Point(x, y), destination, true);

			if (path == null) {
				path = [new Point(x, y)];
				return;
			}
			path.shift();
			moveTimer.start();
			//play walking animation.
			removeChildAt(0);
			addChildAt(transit, 0);
			transit.x = -transit.width / 2;
			transit.y = -transit.height / 2;
		}
		/*Causes the unit to move along a path, triggered by the move function*/
		private function followPath(e:TimerEvent):void {
			var dist:Number = Point.distance(path[0], new Point(x, y));
			if (dist <= movementSpeed) {	//Tests if the next point is shorter than movement speed.
				x = path[0].x;
				y = path[0].y;
				path.shift();
				if (path.length == 0) {
					moveCompleted();
					moveTimer.stop();
					//Plays still animation
					removeChildAt(0);
					addChildAt(still, 0);
					still.x = -still.width / 2;
					still.y = -still.height / 2;
				}
				return;
			}
			var angle:Number = Math.atan2(path[0].y - y, path[0].x - x);
			
			/*var dest : Point =  new Point();
			dest.x = x + Math.cos(angle) * movementSpeed;
			dest.y = y + Math.sin(angle) * movementSpeed;
			*/
			var tmp : LinearVector = new LinearVector(new Point(x, y), new Point());
			tmp.magnitude = movementSpeed * speedMultiplier;
			tmp.direction = angle;
			
			var borders : Array = new Array();
			for (var i : uint = 0; i < Destructable.members.length; ++i) {
				borders.push(Destructable.members[i].border);
			}
			/*
			var first : RadialVector;
			i = 6;
			while(--i){
				first = RadialVector(tmp.getFirstCollider(borders));
				if (first != null) {
					var r : Number = border.radius+0.1;
					var d : Number = Point.distance(first.anchor, border.anchor);
					tmp.direction += Math.PI / 8;
				}else {
					x = tmp.destination.x;
					y = tmp.destination.y;
					rotation = 90 + 180 / Math.PI * tmp.direction;
					break;
				}
			}*/
			x = tmp.destination.x;
			y = tmp.destination.y;
			rotation = 90 + 180 / Math.PI * tmp.direction;
		}
		/*Abstract function that is called when the unit completes it's path.*/
		protected function moveCompleted():void { };
		/*Causes this unit to follow the unit provided.  If an enemy unit is set to follow, will cause this unit to chase that unit and attack.
		 * @param unit The unit to follow.
		 * @param rate The rate, in milliseconds, for the unit's location to be refreshed.*/
		public function follow(unit:DestructableUnit, rate:uint):void {
			move(unit.border.anchor);
			leader = unit;
			followTimer.delay = rate;
			followTimer.start();
		}
		/*Disengages the unit from following another.*/
		public function unfollow():void {
			leader = null;
			followTimer.reset();
		}
		/*Responsible for refreshing the path when the unit moves.*/
		private function updateFollow(e:TimerEvent):void {
			if (Point.distance(leader.border.anchor, border.anchor) <= lineOfSight) {
				var dir:Number;
				if (path.length == 1) {
					dir = Math.atan2(y - leader.border.anchor.y, x - leader.border.anchor.x);
				}else {
					dir = Math.atan2(path[path.length - 2].y - path[path.length - 1].y, path[path.length - 2].x - path[path.length - 1].x);
				}
				move(new Point(leader.border.anchor.x + leader.border.radius * Math.cos(dir), leader.border.anchor.y + leader.border.radius * Math.sin(dir)));
			}else {
				if (path[path.length - 1].equals(border.anchor)) {
					unfollow();
				}
			}
		}
	}
}