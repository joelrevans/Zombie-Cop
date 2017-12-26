package 
{
	import flash.display.Bitmap
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.events.TimerEvent;
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class Longarm extends DestructableMeleeFighter
	{
		//character walking
		[Embed(source = '../graphics/longarm/still/frame0001.png')]private static const stand1:Class;
		[Embed(source = '../graphics/longarm/still/frame0002.png')]private static const stand2:Class;
		[Embed(source = '../graphics/longarm/still/frame0003.png')]private static const stand3:Class;
		//character attack
		[Embed(source = '../graphics/longarm/offend/frame0001.png')]private static const attack1:Class;
		[Embed(source = '../graphics/longarm/offend/frame0002.png')]private static const attack2:Class;
		[Embed(source = '../graphics/longarm/offend/frame0003.png')]private static const attack3:Class;
		[Embed(source = '../graphics/longarm/offend/frame0004.png')]private static const attack4:Class;
		[Embed(source = '../graphics/longarm/offend/frame0005.png')]private static const attack5:Class;
		[Embed(source = '../graphics/longarm/offend/frame0006.png')]private static const attack6:Class;
		[Embed(source = '../graphics/longarm/offend/frame0007.png')]private static const attack7:Class;
		[Embed(source = '../graphics/longarm/offend/frame0008.png')]private static const attack8:Class;
		[Embed(source = '../graphics/longarm/offend/frame0009.png')]private static const attack9:Class;
		[Embed(source = '../graphics/longarm/offend/frame0010.png')]private static const attack10:Class;
		[Embed(source = '../graphics/longarm/offend/frame0011.png')]private static const attack11:Class;
		[Embed(source = '../graphics/longarm/offend/frame0012.png')]private static const attack12:Class;
		[Embed(source = '../graphics/longarm/offend/frame0013.png')]private static const attack13:Class;
		[Embed(source = '../graphics/longarm/offend/frame0014.png')]private static const attack14:Class;
		[Embed(source = '../graphics/longarm/offend/frame0015.png')]private static const attack15:Class;
		[Embed(source = '../graphics/longarm/offend/frame0016.png')]private static const attack16:Class;
		[Embed(source = '../graphics/longarm/offend/frame0017.png')]private static const attack17:Class;
		[Embed(source = '../graphics/longarm/offend/frame0018.png')]private static const attack18:Class;
		[Embed(source = '../graphics/longarm/offend/frame0019.png')]private static const attack19:Class;
		[Embed(source='../graphics/longarm/offend/frame0020.png')]private static const attack20:Class;
		//body parts
		[Embed(source = '../graphics/body parts/Longarm/l1.png')]private static const part1:Class;
		[Embed(source = '../graphics/body parts/Longarm/l2.png')]private static const part2:Class;
		[Embed(source = '../graphics/body parts/Longarm/l3.png')]private static const part3:Class;
		[Embed(source = '../graphics/body parts/Longarm/l4.png')]private static const part4:Class;
		[Embed(source = '../graphics/body parts/Longarm/l5.png')]private static const part5:Class;
		[Embed(source = '../graphics/body parts/Longarm/l6.png')]private static const part6:Class;
		[Embed(source = '../graphics/body parts/Longarm/l7.png')]private static const part7:Class;
		[Embed(source = '../graphics/body parts/Longarm/l8.png')]private static const part8:Class;
		[Embed(source='../graphics/body parts/Longarm/l9.png')]private static const part9:Class;
		private var body:Sprite;
		private var blood:Sprite; 
		
		/*Creates a new Longarm Unit.
		 *@param owner The owner of the unit.  If this value is left blank, the unit will be hostile to all other Destructables.*/
		public function Longarm(owner:Owner = null):void {
			/*Images*/
			var still:Clip = new Clip(12, [new stand1(), new stand2(), new stand3()]);
			var offend:Clip = new Clip(20, [new attack1(), new attack2(), new attack3(), new attack4(), new attack5(), new attack6(), new attack7(), new attack8(), new attack9(), new attack10(), new attack11(), new attack12(), new attack13(), new attack14(), new attack15(), new attack16(), new attack17(), new attack18(), new attack19(), new attack20()]);
			still.loop = true;
			for (var i:uint = 0; i < offend.totalFrames; i++) {
				offend.getFrame(i).x = 6;
				offend.getFrame(i).y = -38;
			}
			/*Images*/
			if (owner == null) {
				owner = new Owner();
			} 
			still.loop = offend.loop = true;
			super(owner, still, still, offend, 100, 1000000, 2000, 150, 1, 100, 3000);
		}
		override protected function destruct():void {
			AmbientZombies.splatter();
			Global.monies += Global.longarmPayout;
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
				var p1:Bitmap = new part1();
				p1.x = 24;
				p1.y = 8 - height / 2;
				var p2:Bitmap = new part2();
				p2.x = 26;
				p2.y = 10 - height / 2;
				var p3:Bitmap = new part3();
				p3.x = 30;
				p3.y = 3 - height / 2;
				var p4:Bitmap = new part4();
				p4.x = 10;
				p4.y = 5 - height / 2;
				var p5:Bitmap = new part5();
				p5.x = 11;
				p5.y = 18 - height / 2;
				var p6:Bitmap = new part6();
				p6.x = 0;
				p6.y = 42 - height / 2;
				var p7:Bitmap = new part7();
				p7.x = 22;
				p7.y = 59 - height / 2;
				var p8:Bitmap = new part8();
				p8.x = 25;
				p8.y = 72 - height / 2;
				var p9:Bitmap = new part9();
				p9.x = 30;
				p9.y = 33 - height / 2;
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