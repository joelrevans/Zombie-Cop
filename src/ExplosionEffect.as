package 
{
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class ExplosionEffect extends Clip 
	{
		[Embed(source = '../graphics/explosion/frame1.png')]private static const frame1:Class;
		[Embed(source = '../graphics/explosion/frame2.png')]private static const frame2:Class;
		[Embed(source = '../graphics/explosion/frame3.png')]private static const frame3:Class;
		[Embed(source = '../graphics/explosion/frame4.png')]private static const frame4:Class;
		[Embed(source = '../graphics/explosion/frame5.png')]private static const frame5:Class;
		[Embed(source = '../graphics/explosion/frame6.png')]private static const frame6:Class;
		[Embed(source = '../graphics/explosion/frame7.png')]private static const frame7:Class;
		[Embed(source = '../graphics/explosion/frame8.png')]private static const frame8:Class;
		[Embed(source = '../graphics/explosion/frame9.png')]private static const frame9:Class;
		[Embed(source = '../graphics/explosion/frame10.png')]private static const frame10:Class;
		/*Creates a new ExplosionEffect Object.
		 * @param rate The delay between frames.*/
		public function ExplosionEffect(rate:Number = 20):void {
			super(rate, [new frame1(), new frame2(), new frame3(), new frame4(), new frame5(), new frame6(), new frame7(), new frame8(), new frame9(), new frame10()]);
			for (var i:uint = 0; i < totalFrames; i++) {
				getFrame(i).x = -getFrame(i).width / 2;
				getFrame(i).y = -getFrame(i).height / 2;
			}
			onComplete = cleaner;
		}
		private function cleaner():void {
			if (parent != null) {
				parent.removeChild(this);
			}
		}
	}
	
}