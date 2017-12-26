package 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import ColorRandomizer;
	import ParticleVortex;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class Fountain extends Sprite 
	{
		[Embed(source = '../graphics/environment/fountain base.png')]private static const fount:Class;
		private var base:Bitmap = new fount();
		private var color:ColorRandomizer = new ColorRandomizer(255, 255, 175, 125, 255, 225, 255, 225);
		
		/*Creates a new Fountain object*/
		public function Fountain():void {
			//Creates the water effect.
			var water:WaterEffect = new WaterEffect(240);
			water.width = base.width - 10;
			water.scaleY = water.scaleX;
			water.scaleY /= 1.05
			water.x = 5;
			water.y = 5;
			addChild(water);
			//Creates the vortex
			var vortex:ParticleVortex = new ParticleVortex(color, -base.width / 50, base.width / 2 - base.width / 5, 0, 1000, 20);
			vortex.x = base.width / 2 - vortex.radius;
			vortex.y = base.height / 2 - vortex.radius;
			vortex.start();
			//Adds the children
			addChild(water);
			addChild(vortex);
			addChild(base);
		}
	}
	
}