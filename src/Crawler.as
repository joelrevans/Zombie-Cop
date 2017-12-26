package 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import SmoothTween;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class Crawler extends DestructableMeleeFighter
	{
		//walk animation
		[Embed(source='../graphics/Crawler/walk/frame0001.png')]private static const walk1:Class;
		[Embed(source='../graphics/Crawler/walk/frame0002.png')]private static const walk2:Class;
		[Embed(source='../graphics/Crawler/walk/frame0003.png')]private static const walk3:Class;
		[Embed(source='../graphics/Crawler/walk/frame0004.png')]private static const walk4:Class;
		[Embed(source='../graphics/Crawler/walk/frame0005.png')]private static const walk5:Class;
		[Embed(source='../graphics/Crawler/walk/frame0006.png')]private static const walk6:Class;
		[Embed(source='../graphics/Crawler/walk/frame0007.png')]private static const walk7:Class;
		[Embed(source = '../graphics/Crawler/walk/frame0008.png')]private static const walk8:Class;
		//stand animation
		[Embed(source = '../graphics/Crawler/still/frame0001.png')]private static const stand1:Class;
		[Embed(source = '../graphics/Crawler/still/frame0002.png')]private static const stand2:Class;
		[Embed(source='../graphics/Crawler/still/frame0003.png')]private static const stand3:Class;
		//attack animation
		[Embed(source = '../graphics/Crawler/attack/frame0001.png')]private static const attack1:Class;
		[Embed(source = '../graphics/Crawler/attack/frame0002.png')]private static const attack2:Class;
		[Embed(source = '../graphics/Crawler/attack/frame0003.png')]private static const attack3:Class;
		[Embed(source = '../graphics/Crawler/attack/frame0004.png')]private static const attack4:Class;
		[Embed(source = '../graphics/Crawler/attack/frame0005.png')]private static const attack5:Class;
		[Embed(source = '../graphics/Crawler/attack/frame0006.png')]private static const attack6:Class;
		[Embed(source = '../graphics/Crawler/attack/frame0007.png')]private static const attack7:Class;
		[Embed(source = '../graphics/Crawler/attack/frame0008.png')]private static const attack8:Class;
		[Embed(source = '../graphics/Crawler/attack/frame0009.png')]private static const attack9:Class;
		[Embed(source = '../graphics/Crawler/attack/frame0010.png')]private static const attack10:Class;
		[Embed(source = '../graphics/Crawler/attack/frame0011.png')]private static const attack11:Class;
		[Embed(source = '../graphics/Crawler/attack/frame0012.png')]private static const attack12:Class;
		[Embed(source = '../graphics/Crawler/attack/frame0013.png')]private static const attack13:Class;
		//splatter chunks
		[Embed(source = '../graphics/body parts/Crawler/c1.png')]private static const part1:Class;
		[Embed(source = '../graphics/body parts/Crawler/c2.png')]private static const part2:Class;
		[Embed(source = '../graphics/body parts/Crawler/c3.png')]private static const part3:Class;
		[Embed(source = '../graphics/body parts/Crawler/c4.png')]private static const part4:Class;
		[Embed(source = '../graphics/body parts/Crawler/c5.png')]private static const part5:Class;
		[Embed(source = '../graphics/body parts/Crawler/c6.png')]private static const part6:Class;
		[Embed(source = '../graphics/body parts/Crawler/c7.png')]private static const part7:Class;
		private var body:Sprite;
		private var blood:Sprite; 
		/*Creates a new Crawler Unit
		 *@param owner The owner of the unit.  If this value is left blank, the unit will be hostile to all other Destructables.*/
		public function Crawler(owner:Owner = null):void {
			var still:Clip = new Clip(8, [new stand1(), new stand2(), new stand3()]);
			var transit:Clip = new Clip(15, [new walk1(), new walk2(), new walk3(), new walk4(), new walk5(), new walk6(), new walk7(), new walk8()]);
			var offend:Clip = new Clip(20, [new attack1(), new attack2(), new attack3(), new attack4(), new attack5(), new attack6(), new attack7(), new attack8(), new attack9(), new attack10(), new attack11(), new attack12(), new attack13()]);
			still.loop = transit.loop = true;
			offend.loop = false;
			if (owner == null) {
				owner = new Owner();
			}
			super(owner, still, transit, offend, 12, 100000, 2500, 240, 1, 50, 1500);
		}
		/*The physical attack move, deals damage.*/
		override protected function attack(target:Destructable):void {
			if (Point.distance(target.border.anchor, border.anchor) - movementSpeed <= radius + target.radius + 30) {
				if (coolTimer.running == false) {
					target.health -= damage;
					coolTimer.start();
					move(border.anchor);
					offend.onComplete = coolDownAnimation;
					//oncomplete
					lunge();
					//Plays attacking animation.
					removeChildAt(0);
					addChild(offend);
					offend.x = -offend.width / 2;
					offend.y = -offend.height / 2;
				}else {
					move(border.anchor);
				}
			}else {
				var v:LinearVector = new LinearVector(border.anchor, target.border.anchor);
				move(v.getCollision(target.border));
				if (path.length == 1) {
					targeter.delay = 150;
				}else if(path.length > 1) {
					targeter.delay = 3000;
				}else {
					targeter.delay = 5000;
				}
			}
		}
		private function lunge():void {
			var v:LinearVector = new LinearVector(this.border.anchor, new Point);
			v.direction = (90 - rotation) / 180 * Math.PI;
			v.direction = Math.atan2( -Math.sin(v.direction), Math.cos(v.direction));
			v.magnitude = 125;
			var l:Vector = v.getFirstCollider(Hero.staticObstacles);
			if (l != null) {
				v.destination = v.getCollision(l);
				v.magnitude -= radius;
			}
			SmoothTween.add(this, v.destination, 100);
		}
		//Abstract death function.
		override protected function destruct():void {
			AmbientZombies.splatter();
			clearMember(this);
			Main.reference.endLevelMaybe();
			Global.monies += Global.crawlerPayout;
			moveTimer.stop();
			followTimer.stop();
			coolTimer.stop();
			targeter.stop();
			
			if (parent != null) {
				var i:uint = Math.floor(Math.random() * Splatter.members.length - .001);
				var rey:Array = new Array();
				//trace(Splatter.members[i].length, a);
				for (var a:uint = 0; a < Splatter.members[i].length; a++) {
					rey.push(Splatter.members[i][a].clone());
					rey[rey.length - 1].y -= rey[rey.length - 1].height / 2;
				}
				var c:Clip = new Clip(30, rey);
				c.x = x;
				c.y = y;
				destructLayer.addChild(c);
				c.rotation = Math.atan2(Hero.hero.y - c.y, Hero.hero.x - c.x) * 180 / Math.PI + 180;
				
				body = new Sprite();
				var p1:Bitmap = new part1();
				p1.x = 1;
				p1.y = 1 - height / 2;
				var p2:Bitmap = new part2();
				p2.x = 1;
				p2.y = 7 - height / 2;
				var p3:Bitmap = new part3();
				p3.x = 16;
				p3.y = 1 - height / 2;
				var p4:Bitmap = new part4();
				p4.x = 14;
				p4.y = 20 - height / 2;
				var p5:Bitmap = new part5();
				p5.x = 3;
				p5.y = 20 - height / 2;
				var p6:Bitmap = new part6();
				p6.x = 2;
				p6.y = 45 - height / 2;
				var p7:Bitmap = new part7();
				p7.x = 13;
				p7.y = 37 - height / 2;
				body.addChild(p1);
				body.addChild(p2);
				body.addChild(p3);
				body.addChild(p4);
				body.addChild(p5);
				body.addChild(p6);
				body.addChild(p7);
				body.rotation = rotation;
				body.x = x;
				body.y = y;
				
				var dist:Number = Point.distance(Splatter.fin.anchor, Splatter.ini.anchor);
				var ang:Number = Math.atan2(y - Hero.hero.y, x - Hero.hero.x) - (rotation) / 180 * Math.PI;
				var radz:RadialVector = new RadialVector(new Point(Math.cos(ang) * dist, Math.sin(ang) * dist), 0, 0, Splatter.fin.radius);
				var p:Point = Splatter.fin.generateInternalPoint();
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