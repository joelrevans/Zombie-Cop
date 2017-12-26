package 
{
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import Destructable;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Joel Evans
	 */
	public class DestructableMeleeFighter extends DestructableWalker 
	{
		private var offendFrameRate:uint;
		protected var offend:Clip;		//Clip holding the unit's attacking animation.
		protected var damage:Number;	//Damage of the unit.  Set below zero to cause healing.
		protected var coolTimer:Timer = new Timer(10, 1);	//Timer that manages cooldowns.  The cooldown time, in ms, is equivalent to the timer's delay.
		protected var targeter:Timer = new Timer(1000, 0);	//Timer that scans for potential targets.
		private var orgDest:Point;	//The destination the unit is heading to.
		//private var timeOut:uint = 0;	//Used to stop the scan() and moveComplete functions to recur continuously and flow the stack.
		private var scanDate:uint = 0;  // Used to decrease scan() latencies when closing in on a target.
		/*Creates a new DestructableMeleeFighter Unit.
		 * @param owner The owner of the unit.
		 * @param still The default animation for units which are not moving.
		 * @param transit The clip to be played when the unit is in motion.
		 * @param offend The clip to be played during an offensive attack.
		 * @param radius Defines the physical area of the unit.
		 * @param lineOfSight The distance that the unit is able to see.  Affects engagement distance as well.
		 * @param coolDown The delay time (milliseconds) required to pass before this unit can attack again after its most recent one.
		 * @param speed Unit's rate of movement, in pixels/second.
		 * @param damage The damage inflicted by the unit.
		 * @param health The health of the unit.
		 * @param followRefresh The rate at which a following unit has its path updated.*/
		public function DestructableMeleeFighter(owner:Owner, still:Clip, transit:Clip, offend:Clip, radius:Number, lineOfSight:Number, coolDown:uint, speed:Number, damage:Number, health:Number, followRefresh:Number):void {
			/*STAT MULTIPLIERS*/
			health *= Math.pow(Math.log(Global.level + 5),2)/Math.log(2 * Global.level + 10) / 1.1249488 //the f(5) of the function;
			if (this is Crawler) {
				speed += (280 - speed) * (Global.level / (Global.level + 10));
			}else if(this is Mosher){
				speed += (265 - speed) * (Global.level / (Global.level + 10));
			}else{
				speed += (255 - speed) * (Global.level / (Global.level + 14));
			}
			/*End stat multipliers*/
			super(owner, still, transit,radius, lineOfSight, speed, health, followRefresh);
			this.offend = offend;
			coolTimer.delay = coolDown;
			coolTimer.addEventListener(TimerEvent.TIMER_COMPLETE, cooled);
			targeter.delay = followRefresh;
			targeter.addEventListener(TimerEvent.TIMER, scan);
			targeter.start();
			orgDest = new Point(x, y);
			this.damage = damage;
			//If you do just scan(), the starting coordinates will calcualte a path from (0, 0), giving it the wrong initial path. .
			var miniTimer:Timer = new Timer(10, 1);
			miniTimer.addEventListener(TimerEvent.TIMER, scan);
			miniTimer.start();
			//scan()  false => //If you dont do this, it will idle until the timer hits
			offendFrameRate = offend.frameRate;
			/*
			//DELETE
			graphics.lineStyle(2, 0xFF0000, 1);
			graphics.drawCircle(0, 0, radius);
			*/
		}
		/*Moves to a destination, and attacks all visible enemies on the way.*/
		public function attackMove(destination:Point):void {
			orgDest = destination;
			move(destination);
			targeter.start();
		}
		/*Identifies valid targets, chases them, and initiates attack when appropriate.*/
		protected function scan(e:*):void {
			/* This code is good and all, but there is only one target, and I need optimization.
			var target:Array = new Array();
			for (var i:uint = 0; i < Destructable.members.length; i++) {	//Gathers targets within this unit's line of sight.
				if (owner.isEnemy(Destructable.members[i].owner) && Point.distance(Destructable.members[i].border.anchor, border.anchor) <= lineOfSight) {	//Detects if units are visible enemies.
					target.push(Destructable.members[i]);
				}
			}
			if (target.length == 0) {
				move(orgDest);
			}else {
				for (var u:uint = 1; u < target.length; u++) {	//Finds the closest target.
					if (Point.distance(border.anchor, target[u - 1].border.anchor) > Point.distance(border.anchor, target[u].border.anchor)) {
						target.shift();
					}else {
						target.splice(1, 1);
					}
				}
				attack(target[0]);
			}*/
			attack(Hero.hero);
		}
		/*The physical attack move, deals damage.*/
		protected function attack(target:Destructable):void {
			if (coolTimer.running) {
				return;
			}
			if (Point.distance(target.border.anchor, border.anchor) - movementSpeed <= radius + target.radius) {
				rotation = 90 + 180 / Math.PI * Math.atan2(target.y - border.anchor.y, target.x - border.anchor.x);
				target.health -= damage;
				coolTimer.start();	//must be called before move() or else a recursion will occur causing double damage.
				move(border.anchor);
				offend.currentFrame = 0;
				offend.frameRate = offendFrameRate;
				offend.onComplete = coolDownAnimation;
				//oncomplete
				//Plays attacking animation.
				removeChildAt(0);
				addChildAt(offend, 0);
				offend.x = -offend.width / 2;
				offend.y = -offend.height / 2;
				return;
			}else {
				var v:LinearVector = new LinearVector(new Point(x, y), new Point(target.x, target.y));
				move(v.getCollision(target.border));
				if (path.length == 1 && path[0].equals(orgDest) == false) {
					targeter.delay = 150;
				}else if(path.length > 1) {
					targeter.delay = 1000;
				}else {	//path is null;
					switch(true) {
						case this is Zombie:
						ProximitySpawnPoint.addSpawn([Zombie]);
						break;
						case this is Crawler:
						ProximitySpawnPoint.addSpawn([Crawler]);
						break;
						case this is Bouncer:
						ProximitySpawnPoint.addSpawn([Bouncer]);
						break;
						case this is Mosher:
						ProximitySpawnPoint.addSpawn([Mosher]);
						break;
						case this is Flailer:
						ProximitySpawnPoint.addSpawn([Flailer ]);
						break;
						case this is Longarm:
						ProximitySpawnPoint.addSpawn([Longarm]);
						break;
					}
					destruct();
				}
			}
		}
		/*
		 *Starts another enemy scan once the path expires.*/
		override protected function moveCompleted():void {
			/*
			if (getTimer() - timeOut < 40) {	//Stops an infinite recursion.
				return;	
			}
			timeOut = getTimer();
			*/
			//scan();
			targeter.delay = 25;
		}
		/*Closes the attack phase.*/
		protected function coolDownAnimation():void {
			offend.onComplete = new Function();
			removeChildAt(0);
			if(moveTimer.running == true){
				addChildAt(transit, 0);	//Need potential stand animation.
				transit.x = -transit.width / 2;
				transit.y = -transit.height / 2;
			}else {
				addChildAt(still, 0);
				still.x = -still.width / 2;
				still.y = -still.height / 2;
			}
		}
		/*Resets the cooldown.*/
		private function cooled(e:TimerEvent):void {
			coolTimer.reset();
		}
	}
	
}