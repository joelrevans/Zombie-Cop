package 
{
	
	/**
	 * ...
	 * @author Joel Evans
	 */
	public class Structure extends Destructable 
	{
		/*Creates new Structure unit.
		 * @param owner Owner of the unit.
		 * @param radius Defines the physical area of the unit.
		 * @param health The health of the unit.*/
		public function Structure(owner:Owner, radius:Number, health:Number):void {
			super(owner, radius, health);
		}
	}
	
}