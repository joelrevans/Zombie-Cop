package
{
	import flash.geom.Point;
	/**
	 * ...
	 * @author Joel Evans
	 */
	public class Path 
	{
		/*Accepts a path, as a series of points, and calculates the total distance traveled between the points.
		 * Non-point objects in the array will be removed.  The array will return undefined if the path is invalid.*/
		public static function getPathDistance(path:Array):Number {
			for (var i:uint = 0; i < path.length; i++) {
				if (!(path[i] is Point)) {
					path.splice(i, 1);
					i--;
				}
			}
			if (path.length == 0) {
				return NaN;
			}
			var total:Number = 0;
			for (i = 0; i < path.length - 1; i++) {
				total += Point.distance(path[i], path[i + 1]);
			}
			return total;
		}
		/*Accepts a list of paths (point-filled arrays), and outputs the one with the shortest distance.*/
		public static function getShortestPath(paths:Array):Array {
			/*Filters out any non-legitimate paths or path members*/
			for (var i:uint = 0; i < paths.length; i++) {
				if (!(paths[i] is Array)) {
					paths.splice(i, 1);
					i--;
					continue;
				}
				for (var q:uint = 0; q < paths[i].length; q++) {
					if (!(paths[i][q] is Point)) {
						paths[i].splice(q, 1);
						q--;
					}
				}
				if (paths[i].length < 2) {
					paths.splice(i, 1);
					i--;
				}
			}
			if (paths.length == 0) {
				return null;
			}
			/*Sorts paths according to distance*/
			while (paths.length > 1) {
				if (getPathDistance(paths[0]) > getPathDistance(paths[1])) {
					paths.shift();
				}else {
					paths.splice(1, 1);
				}
			}
			return paths[0];
		}
		
		/*Automatically generates a comprehensive set of nodes that will connect to form every possible path.
		 * @param vectors A set of vectors, for which nodes will be generated.  Creates two nodes for LinearVectors, number of radialNodes must be specified.
		 * @param radialNodes The number of points to create around RadialVectors.  Increasing this number will increase accuracy, but decrease performance and distance from the vector.  At least 3 nodes will exist per vector.*/
		public static function generateVectorNodes(vectors:Array, radialNodes:uint = 3):Array {
			var obstacles:Array = vectors.concat();
			var untapped:Array = new Array();
			for (var b:uint = 0; b < obstacles.length; b++) {
				if(obstacles[b] is LinearVector){
					//Puts a node slightly beyond the vectors'.  This allows for movement around corners.
					untapped.push(new Point(obstacles[b].anchor.x + Math.cos(obstacles[b].direction + Math.PI), obstacles[b].anchor.y + Math.sin(obstacles[b].direction + Math.PI)));
					untapped.push(new Point(obstacles[b].destination.x + Math.cos(obstacles[b].direction), obstacles[b].destination.y + Math.sin(obstacles[b].direction)));
				}
			}
			//Populates the array, untapped, for radial vectors
			radialNodes = Math.max(3, radialNodes);
			var theta:Number = Math.PI * 2 / radialNodes;	//The angular distance between each point.
			for (var a:uint = 0; a < obstacles.length; a++) {
				if (obstacles[a] is RadialVector) {
					var dist:Number = obstacles[a].radius / Math.cos(theta / 2) + obstacles[a].radius * .1 /*% tolerance*/;	//This is the distance the nodes will be from the center.
					for (var i:uint = 0; i < radialNodes; i++) {
						untapped.push(new Point(Math.cos(theta * i) * dist + obstacles[a].anchor.x, Math.sin(theta * i) * dist + obstacles[a].anchor.y));
					}
				}
				
			}
			/*
			for (var ra:uint = 0; ra < obstacles.length; ra++) {
				if (obstacles[ra] is RadialVector) {
					var theta:Number = 2 * Math.acos(obstacles[ra].radius / (obstacles[ra].radius + 1));	//The angle required to surround the surface with nodes at a distance of 1, and not have the vectors between nodes intsersect with the radial vector itself.  Change the radius + # to a higher number for performance.
					theta -= .01;	//This makes sure that no end-behavior causes a collision with the surface of the vector.
					var num:uint = Math.ceil(Math.PI * 2 / theta);	//Number of nodes needed to represent the circle.
					for (var mn:uint = 0; mn < num; mn++) {
						untapped.push(new Point(Math.cos(Math.PI * 2 / num * mn) * (obstacles[ra].radius + 1) + obstacles[ra].anchor.x, Math.sin(Math.PI * 2 / num * mn) * (obstacles[ra].radius + 1) + obstacles[ra].anchor.y));	//Adds each new node.
					}
				}
			}*/
			return untapped;
		}
		/*Given a set of obstacles, finds the shortest path from the origin point to the destination point.
		 * @param origin Starting point of the path.
		 * @param destination Ending point of the path.
		 * @param timeOut Number of millisecond the function will run before returning a null path.
		 * @param untapped An array filled with path nodes.*/
		public static function findNodePath(origin:Point, destination:Point, obstacles:Array, untapped:Array):Array {	//DOES NOT WORK WITH NEGATIVE NUMBERS YET
			obstacles = obstacles.concat();
			untapped = untapped.concat();	//Makes sure the arrays are not edited.
			for (var iz:uint = 0;  iz < obstacles.length; iz++) {	//Sorts out non-obstacles.
				if((obstacles[iz] is Vector) == false){
					obstacles.splice(iz, 1);
					iz--;
				}
			}
			var options:Array = new Array();						//Holds all of the potential paths.
			var vex:LinearVector = new LinearVector(origin, destination);	//Working vector.
			//Tests for a collision on the way to destination;
			for (var a:uint = 0; a < obstacles.length; a++) {
				if (vex.getCollision(obstacles[a]) != null) {
					break;
				}
			}
			if (a == obstacles.length || obstacles.length == 0) {
				return [origin, destination];
			}
			//Creates paths to all points with clear path to origin, and then removes those points from untapped, as there is no possible shorter path to them.
			lev1: for (var i:uint = 0; i < untapped.length; i++) {
				vex.destination = untapped[i];
				for (var j:uint = 0; j < obstacles.length; j++) {	//Tests for any collisions
					if (vex.getCollision(obstacles[j]) != null) {
						if (obstacles[j] is LinearVector) {
						}else {
						}
						continue lev1;
					}
				}
				//Runs if no collisions have occurred.
				options.push(new Array(origin, untapped[i]));
				untapped.splice(i, 1);
			}
			if (options.length == 0) {
				return null;
			}
			//Pathfinding algorithm
			untapped.push(destination);
			do {
				vex.anchor = options[0][options[0].length - 1];
				//Checks if path to the point is already complete, if so, removes all shorter paths and skips the pathfinding phase.
				if (vex.anchor.equals(destination)) {
					for (var f:uint = 1; f < options.length; f++) {
						if (getPathDistance(options[f]) + Point.distance(options[f][options[f].length - 1], destination) > getPathDistance(options[0])) {
							options.splice(f, 1);
							f--;
						}
					}
					options.push(options.shift());
					continue;
				}
				var nodesAdded:uint = 0;	//Used to test whether an untapped point is a straight-up dead end, if so, removal of the point occurs.
				//Pathfinding algorithm
				tier1:  for (var g:uint = 0; g < untapped.length; g++) {	//Cycles through untapped points, looking for new valid connections.
					if (vex.anchor.equals(untapped[g])) {	//Makes sure the intended destination is not the current point.
						continue;
					}
					vex.destination = untapped[g];
					for (var h:uint = 0; h < obstacles.length; h++) {	//Cycles through obstacles, checking for a collision.
						if (vex.getCollision(obstacles[h]) != null) {
							continue tier1;
						}
					}
					//Checks for shorter paths to the untapped point.
					for (var k:uint = 0; k < options.length; k++) {	//Runs through all potential paths.
						if (options[k][options[k].length - 1].equals(untapped[g])) {	//If the paths converge upon the same point, continues.
							if (getPathDistance(options[k]) > getPathDistance(options[0]) + Point.distance(options[0][options[0].length - 1], untapped[g])) {	//Compares the path lengths
								options.splice(k, 1);
							}else {
								continue tier1;	//Do NOT splice the current path YET, because you still have to check for new viable nodes.
							}
						}
					}
					nodesAdded++;	//Tracks added nodes for dead-end removal.
					//Runs if no collisions have occurred.
					options.push(options[0].concat());
					options[options.length - 1].push(untapped[g]);
				}
				//Removes dead-end nodes.
				if (nodesAdded == 0) {	//If no new paths are created from the last path, that node MUST be a dead end.  
					for (var l:uint = 0; l < untapped.length; l++) {	
						if (untapped[l].equals(options[0][options[0].length - 1])) {
							untapped.splice(l, 1);
							break;
						}
					}
				}
				options.shift();
			}while (options.length > 1 || (options.length != 0 && !options[0][options[0].length - 1].equals(destination)))
			if (options.length == 0) {
				return null;
			}
			return options[0];
		}
		/*
		public static function findCollisionCachedNodePath(origin:Point, destination:Point, obstacles:Array, untapped:Array):Array {
			//copies the arrays so as not to affect the original arrays.
			obstacles = obstacles.concat();
			untapped = untapped.concat();
			untapped.push(destination);
			untapped.unshift(origin);
			var r:Array = Path.getConnectedNodes(untapped, obstacles);
			var map:Array = r[0];
			var dist:Array = r[1];
			var p:Array = map[0].concat();
			for (var t:uint = 0; t < p.length; t++) {
				p[t] = [0, p[t]];
			}
			var branches:Array = p;
			var short:uint = uint.MAX_VALUE;	//The length of the shortest valid destination path.
			while (branches.length > 1) {
				var num:uint = branches[0].length - 1;
				//var num:uint = branches[0][branches[0].length - 1];
				var temp:Array = branches.shift();
				var temp2:Array;//copies temp, then pushes itself with different endpoints into branches.
				var dest:uint = untapped.length - 1;	//Stores the index of the destination variable.
				for (var a:uint = 0; a < map[branches[0][num]].length; a++){
					if (branches[0][branches[0].length - 2] == map[branches[0][num]][a] || branches[0][branches[0].length - 1] == map[branches[0][num]][a]) {	
						//Makes sure that the next node isn't the same as the previous one (back and forth).
						continue;
					}
					temp2 = temp.concat();
					temp2.push(map[branches[0][num]][a]);
					if (dTotal(temp2, dist) > short) {
						continue;
					}
					branches.push(temp2);
					if (a == dest) {
						short = dTotal(temp2, dist);
						for (var b:uint = 0; b < branches.length; b++) {
							if (dTotal(branches[b], dist) > short) {//If the first valid path is found, does a one-time removal of all shorter paths.
								branches.splice(b, 1);
								b--;
							}
						}
					}
				}
			}
			for (var i:uint = 0; i < branches.length; i++) {
				branches[i] = untapped[branches[i]];
			}
			return branches[0];
		}*/
		/*Used only for the findCollisionCachedNodePath function.  Returns the distance of a path.*/
		private static function dTotal(path:Array, dist:Array):Number {
			var t:Number = 0;
			for (var i:uint = 0; i < path.length - 1; i++) {
				t += dist[path[i]][path[i + 1]];
			}
			return t;
		}
		/*Searches for external points, and seperates them from the internal points.
		 * @param vectors A list of vectors, forming the potential enclosure.
		 * @param radialNodes The number of points to create around RadialVectors.  Increasing this number will increase accuracy, but decrease performance and distance from the vector.  At least 3 nodes will exist per vector.
		 * @param subdivide If set to true, will output each enclosure seperately, as all indicies >= [1] (There is a performance loss).  If set to false, all external points will be placed in index [1].*/
		public static function divideEnclosedNodes(vectors:Array, radialNodes:uint = 3, subdivide:Boolean = false):Array {
			var v:Array = vectors.concat();
			for (var i:uint = 0; i < v.length; i++) {	//Removes all non-vectors
				if (v[i] is Vector == false) {
					v.splice(i, 1);
					i--;
				}
			}
			var nodes:Array = generateVectorNodes(v, radialNodes);
			
			//Finds an external node, starting on the right side (right side simply for performance.  It could be any side, but you have to pick)
			var vex:LinearVector;	//working vector
			var branch:Array;	//Holds nodes to be tested for other connections.
			var exhaust:Array;	//Holds nodes that have been tested.
			var forms:Array = new Array();	//Holds groups of nodes that have been divided into seperate groups.  [0] is the outer vars, everything else is enclosed.
			for (i = 0; i < nodes.length; i++) {	//Finds ONE external variable to start with.
				vex = new LinearVector(nodes[i], new Point(Number.MAX_VALUE / Math.SQRT2, nodes[i].y));
				if (vex.collisionOccurs(v) == false/*vex.getFirstCollider(v) == null*/) {
					branch = [nodes[i]];
					nodes.splice(i, 1);
					break;
				}
			}
			while (nodes.length > 0) {
				exhaust = new Array();	//Resets exhaust, which has been passed onto forms.
				if (branch.length == 0) {
					branch = [nodes.shift()];
				}
				//On the first run, returns all of the external points.
				while (branch.length > 0) {
					vex.anchor = branch.shift();
					for (i = 0; i < nodes.length; i++) {
						vex.destination = nodes[i];
						//first part makes sure you arent testing the same point against itself, or it would keep adding itself to branch.
						//Second part tests if the path between points is interrupted
						if (vex.destination.equals(vex.anchor) == false && vex.collisionOccurs(v) == false /*vex.getFirstCollider(v) == null*/) {	
							branch.push(nodes[i]);
							nodes.splice(i, 1);
							i--;
						}
					}
					exhaust.push(vex.anchor.clone());	//not sure if clone is necessary, but i'm not risking it.
				}
				if (subdivide == false) {
					return [exhaust, nodes.concat()];
				}
				forms.push(exhaust);
			}
			return forms;
		}
		/*Returns true if the point is enclosed by the array of vectors.  This process uses non-subtractive areas, so all of the areas of all shapes are added together.
		 * @param vectors An array of vectors to test for enclosure.
		 * @param anchor The point to test for enclosure.*/
		public static function isEnclosed(vectors:Array, anchor:Point):Boolean {
			var pts:Array = divideEnclosedNodes(vectors);
			var v:LinearVector = new LinearVector(anchor, new Point());
			for (var i:uint = 0; i < pts[0].length; i++) {
				v.destination = pts[0][i];
				if (v.collisionOccurs(vectors) == false/*v.getFirstCollider(vectors) == null*/) {
					return true;
				}
			}
			return false;
		}
		/*Accepts a path, and reverses it.
		 * @param A set of points (a path) to reverse.*/
		public static function reversePath(path:Array):Array {
			if (path == null) { return null };
			path = path.concat();
			var p:Array = new Array();
			while(path.length > 0){
				p.push(path.pop());
			}
			return p;
		}
		/*Given a list of obstacles and nodes, will return two arrays corresponding to each node, containing the indicies of all other unobstructed nodes in the line of sight.  Also returns an array corresponding to the distance of every two valid nodes, as root index [1].
		 * NOTE:  Only returns the index locations.  The node array is still necessary to access a particular node.
		 * @param nodes A list of nodes.
		 * @param obstacles A list of obstacle vectors.*/
		public static function getConnectedNodes(nodes:Array, obstacles:Array):Array {
			nodes = nodes.concat();
			obstacles = obstacles.concat();
			//Put in code to filter arrays here
			var k:Array = new Array();
			var j:Array = new Array();
			for (var i:uint = 0; i < nodes.length; i++) {
				k.push(new Array());
				j.push(new Array());
			}
			var v:LinearVector = new LinearVector(new Point(), new Point());
			for (var a:uint = 0; a < nodes.length; a++) {
				v.anchor = nodes[a];
				for (var b:uint = a + 1; b < nodes.length; b++) {
					v.destination = nodes[b];
					if (v.collisionOccurs(obstacles) == false/*v.getFirstCollider(obstacles) == null*/) {
						k[a].push(b);
						k[b].push(a);
						var d:Number = Point.distance(nodes[a], nodes[b]);
						j[a].push(d);
						j[b].push(d);						
					}
				}
			}
			return [k, j];
		}
		/*Divides nodes up into their pathable areas, as if the nodes provided are the nodes used in the pathing algorithm.
		 * @param obstacles A list of vector obstacles.
		 * @param nodes A list of node points.*/
		public static function separateDividedNodes(obstacles:Array, nodes:Array):Array {
			nodes = nodes.concat();
			obstacles = obstacles.concat();
			var areas:Array = new Array();
			var v:LinearVector = new LinearVector(new Point(), new Point());
			while (nodes.length > 0) {
				var untested:Array = [nodes.shift()];
				while (untested.length > 0) {
					var finished:Array = new Array();
					v.anchor = untested[0];
					for (var i:uint = 0; i < nodes.length; i++) {
						v.destination = nodes[i];
						if (v.collisionOccurs(obstacles) == false/*v.getFirstCollider(obstacles) == null*/) {
							untested.push(nodes[i]);
							nodes.splice(i, 1);
							i--;
						}
					}
					finished.push(untested.shift());
				}
				areas.push(finished);
			}
			return areas;
		}
		/*Given a list of vectors, returns an array of formations of connected vectors.
		 * @param vector A list of obstacle vectors.*/
		public static function getFormations(vector:Array):Array {
			vector = vector.concat();
			var form:Array = new Array();
			var p:Point;
			while (vector.length > 0) {
				var untested:Array = [vector.shift()];
				while (untested.length > 0) {
					for (var i:uint = 0; i < vector.length; i++) {
						p = untested[0].getCollision(vector[i]);
						if (p != null) {
							untested.push(vector[i]);
							vector.splice(i, 1);
							i--;
						}
					}
				}
				form.push(untested);
			}
			return untested;
		}
		/*Given a single vector, traces and returns its formation.
		 * @param anchor A single seed vector with which to find the whole formation.
		 * @param vectors A list of accompanying vectors to draw the rest of the formation from.
		 * @param includeUnused If set to true, returns all provided vectors NOT in the formation, as a second index, [1].
		 * @param filterAnchor If set to true, searches the list of vectors provided, and removes the anchor vector, if it is already in the vector list.*/
		public static function traceFormation(anchor:Vector, vectors:Array, includeUnused:Boolean = false, filterAnchor:Boolean = false):Array {
			vectors = vectors.concat();
			if(filterAnchor == true){//removes the vector from the vector cloud, or else you end up with 2 copies in list
				for (var a:uint = 0; a < vectors.length; a++) {	
					if (anchor.equals(vectors[a])) {
						vectors.splice(a, 1);
						break;
					}
				}
			}
			var form:Array = new Array();
			var untested:Array = [anchor];
			while(untested.length > 0){
				for (var i:uint = 0; i < vectors.length; i++) {
					if (untested[0].getCollision(vectors[i]) != null) {
						untested.push(vectors[i]);
						vectors.splice(i, 1);
						i--;
					}
				}
				form.push(untested.shift());
			}
			if(includeUnused == false){
				return form;
			}else {
				return [form, vectors];
			}
		}
		/*Optimizes a path, reutrning a list of valid obstacle vectors.*/
		public static function FormationOptimizePath(origin:Point, destination:Point, obstacles:Array, numberOfNodes:uint = 3):Array {
			var testable:Array = [origin];
			var formations:Array = new Array();
			var vectors:Array = obstacles.concat();
			//working variables
			var v:LinearVector = new LinearVector(testable[0], destination);
			var v1:Vector;
			var v2:Vector;
			var p1:Point;
			var list:Array;
			var points:Array;
			var a:uint;
			while (testable.length > 0) {
				//Tests each point, adding new formations && points.
				v.anchor = testable.shift();
				v.destination = destination;
				v1 = v.getFirstCollider(formations);
				v2 = v.getFirstCollider(vectors);
				
				if(v2 != null && ((v1 != null && Point.distance(v.getCollision(v1), v.anchor) > Point.distance(v.getCollision(v2), v.anchor)) || v1 == null)){ //if vectors hit first, makes new formation.  Else, nothing.
					list = Path.traceFormation(v2, vectors, true, true);
					// trace(list[0]);
					points = Path.generateVectorNodes(list[0]);	//points in the formation
					for (a = 0; a < list[0].length; a++) {	//adds formation to formation vectors list.
						formations.push(list[0][a]);
					}
					vectors = list[1];	//leftover vectors after formation is removed
					for (a = 0; a < points.length; a++) {
						testable.push(points[a]);//adds new testable points.
					}
				}
			}
			return formations;
		}
		/*Returns every shortest possible path between every node, indexed with respect to the position of the node in the array [0][1, 2, 3...], [1][0, 1, 3...]
		 * @param obstacles A set of vector obstacles.
		 * @param nodes A set of pathing nodes.*/
		public static function findAllPaths(obstacles:Array, nodes:Array):Array {
			obstacles = obstacles.concat();
			nodes = nodes.concat();
			var matrix:Array = new Array();
			var fullNodes:uint = nodes.length;
			//You have to do this first, then start at a = 1 because b - 1 is uint.max when a = 0;
			matrix[0] = findSingleNodePathMap(obstacles, nodes);
			nodes.shift();
			for (var a:uint = 1; a < fullNodes; a++) {
				matrix[a] = findSingleNodePathMap(obstacles, nodes);
				nodes.shift();
				for (var b:int = a - 1; b >= 0; b--) {	//b has to be int, because 0 - 1 == uint.max, so b will never be less than zero.
					matrix[a].unshift(reversePath(matrix[b][a]));
				}
			}
			return matrix;
		}
		/*Calculates all paths between one point, and a set of provided nodes.  Paths for each node are returned in the respective order that they were provided.
		 * @param origin An origin to start each path with.
		 * @param obstacles A set of vector obstacles.
		 * @param a set of node obstacles.*/
		public static function findSingleNodePathMap(obstacles:Array, nodes:Array):Array {
			obstacles = obstacles.concat();
			nodes = nodes.concat();
			var index:Array = Path.getConnectedNodes(nodes, obstacles);
			var matrix:Array = new Array();	//holds shortest path to each node.
			for (var a:uint = 0; a < nodes.length; a++) {	//You have to do this becuase flash doesn't seem to work with "undefined"
				matrix[a] = new Array();
			}
			
			var options:Array = [[0]];
			var distances:Array = [[0]];
			
			var spliceIndex:uint;
			var sort:Array;	//working var
			//whichever point the shortest path goes to, that is the shortest point to that path.
			//This function always goes to the shortest path, adds it to the matrix, and creates new paths off of it.
			while (options.length > 0) {	//eventually, options will stop being generated as connections between nodes are severed.
				var b:uint = options[0][options[0].length - 1];
				if (matrix[b].length > 0) {	//If the matrix is already defined, removes it.  Paths longer than the matrix can be defined before, but not after it's creation.
					options.shift();
					distances.shift();
					continue;
				}
				
				for (a = 0; a < options[0].length; a++) {
					matrix[b].push(nodes[options[0][a]]);	//converts the option list to nodes, and adds to matrix.
				}
				
				var copy:Array;
				var originalIndex:uint = 0;
				for (a = 0;  a < index[0][b].length; a++) {	//makes copies of the shortest option, adds new ends to them, and spits them back out.
					copy = options[originalIndex].concat();
					copy.push(index[0][b][a]);
					spliceIndex = Logic.appendBinaryAscendingSort(distances[originalIndex] + index[1][b][a], distances);
					if (spliceIndex <= originalIndex) {
						originalIndex++;
					}
					//trace((distances[0] + index[1][b][a]) is String);
					distances.splice(spliceIndex, 0, Number(distances[0] + index[1][b][a])/*For some reason, if this isn't typed to number, it goes to string.*/);
					options.splice(spliceIndex, 0, copy);
					
					//You cannot remove the node from the loop, since everything is referencing a master list.  (if you cut out #9, any reference to #10 will give the wrong node.
					//Instead, you have to go into all of the index[0] references of the node[a], and remove it's neighbors' vision.
					for (var c:uint = 0; c < index[0][index[0][b][a]].length; c++){
						if (index[0][index[0][b][a]][c] == b) {
							index[0][index[0][b][a]].splice(c, 1);
							index[1][index[0][b][a]].splice(c, 1);
						}
					}
					//so now none of node[a]'s neighbors can see it, so they won't try making paths to it since the shortest path has already been found.
				}
				distances.splice(originalIndex, 1);
				options.splice(originalIndex, 1);	//the fastest path has spawned new copies, and can be removed.			
			}
			return matrix;
		}
	}
}