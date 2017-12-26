package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author ...
	 */
	public class StaticMap extends Bitmap
	{
		public var matrix:Array = new Array();
		public function StaticMap(width:uint, height:uint):void {
			super(new BitmapData(width, height, true, 0));
		}
		public function add(child:DisplayObject, translateCoordinates:Point = null):void {
			if (translateCoordinates == null) {
				translateCoordinates = new Point();
			}
			var bound:Rectangle = child.getBounds(this);
			var rads:Number = (child.rotation) / 180 * Math.PI;
			bitmapData.draw(child, new Matrix(Math.cos(rads), Math.sin(rads), -Math.sin(rads), Math.cos(rads), child.x + translateCoordinates.x, child.y + translateCoordinates.y));
		}
	}
}