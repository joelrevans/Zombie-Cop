package 
{
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	import flash.display.Bitmap;
	import flash.display.Sprite;
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */	
	public class Mosher extends DestructableMeleeFighter
	{
		//Still
		[Embed(source='../graphics/Mosher/still/frame0001.png')]private static const still1:Class;
		[Embed(source='../graphics/Mosher/still/frame0002.png')]private static const still2:Class;
		[Embed(source='../graphics/Mosher/still/frame0003.png')]private static const still3:Class;
		//Attack
		[Embed(source='../graphics/Mosher/offend/frame0001.png')]private static const attack1:Class;
		[Embed(source='../graphics/Mosher/offend/frame0002.png')]private static const attack2:Class;
		[Embed(source='../graphics/Mosher/offend/frame0003.png')]private static const attack3:Class;
		[Embed(source='../graphics/Mosher/offend/frame0004.png')]private static const attack4:Class;
		[Embed(source='../graphics/Mosher/offend/frame0005.png')]private static const attack5:Class;
		[Embed(source='../graphics/Mosher/offend/frame0006.png')]private static const attack6:Class;
		[Embed(source='../graphics/Mosher/offend/frame0007.png')]private static const attack7:Class;
		[Embed(source='../graphics/Mosher/offend/frame0008.png')]private static const attack8:Class;
		//Hold
		[Embed(source='../graphics/Mosher/hold/frame0001.png')]private static const hold1:Class;
		[Embed(source='../graphics/Mosher/hold/frame0002.png')]private static const hold2:Class;
		[Embed(source='../graphics/Mosher/hold/frame0003.png')]private static const hold3:Class;
		[Embed(source='../graphics/Mosher/hold/frame0004.png')]private static const hold4:Class;
		[Embed(source='../graphics/Mosher/hold/frame0005.png')]private static const hold5:Class;
		[Embed(source='../graphics/Mosher/hold/frame0006.png')]private static const hold6:Class;
		[Embed(source='../graphics/Mosher/hold/frame0007.png')]private static const hold7:Class;
		[Embed(source = '../graphics/Mosher/hold/frame0008.png')]private static const hold8:Class;
		//body parts
		[Embed(source = '../graphics/body parts/Mosher/m1.png')]private static const part1:Class;
		[Embed(source = '../graphics/body parts/Mosher/m2.png')]private static const part2:Class;
		[Embed(source = '../graphics/body parts/Mosher/m3.png')]private static const part3:Class;
		[Embed(source = '../graphics/body parts/Mosher/m4.png')]private static const part4:Class;
		[Embed(source = '../graphics/body parts/Mosher/m5.png')]private static const part5:Class;
		[Embed(source = '../graphics/body parts/Mosher/m6.png')]private static const part6:Class;
		[Embed(source='../graphics/body parts/Mosher/m7.png')]private static const part7:Class;
		private var holder:Clip;
		private var holdTime:Timer = new Timer(10);
		private var grabbed:Hero;
		private var body:Sprite;
		private var blood:Sprite; 
		
		public function Mosher(owner:Owner = null):void{
			var still:Clip = new Clip(12, [new still1(), new still2(), new still3()]);
			var offend:Clip = new Clip(15, [new attack1(), new attack2(), new attack3(), new attack4(), new attack5(), new attack6(), new attack7(), new attack8()]);
			holder = new Clip(20, [new hold1(), new hold2(), new hold3(), new hold4(), new hold5(), new hold6(), new hold7(), new hold8()]);
			if (owner == null) {
				owner = new Owner();
			}
			super(owner, still, still, offend, 20, 1000000, 4000, 180, 1, 100, 2000);
			holdTime.addEventListener(TimerEvent.TIMER, tangle);
		}
		
		/*Identifies hero unit, chases, and initiates attack when appropriate.*/
		override protected function scan(e:*):void {
			for (var i:uint = 0; i < Destructable.members.length; i++) {
				if (Destructable.members[i] is Hero) {
					buhtack(Destructable.members[i]);
					return;
				}
			}
		}
		/*The physical attack move, deals damage.*/
		private function buhtack(target:Hero):void {
			if (holdTime.running == true) {
				return;
			}
			if (Point.distance(target.border.anchor, border.anchor) - movementSpeed <= radius + target.radius) {
				rotation = 90 + 180 / Math.PI * Math.atan2(target.y - border.anchor.y, target.x - border.anchor.x);
				target.health -= damage;
				holdTime.start();
				move(border.anchor);
				offend.currentFrame = 0;
				offend.frameRate = 15;
				offend.onComplete = coolDownAnimation;
				targeter.stop();
				grabbed = target;
				//Plays attacking animation.
				removeChildAt(0);
				addChild(offend);
				offend.x = -offend.width / 2;
				offend.y = -offend.height / 2;
				grabbed.x += (x - grabbed.x) / 18;
				grabbed.y += (y - grabbed.y) / 18;
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
		override protected function coolDownAnimation():void {
			offend.onComplete = new Function();
			removeChildAt(0);
			addChild(holder);
			holder.currentFrame = 0;
			holder.loop = true;
			holder.frameRate = 12;
			holder.x = -holder.width / 2;
			holder.y = -holder.height / 2;
		}
		/*Holds the unit in place*/
		private function tangle(e:TimerEvent):void {
			if (Point.distance(new Point(x, y), new Point(grabbed.x, grabbed.y)) > 32) {
				if (offend.frameRate != 0) {
					return;
				}
				holdTime.stop();
				//holdTime.removeEventListener(TimerEvent.TIMER, tangle);
				grabbed = null;
				removeChildAt(0);
				addChild(offend);
				offend.currentFrame = offend.totalFrames - 1;
				offend.frameRate = -12;
				offend.onComplete = targeter.start;
				return;
			}
			grabbed.x += (x - grabbed.x) / 18;
			grabbed.y += (y - grabbed.y) / 18;
			//grabbed.health -= damage;
		}
		override protected function destruct():void {
			AmbientZombies.splatter();
			Global.monies += Global.mosherPayout;
			/*if (grabbed != null) {
				grabbed.x = x;
				grabbed.y = y;
			}*/
			//RELEASES THE HOLD
			holdTime.stop();
			holdTime.removeEventListener(TimerEvent.TIMER, tangle);
			//END
			
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
				p1.x = 36;
				p1.y = 1 - height / 2;
				var p2:Bitmap = new part2();
				p2.x = 20;
				p2.y = 26 - height / 2;
				var p3:Bitmap = new part3();
				p3.x = 34;
				p3.y = 25 - height / 2;
				var p4:Bitmap = new part4();
				p4.x = 0;
				p4.y = 1 - height / 2;
				var p5:Bitmap = new part5();
				p5.x = 15;
				p5.y = 39 - height / 2;
				var p6:Bitmap = new part6();
				p6.x = 36;
				p6.y = 38 - height / 2;
				var p7:Bitmap = new part7();
				p7.x = 41;
				p7.y = 15 - height / 2;
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