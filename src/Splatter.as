package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.filters.BlurFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class Splatter extends Bitmap
	{
		public static var members:Array = new Array();
		public static var fin:RadialVector;
		public static var ini:RadialVector;
		public function Splatter(lines:uint, startingArea:RadialVector, finalArea:RadialVector, color:ColorRandomizer):void {
			fin = finalArea; ini = startingArea;
			super(new BitmapData(Math.abs(startingArea.anchor.x - finalArea.anchor.x) + startingArea.radius  + finalArea.radius, Math.abs(startingArea.anchor.y - finalArea.anchor.y) + finalArea.radius * 2 + 4, true, 0));
			var p1:Point;
			var p2:Point;
			var s:Sprite = new Sprite();
			for (var a:uint = 0; a < lines; a++) {
				p1 = startingArea.generateInternalPoint();
				p2 = finalArea.generateInternalPoint();
				s.graphics.moveTo(p1.x, p1.y);
				s.graphics.lineStyle(1, color.getColor());
				s.graphics.lineTo(p2.x, p2.y);
			}
			bitmapData.draw(s, new Matrix(1, 0, 0, 1, startingArea.radius / 2 + 4, finalArea.radius + 8));
			//Math.abs(startingArea.anchor.x - finalArea.anchor.x) + startingArea.radius  + finalArea.radius, Math.abs(startingArea.anchor.y - finalArea.anchor.y) + finalArea.radius * 2 + 4, true, 0);
			filters = [new BlurFilter(4, 2)];
		}
		public static function generateSplatter(lines:uint, startingArea:RadialVector, finalArea:RadialVector, color:ColorRandomizer, transitions:uint, amount:uint):void {
			for (var k:uint = 0; k < amount; k++) {
				var c:Array = new Array();
				var angle:Number = Math.atan2(finalArea.anchor.y - startingArea.anchor.y, finalArea.anchor.x - startingArea.anchor.x);
				var dist:Number = Point.distance(startingArea.anchor, finalArea.anchor);
				for (var i:uint = 0; i < transitions; i++) {
					var d:Number = i / transitions * dist;
					var sp:Splatter = new Splatter(lines, startingArea, new RadialVector(new Point(Math.cos(angle) * d, Math.sin(angle) * d), 0, 0, i / transitions * (finalArea.radius - startingArea.radius) + startingArea.radius), color);
					c.push(sp);
				}
				members.push(c);
			}
		}
		public function clone():Bitmap {
			return new Bitmap(bitmapData.clone());
		}
	}
	
}