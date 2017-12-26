package 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.utils.Timer;
	import Clip;
	
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class Flailer extends DestructableMeleeFighter
	{
		//still
		[Embed(source = '../graphics/Flailer/Still/frame0001.png')]private static const still1:Class;
		[Embed(source = '../graphics/Flailer/Still/frame0002.png')]private static const still2:Class;
		[Embed(source = '../graphics/Flailer/Still/frame0003.png')]private static const still3:Class;
		[Embed(source = '../graphics/Flailer/Still/frame0004.png')]private static const still4:Class;
		[Embed(source = '../graphics/Flailer/Still/frame0005.png')]private static const still5:Class;
		[Embed(source = '../graphics/Flailer/Still/frame0006.png')]private static const still6:Class;
		[Embed(source = '../graphics/Flailer/Still/frame0007.png')]private static const still7:Class;
		//split
		[Embed(source = '../graphics/Flailer/split/frame0001.png')]private static const walk1:Class;
		[Embed(source = '../graphics/Flailer/split/frame0002.png')]private static const walk2:Class;
		[Embed(source = '../graphics/Flailer/split/frame0003.png')]private static const walk3:Class;
		[Embed(source = '../graphics/Flailer/split/frame0004.png')]private static const walk4:Class;
		[Embed(source = '../graphics/Flailer/split/frame0005.png')]private static const walk5:Class;
		[Embed(source = '../graphics/Flailer/split/frame0006.png')]private static const walk6:Class;
		[Embed(source = '../graphics/Flailer/split/frame0007.png')]private static const walk7:Class;
		[Embed(source = '../graphics/Flailer/split/frame0008.png')]private static const walk8:Class;
		[Embed(source = '../graphics/Flailer/split/frame0009.png')]private static const walk9:Class;
		[Embed(source = '../graphics/Flailer/split/frame0010.png')]private static const walk10:Class;
		[Embed(source = '../graphics/Flailer/split/frame0011.png')]private static const walk11:Class;
		[Embed(source = '../graphics/Flailer/split/frame0012.png')]private static const walk12:Class;
		[Embed(source = '../graphics/Flailer/split/frame0013.png')]private static const walk13:Class;
		[Embed(source = '../graphics/Flailer/split/frame0014.png')]private static const walk14:Class;
		[Embed(source = '../graphics/Flailer/split/frame0015.png')]private static const walk15:Class;
		[Embed(source = '../graphics/Flailer/split/frame0016.png')]private static const walk16:Class;
		[Embed(source = '../graphics/Flailer/split/frame0017.png')]private static const walk17:Class;
		[Embed(source = '../graphics/Flailer/split/frame0018.png')]private static const walk18:Class;
		[Embed(source = '../graphics/Flailer/split/frame0019.png')]private static const walk19:Class;
		[Embed(source = '../graphics/Flailer/split/frame0020.png')]private static const walk20:Class;
		[Embed(source = '../graphics/Flailer/split/frame0021.png')]private static const walk21:Class;
		[Embed(source = '../graphics/Flailer/split/frame0022.png')]private static const walk22:Class;
		[Embed(source = '../graphics/Flailer/split/frame0023.png')]private static const walk23:Class;
		private var split:Clip = new Clip(15, [new walk1(), new walk2(), new walk3(), new walk4(), new walk5(), new walk6(), new walk7(), new walk8(), new walk9(), new walk10(), new walk11(), new walk12(), new walk13(), new walk14(), new walk15(), new walk16(), new walk17(), new walk18(), new walk19(), new walk20(), new walk21(), new walk22(), new walk23()]);
		//body parts
		[Embed(source = '../graphics/body parts/Flailer/f1.png')]private static const part1:Class;
		[Embed(source = '../graphics/body parts/Flailer/f2.png')]private static const part2:Class;
		[Embed(source = '../graphics/body parts/Flailer/f3.png')]private static const part3:Class;
		[Embed(source = '../graphics/body parts/Flailer/f4.png')]private static const part4:Class;
		[Embed(source = '../graphics/body parts/Flailer/f5.png')]private static const part5:Class;
		[Embed(source = '../graphics/body parts/Flailer/f6.png')]private static const part6:Class;
		[Embed(source = '../graphics/body parts/Flailer/f7.png')]private static const part7:Class;
		[Embed(source='../graphics/body parts/Flailer/f8.png')]private static const part8:Class;
		private var body:Sprite;
		
		[Embed(source = '../Sound/final/flailer.mp3')]private static const splode:Class;
		private static var explode:Sound = new splode();
		private static var trans:SoundTransform = new SoundTransform(3);
		private static var flailcount : uint = 0;
		
		private var lit:Timer = new Timer(10000, 1);	//refresh of teh spawn
		
		
		/*Creates a new flailer unit*/
		public function Flailer(owner:Owner = null):void {
			if (owner == null) {
				owner = new Owner();
			}
			flailcount ++;
			speedMultiplier = Math.sqrt(flailcount + 16) / 4;
			for (var gh : uint = 0; gh < Destructable.members.length; ++gh) {
				if (Destructable.members[gh] is Flailer) {
					Destructable.members[gh].speedMultiplier = speedMultiplier;
				}
			}
			var still:Clip = new Clip(15, [new still1(), new still2(), new still3(), new still4(), new still5(), new still6(), new still7()]);
			still.loop = true;
			super(owner, still, still, still, 30, 100000, 100000, 160, 1, 80, 5000);
			//split
			lit.addEventListener(TimerEvent.TIMER, splitter);
			lit.start();
		}
		override protected function attack(target:Destructable):void {
			if (coolTimer.running == true) {
				return;
			}
			if (Point.distance(target.border.anchor, border.anchor) - movementSpeed <= radius + target.radius) {
				coolTimer.start();
				var explosion:ExplosionEffect = new ExplosionEffect();
				explosion.scaleX = explosion.scaleY = .4;
				explosion.x = x - explosion.width / 2;
				explosion.y = y - explosion.height / 2;
				target.health -= damage;
				destruct();
			}else {
				var v:LinearVector = new LinearVector(border.anchor, target.border.anchor);
				move(v.getCollision(target.border));
				if (path.length == 1) {
					targeter.delay = 150;
				}else if(path.length > 1) {
					targeter.delay = 1500;
				}else {
					targeter.delay = 3000;
				}
			}
		}
		private function splitter(...args):void {
			if (Destructable.members.length >= 25) {	//prevents overpopulation
				lit.repeatCount = lit.currentCount + 1;
				return;
			}
			followTimer.stop();
			targeter.stop();
			moveTimer.stop();
			coolTimer.stop();
			removeChildAt(0);
			addChildAt(split, 0);
			split.x = -split.width / 2;
			split.y = -split.height / 2;
			split.currentFrame = 0;
			split.frameRate = 15;
			split.loop = false;
			split.onComplete = spline;
		}
		private function spline():void {
			var z1:Flailer = new Flailer(owner);
			var z2:Flailer = new Flailer(owner);
			if (parent != null) {
				parent.addChild(z1);
				parent.addChild(z2);
				z1.x = x;
				z1.y = y;
				var ang:Number = (90 - rotation) / 180 * Math.PI;
				z2.x = x + Math.cos(ang) * 20;
				z2.y = y - Math.sin(ang) * 20;
				ang = Math.atan2(z2.y - z1.y, z2.x - z1.x);
				var v:LinearVector = new LinearVector(new Point(z1.x, z1.y), new Point(z2.x, z2.y));
				v.direction += Math.PI;
				v.magnitude = 50;
				var k:Vector = v.getFirstCollider(DestructableWalker.staticObstacles);
				if (k == null) {
					SmoothTween.add(z1, v.destination, 100);
				}else {
					SmoothTween.add(z1, v.getCollision(k), 100);
				}
				v.direction += Math.PI;
				v.anchor = new Point(z2.x, z2.y);
				k = v.getFirstCollider(DestructableWalker.staticObstacles);
				if (k == null) {
					SmoothTween.add(z2, v.destination, 100);
				}else {
					SmoothTween.add(z2, v.getCollision(k), 100);
				}
				z1.rotation = z2.rotation = rotation;
			}
			if (parent != null) {
				parent.removeChild(this);
			}
			destruct();
		}
		override protected function destruct():void {
			flailcount--;
			speedMultiplier = Math.sqrt(flailcount + 16) / 4;
			for (var gh : uint = 0; gh < Destructable.members.length; ++gh) {
				if (Destructable.members[gh] is Flailer) {
					Destructable.members[gh].speedMultiplier = speedMultiplier;
				}
			}
			clearMember(this);
			Main.reference.endLevelMaybe();
			/*if (health < 0) {
				Global.monies += Global.flailerPayout;
			}*/
			if (parent != null) {
				body = new Sprite();
				body.x = x;
				body.y = y;
				body.rotation = rotation;
				var p1:Bitmap = new part1();
				p1.x = 35- width / 2;
				p1.y = 1 - height / 2;
				Tween.add(p1, generatePoint(50, 75), 40);
				body.addChild(p1);
				var p2:Bitmap = new part2();
				p2.x = - width / 2;
				p2.y = 12 - height / 2;
				Tween.add(p2, generatePoint(50, 75), 40);
				body.addChild(p2);
				var p3:Bitmap = new part3();
				p3.x = 30- width / 2;
				p3.y = 8 - height / 2;
				Tween.add(p3, generatePoint(50, 75), 40);
				body.addChild(p3);
				var p4:Bitmap = new part4();
				p4.x = 41- width / 2;
				p4.y = 8 - height / 2;
				Tween.add(p4, generatePoint(50, 75), 40);
				body.addChild(p4);
				var p5:Bitmap = new part5();
				p5.x = 42- width / 2;
				p5.y = 21 - height / 2;
				Tween.add(p5, generatePoint(50, 75), 40);
				body.addChild(p5);
				var p6:Bitmap = new part6();
				p6.x = 40- width / 2;
				p6.y = 4 - height / 2;
				Tween.add(p6, generatePoint(50, 75), 40);
				body.addChild(p6);
				var p7:Bitmap = new part7();
				p7.x = 80- width / 2;
				p7.y = 8 - height / 2;
				Tween.add(p7, generatePoint(50, 75), 40);
				body.addChild(p7);
				var p8:Bitmap = new part8();
				p8.x = 70 - width / 2;
				p8.y = 8 - height / 2;
				Tween.add(p8, generatePoint(50, 75), 40);
				body.addChild(p8);
				var smo:SmokeEffect = new SmokeEffect(4000, 80);
				smo.width = 70;
				smo.scaleY = smo.scaleX;
				smo.rotation = Math.random() * 360;
				var xplo:ExplosionEffect = new ExplosionEffect(20);
				xplo.width = 28;
				xplo.scaleY = xplo.scaleX;
				xplo.rotation = Math.random() * 360;
				smo.x = xplo.x = x;
				smo.y = xplo.y = y;
				destructLayer.addChild(smo);
				destructLayer.addChild(xplo);
				destructLayer.addChild(body);
				parent.removeChild(this);
				explode.play(0, 0, trans);
			}
			moveTimer.stop();
			followTimer.stop();
			coolTimer.stop();
			targeter.stop();
			lit.stop();
			split.onComplete = null;//new Function();
			move(new Point(x, y));
			/*
			for (var i:String in this) {
				this[i] = null;
			}*/
			if(health <= 0){
				var t:Timer = new Timer(250, 1);	//needs to happen after the death animations play.
				t.addEventListener(TimerEvent.TIMER_COMPLETE, staticize);
				t.start();
			}
		}
		private function staticize(e:TimerEvent):void {
			//body.parent.removeChild(body);
			if(parent != null){
				destructLayer.removeChild(body);
			}
			Main.oldGuts.add(body, new Point( -Main.oldGuts.x, -Main.oldGuts.y));
		}
		private function generatePoint(innerRadius:Number, outerRadius:Number):Point {
			var radius:Number = Math.random() * (outerRadius - innerRadius) + innerRadius;
			var angle:Number = Math.random() * Math.PI * 2;
			return new Point(Math.cos(angle) * radius, Math.sin(angle) * radius);
		}
	}
	
}