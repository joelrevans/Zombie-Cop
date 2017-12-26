package 
{
	import flash.display.Bitmap;
	import ColorRandomizer;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	/**
	 * ...
	 * @author Joel Evans
	 */
	public class ParticleVortex extends Bitmap
	{
		public var Particle_Per_Second:uint = 0;
		public var colorRandomizer:ColorRandomizer;
		public var radius:uint;
		
		private var coloRay:Array = new Array();
		private var thetaRay:Array = new Array();
		private var radRay:Array = new Array();
		
		private var grav:Number;
		private var velox:Number;
		
		private var time:Timer = new Timer(25);
		
		private var expire:Array = new Array();
		private var fadeStart:Array = new Array();
		private var fadeEnd:Array = new Array();
		private var cycleCount:uint;
		
		//INTERFACE FUNCTIONS
		
		/* @param color The color of each newly spawned particle.
		 * @param radius The radius of the fountain.
		 * @param velocity The tangential velocity of each particle.
		 * @param gravity The gravity of the fountain.
		 * @param spawnRate The number of particles to spawn per second.
		 * @param fadeCycles The number of cycles that it takes the particle to fade out, at 40 hertz approximately
		 * */
		public function ParticleVortex(color:ColorRandomizer, gravity:Number, radius:uint, velocity:Number, spawnRate:uint, fadeCycles:uint = 0):void {
			colorRandomizer = color;
			grav = gravity;
			this.radius = radius;
			velox = velocity;
			Particle_Per_Second = Math.floor(1000 / spawnRate);
			
			bitmapData = new BitmapData(radius * 2, radius * 2, true, 0);
			
			time.addEventListener(TimerEvent.TIMER, motion);
		}
		/*Begins spawning new particles.*/
		public function start():void {
			time.addEventListener(TimerEvent.TIMER, spawn);
			time.start();
		}
		/*Stops spawning new particles, but does not remove ones already created until their lifetime is complet.
		 * @param Dispose If marked true, will run a GarbageCollect of the object, removing all data and processes after the last particle expires*/
		public function stop(Dispose:Boolean):void {
			time.removeEventListener(TimerEvent.TIMER, spawn);
		}
		/*The velocity at which particles move around the center.  A negative value will rotate particles around the center in a counterclockwise direction.*/
		public function set velocity(value:Number):void {
			velox = value;
		}
		/*The velocity at which particles move around the center.  A negative value will rotate particles around the center in a counterclockwise direction.*/
		public function get velocity():Number {
			return velox;
		}
		/*The gravity which pulls particles towards the center.*/
		public function set gravity(value:Number):void {
			grav = value;
		}
		/*The gravity which pulls particles towards the center.*/
		public function get gravity():Number {
			return grav;
		}
		/*The number of cycles that it takes the particle to fade out, at 40 hertz approximately.
		 * The total number of cycles is equal to [radius / gravity].*/
		public function set fade(value:uint):void {
			cycleCount = value;
		}
		public function get fade():uint {
			return cycleCount;
		}
		
		
		
		//PRIVATE FUNCTIONS
		/*Manages particle motion*/
		private function motion(e:TimerEvent):void {
			bitmapData.fillRect(bitmapData.rect, 0);
			var col:uint;
			for (var i:uint = 0; i < coloRay.length; i++) {
				if(expire[i]-- <= 0) {
					thetaRay.splice(i, 1);
					radRay.splice(i, 1);
					coloRay.splice(i, 1);
					expire.splice(i, 1);
					fadeStart.splice(i, 1);
					fadeEnd.splice(i, 1);
					continue;
				}
				if (expire[i] < fadeStart[i] && expire[i] > fadeEnd[i] && gravity > 0) {
					col = coloRay[i] - 16777216 * Math.floor((coloRay[i] >>> 24) * (expire[i] - fadeStart[i]) / fade);  //Fade = fadeStart - fadeEnd
				}else if (expire[i] < fadeStart[i] && expire[i] >= fadeEnd[i] && gravity < 0) {
					col = coloRay[i] - 16777216 * Math.floor((coloRay[i] >>> 24) * (1 - (expire[i] - fadeStart[i]) / fade));
				}else {
					col = coloRay[i];
				}
				radRay[i] -= gravity;
				thetaRay[i] += velox / radRay[i];
				bitmapData.setPixel32(Math.cos(thetaRay[i]) * radRay[i] + radius, Math.sin(thetaRay[i]) * radRay[i] + radius, col);
			}
		}
		/*Spawns new particles*/
		private function spawn(e:TimerEvent):void {
			for (var i:uint = 0; i < Particle_Per_Second; i++) {
				thetaRay.push(Math.random() * 6.14);
				coloRay.push(colorRandomizer.getColor());
				if (gravity > 0) {
					expire.push(Math.floor(radius / gravity));
					radRay.push(radius);
					fadeStart.push(expire[expire.length - 1]);
					fadeEnd.push(expire[expire.length - 1] - cycleCount);
				}else if (gravity < 0) {
					expire.push(Math.floor(radius / -gravity));
					radRay.push(0);
					fadeStart.push(cycleCount);
					fadeEnd.push(0);
				}else {
					expire.push(200000000);
					fadeStart.push(expire[expire.length - 1]);
					fadeEnd.push(expire[expire.length - 1] - 10);
				}
			}
		}
	}	
}