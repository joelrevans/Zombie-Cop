package 
{
	/**
	 * ...
	 * @author Joel Evans
	 */
	public class ColorRandomizer 
	{
		private var rMax:uint;
		private var rMin:uint;
		private var bMax:uint;
		private var bMin:uint;
		private var gMax:uint;
		private var gMin:uint;
		private var aMax:uint;
		private var aMin:uint;
		
		public function ColorRandomizer(aMax:uint = 0, aMin:uint = 0, rMax:uint = 0, rMin:uint = 0, gMax:uint = 0, gMin:uint = 0, bMax:uint = 0, bMin:uint = 0):void {
			this.aMax = aMax;
			this.aMin = aMin;
			this.rMax = rMax;
			this.rMin = rMin;
			this.gMax = gMax;
			this.gMin = gMin;
			this.bMax = bMax;
			this.bMin = bMin;
		}
		/*Returns a random color between the specified values*/
		public function getColor():uint {
			return (Math.floor(Math.random() * (aMax - aMin + 1)) + aMin) * 16777216 + (Math.floor(Math.random() * (rMax - rMin + 1)) + rMin) * 65536 + (Math.floor(Math.random() * (gMax - gMin + 1)) + gMin) * 256 + (Math.floor(Math.random() * (bMax - bMin + 1)) + bMin);
		}
		/*Sets the red channel of each new particle to a random number between the two supplied values*/
		public function setRed(value1:uint, value2:uint):void {
			rMax = Math.min(256, Math.max(value1, value2));
			rMin = Math.min(256, value1, value2);
		}
		/*Returns an array with the Maximum [0] and Minimum [1] values for the red channel.*/
		public function getRed():Array {
			return [rMax, rMin];
		}
		/*Sets the green channel of each new particle to a random number between the two supplied values*/
		public function setGreen(value1:uint, value2:uint):void {
			gMax = Math.min(256, Math.max(value1, value2));
			gMin = Math.min(256, value1, value2);
		}
		/*Returns an array with the Maximum [0] and Minimum [1] values for the green channel.*/
		public function getGreen():Array {
			return [gMax, gMin];
		}
		/*Sets the blue channel of each new particle to a random number between the two supplied values*/
		public function setBlue(value1:uint, value2:uint):void {
			bMax = Math.min(256, Math.max(value1, value2));
			bMin = Math.min(256, value1, value2);
		}
		/*Returns an array with the Maximum [0] and Minimum [1] values for the blue channel.*/
		public function getBlue():Array {
			return [bMax, bMin];
		}
		/*Sets the alpha channel of each new particle to a random number between the two supplied values*/
		public function setAlpha(value1:uint, value2:uint):void {
			aMax = Math.min(256, Math.max(value1, value2));
			aMin = Math.min(256, value1, value2);
		}
		/*Returns an array with the Maximum [0] and Minimum [1] values for the alpha channel.*/
		public function getAlpha():Array {
			return [aMax, aMin];
		}
	}
}