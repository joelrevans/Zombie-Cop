package 
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author Joel Evans
	 */
	public class Vector 
	{
		private var base:Point = new Point();	//Anchor point for vector
		private var mags:Number;				//Magnitude of the vector
		protected var theta:Number;			//Direction of the vector.  Specific operation must be defined.
		
		/*Returns the magnitude of an acute angle formed by three points, in radians.
		 * @param end1 The first end of the angle.
		 * @param vertex The middle point, around which the angle is formed.
		 * @param end2 The second end of the angle.*/
		public static function pointsToAngle(end1:Point, vertex:Point, end2:Point):Number {
			//var angle1:Number = Math.atan2(end1.y - vertex.y, end1.x - vertex.x);
			//var angle2:Number = Math.atan2(end2.y - vertex.y, end2.x - vertex.x);
			return Math.abs(Math.atan2(end1.y - vertex.y, end1.x - vertex.x) - Math.atan2(end2.y - vertex.y, end2.x - vertex.x)) % Math.PI;
		}
		/*Returns the difference between the two angles, in radians (angle2 - angle1).  Clockwise is negative.
		 * @param angle1 The reference angle, from which the difference is measured.
		 * @param angle2 The leading angle, from which the difference may be subtracted to return the original result.*/
		public static function angleDifference(angle1:Number, angle2:Number):Number {
			var ngl:Number = (angle2 - angle1) % (Math.PI * 2);
			if (ngl > Math.PI) {
				return ngl - (2 * Math.PI);
			}else if (ngl < -Math.PI) {
				return ngl + (2 * Math.PI);
			}else {
				return ngl;
			}
		}
		/*Returns a positive angular equivalent between 2pi and 0 for the angle.*/
		public static function normalizeAngle(value:Number):Number {
			return (value % (2 * Math.PI) + (2 * Math.PI)) % (Math.PI * 2);
		}
		/*Returns true if the provided point is between the two provided angles.
		 * @param point Returns true if the provided point is in between the two angles.
		 * @param base The starting angle.  The valid area is from this angle, clockwise, to the second angle.
		 * @param second The second angle.  The valid area is from this angle, counterclockwise, to the base angle.*/
		public static function betweenAngles(point:Point, base:Number, second:Number):Boolean {
			var ang:Number = Math.atan2(point.y, point.x);
			if (normalizeAngle(angleDifference(base, ang)) < normalizeAngle(angleDifference(base, second))) {
				return true;
			}else {
				return false;
			}
		}
		/*Given an array of vectors, returns true if any collide.
		 * @param An array of obstacle vectors.*/
		public function collisionOccurs(vectors:Array):Boolean {
			for (var i:uint = 0; i < vectors.length; i++) {
				if (getCollision(vectors[i]) != null) {
					return true;
				}
			}
			return false;
		}
		/*Returns true if the provided vector is identical with this one.*/
		public function equals(vector:Vector):Boolean{return true}
		/*Returns the collision point between two vectors.*/
		public function getCollision(vector:Vector):Point { return null };
		/*Rotates the vector around the specified point.*/
		public function rotateVector(focus:Point, direction:Number):void {}
		/*Returns true if the provided point exists. upon the vector.*/
		public function interseptsPoint(point:Point, tolerance:Number = .00001):Boolean {return false}
		/*Anchor Point.*/
		public function set anchor(value:Point):void {
			base = value;
		}
		/*Anchor Point.*/
		public function get anchor():Point {
			return base;
		}
		/*Magnitude of the vector*/
		public function set magnitude(value:Number):void {
			if (value < 0) {
				value *= -1;
				reverse();
			}
			mags = value;
		}
		/*Magnitude of the vector*/
		public function get magnitude():Number {
			return mags;
		}
		/*Function is called when the magnitude of a vector is reversed, changing it's direction.*/
		protected function reverse():void { };
		/*Direction of the vector*/
		public function set direction(value:Number):void {}
		/*Direction of the vector*/
		public function get direction():Number { return 0 }
	}
	
}