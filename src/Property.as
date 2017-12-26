package 
{
	import flash.display.InterpolationMethod;
	import flash.display.Sprite;
	import flash.geom.Point;
	/**
	 * ...
	 * @author Joel Evans
	 */
	public class Property extends Sprite
	{
		public var owner:Owner;			//The owner of the unit
		private var rads:Number;		//The radius of the unit's area.
		/*Creates a new Property Object
		 * @param owner The entity which owns the unit, dividing units into teams.
		 * @param radius Defines the physical area of the unit.*/
		public function Property(owner:Owner, radius:Number):void {
			this.owner = owner;
			this.radius = radius;
		}
		/*Returns a RadialVector representing the unit's position and area.*/
		public function get border():RadialVector {
			return new RadialVector(new Point(x, y), 0, 0, rads);
		}
		/*Sets the radius of the unit's area.*/
		public function set radius(value:Number):void {
			rads = Math.abs(value);	//You may need a condition for the radius to not equal zero
		}
		/*The radius which defines the unit's area.*/
		public function get radius():Number {
			return rads;
		}
	}
}