package 
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author ...
	 */
	public class CachedPath  
	{
		private var obstacles:Array;
		private var nodes:Array;
		
		public var matrix:Array;	//temporarily public
		private var pathDistances:Array = new Array();
		
		/*Creates a new cached path object.
		 * @param nodes An array of points to use as pathing nodes.  If none are provided, generates maximum number of nodes automatically.
		 * @param obstacles An array of vector-type obstacles.
		 * @param formationOptimize If set to true, uses the formationOptimize algorithm for each path.*/
		public function CachedPath(nodes:Array, obstacles:Array):void {
			this.obstacles = obstacles;
			this.nodes = nodes;
		}/*
		public function calculateMatrix():void {
			matrix = Path.findAllPaths(obstacles, nodes);
			for (var a:uint = 0; a < matrix.length; a++) {
				pathDistances[a] = new Array();
				for (var b:uint = 0; b < matrix.length; b++) {
					pathDistances[a][b] = Path.getPathDistance(matrix[a][b]);
				}
			}
			outputMatrix();
		}
		/*Returns a new path, created from the cached path.
		 * @param origin The first point in a path.
		 * @param destination The final point in a path.
		 * @param formationOptimize If set to true, will optimize the vectors before finding the path.
		 * @param radialNodes Only used if formationOptimize is set to true.  The number of nodes to use during optimization.*/
		public function findPath(origin:Point, destination:Point, formationOptimize:Boolean = false, radialNodes:uint = 3):Array {
			var obstacles:Array;
			if (formationOptimize == true) {
				obstacles = Path.FormationOptimizePath(origin, destination, this.obstacles, radialNodes);
			}else {
				obstacles = this.obstacles;
			}
			var begin:Array = new Array();
			var fin:Array = new Array();
			var v:LinearVector = new LinearVector(origin, destination);
			if (v.collisionOccurs(obstacles) == false) {
				return [origin, destination];
			}
			for (var a:uint = 0; a < nodes.length; a++) {
				v.anchor = origin;
				v.destination = nodes[a];
				if (v.collisionOccurs(obstacles) == false) {
					begin.push(a);
				}
				v.anchor = destination;
				v.destination = nodes[a];
				if (v.collisionOccurs(obstacles) == false) {
					fin.push(a);
				}
			}
			
			var dist1:Number;
			var dist2:Number;
			var tot:Number = Number.MAX_VALUE;
			var first:uint;
			var second:uint;
			for (a = 0; a < begin.length; a++) {
				dist1 = Point.distance(nodes[begin[a]], origin);
				for (var b:uint = 0; b < fin.length; b++) {
					if (matrix[begin[a]][fin[b]].length == 0 || matrix[begin[a]][fin[b]] == undefined) {
						continue;
					}
					dist2 = dist1 + Point.distance(nodes[fin[b]], destination) + pathDistances[begin[a]][fin[b]];
					if (dist2 < tot) {
						tot = dist2;
						first = begin[a];
						second = fin[b];
					}
				}
			}
			if (tot == Number.MAX_VALUE) {
				return null;
			}
			var pth:Array = matrix[first][second].concat();
			pth.unshift(origin);
			pth.push(destination);
			return pth;
		}
		/*Imports the pre-cached matrix produced by outputMatrix*/
		public function importMatrix(matrix:Array):void {
			this.matrix = matrix;
			for (var a:uint = 0; a < matrix.length; a++) {
				pathDistances[a] = new Array();
				for (var b:uint = 0; b < matrix.length; b++) {
					pathDistances[a][b] = Path.getPathDistance(matrix[a][b]);
				}
			}
		}
		/*  Not compiled, only needs to be used to pre-calculate the matrix.
		public function outputMatrix():void {
			var string:String = "[";
			for (var a:uint = 0; a < matrix.length; a++) {
				string += "[";
				for (var b:uint = 0; b < matrix[a].length; b++) {
					string += "[";
					for (var c:uint = 0; c < matrix[a][b].length; c++) {
						string += "new Point(" + String(matrix[a][b][c].x) + "," + String(matrix[a][b][c].y) + ")";
						string += c != matrix[a][b].length - 1 ? "," : "";
					}
					string += "]";
					string += b >= matrix[a].length - 1 ? "" : ",";
				}
				string += "]";
				string += a >= matrix.length - 1? "" : ","; 
			}
			string += "]";
			trace(string);
		}
		/*comment put here to end the above comment, for ease of testing.*/
	}
}