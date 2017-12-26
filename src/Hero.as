package 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundTransform;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author Joel Evans
	 */
	public class Hero extends Destructable 
	{
		public var healthIndicator:Clip;	//A specially-cusomized variable for this game, not part of the framework.
		
		public static var staticObstacles:Array = new Array();
		
		public static var hero:Hero;
		
		private var movementSpeed:Number;	//Movement speed (pixels / second)
		private var rotator:Timer = new Timer(25);
		private var mover:Timer = new Timer(10);
		private var direction:Number;
		
		private var transit:Clip;
		private var still:Clip;
		private var offend:Clip;
		private var coolDown:Timer = new Timer(10);
		private var damage:Number;
		public var damageTimer:Timer = new Timer(200, 1);
		public var regenerator:Timer = new Timer(7500, 0);
		
		private var switchTo:String = "pistol";	//used to delay weapon switches during firing
		private var attacking:Boolean = false;
		
		private var cameraShaker : Shake;
		
		public function Hero(owner:Owner):void {
			hero = this;
			super(owner, 15, 6);
			
			regenerator.addEventListener(TimerEvent.TIMER, heal);
			regenerator.start();
			
			generateHeroImages();
			addChild(new Sprite());	//Add a blank sprite so that setState() can remove index 0;
			setState("pistol");
			
			rotator.addEventListener(TimerEvent.TIMER, roto);
			rotator.start();
			
			addChild(still);
			still.x = -still.width / 2;
			still.y = -still.height / 2;
			
			cameraShaker = new Shake();
			cameraShaker.target = Main.reference.cammy;
		}
		/*Moves the unit in a specified direction.
		 * @param direcion Direction, in radians, for the unit to move.*/
		public function move(direction:Number):void {
			this.direction = direction;
			/*Manages appearance*/
			if (coolDown.running == false && mover.running == false) {
				removeChildAt(0);
				addChild(transit);
				transit.x = -transit.width / 2;
				transit.y = -transit.height / 2;
			}
			/*End appearance*/
			mover.addEventListener(TimerEvent.TIMER, moving);
			mover.start();
		}
		private function moving(e:TimerEvent):void {	//Keeps the unit moving once the command has been given.
			var next:RadialVector = new RadialVector(new Point(x + Math.cos(direction) * movementSpeed, y + Math.sin(direction) * movementSpeed), 0, 0, 15);
			if (next.collisionOccurs(staticObstacles) == true) {
				return;
			}
			x += movementSpeed * Math.cos(direction);
			y += movementSpeed * Math.sin(direction);
		}
		/*Stops the unit from moving.*/
		public function stop():void {
			/*Manages appearance*/
			if(coolDown.running == false){
				removeChildAt(0);
				addChild(still);
				still.x = -still.width / 2;
				still.y = -still.height / 2;
			}
			/*End appearance*/
			mover.removeEventListener(TimerEvent.TIMER, moving);
			mover.stop();
		}
			/*Sets the movement speed of the unit.*/
		public function set moveSpeed(value:uint):void {
			movementSpeed = value / 1000 * mover.delay;
		}
		/*The movement speed of the unit.*/
		public function get moveSpeed():uint {
			return movementSpeed * 1000 / mover.delay;
		}
		/*The health of the unit.*/
		override public function set health(value:Number):void {
			if (damageTimer.running) {
				return;
			}else {
				damageTimer.start();
			}
			if (value <= 0) {
				healthIndicator.currentFrame = 6;
				Main.reference.death();
				return;
			}else if (value > 6) {
				value = 6;
			}
			if (6 - value > healthIndicator.currentFrame) {
				/*SHAKES THE CAMERA.  BRILLIANT, I KNOW.*/
				//cameraShaker.stop();
				cameraShaker.start(75, 0.92, 1000);
			}
			healthIndicator.currentFrame = 6 - value;
		}
		override public function get health():Number {
			return 6 - healthIndicator.currentFrame;
		}
		/*Regenerates the hero's health periodically.*/
		private function heal(e:TimerEvent):void {
			health++;
		}
		private function switcheroo(e:TimerEvent):void {
			coolDown.removeEventListener(TimerEvent.TIMER_COMPLETE, switcheroo);
			setState(switchTo);
		}
		/*Changes the weapon state && appearance of the hero unit.*/
		public function setState(str:String):void {
			if (coolDown.running) {
				attacking = (coolDown.repeatCount) ? false : true;
				ceaseProtocol();
				switchTo = str;
				coolDown.addEventListener(TimerEvent.TIMER_COMPLETE, switcheroo);
				attackProtocol = function():void { attacking = true }
				ceaseProtocol = function():void { attacking = false }
				return;
			}
			//coolDown.stop();
			switch(str) {
				case "pistol":
				still = pistolStill;
				transit = pistolWalking;
				offend = pistolAttack;
				attackProtocol = pistolAttackProtocol;
				ceaseProtocol = pistolCeaseProtocol;
				coolDown.delay = Global.weaponUpgrade[0][2][Global.weaponUpgrade[0][2][0][1]][0];
				moveSpeed = Global.weaponUpgrade[0][3][Global.weaponUpgrade[0][3][0][1]][0];
				//moveSpeed = 1000;
				break;
				case "shotgun":
				still = shottyStill;
				transit = shottyWalking;
				offend = shottyAttack;
				attackProtocol = shogunAttackProtocol;
				ceaseProtocol = shotgunCeaseProtocol;
				moveSpeed = Global.weaponUpgrade[1][3][Global.weaponUpgrade[1][3][0][1]][0];
				coolDown.delay = Global.weaponUpgrade[1][2][Global.weaponUpgrade[1][2][0][1]][0];
				break;
				case "uzi":
				still = uziStill;
				transit = uziWalking;
				offend = uziAttack;
				attackProtocol = uziAttackProtocol;
				ceaseProtocol = uziCeaseProtocol;
				moveSpeed = Global.weaponUpgrade[2][3][Global.weaponUpgrade[2][3][0][1]][0];
				coolDown.delay = Global.weaponUpgrade[2][2][Global.weaponUpgrade[2][2][0][1]][0] + Global.weaponUpgrade[2][5][Global.weaponUpgrade[2][5][0][1]][0] * 60;
				break;
				case "sniper":
				still = sniperStill;
				transit = sniperWalking;
				offend = sniperAttack;
				attackProtocol = sniperAttackProtocol;
				ceaseProtocol = sniperCeaseProtocol;
				moveSpeed = Global.weaponUpgrade[3][3][Global.weaponUpgrade[3][3][0][1]][0];
				coolDown.delay = Global.weaponUpgrade[3][2][Global.weaponUpgrade[3][2][0][1]][0];
				break;
				case "minigun":
				still = miniGunStill;
				transit = miniGunWalking;
				offend = miniGunAttack;
				attackProtocol = minigunAttackProtocol;
				ceaseProtocol = minigunCeaseProtocol;
				moveSpeed = Global.weaponUpgrade[4][3][Global.weaponUpgrade[4][3][0][1]][0];
				coolDown.delay = Global.weaponUpgrade[4][2][Global.weaponUpgrade[4][2][0][1]][0];
				break;
			}
			if (attacking) {
				attacking = false;
				attackProtocol();
				return;
			}
			standardCleanup();
		}
		/*Rotates the hero to face the mouse.*/
		private function roto(e:TimerEvent):void {
			if (parent != null) {
				//MouseX and MouseY are affected by rotation as well as the scale of the movieclip
				rotation = 0;
				rotation = 90 - Math.atan2(-(y + mouseY - 250), x + mouseX - 250) * 180 / Math.PI;
			}
		}
		//Runs the guns.
		public var attackProtocol:Function = new Function();
		public var ceaseProtocol:Function = new Function();
		
		/*PISTOL PROTOCOLS*/
		private function pistolAttackProtocol():void {
			coolDown.addEventListener(TimerEvent.TIMER, pistolFireProtocol);
			coolDown.repeatCount = 0;
			if (coolDown.running == false) {
				pistolFireProtocol();
				coolDown.start();
			}
		}
		private function pistolFireProtocol(...args):void {
			standardOffendShift();
			offend.frameRate = 12;
			still.frameRate = transit.frameRate = 0;
			offend.onComplete = standardCleanup;
			pistolSound.play();
			if (Global.rollover == false) {
				standardFireProtocol(Global.weaponUpgrade[0][4][Global.weaponUpgrade[0][4][0][1]][0], Global.weaponUpgrade[0][1][Global.weaponUpgrade[0][1][0][1]][0], Global.weaponUpgrade[0][0][Global.weaponUpgrade[0][0][0][1]][0]);
				//standardFireProtocol(Global.pistolAccuracy, Global.pistolRange, Global.pistolDamage);
			}else {
				standardFireProtocol(Global.weaponUpgrade[0][4][Global.weaponUpgrade[0][4][0][1]][0], Global.weaponUpgrade[0][1][Global.weaponUpgrade[0][1][0][1]][0], Global.weaponUpgrade[0][0][Global.weaponUpgrade[0][0][0][1]][0]);
				//rollOverProtocol(Global.pistolAccuracy, Global.pistolRange, Global.pistolDamage);
			}
		}
		private function pistolCeaseProtocol():void {
			coolDown.repeatCount = coolDown.currentCount + 1;
			coolDown.removeEventListener(TimerEvent.TIMER, pistolFireProtocol);
		}
		/*END PISTOL PROTOCOLS*/
		/*SHOTGUN PROTOCOLS*/
		private function shogunAttackProtocol():void {
			coolDown.addEventListener(TimerEvent.TIMER, shotgunFireProtocol);
			coolDown.repeatCount = 0;
			if (coolDown.running == false) {
				shotgunFireProtocol();
				coolDown.start();
			}
		}
		private function shotgunFireProtocol(...args):void {
			standardOffendShift();
			still.frameRate = transit.frameRate = 0;
			offend.onComplete = standardCleanup;
			offend.frameRate = 12;
			for (var i:uint = 0; i < Global.weaponUpgrade[1][5][Global.weaponUpgrade[1][5][0][1]][0]; i++){
				standardFireProtocol(Global.weaponUpgrade[1][4][Global.weaponUpgrade[1][4][0][1]][0], Global.weaponUpgrade[1][1][Global.weaponUpgrade[1][1][0][1]][0], Global.weaponUpgrade[1][0][Global.weaponUpgrade[1][0][0][1]][0]);
				//standardFireProtocol(Global.shotgunAccuracy, Global.shotgunRange, Global.shotgunDamage);
			}
			shotgunSound.play(0, 0/*, shotgunTrans*/);
		}
		private function shotgunCeaseProtocol():void {
			coolDown.removeEventListener(TimerEvent.TIMER, shotgunFireProtocol);
			coolDown.repeatCount = coolDown.currentCount + 1;
		}
		/*END SHOTGUN PROTOCOLS*/
		/*UZI PROTOCOLS.*/
		private function uziAttackProtocol():void {
			coolDown.addEventListener(TimerEvent.TIMER, uziFireProtocol);
			coolDown.repeatCount = 0;
			if (coolDown.running == false){
				uziFireProtocol();
				still.frameRate = transit.frameRate = 0;
				coolDown.start();
			}
		}
		private function uziFireProtocol(...args):void {
			standardOffendShift();
			offend.frameRate = 20;
			var t:Timer = new Timer(60, Global.weaponUpgrade[2][5][Global.weaponUpgrade[2][5][0][1]][0] - 1);
			t.addEventListener(TimerEvent.TIMER, uziBulletSpawn);
			t.addEventListener(TimerEvent.TIMER_COMPLETE, standardCleanup);
			t.start();
			uziBulletSpawn();
		}
		private function uziCeaseProtocol():void {
			coolDown.removeEventListener(TimerEvent.TIMER, uziFireProtocol);
			coolDown.repeatCount = coolDown.currentCount + 1;
		}
		private function uziBulletSpawn(...args):void {	//Only used in the uzi function, for bullet spacing.
			standardFireProtocol(Global.weaponUpgrade[2][4][Global.weaponUpgrade[2][4][0][1]][0], Global.weaponUpgrade[2][1][Global.weaponUpgrade[2][1][0][1]][0], Global.weaponUpgrade[2][0][Global.weaponUpgrade[2][0][0][1]][0]);
			//standardFireProtocol(Global.uziAccuracy, Global.uziRange, Global.uziDamage);
			uziSound.play();
		}
		/*END UZI PROTOCOLS*/
		/*SNIPER PROTOCOLS*/
		private function sniperAttackProtocol():void {
			coolDown.addEventListener(TimerEvent.TIMER, sniperFireProtocol);
			coolDown.repeatCount = 0;
			if (coolDown.running == false) {
				sniperFireProtocol();
				coolDown.start();
			}
		}
		private function sniperFireProtocol(...args):void {
			var sniperDamage:uint = Global.weaponUpgrade[3][0][Global.weaponUpgrade[3][0][0][1]][0];
			var piercing:uint = Global.weaponUpgrade[3][1][Global.weaponUpgrade[3][1][0][1]][0];
			sniperSound.play();
			standardOffendShift();
			still.frameRate = transit.frameRate = 0;
			offend.onComplete = standardCleanup;
			offend.frameRate = 12;
			//Bullet creation and dectection.
			var v:LinearVector = new LinearVector(new Point(x, y), new Point());
			v.direction = (90 - rotation) / 180 * Math.PI;	//perfect accuracy
			v.direction = Math.atan2( -Math.sin(v.direction), Math.cos(v.direction));
			v.magnitude = 3000;	//range
			
			var adjusted:LinearVector = new LinearVector(v.destination, v.anchor);
			adjusted.magnitude -= 40 + Math.random() * 8;
			adjusted.anchor = adjusted.destination;
			adjusted.destination = v.destination;
			//parent.addChild(new Bullet(adjusted, 3000, 40, 1, false));	//This is moved to after zombie collision is determined.
			
			var targets:Array = new Array();
			for (var i:uint = 0; i < Destructable.members.length; i++) {
				if (v.getCollision(Destructable.members[i].border) != null && Destructable.members[i].owner.isEnemy(owner)) {
					targets.push(Destructable.members[i]);
				}
			}
			if (targets.length == 0 || piercing == 0) {
				parent.addChild(new Bullet(adjusted, 3000, 40, 1, false));
				return;
			}
			if (targets.length <= piercing) {	//if fewer (or equal) targets exist than pierces
				for (i = 0; i < targets.length; i++) {
					targets[i].health -= sniperDamage;
				}
			}else {										//if more targest exist than pierces.
				var t:Array = new Array(targets.shift());
				top:  for (i = 0; i < targets.length; i++) {
					var p:Number = Point.distance(new Point(targets[i].x, targets[i].y), new Point(x, y));
					for (var a:uint = 0; a < t.length; a++) {
						if (p < Point.distance(new Point(x, y), new Point(t[a].x, t[a].y))) {
							t.splice(a, 0, targets[i]);
							continue top;
						}
					}
					t.push(targets[i]);
				}
				for (i = 0; i < piercing; i++) {
					t[i].health -= sniperDamage;
				}
				adjusted.magnitude = Point.distance(t[--i].border.anchor, new Point(x, y)) - radius - t[i].border.radius;
				parent.addChild(new Bullet(adjusted, 3000, 40, 1, false));
			}
		}
		private function sniperCeaseProtocol():void {
			coolDown.removeEventListener(TimerEvent.TIMER, sniperFireProtocol);
			coolDown.repeatCount = coolDown.currentCount + 1;
		}
		/*END SNIPER PROTOCOLS*/
		/*MINIGUN PROTOCOLS*/
		public function minigunAttackProtocol():void {
			coolDown.repeatCount = 0;
			offend.frameRate = 20;
			removeChildAt(0);
			still.frameRate = transit.frameRate = 0;
			addChild(offend);
			offend.x = -offend.width / 2;
			offend.y = -offend.height / 2;
			standardFireProtocol(Global.weaponUpgrade[4][4][Global.weaponUpgrade[4][4][0][1]][0], Global.weaponUpgrade[4][1][Global.weaponUpgrade[4][1][0][1]][0], Global.weaponUpgrade[4][0][Global.weaponUpgrade[4][0][0][1]][0]);
			coolDown.addEventListener(TimerEvent.TIMER, minigunFireProtocol);
			coolDown.start();
		}
		private var minigunTransform:SoundTransform = new SoundTransform(5);
		public function minigunFireProtocol(...args):void {
			//standardFireProtocol(Global.gatlingAccuracy, Global.gatlingRange, Global.gatlingDamage);
			standardFireProtocol(Global.weaponUpgrade[4][4][Global.weaponUpgrade[4][4][0][1]][0], Global.weaponUpgrade[4][1][Global.weaponUpgrade[4][1][0][1]][0], Global.weaponUpgrade[4][0][Global.weaponUpgrade[4][0][0][1]][0]);
			gatlingSound.play(0, 0, minigunTransform);
		}
		public function minigunCeaseProtocol():void {
			standardCleanup();
			coolDown.repeatCount = coolDown.currentCount + 1;
			coolDown.removeEventListener(TimerEvent.TIMER, minigunFireProtocol);
			offend.frameRate = 0;
		}
		/*END MINIGUN PROTOCOLS*/
		/*Standard image shifting protocols.  NOT GOOD FOR ALL WEAPONS. MUST USE STANDARD CLEANUP*/
		private function standardOffendShift():void {	//Standard cleanup automatically included.	
			removeChildAt(0);
			addChild(offend);
			still.frameRate = transit.frameRate = 0;
			offend.currentFrame = 0;
			offend.x = -offend.width / 2;
			offend.y = -offend.height / 2;
			//offend.onComplete = standardCleanup;
		}
		/*Standard image shifting for AFTER a fire phase has occurred.*/
		private function standardCleanup(...args):void {
			offend.frameRate = 0;
			removeChildAt(0);
			if (mover.running == true) {
				addChild(transit);
				transit.x = -transit.width / 2;
				transit.y = -transit.height / 2;
				transit.frameRate = 12;
			}else {
				addChild(still);
				still.x = -still.width / 2;
				still.y = -still.height / 2;
				still.frameRate = 12;
			}
		}
		/*Standard firing protocol for MOST weapons.  Not good for ALL weapons.*/
		private function standardFireProtocol(inaccuracy:Number, range:Number, damage:Number):void {
			if (Destructable.members.length == 0) {
				return;
			}
			var v:LinearVector = new LinearVector(new Point(x, y), new Point());	//working vector.
			v.direction = (90 - rotation) / 180 * Math.PI + Math.random() * inaccuracy * 2 - inaccuracy;
			v.direction = Math.atan2(-Math.sin(v.direction), Math.cos(v.direction));	//Flips things because of the coordinate system.
			v.magnitude = range;//range
			var first:Point = v.getCollision(v.getFirstCollider(DestructableWalker.staticObstacles));	//The closest intersecting static, indestructable vector.
			
			var adjusted:LinearVector = new LinearVector(v.destination, v.anchor);
			adjusted.magnitude -= 26 + Math.random() * 8;
			/*
			if (attackProtocol == pistolAttackProtocol) {
				v.anchor.x += Math.cos(90 - rotation / 180 * Math.PI + 10) * 6;
				v.anchor.y -= Math.sin(90 - rotation / 180 * Math.PI + 10) * 6;
				adjusted.magnitude -= 10;
			}*/
			adjusted.anchor = adjusted.destination;
			adjusted.destination = v.destination;
			//bullet is inserted later, after collision with zombies is confirmed.
			/*
			//DELETE
			Main.reference.zombieLayer.graphics.lineStyle(2, 0, 1);
			Main.reference.zombieLayer.graphics.moveTo(v.anchor.x, v.anchor.y);
			Main.reference.zombieLayer.graphics.lineTo(v.destination.x, v.destination.y);
			*/
			
			var temp:Array = new Array();	//Gets filled with radial border vectors
			for (var p:uint = 0; p < Destructable.members.length; p++) {
				if (owner.isEnemy(Destructable.members[p].owner)) {
					temp.push(Destructable.members[p].border);		//Collects all of the collision vectors of possible enemy targets.
				}
			}
			var w:RadialVector = RadialVector(v.getFirstCollider(temp));	//Vector of the first enemy collider.
			if (w == null) {
				parent.addChild(new Bullet(adjusted, Math.random() * 2000 + 1000, 38, 1, true));
				return;
			}
			if (first == null) {
				for (var m:uint = 0; m < Destructable.members.length; m++) {	//searches for w, the collider, and deducts health
					if (w.anchor.equals(Destructable.members[m].border.anchor) && w.radius == Destructable.members[m].radius) {
						Destructable.members[m].health -= damage;
						adjusted.magnitude = Point.distance(new Point(x, y), w.anchor) - w.radius - border.radius;
						break;
					}
				}
			}else {
				if (Point.distance(w.anchor, new Point(x, y)) < Point.distance(first, new Point(x, y))) {
					for (var b:uint = 0; b < Destructable.members.length; b++) {	//searches for w, the collider, and deducts health
						if (w.anchor.equals(Destructable.members[m].border.anchor) && w.radius == Destructable.members[m].radius) {
							Destructable.members[m].health -= damage;
							adjusted.magnitude = Point.distance(new Point(x, y), w.anchor) - w.radius - border.radius;
							break;
						}
					}
				}
			}
			parent.addChild(new Bullet(adjusted, Math.random() * 2000 + 1000, 38, 1, true));
		}
		/*END STANDARD PROTOCOLS*/
		
		/*Rollover protocols*/
		private function rollOverProtocol(inaccuracy:Number, range:Number, damage:Number):void {
			if (Destructable.members.length == 0) {
				return;
			}
			var v:LinearVector = new LinearVector(new Point(x, y), new Point());	//working vector.
			v.direction = (90 - rotation) / 180 * Math.PI + Math.random() * inaccuracy * 2 - inaccuracy;
			v.direction = Math.atan2( -Math.sin(v.direction), Math.cos(v.direction));	//Flips things because of the coordinate system.
			v.magnitude = range;//range 
			var first:Point = v.getCollision(v.getFirstCollider(DestructableWalker.staticObstacles));	//The closest intersecting static, indestructable vector.
			
			var temp:Array = new Array();	//Gets filled with radial border vectors
			for (var p:uint = 0; p < Destructable.members.length; p++) {
				if (owner.isEnemy(Destructable.members[p].owner)) {
					temp.push(Destructable.members[p].border);		//Collects all of the collision vectors of possible enemy targets.
				}
			}
			var w:RadialVector = RadialVector(v.getFirstCollider(temp));	//Vector of the first enemy collider.
			if (w == null) {
				return;
			}
			if (first == null) {
				for (var m:uint = 0; m < Destructable.members.length; m++) {
					if (w.anchor.equals(Destructable.members[m].border.anchor) && w.radius == Destructable.members[m].radius) {
						if (Destructable.members[m].health < damage) {
							rollOverProtocol(inaccuracy, range, damage - Destructable.members[m].health);
						}
						Destructable.members[m].health -= damage;
					}
				}
			}else {
				if (Point.distance(w.anchor, new Point(x, y)) < Point.distance(first, new Point(x, y))) {
					for (var b:uint = 0; b < Destructable.members.length; b++) {
						if (w.anchor.equals(Destructable.members[m].border.anchor) && w.radius == Destructable.members[m].radius) {
							if (Destructable.members[m].health < damage) {
								rollOverProtocol(inaccuracy, range, damage - Destructable.members[m].health);
							}
							Destructable.members[m].health -= damage;
						}
					}
				}
			}
		}
		
		private function preShakeCam(e:Event) : void {
			if (cameraShaker.running){
				Main.reference.cammy.follow = null;
				Main.reference.cammy.focus.x += Main.reference.cammy.x;
				Main.reference.cammy.focus.y += Main.reference.cammy.y;
				Main.reference.cammy.x = Main.reference.cammy.y = 0;
			}
		}
		private function postShakeCam(e:Event) : void {
			if (cameraShaker.running){
				Main.reference.cammy.follow = this;
			}
		}
		
		/*SETS ALL OF THE STATES OF HERO IMAGES, AND PREPS ALL CLIPS AND ANIMATIONS PERTAINING.  RUN ONCE!*/
		/*Permanent variables containing all animation data related to Hero object.*/
		private var pistolStill:Clip;
		private var pistolWalking:Clip;
		private var pistolAttack:Clip;
		private var uziStill:Clip;
		private var uziWalking:Clip;
		private var uziAttack:Clip;
		private var shottyStill:Clip;
		private var shottyWalking:Clip;
		private var shottyAttack:Clip;
		private var sniperStill:Clip;
		private var sniperWalking:Clip;
		private var sniperAttack:Clip;
		private var miniGunStill:Clip;
		private var miniGunWalking:Clip;
		private var miniGunAttack:Clip;
		private function generateHeroImages():void {
			/*Hero Images*/
			//Pistol Stand
			[Embed(source = '../graphics/pistolStill.png')]const pistolStill0:Class;
			pistolStill = new Clip(0, [new pistolStill0()]);
			//Pisol Walk
			[Embed(source='../graphics/pistol walking/pistolWalking0001.png')]const pistolWalking1:Class;
			[Embed(source='../graphics/pistol walking/pistolWalking0002.png')]const pistolWalking2:Class;
			[Embed(source='../graphics/pistol walking/pistolWalking0003.png')]const pistolWalking3:Class;
			[Embed(source='../graphics/pistol walking/pistolWalking0004.png')]const pistolWalking4:Class;
			[Embed(source='../graphics/pistol walking/pistolWalking0004.png')]const pistolWalking5:Class;
			[Embed(source='../graphics/pistol walking/pistolWalking0006.png')]const pistolWalking6:Class;
			[Embed(source='../graphics/pistol walking/pistolWalking0007.png')]const pistolWalking7:Class;
			[Embed(source='../graphics/pistol walking/pistolWalking0008.png')]const pistolWalking8:Class;
			pistolWalking = new Clip(0, [new pistolWalking1(),new pistolWalking2(),new pistolWalking3(),new pistolWalking4(),new pistolWalking5(),new pistolWalking6(),new pistolWalking7(),new pistolWalking8()]);
			pistolWalking.loop = true;
			//pistol attack
			[Embed(source = '../graphics/pistol attack/pistolAttack0001.png')]const pistolAttack1:Class;
			[Embed(source = '../graphics/pistol attack/pistolAttack0002.png')]const pistolAttack2:Class;
			pistolAttack = new Clip(0, [new pistolAttack1(), new pistolAttack2()]);
			for (var q:uint = 0; q < pistolAttack.totalFrames; q++) {
				pistolAttack.getFrame(q).y -= 8;
				pistolAttack.getFrame(q).x += 3.5;
			}
			pistolAttack.rotation = -7;
			pistolStill.rotation = -7;
			pistolWalking.rotation = -7;
			//uzi Stand
			[Embed(source='../graphics/uziStill.png')]const uziStill0:Class;
			uziStill = new Clip(0, [new uziStill0()]);
			//uzi Walk
			[Embed(source='../graphics/uzi Walking/uziWalking0001.png')]const uziWalking1:Class;
			[Embed(source='../graphics/uzi Walking/uziWalking0002.png')]const uziWalking2:Class;
			[Embed(source='../graphics/uzi Walking/uziWalking0003.png')]const uziWalking3:Class;
			[Embed(source='../graphics/uzi Walking/uziWalking0004.png')]const uziWalking4:Class;
			[Embed(source='../graphics/uzi Walking/uziWalking0005.png')]const uziWalking5:Class;
			[Embed(source='../graphics/uzi Walking/uziWalking0006.png')]const uziWalking6:Class;
			[Embed(source='../graphics/uzi Walking/uziWalking0007.png')]const uziWalking7:Class;
			[Embed(source='../graphics/uzi Walking/uziWalking0008.png')]const uziWalking8:Class;
			uziWalking = new Clip(0, [new uziWalking1(),new uziWalking2(),new uziWalking3(),new uziWalking4(),new uziWalking5(),new uziWalking6(),new uziWalking7(),new uziWalking8()]);
			uziWalking.loop = true;
			//uzi attack
			[Embed(source = '../graphics/uzi attack/uziAttack0001.png')]const uziAttack1:Class;
			[Embed(source = '../graphics/uzi attack/uziAttack0002.png')]const uziAttack2:Class;
			[Embed(source = '../graphics/uzi attack/uziAttack0003.png')]const uziAttack3:Class;
			[Embed(source = '../graphics/uzi attack/uziAttack0004.png')]const uziAttack4:Class;
			[Embed(source = '../graphics/uzi attack/uziAttack0005.png')]const uziAttack5:Class;
			[Embed(source = '../graphics/uzi attack/uziAttack0006.png')]const uziAttack6:Class;
			[Embed(source = '../graphics/uzi attack/uziAttack0007.png')]const uziAttack7:Class;
			[Embed(source = '../graphics/uzi attack/uziAttack0008.png')]const uziAttack8:Class;
			[Embed(source = '../graphics/uzi attack/uziAttack0009.png')]const uziAttack9:Class;
			[Embed(source = '../graphics/uzi attack/uziAttack0010.png')]const uziAttack10:Class;
			uziAttack = new Clip(0, [new uziAttack1(), new uziAttack2(), new uziAttack3(), new uziAttack4(), new uziAttack5(), new uziAttack6(), new uziAttack7(), new uziAttack8(), new uziAttack9(), new uziAttack10()]);
			uziAttack.loop = true;
			for (var w:uint = 0; w < uziAttack.totalFrames; w++) {
				uziAttack.getFrame(w).y -= 16;
				uziAttack.getFrame(w).x += 2;
			}
			//shotty Stand
			[Embed(source = '../graphics/shottyStill.png')]const shottyStill0:Class;
			shottyStill = new Clip(0, [new shottyStill0()]);
			//shotty Walk
			[Embed(source = '../graphics/shottyWalking/shottyWalking0001.png')]const shottyWalking1:Class;
			[Embed(source = '../graphics/shottyWalking/shottyWalking0002.png')]const shottyWalking2:Class;
			[Embed(source = '../graphics/shottyWalking/shottyWalking0003.png')]const shottyWalking3:Class;
			[Embed(source = '../graphics/shottyWalking/shottyWalking0004.png')]const shottyWalking4:Class;
			[Embed(source = '../graphics/shottyWalking/shottyWalking0005.png')]const shottyWalking5:Class;
			[Embed(source = '../graphics/shottyWalking/shottyWalking0006.png')]const shottyWalking6:Class;
			[Embed(source = '../graphics/shottyWalking/shottyWalking0007.png')]const shottyWalking7:Class;
			[Embed(source = '../graphics/shottyWalking/shottyWalking0008.png')]const shottyWalking8:Class;
			shottyWalking = new Clip(0, [new shottyWalking1(), new shottyWalking2(), new shottyWalking3(), new shottyWalking4(), new shottyWalking5(), new shottyWalking6(), new shottyWalking7(), new shottyWalking8()]);
			shottyWalking.loop = true;
			//shotty Attack
			[Embed(source = '../graphics/shotgun attack/shotgunAttack0001.png')]const shottyAttack1:Class;
			[Embed(source = '../graphics/shotgun attack/shotgunAttack0002.png')]const shottyAttack2:Class;
			shottyAttack = new Clip(0, [new shottyAttack1(), new shottyAttack2]);
			for (var r:uint = 0; r < shottyAttack.totalFrames; r++) {
				shottyAttack.getFrame(r).y -= 17;
				shottyAttack.getFrame(r).x += 2;
			}
			//sniper Still
			[Embed(source = '../graphics/sniperStill.png')]const sniperStill0:Class;
			sniperStill = new Clip(0, [new sniperStill0()]);
			//sniper Walking
			[Embed(source = '../graphics/sniperWalking/sniperWalking0001.png')]const sniperWalking1:Class;
			[Embed(source = '../graphics/sniperWalking/sniperWalking0002.png')]const sniperWalking2:Class;
			[Embed(source = '../graphics/sniperWalking/sniperWalking0003.png')]const sniperWalking3:Class;
			[Embed(source = '../graphics/sniperWalking/sniperWalking0004.png')]const sniperWalking4:Class;
			[Embed(source = '../graphics/sniperWalking/sniperWalking0005.png')]const sniperWalking5:Class;
			[Embed(source = '../graphics/sniperWalking/sniperWalking0006.png')]const sniperWalking6:Class;
			[Embed(source = '../graphics/sniperWalking/sniperWalking0007.png')]const sniperWalking7:Class;
			[Embed(source = '../graphics/sniperWalking/sniperWalking0008.png')]const sniperWalking8:Class;
			sniperWalking = new Clip(0, [new sniperWalking1(), new sniperWalking2(), new sniperWalking3(), new sniperWalking4(),new sniperWalking5(),new sniperWalking6(),new sniperWalking7(), new sniperWalking8()]);
			sniperWalking.loop = true;
			//sniper attack
			[Embed(source = '../graphics/sniper attack/sniperAttack0001.png')]const sniperAttack1:Class;
			[Embed(source = '../graphics/sniper attack/sniperAttack0002.png')]const sniperAttack2:Class;
			sniperAttack = new Clip(0, [new sniperAttack1(), new sniperAttack2()]);
			//Adjusts the position of the clip's frames to compensate for differing frame sizes, so they all align.
			for (var t:uint = 0; t < sniperAttack.totalFrames; t++) {	
				sniperAttack.getFrame(t).x += 4;
				sniperAttack.getFrame(t).y -= 8;	//It's really 14px, but 12px creates the illusion of kickback.
			}
			sniperStill.rotation = 8;
			sniperWalking.rotation = 8;
			sniperAttack.rotation = 8;
			//For some reason, sniperattack2 needs to be smaller, because flash overinflates its size.  No idea why yet.
			
			//miniGun still
			[Embed(source = '../graphics/miniGunStill/miniGunStill0001.png')]const miniGunStill1:Class;
			[Embed(source='../graphics/miniGunStill/miniGunStill0002.png')]const miniGunStill2:Class;
			[Embed(source = '../graphics/miniGunStill/miniGunStill0003.png')]const miniGunStill3:Class;
			[Embed(source = '../graphics/miniGunStill/miniGunStill0004.png')]const miniGunStill4:Class;
			[Embed(source = '../graphics/miniGunStill/miniGunStill0005.png')]const miniGunStill5:Class;
			[Embed(source = '../graphics/miniGunStill/miniGunStill0006.png')]const miniGunStill6:Class;
			[Embed(source = '../graphics/miniGunStill/miniGunStill0007.png')]const miniGunStill7:Class;
			[Embed(source = '../graphics/miniGunStill/miniGunStill0008.png')]const miniGunStill8:Class;
			miniGunStill = new Clip(0, [new miniGunStill1(),new miniGunStill2(),new miniGunStill3(),new miniGunStill4(),new miniGunStill5(),new miniGunStill6(),new miniGunStill7(),new miniGunStill8()]);
			//miniGun Walking
			[Embed(source = '../graphics/MiniGunWalking/miniGunWalking0001.png')]const miniGunWalking1:Class;
			[Embed(source = '../graphics/MiniGunWalking/miniGunWalking0002.png')]const miniGunWalking2:Class;
			[Embed(source = '../graphics/MiniGunWalking/miniGunWalking0003.png')]const miniGunWalking3:Class;
			[Embed(source = '../graphics/MiniGunWalking/miniGunWalking0004.png')]const miniGunWalking4:Class;
			[Embed(source = '../graphics/MiniGunWalking/miniGunWalking0005.png')]const miniGunWalking5:Class;
			[Embed(source = '../graphics/MiniGunWalking/miniGunWalking0006.png')]const miniGunWalking6:Class;
			[Embed(source = '../graphics/MiniGunWalking/miniGunWalking0007.png')]const miniGunWalking7:Class;
			[Embed(source = '../graphics/MiniGunWalking/miniGunWalking0008.png')]const miniGunWalking8:Class;
			miniGunWalking = new Clip(0, [new miniGunWalking1(),new miniGunWalking2(),new miniGunWalking3(),new miniGunWalking4(),new miniGunWalking5(),new miniGunWalking6(),new miniGunWalking7(),new miniGunWalking8()]);
			miniGunWalking.loop = true;
			//miniGun Attack
			[Embed(source = '../graphics/miniGunAttack/miniGunAttack0001.png')]const miniGunAttack1:Class;
			[Embed(source = '../graphics/miniGunAttack/miniGunAttack0002.png')]const miniGunAttack2:Class;
			[Embed(source = '../graphics/miniGunAttack/miniGunAttack0003.png')]const miniGunAttack3:Class;
			[Embed(source = '../graphics/miniGunAttack/miniGunAttack0004.png')]const miniGunAttack4:Class;
			[Embed(source = '../graphics/miniGunAttack/miniGunAttack0005.png')]const miniGunAttack5:Class;
			[Embed(source = '../graphics/miniGunAttack/miniGunAttack0006.png')]const miniGunAttack6:Class;
			[Embed(source = '../graphics/miniGunAttack/miniGunAttack0007.png')]const miniGunAttack7:Class;
			[Embed(source = '../graphics/miniGunAttack/miniGunAttack0008.png')]const miniGunAttack8:Class;
			miniGunAttack = new Clip(0, [new miniGunAttack1(), new miniGunAttack2(), new miniGunAttack3(), new miniGunAttack4(), new miniGunAttack5(), new miniGunAttack6(), new miniGunAttack7(), new miniGunAttack8()]);
			miniGunAttack.loop = true;
			//Adjusts the position of the clip's frames to compensate for differing frame sizes, so they all align.
			for (var c:uint = 0; c < miniGunAttack.totalFrames; c++) {
				miniGunAttack.getFrame(c).y -= 17;
				miniGunAttack.getFrame(c).x += 3;
			}
			/*Hero Images*/			
		}
		
		/*SOUND*/
		[Embed(source = '../Sound/final/gat.mp3')]private const pistolS:Class;
		private var pistolSound:Sound = new pistolS();
		[Embed(source = '../Sound/final/uzi.mp3')]private const uziS:Class;
		private var uziSound:Sound = new uziS();
		[Embed(source = '../Sound/final/shotgun.mp3')]private const shotS:Class;
		private var shotgunSound:Sound = new shotS();
		private var shotgunTrans:SoundTransform = new SoundTransform(.5);
		[Embed(source = '../Sound/final/sniper.mp3')]private const snipS:Class;
		private var sniperSound:Sound = new snipS();
		[Embed(source = '../Sound/final/gatling.mp3')]private const gatS:Class;
		private var gatlingSound:Sound = new gatS();
	}
}