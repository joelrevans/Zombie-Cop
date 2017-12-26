package 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.utils.Timer;
	import Global;
	/**
	 * ...
	 * @author Joel Evans
	 */
	public class Zombie extends DestructableMeleeFighter 
	{
		//still frames
		[Embed(source = '../graphics/Zombie/stand/frame0001.png')]private static const stand1:Class;
		[Embed(source = '../graphics/Zombie/stand/frame0002.png')]private static const stand2:Class;
		[Embed(source = '../graphics/Zombie/stand/frame0003.png')]private static const stand3:Class;
		//walk frames
		[Embed(source='../graphics/Zombie/walk/frame0001.png')]private static const walk1:Class;
		[Embed(source = '../graphics/Zombie/walk/frame0002.png')]private static const walk2:Class;
		[Embed(source = '../graphics/Zombie/walk/frame0003.png')]private static const walk3:Class;
		[Embed(source = '../graphics/Zombie/walk/frame0004.png')]private static const walk4:Class;
		[Embed(source = '../graphics/Zombie/walk/frame0005.png')]private static const walk5:Class;
		[Embed(source = '../graphics/Zombie/walk/frame0006.png')]private static const walk6:Class;
		[Embed(source = '../graphics/Zombie/walk/frame0007.png')]private static const walk7:Class;
		[Embed(source = '../graphics/Zombie/walk/frame0008.png')]private static const walk8:Class;
		[Embed(source = '../graphics/Zombie/walk/frame0009.png')]private static const walk9:Class;
		[Embed(source = '../graphics/Zombie/walk/frame0010.png')]private static const walk10:Class;
		[Embed(source = '../graphics/Zombie/walk/frame0011.png')]private static const walk11:Class;
		[Embed(source = '../graphics/Zombie/walk/frame0012.png')]private static const walk12:Class;
		[Embed(source = '../graphics/Zombie/walk/frame0013.png')]private static const walk13:Class;
		[Embed(source = '../graphics/Zombie/walk/frame0014.png')]private static const walk14:Class;
		[Embed(source = '../graphics/Zombie/walk/frame0015.png')]private static const walk15:Class;
		//attack frames
		[Embed(source = '../graphics/Zombie/attack1/frame0001.png')]private static const attack1:Class;
		[Embed(source = '../graphics/Zombie/attack1/frame0002.png')]private static const attack2:Class;
		[Embed(source = '../graphics/Zombie/attack1/frame0003.png')]private static const attack3:Class;
		[Embed(source = '../graphics/Zombie/attack1/frame0004.png')]private static const attack4:Class;
		[Embed(source = '../graphics/Zombie/attack1/frame0005.png')]private static const attack5:Class;
		[Embed(source = '../graphics/Zombie/attack1/frame0006.png')]private static const attack6:Class;
		[Embed(source='../graphics/Zombie/attack1/frame0007.png')]private static const attack7:Class;
		[Embed(source = '../graphics/Zombie/attack1/frame0008.png')]private static const attack8:Class;
		[Embed(source='../graphics/Zombie/attack1/frame0009.png')]private static const attack9:Class;
		//body parts
		[Embed(source = '../graphics/body parts/Zombie/z1.png')]private static const part1:Class;
		[Embed(source = '../graphics/body parts/Zombie/z2.png')]private static const part2:Class;
		[Embed(source = '../graphics/body parts/Zombie/z3.png')]private static const part3:Class;
		[Embed(source = '../graphics/body parts/Zombie/z4.png')]private static const part4:Class;
		[Embed(source = '../graphics/body parts/Zombie/z5.png')]private static const part5:Class;
		[Embed(source = '../graphics/body parts/Zombie/z6.png')]private static const part6:Class;
		[Embed(source='../graphics/body parts/Zombie/z7.png')]private static const part7:Class;
		//public static var owner:Owner = new Owner();		
		private var body:Sprite;
		private var blood:Sprite; 
		
		/*Creates a new Zombie Unit
		 *@param owner The owner of the unit.  If this value is left blank, the unit will be hostile to all other Destructables.*/
		public function Zombie(owner:Owner = null):void {
			/*Images*/
			var clip1:Clip = new Clip(20, [new attack1(), new attack2(), new attack3(), new attack4(), new attack5(), new attack6(), new attack7(), new attack8(), new attack9()]);
			var clip2:Clip = new Clip(20, [new stand1(), new stand2(), new stand3()]);
			var clip3:Clip = new Clip(20, [new walk1(), new walk2(), new walk3(), new walk4(), new walk5(), new walk6(), new walk7(), new walk8(), new walk9(), new walk10(), new walk11(), new walk12(), new walk13(), new walk14(), new walk15()]);
			clip2.loop = clip3.loop = true;
			/*Images*/
			if (owner == null) {
				owner = new Owner();
			}
			super(owner, clip2, clip3, clip1, 20, 10000000, 1000, 175, 1, (Global.level==1)?5:100, 3000);
		}
		override protected function destruct():void {
			AmbientZombies.splatter();
			clearMember(this);
			Main.reference.endLevelMaybe();
			Global.monies += Global.zombiePayout;
			moveTimer.stop();
			followTimer.stop();
			coolTimer.stop();
			targeter.stop();
			
			if (parent != null) {
				var i:uint = Math.floor(Math.random() * Splatter.members.length - .001);
				var rey:Array = new Array();
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
				p1.x = 2;
				p1.y = 28 - height / 2;
				var p2:Bitmap = new part2();
				p2.x = 0;
				p2.y = 0 - height / 2;
				var p3:Bitmap = new part3();
				p3.x = 11;
				p3.y = 32 - height / 2;
				var p4:Bitmap = new part4();
				p4.x = 21;
				p4.y = 0 - height / 2;
				var p5:Bitmap = new part5();
				p5.x = 8;
				p5.y = 24 - height / 2;
				var p6:Bitmap = new part6();
				p6.x = 6;
				p6.y = 1 - height / 2;
				var p7:Bitmap = new part7();
				p7.x = 17;
				p7.y = 10 - height / 2;
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