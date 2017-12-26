package 
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Joel Evans
	 */
	public class DestructableUnit extends Destructable
	{
		protected var movementSpeed:Number;		//Abstract movement speed
		protected var still:Clip;				//Clip holding the default animation for each unit.
		protected var transit:Clip;			//Clip holding the movement animation for each unit.
		/*Creates a new DestructableUnit.
		 * @param The owner of the unit.
		 * @param still The default animation for units which are not moving.
		 * @param radius Defines the physical area of the unit.
		 * @param health The health of the unit.*/
		public function DestructableUnit(owner:Owner, still:Clip, radius:Number, health:Number):void {
			super(owner, radius, health);
			this.still = still;
			addChild(still);
			still.x = -still.width / 2;
			still.y = -still.height / 2;
		}
		public function move(destination:Point):void { };		//Abstract movement function
		//I'd rather move be protected, but I can't seem to make it work.
	}
}