package
{
	import flash.display.DisplayObjectContainer;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	/**
	 * ...
	 * @author Joel Evans
	 */
	public class LinearVector extends Vector 
	{
		private static var abb:Boolean = false;
		public function LinearVector(anchor:Point, destination:Point):void {	//If only you could set between two points instead of supplying magnitude and direction.
			this.anchor = anchor;
			this.destination = destination;
		}
		/*Returns the first vector that intersects this one., given length as magnitude.
		 * @param vectors A set of vectors to test for collision.*/
		public function getFirstCollider(vectors:Array):Vector {
			var bestInt:uint = 0;
			var bestDist:Number = Number.MAX_VALUE;
			var p:Point;
			var d:Number;
			for (var i:uint = 0; i < vectors.length; i++) {
				p = getCollision(vectors[i]);
				if (p != null) {
					d = Point.distance(anchor, p);
					if (d < bestDist) {
						bestDist = d;
						bestInt = i;
					}
				}
			}
			if (bestDist == Number.MAX_VALUE) {
				return null;
			}
			return vectors[bestInt];
		}
		/*Given a set of obstacles, returns them in the order that they collide with this vector.
		 * @param vectors A list of vectors to test for collision and order according to proximity of collision to the vectors's anchor.
		 * @param includeCollisions If set to true, returns two indicies.  The first contains vectors in order, the second contains their corresponding collision locations.*/
		public function getOrderedColliders(vectors:Array, includeCollisions:Boolean = false):Array {
			//vectors = vectors.concat();
			var vex:Array = new Array();	//Holds the collided vectors
			var range:Array = new Array();	//length of the collided vectors along the path.
			var p:Point;	//Working var
			for (var i:uint = 0; i < vectors.length; i++) {
				p = getCollision(vectors[i]);
				if (p != null) {
					vex.push(vectors[i]);
					range.push(Point.distance(p, anchor));
				}
			}
			if(includeCollisions == false){
				return Logic.applySort(vectors, Logic.binaryAscendingSort(range));
			}else {
				var sort:Array = Logic.binaryAscendingSort(range);
				return [Logic.applySort(vectors, sort), Logic.applySort(range, sort)];
			}
		}
		/*Rotates the vector about a specified point.
		 * @param focus The point about which to rotate the vector.
		 * @param direction The angle, in radians, for the vector to be rotated.*/
		override public function rotateVector(focus:Point, direction:Number):void {
			var ang1:Number = Math.atan2(focus.y - anchor.y, focus.x - anchor.x);
			var ang2:Number = Math.atan2(focus.y - destination.y, focus.x - destination.x);
			var mag1:Number = Point.distance(focus, anchor);
			var mag2:Number = Point.distance(focus, destination);
			ang1 += direction;
			ang2 += direction;
			anchor.x = Math.cos(ang1) * mag1 + focus.x;
			anchor.y = Math.sin(ang1) * mag1 + focus.y;
			destination.x = Math.cos(ang2) * mag2 + focus.x;
			destination.y = Math.sin(ang2) * mag2 + focus.y;
		}
		/*Returns true if the provided point exists. upon the vector.
		 * @param point The point to detect intersection with.
		 * @param tolerance Controls the maximum percentage of error that can occur in the calculation.  It's good to have SOME tolerance, because of the limited bit-set provided by the number class.*/
		override public function interseptsPoint(point:Point, tolerance:Number = .00001):Boolean {
			if (((point.y - anchor.y) / (point.x - anchor.x)) - Math.tan(direction) <= tolerance && Point.distance(point, anchor) <= magnitude && Point.distance(point, anchor) <= magnitude) {
				return true;
			}
			return false;
		}
		/*Finds the distance between a linearVector object and a point, rounded to six digits.  Returns NaN if the point is not perpendicular to the line.
		 * @param point The point from which to measure the distance of the vector.*/
		public function distanceFromPoint(point:Point):Number {		//PRETTY SURE THAT THIS WORKS, BUT NEEDS TESTING ANYWAY.
			/*
			var d:Number = Point.distance(anchor, point);
			var e:Number = Point.distance(destination, point);
			var f:Number = magnitude;
			//c is the answer
			//var c:Number = Math.sqrt(Math.pow(d, 2) + 2 * Math.pow(f, 2) * Math.pow(e, 2) + 2 * Math.pow(d, 2) * Math.pow(e, 2) - 2 * Math.pow(d, 2) * Math.pow(f, 2) - Math.pow(e, 4) - Math.pow(f, 4) - Math.pow(d, 4)) / (2 * f);
			var c:Number = Math.sqrt(Math.pow(d, 2) - Math.pow(Math.pow(e, 2) - Math.pow(d, 2) - Math.pow(f, 2), 2) / Math.pow(2 * f, 2));
			var a:Number = Math.sqrt(Math.pow(d, 2) - Math.pow(c, 2));
			var b:Number = Math.sqrt(Math.pow(e, 2) - Math.pow(c, 2));
			if (Math.round((a + b) * 100000) / 100000 > Math.round(f * 100000) / 100000) {	//Unfortunately, these number MUST be rounded.  The huge calculations cause some minor error, which will misrepresent vector collisions.	
				return NaN;
			}else {
				return c;
			}*/
			var a2:Number = Math.pow(Point.distance(anchor, point), 2);
			var b2:Number = Math.pow(Point.distance(destination, point), 2);
			var d:Number = magnitude;
			var c2:Number = b2 - Math.pow((d * d + b2 - a2) / (2 * d), 2)
			var e:Number = Math.sqrt(a2 - c2);
			var f:Number = Math.sqrt(b2 - c2);
			if (e > d || f > d) {
				return NaN;
			}
			return Math.sqrt(c2);
		}
		/*Returns the point at which two vectors intersect.  Returns null if no intersection occurs, with length determined as magnitude.*/
		override public function getCollision(vector:Vector):Point {
			if (vector is LinearVector) {
				if (direction % Math.PI == vector.direction % Math.PI) {
					return null;
				}
				//The magnitude of the displacement of the vectors' intersection, divide-by-zero proof.  Multiply by components for simplicity. 
				var f:Number = (Math.sin(vector.direction) * (anchor.x - vector.anchor.x) + (vector.anchor.y - anchor.y) * Math.cos(vector.direction)) / Math.sin(direction - vector.direction);
				var d:Number = f * Math.cos(direction);	//x-component of displacement
				var e:Number = f * Math.sin(direction);	//x-component of displacement
				
				//The 1st-4th confirm the direction of the vectors.  atan2 is used to get the full spectrum, and d is used to get the correct signs.  The 3rd & 4th check that d is less than magnitude.
				if (Math.cos(direction) * Math.abs(d) == d * Math.abs(Math.cos(direction)) && Math.sin(direction) * Math.abs(e) == e * Math.abs(Math.sin(direction)) && Math.cos(vector.direction) * Math.abs(anchor.x + d - vector.anchor.x) == (anchor.x + d - vector.anchor.x) * Math.abs(Math.cos(vector.direction)) && Math.sin(vector.direction) * Math.abs(anchor.y + e - vector.anchor.y) == (anchor.y + e - vector.anchor.y) * Math.abs(Math.sin(vector.direction)) && magnitude >= f && vector.magnitude >= Point.distance(vector.anchor.subtract(anchor), new Point(d, e))) {
					return new Point(anchor.x + d, anchor.y + e);
				}
			}else if (vector is RadialVector) {
				/*
				var copy:LinearVector = new LinearVector(destination, anchor);
				var r:Number = RadialVector(vector).radius;
				if (Point.distance(anchor, vector.anchor) < r) {
					if (Point.distance(destination, vector.anchor) < r) {
						return null;
					}
					return copy.getCollision(vector);
				}
				
				copy = new LinearVector(anchor, destination);
				copy.magnitude = Number.MAX_VALUE;
				var k:Number = copy.distanceFromPoint(vector.anchor);
				if (isNaN(k) || k > r) {
					return null;
				}
				var min:Number = Math.sqrt(Math.pow(Point.distance(anchor, vector.anchor), 2) - Math.pow(k, 2)) - Math.sqrt(Math.pow(r, 2) - Math.pow(k, 2));
				if (magnitude >= min) {
					copy.magnitude = min;
					return copy.destination;
				}	//returns null at the end anyway.
				*/
				
				var dist:Number = Point.distance(anchor, vector.anchor);
				if (dist < RadialVector(vector).radius) {	//Checks if the linear vector is on the inside of the circle, and switches anchor and destination if needbe, to obtain the correct calculations.
					if (Point.distance(destination, vector.anchor) < RadialVector(vector).radius) {
						return null;
					}else {
						var vixen:LinearVector = new LinearVector(destination.clone(), anchor.clone());
						return vixen.getCollision(vector);
					}
				}
				var r:Number = RadialVector(vector).radius;
				var lin:LinearVector = new LinearVector(anchor.clone(), destination.clone());
				lin.magnitude = dist;
				var k:Number = lin.distanceFromPoint(vector.anchor);
				if (isNaN(k)) {	// k will return NaN only if it is facing the opposite direction from the vector.
					return null;
				}
				var g:Number = Math.sqrt(Math.pow(dist, 2) - Math.pow(k, 2));
				var a:Number = Math.sqrt(Math.pow(r, 2) - Math.pow(k, 2));
				var mindist:Number = g - a;
				lin.magnitude = mindist;
				if (magnitude < mindist || k > r) {
					return null;
				}else {
					return lin.destination;
				}
			}
			return null;
		}
		/*Direction in Radians.*/
		override public function set direction(direction:Number):void {
			theta = direction >= 0 ? direction % (2 * Math.PI) : direction % (2 * Math.PI) + (2 * Math.PI);	//Sets the bounds within positive 2Pi
		}
		/*Direction in Radians.*/
		override public function get direction():Number {
			return theta;
		}
		/*Resets the magnitude and direction of the vector so that the end point is identical to the one provided. */
		public function set destination(value:Point):void {
			magnitude = Math.sqrt(Math.pow(value.x - anchor.x, 2) + Math.pow(value.y - anchor.y, 2));
			direction = Math.atan2(value.y - anchor.y, value.x - anchor.x);
		}
		public function get destination():Point {
			var ex:Number = anchor.x + Math.cos(direction) * magnitude;
			var ey:Number = anchor.y + Math.sin(direction) * magnitude;
			//Rounds so you don't get stupid stuff like 10 ^ -14
			if (Math.abs(ex - Math.round(ex)) < .00001) {
				ex = Math.round(ex);
			}
			if (Math.abs(ey - Math.round(ey)) < .00001) {
				ey = Math.round(ey);
			}
			return new Point(ex, ey);
		}
		/*Returns true if the provided vector is identical with this one.*/
		override public function equals(vector:Vector):Boolean {
			if (vector is LinearVector == false) {
				return false;
			}
			if (destination.equals(LinearVector(vector).destination) && anchor.equals(vector.anchor)) {
				return true;
			}
			return false;
		}
		/*Returns the component values of the vector.*/
		public function get components() : Point {
			return new Point(Math.cos(direction), Math.sin(direction));
		}
		/*Changes the direction of the vector to point in the specified direction.*/
		public function set components(value : Point) : void {
			direction = Math.atan2(value.x, value.y);
		}
		/*Returns the point that lies upon the vector closest to the one provided.*/
		public function getClosestPoint(p : Point) : Point {
			var r : Number = distanceFromPoint(p);
			var d0 : Number = Point.distance(p, anchor);
			var mags : Number = Math.sqrt(d0 * d0 + r * r);
			return new Point(anchor.x + mags * components.x, anchor.y + mags * components.y);
		}
	}	
}