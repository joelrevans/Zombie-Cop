package 
{
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class FogEffect extends FadeBlender
	{
		
		[Embed(source = '../graphics/Fog/fog1.png')]private static const fog1:Class;
		[Embed(source = '../graphics/Fog/fog2.png')]private static const fog2:Class;
		[Embed(source = '../graphics/Fog/fog3.png')]private static const fog3:Class;
		[Embed(source = '../graphics/Fog/fog4.png')]private static const fog4:Class;
		[Embed(source = '../graphics/Fog/fog5.png')]private static const fog5:Class;
		[Embed(source = '../graphics/Fog/fog6.png')]private static const fog6:Class;
		[Embed(source='../graphics/Fog/fog7.png')]private static const fog7:Class;
		
		public function FogEffect():void {
			var fogRay:Array = [new fog1(), new fog2(), new fog3(), new fog4(), new fog5(), new fog6(), new fog7()];
			super(fogRay, .75, 7, 150);
		}
	}
}