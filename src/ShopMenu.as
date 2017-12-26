package 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Sound;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.utils.Timer;
	import SmoothTween;
	import Button;
	import flash.text.Font;
	import flash.events.TimerEvent;
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class ShopMenu extends Sprite 
	{
		/*Paper textures*/
		[Embed(source = '../graphics/shop/Compressed/pageside.png')]public static const side:Class;
		[Embed(source = '../graphics/shop/Compressed/papermid.jpg')]public static const mid:Class;
		/*Guns*/
		[Embed(source = '../graphics/shop/Compressed/gatling.png')]private static const gat:Class;
		[Embed(source = '../graphics/shop/Compressed/pistol.png')]private static const pst:Class;
		[Embed(source = '../graphics/shop/Compressed/shotgun.png')]private static const sho:Class;
		[Embed(source = '../graphics/shop/Compressed/sniper.png')]private static const sni:Class;
		[Embed(source = '../graphics/shop/Compressed/uzi.png')]private static const uz:Class;
		/*Cop with guns*/
		[Embed(source = '../graphics/shop/Compressed/folded.png')]private static const fldcop:Class;
		[Embed(source = '../graphics/shop/Compressed/gatling cop.png')]private static const gatcop:Class;
		[Embed(source = '../graphics/shop/Compressed/pistol cop.png')]private static const pstcop:Class;
		[Embed(source = '../graphics/shop/Compressed/shotgun cop.png')]private static const shocop:Class;
		[Embed(source = '../graphics/shop/Compressed/sniper cop.png')]private static const snicop:Class;
		[Embed(source = '../graphics/shop/Compressed/uzi cop.png')]private static const uzcop:Class;
		/*Hanging Signs*/
		[Embed(source = '../graphics/shop/Compressed/hanging signs.png')]private static const hangs:Class;
		/*Cash Sounds*/
		[Embed(source = '../Sound/final/cashregister.mp3')]private static const regs:Class;
		private var register:Sound = new regs();
		[Embed(source = '../Sound/final/change.mp3')]private static const chg:Class;
		private var change:Sound = new chg();
		
		private var gatling:Button = new Button();
		private var sniper:Button = new Button();
		private var shotgun:Button = new Button();
		private var pistol:Button = new Button();
		private var uzi:Button = new Button();
		
		private var foldedCop:Bitmap;
		private var gatlingCop:Bitmap;
		private var pistolCop:Bitmap;
		private var shotgunCop:Bitmap;
		private var sniperCop:Bitmap;
		private var uziCop:Bitmap;
		
		private var sniperTarget:Shape = new Shape();
		private var gatlingTarget:Shape = new Shape();
		
		private var signs:Sprite = new Sprite();
		
		private var button1:Button = new Button();
		private var button2:Button = new Button();
		private var button3:Button = new Button();
		private var button4:Button = new Button();
		private var button5:Button = new Button();
		private var button6:Button = new Button();
		private var button7:Button = new Button();
		private var button1text:TextField = new TextField();
		private var button2text:TextField = new TextField();
		private var button3text:TextField = new TextField();
		private var button4text:TextField = new TextField();
		private var button5text:TextField = new TextField();
		private var button6text:TextField = new TextField();
		private var button7text:TextField = new TextField();
		
		private var weaponIndex:uint;	//needed for buying weapons.  The buy functions are attached to buttons, which cannot accept parameters.
		
		private var moneyField:TextField = new TextField();
		
		private var exitButton:Button = new Button();
		public static var exitFunction:Function;
		
		public function ShopMenu():void {			
			//visuals
			addChild(new mid());
			var s:Bitmap = new side();
			addChild(s);
			s.x = -s.width;
			s = new side();
			addChild(s);
			s.x = 500 + s.width;
			s.scaleX = -1;
			//end visuals
			
			
			foldedCop = new fldcop();
			gatlingCop = new gatcop();
			pistolCop = new pstcop();
			shotgunCop = new shocop();
			sniperCop = new snicop();
			uziCop = new uzcop();
			
			//add cop
			addChild(foldedCop);
			foldedCop.x = 328;
			foldedCop.y = 58;
			//end cop
			addChild(pistolCop);
			addChild(shotgunCop);
			addChild(uziCop);
			addChild(sniperCop);
			addChild(gatlingCop);
			pistolCop.x = 328;
			pistolCop.y = 600;
			shotgunCop.x = 339;
			shotgunCop.y = 600;
			uziCop.x = 317;
			uziCop.y = 600;
			sniperCop.x = 253;
			sniperCop.y = 600;
			gatlingCop.x = 177;
			gatlingCop.y = 600;
			pistol.release = pistolMenu;
			shotgun.release = shotgunMenu;
			uzi.release = uziMenu;
			sniper.release = sniperMenu;
			gatling.release = gatlingMenu;
			/*Hanging signs*/
			signs.y = -700;
			signs.x = 40
			signs.addChild(new hangs());
			addChild(signs);
			
			//add guns
			addChild(gatling);
			var gata:Bitmap = new gat();
			gata.smoothing = true;
			gatling.addChild(gata);
			gatling.x = 47;
			gatling.y = 345;
			gatling.rotation = 22;
			addChild(sniper);
			var snip:Bitmap = new sni();
			snip.smoothing = true;
			sniper.addChild(snip);
			sniper.x = 41;
			sniper.y = 274;
			sniper.rotation = 20;
			addChild(shotgun);
			var short:Bitmap = new sho();
			short.smoothing = true;
			shotgun.addChild(short);
			shotgun.x = 45;
			shotgun.y = 68;
			shotgun.rotation = 23;
			addChild(pistol);
			var pzz:Bitmap = new pst();
			pzz.smoothing = true;
			pistol.addChild(pzz);
			pistol.x = 135;
			pistol.y = 16;
			pistol.rotation = 23;
			addChild(uzi);
			var buzz:Bitmap = new uz();
			buzz.smoothing = true;
			uzi.addChild(buzz);
			uzi.x = 100;
			uzi.y = 178;
			uzi.rotation = 23;
			//end guns

			//var frmt:TextFormat = new TextFormat("batik", 27);
			button1text.selectable = button2text.selectable = button3text.selectable = button4text.selectable = button5text.selectable = button6text.selectable = button7text.selectable = false;
			button1text.embedFonts = button2text.embedFonts = button3text.embedFonts = button4text.embedFonts = button5text.embedFonts = button6text.embedFonts = button7text.embedFonts = true;
			//button1text.defaultTextFormat = button2text.defaultTextFormat = button3text.defaultTextFormat = button4text.defaultTextFormat = button5text.defaultTextFormat = button6text.defaultTextFormat = button7text.defaultTextFormat = frmt;
			button1text.defaultTextFormat = new TextFormat("batik", 27);
			signs.addChild(button1text);
			signs.addChild(button2text);
			signs.addChild(button3text);
			signs.addChild(button4text);
			signs.addChild(button5text);
			signs.addChild(button6text);
			signs.addChild(button7text);
			
			button1text.x = 10;
			button1text.y = 60;
			button2text.x = 13;
			button2text.y = 180;
			button3text.x = 14;
			button3text.y = 234;
			button4text.x = 22;
			button4text.y = 288;
			button5text.x = 19;
			button5text.y = 385;
			button6text.x = 21;
			button6text.y = 462;
			button7text.x = 22;
			button7text.y = 513;
			button2text.rotation = 8;
			button3text.rotation = 1;
			button5text.rotation = -4;
			button6text.rotation = -2;
			
			var upgradeText:TextField = new TextField();
			upgradeText.selectable = false;
			upgradeText.embedFonts = true;
			upgradeText.defaultTextFormat = new TextFormat("batik", 20);
			upgradeText.x = 26;
			upgradeText.y = 104;
			upgradeText.rotation = 32;
			upgradeText.text = "Upgrades";
			signs.addChild(upgradeText);
			
			button1text.text = "RETURN"
			
			button1.graphics.beginFill(0, 0);
			button1.graphics.drawRect(9, 58, 106, 32);
			button1.graphics.endFill();
			signs.addChild(button1);
			
			button2.graphics.beginFill(0, 0);
			button2.graphics.moveTo(13, 183);
			button2.graphics.lineTo(133, 200);
			button2.graphics.lineTo(132, 223);
			button2.graphics.lineTo(7, 207);
			button2.graphics.lineTo(13, 183);
			button2.graphics.endFill();
			signs.addChild(button2);
			
			button3.graphics.beginFill(0, 0);
			button3.graphics.moveTo(14, 235);
			button3.graphics.lineTo(138, 237);
			button3.graphics.lineTo(140, 263);
			button3.graphics.lineTo(3, 258);
			button3.graphics.lineTo(14, 235);
			button3.graphics.endFill();
			signs.addChild(button3);
			
			button4.graphics.beginFill(0, 0);
			button4.graphics.moveTo(22, 291);
			button4.graphics.lineTo(140, 292);
			button4.graphics.lineTo(142, 312);
			button4.graphics.lineTo(20, 314);
			button4.graphics.lineTo(22, 291);
			button4.graphics.endFill();
			signs.addChild(button4);
			
			button5.graphics.beginFill(0, 0);
			button5.graphics.moveTo(18, 385);
			button5.graphics.lineTo(142, 374);
			button5.graphics.lineTo(145, 404);
			button5.graphics.lineTo(23, 414);
			button5.graphics.lineTo(18, 385);
			button5.graphics.endFill();
			signs.addChild(button5);
			
			button6.graphics.beginFill(0, 0);
			button6.graphics.moveTo(20, 461);
			button6.graphics.lineTo(138, 462);
			button6.graphics.lineTo(137, 485);
			button6.graphics.lineTo(19, 488);
			button6.graphics.lineTo(20, 461);
			button6.graphics.endFill();
			signs.addChild(button6);
			
			button7.graphics.beginFill(0, 0);
			button7.graphics.moveTo(21, 515);
			button7.graphics.lineTo(136, 515);
			button7.graphics.lineTo(135, 535);
			button7.graphics.lineTo(22, 539);
			button7.graphics.lineTo(21, 515);
			button7.graphics.endFill();
			signs.addChild(button7);
			
			button2text.width = button3text.width = button4text.width = button5text.width = button6text.width = button7text.width = 150;
			button1.release = regularMenu;
			
			//This is also in regularmenu, but it needs to be called or it wont work the first time you go into a menu.
			button2.release = buyDamage;
			button3.release = buyAccuracy;
			button4.release = buyCooldown;
			button5.release = buyRange;
			button6.release = buyWeight;
			button7.release = null;
			
			moneyField.x = 240;
			moneyField.y = 5;
			moneyField.selectable = false;
			moneyField.embedFonts = true;
			moneyField.defaultTextFormat = new TextFormat("batik", 30);
			moneyField.width = 300;
			addChild(moneyField);
			
			//this has to be called delayed, because shopMenu exists before monies does and there's nothing I can do.
			var t:Timer = new Timer(1, 1);
			t.addEventListener(TimerEvent.TIMER, updateMoney);
			t.start();
			
			var xText:TextField = new TextField();
			xText.defaultTextFormat = new TextFormat("batik", 20);
			xText.selectable = false;
			xText.embedFonts = true;
			xText.text = 'X';
			xText.width = xText.textWidth + 3;
			xText.height = xText.textHeight;
			
			exitButton.x = 20;
			exitButton.y = 2;
			exitButton.scaleX = 1.35;
			exitButton.addChild(xText);
			addChild(exitButton);
			
			var sh:Shape = new Shape();
			sh.graphics.lineStyle(1, 0, 0);
			sh.graphics.drawRect(0, 0, xText.textWidth, xText.textHeight);
			exitButton.addChild(sh);
			exitButton.release = tr;
			
			var tm:Timer = new Timer(1, 1);	//Shopmenu class exists before Global, so I guess you have to call functions after initialization
			tm.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent):void { regularMenu() } );
			tm.start();
		}
		private function tr():void {	//For some reason, you cant pass this function too many times.  You just have to make another function to call it directly.
			exitFunction();
		}
		private function regularMenu():void {
			pistol.release = pistolMenu;
			uzi.release = uziMenu;
			sniper.release = sniperMenu;
			gatling.release = gatlingMenu;
			SmoothTween.add(gatling, new Point(47, 345), 250);
			SmoothTween.add(sniper, new Point(41, 274), 250);
			SmoothTween.add(shotgun, new Point(45, 68), 250);
			SmoothTween.add(pistol, new Point(135, 16), 250);
			SmoothTween.add(uzi, new Point(100, 178), 250);
			SmoothTween.add(foldedCop, new Point(328, 58), 250);
			SmoothTween.add(pistolCop, new Point(pistolCop.x, 600), 250);
			SmoothTween.add(shotgunCop, new Point(shotgunCop.x, 600), 250);
			SmoothTween.add(uziCop, new Point(uziCop.x, 600), 250);
			SmoothTween.add(sniperCop, new Point(sniperCop.x, 600), 250);
			SmoothTween.add(gatlingCop, new Point(gatlingCop.x, 600), 250);
			SmoothTween.add(signs, new Point(40, -700), 250);
			
			//buttons are reset every time to prevent accidental clicks and button errors
			button2.release = button3.release = button4.release = button5.release = button6.release = button7.release = null;
			SmoothTween.add(exitButton, new Point(20, 2), 250);
			exitButton.release = tr;
			
			if (Global.ownsShotgun == false) {
				shotgun.toolTip = generateTextTip("The Shotgun costs $1200");
				shotgun.release = buyShotgun;
			}else {
				shotgun.toolTip = null;
				shotgun.release = shotgunMenu;
			}
			if (Global.ownsUzi == false) {
				uzi.toolTip = generateTextTip("The Uzis cost $2800");
				uzi.release = buyUzi;
			}else {
				uzi.release = uziMenu;
				uzi.toolTip = null;
			}
			if (Global.ownsSniper == false) {
				sniper.toolTip = generateTextTip("The Sniper costs $3600");
				sniper.release = buySniper;
			}else {
				sniper.release = sniperMenu;
				sniper.toolTip = null;
			}
			if (Global.ownsGatling == false) {
				gatling.toolTip = generateTextTip("The Minigun costs $5000");
				gatling.release = buyGatling;
			}else {
				gatling.release = gatlingMenu;
				gatling.toolTip = null;
			}
		}
		private function pistolMenu():void {
			weaponIndex = 0;
			button2.toolTip = damageToolTip(0);
			button3.toolTip = accuracyToolTip(0);
			button4.toolTip = cooldownToolTip(0);
			button5.toolTip = rangeToolTip(0);
			button6.toolTip = weightToolTip(0);
			/*
			var s:Sprite = new Sprite();
			if (Global.rollover == false) {
				s.addChild(generateTextTip("Bullets that kill enemies continue to deal damage to those in their trajectory.\nCosts $400."));
			}else {
				s.addChild(generateTextTip("Bullets that kill enemies continue to deal damage to those in their trajectory.\nAlready Purchased."));
			}
			s.getChildAt(0).y -= 80;
			button7.toolTip = s;
			*/
			resolveRolloverToolTip();
			button2.release = buyDamage;
			button3.release = buyAccuracy;
			button4.release = buyCooldown;
			button5.release = buyRange;
			button6.release = buyWeight;
			button7.release = buyRollover;
			SmoothTween.add(signs, new Point(40, -50), 250);
			SmoothTween.add(pistol, new Point(-500, pistol.y), 250);
			SmoothTween.add(shotgun, new Point(-500, shotgun.y), 250);
			SmoothTween.add(uzi, new Point(-500, uzi.y), 250);
			SmoothTween.add(sniper, new Point(-500, sniper.y), 250);
			SmoothTween.add(gatling, new Point( -500, gatling.y), 250);
			SmoothTween.add(foldedCop, new Point(foldedCop.x, 600), 250);
			SmoothTween.add(pistolCop, new Point(328, 57), 250);//
			SmoothTween.add(shotgunCop, new Point(shotgunCop.x, 600), 250);
			SmoothTween.add(uziCop, new Point(uziCop.x, 600), 250);
			SmoothTween.add(sniperCop, new Point(sniperCop.x, 600), 250);
			SmoothTween.add(gatlingCop, new Point(gatlingCop.x, 600), 250);
			//button texts
			button3text.defaultTextFormat = button4text.defaultTextFormat = new TextFormat("batik", 24);
			button2text.defaultTextFormat = button5text.defaultTextFormat = button6text.defaultTextFormat = new TextFormat("batik", 27);
			button7text.defaultTextFormat = new TextFormat("batik", 22);
			button2text.text = "Damage";
			button3text.text = "Accuracy";
			button4text.text = "Cooldown";
			button5text.text = "Range";
			button6text.text = "Weight";
			button7text.text = "RollOver";
			SmoothTween.add(exitButton, new Point( -20, 2), 250);
			exitButton.release = null;
		}
		private function shotgunMenu():void {
			weaponIndex = 1;
			button2.toolTip = damageToolTip(1);
			button3.toolTip = accuracyToolTip(1);
			button4.toolTip = cooldownToolTip(1);
			button5.toolTip = rangeToolTip(1);
			button6.toolTip = weightToolTip(1);
			var s:Sprite = new Sprite();
			if (Global.weaponUpgrade[1][5][0][1] == Global.weaponUpgrade[1][5].length - 1) { 
				s.addChild(generateTextTip("You have reached the maximum amount of buckshot for this weapon.\nBullets Per Shot: 8"));
			}else {
				s.addChild(generateTextTip("(Level " + (Global.weaponUpgrade[1][5][0][1] + 1) + ")\nIncrease the number of bullets per shot from " + Global.weaponUpgrade[1][5][Global.weaponUpgrade[1][5][0][1]][0] + " to " + Global.weaponUpgrade[1][5][Global.weaponUpgrade[1][5][0][1] + 1][0] + ".\nCosts $" + Global.weaponUpgrade[1][5][Global.weaponUpgrade[1][5][0][1] + 1][1]));
			}
			s.getChildAt(0).y -= 80;
			button7.toolTip = s;
			button2.release = buyDamage;
			button3.release = buyAccuracy;
			button4.release = buyCooldown;
			button5.release = buyRange;
			button6.release = buyWeight;
			button7.release = buyBuckshot;
			SmoothTween.add(signs, new Point(40, -50), 250);
			SmoothTween.add(pistol, new Point(-500, pistol.y), 250);
			SmoothTween.add(shotgun, new Point(-500, shotgun.y), 250);
			SmoothTween.add(uzi, new Point(-500, uzi.y), 250);
			SmoothTween.add(sniper, new Point(-500, sniper.y), 250);
			SmoothTween.add(gatling, new Point( -500, gatling.y), 250);
			SmoothTween.add(foldedCop, new Point(foldedCop.x, 600), 250);
			SmoothTween.add(pistolCop, new Point(pistolCop.x, 600), 250);
			SmoothTween.add(shotgunCop, new Point(275, 37), 250);//
			SmoothTween.add(uziCop, new Point(uziCop.x, 600), 250);
			SmoothTween.add(sniperCop, new Point(sniperCop.x, 600), 250);
			SmoothTween.add(gatlingCop, new Point(gatlingCop.x, 600), 250);
			button3text.defaultTextFormat = button4text.defaultTextFormat = button7text.defaultTextFormat = new TextFormat("batik", 24);
			button2text.defaultTextFormat=button5text.defaultTextFormat=button6text.defaultTextFormat=new TextFormat("batik", 27);
			button2text.text = "Damage";
			button3text.text = "Accuracy";
			button4text.text = "Cooldown";
			button5text.text = "Range";
			button6text.text = "Weight";
			button7text.text = "Buckshot";
			SmoothTween.add(exitButton, new Point( -20, 2), 250);
			exitButton.release = null;
		}
		private function uziMenu():void {
			weaponIndex = 2;
			button2.toolTip = damageToolTip(2);
			button3.toolTip = accuracyToolTip(2);
			button4.toolTip = cooldownToolTip(2);
			button5.toolTip = rangeToolTip(2);
			button6.toolTip = weightToolTip(2);
			var s:Sprite = new Sprite();
			if (Global.weaponUpgrade[2][5][0][1] == Global.weaponUpgrade[2][5].length - 1) { 
				s.addChild(generateTextTip("You have reached the maximum clip size for this weapon.\nShots Per Clip: 16"));
			}else {
				s.addChild(generateTextTip("(Level " + (Global.weaponUpgrade[2][5][0][1] + 1) + ")\nIncrease the number of bullets fired before a cooldown is needed from " + Global.weaponUpgrade[2][5][Global.weaponUpgrade[2][5][0][1]][0] + " to " + Global.weaponUpgrade[2][5][Global.weaponUpgrade[2][5][0][1] + 1][0] + ".\nCosts $" + Global.weaponUpgrade[2][5][Global.weaponUpgrade[2][5][0][1] + 1][1]));
			}
			s.getChildAt(0).y -= 100;
			button7.toolTip = s;
			button2.release = buyDamage;
			button3.release = buyAccuracy;
			button4.release = buyCooldown;
			button5.release = buyRange;
			button6.release = buyWeight;
			button7.release = buyClipsize;
			SmoothTween.add(signs, new Point(40, -50), 250);
			SmoothTween.add(pistol, new Point(-500, pistol.y), 250);
			SmoothTween.add(shotgun, new Point(-500, shotgun.y), 250);
			SmoothTween.add(uzi, new Point(-500, uzi.y), 250);
			SmoothTween.add(sniper, new Point(-500, sniper.y), 250);
			SmoothTween.add(gatling, new Point( -500, gatling.y), 250);
			SmoothTween.add(foldedCop, new Point(foldedCop.x, 600), 250);
			SmoothTween.add(pistolCop, new Point(pistolCop.x, 600), 250);
			SmoothTween.add(shotgunCop, new Point(shotgunCop.x, 600), 250);
			SmoothTween.add(uziCop, new Point(260, 58), 250);//
			SmoothTween.add(sniperCop, new Point(sniperCop.x, 600), 250);
			SmoothTween.add(gatlingCop, new Point(gatlingCop.x, 600), 250);
			button3text.defaultTextFormat = button4text.defaultTextFormat = new TextFormat("batik", 24);
			button2text.defaultTextFormat = button5text.defaultTextFormat = button6text.defaultTextFormat = new TextFormat("batik", 27);
			button7text.defaultTextFormat = new TextFormat("batik", 20);
			button2text.text = "Damage";
			button3text.text = "Accuracy";
			button4text.text = "Cooldown";
			button5text.text = "Range";
			button6text.text = "Weight";
			button7text.text = "Clip Size";
			SmoothTween.add(exitButton, new Point( -20, 2), 250);
			exitButton.release = null;
		}
		private function sniperMenu():void {
			weaponIndex = 3;
			button2.toolTip = damageToolTip(3);
			button3.toolTip = cooldownToolTip(3);
			button4.toolTip = weightToolTip(3);
			button5.toolTip = button6.toolTip = button7.toolTip = null;
			SmoothTween.add(signs, new Point(40, -50), 250);
			SmoothTween.add(pistol, new Point(-500, pistol.y), 250);
			SmoothTween.add(shotgun, new Point(-500, shotgun.y), 250);
			SmoothTween.add(uzi, new Point(-500, uzi.y), 250);
			SmoothTween.add(sniper, new Point(-500, sniper.y), 250);
			SmoothTween.add(gatling, new Point( -500, gatling.y), 250);
			SmoothTween.add(foldedCop, new Point(foldedCop.x, 600), 250);
			SmoothTween.add(pistolCop, new Point(pistolCop.x, 600), 250);
			SmoothTween.add(shotgunCop, new Point(shotgunCop.x, 600), 250);
			SmoothTween.add(uziCop, new Point(uziCop.x, 600), 250);
			SmoothTween.add(sniperCop, new Point(225, 59), 250);//
			SmoothTween.add(gatlingCop, new Point(gatlingCop.x, 600), 250);
			button3text.defaultTextFormat = button5text.defaultTextFormat = new TextFormat("batik", 24);
			button2text.defaultTextFormat=button4text.defaultTextFormat=new TextFormat("batik", 27);
			button2text.text = "Damage";
			button3text.text = "Cooldown";
			button4text.text = "Weight";
			button5text.text = "Piercing";
			button6text.text = "";
			button7text.text = "";
			button6.release = button7.release = null;
			button5.release = buyPiercing;
			button4.release = buyWeight;
			button3.release = buyCooldown;
			button2.release = buyDamage;
			if (Global.weaponUpgrade[3][1][0][1] == Global.weaponUpgrade[3][1].length - 1) { 
				button5.toolTip =generateTextTip("You have reached the maximum amount of piercing for this weapon.\nUnits Piercing: 8 Per Shot");
			}else {
				button5.toolTip =generateTextTip("(Level " + (Global.weaponUpgrade[3][1][0][1] + 1) + ")\nIncrease the number of targets hit by a single bullet from " + Global.weaponUpgrade[3][1][Global.weaponUpgrade[3][1][0][1]][0] + " to " + Global.weaponUpgrade[3][1][Global.weaponUpgrade[3][1][0][1] + 1][0] + ".\nCosts $" + Global.weaponUpgrade[3][1][Global.weaponUpgrade[3][1][0][1] + 1][1]);
			}
			SmoothTween.add(exitButton, new Point( -20, 2), 250);
			exitButton.release = null;
		}
		private function gatlingMenu():void {
			weaponIndex = 4;
			button2.toolTip = damageToolTip(4);
			button3.toolTip = accuracyToolTip(4);
			button4.toolTip = cooldownToolTip(4);
			button5.toolTip = rangeToolTip(4);
			button6.toolTip = weightToolTip(4);
			button7.toolTip = null;
			button2.release = buyDamage;
			button3.release = buyAccuracy;
			button4.release = buyCooldown;
			button5.release = buyRange;
			button6.release = buyWeight;
			button7.release = null;
			SmoothTween.add(signs, new Point(40, -50), 250);
			SmoothTween.add(pistol, new Point(-500, pistol.y), 250);
			SmoothTween.add(shotgun, new Point(-500, shotgun.y), 250);
			SmoothTween.add(uzi, new Point(-500, uzi.y), 250);
			SmoothTween.add(sniper, new Point(-500, sniper.y), 250);
			SmoothTween.add(gatling, new Point( -500, gatling.y), 250);
			SmoothTween.add(foldedCop, new Point(foldedCop.x, 600), 250);
			SmoothTween.add(pistolCop, new Point(pistolCop.x, 600), 250);
			SmoothTween.add(shotgunCop, new Point(shotgunCop.x, 600), 250);
			SmoothTween.add(uziCop, new Point(uziCop.x, 600), 250);
			SmoothTween.add(sniperCop, new Point(sniperCop.x, 600), 250);
			SmoothTween.add(gatlingCop, new Point(177, 59), 250);//
			button3text.defaultTextFormat = button4text.defaultTextFormat = new TextFormat("batik", 24);
			button2text.defaultTextFormat=button5text.defaultTextFormat=button6text.defaultTextFormat=button7text.defaultTextFormat=new TextFormat("batik", 27);
			button2text.text = "Damage";
			button3text.text = "Accuracy";
			button4text.text = "Cooldown";
			button5text.text = "Range";
			button6text.text = "Weight";
			button7text.text = "";
			SmoothTween.add(exitButton, new Point( -20, 2), 250);
			exitButton.release = null;
		}
		private function generateTextTip(text:String):Sprite {
			var t:TextField = new TextField();
			t.selectable = false;
			t.width = 250;
			t.wordWrap = true;
			t.embedFonts = true;
			t.defaultTextFormat = new TextFormat("batik", 16);
			t.text = text;
			t.height = 500;
			t.x = 7;
			t.y = 7;
			var back:Shape = new Shape();
			back.graphics.lineStyle(0, 0, 0);
			back.graphics.beginFill(0xFFFFEF, .85);
			back.graphics.drawRoundRect( 2, 2, t.textWidth + 10, t.textHeight + 10, 5, 5);
			back.graphics.endFill();
			var total:Sprite = new Sprite();
			total.addChild(back);
			total.addChild(t);
			total.x = 0;
			total.y = 0;
			return total;
		}
		private function damageToolTip(weaponIndex:uint):DisplayObject {
			if(Global.weaponUpgrade[weaponIndex][0][0][1] == Global.weaponUpgrade[weaponIndex][0].length - 1){
				return generateTextTip("This weapon's damage cannot be upgraded any further. \nDamage: " + Global.weaponUpgrade[weaponIndex][0][Global.weaponUpgrade[weaponIndex][0][0][1]][0]);
			}else {
				return generateTextTip("(Level " + (Global.weaponUpgrade[weaponIndex][0][0][1] + 1) + "\nUpgrade weapon damage from " + Global.weaponUpgrade[weaponIndex][0][Global.weaponUpgrade[weaponIndex][0][0][1]][0] + " to " + Global.weaponUpgrade[weaponIndex][0][Global.weaponUpgrade[weaponIndex][0][0][1] + 1][0] + ".  \nCosts $" + Global.weaponUpgrade[weaponIndex][0][Global.weaponUpgrade[weaponIndex][0][0][1] + 1][1]);
			}
		}
		private function accuracyToolTip(weaponIndex:uint):DisplayObject {	//not to be used with sniper
			if (Global.weaponUpgrade[weaponIndex][4][0][1] == Global.weaponUpgrade[weaponIndex][4].length - 1) {
				return generateTextTip("This weapon's accuracy cannot be increased any further. \nAccuracy: " + Global.weaponUpgrade[weaponIndex][4][Global.weaponUpgrade[weaponIndex][4][0][1]][0]);
			}else {
				return generateTextTip("(Level " + (Global.weaponUpgrade[weaponIndex][4][0][1] + 1) + ")\nIncrease accuracy from " + Global.weaponUpgrade[weaponIndex][4][Global.weaponUpgrade[weaponIndex][4][0][1]][0] + " to " + Global.weaponUpgrade[weaponIndex][4][Global.weaponUpgrade[weaponIndex][4][0][1] + 1][0] + " points of deviation.\nCosts $" + Global.weaponUpgrade[weaponIndex][4][Global.weaponUpgrade[weaponIndex][4][0][1] + 1][1]);
			}
		}
		private function rangeToolTip(weaponIndex:uint):DisplayObject {
			if (Global.weaponUpgrade[weaponIndex][1][0][1] == Global.weaponUpgrade[weaponIndex][1].length - 1) {
				return generateTextTip("This weapon's range cannot be increased any further. \nRange: " + Global.weaponUpgrade[weaponIndex][1][Global.weaponUpgrade[weaponIndex][1][0][1]][0]);
			}else {
				return generateTextTip("(Level " + (Global.weaponUpgrade[weaponIndex][1][0][1] + 1) + ")\nIncrease range from " + Global.weaponUpgrade[weaponIndex][1][Global.weaponUpgrade[weaponIndex][1][0][1]][0] + " to " + Global.weaponUpgrade[weaponIndex][1][Global.weaponUpgrade[weaponIndex][1][0][1] + 1][0] + ".\nCosts $" + Global.weaponUpgrade[weaponIndex][1][Global.weaponUpgrade[weaponIndex][1][0][1] + 1][1] + "\nNOTE:  Screen is 500 pixels wide");
			}
		}
		private function cooldownToolTip(weaponIndex:uint):DisplayObject {
			if (Global.weaponUpgrade[weaponIndex][2][0][1] == Global.weaponUpgrade[weaponIndex][2].length - 1) {
				return generateTextTip("This weapon's cooldown cannot be lowered any further. \nCooldown: " + Global.weaponUpgrade[weaponIndex][2][Global.weaponUpgrade[weaponIndex][2][0][1]][0]);
			}else {
				return generateTextTip("(Level " + (Global.weaponUpgrade[weaponIndex][2][0][1] + 1) + ")\nDecrease cooldown from " + Global.weaponUpgrade[weaponIndex][2][Global.weaponUpgrade[weaponIndex][2][0][1]][0] / 1000 + " to " + Global.weaponUpgrade[weaponIndex][2][Global.weaponUpgrade[weaponIndex][2][0][1] + 1][0] / 1000 + " seconds.\nCosts $" + Global.weaponUpgrade[weaponIndex][2][Global.weaponUpgrade[weaponIndex][2][0][1] + 1][1]);
			}
		}
		private function weightToolTip(weaponIndex:uint):DisplayObject {
			if (Global.weaponUpgrade[weaponIndex][3][0][1] == Global.weaponUpgrade[weaponIndex][3].length - 1) {
				return generateTextTip("This weapon cannot lose any more weight. \nWeight: " + Global.weaponUpgrade[weaponIndex][3][Global.weaponUpgrade[weaponIndex][3][0][1]][0]);
			}else {
				return generateTextTip("(Level " + (Global.weaponUpgrade[weaponIndex][3][0][1] + 1) + ")\nIncrease movement speed from " + Global.weaponUpgrade[weaponIndex][3][Global.weaponUpgrade[weaponIndex][3][0][1]][0] + " to " + Global.weaponUpgrade[weaponIndex][3][Global.weaponUpgrade[weaponIndex][3][0][1] + 1][0] + ".\nCosts $" + Global.weaponUpgrade[weaponIndex][3][Global.weaponUpgrade[weaponIndex][3][0][1] + 1][1]);
			}
		}
		//Handles the purchase and upgrade of weapons.
		private function buyDamage(weaponIndex:uint = undefined):void {
			weaponIndex = this.weaponIndex;
			if (Global.weaponUpgrade[weaponIndex][0][0][1] == Global.weaponUpgrade[weaponIndex][0].length - 1) {
					button2.toolTip = generateTextTip("DID I STUTTER!?!");
					var f:Timer = new Timer(2000, 1);
					f.addEventListener(TimerEvent.TIMER, damageToolTip);
					f.start();
					return;
			}
			if (Global.monies < Global.weaponUpgrade[weaponIndex][0][Global.weaponUpgrade[weaponIndex][0][0][1] + 1][1]) {
				button2.toolTip = generateTextTip("You do not have enough monies to purchase this upgrade!");
			}else {
				Global.monies -= Global.weaponUpgrade[weaponIndex][0][Global.weaponUpgrade[weaponIndex][0][0][1] + 1][1];
				Global.weaponUpgrade[weaponIndex][0][0][1]++;
				button2.toolTip = generateTextTip("We appreciate your business!");
				updateMoney();
				change.play();
			}
			var t:Timer = new Timer(2000, 1);
			t.addEventListener(TimerEvent.TIMER, resolveDamageToolTip);
			t.start();
		}
		private function resolveDamageToolTip(e:TimerEvent):void {
			button2.toolTip = damageToolTip(weaponIndex);
		}
		private function buyRange(weaponIndex:uint = undefined):void {
			weaponIndex = this.weaponIndex;
			if (Global.weaponUpgrade[weaponIndex][1][0][1] == Global.weaponUpgrade[weaponIndex][0].length - 1) {
					button5.toolTip = generateTextTip("SAY WHAT AGAIN!");
					var f:Timer = new Timer(2000, 1);
					f.addEventListener(TimerEvent.TIMER, resolveRangeToolTip);
					f.start();
					return;
			}
			if (Global.monies < Global.weaponUpgrade[weaponIndex][1][Global.weaponUpgrade[weaponIndex][1][0][1] + 1][1]) {
				button5.toolTip = generateTextTip("You do not have enough monies to purchase this upgrade!");
			}else {
				Global.monies -= Global.weaponUpgrade[weaponIndex][1][Global.weaponUpgrade[weaponIndex][1][0][1] + 1][1];
				Global.weaponUpgrade[weaponIndex][1][0][1]++;
				button5.toolTip = generateTextTip("We appreciate your business!");
				change.play();
				updateMoney();
			}
			var t:Timer = new Timer(2000, 1);
			t.addEventListener(TimerEvent.TIMER, resolveRangeToolTip);
			t.start();
		}
		private function resolveRangeToolTip(e:TimerEvent):void {
			button5.toolTip = rangeToolTip(weaponIndex);
		}
		private function buyCooldown(weaponIndex:uint = undefined):void {
			weaponIndex = this.weaponIndex;
			if (Global.weaponUpgrade[weaponIndex][2][0][1] == Global.weaponUpgrade[weaponIndex][2].length - 1) {
					button4.toolTip = generateTextTip("DONT MAKE ME REPEAT MYSELF!");
					var f:Timer = new Timer(2000, 1);
					f.addEventListener(TimerEvent.TIMER, resolveCooldownToolTip);
					f.start();
					return;
			}
			if (Global.monies < Global.weaponUpgrade[weaponIndex][2][Global.weaponUpgrade[weaponIndex][2][0][1] + 1][1]) {
				button4.toolTip = generateTextTip("You do not have enough monies to purchase this upgrade!");
			}else {
				Global.monies -= Global.weaponUpgrade[weaponIndex][2][Global.weaponUpgrade[weaponIndex][2][0][1] + 1][1];
				Global.weaponUpgrade[weaponIndex][2][0][1]++;
				button4.toolTip = generateTextTip("We appreciate your business!");
				updateMoney();
				change.play();
			}
			var t:Timer = new Timer(2000, 1);
			t.addEventListener(TimerEvent.TIMER, resolveCooldownToolTip);
			t.start();
		}
		private function resolveCooldownToolTip(e:TimerEvent):void {
			button4.toolTip = cooldownToolTip(weaponIndex);
		}
		private function buyWeight(weaponIndex:uint = undefined):void {
			weaponIndex = this.weaponIndex;
			if (Global.weaponUpgrade[weaponIndex][3][0][1] == Global.weaponUpgrade[weaponIndex][3].length - 1) {
					button6.toolTip = generateTextTip("ITS A TRAP!");
					var f:Timer = new Timer(2000, 1);
					f.addEventListener(TimerEvent.TIMER, resolveWeightToolTip);
					f.start();
					return;
			}
			if (Global.monies < Global.weaponUpgrade[weaponIndex][3][Global.weaponUpgrade[weaponIndex][3][0][1] + 1][1]) {
				button6.toolTip = generateTextTip("You do not have enough monies to purchase this upgrade!");
			}else {
				Global.monies -= Global.weaponUpgrade[weaponIndex][3][Global.weaponUpgrade[weaponIndex][3][0][1] + 1][1];
				Global.weaponUpgrade[weaponIndex][3][0][1]++;
				button6.toolTip = generateTextTip("We appreciate your business!");
				updateMoney();
				change.play();
			}
			var t:Timer = new Timer(2000, 1);
			t.addEventListener(TimerEvent.TIMER, resolveWeightToolTip);
			t.start();
		}
		private function resolveWeightToolTip(e:TimerEvent):void {
			button6.toolTip = weightToolTip(weaponIndex);
		}
		private function buyAccuracy(weaponIndex:uint = undefined):void {
			weaponIndex = this.weaponIndex;
			if (Global.weaponUpgrade[weaponIndex][4][0][1] == Global.weaponUpgrade[weaponIndex][4].length - 1) {
				button3.toolTip = generateTextTip("THAT... WAS A MISTAKE!");
				var f:Timer = new Timer(2000, 1);
				f.addEventListener(TimerEvent.TIMER, resolveAccuracyToolTip);
				f.start();
				return;
			}
			if (Global.monies < Global.weaponUpgrade[weaponIndex][4][Global.weaponUpgrade[weaponIndex][4][0][1] + 1][1]) {
				button3.toolTip = generateTextTip("You do not have enough monies to purchase this upgrade!");
			}else {
				Global.monies -= Global.weaponUpgrade[weaponIndex][4][Global.weaponUpgrade[weaponIndex][4][0][1] + 1][1];
				Global.weaponUpgrade[weaponIndex][4][0][1]++;
				button3.toolTip = generateTextTip("We appreciate your business!");
				change.play();
				updateMoney();
			}
			var t:Timer = new Timer(2000, 1);
			t.addEventListener(TimerEvent.TIMER, resolveAccuracyToolTip);
			t.start();
		}
		private function resolveAccuracyToolTip(e:TimerEvent):void {
			button3.toolTip = accuracyToolTip(weaponIndex);
		}
		private function buyRollover():void {
			if (Global.rollover == false) {
				button7.toolTip = new Sprite();
				if (Global.monies < 400) {
					Sprite(button7.toolTip).addChild(generateTextTip("You do not have enough monies to purchase this upgrade!"));
				}else {
					Sprite(button7.toolTip).addChild(generateTextTip("We appreciate your business!"));
					//button7.toolTip.y -= button7.toolTip.height + 3;
					Global.rollover = true;
					Global.monies -= 400;
					updateMoney();
					change.play();
				}
				Sprite(button7.toolTip).getChildAt(0).y = -40;//-s.getChildAt(0).height;
			}
			var t:Timer = new Timer(2000, 1);
			t.addEventListener(TimerEvent.TIMER, resolveRolloverToolTip);
			t.start();
		}
		private function resolveRolloverToolTip(...args):void {
			if (weaponIndex != 0) {
				return;
			}
			button7.toolTip = new Sprite();
			if (Global.rollover == false) {
				Sprite(button7.toolTip).addChild(generateTextTip("Bullets that kill enemies continue to deal damage to those in their trajectory.\nCosts $400."));
			}else {
				Sprite(button7.toolTip).addChild(generateTextTip("Bullets that kill enemies continue to deal damage to those in their trajectory.\nAlready Purchased."));
			}
			Sprite(button7.toolTip).getChildAt(0).y -= 80;
		}
		private function buyBuckshot():void {
			var s:Sprite = new Sprite();
			if (Global.weaponUpgrade[1][5][0][1] == Global.weaponUpgrade[1][5].length - 1) {
				s.addChild(generateTextTip("I SAID YOU HAVE ALREADY MAXED OUT THIS UPGRADE!"));
				s.getChildAt(0).y -= 40;
				var f:Timer = new Timer(2000, 1);
				f.addEventListener(TimerEvent.TIMER, resolveBuckshotToolTip);
				f.start();
				return;
			}
			if (Global.monies < Global.weaponUpgrade[1][5][Global.weaponUpgrade[1][5][0][1] + 1][1]) {
				s.addChild(generateTextTip("You do not have enough monies to purchase this upgrade!"));
			}else {
				s.addChild(generateTextTip("We appreciate your business!"));
				Global.weaponUpgrade[1][5][0][1]++;
				Global.monies -= Global.weaponUpgrade[1][5][Global.weaponUpgrade[1][5][0][1]][1];
				updateMoney();
				change.play();
			}
			s.getChildAt(0).y -= 40;
			button7.toolTip = s;
			var t:Timer = new Timer(2000, 1);
			t.addEventListener(TimerEvent.TIMER, resolveBuckshotToolTip);
			t.start();
		}
		private function resolveBuckshotToolTip(e:TimerEvent):void {
			if (weaponIndex != 1) {
				return;
			}
			var s:Sprite = new Sprite();
			if (Global.weaponUpgrade[1][5][0][1] == Global.weaponUpgrade[1][5].length - 1) { 
				s.addChild(generateTextTip("You have reached the maximum amount of buckshot for this weapon.\nBullets Per Shot: 8"));
			}else {
				s.addChild(generateTextTip("(Level " + (Global.weaponUpgrade[1][5][0][1] + 1) + ")\nIncrease the number of bullets per shot from " + Global.weaponUpgrade[1][5][Global.weaponUpgrade[1][5][0][1]][0] + " to " + Global.weaponUpgrade[1][5][Global.weaponUpgrade[1][5][0][1] + 1][0] + ".\nCosts $" + Global.weaponUpgrade[1][5][Global.weaponUpgrade[1][5][0][1] + 1][1]));
			}
			s.getChildAt(0).y -= 80;
			button7.toolTip = s;
		}
		private function buyClipsize():void {
			if (Global.weaponUpgrade[2][5][0][1] == Global.weaponUpgrade[2][5].length - 1) {
				button7.toolTip = generateTextTip("Stop.  Hammer Time.");
				var f:Timer = new Timer(2000, 1);
				f.addEventListener(TimerEvent.TIMER, resolveClipsizeToolTip);
				f.start();
				return;
			}
			if (Global.monies < Global.weaponUpgrade[2][5][Global.weaponUpgrade[2][5][0][1] + 1][1]) {
				button7.toolTip = generateTextTip("You do not have enough monies to purchase this upgrade!");
			}else {
				button7.toolTip = new Sprite();
				Sprite(button7.toolTip).addChild(generateTextTip("We appreciate your business!"));
				Sprite(button7.toolTip).getChildAt(0).y -= 40;
				Global.weaponUpgrade[2][5][0][1]++;
				Global.monies -= Global.weaponUpgrade[2][5][Global.weaponUpgrade[2][5][0][1]][1];
				updateMoney();
				change.play();
			}
			var t:Timer = new Timer(2000, 1);
			t.addEventListener(TimerEvent.TIMER, resolveClipsizeToolTip);
			t.start();
		}
		private function resolveClipsizeToolTip(e:TimerEvent):void {
			if (weaponIndex != 2) {
				return;
			}
			var s:Sprite = new Sprite();
			if (Global.weaponUpgrade[2][5][0][1] == Global.weaponUpgrade[2][5].length - 1) { 
				s.addChild(generateTextTip("You have reached the maximum clip size for this weapon.\nShots Per Clip: 16"));
			}else {
				s.addChild(generateTextTip("(Level " + (Global.weaponUpgrade[2][5][0][1] + 1) + ")\nIncrease the number of bullets fired before a cooldown is needed from " + Global.weaponUpgrade[2][5][Global.weaponUpgrade[2][5][0][1]][0] + " to " + Global.weaponUpgrade[2][5][Global.weaponUpgrade[2][5][0][1] + 1][0] + ".\nCosts $" + Global.weaponUpgrade[2][5][Global.weaponUpgrade[2][5][0][1] + 1][1]));
			}
			s.getChildAt(0).y -= 80;
			button7.toolTip = s;
		}
		private function buyPiercing():void {
			if (Global.weaponUpgrade[3][1][0][1] == Global.weaponUpgrade[3][1].length - 1) {
				//button5.toolTip = generateTextTip("You have maxed out this upgrade!");
				resolvePiercingToolTip();
				return;
			}
			if (Global.monies < Global.weaponUpgrade[3][1][Global.weaponUpgrade[3][1][0][1] + 1][1]) {
				button5.toolTip = generateTextTip("You do not have enough monies to purchase this upgrade!");
			}else {
				button5.toolTip = generateTextTip("We appreciate your business!");
				Global.weaponUpgrade[3][1][0][1]++;
				Global.monies -= Global.weaponUpgrade[3][1][Global.weaponUpgrade[3][1][0][1]][1];
				updateMoney();
				change.play();
			}
			var t:Timer = new Timer(2000, 1);
			t.addEventListener(TimerEvent.TIMER, resolvePiercingToolTip);
			t.start();
		}
		private function resolvePiercingToolTip(...args):void {
			if (weaponIndex != 3) {
				return;
			}
			//Tooltip restoration code
			var s:Sprite;
			if (Global.weaponUpgrade[3][1][0][1] == Global.weaponUpgrade[3][1].length - 1) { 
				s =generateTextTip("You have reached the maximum amount of piercing for this weapon.\nUnits Piercing: 8 Per Shot");
			}else {
				s =generateTextTip("(Level " + (Global.weaponUpgrade[3][1][0][1] + 1) + ")\nIncrease the number of targets hit by a single bullet from " + Global.weaponUpgrade[3][1][Global.weaponUpgrade[3][1][0][1]][0] + " to " + Global.weaponUpgrade[3][1][Global.weaponUpgrade[3][1][0][1] + 1][0] + ".\nCosts $" + Global.weaponUpgrade[3][1][Global.weaponUpgrade[3][1][0][1] + 1][1]);
			}
			button5.toolTip = s;
		}
		public function updateMoney(...args):void {
			moneyField.text = ("You Have $" + Global.monies);
		}
		private function buyShotgun():void {
			if (Global.monies >= 1200) {
				Global.monies -= 1200;
				//shotgun.toolTip = generateTextTip("You may now use and upgrade this weapon.  Nice doin' bidness witcha.");
				Global.ownsShotgun = true;
				//regularMenu();
				updateMoney();
				shotgunMenu();
				register.play();
				addChild(new Notification("You may now use the Shotgun.  Press 2 during combat to select this weapon. \nClick to Remove...", new TextFormat("batik", 20, 0), 400, 0));
			}else{
				shotgun.toolTip = generateTextTip("You do not have enough money for this weapon.");
			}
		}
		private function buyUzi():void {
			if (Global.monies >= 2800) {
				Global.monies -= 2800;
				//uzi.toolTip = generateTextTip("You may now use and upgrade this weapon.  Enjoy!");
				Global.ownsUzi = true;
				//regularMenu();
				register.play();
				updateMoney();
				uziMenu();
				addChild(new Notification("You may now use the Uzi.  Press 3 during combat to select this weapon. \nClick to Remove...", new TextFormat("batik", 20, 0), 400, 0));
			}else {
				uzi.toolTip =  generateTextTip("You do not have enough money for this weapon.");
			}
		}
		private function buySniper():void {
			if (Global.monies >= 3600) {
				Global.monies -= 3600;
				//sniper.toolTip = generateTextTip("Boom, headshot.");
				Global.ownsSniper = true;
				//regularMenu();
				updateMoney();
				sniperMenu();
				register.play();
				addChild(new Notification("You may now use the Sniper.  Press 4 during combat to select this weapon. \nClick to Remove...", new TextFormat("batik", 20, 0), 400, 0));
			}else {
				sniper.toolTip = generateTextTip("You do not have enough money for this weapon.");
			}	
		}
		private function buyGatling():void {
			if (Global.monies >= 5000) {
				Global.monies -= 5000;
				//gatling.toolTip = generateTextTip("You may now use and upgrade this weapon.  MWAHAHAHA!");
				Global.ownsGatling = true;
				//regularMenu();
				register.play();
				updateMoney();
				uziMenu();
				addChild(new Notification("You may now use the Gatling Gun.  Press 5 during combat to select this weapon. \nClick to Remove...", new TextFormat("batik", 20, 0), 400, 0));
			}else {
				gatling.toolTip = generateTextTip("You do not have enough money for this upgrade.");
			}
		}
		public function fresh():void {
			regularMenu();
		}
	}
}