package 
{
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class Bouncer extends DestructableMeleeFighter 
	{
		//still
		[Embed(source = '../graphics/bouncer/still/frame0001.png')]private static const still1:Class;
		[Embed(source = '../graphics/bouncer/still/frame0002.png')]private static const still2:Class;
		[Embed(source = '../graphics/bouncer/still/frame0003.png')]private static const still3:Class;
		//walk
		[Embed(source = '../graphics/bouncer/transit/frame0001.png')]private static const walk1:Class;
		[Embed(source = '../graphics/bouncer/transit/frame0002.png')]private static const walk2:Class;
		[Embed(source = '../graphics/bouncer/transit/frame0003.png')]private static const walk3:Class;
		[Embed(source = '../graphics/bouncer/transit/frame0004.png')]private static const walk4:Class;
		[Embed(source = '../graphics/bouncer/transit/frame0005.png')]private static const walk5:Class;
		[Embed(source = '../graphics/bouncer/transit/frame0006.png')]private static const walk6:Class;
		[Embed(source = '../graphics/bouncer/transit/frame0007.png')]private static const walk7:Class;
		[Embed(source = '../graphics/bouncer/transit/frame0008.png')]private static const walk8:Class;
		[Embed(source = '../graphics/bouncer/transit/frame0009.png')]private static const walk9:Class;
		[Embed(source = '../graphics/bouncer/transit/frame0010.png')]private static const walk10:Class;
		//attack
		[Embed(source = '../graphics/bouncer/offend/frame0001.png')]private static const attack1:Class;
		[Embed(source = '../graphics/bouncer/offend/frame0002.png')]private static const attack2:Class;
		[Embed(source = '../graphics/bouncer/offend/frame0003.png')]private static const attack3:Class;
		[Embed(source = '../graphics/bouncer/offend/frame0004.png')]private static const attack4:Class;
		[Embed(source = '../graphics/bouncer/offend/frame0005.png')]private static const attack5:Class;
		[Embed(source = '../graphics/bouncer/offend/frame0006.png')]private static const attack6:Class;
		[Embed(source='../graphics/bouncer/offend/frame0007.png')]private static const attack7:Class;
		//zombie parts
		[Embed(source = '../graphics/body parts/Bouncer/b0.png')]private static const part0:Class;
		[Embed(source = '../graphics/body parts/Bouncer/b1.png')]private static const part1:Class;
		[Embed(source = '../graphics/body parts/Bouncer/b2.png')]private static const part2:Class;
		[Embed(source = '../graphics/body parts/Bouncer/b3.png')]private static const part3:Class;
		[Embed(source = '../graphics/body parts/Bouncer/b4.png')]private static const part4:Class;
		[Embed(source = '../graphics/body parts/Bouncer/b5.png')]private static const part5:Class;
		[Embed(source = '../graphics/body parts/Bouncer/b6.png')]private static const part6:Class;
		[Embed(source = '../graphics/body parts/Bouncer/b7.png')]private static const part7:Class;
		[Embed(source = '../graphics/body parts/Bouncer/b8.png')]private static const part8:Class;
		[Embed(source='../graphics/body parts/Bouncer/b9.png')]private static const part9:Class;
		private var body:Sprite;
		private var blood:Sprite; 
		public function Bouncer(owner:Owner = null):void {
			var still:Clip = new Clip(12, [new still1(), new still2(), new still3()]);
			var transit:Clip = new Clip(15, [new walk1(), new walk2(), new walk3(), new walk4(), new walk5(), new walk6(), new walk7(), new walk8(), new walk9(), new walk10()]);
			var offend:Clip = new Clip(12, [new attack1(), new attack2(), new attack3(), new attack4(), new attack5(), new attack6(), new attack7()]);
			still.loop = transit.loop = true;
			if (owner == null) {
				owner = new Owner();
			}
			super(owner, still, transit, offend, 26, 1000000, 500, 160, 1, 225, 3000);
		}
		/*The physical attack move, deals damage.*/
		override protected function attack(target:Destructable):void {
			if (coolTimer.running == true) {
				return;
			}
			if (Point.distance(target.border.anchor, border.anchor) - movementSpeed <= radius + target.radius) {
				rotation = 90 + 180 / Math.PI * Math.atan2(target.y - border.anchor.y, target.x - border.anchor.x);
				target.health -= damage;
				coolTimer.start();
				move(border.anchor);
				offend.currentFrame = 0;
				offend.onComplete = coolDownAnimation;
				//oncomplete
				//Plays attacking animation.
				removeChildAt(0);
				addChild(offend);
				offend.x = -offend.width / 2;
				offend.y = -offend.height / 2;
				//if(target is Structure == false){
				//borrowed lunge() code from crawler, for bounce dynamic
				var v:LinearVector = new LinearVector(this.border.anchor, new Point());
				v.direction = (90 - rotation) / 180 * Math.PI;
				v.direction = Math.atan2(-Math.sin(v.direction), Math.cos(v.direction));
				v.magnitude = 125;
				var kid:Vector = v.getFirstCollider(Hero.staticObstacles);
				if (kid == null) {
					SmoothTween.add(target, v.destination, 100);
				}else {
					v.destination = v.getCollision(kid);
					v.magnitude -= target.radius;
					var copy:RadialVector = new RadialVector(v.destination, 0, 0, 15);;
					while (copy.collisionOccurs(Hero.staticObstacles)) {
						v.magnitude -= 3;
						copy.anchor = v.destination;
						if (v.magnitude < 0) {
							v.magnitude = 0;
							break;
						}
					}
					SmoothTween.add(target, v.destination, 100);
				}
					//end lunge
				//}
			}else {
				var vd:LinearVector = new LinearVector(border.anchor, target.border.anchor);
				move(vd.getCollision(target.border));
				if (path.length == 1) {
					targeter.delay = 150;
				}else if(path.length > 1) {
					targeter.delay = 3000;
				}else {
					targeter.delay = 5000;
				}
			}
		}
		//DESTRUCT
		override protected function destruct():void {
			AmbientZombies.splatter();
			Global.monies += Global.bouncerPayout;
			clearMember(this);
			Main.reference.endLevelMaybe();
			moveTimer.stop();
			followTimer.stop();
			coolTimer.stop();
			targeter.stop();
			
			if (parent != null) {
				var i:uint = Math.floor(Math.random() * Splatter.members.length - .001);
				var rey:Array = new Array();
				for (var a:uint = 0; a < Splatter.members[i].length; a++) {
					rey.push(Splatter.members[i][a].clone())
					rey[rey.length - 1].y -= rey[rey.length - 1].height / 2;
				}
				var c:Clip = new Clip(30, rey);
				c.x = x;
				c.y = y;
				destructLayer.addChild(c);
				c.rotation = Math.atan2(Hero.hero.y - c.y, Hero.hero.x - c.x) * 180 / Math.PI + 180;
				body = new Sprite();
				var p0:Bitmap = new part0();
				p0.x = 24;
				p0.y = 58 - height / 2;
				var p1:Bitmap = new part1();
				p1.x = 39;
				p1.y = 0 - height / 2;
				var p2:Bitmap = new part2();
				p2.x = 34;
				p2.y = 55 - height / 2;
				var p3:Bitmap = new part3();
				p3.x = 34;
				p3.y = 41 - height / 2;
				var p4:Bitmap = new part4();
				p4.x = 22;
				p4.y = 12 - height / 2;
				var p5:Bitmap = new part5();
				p5.x = 32;
				p5.y = 23 - height / 2;
				var p6:Bitmap = new part6();
				p6.x = 2;
				p6.y = 20 - height / 2;
				var p7:Bitmap = new part7();
				p7.x = 16;
				p7.y = 35 - height / 2;
				var p8:Bitmap = new part8();
				p8.x = 1;
				p8.y = 38 - height / 2;
				var p9:Bitmap = new part9();
				p9.x = 1;
				p9.y = 49 - height / 2;
				body.addChild(p0);
				body.addChild(p1);
				body.addChild(p2);
				body.addChild(p3);
				body.addChild(p4);
				body.addChild(p5);
				body.addChild(p6);
				body.addChild(p7);
				body.addChild(p8);
				body.addChild(p9);
				body.rotation = rotation;
				body.x = x;
				body.y = y;
				
				var dist:Number = Point.distance(Splatter.fin.anchor, Splatter.ini.anchor);
				var ang:Number = Math.atan2(y - Hero.hero.y, x - Hero.hero.x) - (rotation) / 180 * Math.PI;
				var radz:RadialVector = new RadialVector(new Point(Math.cos(ang) * dist, Math.sin(ang) * dist), 0, 0, Splatter.fin.radius);
				var p:Point = Splatter.fin.generateInternalPoint();
				p.x *= -1;
				Tween.add(p0, p, 75);
				p = radz.generateInternalPoint();
				p.x *= -1;
				Tween.add(p1, p, 75);
				p = radz.generateInternalPoint();
				p.x *= -1;
				Tween.add(p2, p, 75);
				p = radz.generateInternalPoint();
				p.x *= -1;
				Tween.add(p3, p, 75);
				p = radz.generateInternalPoint();
				p.x *= -1;
				Tween.add(p4, p, 75);
				p = radz.generateInternalPoint();
				p.x *= -1;
				Tween.add(p5, p, 75);
				p = radz.generateInternalPoint();
				p.x *= -1;
				Tween.add(p6, p, 75);
				p = radz.generateInternalPoint();
				p.x *= -1;
				Tween.add(p7, p, 75);
				p = radz.generateInternalPoint();
				p.x *= -1;
				Tween.add(p8, p, 75);
				p = radz.generateInternalPoint();
				p.x *= -1;
				Tween.add(p9, p, 75);
				destructLayer.addChild(body);
				
				parent.removeChild(this);
				/*
				var v:DiffusionMap = new DiffusionMap(this);
				parent.addChild(v);
				v.start(8, 2, 2, true, true);
				parent.removeChild(this);
				*/
				blood = c;
				
				var t:Timer = new Timer(150, 1);	//needs to happen after the death animations play.
				t.addEventListener(TimerEvent.TIMER_COMPLETE, staticize);
				t.start();
			}
		}
		private function staticize(e:TimerEvent):void {
			body.parent.removeChild(body);
			blood.parent.removeChild(blood);
			Main.oldGuts.add(blood, new Point(-Main.oldGuts.x, -Main.oldGuts.y));
			Main.oldGuts.add(body, new Point(-Main.oldGuts.x, -Main.oldGuts.y));
		}
	}
	
}