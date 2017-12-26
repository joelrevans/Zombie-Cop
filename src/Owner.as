package 
{
	
	/**
	 * ...
	 * @author Joel Evans
	 */
	public class Owner 
	{
		public var allies:Array = new Array();
		/*Creates a new Owner.*/
		public function Owner():void {
			allies.push(this);
		}
		/*Returns true if the owner provided is an enemy.*/
		public function isEnemy(value:Owner):Boolean {
			for (var a:uint = 0; a < allies.length; a++) {
				if (allies[a] == value) {
					return false;
				}
			}
			return true;
		}
	}
	
}