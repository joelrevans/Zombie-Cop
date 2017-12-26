package 
{
	//INCOMPLETE CLASS.  NOT NECESSARY FOR ZOMBIE GAME
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	/**
	 * ...
	 * @author Joel Evans
	 */
	public class DestructableRanger extends DestructableWalker 
	{
		protected var offend:Clip;		//Clip holding the unit's attacking animation.
		protected var damage:Number;	//Damage of the unit.  Set below zero to cause healing.
		protected var coolTimer:Timer = new Timer(10, 1);	//Timer that manages cooldowns.  The cooldown time, in ms, is equivalent to the timer's delay.
		protected var targeter:Timer = new Timer(10, 0);	//Timer that scans for potential targets.
		private var orgDest:Point;	//The destination the unit is heading to.
		private var target:Destructable;	//The ranged unit's current target.
		
		/*Creates a new DestructableMeleeFighter Unit.
		 * @param owner The owner of the unit.
		 * @param still The default animation for units which are not moving.
		 * @param transit The clip to be played when the unit is in motion.
		 * @param offend The clip to be played during an offensive attack.
		 * @param border The physical border of the unit.  The anchor defines each unit's position.
		 * @param lineOfSight The distance that the unit is able to see.  Affects engagement distance as well.
		 * @param coolDown The delay time (milliseconds) required to pass before this unit can attack again after its most recent one.
		 * @param speed Unit's rate of movement.
		 * @param damage The damage inflicted by the unit.
		 * @param health The health of the unit.
		 * @param followRefresh The rate at which a following unit has its path updated.*/
		public function DestructableRanger(owner:Owner, still:Clip, transit:Clip, offend:Clip, border:RadialVector, lineOfSight:Number, coolDown:Number, speed:Number, health:Number, followRefresh:uint):void {
			super(owner, still, transit, border, lineOfSight, speed, health, followRefresh);
			this.offend = offend;
			coolTimer.delay = coolDown;
			
			targeter.addEventListener(TimerEvent.TIMER, scan);
			
		}
		//IDENTIFIES A TARGET.
		private function scan(e:TimerEvent):void {
			var targets:Array = new Array();
			for (var a:uint = 0; a < Destructable.members.length; a++) {
				if (Point.distance(Destructable.members[a].border.anchor, border.anchor) <= lineOfSight) {
					targets.push(Destructable.members[a]);
				}
			}
			if (targets.length == 0) {
				return;
			}
			while (targets.length > 1) {
				if (Point.distance(border.anchor, targets[0].border.anchor) > Point.distance(border.anchor, targets[1].border.anchor)) {
					targets.shift();
				}else {
					targets.splice(1, 1);
				}
			}
			target = targets.pop();
		}
	}
	
}