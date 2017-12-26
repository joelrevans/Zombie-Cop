package 
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Joel Evans
	 */
	public class RadialVector extends Vector
	{
		private var rad:Number;		//Radius of vector
		
		public function RadialVector(anchor:Point, magnitude:Number, direction:Number, radius:Number):void {
			this.anchor = anchor;
			this.magnitude = magnitude;
			this.direction = direction;
			rad = radius;
		}
		override public function getCollision(vector:Vector):Point {
			if (vector is LinearVector) {
				return vector.getCollision(this);
			}else if (vector is RadialVector) {
				var ix:Number = Point.distance(vector.anchor, anchor);
				var dir:Number = Math.atan2(vector.anchor.y - anchor.y, vector.anchor.x - anchor.x);
				if (ix <= radius + RadialVector(vector).radius) {
					return new Point(anchor.x + Math.cos(dir) * ix , anchor.y + Math.sin(dir) * ix);
				}
			}
			return null;
		}
		/*Returns true if the provided point exists. upon the vector.
		 * @param point The point to detect intersection with.
		 * @param tolerance Controls the maximum percentage of error that can occur in the calculation.  It's good to have SOME tolerance, because of the limited bit-set provided by the number class.*/
		override public function interseptsPoint(point:Point, tolerance:Number = .00001):Boolean {
			if (Math.abs(Point.distance(point, anchor) - radius) <= Math.abs(tolerance)) {
				return true;
			}
			return false;
		}
		/*Returns a random point on the inside of the vector.*/
		public function generateInternalPoint():Point {
			var theta:Number = Math.random() * 2 * Math.PI;
			var r:Number = Math.random() * radius;
			return new Point(Math.cos(theta) * r + anchor.x, Math.sin(theta) * r + anchor.y);
		}
		/*Radius of the vector.*/  
		public function set radius(value:Number):void {
			rad = Math.abs(value);
		}
		/*Radius of the vector.*/
		public function get radius():Number {
			return rad;
		}
		/*Direction of the vector.  Positive values are clockwise, and negative values are counterclockwise.  Zero is scalar.
		 * All values will be rounded to 1, 0, or -1.*/
		override public function set direction(value:Number):void {
			if (value > 0) {
				theta = 1;
			}else if (value < 0) {
				theta = -1;
			}else {
				theta = 0;
			}
		}
		/*Direction of the vector.  Positive values are clockwise, and negative values are counterclockwise.  Zero is scalar.
		 * All values will be rounded to 1, 0, or -1.*/
		override public function get direction():Number {
			return theta;
		}
		/*Returns true if the provided vector is identical with this one.*/
		override public function equals(vector:Vector):Boolean {
			if (vector is RadialVector == false) {
				return false
			}
			if (anchor.equals(vector.anchor) && radius == RadialVector(vector).radius) {
				return true;
			}else {
				return false;
			}
		}
	}
	
}