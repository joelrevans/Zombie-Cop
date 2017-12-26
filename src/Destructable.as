package 
{
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ...
	 * @author Joel Evans
	 */
	public class Destructable extends Property 
	{
		private static var mems:Array = new Array();
		private var hp:Number;	//Health of the unit
		public static var destructLayer:DisplayObjectContainer;
		/*Creates new Destructable unit.
		 * @param owner Owner of the unit.
		 * @param radius Defines the physical area of the unit.
		 * @param health The health of the unit.*/
		public function Destructable(owner:Owner, radius:Number, health:Number):void {
			super(owner, radius);
			hp = health;
			mems.push(this);
		}
		/*Returns a list of all members.*/
		public static function get members():Array {
			return mems;
		}
		protected static function clearMember(d:Destructable):void {
			for (var i:uint = 0; i < members.length; i++) {
				if (members[i] == d) {
					members.splice(i, 1);
					return;
				}
			}
		}
		/*Sets the health of the unit.  Anything less than or equal to zero triggers death.*/
		public function set health(value:Number):void {
			if (value <= 0) {
				hp = 0;
				destruct();
				return;
			}
			hp = value;
		}
		/*Returns the health of the unit.*/
		public function get health():Number {
			return hp;
		}
		//Abstract death function.
		protected function destruct():void { }
		/*Pauses all of the unit processes if set to true.*/
	}
	
}