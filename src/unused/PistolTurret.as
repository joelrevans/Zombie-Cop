package 
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class PistolTurret extends StandardTurret 
	{
		[Embed(source='../graphics/turretBase.png')]private var baseImg:Class;
		[Embed(source='../graphics/basicTurret.png')]private var topStillImg:Class;
		[Embed(source = '../graphics/basicTurretAttack.png')]private var topOffendImg:Class;
		/*Creates a new pistolTurret object.
		 * @param owner The owner of the unit.
		 * @param direction The direction that the unit faces.
		 * @param position The position of the unit upon the field.*/
		public function PistolTurret(owner:Owner, direction:Number, position:Point):void {
			var topOff:Clip = new Clip(6, new topOffendImg(), new topStillImg());
			topOff.getFrame(0).y -= 46;
			var topSti:Clip = new Clip(0, new topStillImg());
			
			topOff.x = topSti.x = -25;
			
			super(owner, new Clip(0, new baseImg()), topSti, topOff, new Point(50, 50), direction, Math.PI / 4, 10, 50, 500, 60, 500);
			
			this.x = position.x;
			this.y = position.y;
 		}
	}
}