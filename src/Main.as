﻿package 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.HTTPStatusEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Matrix;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.ui.Keyboard;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	import Longarm;
	import flash.events.KeyboardEvent;
	import flash.utils.getTimer;
	import SmoothTween;
	import flash.display.BitmapDataChannel;
	import AmbientZombies;
	import flash.media.SoundMixer;
	import flash.system.System;
	import flash.events.ContextMenuEvent;
	import flash.net.URLRequest;
	import flash.net.navigateToURL;
	import mochi.as3.MochiScores;
	import AGcontainer;
	
	[Frame(factoryClass="Preloader")]
	public class Main extends Sprite {
		public var player:Owner = new Owner();
		public var zom:Owner = new Owner();
		
		public var jim:Hero;
		private var healthIndicator:Clip;
		
		private var heroLayer:Sprite = new Sprite();
		private var guts:Sprite = new Sprite();
		public var zombieLayer:Sprite = new Sprite();
		private var environment:Sprite = new Sprite();
		private var topLevel:Sprite = new Sprite();
		private var oceanLayer:Sprite = new Sprite();
		private var middleLayer:Sprite = new Sprite();
		private var totalLayer:Sprite = new Sprite();
		private var foolmeonce:Boolean = false;
		public static var oldGuts:StaticMap = new StaticMap(1838, 1785);
		
		public var cammy:Camera = new Camera(new Rectangle(0, 0, 500, 500), new Rectangle(0, 0, 500, 500), totalLayer, 30);
		
		//private var moneyBar:TextField = Global.pointBar;
		private var gunBox:Clip;
		
		private var back:Bitmap;
		private var zombietext:Bitmap;
		private var tx:TextField;
		//private var tx2:TextField;
		//private var tx3:TextField;
		private var bu:Button;
		//private var b2:Button;
		//private var b3:Button;
		private var whiteBurn:Clip;
		private var whiteMask:Clip;
		private var deathMask:Clip;
		private var txLoad:TextField;
		private var reverseBurn:Clip;
		
		private var submitButton:Button;
		private var scoresText:TextField;
		private var continueButton:Button;
		private var restartButton:Button;		
		private var retoolButton:Button;
		private var deathScreen:Clip = new Clip();
		public static var reference:Main;
		
		private var saveArray:Array = [new SaveFile()];
		private var startingSong:Sound;
		private var songChannel:SoundChannel;
		
		private var leveltext:TextField = new TextField();
		private var muteButton:Button = new Button;
		private var retool:Boolean;
		private var retemp:SaveFile;//saves a copy after menu exit for retool skipping.
		
		[Embed(source = '../graphics/aimer.png')]private static const aimer:Class;
		[Embed(source = '../graphics/cursor.png')]private static const hnd:Class;
		private var cursor:Bitmap;
		private var hand:Bitmap = new hnd;
		private var crosshair:Bitmap = new aimer;
		
		private var topscore : uint = 0;
			
		public function Main():void {	//done for compatibility with mochi wrapper
			/*
			//[Embed(source = '../graphics/agteaser.swc', mimeType = 'application/octet-stream')]var intro : Class;
			[Embed(source = '../graphics/agteaser.swf', mimeType = 'application/octet-stream')]var agteaser : Class;
			
			var loader : Loader = new Loader();
			loader.loadBytes(new agteaser());

			var intro : Class = loader.contentLoaderInfo.applicationDomain.getDefinition("agteaser") as Class;
			
			var splash : MovieClip = new intro() as MovieClip;
			addChild(splash);
			splash.play();
			*/
			//splash.addEventListener(Event.COMPLETE, callMain);
			
			var t:Timer = new Timer(10, 1);
			t.addEventListener(TimerEvent.TIMER, callMain);
			t.start();
			
			//callMain();
		}
		
		public function callMain(...args):void {
			/*Mouse Cursor Management!*/
			Mouse.hide();
			cursor = hand;
			var flow:Timer = new Timer(20);
			flow.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void { cursor.x = stage.mouseX - cursor.width / 2; cursor.y = stage.mouseY - cursor.height / 2; } );
			flow.start();
			
			reference = this;
			[Embed(source = '../graphics/Title and Death Screens/pngs/assembled.png')]const b:Class;
			back = new b();
			addChild(back);
			/*
			[Embed(source='../graphics/Title and Death Screens/pngs/zombie.png')]const c:Class;
			zombietext = new c();
			zombietext.y = 25;
			addChild(zombietext);
			*/
			tx = new TextField();
			tx.defaultTextFormat = new TextFormat("batik", 25);
			tx.text = "CLICK \n TO PLAY";
			tx.width = 100;
			tx.wordWrap = true;
			tx.selectable = false;
			tx.embedFonts = true;
			tx.y = 350;
			tx.x = 25;
			addChild(tx);
			bu = new Button();
			bu.hitArea = new Sprite();
			var rrr:Rectangle = tx.getBounds(stage);
			bu.x = rrr.x;
			bu.y = rrr.y;
			bu.hitArea.graphics.beginFill(0, 0);
			bu.hitArea.graphics.drawRect(0, 0, rrr.width, rrr.height);
			bu.hitArea.graphics.endFill();
			bu.addChild(bu.hitArea);
			addChild(bu);
			bu.release = minorTrans2;
			//bu.release = minorTrans1;
			/*
			tx2 = new TextField();
			tx2.defaultTextFormat = new TextFormat("batik", 25);
			tx2.width = 150;
			tx2.x = -tx2.width;
			tx2.y = 350;
			tx2.selectable = false;
			tx2.embedFonts = true;
			addChild(tx2);
			tx2.text = "Normal \n\nTough";
			*/
			[Embed(source = '../Sound/final/titlescreen.mp3')]const sng:Class;
			startingSong = new sng();
			songChannel = startingSong.play(0, int.MAX_VALUE);
			
			//leveltext.defaultTextFormat = new TextFormat("batik", 50, 0xFFFFFF);
			leveltext.embedFonts = true;
			leveltext.selectable = false;
			leveltext.y = 100;
			leveltext.width = 450;
			
			addChild(cursor);
			//Context Menu moved to preloader
			/*var author:ContextMenuItem = new ContextMenuItem("Created by Joel Evans");
			author.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(e:Event):void { navigateToURL(new URLRequest("http://adventuresofjoel.com/pages/home.htm")) } );
			var sponsor:ContextMenuItem = new ContextMenuItem("Addictinggames");	//SPONSOR INFO INSERT
			sponsor.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(e:Event):void { navigateToURL(new URLRequest("http://www.google.com/search?sourceid=chrome&ie=UTF-8&q=FLASH+GAME+SPONSOR")) } );
			
			var con:ContextMenu = new ContextMenu();
			con.hideBuiltInItems();
			con.customItems = [author, sponsor];
			contextMenu = con;
			
			contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, menuselect);*/
			//SoundMixer.soundTransform = new SoundTransform(0);	//MUTES THE GAME. FOR TESTING ONLY, SO'S I CAN LISTEN MY MY MUSIC.
		}
		
		/*	Moved to preloader
		private function menuselect(e:Event):void {
			addEventListener(MouseEvent.CLICK, menureturn);	//THIS IS NOT CALLED WHEN OTHER CLICK EVENTS ARE PRESENT.  IDK WHY.	  Putting mouse.hide in other event listeners.
		}
		private function menureturn(e:MouseEvent):void {
			removeEventListener(MouseEvent.CLICK, menureturn);
			Mouse.hide();
		}*/
		
		public function init(...args):void {
			visuals();
			obstacles();
			Splatter.generateSplatter(300, new RadialVector(new Point(0, -8), 0, 0, 16), new RadialVector(new Point(70, -25), 0, 0, 50), new ColorRandomizer(0,0, 255, 100, 0, 0, 25, 0), 3, 20);
			Destructable.destructLayer = guts;
			
			/*Removes listener created to call init*/
			stage.removeEventListener(MouseEvent.CLICK, init);
			stage.focus = null;
			/*
			var da:Array = Path.divideEnclosedNodes(Hero.staticObstacles);
			turretLayer.graphics.lineStyle(1, 0x00FF00);
			for (var p:uint = 0; p < da[0].length; p++) {
				turretLayer.graphics.drawCircle(da[0][p].x, da[0][p].y, 10);
			}
			turretLayer.graphics.lineStyle(1, 0xFF0000);
			for (p = 0; p < da[1].length; p++) {
				turretLayer.graphics.drawCircle(da[1][p].x, da[1][p].y, 10);
			}
			turretLayer.graphics.lineStyle(1, 0x0000FF);
			
			/*
			var pat:Array = Path.findPath(new Point(300, 0), new Point(3000, 0), Hero.staticObstacles);
			turretLayer.graphics.moveTo(300, 0);
			for (p = 0; p < pat.length; p++) {
				turretLayer.graphics.lineTo(pat[p].x, pat[p].y);
			}*/
			
			/*
			var sp:Sprite = new Sprite();
			turretLayer.addChild(sp);
			//VISUALLY MAPS OUT THE HERO OBSTACLE VECTORS
			sp.graphics.lineStyle(3, 16740960);
			for (ad = 0; ad < Hero.staticObstacles.length; ad++) {
				if(Hero.staticObstacles[ad] is LinearVector){
					sp.graphics.moveTo(Hero.staticObstacles[ad].anchor.x, Hero.staticObstacles[ad].anchor.y)
					sp.graphics.lineTo(Hero.staticObstacles[ad].destination.x, Hero.staticObstacles[ad].destination.y)
				}else {
					sp.graphics.drawCircle(Hero.staticObstacles[ad].anchor.x, Hero.staticObstacles[ad].anchor.y, Hero.staticObstacles[ad].radius);
				}
			}
			//end
			
			//VISUALLY MAPS OUT THE DESTRUCTABLWALKER OBSTACLE VECTORS
			sp.graphics.lineStyle(3, 1433605);
			for (var ad:uint = 0; ad < DestructableWalker.staticObstacles.length; ad++) {
				if(DestructableWalker.staticObstacles[ad] is LinearVector){
					sp.graphics.moveTo(DestructableWalker.staticObstacles[ad].anchor.x, DestructableWalker.staticObstacles[ad].anchor.y)
					sp.graphics.lineTo(DestructableWalker.staticObstacles[ad].destination.x, DestructableWalker.staticObstacles[ad].destination.y)
				}else {
					sp.graphics.drawCircle(DestructableWalker.staticObstacles[ad].anchor.x, DestructableWalker.staticObstacles[ad].anchor.y, DestructableWalker.staticObstacles[ad].radius);
				}
			}
			//end
			*/
			/*
			var sp:Sprite = new Sprite();
			totalLayer.addChild(sp);
			//VISUALLY MAPS OUT THE PATHING NODES
			sp.graphics.lineStyle(3, 16740960);
			for (var ty:uint = 0; ty < DestructableWalker.nodes.length; ty++) {
				sp.graphics.drawCircle(DestructableWalker.nodes[ty].x, DestructableWalker.nodes[ty].y, 3);
			}
			//end
			*/
			//adding the hero
			//Global.resetDefaults();
			jim = new Hero(player);
			jim.x = 72;
			jim.y = -173;
			saveArray[0].saveGlobal();  //This must come after new Hero(), because it records Hero position.
			
			heroLayer.addChild(jim);
			cammy.follow = jim;
			//cam1.follow = cam2.follow = cam3.follow = cam4.follow = cam5.follow = jim;
			
			ProximitySpawnPoint.parent = zombieLayer;
			ProximitySpawnPoint.spawnDelay = 450;
			ProximitySpawnPoint.spawnOwner = zom;
			ProximitySpawnPoint.target = jim;
			ProximitySpawnPoint.proximity = 350;
			
			/*
			//	POINT REDUCTION
			var opti:Array = Path.divideEnclosedNodes(Hero.staticObstacles, 3, false)[1];
			var pts:Array = Path.generateVectorNodes(DestructableWalker.staticObstacles);
			var v:LinearVector = new LinearVector(new Point(), new Point());
			top: for (var a:uint = 0; a < pts.length; a++) {	//filters all pts outside of the main area
				v.anchor = pts[a];
				for (var b:uint = 0; b < opti.length; b++) {
					v.destination = opti[b];
					if (v.collisionOccurs(Hero.staticObstacles) == false) {
						continue top;
					}
				}
				pts.splice(a, 1);
				a--;
			}
			var sp:Sprite = new Sprite();
			sp.graphics.lineStyle(1, 255);
			for (a = 0; a < pts.length; a++) {//draws the points
				sp.graphics.drawCircle(pts[a].x, pts[a].y, 5);
				trace(pts[a]);
			}
			DestructableWalker.prePath = new CachedPath(pts, DestructableWalker.staticObstacles);				
			*/
			//DestructableWalker.prePath = new CachedPath([new Point(271, -479), new Point(360.0604335563131, -529.0018277777501), new Point(1055, 664), new Point(784, 674), new Point(417, 656), new Point(203, 759), new Point(56, 674), new Point( -289.3991018391502, 729.2006744090877), new Point( -381.4843460976219, 649.1432030269882), new Point( -89.03523617876226, -499.7368825942079), new Point( -200.96476382123774, -530.2631174057921), new Point( -200.96476382123774, -499.7368825942079), new Point( -89.03523617876226, -530.2631174057921), new Point(1004.696796342723, -29.047074219986737), new Point(1040.303203657277, -140.95292578001326), new Point(1040.303203657277, -29.047074219986737), new Point(1004.696796342723, -140.95292578001326), new Point(1004.7206704591699, 249.0398047033964), new Point(1037.27932954083, 360.96019529660356), new Point(1004.7206704591699, 360.96019529660356), new Point(1037.27932954083, 249.0398047033964), new Point(471.13992102513606, -235.48983908715294), new Point(588.4106157414747, -343.91180848474517), new Point(519.5893842585253, -191.08819151525486), new Point( -283.73502185420614, 242.3219565841044), new Point( -153.26497814579386, 362.6780434158956), new Point( -213.94893036447175, 389.9986950947747), new Point( -223.05106963552825, 212.0013049052253), new Point( -190.49613893835684, -350.86824314212447), new Point( -107, -207), new Point( -296.99632055783536, -193.9142950057776), new Point(973, -420), new Point(721, -274.5077321642143), new Point(721, -565.4922678357856), new Point( -143.5, 650), new Point( -190.75, 677.2798002192098), new Point( -190.75, 622.7201997807902), new Point(161, 542), new Point(129.5, 560.1865334794732), new Point(129.5, 523.8134665205268), new Point(647, 320), new Point(584, 356.3730669589464), new Point(584, 283.6269330410536), new Point(838.5, 55), new Point(728.25, 118.65286717815624), new Point(728.25, -8.652867178156207), new Point(260.59999999999997, 90), new Point( -10.29999999999994, 246.4041879234696), new Point( -10.300000000000068, -66.40418792346955)], DestructableWalker.staticObstacles);	
			DestructableWalker.prePath = new CachedPath([new Point(271, -479),new Point(360.0604335563131, -529.0018277777501),new Point(1055, 664),new Point(784, 674),new Point(417, 656),new Point(203, 759),new Point(56, 674),new Point(-289.3991018391502, 729.2006744090877),new Point(-381.4843460976219, 649.1432030269882),new Point(-89.03523617876226, -499.7368825942079),new Point(-200.96476382123774, -530.2631174057921),new Point(-200.96476382123774, -499.7368825942079),new Point(-89.03523617876226, -530.2631174057921),new Point(1004.696796342723, -29.047074219986737),new Point(1040.303203657277, -140.95292578001326),new Point(1040.303203657277, -29.047074219986737),new Point(1004.696796342723, -140.95292578001326),new Point(1004.7206704591699, 249.0398047033964),new Point(1037.27932954083, 360.96019529660356),new Point(1004.7206704591699, 360.96019529660356),new Point(1037.27932954083, 249.0398047033964),new Point(471.13992102513606, -235.48983908715294),new Point(735.860078974864, -392.5101609128471),new Point(588.4106157414747, -343.91180848474517),new Point(519.5893842585253, -191.08819151525486),new Point(-283.73502185420614, 242.3219565841044),new Point(-153.26497814579386, 362.6780434158956),new Point(-213.94893036447175, 389.9986950947747),new Point(-223.05106963552825, 212.0013049052253),new Point(-190.49613893835684, -350.86824314212447),new Point(-109.50386106164316, -209.13175685787553),new Point(-109.00367944216465, -210.0857049942224),new Point(-296.99632055783536, -193.9142950057776),new Point(897.1169779390614, -420),new Point(879.5242006231628, -365.8549988816686),new Point(833.4657116536321, -332.39154786963877),new Point(776.5342883463679, -332.39154786963877),new Point(730.4757993768372, -365.8549988816686),new Point(712.8830220609386, -420),new Point(730.4757993768372, -474.1450011183314),new Point(776.5342883463679, -507.60845213036123),new Point(833.4657116536321, -507.60845213036123),new Point(879.5242006231628, -474.1450011183314),new Point(-157.72806663642598, 650),new Point(-161.026712383157, 660.1521877096872),new Point(-169.66267906494397, 666.4265847744427),new Point(-180.33732093505603, 666.4265847744427),new Point(-188.973287616843, 660.1521877096872),new Point(-192.27193336357402, 650),new Point(-188.973287616843, 639.8478122903128),new Point(-180.33732093505603, 633.5734152255573),new Point(-169.662679064944, 633.5734152255573),new Point(-161.026712383157, 639.8478122903128),new Point(151.51462224238267, 542),new Point(149.31552507789536, 548.7681251397914),new Point(143.558213956704, 552.9510565162951),new Point(136.441786043296, 552.9510565162951),new Point(130.68447492210464, 548.7681251397914),new Point(128.48537775761733, 542),new Point(130.68447492210464, 535.2318748602086),new Point(136.441786043296, 531.0489434837049),new Point(143.558213956704, 531.0489434837049),new Point(149.31552507789536, 535.2318748602086),new Point(628.0292444847654, 320),new Point(623.6310501557907, 333.5362502795829),new Point(612.1164279134081, 341.9021130325903),new Point(597.8835720865919, 341.9021130325903),new Point(586.3689498442093, 333.5362502795829),new Point(581.9707555152346, 320),new Point(586.3689498442093, 306.4637497204172),new Point(597.8835720865919, 298.0978869674097),new Point(612.116427913408, 298.0978869674097),new Point(623.6310501557907, 306.4637497204171),new Point(805.3011778483393, 55),new Point(797.6043377726337, 78.68843798926997),new Point(777.453748848464, 93.32869780703304),new Point(752.546251151536, 93.32869780703305),new Point(732.3956622273663, 78.68843798926999),new Point(724.6988221516607, 55.00000000000001),new Point(732.3956622273663, 31.311562010730025),new Point(752.5462511515359, 16.671302192966962),new Point(777.453748848464, 16.671302192966955),new Point(797.6043377726337, 31.31156201073001),new Point(179.02575128449098, 90),new Point(160.11351566989998, 148.20587620220624),new Point(110.60064002765449, 184.17908604013832),new Point(49.399359972345515, 184.17908604013832),new Point(-0.11351566989996797, 148.20587620220624),new Point(-19.02575128449098, 90.00000000000001),new Point(-0.1135156698999964, 31.794123797793787),new Point(49.39935997234549, -4.179086040138316),new Point(110.60064002765446, -4.17908604013833),new Point(160.11351566989998, 31.794123797793752)], DestructableWalker.staticObstacles);
			DestructableWalker.prePath.importMatrix(
			);
			
			//DestructableWalker.prePath.calculateMatrix();
			/*
			DestructableWalker.prePath.importMatrix(
			[[[new Point(271,-479)],[new Point(271,-479),new Point(360.0604335563131,-529.0018277777501)],[new Point(271,-479),new Point(1055,664)],[new Point(271,-479),new Point(647,320),new Point(784,674)],[new Point(271,-479),new Point(417,656)],[new Point(271,-479),new Point(203,759)],[new Point(271,-479),new Point(129.5,523.8134665205268),new Point(56,674)],[new Point(271,-479),new Point(-10.300000000000068,-66.40418792346955),new Point(-153.26497814579386,362.6780434158956),new Point(-289.3991018391502,729.2006744090877)],[new Point(271,-479),new Point(-10.300000000000068,-66.40418792346955),new Point(-153.26497814579386,362.6780434158956),new Point(-381.4843460976219,649.1432030269882)],[new Point(271,-479),new Point(-89.03523617876226,-499.7368825942079)],[new Point(271,-479),new Point(-89.03523617876226,-530.2631174057921),new Point(-200.96476382123774,-530.2631174057921)],[new Point(271,-479),new Point(-200.96476382123774,-499.7368825942079)],[new Point(271,-479),new Point(-89.03523617876226,-530.2631174057921)],[new Point(271,-479),new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(1004.696796342723,-29.047074219986737)],[new Point(271,-479),new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(1040.303203657277,-140.95292578001326)],[new Point(271,-479),new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(1004.696796342723,-29.047074219986737),new Point(1040.303203657277,-29.047074219986737)],[new Point(271,-479),new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(1004.696796342723,-140.95292578001326)],[new Point(271,-479),new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(838.5,55),new Point(1004.7206704591699,249.0398047033964)],[new Point(271,-479),new Point(728.25,118.65286717815624),new Point(1004.7206704591699,360.96019529660356),new Point(1037.27932954083,360.96019529660356)],[new Point(271,-479),new Point(728.25,118.65286717815624),new Point(1004.7206704591699,360.96019529660356)],[new Point(271,-479),new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(838.5,55),new Point(1037.27932954083,249.0398047033964)],[new Point(271,-479),new Point(471.13992102513606,-235.48983908715294)],[new Point(271,-479),new Point(588.4106157414747,-343.91180848474517)],[new Point(271,-479),new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486)],[new Point(271,-479),new Point(-283.73502185420614,242.3219565841044)],[new Point(271,-479),new Point(-10.300000000000068,-66.40418792346955),new Point(-153.26497814579386,362.6780434158956)],[new Point(271,-479),new Point(-10.300000000000068,-66.40418792346955),new Point(-153.26497814579386,362.6780434158956),new Point(-213.94893036447175,389.9986950947747)],[new Point(271,-479),new Point(-223.05106963552825,212.0013049052253)],[new Point(271,-479),new Point(-190.49613893835684,-350.86824314212447)],[new Point(271,-479),new Point(-107,-207)],[new Point(271,-479),new Point(-107,-207),new Point(-296.99632055783536,-193.9142950057776)],[new Point(271,-479),new Point(721,-565.4922678357856),new Point(973,-420)],[new Point(271,-479),new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(721,-274.5077321642143)],[new Point(271,-479),new Point(721,-565.4922678357856)],[new Point(271,-479),new Point(-10.300000000000068,-66.40418792346955),new Point(-143.5,650)],[new Point(271,-479),new Point(-10.300000000000068,-66.40418792346955),new Point(-190.75,622.7201997807902),new Point(-190.75,677.2798002192098)],[new Point(271,-479),new Point(-10.300000000000068,-66.40418792346955),new Point(-190.75,622.7201997807902)],[new Point(271,-479),new Point(161,542)],[new Point(271,-479),new Point(129.5,523.8134665205268),new Point(129.5,560.1865334794732)],[new Point(271,-479),new Point(129.5,523.8134665205268)],[new Point(271,-479),new Point(647,320)],[new Point(271,-479),new Point(584,356.3730669589464)],[new Point(271,-479),new Point(584,283.6269330410536)],[new Point(271,-479),new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(838.5,55)],[new Point(271,-479),new Point(728.25,118.65286717815624)],[new Point(271,-479),new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(728.25,-8.652867178156207)],[new Point(271,-479),new Point(260.59999999999997,90)],[new Point(271,-479),new Point(-10.300000000000068,-66.40418792346955),new Point(-10.29999999999994,246.4041879234696)],[new Point(271,-479),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(360.0604335563131,-529.0018277777501),new Point(271,-479)],[new Point(360.0604335563131,-529.0018277777501)],[new Point(360.0604335563131,-529.0018277777501),new Point(471.13992102513606,-235.48983908715294),new Point(1055,664)],[new Point(360.0604335563131,-529.0018277777501),new Point(784,674)],[new Point(360.0604335563131,-529.0018277777501),new Point(417,656)],[new Point(360.0604335563131,-529.0018277777501),new Point(203,759)],[new Point(360.0604335563131,-529.0018277777501),new Point(56,674)],[new Point(360.0604335563131,-529.0018277777501),new Point(-10.300000000000068,-66.40418792346955),new Point(-153.26497814579386,362.6780434158956),new Point(-289.3991018391502,729.2006744090877)],[new Point(360.0604335563131,-529.0018277777501),new Point(-10.300000000000068,-66.40418792346955),new Point(-153.26497814579386,362.6780434158956),new Point(-381.4843460976219,649.1432030269882)],[new Point(360.0604335563131,-529.0018277777501),new Point(-107,-207),new Point(-89.03523617876226,-499.7368825942079)],[new Point(360.0604335563131,-529.0018277777501),new Point(-107,-207),new Point(-200.96476382123774,-499.7368825942079),new Point(-200.96476382123774,-530.2631174057921)],[new Point(360.0604335563131,-529.0018277777501),new Point(-107,-207),new Point(-200.96476382123774,-499.7368825942079)],[new Point(360.0604335563131,-529.0018277777501),new Point(-107,-207),new Point(-89.03523617876226,-499.7368825942079),new Point(-89.03523617876226,-530.2631174057921)],[new Point(360.0604335563131,-529.0018277777501),new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(1004.696796342723,-29.047074219986737)],[new Point(360.0604335563131,-529.0018277777501),new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(1040.303203657277,-140.95292578001326)],[new Point(360.0604335563131,-529.0018277777501),new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(1004.696796342723,-29.047074219986737),new Point(1040.303203657277,-29.047074219986737)],[new Point(360.0604335563131,-529.0018277777501),new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(1004.696796342723,-140.95292578001326)],[new Point(360.0604335563131,-529.0018277777501),new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(838.5,55),new Point(1004.7206704591699,249.0398047033964)],[new Point(360.0604335563131,-529.0018277777501),new Point(471.13992102513606,-235.48983908715294),new Point(728.25,118.65286717815624),new Point(1004.7206704591699,360.96019529660356),new Point(1037.27932954083,360.96019529660356)],[new Point(360.0604335563131,-529.0018277777501),new Point(471.13992102513606,-235.48983908715294),new Point(728.25,118.65286717815624),new Point(1004.7206704591699,360.96019529660356)],[new Point(360.0604335563131,-529.0018277777501),new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(838.5,55),new Point(1037.27932954083,249.0398047033964)],[new Point(360.0604335563131,-529.0018277777501),new Point(471.13992102513606,-235.48983908715294)],[new Point(360.0604335563131,-529.0018277777501),new Point(588.4106157414747,-343.91180848474517)],[new Point(360.0604335563131,-529.0018277777501),new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486)],[new Point(360.0604335563131,-529.0018277777501),new Point(-283.73502185420614,242.3219565841044)],[new Point(360.0604335563131,-529.0018277777501),new Point(-10.300000000000068,-66.40418792346955),new Point(-153.26497814579386,362.6780434158956)],[new Point(360.0604335563131,-529.0018277777501),new Point(-10.300000000000068,-66.40418792346955),new Point(-153.26497814579386,362.6780434158956),new Point(-213.94893036447175,389.9986950947747)],[new Point(360.0604335563131,-529.0018277777501),new Point(-223.05106963552825,212.0013049052253)],[new Point(360.0604335563131,-529.0018277777501),new Point(-107,-207),new Point(-190.49613893835684,-350.86824314212447)],[new Point(360.0604335563131,-529.0018277777501),new Point(-107,-207)],[new Point(360.0604335563131,-529.0018277777501),new Point(-107,-207),new Point(-296.99632055783536,-193.9142950057776)],[new Point(360.0604335563131,-529.0018277777501),new Point(721,-565.4922678357856),new Point(973,-420)],[new Point(360.0604335563131,-529.0018277777501),new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(721,-274.5077321642143)],[new Point(360.0604335563131,-529.0018277777501),new Point(721,-565.4922678357856)],[new Point(360.0604335563131,-529.0018277777501),new Point(260.59999999999997,90),new Point(-143.5,650)],[new Point(360.0604335563131,-529.0018277777501),new Point(-10.300000000000068,-66.40418792346955),new Point(-190.75,622.7201997807902),new Point(-190.75,677.2798002192098)],[new Point(360.0604335563131,-529.0018277777501),new Point(-10.300000000000068,-66.40418792346955),new Point(-190.75,622.7201997807902)],[new Point(360.0604335563131,-529.0018277777501),new Point(161,542)],[new Point(360.0604335563131,-529.0018277777501),new Point(129.5,523.8134665205268),new Point(129.5,560.1865334794732)],[new Point(360.0604335563131,-529.0018277777501),new Point(129.5,523.8134665205268)],[new Point(360.0604335563131,-529.0018277777501),new Point(647,320)],[new Point(360.0604335563131,-529.0018277777501),new Point(584,356.3730669589464)],[new Point(360.0604335563131,-529.0018277777501),new Point(584,283.6269330410536)],[new Point(360.0604335563131,-529.0018277777501),new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(838.5,55)],[new Point(360.0604335563131,-529.0018277777501),new Point(471.13992102513606,-235.48983908715294),new Point(728.25,118.65286717815624)],[new Point(360.0604335563131,-529.0018277777501),new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(728.25,-8.652867178156207)],[new Point(360.0604335563131,-529.0018277777501),new Point(260.59999999999997,90)],[new Point(360.0604335563131,-529.0018277777501),new Point(-10.300000000000068,-66.40418792346955),new Point(-10.29999999999994,246.4041879234696)],[new Point(360.0604335563131,-529.0018277777501),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(1055,664),new Point(271,-479)],[new Point(1055,664),new Point(471.13992102513606,-235.48983908715294),new Point(360.0604335563131,-529.0018277777501)],[new Point(1055,664)],[new Point(1055,664),new Point(784,674)],[new Point(1055,664),new Point(417,656)],[new Point(1055,664),new Point(417,656),new Point(203,759)],[new Point(1055,664),new Point(417,656),new Point(56,674)],[new Point(1055,664),new Point(417,656),new Point(56,674),new Point(-289.3991018391502,729.2006744090877)],[new Point(1055,664),new Point(417,656),new Point(-190.75,677.2798002192098),new Point(-381.4843460976219,649.1432030269882)],[new Point(1055,664),new Point(-89.03523617876226,-499.7368825942079)],[new Point(1055,664),new Point(-200.96476382123774,-499.7368825942079),new Point(-200.96476382123774,-530.2631174057921)],[new Point(1055,664),new Point(-200.96476382123774,-499.7368825942079)],[new Point(1055,664),new Point(-89.03523617876226,-530.2631174057921)],[new Point(1055,664),new Point(1037.27932954083,249.0398047033964),new Point(1004.696796342723,-29.047074219986737)],[new Point(1055,664),new Point(1040.303203657277,-140.95292578001326)],[new Point(1055,664),new Point(1040.303203657277,-29.047074219986737)],[new Point(1055,664),new Point(1037.27932954083,249.0398047033964),new Point(1004.696796342723,-29.047074219986737),new Point(1004.696796342723,-140.95292578001326)],[new Point(1055,664),new Point(1004.7206704591699,360.96019529660356),new Point(1004.7206704591699,249.0398047033964)],[new Point(1055,664),new Point(1037.27932954083,360.96019529660356)],[new Point(1055,664),new Point(1004.7206704591699,360.96019529660356)],[new Point(1055,664),new Point(1037.27932954083,249.0398047033964)],[new Point(1055,664),new Point(471.13992102513606,-235.48983908715294)],[new Point(1055,664),new Point(471.13992102513606,-235.48983908715294),new Point(588.4106157414747,-343.91180848474517)],[new Point(1055,664),new Point(519.5893842585253,-191.08819151525486)],[new Point(1055,664),new Point(-223.05106963552825,212.0013049052253),new Point(-283.73502185420614,242.3219565841044)],[new Point(1055,664),new Point(-153.26497814579386,362.6780434158956)],[new Point(1055,664),new Point(-213.94893036447175,389.9986950947747)],[new Point(1055,664),new Point(-223.05106963552825,212.0013049052253)],[new Point(1055,664),new Point(647,320),new Point(-190.49613893835684,-350.86824314212447)],[new Point(1055,664),new Point(647,320),new Point(-107,-207)],[new Point(1055,664),new Point(584,356.3730669589464),new Point(260.59999999999997,90),new Point(-10.300000000000068,-66.40418792346955),new Point(-296.99632055783536,-193.9142950057776)],[new Point(1055,664),new Point(1037.27932954083,249.0398047033964),new Point(1004.696796342723,-29.047074219986737),new Point(973,-420)],[new Point(1055,664),new Point(721,-274.5077321642143)],[new Point(1055,664),new Point(1037.27932954083,249.0398047033964),new Point(1004.696796342723,-29.047074219986737),new Point(973,-420),new Point(721,-565.4922678357856)],[new Point(1055,664),new Point(-143.5,650)],[new Point(1055,664),new Point(417,656),new Point(-190.75,677.2798002192098)],[new Point(1055,664),new Point(-190.75,622.7201997807902)],[new Point(1055,664),new Point(161,542)],[new Point(1055,664),new Point(129.5,560.1865334794732)],[new Point(1055,664),new Point(129.5,523.8134665205268)],[new Point(1055,664),new Point(647,320)],[new Point(1055,664),new Point(584,356.3730669589464)],[new Point(1055,664),new Point(647,320),new Point(584,283.6269330410536)],[new Point(1055,664),new Point(838.5,55)],[new Point(1055,664),new Point(728.25,118.65286717815624)],[new Point(1055,664),new Point(728.25,118.65286717815624),new Point(728.25,-8.652867178156207)],[new Point(1055,664),new Point(584,356.3730669589464),new Point(260.59999999999997,90)],[new Point(1055,664),new Point(-10.29999999999994,246.4041879234696)],[new Point(1055,664),new Point(584,356.3730669589464),new Point(260.59999999999997,90),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(784,674),new Point(647,320),new Point(271,-479)],[new Point(784,674),new Point(360.0604335563131,-529.0018277777501)],[new Point(784,674),new Point(1055,664)],[new Point(784,674)],[new Point(784,674),new Point(417,656)],[new Point(784,674),new Point(417,656),new Point(203,759)],[new Point(784,674),new Point(417,656),new Point(56,674)],[new Point(784,674),new Point(417,656),new Point(56,674),new Point(-289.3991018391502,729.2006744090877)],[new Point(784,674),new Point(417,656),new Point(-190.75,677.2798002192098),new Point(-381.4843460976219,649.1432030269882)],[new Point(784,674),new Point(-89.03523617876226,-499.7368825942079)],[new Point(784,674),new Point(-200.96476382123774,-499.7368825942079),new Point(-200.96476382123774,-530.2631174057921)],[new Point(784,674),new Point(-200.96476382123774,-499.7368825942079)],[new Point(784,674),new Point(-89.03523617876226,-530.2631174057921)],[new Point(784,674),new Point(1004.696796342723,-29.047074219986737)],[new Point(784,674),new Point(1040.303203657277,-29.047074219986737),new Point(1040.303203657277,-140.95292578001326)],[new Point(784,674),new Point(1040.303203657277,-29.047074219986737)],[new Point(784,674),new Point(1004.696796342723,-140.95292578001326)],[new Point(784,674),new Point(1004.7206704591699,249.0398047033964)],[new Point(784,674),new Point(1037.27932954083,360.96019529660356)],[new Point(784,674),new Point(1004.7206704591699,360.96019529660356)],[new Point(784,674),new Point(1004.7206704591699,249.0398047033964),new Point(1037.27932954083,249.0398047033964)],[new Point(784,674),new Point(471.13992102513606,-235.48983908715294)],[new Point(784,674),new Point(471.13992102513606,-235.48983908715294),new Point(588.4106157414747,-343.91180848474517)],[new Point(784,674),new Point(519.5893842585253,-191.08819151525486)],[new Point(784,674),new Point(-223.05106963552825,212.0013049052253),new Point(-283.73502185420614,242.3219565841044)],[new Point(784,674),new Point(-153.26497814579386,362.6780434158956)],[new Point(784,674),new Point(-213.94893036447175,389.9986950947747)],[new Point(784,674),new Point(-223.05106963552825,212.0013049052253)],[new Point(784,674),new Point(-190.49613893835684,-350.86824314212447)],[new Point(784,674),new Point(260.59999999999997,90),new Point(-107,-207)],[new Point(784,674),new Point(260.59999999999997,90),new Point(-10.300000000000068,-66.40418792346955),new Point(-296.99632055783536,-193.9142950057776)],[new Point(784,674),new Point(973,-420)],[new Point(784,674),new Point(728.25,118.65286717815624),new Point(721,-274.5077321642143)],[new Point(784,674),new Point(471.13992102513606,-235.48983908715294),new Point(721,-565.4922678357856)],[new Point(784,674),new Point(417,656),new Point(-143.5,650)],[new Point(784,674),new Point(417,656),new Point(-190.75,677.2798002192098)],[new Point(784,674),new Point(-190.75,622.7201997807902)],[new Point(784,674),new Point(161,542)],[new Point(784,674),new Point(129.5,560.1865334794732)],[new Point(784,674),new Point(129.5,523.8134665205268)],[new Point(784,674),new Point(647,320)],[new Point(784,674),new Point(584,356.3730669589464)],[new Point(784,674),new Point(584,356.3730669589464),new Point(584,283.6269330410536)],[new Point(784,674),new Point(838.5,55)],[new Point(784,674),new Point(728.25,118.65286717815624)],[new Point(784,674),new Point(728.25,118.65286717815624),new Point(728.25,-8.652867178156207)],[new Point(784,674),new Point(260.59999999999997,90)],[new Point(784,674),new Point(-10.29999999999994,246.4041879234696)],[new Point(784,674),new Point(260.59999999999997,90),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(417,656),new Point(271,-479)],[new Point(417,656),new Point(360.0604335563131,-529.0018277777501)],[new Point(417,656),new Point(1055,664)],[new Point(417,656),new Point(784,674)],[new Point(417,656)],[new Point(417,656),new Point(203,759)],[new Point(417,656),new Point(56,674)],[new Point(417,656),new Point(56,674),new Point(-289.3991018391502,729.2006744090877)],[new Point(417,656),new Point(-190.75,677.2798002192098),new Point(-381.4843460976219,649.1432030269882)],[new Point(417,656),new Point(260.59999999999997,90),new Point(-89.03523617876226,-499.7368825942079)],[new Point(417,656),new Point(260.59999999999997,90),new Point(-200.96476382123774,-499.7368825942079),new Point(-200.96476382123774,-530.2631174057921)],[new Point(417,656),new Point(260.59999999999997,90),new Point(-200.96476382123774,-499.7368825942079)],[new Point(417,656),new Point(-89.03523617876226,-530.2631174057921)],[new Point(417,656),new Point(1004.696796342723,-29.047074219986737)],[new Point(417,656),new Point(1004.696796342723,-140.95292578001326),new Point(1040.303203657277,-140.95292578001326)],[new Point(417,656),new Point(1040.303203657277,-29.047074219986737)],[new Point(417,656),new Point(1004.696796342723,-140.95292578001326)],[new Point(417,656),new Point(1004.7206704591699,249.0398047033964)],[new Point(417,656),new Point(1037.27932954083,360.96019529660356)],[new Point(417,656),new Point(1004.7206704591699,360.96019529660356)],[new Point(417,656),new Point(1004.7206704591699,249.0398047033964),new Point(1037.27932954083,249.0398047033964)],[new Point(417,656),new Point(471.13992102513606,-235.48983908715294)],[new Point(417,656),new Point(471.13992102513606,-235.48983908715294),new Point(588.4106157414747,-343.91180848474517)],[new Point(417,656),new Point(519.5893842585253,-191.08819151525486)],[new Point(417,656),new Point(-223.05106963552825,212.0013049052253),new Point(-283.73502185420614,242.3219565841044)],[new Point(417,656),new Point(-153.26497814579386,362.6780434158956)],[new Point(417,656),new Point(129.5,523.8134665205268),new Point(-213.94893036447175,389.9986950947747)],[new Point(417,656),new Point(-223.05106963552825,212.0013049052253)],[new Point(417,656),new Point(260.59999999999997,90),new Point(-190.49613893835684,-350.86824314212447)],[new Point(417,656),new Point(-10.29999999999994,246.4041879234696),new Point(-107,-207)],[new Point(417,656),new Point(-296.99632055783536,-193.9142950057776)],[new Point(417,656),new Point(584,283.6269330410536),new Point(973,-420)],[new Point(417,656),new Point(721,-274.5077321642143)],[new Point(417,656),new Point(471.13992102513606,-235.48983908715294),new Point(721,-565.4922678357856)],[new Point(417,656),new Point(-143.5,650)],[new Point(417,656),new Point(-190.75,677.2798002192098)],[new Point(417,656),new Point(-190.75,622.7201997807902)],[new Point(417,656),new Point(161,542)],[new Point(417,656),new Point(129.5,560.1865334794732)],[new Point(417,656),new Point(129.5,523.8134665205268)],[new Point(417,656),new Point(647,320)],[new Point(417,656),new Point(584,356.3730669589464)],[new Point(417,656),new Point(584,283.6269330410536)],[new Point(417,656),new Point(838.5,55)],[new Point(417,656),new Point(647,320),new Point(728.25,118.65286717815624)],[new Point(417,656),new Point(728.25,-8.652867178156207)],[new Point(417,656),new Point(260.59999999999997,90)],[new Point(417,656),new Point(-10.29999999999994,246.4041879234696)],[new Point(417,656),new Point(260.59999999999997,90),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(203,759),new Point(271,-479)],[new Point(203,759),new Point(360.0604335563131,-529.0018277777501)],[new Point(203,759),new Point(417,656),new Point(1055,664)],[new Point(203,759),new Point(417,656),new Point(784,674)],[new Point(203,759),new Point(417,656)],[new Point(203,759)],[new Point(203,759),new Point(56,674)],[new Point(203,759),new Point(56,674),new Point(-289.3991018391502,729.2006744090877)],[new Point(203,759),new Point(56,674),new Point(-190.75,677.2798002192098),new Point(-381.4843460976219,649.1432030269882)],[new Point(203,759),new Point(-10.29999999999994,246.4041879234696),new Point(-89.03523617876226,-499.7368825942079)],[new Point(203,759),new Point(129.5,560.1865334794732),new Point(-107,-207),new Point(-200.96476382123774,-499.7368825942079),new Point(-200.96476382123774,-530.2631174057921)],[new Point(203,759),new Point(129.5,560.1865334794732),new Point(-107,-207),new Point(-200.96476382123774,-499.7368825942079)],[new Point(203,759),new Point(-10.29999999999994,246.4041879234696),new Point(-89.03523617876226,-530.2631174057921)],[new Point(203,759),new Point(1004.696796342723,-29.047074219986737)],[new Point(203,759),new Point(647,320),new Point(1004.696796342723,-140.95292578001326),new Point(1040.303203657277,-140.95292578001326)],[new Point(203,759),new Point(1040.303203657277,-29.047074219986737)],[new Point(203,759),new Point(647,320),new Point(1004.696796342723,-140.95292578001326)],[new Point(203,759),new Point(1004.7206704591699,249.0398047033964)],[new Point(203,759),new Point(1037.27932954083,360.96019529660356)],[new Point(203,759),new Point(1004.7206704591699,360.96019529660356)],[new Point(203,759),new Point(1004.7206704591699,249.0398047033964),new Point(1037.27932954083,249.0398047033964)],[new Point(203,759),new Point(471.13992102513606,-235.48983908715294)],[new Point(203,759),new Point(471.13992102513606,-235.48983908715294),new Point(588.4106157414747,-343.91180848474517)],[new Point(203,759),new Point(519.5893842585253,-191.08819151525486)],[new Point(203,759),new Point(-213.94893036447175,389.9986950947747),new Point(-283.73502185420614,242.3219565841044)],[new Point(203,759),new Point(-153.26497814579386,362.6780434158956)],[new Point(203,759),new Point(-213.94893036447175,389.9986950947747)],[new Point(203,759),new Point(-223.05106963552825,212.0013049052253)],[new Point(203,759),new Point(129.5,560.1865334794732),new Point(-107,-207),new Point(-190.49613893835684,-350.86824314212447)],[new Point(203,759),new Point(129.5,560.1865334794732),new Point(-107,-207)],[new Point(203,759),new Point(-296.99632055783536,-193.9142950057776)],[new Point(203,759),new Point(973,-420)],[new Point(203,759),new Point(721,-274.5077321642143)],[new Point(203,759),new Point(471.13992102513606,-235.48983908715294),new Point(721,-565.4922678357856)],[new Point(203,759),new Point(56,674),new Point(-143.5,650)],[new Point(203,759),new Point(56,674),new Point(-190.75,677.2798002192098)],[new Point(203,759),new Point(56,674),new Point(-190.75,622.7201997807902)],[new Point(203,759),new Point(161,542)],[new Point(203,759),new Point(129.5,560.1865334794732)],[new Point(203,759),new Point(129.5,560.1865334794732),new Point(129.5,523.8134665205268)],[new Point(203,759),new Point(647,320)],[new Point(203,759),new Point(584,356.3730669589464)],[new Point(203,759),new Point(584,283.6269330410536)],[new Point(203,759),new Point(584,283.6269330410536),new Point(838.5,55)],[new Point(203,759),new Point(728.25,118.65286717815624)],[new Point(203,759),new Point(728.25,-8.652867178156207)],[new Point(203,759),new Point(260.59999999999997,90)],[new Point(203,759),new Point(-10.29999999999994,246.4041879234696)],[new Point(203,759),new Point(-10.29999999999994,246.4041879234696),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(56,674),new Point(129.5,523.8134665205268),new Point(271,-479)],[new Point(56,674),new Point(360.0604335563131,-529.0018277777501)],[new Point(56,674),new Point(417,656),new Point(1055,664)],[new Point(56,674),new Point(417,656),new Point(784,674)],[new Point(56,674),new Point(417,656)],[new Point(56,674),new Point(203,759)],[new Point(56,674)],[new Point(56,674),new Point(-289.3991018391502,729.2006744090877)],[new Point(56,674),new Point(-190.75,677.2798002192098),new Point(-381.4843460976219,649.1432030269882)],[new Point(56,674),new Point(-89.03523617876226,-499.7368825942079)],[new Point(56,674),new Point(-107,-207),new Point(-200.96476382123774,-499.7368825942079),new Point(-200.96476382123774,-530.2631174057921)],[new Point(56,674),new Point(-107,-207),new Point(-200.96476382123774,-499.7368825942079)],[new Point(56,674),new Point(-89.03523617876226,-530.2631174057921)],[new Point(56,674),new Point(1004.696796342723,-29.047074219986737)],[new Point(56,674),new Point(838.5,55),new Point(1004.696796342723,-140.95292578001326),new Point(1040.303203657277,-140.95292578001326)],[new Point(56,674),new Point(1040.303203657277,-29.047074219986737)],[new Point(56,674),new Point(838.5,55),new Point(1004.696796342723,-140.95292578001326)],[new Point(56,674),new Point(1004.7206704591699,249.0398047033964)],[new Point(56,674),new Point(1037.27932954083,360.96019529660356)],[new Point(56,674),new Point(1004.7206704591699,360.96019529660356)],[new Point(56,674),new Point(1004.7206704591699,249.0398047033964),new Point(1037.27932954083,249.0398047033964)],[new Point(56,674),new Point(471.13992102513606,-235.48983908715294)],[new Point(56,674),new Point(471.13992102513606,-235.48983908715294),new Point(588.4106157414747,-343.91180848474517)],[new Point(56,674),new Point(519.5893842585253,-191.08819151525486)],[new Point(56,674),new Point(-213.94893036447175,389.9986950947747),new Point(-283.73502185420614,242.3219565841044)],[new Point(56,674),new Point(-153.26497814579386,362.6780434158956)],[new Point(56,674),new Point(-213.94893036447175,389.9986950947747)],[new Point(56,674),new Point(-223.05106963552825,212.0013049052253)],[new Point(56,674),new Point(-107,-207),new Point(-190.49613893835684,-350.86824314212447)],[new Point(56,674),new Point(-107,-207)],[new Point(56,674),new Point(-296.99632055783536,-193.9142950057776)],[new Point(56,674),new Point(973,-420)],[new Point(56,674),new Point(161,542),new Point(721,-274.5077321642143)],[new Point(56,674),new Point(471.13992102513606,-235.48983908715294),new Point(721,-565.4922678357856)],[new Point(56,674),new Point(-143.5,650)],[new Point(56,674),new Point(-190.75,677.2798002192098)],[new Point(56,674),new Point(-190.75,622.7201997807902)],[new Point(56,674),new Point(161,542)],[new Point(56,674),new Point(129.5,560.1865334794732)],[new Point(56,674),new Point(129.5,523.8134665205268)],[new Point(56,674),new Point(647,320)],[new Point(56,674),new Point(584,356.3730669589464)],[new Point(56,674),new Point(584,283.6269330410536)],[new Point(56,674),new Point(838.5,55)],[new Point(56,674),new Point(728.25,118.65286717815624)],[new Point(56,674),new Point(728.25,-8.652867178156207)],[new Point(56,674),new Point(260.59999999999997,90)],[new Point(56,674),new Point(-10.29999999999994,246.4041879234696)],[new Point(56,674),new Point(-10.29999999999994,246.4041879234696),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(-289.3991018391502,729.2006744090877),new Point(-153.26497814579386,362.6780434158956),new Point(-10.300000000000068,-66.40418792346955),new Point(271,-479)],[new Point(-289.3991018391502,729.2006744090877),new Point(-153.26497814579386,362.6780434158956),new Point(-10.300000000000068,-66.40418792346955),new Point(360.0604335563131,-529.0018277777501)],[new Point(-289.3991018391502,729.2006744090877),new Point(56,674),new Point(417,656),new Point(1055,664)],[new Point(-289.3991018391502,729.2006744090877),new Point(56,674),new Point(417,656),new Point(784,674)],[new Point(-289.3991018391502,729.2006744090877),new Point(56,674),new Point(417,656)],[new Point(-289.3991018391502,729.2006744090877),new Point(56,674),new Point(203,759)],[new Point(-289.3991018391502,729.2006744090877),new Point(56,674)],[new Point(-289.3991018391502,729.2006744090877)],[new Point(-289.3991018391502,729.2006744090877),new Point(-381.4843460976219,649.1432030269882)],[new Point(-289.3991018391502,729.2006744090877),new Point(-153.26497814579386,362.6780434158956),new Point(-107,-207),new Point(-89.03523617876226,-499.7368825942079)],[new Point(-289.3991018391502,729.2006744090877),new Point(-296.99632055783536,-193.9142950057776),new Point(-200.96476382123774,-530.2631174057921)],[new Point(-289.3991018391502,729.2006744090877),new Point(-296.99632055783536,-193.9142950057776),new Point(-200.96476382123774,-499.7368825942079)],[new Point(-289.3991018391502,729.2006744090877),new Point(-153.26497814579386,362.6780434158956),new Point(-107,-207),new Point(-89.03523617876226,-499.7368825942079),new Point(-89.03523617876226,-530.2631174057921)],[new Point(-289.3991018391502,729.2006744090877),new Point(-143.5,650),new Point(1004.696796342723,-29.047074219986737)],[new Point(-289.3991018391502,729.2006744090877),new Point(-190.75,622.7201997807902),new Point(1004.696796342723,-140.95292578001326),new Point(1040.303203657277,-140.95292578001326)],[new Point(-289.3991018391502,729.2006744090877),new Point(-143.5,650),new Point(1040.303203657277,-29.047074219986737)],[new Point(-289.3991018391502,729.2006744090877),new Point(-190.75,622.7201997807902),new Point(1004.696796342723,-140.95292578001326)],[new Point(-289.3991018391502,729.2006744090877),new Point(1004.7206704591699,249.0398047033964)],[new Point(-289.3991018391502,729.2006744090877),new Point(1037.27932954083,360.96019529660356)],[new Point(-289.3991018391502,729.2006744090877),new Point(1004.7206704591699,360.96019529660356)],[new Point(-289.3991018391502,729.2006744090877),new Point(1004.7206704591699,249.0398047033964),new Point(1037.27932954083,249.0398047033964)],[new Point(-289.3991018391502,729.2006744090877),new Point(471.13992102513606,-235.48983908715294)],[new Point(-289.3991018391502,729.2006744090877),new Point(471.13992102513606,-235.48983908715294),new Point(588.4106157414747,-343.91180848474517)],[new Point(-289.3991018391502,729.2006744090877),new Point(519.5893842585253,-191.08819151525486)],[new Point(-289.3991018391502,729.2006744090877),new Point(-283.73502185420614,242.3219565841044)],[new Point(-289.3991018391502,729.2006744090877),new Point(-153.26497814579386,362.6780434158956)],[new Point(-289.3991018391502,729.2006744090877),new Point(-213.94893036447175,389.9986950947747)],[new Point(-289.3991018391502,729.2006744090877),new Point(-283.73502185420614,242.3219565841044),new Point(-223.05106963552825,212.0013049052253)],[new Point(-289.3991018391502,729.2006744090877),new Point(-296.99632055783536,-193.9142950057776),new Point(-190.49613893835684,-350.86824314212447)],[new Point(-289.3991018391502,729.2006744090877),new Point(-153.26497814579386,362.6780434158956),new Point(-107,-207)],[new Point(-289.3991018391502,729.2006744090877),new Point(-296.99632055783536,-193.9142950057776)],[new Point(-289.3991018391502,729.2006744090877),new Point(973,-420)],[new Point(-289.3991018391502,729.2006744090877),new Point(721,-274.5077321642143)],[new Point(-289.3991018391502,729.2006744090877),new Point(721,-565.4922678357856)],[new Point(-289.3991018391502,729.2006744090877),new Point(-143.5,650)],[new Point(-289.3991018391502,729.2006744090877),new Point(-190.75,677.2798002192098)],[new Point(-289.3991018391502,729.2006744090877),new Point(-190.75,622.7201997807902)],[new Point(-289.3991018391502,729.2006744090877),new Point(129.5,560.1865334794732),new Point(161,542)],[new Point(-289.3991018391502,729.2006744090877),new Point(129.5,560.1865334794732)],[new Point(-289.3991018391502,729.2006744090877),new Point(129.5,523.8134665205268)],[new Point(-289.3991018391502,729.2006744090877),new Point(129.5,560.1865334794732),new Point(584,356.3730669589464),new Point(647,320)],[new Point(-289.3991018391502,729.2006744090877),new Point(129.5,560.1865334794732),new Point(584,356.3730669589464)],[new Point(-289.3991018391502,729.2006744090877),new Point(584,283.6269330410536)],[new Point(-289.3991018391502,729.2006744090877),new Point(-143.5,650),new Point(838.5,55)],[new Point(-289.3991018391502,729.2006744090877),new Point(-143.5,650),new Point(728.25,118.65286717815624)],[new Point(-289.3991018391502,729.2006744090877),new Point(-143.5,650),new Point(728.25,-8.652867178156207)],[new Point(-289.3991018391502,729.2006744090877),new Point(260.59999999999997,90)],[new Point(-289.3991018391502,729.2006744090877),new Point(-10.29999999999994,246.4041879234696)],[new Point(-289.3991018391502,729.2006744090877),new Point(-153.26497814579386,362.6780434158956),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(-381.4843460976219,649.1432030269882),new Point(-153.26497814579386,362.6780434158956),new Point(-10.300000000000068,-66.40418792346955),new Point(271,-479)],[new Point(-381.4843460976219,649.1432030269882),new Point(-153.26497814579386,362.6780434158956),new Point(-10.300000000000068,-66.40418792346955),new Point(360.0604335563131,-529.0018277777501)],[new Point(-381.4843460976219,649.1432030269882),new Point(-190.75,677.2798002192098),new Point(417,656),new Point(1055,664)],[new Point(-381.4843460976219,649.1432030269882),new Point(-190.75,677.2798002192098),new Point(417,656),new Point(784,674)],[new Point(-381.4843460976219,649.1432030269882),new Point(-190.75,677.2798002192098),new Point(417,656)],[new Point(-381.4843460976219,649.1432030269882),new Point(-190.75,677.2798002192098),new Point(56,674),new Point(203,759)],[new Point(-381.4843460976219,649.1432030269882),new Point(-190.75,677.2798002192098),new Point(56,674)],[new Point(-381.4843460976219,649.1432030269882),new Point(-289.3991018391502,729.2006744090877)],[new Point(-381.4843460976219,649.1432030269882)],[new Point(-381.4843460976219,649.1432030269882),new Point(-283.73502185420614,242.3219565841044),new Point(-107,-207),new Point(-89.03523617876226,-499.7368825942079)],[new Point(-381.4843460976219,649.1432030269882),new Point(-296.99632055783536,-193.9142950057776),new Point(-200.96476382123774,-530.2631174057921)],[new Point(-381.4843460976219,649.1432030269882),new Point(-296.99632055783536,-193.9142950057776),new Point(-200.96476382123774,-499.7368825942079)],[new Point(-381.4843460976219,649.1432030269882),new Point(-283.73502185420614,242.3219565841044),new Point(-107,-207),new Point(-89.03523617876226,-499.7368825942079),new Point(-89.03523617876226,-530.2631174057921)],[new Point(-381.4843460976219,649.1432030269882),new Point(728.25,118.65286717815624),new Point(1004.696796342723,-29.047074219986737)],[new Point(-381.4843460976219,649.1432030269882),new Point(1004.696796342723,-140.95292578001326),new Point(1040.303203657277,-140.95292578001326)],[new Point(-381.4843460976219,649.1432030269882),new Point(1040.303203657277,-29.047074219986737)],[new Point(-381.4843460976219,649.1432030269882),new Point(1004.696796342723,-140.95292578001326)],[new Point(-381.4843460976219,649.1432030269882),new Point(1004.7206704591699,249.0398047033964)],[new Point(-381.4843460976219,649.1432030269882),new Point(129.5,560.1865334794732),new Point(1037.27932954083,360.96019529660356)],[new Point(-381.4843460976219,649.1432030269882),new Point(129.5,560.1865334794732),new Point(1004.7206704591699,360.96019529660356)],[new Point(-381.4843460976219,649.1432030269882),new Point(1004.7206704591699,249.0398047033964),new Point(1037.27932954083,249.0398047033964)],[new Point(-381.4843460976219,649.1432030269882),new Point(260.59999999999997,90),new Point(471.13992102513606,-235.48983908715294)],[new Point(-381.4843460976219,649.1432030269882),new Point(260.59999999999997,90),new Point(471.13992102513606,-235.48983908715294),new Point(588.4106157414747,-343.91180848474517)],[new Point(-381.4843460976219,649.1432030269882),new Point(519.5893842585253,-191.08819151525486)],[new Point(-381.4843460976219,649.1432030269882),new Point(-283.73502185420614,242.3219565841044)],[new Point(-381.4843460976219,649.1432030269882),new Point(-153.26497814579386,362.6780434158956)],[new Point(-381.4843460976219,649.1432030269882),new Point(-213.94893036447175,389.9986950947747)],[new Point(-381.4843460976219,649.1432030269882),new Point(-283.73502185420614,242.3219565841044),new Point(-223.05106963552825,212.0013049052253)],[new Point(-381.4843460976219,649.1432030269882),new Point(-296.99632055783536,-193.9142950057776),new Point(-190.49613893835684,-350.86824314212447)],[new Point(-381.4843460976219,649.1432030269882),new Point(-283.73502185420614,242.3219565841044),new Point(-107,-207)],[new Point(-381.4843460976219,649.1432030269882),new Point(-296.99632055783536,-193.9142950057776)],[new Point(-381.4843460976219,649.1432030269882),new Point(973,-420)],[new Point(-381.4843460976219,649.1432030269882),new Point(721,-274.5077321642143)],[new Point(-381.4843460976219,649.1432030269882),new Point(260.59999999999997,90),new Point(471.13992102513606,-235.48983908715294),new Point(721,-565.4922678357856)],[new Point(-381.4843460976219,649.1432030269882),new Point(-190.75,622.7201997807902),new Point(-143.5,650)],[new Point(-381.4843460976219,649.1432030269882),new Point(-190.75,677.2798002192098)],[new Point(-381.4843460976219,649.1432030269882),new Point(-190.75,622.7201997807902)],[new Point(-381.4843460976219,649.1432030269882),new Point(129.5,560.1865334794732),new Point(161,542)],[new Point(-381.4843460976219,649.1432030269882),new Point(129.5,560.1865334794732)],[new Point(-381.4843460976219,649.1432030269882),new Point(129.5,523.8134665205268)],[new Point(-381.4843460976219,649.1432030269882),new Point(584,356.3730669589464),new Point(647,320)],[new Point(-381.4843460976219,649.1432030269882),new Point(584,356.3730669589464)],[new Point(-381.4843460976219,649.1432030269882),new Point(584,283.6269330410536)],[new Point(-381.4843460976219,649.1432030269882),new Point(728.25,118.65286717815624),new Point(838.5,55)],[new Point(-381.4843460976219,649.1432030269882),new Point(728.25,118.65286717815624)],[new Point(-381.4843460976219,649.1432030269882),new Point(728.25,-8.652867178156207)],[new Point(-381.4843460976219,649.1432030269882),new Point(260.59999999999997,90)],[new Point(-381.4843460976219,649.1432030269882),new Point(-10.29999999999994,246.4041879234696)],[new Point(-381.4843460976219,649.1432030269882),new Point(-153.26497814579386,362.6780434158956),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(-89.03523617876226,-499.7368825942079),new Point(271,-479)],[new Point(-89.03523617876226,-499.7368825942079),new Point(-107,-207),new Point(360.0604335563131,-529.0018277777501)],[new Point(-89.03523617876226,-499.7368825942079),new Point(1055,664)],[new Point(-89.03523617876226,-499.7368825942079),new Point(784,674)],[new Point(-89.03523617876226,-499.7368825942079),new Point(260.59999999999997,90),new Point(417,656)],[new Point(-89.03523617876226,-499.7368825942079),new Point(-10.29999999999994,246.4041879234696),new Point(203,759)],[new Point(-89.03523617876226,-499.7368825942079),new Point(56,674)],[new Point(-89.03523617876226,-499.7368825942079),new Point(-107,-207),new Point(-153.26497814579386,362.6780434158956),new Point(-289.3991018391502,729.2006744090877)],[new Point(-89.03523617876226,-499.7368825942079),new Point(-107,-207),new Point(-283.73502185420614,242.3219565841044),new Point(-381.4843460976219,649.1432030269882)],[new Point(-89.03523617876226,-499.7368825942079)],[new Point(-89.03523617876226,-499.7368825942079),new Point(-89.03523617876226,-530.2631174057921),new Point(-200.96476382123774,-530.2631174057921)],[new Point(-89.03523617876226,-499.7368825942079),new Point(-200.96476382123774,-499.7368825942079)],[new Point(-89.03523617876226,-499.7368825942079),new Point(-89.03523617876226,-530.2631174057921)],[new Point(-89.03523617876226,-499.7368825942079),new Point(519.5893842585253,-191.08819151525486),new Point(1004.696796342723,-29.047074219986737)],[new Point(-89.03523617876226,-499.7368825942079),new Point(519.5893842585253,-191.08819151525486),new Point(1040.303203657277,-140.95292578001326)],[new Point(-89.03523617876226,-499.7368825942079),new Point(519.5893842585253,-191.08819151525486),new Point(1004.696796342723,-29.047074219986737),new Point(1040.303203657277,-29.047074219986737)],[new Point(-89.03523617876226,-499.7368825942079),new Point(519.5893842585253,-191.08819151525486),new Point(1004.696796342723,-140.95292578001326)],[new Point(-89.03523617876226,-499.7368825942079),new Point(728.25,118.65286717815624),new Point(1004.7206704591699,249.0398047033964)],[new Point(-89.03523617876226,-499.7368825942079),new Point(1004.7206704591699,360.96019529660356),new Point(1037.27932954083,360.96019529660356)],[new Point(-89.03523617876226,-499.7368825942079),new Point(1004.7206704591699,360.96019529660356)],[new Point(-89.03523617876226,-499.7368825942079),new Point(838.5,55),new Point(1037.27932954083,249.0398047033964)],[new Point(-89.03523617876226,-499.7368825942079),new Point(471.13992102513606,-235.48983908715294)],[new Point(-89.03523617876226,-499.7368825942079),new Point(588.4106157414747,-343.91180848474517)],[new Point(-89.03523617876226,-499.7368825942079),new Point(519.5893842585253,-191.08819151525486)],[new Point(-89.03523617876226,-499.7368825942079),new Point(-107,-207),new Point(-283.73502185420614,242.3219565841044)],[new Point(-89.03523617876226,-499.7368825942079),new Point(-107,-207),new Point(-153.26497814579386,362.6780434158956)],[new Point(-89.03523617876226,-499.7368825942079),new Point(-107,-207),new Point(-153.26497814579386,362.6780434158956),new Point(-213.94893036447175,389.9986950947747)],[new Point(-89.03523617876226,-499.7368825942079),new Point(-107,-207),new Point(-223.05106963552825,212.0013049052253)],[new Point(-89.03523617876226,-499.7368825942079),new Point(-190.49613893835684,-350.86824314212447)],[new Point(-89.03523617876226,-499.7368825942079),new Point(-107,-207)],[new Point(-89.03523617876226,-499.7368825942079),new Point(-296.99632055783536,-193.9142950057776)],[new Point(-89.03523617876226,-499.7368825942079),new Point(519.5893842585253,-191.08819151525486),new Point(721,-274.5077321642143),new Point(973,-420)],[new Point(-89.03523617876226,-499.7368825942079),new Point(519.5893842585253,-191.08819151525486),new Point(721,-274.5077321642143)],[new Point(-89.03523617876226,-499.7368825942079),new Point(588.4106157414747,-343.91180848474517),new Point(721,-565.4922678357856)],[new Point(-89.03523617876226,-499.7368825942079),new Point(-143.5,650)],[new Point(-89.03523617876226,-499.7368825942079),new Point(-107,-207),new Point(-153.26497814579386,362.6780434158956),new Point(-190.75,622.7201997807902),new Point(-190.75,677.2798002192098)],[new Point(-89.03523617876226,-499.7368825942079),new Point(-107,-207),new Point(-153.26497814579386,362.6780434158956),new Point(-190.75,622.7201997807902)],[new Point(-89.03523617876226,-499.7368825942079),new Point(-10.29999999999994,246.4041879234696),new Point(161,542)],[new Point(-89.03523617876226,-499.7368825942079),new Point(-10.29999999999994,246.4041879234696),new Point(129.5,560.1865334794732)],[new Point(-89.03523617876226,-499.7368825942079),new Point(-10.29999999999994,246.4041879234696),new Point(129.5,523.8134665205268)],[new Point(-89.03523617876226,-499.7368825942079),new Point(647,320)],[new Point(-89.03523617876226,-499.7368825942079),new Point(584,356.3730669589464)],[new Point(-89.03523617876226,-499.7368825942079),new Point(584,283.6269330410536)],[new Point(-89.03523617876226,-499.7368825942079),new Point(838.5,55)],[new Point(-89.03523617876226,-499.7368825942079),new Point(728.25,118.65286717815624)],[new Point(-89.03523617876226,-499.7368825942079),new Point(728.25,-8.652867178156207)],[new Point(-89.03523617876226,-499.7368825942079),new Point(260.59999999999997,90)],[new Point(-89.03523617876226,-499.7368825942079),new Point(-10.29999999999994,246.4041879234696)],[new Point(-89.03523617876226,-499.7368825942079),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(-200.96476382123774,-530.2631174057921),new Point(-89.03523617876226,-530.2631174057921),new Point(271,-479)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-200.96476382123774,-499.7368825942079),new Point(-107,-207),new Point(360.0604335563131,-529.0018277777501)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-200.96476382123774,-499.7368825942079),new Point(1055,664)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-200.96476382123774,-499.7368825942079),new Point(784,674)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-200.96476382123774,-499.7368825942079),new Point(260.59999999999997,90),new Point(417,656)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-200.96476382123774,-499.7368825942079),new Point(-107,-207),new Point(129.5,560.1865334794732),new Point(203,759)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-200.96476382123774,-499.7368825942079),new Point(-107,-207),new Point(56,674)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-296.99632055783536,-193.9142950057776),new Point(-289.3991018391502,729.2006744090877)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-296.99632055783536,-193.9142950057776),new Point(-381.4843460976219,649.1432030269882)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-89.03523617876226,-530.2631174057921),new Point(-89.03523617876226,-499.7368825942079)],[new Point(-200.96476382123774,-530.2631174057921)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-200.96476382123774,-499.7368825942079)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-89.03523617876226,-530.2631174057921)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-89.03523617876226,-530.2631174057921),new Point(519.5893842585253,-191.08819151525486),new Point(1004.696796342723,-29.047074219986737)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-89.03523617876226,-530.2631174057921),new Point(519.5893842585253,-191.08819151525486),new Point(1040.303203657277,-140.95292578001326)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-89.03523617876226,-530.2631174057921),new Point(519.5893842585253,-191.08819151525486),new Point(1004.696796342723,-29.047074219986737),new Point(1040.303203657277,-29.047074219986737)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-89.03523617876226,-530.2631174057921),new Point(519.5893842585253,-191.08819151525486),new Point(1004.696796342723,-140.95292578001326)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-200.96476382123774,-499.7368825942079),new Point(1004.7206704591699,249.0398047033964)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-200.96476382123774,-499.7368825942079),new Point(1004.7206704591699,360.96019529660356),new Point(1037.27932954083,360.96019529660356)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-200.96476382123774,-499.7368825942079),new Point(1004.7206704591699,360.96019529660356)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-200.96476382123774,-499.7368825942079),new Point(728.25,118.65286717815624),new Point(1037.27932954083,249.0398047033964)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-89.03523617876226,-530.2631174057921),new Point(471.13992102513606,-235.48983908715294)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-89.03523617876226,-530.2631174057921),new Point(588.4106157414747,-343.91180848474517)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-89.03523617876226,-530.2631174057921),new Point(519.5893842585253,-191.08819151525486)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-296.99632055783536,-193.9142950057776),new Point(-283.73502185420614,242.3219565841044)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-200.96476382123774,-499.7368825942079),new Point(-107,-207),new Point(-153.26497814579386,362.6780434158956)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-296.99632055783536,-193.9142950057776),new Point(-283.73502185420614,242.3219565841044),new Point(-213.94893036447175,389.9986950947747)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-296.99632055783536,-193.9142950057776),new Point(-223.05106963552825,212.0013049052253)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-200.96476382123774,-499.7368825942079),new Point(-190.49613893835684,-350.86824314212447)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-200.96476382123774,-499.7368825942079),new Point(-107,-207)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-296.99632055783536,-193.9142950057776)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-89.03523617876226,-530.2631174057921),new Point(519.5893842585253,-191.08819151525486),new Point(721,-274.5077321642143),new Point(973,-420)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-89.03523617876226,-530.2631174057921),new Point(519.5893842585253,-191.08819151525486),new Point(721,-274.5077321642143)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-89.03523617876226,-530.2631174057921),new Point(588.4106157414747,-343.91180848474517),new Point(721,-565.4922678357856)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-200.96476382123774,-499.7368825942079),new Point(-107,-207),new Point(-143.5,650)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-200.96476382123774,-499.7368825942079),new Point(-107,-207),new Point(-153.26497814579386,362.6780434158956),new Point(-190.75,622.7201997807902),new Point(-190.75,677.2798002192098)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-200.96476382123774,-499.7368825942079),new Point(-107,-207),new Point(-153.26497814579386,362.6780434158956),new Point(-190.75,622.7201997807902)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-200.96476382123774,-499.7368825942079),new Point(129.5,523.8134665205268),new Point(161,542)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-200.96476382123774,-499.7368825942079),new Point(-107,-207),new Point(129.5,560.1865334794732)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-200.96476382123774,-499.7368825942079),new Point(129.5,523.8134665205268)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-200.96476382123774,-499.7368825942079),new Point(647,320)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-200.96476382123774,-499.7368825942079),new Point(584,356.3730669589464)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-200.96476382123774,-499.7368825942079),new Point(584,283.6269330410536)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-89.03523617876226,-530.2631174057921),new Point(838.5,55)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-200.96476382123774,-499.7368825942079),new Point(728.25,118.65286717815624)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-89.03523617876226,-530.2631174057921),new Point(728.25,-8.652867178156207)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-200.96476382123774,-499.7368825942079),new Point(260.59999999999997,90)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-200.96476382123774,-499.7368825942079),new Point(-107,-207),new Point(-10.29999999999994,246.4041879234696)],[new Point(-200.96476382123774,-530.2631174057921),new Point(-200.96476382123774,-499.7368825942079),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(-200.96476382123774,-499.7368825942079),new Point(271,-479)],[new Point(-200.96476382123774,-499.7368825942079),new Point(-107,-207),new Point(360.0604335563131,-529.0018277777501)],[new Point(-200.96476382123774,-499.7368825942079),new Point(1055,664)],[new Point(-200.96476382123774,-499.7368825942079),new Point(784,674)],[new Point(-200.96476382123774,-499.7368825942079),new Point(260.59999999999997,90),new Point(417,656)],[new Point(-200.96476382123774,-499.7368825942079),new Point(-107,-207),new Point(129.5,560.1865334794732),new Point(203,759)],[new Point(-200.96476382123774,-499.7368825942079),new Point(-107,-207),new Point(56,674)],[new Point(-200.96476382123774,-499.7368825942079),new Point(-296.99632055783536,-193.9142950057776),new Point(-289.3991018391502,729.2006744090877)],[new Point(-200.96476382123774,-499.7368825942079),new Point(-296.99632055783536,-193.9142950057776),new Point(-381.4843460976219,649.1432030269882)],[new Point(-200.96476382123774,-499.7368825942079),new Point(-89.03523617876226,-499.7368825942079)],[new Point(-200.96476382123774,-499.7368825942079),new Point(-200.96476382123774,-530.2631174057921)],[new Point(-200.96476382123774,-499.7368825942079)],[new Point(-200.96476382123774,-499.7368825942079),new Point(-10.300000000000068,-66.40418792346955),new Point(-89.03523617876226,-530.2631174057921)],[new Point(-200.96476382123774,-499.7368825942079),new Point(519.5893842585253,-191.08819151525486),new Point(1004.696796342723,-29.047074219986737)],[new Point(-200.96476382123774,-499.7368825942079),new Point(519.5893842585253,-191.08819151525486),new Point(1040.303203657277,-140.95292578001326)],[new Point(-200.96476382123774,-499.7368825942079),new Point(519.5893842585253,-191.08819151525486),new Point(1004.696796342723,-29.047074219986737),new Point(1040.303203657277,-29.047074219986737)],[new Point(-200.96476382123774,-499.7368825942079),new Point(519.5893842585253,-191.08819151525486),new Point(1004.696796342723,-140.95292578001326)],[new Point(-200.96476382123774,-499.7368825942079),new Point(1004.7206704591699,249.0398047033964)],[new Point(-200.96476382123774,-499.7368825942079),new Point(1004.7206704591699,360.96019529660356),new Point(1037.27932954083,360.96019529660356)],[new Point(-200.96476382123774,-499.7368825942079),new Point(1004.7206704591699,360.96019529660356)],[new Point(-200.96476382123774,-499.7368825942079),new Point(728.25,118.65286717815624),new Point(1037.27932954083,249.0398047033964)],[new Point(-200.96476382123774,-499.7368825942079),new Point(471.13992102513606,-235.48983908715294)],[new Point(-200.96476382123774,-499.7368825942079),new Point(588.4106157414747,-343.91180848474517)],[new Point(-200.96476382123774,-499.7368825942079),new Point(519.5893842585253,-191.08819151525486)],[new Point(-200.96476382123774,-499.7368825942079),new Point(-296.99632055783536,-193.9142950057776),new Point(-283.73502185420614,242.3219565841044)],[new Point(-200.96476382123774,-499.7368825942079),new Point(-107,-207),new Point(-153.26497814579386,362.6780434158956)],[new Point(-200.96476382123774,-499.7368825942079),new Point(-296.99632055783536,-193.9142950057776),new Point(-283.73502185420614,242.3219565841044),new Point(-213.94893036447175,389.9986950947747)],[new Point(-200.96476382123774,-499.7368825942079),new Point(-296.99632055783536,-193.9142950057776),new Point(-223.05106963552825,212.0013049052253)],[new Point(-200.96476382123774,-499.7368825942079),new Point(-190.49613893835684,-350.86824314212447)],[new Point(-200.96476382123774,-499.7368825942079),new Point(-107,-207)],[new Point(-200.96476382123774,-499.7368825942079),new Point(-296.99632055783536,-193.9142950057776)],[new Point(-200.96476382123774,-499.7368825942079),new Point(519.5893842585253,-191.08819151525486),new Point(721,-274.5077321642143),new Point(973,-420)],[new Point(-200.96476382123774,-499.7368825942079),new Point(519.5893842585253,-191.08819151525486),new Point(721,-274.5077321642143)],[new Point(-200.96476382123774,-499.7368825942079),new Point(588.4106157414747,-343.91180848474517),new Point(721,-565.4922678357856)],[new Point(-200.96476382123774,-499.7368825942079),new Point(-107,-207),new Point(-143.5,650)],[new Point(-200.96476382123774,-499.7368825942079),new Point(-107,-207),new Point(-153.26497814579386,362.6780434158956),new Point(-190.75,622.7201997807902),new Point(-190.75,677.2798002192098)],[new Point(-200.96476382123774,-499.7368825942079),new Point(-107,-207),new Point(-153.26497814579386,362.6780434158956),new Point(-190.75,622.7201997807902)],[new Point(-200.96476382123774,-499.7368825942079),new Point(129.5,523.8134665205268),new Point(161,542)],[new Point(-200.96476382123774,-499.7368825942079),new Point(-107,-207),new Point(129.5,560.1865334794732)],[new Point(-200.96476382123774,-499.7368825942079),new Point(129.5,523.8134665205268)],[new Point(-200.96476382123774,-499.7368825942079),new Point(647,320)],[new Point(-200.96476382123774,-499.7368825942079),new Point(584,356.3730669589464)],[new Point(-200.96476382123774,-499.7368825942079),new Point(584,283.6269330410536)],[new Point(-200.96476382123774,-499.7368825942079),new Point(728.25,-8.652867178156207),new Point(838.5,55)],[new Point(-200.96476382123774,-499.7368825942079),new Point(728.25,118.65286717815624)],[new Point(-200.96476382123774,-499.7368825942079),new Point(728.25,-8.652867178156207)],[new Point(-200.96476382123774,-499.7368825942079),new Point(260.59999999999997,90)],[new Point(-200.96476382123774,-499.7368825942079),new Point(-107,-207),new Point(-10.29999999999994,246.4041879234696)],[new Point(-200.96476382123774,-499.7368825942079),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(-89.03523617876226,-530.2631174057921),new Point(271,-479)],[new Point(-89.03523617876226,-530.2631174057921),new Point(-89.03523617876226,-499.7368825942079),new Point(-107,-207),new Point(360.0604335563131,-529.0018277777501)],[new Point(-89.03523617876226,-530.2631174057921),new Point(1055,664)],[new Point(-89.03523617876226,-530.2631174057921),new Point(784,674)],[new Point(-89.03523617876226,-530.2631174057921),new Point(417,656)],[new Point(-89.03523617876226,-530.2631174057921),new Point(-10.29999999999994,246.4041879234696),new Point(203,759)],[new Point(-89.03523617876226,-530.2631174057921),new Point(56,674)],[new Point(-89.03523617876226,-530.2631174057921),new Point(-89.03523617876226,-499.7368825942079),new Point(-107,-207),new Point(-153.26497814579386,362.6780434158956),new Point(-289.3991018391502,729.2006744090877)],[new Point(-89.03523617876226,-530.2631174057921),new Point(-89.03523617876226,-499.7368825942079),new Point(-107,-207),new Point(-283.73502185420614,242.3219565841044),new Point(-381.4843460976219,649.1432030269882)],[new Point(-89.03523617876226,-530.2631174057921),new Point(-89.03523617876226,-499.7368825942079)],[new Point(-89.03523617876226,-530.2631174057921),new Point(-200.96476382123774,-530.2631174057921)],[new Point(-89.03523617876226,-530.2631174057921),new Point(-10.300000000000068,-66.40418792346955),new Point(-200.96476382123774,-499.7368825942079)],[new Point(-89.03523617876226,-530.2631174057921)],[new Point(-89.03523617876226,-530.2631174057921),new Point(519.5893842585253,-191.08819151525486),new Point(1004.696796342723,-29.047074219986737)],[new Point(-89.03523617876226,-530.2631174057921),new Point(519.5893842585253,-191.08819151525486),new Point(1040.303203657277,-140.95292578001326)],[new Point(-89.03523617876226,-530.2631174057921),new Point(519.5893842585253,-191.08819151525486),new Point(1004.696796342723,-29.047074219986737),new Point(1040.303203657277,-29.047074219986737)],[new Point(-89.03523617876226,-530.2631174057921),new Point(519.5893842585253,-191.08819151525486),new Point(1004.696796342723,-140.95292578001326)],[new Point(-89.03523617876226,-530.2631174057921),new Point(728.25,118.65286717815624),new Point(1004.7206704591699,249.0398047033964)],[new Point(-89.03523617876226,-530.2631174057921),new Point(1004.7206704591699,360.96019529660356),new Point(1037.27932954083,360.96019529660356)],[new Point(-89.03523617876226,-530.2631174057921),new Point(1004.7206704591699,360.96019529660356)],[new Point(-89.03523617876226,-530.2631174057921),new Point(838.5,55),new Point(1037.27932954083,249.0398047033964)],[new Point(-89.03523617876226,-530.2631174057921),new Point(471.13992102513606,-235.48983908715294)],[new Point(-89.03523617876226,-530.2631174057921),new Point(588.4106157414747,-343.91180848474517)],[new Point(-89.03523617876226,-530.2631174057921),new Point(519.5893842585253,-191.08819151525486)],[new Point(-89.03523617876226,-530.2631174057921),new Point(-10.300000000000068,-66.40418792346955),new Point(-283.73502185420614,242.3219565841044)],[new Point(-89.03523617876226,-530.2631174057921),new Point(-10.300000000000068,-66.40418792346955),new Point(-153.26497814579386,362.6780434158956)],[new Point(-89.03523617876226,-530.2631174057921),new Point(-10.300000000000068,-66.40418792346955),new Point(-153.26497814579386,362.6780434158956),new Point(-213.94893036447175,389.9986950947747)],[new Point(-89.03523617876226,-530.2631174057921),new Point(-10.300000000000068,-66.40418792346955),new Point(-223.05106963552825,212.0013049052253)],[new Point(-89.03523617876226,-530.2631174057921),new Point(-10.300000000000068,-66.40418792346955),new Point(-190.49613893835684,-350.86824314212447)],[new Point(-89.03523617876226,-530.2631174057921),new Point(-10.300000000000068,-66.40418792346955),new Point(-107,-207)],[new Point(-89.03523617876226,-530.2631174057921),new Point(-10.300000000000068,-66.40418792346955),new Point(-296.99632055783536,-193.9142950057776)],[new Point(-89.03523617876226,-530.2631174057921),new Point(519.5893842585253,-191.08819151525486),new Point(721,-274.5077321642143),new Point(973,-420)],[new Point(-89.03523617876226,-530.2631174057921),new Point(519.5893842585253,-191.08819151525486),new Point(721,-274.5077321642143)],[new Point(-89.03523617876226,-530.2631174057921),new Point(588.4106157414747,-343.91180848474517),new Point(721,-565.4922678357856)],[new Point(-89.03523617876226,-530.2631174057921),new Point(-10.300000000000068,-66.40418792346955),new Point(-143.5,650)],[new Point(-89.03523617876226,-530.2631174057921),new Point(-10.300000000000068,-66.40418792346955),new Point(-190.75,622.7201997807902),new Point(-190.75,677.2798002192098)],[new Point(-89.03523617876226,-530.2631174057921),new Point(-10.300000000000068,-66.40418792346955),new Point(-190.75,622.7201997807902)],[new Point(-89.03523617876226,-530.2631174057921),new Point(-10.29999999999994,246.4041879234696),new Point(161,542)],[new Point(-89.03523617876226,-530.2631174057921),new Point(-10.29999999999994,246.4041879234696),new Point(129.5,560.1865334794732)],[new Point(-89.03523617876226,-530.2631174057921),new Point(-10.29999999999994,246.4041879234696),new Point(129.5,523.8134665205268)],[new Point(-89.03523617876226,-530.2631174057921),new Point(647,320)],[new Point(-89.03523617876226,-530.2631174057921),new Point(584,356.3730669589464)],[new Point(-89.03523617876226,-530.2631174057921),new Point(584,283.6269330410536)],[new Point(-89.03523617876226,-530.2631174057921),new Point(838.5,55)],[new Point(-89.03523617876226,-530.2631174057921),new Point(728.25,118.65286717815624)],[new Point(-89.03523617876226,-530.2631174057921),new Point(728.25,-8.652867178156207)],[new Point(-89.03523617876226,-530.2631174057921),new Point(260.59999999999997,90)],[new Point(-89.03523617876226,-530.2631174057921),new Point(-10.29999999999994,246.4041879234696)],[new Point(-89.03523617876226,-530.2631174057921),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(1004.696796342723,-29.047074219986737),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294),new Point(271,-479)],[new Point(1004.696796342723,-29.047074219986737),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294),new Point(360.0604335563131,-529.0018277777501)],[new Point(1004.696796342723,-29.047074219986737),new Point(1037.27932954083,249.0398047033964),new Point(1055,664)],[new Point(1004.696796342723,-29.047074219986737),new Point(784,674)],[new Point(1004.696796342723,-29.047074219986737),new Point(417,656)],[new Point(1004.696796342723,-29.047074219986737),new Point(203,759)],[new Point(1004.696796342723,-29.047074219986737),new Point(56,674)],[new Point(1004.696796342723,-29.047074219986737),new Point(-143.5,650),new Point(-289.3991018391502,729.2006744090877)],[new Point(1004.696796342723,-29.047074219986737),new Point(728.25,118.65286717815624),new Point(-381.4843460976219,649.1432030269882)],[new Point(1004.696796342723,-29.047074219986737),new Point(519.5893842585253,-191.08819151525486),new Point(-89.03523617876226,-499.7368825942079)],[new Point(1004.696796342723,-29.047074219986737),new Point(519.5893842585253,-191.08819151525486),new Point(-89.03523617876226,-530.2631174057921),new Point(-200.96476382123774,-530.2631174057921)],[new Point(1004.696796342723,-29.047074219986737),new Point(519.5893842585253,-191.08819151525486),new Point(-200.96476382123774,-499.7368825942079)],[new Point(1004.696796342723,-29.047074219986737),new Point(519.5893842585253,-191.08819151525486),new Point(-89.03523617876226,-530.2631174057921)],[new Point(1004.696796342723,-29.047074219986737)],[new Point(1004.696796342723,-29.047074219986737),new Point(1040.303203657277,-29.047074219986737),new Point(1040.303203657277,-140.95292578001326)],[new Point(1004.696796342723,-29.047074219986737),new Point(1040.303203657277,-29.047074219986737)],[new Point(1004.696796342723,-29.047074219986737),new Point(1004.696796342723,-140.95292578001326)],[new Point(1004.696796342723,-29.047074219986737),new Point(1004.7206704591699,249.0398047033964)],[new Point(1004.696796342723,-29.047074219986737),new Point(1037.27932954083,249.0398047033964),new Point(1037.27932954083,360.96019529660356)],[new Point(1004.696796342723,-29.047074219986737),new Point(1004.7206704591699,360.96019529660356)],[new Point(1004.696796342723,-29.047074219986737),new Point(1037.27932954083,249.0398047033964)],[new Point(1004.696796342723,-29.047074219986737),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294)],[new Point(1004.696796342723,-29.047074219986737),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294),new Point(588.4106157414747,-343.91180848474517)],[new Point(1004.696796342723,-29.047074219986737),new Point(519.5893842585253,-191.08819151525486)],[new Point(1004.696796342723,-29.047074219986737),new Point(728.25,118.65286717815624),new Point(-223.05106963552825,212.0013049052253),new Point(-283.73502185420614,242.3219565841044)],[new Point(1004.696796342723,-29.047074219986737),new Point(728.25,118.65286717815624),new Point(-153.26497814579386,362.6780434158956)],[new Point(1004.696796342723,-29.047074219986737),new Point(728.25,118.65286717815624),new Point(-213.94893036447175,389.9986950947747)],[new Point(1004.696796342723,-29.047074219986737),new Point(728.25,118.65286717815624),new Point(-223.05106963552825,212.0013049052253)],[new Point(1004.696796342723,-29.047074219986737),new Point(-190.49613893835684,-350.86824314212447)],[new Point(1004.696796342723,-29.047074219986737),new Point(-107,-207)],[new Point(1004.696796342723,-29.047074219986737),new Point(-296.99632055783536,-193.9142950057776)],[new Point(1004.696796342723,-29.047074219986737),new Point(973,-420)],[new Point(1004.696796342723,-29.047074219986737),new Point(721,-274.5077321642143)],[new Point(1004.696796342723,-29.047074219986737),new Point(973,-420),new Point(721,-565.4922678357856)],[new Point(1004.696796342723,-29.047074219986737),new Point(-143.5,650)],[new Point(1004.696796342723,-29.047074219986737),new Point(-190.75,677.2798002192098)],[new Point(1004.696796342723,-29.047074219986737),new Point(-190.75,622.7201997807902)],[new Point(1004.696796342723,-29.047074219986737),new Point(161,542)],[new Point(1004.696796342723,-29.047074219986737),new Point(161,542),new Point(129.5,560.1865334794732)],[new Point(1004.696796342723,-29.047074219986737),new Point(129.5,523.8134665205268)],[new Point(1004.696796342723,-29.047074219986737),new Point(647,320)],[new Point(1004.696796342723,-29.047074219986737),new Point(647,320),new Point(584,356.3730669589464)],[new Point(1004.696796342723,-29.047074219986737),new Point(584,283.6269330410536)],[new Point(1004.696796342723,-29.047074219986737),new Point(838.5,55)],[new Point(1004.696796342723,-29.047074219986737),new Point(728.25,118.65286717815624)],[new Point(1004.696796342723,-29.047074219986737),new Point(728.25,-8.652867178156207)],[new Point(1004.696796342723,-29.047074219986737),new Point(260.59999999999997,90)],[new Point(1004.696796342723,-29.047074219986737),new Point(728.25,-8.652867178156207),new Point(-10.29999999999994,246.4041879234696)],[new Point(1004.696796342723,-29.047074219986737),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(1040.303203657277,-140.95292578001326),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294),new Point(271,-479)],[new Point(1040.303203657277,-140.95292578001326),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294),new Point(360.0604335563131,-529.0018277777501)],[new Point(1040.303203657277,-140.95292578001326),new Point(1055,664)],[new Point(1040.303203657277,-140.95292578001326),new Point(1040.303203657277,-29.047074219986737),new Point(784,674)],[new Point(1040.303203657277,-140.95292578001326),new Point(1004.696796342723,-140.95292578001326),new Point(417,656)],[new Point(1040.303203657277,-140.95292578001326),new Point(1004.696796342723,-140.95292578001326),new Point(647,320),new Point(203,759)],[new Point(1040.303203657277,-140.95292578001326),new Point(1004.696796342723,-140.95292578001326),new Point(838.5,55),new Point(56,674)],[new Point(1040.303203657277,-140.95292578001326),new Point(1004.696796342723,-140.95292578001326),new Point(-190.75,622.7201997807902),new Point(-289.3991018391502,729.2006744090877)],[new Point(1040.303203657277,-140.95292578001326),new Point(1004.696796342723,-140.95292578001326),new Point(-381.4843460976219,649.1432030269882)],[new Point(1040.303203657277,-140.95292578001326),new Point(519.5893842585253,-191.08819151525486),new Point(-89.03523617876226,-499.7368825942079)],[new Point(1040.303203657277,-140.95292578001326),new Point(519.5893842585253,-191.08819151525486),new Point(-89.03523617876226,-530.2631174057921),new Point(-200.96476382123774,-530.2631174057921)],[new Point(1040.303203657277,-140.95292578001326),new Point(519.5893842585253,-191.08819151525486),new Point(-200.96476382123774,-499.7368825942079)],[new Point(1040.303203657277,-140.95292578001326),new Point(519.5893842585253,-191.08819151525486),new Point(-89.03523617876226,-530.2631174057921)],[new Point(1040.303203657277,-140.95292578001326),new Point(1040.303203657277,-29.047074219986737),new Point(1004.696796342723,-29.047074219986737)],[new Point(1040.303203657277,-140.95292578001326)],[new Point(1040.303203657277,-140.95292578001326),new Point(1040.303203657277,-29.047074219986737)],[new Point(1040.303203657277,-140.95292578001326),new Point(1004.696796342723,-140.95292578001326)],[new Point(1040.303203657277,-140.95292578001326),new Point(1040.303203657277,-29.047074219986737),new Point(1004.7206704591699,249.0398047033964)],[new Point(1040.303203657277,-140.95292578001326),new Point(1040.303203657277,-29.047074219986737),new Point(1037.27932954083,360.96019529660356)],[new Point(1040.303203657277,-140.95292578001326),new Point(1040.303203657277,-29.047074219986737),new Point(1004.7206704591699,249.0398047033964),new Point(1004.7206704591699,360.96019529660356)],[new Point(1040.303203657277,-140.95292578001326),new Point(1040.303203657277,-29.047074219986737),new Point(1037.27932954083,249.0398047033964)],[new Point(1040.303203657277,-140.95292578001326),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294)],[new Point(1040.303203657277,-140.95292578001326),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294),new Point(588.4106157414747,-343.91180848474517)],[new Point(1040.303203657277,-140.95292578001326),new Point(519.5893842585253,-191.08819151525486)],[new Point(1040.303203657277,-140.95292578001326),new Point(1004.696796342723,-140.95292578001326),new Point(-10.29999999999994,246.4041879234696),new Point(-223.05106963552825,212.0013049052253),new Point(-283.73502185420614,242.3219565841044)],[new Point(1040.303203657277,-140.95292578001326),new Point(1004.696796342723,-140.95292578001326),new Point(-153.26497814579386,362.6780434158956)],[new Point(1040.303203657277,-140.95292578001326),new Point(1004.696796342723,-140.95292578001326),new Point(-213.94893036447175,389.9986950947747)],[new Point(1040.303203657277,-140.95292578001326),new Point(1004.696796342723,-140.95292578001326),new Point(-10.29999999999994,246.4041879234696),new Point(-223.05106963552825,212.0013049052253)],[new Point(1040.303203657277,-140.95292578001326),new Point(519.5893842585253,-191.08819151525486),new Point(-190.49613893835684,-350.86824314212447)],[new Point(1040.303203657277,-140.95292578001326),new Point(-107,-207)],[new Point(1040.303203657277,-140.95292578001326),new Point(-296.99632055783536,-193.9142950057776)],[new Point(1040.303203657277,-140.95292578001326),new Point(973,-420)],[new Point(1040.303203657277,-140.95292578001326),new Point(721,-274.5077321642143)],[new Point(1040.303203657277,-140.95292578001326),new Point(973,-420),new Point(721,-565.4922678357856)],[new Point(1040.303203657277,-140.95292578001326),new Point(1004.696796342723,-140.95292578001326),new Point(728.25,-8.652867178156207),new Point(-143.5,650)],[new Point(1040.303203657277,-140.95292578001326),new Point(1004.696796342723,-140.95292578001326),new Point(728.25,-8.652867178156207),new Point(-143.5,650),new Point(-190.75,677.2798002192098)],[new Point(1040.303203657277,-140.95292578001326),new Point(1004.696796342723,-140.95292578001326),new Point(-190.75,622.7201997807902)],[new Point(1040.303203657277,-140.95292578001326),new Point(1004.696796342723,-140.95292578001326),new Point(838.5,55),new Point(161,542)],[new Point(1040.303203657277,-140.95292578001326),new Point(1004.696796342723,-140.95292578001326),new Point(838.5,55),new Point(161,542),new Point(129.5,560.1865334794732)],[new Point(1040.303203657277,-140.95292578001326),new Point(1004.696796342723,-140.95292578001326),new Point(838.5,55),new Point(129.5,523.8134665205268)],[new Point(1040.303203657277,-140.95292578001326),new Point(1004.696796342723,-140.95292578001326),new Point(647,320)],[new Point(1040.303203657277,-140.95292578001326),new Point(1004.696796342723,-140.95292578001326),new Point(647,320),new Point(584,356.3730669589464)],[new Point(1040.303203657277,-140.95292578001326),new Point(1004.696796342723,-140.95292578001326),new Point(838.5,55),new Point(584,283.6269330410536)],[new Point(1040.303203657277,-140.95292578001326),new Point(1004.696796342723,-140.95292578001326),new Point(838.5,55)],[new Point(1040.303203657277,-140.95292578001326),new Point(1004.696796342723,-140.95292578001326),new Point(838.5,55),new Point(728.25,118.65286717815624)],[new Point(1040.303203657277,-140.95292578001326),new Point(1004.696796342723,-140.95292578001326),new Point(728.25,-8.652867178156207)],[new Point(1040.303203657277,-140.95292578001326),new Point(1004.696796342723,-140.95292578001326),new Point(260.59999999999997,90)],[new Point(1040.303203657277,-140.95292578001326),new Point(1004.696796342723,-140.95292578001326),new Point(-10.29999999999994,246.4041879234696)],[new Point(1040.303203657277,-140.95292578001326),new Point(1004.696796342723,-140.95292578001326),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(1040.303203657277,-29.047074219986737),new Point(1004.696796342723,-29.047074219986737),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294),new Point(271,-479)],[new Point(1040.303203657277,-29.047074219986737),new Point(1004.696796342723,-29.047074219986737),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294),new Point(360.0604335563131,-529.0018277777501)],[new Point(1040.303203657277,-29.047074219986737),new Point(1055,664)],[new Point(1040.303203657277,-29.047074219986737),new Point(784,674)],[new Point(1040.303203657277,-29.047074219986737),new Point(417,656)],[new Point(1040.303203657277,-29.047074219986737),new Point(203,759)],[new Point(1040.303203657277,-29.047074219986737),new Point(56,674)],[new Point(1040.303203657277,-29.047074219986737),new Point(-143.5,650),new Point(-289.3991018391502,729.2006744090877)],[new Point(1040.303203657277,-29.047074219986737),new Point(-381.4843460976219,649.1432030269882)],[new Point(1040.303203657277,-29.047074219986737),new Point(1004.696796342723,-29.047074219986737),new Point(519.5893842585253,-191.08819151525486),new Point(-89.03523617876226,-499.7368825942079)],[new Point(1040.303203657277,-29.047074219986737),new Point(1004.696796342723,-29.047074219986737),new Point(519.5893842585253,-191.08819151525486),new Point(-89.03523617876226,-530.2631174057921),new Point(-200.96476382123774,-530.2631174057921)],[new Point(1040.303203657277,-29.047074219986737),new Point(1004.696796342723,-29.047074219986737),new Point(519.5893842585253,-191.08819151525486),new Point(-200.96476382123774,-499.7368825942079)],[new Point(1040.303203657277,-29.047074219986737),new Point(1004.696796342723,-29.047074219986737),new Point(519.5893842585253,-191.08819151525486),new Point(-89.03523617876226,-530.2631174057921)],[new Point(1040.303203657277,-29.047074219986737),new Point(1004.696796342723,-29.047074219986737)],[new Point(1040.303203657277,-29.047074219986737),new Point(1040.303203657277,-140.95292578001326)],[new Point(1040.303203657277,-29.047074219986737)],[new Point(1040.303203657277,-29.047074219986737),new Point(838.5,55),new Point(1004.696796342723,-140.95292578001326)],[new Point(1040.303203657277,-29.047074219986737),new Point(1004.7206704591699,249.0398047033964)],[new Point(1040.303203657277,-29.047074219986737),new Point(1037.27932954083,360.96019529660356)],[new Point(1040.303203657277,-29.047074219986737),new Point(1004.7206704591699,249.0398047033964),new Point(1004.7206704591699,360.96019529660356)],[new Point(1040.303203657277,-29.047074219986737),new Point(1037.27932954083,249.0398047033964)],[new Point(1040.303203657277,-29.047074219986737),new Point(728.25,-8.652867178156207),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294)],[new Point(1040.303203657277,-29.047074219986737),new Point(728.25,-8.652867178156207),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294),new Point(588.4106157414747,-343.91180848474517)],[new Point(1040.303203657277,-29.047074219986737),new Point(728.25,-8.652867178156207),new Point(519.5893842585253,-191.08819151525486)],[new Point(1040.303203657277,-29.047074219986737),new Point(728.25,118.65286717815624),new Point(-223.05106963552825,212.0013049052253),new Point(-283.73502185420614,242.3219565841044)],[new Point(1040.303203657277,-29.047074219986737),new Point(728.25,118.65286717815624),new Point(-153.26497814579386,362.6780434158956)],[new Point(1040.303203657277,-29.047074219986737),new Point(728.25,118.65286717815624),new Point(-213.94893036447175,389.9986950947747)],[new Point(1040.303203657277,-29.047074219986737),new Point(728.25,118.65286717815624),new Point(-223.05106963552825,212.0013049052253)],[new Point(1040.303203657277,-29.047074219986737),new Point(728.25,-8.652867178156207),new Point(-190.49613893835684,-350.86824314212447)],[new Point(1040.303203657277,-29.047074219986737),new Point(728.25,-8.652867178156207),new Point(-107,-207)],[new Point(1040.303203657277,-29.047074219986737),new Point(728.25,-8.652867178156207),new Point(-296.99632055783536,-193.9142950057776)],[new Point(1040.303203657277,-29.047074219986737),new Point(838.5,55),new Point(973,-420)],[new Point(1040.303203657277,-29.047074219986737),new Point(838.5,55),new Point(721,-274.5077321642143)],[new Point(1040.303203657277,-29.047074219986737),new Point(838.5,55),new Point(973,-420),new Point(721,-565.4922678357856)],[new Point(1040.303203657277,-29.047074219986737),new Point(-143.5,650)],[new Point(1040.303203657277,-29.047074219986737),new Point(-190.75,677.2798002192098)],[new Point(1040.303203657277,-29.047074219986737),new Point(-190.75,622.7201997807902)],[new Point(1040.303203657277,-29.047074219986737),new Point(161,542)],[new Point(1040.303203657277,-29.047074219986737),new Point(161,542),new Point(129.5,560.1865334794732)],[new Point(1040.303203657277,-29.047074219986737),new Point(129.5,523.8134665205268)],[new Point(1040.303203657277,-29.047074219986737),new Point(647,320)],[new Point(1040.303203657277,-29.047074219986737),new Point(647,320),new Point(584,356.3730669589464)],[new Point(1040.303203657277,-29.047074219986737),new Point(584,283.6269330410536)],[new Point(1040.303203657277,-29.047074219986737),new Point(838.5,55)],[new Point(1040.303203657277,-29.047074219986737),new Point(728.25,118.65286717815624)],[new Point(1040.303203657277,-29.047074219986737),new Point(728.25,-8.652867178156207)],[new Point(1040.303203657277,-29.047074219986737),new Point(260.59999999999997,90)],[new Point(1040.303203657277,-29.047074219986737),new Point(728.25,-8.652867178156207),new Point(-10.29999999999994,246.4041879234696)],[new Point(1040.303203657277,-29.047074219986737),new Point(728.25,-8.652867178156207),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(1004.696796342723,-140.95292578001326),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294),new Point(271,-479)],[new Point(1004.696796342723,-140.95292578001326),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294),new Point(360.0604335563131,-529.0018277777501)],[new Point(1004.696796342723,-140.95292578001326),new Point(1004.696796342723,-29.047074219986737),new Point(1037.27932954083,249.0398047033964),new Point(1055,664)],[new Point(1004.696796342723,-140.95292578001326),new Point(784,674)],[new Point(1004.696796342723,-140.95292578001326),new Point(417,656)],[new Point(1004.696796342723,-140.95292578001326),new Point(647,320),new Point(203,759)],[new Point(1004.696796342723,-140.95292578001326),new Point(838.5,55),new Point(56,674)],[new Point(1004.696796342723,-140.95292578001326),new Point(-190.75,622.7201997807902),new Point(-289.3991018391502,729.2006744090877)],[new Point(1004.696796342723,-140.95292578001326),new Point(-381.4843460976219,649.1432030269882)],[new Point(1004.696796342723,-140.95292578001326),new Point(519.5893842585253,-191.08819151525486),new Point(-89.03523617876226,-499.7368825942079)],[new Point(1004.696796342723,-140.95292578001326),new Point(519.5893842585253,-191.08819151525486),new Point(-89.03523617876226,-530.2631174057921),new Point(-200.96476382123774,-530.2631174057921)],[new Point(1004.696796342723,-140.95292578001326),new Point(519.5893842585253,-191.08819151525486),new Point(-200.96476382123774,-499.7368825942079)],[new Point(1004.696796342723,-140.95292578001326),new Point(519.5893842585253,-191.08819151525486),new Point(-89.03523617876226,-530.2631174057921)],[new Point(1004.696796342723,-140.95292578001326),new Point(1004.696796342723,-29.047074219986737)],[new Point(1004.696796342723,-140.95292578001326),new Point(1040.303203657277,-140.95292578001326)],[new Point(1004.696796342723,-140.95292578001326),new Point(838.5,55),new Point(1040.303203657277,-29.047074219986737)],[new Point(1004.696796342723,-140.95292578001326)],[new Point(1004.696796342723,-140.95292578001326),new Point(1004.7206704591699,249.0398047033964)],[new Point(1004.696796342723,-140.95292578001326),new Point(1004.7206704591699,360.96019529660356),new Point(1037.27932954083,360.96019529660356)],[new Point(1004.696796342723,-140.95292578001326),new Point(1004.7206704591699,360.96019529660356)],[new Point(1004.696796342723,-140.95292578001326),new Point(1004.7206704591699,249.0398047033964),new Point(1037.27932954083,249.0398047033964)],[new Point(1004.696796342723,-140.95292578001326),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294)],[new Point(1004.696796342723,-140.95292578001326),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294),new Point(588.4106157414747,-343.91180848474517)],[new Point(1004.696796342723,-140.95292578001326),new Point(519.5893842585253,-191.08819151525486)],[new Point(1004.696796342723,-140.95292578001326),new Point(-10.29999999999994,246.4041879234696),new Point(-223.05106963552825,212.0013049052253),new Point(-283.73502185420614,242.3219565841044)],[new Point(1004.696796342723,-140.95292578001326),new Point(-153.26497814579386,362.6780434158956)],[new Point(1004.696796342723,-140.95292578001326),new Point(-213.94893036447175,389.9986950947747)],[new Point(1004.696796342723,-140.95292578001326),new Point(-10.29999999999994,246.4041879234696),new Point(-223.05106963552825,212.0013049052253)],[new Point(1004.696796342723,-140.95292578001326),new Point(519.5893842585253,-191.08819151525486),new Point(-190.49613893835684,-350.86824314212447)],[new Point(1004.696796342723,-140.95292578001326),new Point(-107,-207)],[new Point(1004.696796342723,-140.95292578001326),new Point(-296.99632055783536,-193.9142950057776)],[new Point(1004.696796342723,-140.95292578001326),new Point(973,-420)],[new Point(1004.696796342723,-140.95292578001326),new Point(721,-274.5077321642143)],[new Point(1004.696796342723,-140.95292578001326),new Point(973,-420),new Point(721,-565.4922678357856)],[new Point(1004.696796342723,-140.95292578001326),new Point(728.25,-8.652867178156207),new Point(-143.5,650)],[new Point(1004.696796342723,-140.95292578001326),new Point(728.25,-8.652867178156207),new Point(-143.5,650),new Point(-190.75,677.2798002192098)],[new Point(1004.696796342723,-140.95292578001326),new Point(-190.75,622.7201997807902)],[new Point(1004.696796342723,-140.95292578001326),new Point(838.5,55),new Point(161,542)],[new Point(1004.696796342723,-140.95292578001326),new Point(838.5,55),new Point(161,542),new Point(129.5,560.1865334794732)],[new Point(1004.696796342723,-140.95292578001326),new Point(838.5,55),new Point(129.5,523.8134665205268)],[new Point(1004.696796342723,-140.95292578001326),new Point(647,320)],[new Point(1004.696796342723,-140.95292578001326),new Point(647,320),new Point(584,356.3730669589464)],[new Point(1004.696796342723,-140.95292578001326),new Point(838.5,55),new Point(584,283.6269330410536)],[new Point(1004.696796342723,-140.95292578001326),new Point(838.5,55)],[new Point(1004.696796342723,-140.95292578001326),new Point(838.5,55),new Point(728.25,118.65286717815624)],[new Point(1004.696796342723,-140.95292578001326),new Point(728.25,-8.652867178156207)],[new Point(1004.696796342723,-140.95292578001326),new Point(260.59999999999997,90)],[new Point(1004.696796342723,-140.95292578001326),new Point(-10.29999999999994,246.4041879234696)],[new Point(1004.696796342723,-140.95292578001326),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(1004.7206704591699,249.0398047033964),new Point(838.5,55),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294),new Point(271,-479)],[new Point(1004.7206704591699,249.0398047033964),new Point(838.5,55),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294),new Point(360.0604335563131,-529.0018277777501)],[new Point(1004.7206704591699,249.0398047033964),new Point(1004.7206704591699,360.96019529660356),new Point(1055,664)],[new Point(1004.7206704591699,249.0398047033964),new Point(784,674)],[new Point(1004.7206704591699,249.0398047033964),new Point(417,656)],[new Point(1004.7206704591699,249.0398047033964),new Point(203,759)],[new Point(1004.7206704591699,249.0398047033964),new Point(56,674)],[new Point(1004.7206704591699,249.0398047033964),new Point(-289.3991018391502,729.2006744090877)],[new Point(1004.7206704591699,249.0398047033964),new Point(-381.4843460976219,649.1432030269882)],[new Point(1004.7206704591699,249.0398047033964),new Point(728.25,118.65286717815624),new Point(-89.03523617876226,-499.7368825942079)],[new Point(1004.7206704591699,249.0398047033964),new Point(-200.96476382123774,-499.7368825942079),new Point(-200.96476382123774,-530.2631174057921)],[new Point(1004.7206704591699,249.0398047033964),new Point(-200.96476382123774,-499.7368825942079)],[new Point(1004.7206704591699,249.0398047033964),new Point(728.25,118.65286717815624),new Point(-89.03523617876226,-530.2631174057921)],[new Point(1004.7206704591699,249.0398047033964),new Point(1004.696796342723,-29.047074219986737)],[new Point(1004.7206704591699,249.0398047033964),new Point(1040.303203657277,-29.047074219986737),new Point(1040.303203657277,-140.95292578001326)],[new Point(1004.7206704591699,249.0398047033964),new Point(1040.303203657277,-29.047074219986737)],[new Point(1004.7206704591699,249.0398047033964),new Point(1004.696796342723,-140.95292578001326)],[new Point(1004.7206704591699,249.0398047033964)],[new Point(1004.7206704591699,249.0398047033964),new Point(1037.27932954083,249.0398047033964),new Point(1037.27932954083,360.96019529660356)],[new Point(1004.7206704591699,249.0398047033964),new Point(1004.7206704591699,360.96019529660356)],[new Point(1004.7206704591699,249.0398047033964),new Point(1037.27932954083,249.0398047033964)],[new Point(1004.7206704591699,249.0398047033964),new Point(838.5,55),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294)],[new Point(1004.7206704591699,249.0398047033964),new Point(838.5,55),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294),new Point(588.4106157414747,-343.91180848474517)],[new Point(1004.7206704591699,249.0398047033964),new Point(838.5,55),new Point(519.5893842585253,-191.08819151525486)],[new Point(1004.7206704591699,249.0398047033964),new Point(-223.05106963552825,212.0013049052253),new Point(-283.73502185420614,242.3219565841044)],[new Point(1004.7206704591699,249.0398047033964),new Point(-153.26497814579386,362.6780434158956)],[new Point(1004.7206704591699,249.0398047033964),new Point(-213.94893036447175,389.9986950947747)],[new Point(1004.7206704591699,249.0398047033964),new Point(-223.05106963552825,212.0013049052253)],[new Point(1004.7206704591699,249.0398047033964),new Point(-190.49613893835684,-350.86824314212447)],[new Point(1004.7206704591699,249.0398047033964),new Point(-107,-207)],[new Point(1004.7206704591699,249.0398047033964),new Point(-296.99632055783536,-193.9142950057776)],[new Point(1004.7206704591699,249.0398047033964),new Point(973,-420)],[new Point(1004.7206704591699,249.0398047033964),new Point(721,-274.5077321642143)],[new Point(1004.7206704591699,249.0398047033964),new Point(973,-420),new Point(721,-565.4922678357856)],[new Point(1004.7206704591699,249.0398047033964),new Point(129.5,560.1865334794732),new Point(-143.5,650)],[new Point(1004.7206704591699,249.0398047033964),new Point(-190.75,677.2798002192098)],[new Point(1004.7206704591699,249.0398047033964),new Point(-190.75,622.7201997807902)],[new Point(1004.7206704591699,249.0398047033964),new Point(161,542)],[new Point(1004.7206704591699,249.0398047033964),new Point(129.5,560.1865334794732)],[new Point(1004.7206704591699,249.0398047033964),new Point(129.5,523.8134665205268)],[new Point(1004.7206704591699,249.0398047033964),new Point(647,320)],[new Point(1004.7206704591699,249.0398047033964),new Point(584,356.3730669589464)],[new Point(1004.7206704591699,249.0398047033964),new Point(584,283.6269330410536)],[new Point(1004.7206704591699,249.0398047033964),new Point(838.5,55)],[new Point(1004.7206704591699,249.0398047033964),new Point(728.25,118.65286717815624)],[new Point(1004.7206704591699,249.0398047033964),new Point(838.5,55),new Point(728.25,-8.652867178156207)],[new Point(1004.7206704591699,249.0398047033964),new Point(260.59999999999997,90)],[new Point(1004.7206704591699,249.0398047033964),new Point(-10.29999999999994,246.4041879234696)],[new Point(1004.7206704591699,249.0398047033964),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(1037.27932954083,360.96019529660356),new Point(1004.7206704591699,360.96019529660356),new Point(728.25,118.65286717815624),new Point(271,-479)],[new Point(1037.27932954083,360.96019529660356),new Point(1004.7206704591699,360.96019529660356),new Point(728.25,118.65286717815624),new Point(471.13992102513606,-235.48983908715294),new Point(360.0604335563131,-529.0018277777501)],[new Point(1037.27932954083,360.96019529660356),new Point(1055,664)],[new Point(1037.27932954083,360.96019529660356),new Point(784,674)],[new Point(1037.27932954083,360.96019529660356),new Point(417,656)],[new Point(1037.27932954083,360.96019529660356),new Point(203,759)],[new Point(1037.27932954083,360.96019529660356),new Point(56,674)],[new Point(1037.27932954083,360.96019529660356),new Point(-289.3991018391502,729.2006744090877)],[new Point(1037.27932954083,360.96019529660356),new Point(129.5,560.1865334794732),new Point(-381.4843460976219,649.1432030269882)],[new Point(1037.27932954083,360.96019529660356),new Point(1004.7206704591699,360.96019529660356),new Point(-89.03523617876226,-499.7368825942079)],[new Point(1037.27932954083,360.96019529660356),new Point(1004.7206704591699,360.96019529660356),new Point(-200.96476382123774,-499.7368825942079),new Point(-200.96476382123774,-530.2631174057921)],[new Point(1037.27932954083,360.96019529660356),new Point(1004.7206704591699,360.96019529660356),new Point(-200.96476382123774,-499.7368825942079)],[new Point(1037.27932954083,360.96019529660356),new Point(1004.7206704591699,360.96019529660356),new Point(-89.03523617876226,-530.2631174057921)],[new Point(1037.27932954083,360.96019529660356),new Point(1037.27932954083,249.0398047033964),new Point(1004.696796342723,-29.047074219986737)],[new Point(1037.27932954083,360.96019529660356),new Point(1040.303203657277,-29.047074219986737),new Point(1040.303203657277,-140.95292578001326)],[new Point(1037.27932954083,360.96019529660356),new Point(1040.303203657277,-29.047074219986737)],[new Point(1037.27932954083,360.96019529660356),new Point(1004.7206704591699,360.96019529660356),new Point(1004.696796342723,-140.95292578001326)],[new Point(1037.27932954083,360.96019529660356),new Point(1037.27932954083,249.0398047033964),new Point(1004.7206704591699,249.0398047033964)],[new Point(1037.27932954083,360.96019529660356)],[new Point(1037.27932954083,360.96019529660356),new Point(1004.7206704591699,360.96019529660356)],[new Point(1037.27932954083,360.96019529660356),new Point(1037.27932954083,249.0398047033964)],[new Point(1037.27932954083,360.96019529660356),new Point(1004.7206704591699,360.96019529660356),new Point(728.25,118.65286717815624),new Point(471.13992102513606,-235.48983908715294)],[new Point(1037.27932954083,360.96019529660356),new Point(1004.7206704591699,360.96019529660356),new Point(728.25,118.65286717815624),new Point(471.13992102513606,-235.48983908715294),new Point(588.4106157414747,-343.91180848474517)],[new Point(1037.27932954083,360.96019529660356),new Point(1004.7206704591699,360.96019529660356),new Point(728.25,118.65286717815624),new Point(519.5893842585253,-191.08819151525486)],[new Point(1037.27932954083,360.96019529660356),new Point(1004.7206704591699,360.96019529660356),new Point(584,283.6269330410536),new Point(-223.05106963552825,212.0013049052253),new Point(-283.73502185420614,242.3219565841044)],[new Point(1037.27932954083,360.96019529660356),new Point(-153.26497814579386,362.6780434158956)],[new Point(1037.27932954083,360.96019529660356),new Point(-213.94893036447175,389.9986950947747)],[new Point(1037.27932954083,360.96019529660356),new Point(1004.7206704591699,360.96019529660356),new Point(584,283.6269330410536),new Point(-223.05106963552825,212.0013049052253)],[new Point(1037.27932954083,360.96019529660356),new Point(1004.7206704591699,360.96019529660356),new Point(-190.49613893835684,-350.86824314212447)],[new Point(1037.27932954083,360.96019529660356),new Point(1004.7206704591699,360.96019529660356),new Point(-107,-207)],[new Point(1037.27932954083,360.96019529660356),new Point(1004.7206704591699,360.96019529660356),new Point(-296.99632055783536,-193.9142950057776)],[new Point(1037.27932954083,360.96019529660356),new Point(1004.7206704591699,360.96019529660356),new Point(973,-420)],[new Point(1037.27932954083,360.96019529660356),new Point(1037.27932954083,249.0398047033964),new Point(721,-274.5077321642143)],[new Point(1037.27932954083,360.96019529660356),new Point(1004.7206704591699,360.96019529660356),new Point(973,-420),new Point(721,-565.4922678357856)],[new Point(1037.27932954083,360.96019529660356),new Point(-143.5,650)],[new Point(1037.27932954083,360.96019529660356),new Point(-190.75,677.2798002192098)],[new Point(1037.27932954083,360.96019529660356),new Point(129.5,560.1865334794732),new Point(-190.75,622.7201997807902)],[new Point(1037.27932954083,360.96019529660356),new Point(161,542)],[new Point(1037.27932954083,360.96019529660356),new Point(129.5,560.1865334794732)],[new Point(1037.27932954083,360.96019529660356),new Point(129.5,523.8134665205268)],[new Point(1037.27932954083,360.96019529660356),new Point(1004.7206704591699,360.96019529660356),new Point(647,320)],[new Point(1037.27932954083,360.96019529660356),new Point(584,356.3730669589464)],[new Point(1037.27932954083,360.96019529660356),new Point(1004.7206704591699,360.96019529660356),new Point(584,283.6269330410536)],[new Point(1037.27932954083,360.96019529660356),new Point(1004.7206704591699,360.96019529660356),new Point(838.5,55)],[new Point(1037.27932954083,360.96019529660356),new Point(1004.7206704591699,360.96019529660356),new Point(728.25,118.65286717815624)],[new Point(1037.27932954083,360.96019529660356),new Point(1004.7206704591699,360.96019529660356),new Point(838.5,55),new Point(728.25,-8.652867178156207)],[new Point(1037.27932954083,360.96019529660356),new Point(1004.7206704591699,360.96019529660356),new Point(260.59999999999997,90)],[new Point(1037.27932954083,360.96019529660356),new Point(1004.7206704591699,360.96019529660356),new Point(584,283.6269330410536),new Point(-10.29999999999994,246.4041879234696)],[new Point(1037.27932954083,360.96019529660356),new Point(1004.7206704591699,360.96019529660356),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(1004.7206704591699,360.96019529660356),new Point(728.25,118.65286717815624),new Point(271,-479)],[new Point(1004.7206704591699,360.96019529660356),new Point(728.25,118.65286717815624),new Point(471.13992102513606,-235.48983908715294),new Point(360.0604335563131,-529.0018277777501)],[new Point(1004.7206704591699,360.96019529660356),new Point(1055,664)],[new Point(1004.7206704591699,360.96019529660356),new Point(784,674)],[new Point(1004.7206704591699,360.96019529660356),new Point(417,656)],[new Point(1004.7206704591699,360.96019529660356),new Point(203,759)],[new Point(1004.7206704591699,360.96019529660356),new Point(56,674)],[new Point(1004.7206704591699,360.96019529660356),new Point(-289.3991018391502,729.2006744090877)],[new Point(1004.7206704591699,360.96019529660356),new Point(129.5,560.1865334794732),new Point(-381.4843460976219,649.1432030269882)],[new Point(1004.7206704591699,360.96019529660356),new Point(-89.03523617876226,-499.7368825942079)],[new Point(1004.7206704591699,360.96019529660356),new Point(-200.96476382123774,-499.7368825942079),new Point(-200.96476382123774,-530.2631174057921)],[new Point(1004.7206704591699,360.96019529660356),new Point(-200.96476382123774,-499.7368825942079)],[new Point(1004.7206704591699,360.96019529660356),new Point(-89.03523617876226,-530.2631174057921)],[new Point(1004.7206704591699,360.96019529660356),new Point(1004.696796342723,-29.047074219986737)],[new Point(1004.7206704591699,360.96019529660356),new Point(1004.7206704591699,249.0398047033964),new Point(1040.303203657277,-29.047074219986737),new Point(1040.303203657277,-140.95292578001326)],[new Point(1004.7206704591699,360.96019529660356),new Point(1004.7206704591699,249.0398047033964),new Point(1040.303203657277,-29.047074219986737)],[new Point(1004.7206704591699,360.96019529660356),new Point(1004.696796342723,-140.95292578001326)],[new Point(1004.7206704591699,360.96019529660356),new Point(1004.7206704591699,249.0398047033964)],[new Point(1004.7206704591699,360.96019529660356),new Point(1037.27932954083,360.96019529660356)],[new Point(1004.7206704591699,360.96019529660356)],[new Point(1004.7206704591699,360.96019529660356),new Point(838.5,55),new Point(1037.27932954083,249.0398047033964)],[new Point(1004.7206704591699,360.96019529660356),new Point(728.25,118.65286717815624),new Point(471.13992102513606,-235.48983908715294)],[new Point(1004.7206704591699,360.96019529660356),new Point(728.25,118.65286717815624),new Point(471.13992102513606,-235.48983908715294),new Point(588.4106157414747,-343.91180848474517)],[new Point(1004.7206704591699,360.96019529660356),new Point(728.25,118.65286717815624),new Point(519.5893842585253,-191.08819151525486)],[new Point(1004.7206704591699,360.96019529660356),new Point(584,283.6269330410536),new Point(-223.05106963552825,212.0013049052253),new Point(-283.73502185420614,242.3219565841044)],[new Point(1004.7206704591699,360.96019529660356),new Point(-153.26497814579386,362.6780434158956)],[new Point(1004.7206704591699,360.96019529660356),new Point(-213.94893036447175,389.9986950947747)],[new Point(1004.7206704591699,360.96019529660356),new Point(584,283.6269330410536),new Point(-223.05106963552825,212.0013049052253)],[new Point(1004.7206704591699,360.96019529660356),new Point(-190.49613893835684,-350.86824314212447)],[new Point(1004.7206704591699,360.96019529660356),new Point(-107,-207)],[new Point(1004.7206704591699,360.96019529660356),new Point(-296.99632055783536,-193.9142950057776)],[new Point(1004.7206704591699,360.96019529660356),new Point(973,-420)],[new Point(1004.7206704591699,360.96019529660356),new Point(721,-274.5077321642143)],[new Point(1004.7206704591699,360.96019529660356),new Point(973,-420),new Point(721,-565.4922678357856)],[new Point(1004.7206704591699,360.96019529660356),new Point(-143.5,650)],[new Point(1004.7206704591699,360.96019529660356),new Point(-190.75,677.2798002192098)],[new Point(1004.7206704591699,360.96019529660356),new Point(129.5,560.1865334794732),new Point(-190.75,622.7201997807902)],[new Point(1004.7206704591699,360.96019529660356),new Point(161,542)],[new Point(1004.7206704591699,360.96019529660356),new Point(129.5,560.1865334794732)],[new Point(1004.7206704591699,360.96019529660356),new Point(129.5,523.8134665205268)],[new Point(1004.7206704591699,360.96019529660356),new Point(647,320)],[new Point(1004.7206704591699,360.96019529660356),new Point(584,356.3730669589464)],[new Point(1004.7206704591699,360.96019529660356),new Point(584,283.6269330410536)],[new Point(1004.7206704591699,360.96019529660356),new Point(838.5,55)],[new Point(1004.7206704591699,360.96019529660356),new Point(728.25,118.65286717815624)],[new Point(1004.7206704591699,360.96019529660356),new Point(838.5,55),new Point(728.25,-8.652867178156207)],[new Point(1004.7206704591699,360.96019529660356),new Point(260.59999999999997,90)],[new Point(1004.7206704591699,360.96019529660356),new Point(584,283.6269330410536),new Point(-10.29999999999994,246.4041879234696)],[new Point(1004.7206704591699,360.96019529660356),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(1037.27932954083,249.0398047033964),new Point(838.5,55),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294),new Point(271,-479)],[new Point(1037.27932954083,249.0398047033964),new Point(838.5,55),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294),new Point(360.0604335563131,-529.0018277777501)],[new Point(1037.27932954083,249.0398047033964),new Point(1055,664)],[new Point(1037.27932954083,249.0398047033964),new Point(1004.7206704591699,249.0398047033964),new Point(784,674)],[new Point(1037.27932954083,249.0398047033964),new Point(1004.7206704591699,249.0398047033964),new Point(417,656)],[new Point(1037.27932954083,249.0398047033964),new Point(1004.7206704591699,249.0398047033964),new Point(203,759)],[new Point(1037.27932954083,249.0398047033964),new Point(1004.7206704591699,249.0398047033964),new Point(56,674)],[new Point(1037.27932954083,249.0398047033964),new Point(1004.7206704591699,249.0398047033964),new Point(-289.3991018391502,729.2006744090877)],[new Point(1037.27932954083,249.0398047033964),new Point(1004.7206704591699,249.0398047033964),new Point(-381.4843460976219,649.1432030269882)],[new Point(1037.27932954083,249.0398047033964),new Point(838.5,55),new Point(-89.03523617876226,-499.7368825942079)],[new Point(1037.27932954083,249.0398047033964),new Point(728.25,118.65286717815624),new Point(-200.96476382123774,-499.7368825942079),new Point(-200.96476382123774,-530.2631174057921)],[new Point(1037.27932954083,249.0398047033964),new Point(728.25,118.65286717815624),new Point(-200.96476382123774,-499.7368825942079)],[new Point(1037.27932954083,249.0398047033964),new Point(838.5,55),new Point(-89.03523617876226,-530.2631174057921)],[new Point(1037.27932954083,249.0398047033964),new Point(1004.696796342723,-29.047074219986737)],[new Point(1037.27932954083,249.0398047033964),new Point(1040.303203657277,-29.047074219986737),new Point(1040.303203657277,-140.95292578001326)],[new Point(1037.27932954083,249.0398047033964),new Point(1040.303203657277,-29.047074219986737)],[new Point(1037.27932954083,249.0398047033964),new Point(1004.7206704591699,249.0398047033964),new Point(1004.696796342723,-140.95292578001326)],[new Point(1037.27932954083,249.0398047033964),new Point(1004.7206704591699,249.0398047033964)],[new Point(1037.27932954083,249.0398047033964),new Point(1037.27932954083,360.96019529660356)],[new Point(1037.27932954083,249.0398047033964),new Point(838.5,55),new Point(1004.7206704591699,360.96019529660356)],[new Point(1037.27932954083,249.0398047033964)],[new Point(1037.27932954083,249.0398047033964),new Point(838.5,55),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294)],[new Point(1037.27932954083,249.0398047033964),new Point(838.5,55),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294),new Point(588.4106157414747,-343.91180848474517)],[new Point(1037.27932954083,249.0398047033964),new Point(838.5,55),new Point(519.5893842585253,-191.08819151525486)],[new Point(1037.27932954083,249.0398047033964),new Point(-223.05106963552825,212.0013049052253),new Point(-283.73502185420614,242.3219565841044)],[new Point(1037.27932954083,249.0398047033964),new Point(-10.29999999999994,246.4041879234696),new Point(-153.26497814579386,362.6780434158956)],[new Point(1037.27932954083,249.0398047033964),new Point(-10.29999999999994,246.4041879234696),new Point(-153.26497814579386,362.6780434158956),new Point(-213.94893036447175,389.9986950947747)],[new Point(1037.27932954083,249.0398047033964),new Point(-223.05106963552825,212.0013049052253)],[new Point(1037.27932954083,249.0398047033964),new Point(-190.49613893835684,-350.86824314212447)],[new Point(1037.27932954083,249.0398047033964),new Point(-107,-207)],[new Point(1037.27932954083,249.0398047033964),new Point(-296.99632055783536,-193.9142950057776)],[new Point(1037.27932954083,249.0398047033964),new Point(838.5,55),new Point(973,-420)],[new Point(1037.27932954083,249.0398047033964),new Point(721,-274.5077321642143)],[new Point(1037.27932954083,249.0398047033964),new Point(838.5,55),new Point(973,-420),new Point(721,-565.4922678357856)],[new Point(1037.27932954083,249.0398047033964),new Point(728.25,118.65286717815624),new Point(-143.5,650)],[new Point(1037.27932954083,249.0398047033964),new Point(728.25,118.65286717815624),new Point(-190.75,677.2798002192098)],[new Point(1037.27932954083,249.0398047033964),new Point(728.25,118.65286717815624),new Point(-190.75,622.7201997807902)],[new Point(1037.27932954083,249.0398047033964),new Point(728.25,118.65286717815624),new Point(161,542)],[new Point(1037.27932954083,249.0398047033964),new Point(728.25,118.65286717815624),new Point(161,542),new Point(129.5,560.1865334794732)],[new Point(1037.27932954083,249.0398047033964),new Point(728.25,118.65286717815624),new Point(129.5,523.8134665205268)],[new Point(1037.27932954083,249.0398047033964),new Point(728.25,118.65286717815624),new Point(647,320)],[new Point(1037.27932954083,249.0398047033964),new Point(728.25,118.65286717815624),new Point(647,320),new Point(584,356.3730669589464)],[new Point(1037.27932954083,249.0398047033964),new Point(728.25,118.65286717815624),new Point(584,283.6269330410536)],[new Point(1037.27932954083,249.0398047033964),new Point(838.5,55)],[new Point(1037.27932954083,249.0398047033964),new Point(728.25,118.65286717815624)],[new Point(1037.27932954083,249.0398047033964),new Point(838.5,55),new Point(728.25,-8.652867178156207)],[new Point(1037.27932954083,249.0398047033964),new Point(260.59999999999997,90)],[new Point(1037.27932954083,249.0398047033964),new Point(-10.29999999999994,246.4041879234696)],[new Point(1037.27932954083,249.0398047033964),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(471.13992102513606,-235.48983908715294),new Point(271,-479)],[new Point(471.13992102513606,-235.48983908715294),new Point(360.0604335563131,-529.0018277777501)],[new Point(471.13992102513606,-235.48983908715294),new Point(1055,664)],[new Point(471.13992102513606,-235.48983908715294),new Point(784,674)],[new Point(471.13992102513606,-235.48983908715294),new Point(417,656)],[new Point(471.13992102513606,-235.48983908715294),new Point(203,759)],[new Point(471.13992102513606,-235.48983908715294),new Point(56,674)],[new Point(471.13992102513606,-235.48983908715294),new Point(-289.3991018391502,729.2006744090877)],[new Point(471.13992102513606,-235.48983908715294),new Point(260.59999999999997,90),new Point(-381.4843460976219,649.1432030269882)],[new Point(471.13992102513606,-235.48983908715294),new Point(-89.03523617876226,-499.7368825942079)],[new Point(471.13992102513606,-235.48983908715294),new Point(-89.03523617876226,-530.2631174057921),new Point(-200.96476382123774,-530.2631174057921)],[new Point(471.13992102513606,-235.48983908715294),new Point(-200.96476382123774,-499.7368825942079)],[new Point(471.13992102513606,-235.48983908715294),new Point(-89.03523617876226,-530.2631174057921)],[new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(1004.696796342723,-29.047074219986737)],[new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(1040.303203657277,-140.95292578001326)],[new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(728.25,-8.652867178156207),new Point(1040.303203657277,-29.047074219986737)],[new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(1004.696796342723,-140.95292578001326)],[new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(838.5,55),new Point(1004.7206704591699,249.0398047033964)],[new Point(471.13992102513606,-235.48983908715294),new Point(728.25,118.65286717815624),new Point(1004.7206704591699,360.96019529660356),new Point(1037.27932954083,360.96019529660356)],[new Point(471.13992102513606,-235.48983908715294),new Point(728.25,118.65286717815624),new Point(1004.7206704591699,360.96019529660356)],[new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(838.5,55),new Point(1037.27932954083,249.0398047033964)],[new Point(471.13992102513606,-235.48983908715294)],[new Point(471.13992102513606,-235.48983908715294),new Point(588.4106157414747,-343.91180848474517)],[new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486)],[new Point(471.13992102513606,-235.48983908715294),new Point(-10.300000000000068,-66.40418792346955),new Point(-283.73502185420614,242.3219565841044)],[new Point(471.13992102513606,-235.48983908715294),new Point(260.59999999999997,90),new Point(-153.26497814579386,362.6780434158956)],[new Point(471.13992102513606,-235.48983908715294),new Point(260.59999999999997,90),new Point(-153.26497814579386,362.6780434158956),new Point(-213.94893036447175,389.9986950947747)],[new Point(471.13992102513606,-235.48983908715294),new Point(-10.300000000000068,-66.40418792346955),new Point(-223.05106963552825,212.0013049052253)],[new Point(471.13992102513606,-235.48983908715294),new Point(-190.49613893835684,-350.86824314212447)],[new Point(471.13992102513606,-235.48983908715294),new Point(-107,-207)],[new Point(471.13992102513606,-235.48983908715294),new Point(-296.99632055783536,-193.9142950057776)],[new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(721,-274.5077321642143),new Point(973,-420)],[new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(721,-274.5077321642143)],[new Point(471.13992102513606,-235.48983908715294),new Point(721,-565.4922678357856)],[new Point(471.13992102513606,-235.48983908715294),new Point(-143.5,650)],[new Point(471.13992102513606,-235.48983908715294),new Point(-143.5,650),new Point(-190.75,677.2798002192098)],[new Point(471.13992102513606,-235.48983908715294),new Point(-190.75,622.7201997807902)],[new Point(471.13992102513606,-235.48983908715294),new Point(161,542)],[new Point(471.13992102513606,-235.48983908715294),new Point(129.5,523.8134665205268),new Point(129.5,560.1865334794732)],[new Point(471.13992102513606,-235.48983908715294),new Point(129.5,523.8134665205268)],[new Point(471.13992102513606,-235.48983908715294),new Point(647,320)],[new Point(471.13992102513606,-235.48983908715294),new Point(584,356.3730669589464)],[new Point(471.13992102513606,-235.48983908715294),new Point(584,283.6269330410536)],[new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(838.5,55)],[new Point(471.13992102513606,-235.48983908715294),new Point(728.25,118.65286717815624)],[new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(728.25,-8.652867178156207)],[new Point(471.13992102513606,-235.48983908715294),new Point(260.59999999999997,90)],[new Point(471.13992102513606,-235.48983908715294),new Point(260.59999999999997,90),new Point(-10.29999999999994,246.4041879234696)],[new Point(471.13992102513606,-235.48983908715294),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(588.4106157414747,-343.91180848474517),new Point(271,-479)],[new Point(588.4106157414747,-343.91180848474517),new Point(360.0604335563131,-529.0018277777501)],[new Point(588.4106157414747,-343.91180848474517),new Point(471.13992102513606,-235.48983908715294),new Point(1055,664)],[new Point(588.4106157414747,-343.91180848474517),new Point(471.13992102513606,-235.48983908715294),new Point(784,674)],[new Point(588.4106157414747,-343.91180848474517),new Point(471.13992102513606,-235.48983908715294),new Point(417,656)],[new Point(588.4106157414747,-343.91180848474517),new Point(471.13992102513606,-235.48983908715294),new Point(203,759)],[new Point(588.4106157414747,-343.91180848474517),new Point(471.13992102513606,-235.48983908715294),new Point(56,674)],[new Point(588.4106157414747,-343.91180848474517),new Point(471.13992102513606,-235.48983908715294),new Point(-289.3991018391502,729.2006744090877)],[new Point(588.4106157414747,-343.91180848474517),new Point(471.13992102513606,-235.48983908715294),new Point(260.59999999999997,90),new Point(-381.4843460976219,649.1432030269882)],[new Point(588.4106157414747,-343.91180848474517),new Point(-89.03523617876226,-499.7368825942079)],[new Point(588.4106157414747,-343.91180848474517),new Point(-89.03523617876226,-530.2631174057921),new Point(-200.96476382123774,-530.2631174057921)],[new Point(588.4106157414747,-343.91180848474517),new Point(-200.96476382123774,-499.7368825942079)],[new Point(588.4106157414747,-343.91180848474517),new Point(-89.03523617876226,-530.2631174057921)],[new Point(588.4106157414747,-343.91180848474517),new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(1004.696796342723,-29.047074219986737)],[new Point(588.4106157414747,-343.91180848474517),new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(1040.303203657277,-140.95292578001326)],[new Point(588.4106157414747,-343.91180848474517),new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(728.25,-8.652867178156207),new Point(1040.303203657277,-29.047074219986737)],[new Point(588.4106157414747,-343.91180848474517),new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(1004.696796342723,-140.95292578001326)],[new Point(588.4106157414747,-343.91180848474517),new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(838.5,55),new Point(1004.7206704591699,249.0398047033964)],[new Point(588.4106157414747,-343.91180848474517),new Point(471.13992102513606,-235.48983908715294),new Point(728.25,118.65286717815624),new Point(1004.7206704591699,360.96019529660356),new Point(1037.27932954083,360.96019529660356)],[new Point(588.4106157414747,-343.91180848474517),new Point(471.13992102513606,-235.48983908715294),new Point(728.25,118.65286717815624),new Point(1004.7206704591699,360.96019529660356)],[new Point(588.4106157414747,-343.91180848474517),new Point(471.13992102513606,-235.48983908715294),new Point(519.5893842585253,-191.08819151525486),new Point(838.5,55),new Point(1037.27932954083,249.0398047033964)],[new Point(588.4106157414747,-343.91180848474517),new Point(471.13992102513606,-235.48983908715294)],[new Point(588.4106157414747,-343.91180848474517)],[new Point(588.4106157414747,-343.91180848474517),new Point(721,-565.4922678357856),new Point(973,-420),new Point(721,-274.5077321642143),new Point(519.5893842585253,-191.08819151525486)],[new Point(588.4106157414747,-343.91180848474517),new Point(-10.300000000000068,-66.40418792346955),new Point(-283.73502185420614,242.3219565841044)],[new Point(588.4106157414747,-343.91180848474517),new Point(-10.300000000000068,-66.40418792346955),new Point(-153.26497814579386,362.6780434158956)],[new Point(588.4106157414747,-343.91180848474517),new Point(-10.300000000000068,-66.40418792346955),new Point(-153.26497814579386,362.6780434158956),new Point(-213.94893036447175,389.9986950947747)],[new Point(588.4106157414747,-343.91180848474517),new Point(-10.300000000000068,-66.40418792346955),new Point(-223.05106963552825,212.0013049052253)],[new Point(588.4106157414747,-343.91180848474517),new Point(-190.49613893835684,-350.86824314212447)],[new Point(588.4106157414747,-343.91180848474517),new Point(-107,-207)],[new Point(588.4106157414747,-343.91180848474517),new Point(-107,-207),new Point(-296.99632055783536,-193.9142950057776)],[new Point(588.4106157414747,-343.91180848474517),new Point(721,-565.4922678357856),new Point(973,-420)],[new Point(588.4106157414747,-343.91180848474517),new Point(721,-565.4922678357856),new Point(973,-420),new Point(721,-274.5077321642143)],[new Point(588.4106157414747,-343.91180848474517),new Point(721,-565.4922678357856)],[new Point(588.4106157414747,-343.91180848474517),new Point(-10.300000000000068,-66.40418792346955),new Point(-143.5,650)],[new Point(588.4106157414747,-343.91180848474517),new Point(-10.300000000000068,-66.40418792346955),new Point(-190.75,622.7201997807902),new Point(-190.75,677.2798002192098)],[new Point(588.4106157414747,-343.91180848474517),new Point(-10.300000000000068,-66.40418792346955),new Point(-190.75,622.7201997807902)],[new Point(588.4106157414747,-343.91180848474517),new Point(-10.300000000000068,-66.40418792346955),new Point(-10.29999999999994,246.4041879234696),new Point(161,542)],[new Point(588.4106157414747,-343.91180848474517),new Point(-10.300000000000068,-66.40418792346955),new Point(-10.29999999999994,246.4041879234696),new Point(129.5,560.1865334794732)],[new Point(588.4106157414747,-343.91180848474517),new Point(-10.300000000000068,-66.40418792346955),new Point(-10.29999999999994,246.4041879234696),new Point(129.5,523.8134665205268)],[new Point(588.4106157414747,-343.91180848474517),new Point(721,-565.4922678357856),new Point(973,-420),new Point(728.25,-8.652867178156207),new Point(647,320)],[new Point(588.4106157414747,-343.91180848474517),new Point(-10.300000000000068,-66.40418792346955),new Point(260.59999999999997,90),new Point(584,356.3730669589464)],[new Point(588.4106157414747,-343.91180848474517),new Point(-10.300000000000068,-66.40418792346955),new Point(584,283.6269330410536)],[new Point(588.4106157414747,-343.91180848474517),new Point(721,-565.4922678357856),new Point(973,-420),new Point(838.5,55)],[new Point(588.4106157414747,-343.91180848474517),new Point(721,-565.4922678357856),new Point(973,-420),new Point(728.25,-8.652867178156207),new Point(728.25,118.65286717815624)],[new Point(588.4106157414747,-343.91180848474517),new Point(721,-565.4922678357856),new Point(973,-420),new Point(728.25,-8.652867178156207)],[new Point(588.4106157414747,-343.91180848474517),new Point(-10.300000000000068,-66.40418792346955),new Point(260.59999999999997,90)],[new Point(588.4106157414747,-343.91180848474517),new Point(-10.300000000000068,-66.40418792346955),new Point(-10.29999999999994,246.4041879234696)],[new Point(588.4106157414747,-343.91180848474517),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294),new Point(271,-479)],[new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294),new Point(360.0604335563131,-529.0018277777501)],[new Point(519.5893842585253,-191.08819151525486),new Point(1055,664)],[new Point(519.5893842585253,-191.08819151525486),new Point(784,674)],[new Point(519.5893842585253,-191.08819151525486),new Point(417,656)],[new Point(519.5893842585253,-191.08819151525486),new Point(203,759)],[new Point(519.5893842585253,-191.08819151525486),new Point(56,674)],[new Point(519.5893842585253,-191.08819151525486),new Point(-289.3991018391502,729.2006744090877)],[new Point(519.5893842585253,-191.08819151525486),new Point(-381.4843460976219,649.1432030269882)],[new Point(519.5893842585253,-191.08819151525486),new Point(-89.03523617876226,-499.7368825942079)],[new Point(519.5893842585253,-191.08819151525486),new Point(-89.03523617876226,-530.2631174057921),new Point(-200.96476382123774,-530.2631174057921)],[new Point(519.5893842585253,-191.08819151525486),new Point(-200.96476382123774,-499.7368825942079)],[new Point(519.5893842585253,-191.08819151525486),new Point(-89.03523617876226,-530.2631174057921)],[new Point(519.5893842585253,-191.08819151525486),new Point(1004.696796342723,-29.047074219986737)],[new Point(519.5893842585253,-191.08819151525486),new Point(1040.303203657277,-140.95292578001326)],[new Point(519.5893842585253,-191.08819151525486),new Point(728.25,-8.652867178156207),new Point(1040.303203657277,-29.047074219986737)],[new Point(519.5893842585253,-191.08819151525486),new Point(1004.696796342723,-140.95292578001326)],[new Point(519.5893842585253,-191.08819151525486),new Point(838.5,55),new Point(1004.7206704591699,249.0398047033964)],[new Point(519.5893842585253,-191.08819151525486),new Point(728.25,118.65286717815624),new Point(1004.7206704591699,360.96019529660356),new Point(1037.27932954083,360.96019529660356)],[new Point(519.5893842585253,-191.08819151525486),new Point(728.25,118.65286717815624),new Point(1004.7206704591699,360.96019529660356)],[new Point(519.5893842585253,-191.08819151525486),new Point(838.5,55),new Point(1037.27932954083,249.0398047033964)],[new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294)],[new Point(519.5893842585253,-191.08819151525486),new Point(721,-274.5077321642143),new Point(973,-420),new Point(721,-565.4922678357856),new Point(588.4106157414747,-343.91180848474517)],[new Point(519.5893842585253,-191.08819151525486)],[new Point(519.5893842585253,-191.08819151525486),new Point(-10.300000000000068,-66.40418792346955),new Point(-283.73502185420614,242.3219565841044)],[new Point(519.5893842585253,-191.08819151525486),new Point(260.59999999999997,90),new Point(-153.26497814579386,362.6780434158956)],[new Point(519.5893842585253,-191.08819151525486),new Point(260.59999999999997,90),new Point(-153.26497814579386,362.6780434158956),new Point(-213.94893036447175,389.9986950947747)],[new Point(519.5893842585253,-191.08819151525486),new Point(-10.300000000000068,-66.40418792346955),new Point(-223.05106963552825,212.0013049052253)],[new Point(519.5893842585253,-191.08819151525486),new Point(-190.49613893835684,-350.86824314212447)],[new Point(519.5893842585253,-191.08819151525486),new Point(-107,-207)],[new Point(519.5893842585253,-191.08819151525486),new Point(-296.99632055783536,-193.9142950057776)],[new Point(519.5893842585253,-191.08819151525486),new Point(721,-274.5077321642143),new Point(973,-420)],[new Point(519.5893842585253,-191.08819151525486),new Point(721,-274.5077321642143)],[new Point(519.5893842585253,-191.08819151525486),new Point(721,-274.5077321642143),new Point(973,-420),new Point(721,-565.4922678357856)],[new Point(519.5893842585253,-191.08819151525486),new Point(-143.5,650)],[new Point(519.5893842585253,-191.08819151525486),new Point(-143.5,650),new Point(-190.75,677.2798002192098)],[new Point(519.5893842585253,-191.08819151525486),new Point(-190.75,622.7201997807902)],[new Point(519.5893842585253,-191.08819151525486),new Point(161,542)],[new Point(519.5893842585253,-191.08819151525486),new Point(129.5,523.8134665205268),new Point(129.5,560.1865334794732)],[new Point(519.5893842585253,-191.08819151525486),new Point(129.5,523.8134665205268)],[new Point(519.5893842585253,-191.08819151525486),new Point(647,320)],[new Point(519.5893842585253,-191.08819151525486),new Point(584,356.3730669589464)],[new Point(519.5893842585253,-191.08819151525486),new Point(584,283.6269330410536)],[new Point(519.5893842585253,-191.08819151525486),new Point(838.5,55)],[new Point(519.5893842585253,-191.08819151525486),new Point(728.25,118.65286717815624)],[new Point(519.5893842585253,-191.08819151525486),new Point(728.25,-8.652867178156207)],[new Point(519.5893842585253,-191.08819151525486),new Point(260.59999999999997,90)],[new Point(519.5893842585253,-191.08819151525486),new Point(260.59999999999997,90),new Point(-10.29999999999994,246.4041879234696)],[new Point(519.5893842585253,-191.08819151525486),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(-283.73502185420614,242.3219565841044),new Point(271,-479)],[new Point(-283.73502185420614,242.3219565841044),new Point(360.0604335563131,-529.0018277777501)],[new Point(-283.73502185420614,242.3219565841044),new Point(-223.05106963552825,212.0013049052253),new Point(1055,664)],[new Point(-283.73502185420614,242.3219565841044),new Point(-223.05106963552825,212.0013049052253),new Point(784,674)],[new Point(-283.73502185420614,242.3219565841044),new Point(-223.05106963552825,212.0013049052253),new Point(417,656)],[new Point(-283.73502185420614,242.3219565841044),new Point(-213.94893036447175,389.9986950947747),new Point(203,759)],[new Point(-283.73502185420614,242.3219565841044),new Point(-213.94893036447175,389.9986950947747),new Point(56,674)],[new Point(-283.73502185420614,242.3219565841044),new Point(-289.3991018391502,729.2006744090877)],[new Point(-283.73502185420614,242.3219565841044),new Point(-381.4843460976219,649.1432030269882)],[new Point(-283.73502185420614,242.3219565841044),new Point(-107,-207),new Point(-89.03523617876226,-499.7368825942079)],[new Point(-283.73502185420614,242.3219565841044),new Point(-296.99632055783536,-193.9142950057776),new Point(-200.96476382123774,-530.2631174057921)],[new Point(-283.73502185420614,242.3219565841044),new Point(-296.99632055783536,-193.9142950057776),new Point(-200.96476382123774,-499.7368825942079)],[new Point(-283.73502185420614,242.3219565841044),new Point(-10.300000000000068,-66.40418792346955),new Point(-89.03523617876226,-530.2631174057921)],[new Point(-283.73502185420614,242.3219565841044),new Point(-223.05106963552825,212.0013049052253),new Point(728.25,118.65286717815624),new Point(1004.696796342723,-29.047074219986737)],[new Point(-283.73502185420614,242.3219565841044),new Point(-223.05106963552825,212.0013049052253),new Point(-10.29999999999994,246.4041879234696),new Point(1004.696796342723,-140.95292578001326),new Point(1040.303203657277,-140.95292578001326)],[new Point(-283.73502185420614,242.3219565841044),new Point(-223.05106963552825,212.0013049052253),new Point(728.25,118.65286717815624),new Point(1040.303203657277,-29.047074219986737)],[new Point(-283.73502185420614,242.3219565841044),new Point(-223.05106963552825,212.0013049052253),new Point(-10.29999999999994,246.4041879234696),new Point(1004.696796342723,-140.95292578001326)],[new Point(-283.73502185420614,242.3219565841044),new Point(-223.05106963552825,212.0013049052253),new Point(1004.7206704591699,249.0398047033964)],[new Point(-283.73502185420614,242.3219565841044),new Point(-223.05106963552825,212.0013049052253),new Point(584,283.6269330410536),new Point(1004.7206704591699,360.96019529660356),new Point(1037.27932954083,360.96019529660356)],[new Point(-283.73502185420614,242.3219565841044),new Point(-223.05106963552825,212.0013049052253),new Point(584,283.6269330410536),new Point(1004.7206704591699,360.96019529660356)],[new Point(-283.73502185420614,242.3219565841044),new Point(-223.05106963552825,212.0013049052253),new Point(1037.27932954083,249.0398047033964)],[new Point(-283.73502185420614,242.3219565841044),new Point(-10.300000000000068,-66.40418792346955),new Point(471.13992102513606,-235.48983908715294)],[new Point(-283.73502185420614,242.3219565841044),new Point(-10.300000000000068,-66.40418792346955),new Point(588.4106157414747,-343.91180848474517)],[new Point(-283.73502185420614,242.3219565841044),new Point(-10.300000000000068,-66.40418792346955),new Point(519.5893842585253,-191.08819151525486)],[new Point(-283.73502185420614,242.3219565841044)],[new Point(-283.73502185420614,242.3219565841044),new Point(-213.94893036447175,389.9986950947747),new Point(-153.26497814579386,362.6780434158956)],[new Point(-283.73502185420614,242.3219565841044),new Point(-213.94893036447175,389.9986950947747)],[new Point(-283.73502185420614,242.3219565841044),new Point(-223.05106963552825,212.0013049052253)],[new Point(-283.73502185420614,242.3219565841044),new Point(-296.99632055783536,-193.9142950057776),new Point(-190.49613893835684,-350.86824314212447)],[new Point(-283.73502185420614,242.3219565841044),new Point(-107,-207)],[new Point(-283.73502185420614,242.3219565841044),new Point(-296.99632055783536,-193.9142950057776)],[new Point(-283.73502185420614,242.3219565841044),new Point(-223.05106963552825,212.0013049052253),new Point(-10.29999999999994,246.4041879234696),new Point(260.59999999999997,90),new Point(973,-420)],[new Point(-283.73502185420614,242.3219565841044),new Point(-223.05106963552825,212.0013049052253),new Point(-10.29999999999994,246.4041879234696),new Point(260.59999999999997,90),new Point(721,-274.5077321642143)],[new Point(-283.73502185420614,242.3219565841044),new Point(721,-565.4922678357856)],[new Point(-283.73502185420614,242.3219565841044),new Point(-143.5,650)],[new Point(-283.73502185420614,242.3219565841044),new Point(-190.75,677.2798002192098)],[new Point(-283.73502185420614,242.3219565841044),new Point(-190.75,622.7201997807902)],[new Point(-283.73502185420614,242.3219565841044),new Point(-213.94893036447175,389.9986950947747),new Point(129.5,523.8134665205268),new Point(161,542)],[new Point(-283.73502185420614,242.3219565841044),new Point(-213.94893036447175,389.9986950947747),new Point(129.5,560.1865334794732)],[new Point(-283.73502185420614,242.3219565841044),new Point(-213.94893036447175,389.9986950947747),new Point(129.5,523.8134665205268)],[new Point(-283.73502185420614,242.3219565841044),new Point(-223.05106963552825,212.0013049052253),new Point(584,283.6269330410536),new Point(647,320)],[new Point(-283.73502185420614,242.3219565841044),new Point(-223.05106963552825,212.0013049052253),new Point(584,356.3730669589464)],[new Point(-283.73502185420614,242.3219565841044),new Point(-223.05106963552825,212.0013049052253),new Point(584,283.6269330410536)],[new Point(-283.73502185420614,242.3219565841044),new Point(-223.05106963552825,212.0013049052253),new Point(728.25,118.65286717815624),new Point(838.5,55)],[new Point(-283.73502185420614,242.3219565841044),new Point(-223.05106963552825,212.0013049052253),new Point(728.25,118.65286717815624)],[new Point(-283.73502185420614,242.3219565841044),new Point(-223.05106963552825,212.0013049052253),new Point(-10.29999999999994,246.4041879234696),new Point(728.25,-8.652867178156207)],[new Point(-283.73502185420614,242.3219565841044),new Point(-223.05106963552825,212.0013049052253),new Point(-10.29999999999994,246.4041879234696),new Point(260.59999999999997,90)],[new Point(-283.73502185420614,242.3219565841044),new Point(-223.05106963552825,212.0013049052253),new Point(-10.29999999999994,246.4041879234696)],[new Point(-283.73502185420614,242.3219565841044),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(-153.26497814579386,362.6780434158956),new Point(-10.300000000000068,-66.40418792346955),new Point(271,-479)],[new Point(-153.26497814579386,362.6780434158956),new Point(-10.300000000000068,-66.40418792346955),new Point(360.0604335563131,-529.0018277777501)],[new Point(-153.26497814579386,362.6780434158956),new Point(1055,664)],[new Point(-153.26497814579386,362.6780434158956),new Point(784,674)],[new Point(-153.26497814579386,362.6780434158956),new Point(417,656)],[new Point(-153.26497814579386,362.6780434158956),new Point(203,759)],[new Point(-153.26497814579386,362.6780434158956),new Point(56,674)],[new Point(-153.26497814579386,362.6780434158956),new Point(-289.3991018391502,729.2006744090877)],[new Point(-153.26497814579386,362.6780434158956),new Point(-381.4843460976219,649.1432030269882)],[new Point(-153.26497814579386,362.6780434158956),new Point(-107,-207),new Point(-89.03523617876226,-499.7368825942079)],[new Point(-153.26497814579386,362.6780434158956),new Point(-107,-207),new Point(-200.96476382123774,-499.7368825942079),new Point(-200.96476382123774,-530.2631174057921)],[new Point(-153.26497814579386,362.6780434158956),new Point(-107,-207),new Point(-200.96476382123774,-499.7368825942079)],[new Point(-153.26497814579386,362.6780434158956),new Point(-10.300000000000068,-66.40418792346955),new Point(-89.03523617876226,-530.2631174057921)],[new Point(-153.26497814579386,362.6780434158956),new Point(728.25,118.65286717815624),new Point(1004.696796342723,-29.047074219986737)],[new Point(-153.26497814579386,362.6780434158956),new Point(1004.696796342723,-140.95292578001326),new Point(1040.303203657277,-140.95292578001326)],[new Point(-153.26497814579386,362.6780434158956),new Point(728.25,118.65286717815624),new Point(1040.303203657277,-29.047074219986737)],[new Point(-153.26497814579386,362.6780434158956),new Point(1004.696796342723,-140.95292578001326)],[new Point(-153.26497814579386,362.6780434158956),new Point(1004.7206704591699,249.0398047033964)],[new Point(-153.26497814579386,362.6780434158956),new Point(1037.27932954083,360.96019529660356)],[new Point(-153.26497814579386,362.6780434158956),new Point(1004.7206704591699,360.96019529660356)],[new Point(-153.26497814579386,362.6780434158956),new Point(-10.29999999999994,246.4041879234696),new Point(1037.27932954083,249.0398047033964)],[new Point(-153.26497814579386,362.6780434158956),new Point(260.59999999999997,90),new Point(471.13992102513606,-235.48983908715294)],[new Point(-153.26497814579386,362.6780434158956),new Point(-10.300000000000068,-66.40418792346955),new Point(588.4106157414747,-343.91180848474517)],[new Point(-153.26497814579386,362.6780434158956),new Point(260.59999999999997,90),new Point(519.5893842585253,-191.08819151525486)],[new Point(-153.26497814579386,362.6780434158956),new Point(-213.94893036447175,389.9986950947747),new Point(-283.73502185420614,242.3219565841044)],[new Point(-153.26497814579386,362.6780434158956)],[new Point(-153.26497814579386,362.6780434158956),new Point(-213.94893036447175,389.9986950947747)],[new Point(-153.26497814579386,362.6780434158956),new Point(-223.05106963552825,212.0013049052253)],[new Point(-153.26497814579386,362.6780434158956),new Point(-107,-207),new Point(-190.49613893835684,-350.86824314212447)],[new Point(-153.26497814579386,362.6780434158956),new Point(-107,-207)],[new Point(-153.26497814579386,362.6780434158956),new Point(-296.99632055783536,-193.9142950057776)],[new Point(-153.26497814579386,362.6780434158956),new Point(973,-420)],[new Point(-153.26497814579386,362.6780434158956),new Point(260.59999999999997,90),new Point(721,-274.5077321642143)],[new Point(-153.26497814579386,362.6780434158956),new Point(-10.300000000000068,-66.40418792346955),new Point(721,-565.4922678357856)],[new Point(-153.26497814579386,362.6780434158956),new Point(-143.5,650)],[new Point(-153.26497814579386,362.6780434158956),new Point(-190.75,622.7201997807902),new Point(-190.75,677.2798002192098)],[new Point(-153.26497814579386,362.6780434158956),new Point(-190.75,622.7201997807902)],[new Point(-153.26497814579386,362.6780434158956),new Point(161,542)],[new Point(-153.26497814579386,362.6780434158956),new Point(129.5,560.1865334794732)],[new Point(-153.26497814579386,362.6780434158956),new Point(129.5,523.8134665205268)],[new Point(-153.26497814579386,362.6780434158956),new Point(584,356.3730669589464),new Point(647,320)],[new Point(-153.26497814579386,362.6780434158956),new Point(584,356.3730669589464)],[new Point(-153.26497814579386,362.6780434158956),new Point(584,283.6269330410536)],[new Point(-153.26497814579386,362.6780434158956),new Point(728.25,118.65286717815624),new Point(838.5,55)],[new Point(-153.26497814579386,362.6780434158956),new Point(728.25,118.65286717815624)],[new Point(-153.26497814579386,362.6780434158956),new Point(728.25,-8.652867178156207)],[new Point(-153.26497814579386,362.6780434158956),new Point(260.59999999999997,90)],[new Point(-153.26497814579386,362.6780434158956),new Point(-10.29999999999994,246.4041879234696)],[new Point(-153.26497814579386,362.6780434158956),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(-213.94893036447175,389.9986950947747),new Point(-153.26497814579386,362.6780434158956),new Point(-10.300000000000068,-66.40418792346955),new Point(271,-479)],[new Point(-213.94893036447175,389.9986950947747),new Point(-153.26497814579386,362.6780434158956),new Point(-10.300000000000068,-66.40418792346955),new Point(360.0604335563131,-529.0018277777501)],[new Point(-213.94893036447175,389.9986950947747),new Point(1055,664)],[new Point(-213.94893036447175,389.9986950947747),new Point(784,674)],[new Point(-213.94893036447175,389.9986950947747),new Point(129.5,523.8134665205268),new Point(417,656)],[new Point(-213.94893036447175,389.9986950947747),new Point(203,759)],[new Point(-213.94893036447175,389.9986950947747),new Point(56,674)],[new Point(-213.94893036447175,389.9986950947747),new Point(-289.3991018391502,729.2006744090877)],[new Point(-213.94893036447175,389.9986950947747),new Point(-381.4843460976219,649.1432030269882)],[new Point(-213.94893036447175,389.9986950947747),new Point(-153.26497814579386,362.6780434158956),new Point(-107,-207),new Point(-89.03523617876226,-499.7368825942079)],[new Point(-213.94893036447175,389.9986950947747),new Point(-283.73502185420614,242.3219565841044),new Point(-296.99632055783536,-193.9142950057776),new Point(-200.96476382123774,-530.2631174057921)],[new Point(-213.94893036447175,389.9986950947747),new Point(-283.73502185420614,242.3219565841044),new Point(-296.99632055783536,-193.9142950057776),new Point(-200.96476382123774,-499.7368825942079)],[new Point(-213.94893036447175,389.9986950947747),new Point(-153.26497814579386,362.6780434158956),new Point(-10.300000000000068,-66.40418792346955),new Point(-89.03523617876226,-530.2631174057921)],[new Point(-213.94893036447175,389.9986950947747),new Point(728.25,118.65286717815624),new Point(1004.696796342723,-29.047074219986737)],[new Point(-213.94893036447175,389.9986950947747),new Point(1004.696796342723,-140.95292578001326),new Point(1040.303203657277,-140.95292578001326)],[new Point(-213.94893036447175,389.9986950947747),new Point(728.25,118.65286717815624),new Point(1040.303203657277,-29.047074219986737)],[new Point(-213.94893036447175,389.9986950947747),new Point(1004.696796342723,-140.95292578001326)],[new Point(-213.94893036447175,389.9986950947747),new Point(1004.7206704591699,249.0398047033964)],[new Point(-213.94893036447175,389.9986950947747),new Point(1037.27932954083,360.96019529660356)],[new Point(-213.94893036447175,389.9986950947747),new Point(1004.7206704591699,360.96019529660356)],[new Point(-213.94893036447175,389.9986950947747),new Point(-153.26497814579386,362.6780434158956),new Point(-10.29999999999994,246.4041879234696),new Point(1037.27932954083,249.0398047033964)],[new Point(-213.94893036447175,389.9986950947747),new Point(-153.26497814579386,362.6780434158956),new Point(260.59999999999997,90),new Point(471.13992102513606,-235.48983908715294)],[new Point(-213.94893036447175,389.9986950947747),new Point(-153.26497814579386,362.6780434158956),new Point(-10.300000000000068,-66.40418792346955),new Point(588.4106157414747,-343.91180848474517)],[new Point(-213.94893036447175,389.9986950947747),new Point(-153.26497814579386,362.6780434158956),new Point(260.59999999999997,90),new Point(519.5893842585253,-191.08819151525486)],[new Point(-213.94893036447175,389.9986950947747),new Point(-283.73502185420614,242.3219565841044)],[new Point(-213.94893036447175,389.9986950947747),new Point(-153.26497814579386,362.6780434158956)],[new Point(-213.94893036447175,389.9986950947747)],[new Point(-213.94893036447175,389.9986950947747),new Point(129.5,523.8134665205268),new Point(-223.05106963552825,212.0013049052253)],[new Point(-213.94893036447175,389.9986950947747),new Point(-190.75,622.7201997807902),new Point(-10.29999999999994,246.4041879234696),new Point(-107,-207),new Point(-190.49613893835684,-350.86824314212447)],[new Point(-213.94893036447175,389.9986950947747),new Point(-190.75,622.7201997807902),new Point(-10.29999999999994,246.4041879234696),new Point(-107,-207)],[new Point(-213.94893036447175,389.9986950947747),new Point(-190.75,622.7201997807902),new Point(-10.29999999999994,246.4041879234696),new Point(-296.99632055783536,-193.9142950057776)],[new Point(-213.94893036447175,389.9986950947747),new Point(728.25,-8.652867178156207),new Point(973,-420)],[new Point(-213.94893036447175,389.9986950947747),new Point(728.25,-8.652867178156207),new Point(721,-274.5077321642143)],[new Point(-213.94893036447175,389.9986950947747),new Point(-190.75,622.7201997807902),new Point(721,-565.4922678357856)],[new Point(-213.94893036447175,389.9986950947747),new Point(-143.5,650)],[new Point(-213.94893036447175,389.9986950947747),new Point(-190.75,677.2798002192098)],[new Point(-213.94893036447175,389.9986950947747),new Point(-190.75,622.7201997807902)],[new Point(-213.94893036447175,389.9986950947747),new Point(129.5,523.8134665205268),new Point(161,542)],[new Point(-213.94893036447175,389.9986950947747),new Point(129.5,560.1865334794732)],[new Point(-213.94893036447175,389.9986950947747),new Point(129.5,523.8134665205268)],[new Point(-213.94893036447175,389.9986950947747),new Point(584,356.3730669589464),new Point(647,320)],[new Point(-213.94893036447175,389.9986950947747),new Point(584,356.3730669589464)],[new Point(-213.94893036447175,389.9986950947747),new Point(584,283.6269330410536)],[new Point(-213.94893036447175,389.9986950947747),new Point(728.25,118.65286717815624),new Point(838.5,55)],[new Point(-213.94893036447175,389.9986950947747),new Point(728.25,118.65286717815624)],[new Point(-213.94893036447175,389.9986950947747),new Point(728.25,-8.652867178156207)],[new Point(-213.94893036447175,389.9986950947747),new Point(129.5,523.8134665205268),new Point(260.59999999999997,90)],[new Point(-213.94893036447175,389.9986950947747),new Point(-190.75,622.7201997807902),new Point(-10.29999999999994,246.4041879234696)],[new Point(-213.94893036447175,389.9986950947747),new Point(-190.75,622.7201997807902),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(-223.05106963552825,212.0013049052253),new Point(271,-479)],[new Point(-223.05106963552825,212.0013049052253),new Point(360.0604335563131,-529.0018277777501)],[new Point(-223.05106963552825,212.0013049052253),new Point(1055,664)],[new Point(-223.05106963552825,212.0013049052253),new Point(784,674)],[new Point(-223.05106963552825,212.0013049052253),new Point(417,656)],[new Point(-223.05106963552825,212.0013049052253),new Point(203,759)],[new Point(-223.05106963552825,212.0013049052253),new Point(56,674)],[new Point(-223.05106963552825,212.0013049052253),new Point(-283.73502185420614,242.3219565841044),new Point(-289.3991018391502,729.2006744090877)],[new Point(-223.05106963552825,212.0013049052253),new Point(-283.73502185420614,242.3219565841044),new Point(-381.4843460976219,649.1432030269882)],[new Point(-223.05106963552825,212.0013049052253),new Point(-107,-207),new Point(-89.03523617876226,-499.7368825942079)],[new Point(-223.05106963552825,212.0013049052253),new Point(-296.99632055783536,-193.9142950057776),new Point(-200.96476382123774,-530.2631174057921)],[new Point(-223.05106963552825,212.0013049052253),new Point(-296.99632055783536,-193.9142950057776),new Point(-200.96476382123774,-499.7368825942079)],[new Point(-223.05106963552825,212.0013049052253),new Point(-10.300000000000068,-66.40418792346955),new Point(-89.03523617876226,-530.2631174057921)],[new Point(-223.05106963552825,212.0013049052253),new Point(728.25,118.65286717815624),new Point(1004.696796342723,-29.047074219986737)],[new Point(-223.05106963552825,212.0013049052253),new Point(-10.29999999999994,246.4041879234696),new Point(1004.696796342723,-140.95292578001326),new Point(1040.303203657277,-140.95292578001326)],[new Point(-223.05106963552825,212.0013049052253),new Point(728.25,118.65286717815624),new Point(1040.303203657277,-29.047074219986737)],[new Point(-223.05106963552825,212.0013049052253),new Point(-10.29999999999994,246.4041879234696),new Point(1004.696796342723,-140.95292578001326)],[new Point(-223.05106963552825,212.0013049052253),new Point(1004.7206704591699,249.0398047033964)],[new Point(-223.05106963552825,212.0013049052253),new Point(584,283.6269330410536),new Point(1004.7206704591699,360.96019529660356),new Point(1037.27932954083,360.96019529660356)],[new Point(-223.05106963552825,212.0013049052253),new Point(584,283.6269330410536),new Point(1004.7206704591699,360.96019529660356)],[new Point(-223.05106963552825,212.0013049052253),new Point(1037.27932954083,249.0398047033964)],[new Point(-223.05106963552825,212.0013049052253),new Point(-10.300000000000068,-66.40418792346955),new Point(471.13992102513606,-235.48983908715294)],[new Point(-223.05106963552825,212.0013049052253),new Point(-10.300000000000068,-66.40418792346955),new Point(588.4106157414747,-343.91180848474517)],[new Point(-223.05106963552825,212.0013049052253),new Point(-10.300000000000068,-66.40418792346955),new Point(519.5893842585253,-191.08819151525486)],[new Point(-223.05106963552825,212.0013049052253),new Point(-283.73502185420614,242.3219565841044)],[new Point(-223.05106963552825,212.0013049052253),new Point(-153.26497814579386,362.6780434158956)],[new Point(-223.05106963552825,212.0013049052253),new Point(129.5,523.8134665205268),new Point(-213.94893036447175,389.9986950947747)],[new Point(-223.05106963552825,212.0013049052253)],[new Point(-223.05106963552825,212.0013049052253),new Point(-107,-207),new Point(-190.49613893835684,-350.86824314212447)],[new Point(-223.05106963552825,212.0013049052253),new Point(-107,-207)],[new Point(-223.05106963552825,212.0013049052253),new Point(-296.99632055783536,-193.9142950057776)],[new Point(-223.05106963552825,212.0013049052253),new Point(-10.29999999999994,246.4041879234696),new Point(260.59999999999997,90),new Point(973,-420)],[new Point(-223.05106963552825,212.0013049052253),new Point(-10.29999999999994,246.4041879234696),new Point(260.59999999999997,90),new Point(721,-274.5077321642143)],[new Point(-223.05106963552825,212.0013049052253),new Point(721,-565.4922678357856)],[new Point(-223.05106963552825,212.0013049052253),new Point(-10.29999999999994,246.4041879234696),new Point(-143.5,650)],[new Point(-223.05106963552825,212.0013049052253),new Point(-10.29999999999994,246.4041879234696),new Point(-190.75,622.7201997807902),new Point(-190.75,677.2798002192098)],[new Point(-223.05106963552825,212.0013049052253),new Point(-10.29999999999994,246.4041879234696),new Point(-190.75,622.7201997807902)],[new Point(-223.05106963552825,212.0013049052253),new Point(161,542)],[new Point(-223.05106963552825,212.0013049052253),new Point(129.5,560.1865334794732)],[new Point(-223.05106963552825,212.0013049052253),new Point(129.5,523.8134665205268)],[new Point(-223.05106963552825,212.0013049052253),new Point(584,283.6269330410536),new Point(647,320)],[new Point(-223.05106963552825,212.0013049052253),new Point(584,356.3730669589464)],[new Point(-223.05106963552825,212.0013049052253),new Point(584,283.6269330410536)],[new Point(-223.05106963552825,212.0013049052253),new Point(728.25,118.65286717815624),new Point(838.5,55)],[new Point(-223.05106963552825,212.0013049052253),new Point(728.25,118.65286717815624)],[new Point(-223.05106963552825,212.0013049052253),new Point(-10.29999999999994,246.4041879234696),new Point(728.25,-8.652867178156207)],[new Point(-223.05106963552825,212.0013049052253),new Point(-10.29999999999994,246.4041879234696),new Point(260.59999999999997,90)],[new Point(-223.05106963552825,212.0013049052253),new Point(-10.29999999999994,246.4041879234696)],[new Point(-223.05106963552825,212.0013049052253),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(-190.49613893835684,-350.86824314212447),new Point(271,-479)],[new Point(-190.49613893835684,-350.86824314212447),new Point(-107,-207),new Point(360.0604335563131,-529.0018277777501)],[new Point(-190.49613893835684,-350.86824314212447),new Point(647,320),new Point(1055,664)],[new Point(-190.49613893835684,-350.86824314212447),new Point(784,674)],[new Point(-190.49613893835684,-350.86824314212447),new Point(260.59999999999997,90),new Point(417,656)],[new Point(-190.49613893835684,-350.86824314212447),new Point(-107,-207),new Point(129.5,560.1865334794732),new Point(203,759)],[new Point(-190.49613893835684,-350.86824314212447),new Point(-107,-207),new Point(56,674)],[new Point(-190.49613893835684,-350.86824314212447),new Point(-296.99632055783536,-193.9142950057776),new Point(-289.3991018391502,729.2006744090877)],[new Point(-190.49613893835684,-350.86824314212447),new Point(-296.99632055783536,-193.9142950057776),new Point(-381.4843460976219,649.1432030269882)],[new Point(-190.49613893835684,-350.86824314212447),new Point(-89.03523617876226,-499.7368825942079)],[new Point(-190.49613893835684,-350.86824314212447),new Point(-200.96476382123774,-499.7368825942079),new Point(-200.96476382123774,-530.2631174057921)],[new Point(-190.49613893835684,-350.86824314212447),new Point(-200.96476382123774,-499.7368825942079)],[new Point(-190.49613893835684,-350.86824314212447),new Point(-10.300000000000068,-66.40418792346955),new Point(-89.03523617876226,-530.2631174057921)],[new Point(-190.49613893835684,-350.86824314212447),new Point(1004.696796342723,-29.047074219986737)],[new Point(-190.49613893835684,-350.86824314212447),new Point(519.5893842585253,-191.08819151525486),new Point(1040.303203657277,-140.95292578001326)],[new Point(-190.49613893835684,-350.86824314212447),new Point(728.25,-8.652867178156207),new Point(1040.303203657277,-29.047074219986737)],[new Point(-190.49613893835684,-350.86824314212447),new Point(519.5893842585253,-191.08819151525486),new Point(1004.696796342723,-140.95292578001326)],[new Point(-190.49613893835684,-350.86824314212447),new Point(1004.7206704591699,249.0398047033964)],[new Point(-190.49613893835684,-350.86824314212447),new Point(1004.7206704591699,360.96019529660356),new Point(1037.27932954083,360.96019529660356)],[new Point(-190.49613893835684,-350.86824314212447),new Point(1004.7206704591699,360.96019529660356)],[new Point(-190.49613893835684,-350.86824314212447),new Point(1037.27932954083,249.0398047033964)],[new Point(-190.49613893835684,-350.86824314212447),new Point(471.13992102513606,-235.48983908715294)],[new Point(-190.49613893835684,-350.86824314212447),new Point(588.4106157414747,-343.91180848474517)],[new Point(-190.49613893835684,-350.86824314212447),new Point(519.5893842585253,-191.08819151525486)],[new Point(-190.49613893835684,-350.86824314212447),new Point(-296.99632055783536,-193.9142950057776),new Point(-283.73502185420614,242.3219565841044)],[new Point(-190.49613893835684,-350.86824314212447),new Point(-107,-207),new Point(-153.26497814579386,362.6780434158956)],[new Point(-190.49613893835684,-350.86824314212447),new Point(-107,-207),new Point(-10.29999999999994,246.4041879234696),new Point(-190.75,622.7201997807902),new Point(-213.94893036447175,389.9986950947747)],[new Point(-190.49613893835684,-350.86824314212447),new Point(-107,-207),new Point(-223.05106963552825,212.0013049052253)],[new Point(-190.49613893835684,-350.86824314212447)],[new Point(-190.49613893835684,-350.86824314212447),new Point(-107,-207)],[new Point(-190.49613893835684,-350.86824314212447),new Point(-296.99632055783536,-193.9142950057776)],[new Point(-190.49613893835684,-350.86824314212447),new Point(721,-565.4922678357856),new Point(973,-420)],[new Point(-190.49613893835684,-350.86824314212447),new Point(260.59999999999997,90),new Point(721,-274.5077321642143)],[new Point(-190.49613893835684,-350.86824314212447),new Point(721,-565.4922678357856)],[new Point(-190.49613893835684,-350.86824314212447),new Point(-107,-207),new Point(-143.5,650)],[new Point(-190.49613893835684,-350.86824314212447),new Point(-107,-207),new Point(-143.5,650),new Point(-190.75,677.2798002192098)],[new Point(-190.49613893835684,-350.86824314212447),new Point(-107,-207),new Point(-10.29999999999994,246.4041879234696),new Point(-190.75,622.7201997807902)],[new Point(-190.49613893835684,-350.86824314212447),new Point(-107,-207),new Point(129.5,523.8134665205268),new Point(161,542)],[new Point(-190.49613893835684,-350.86824314212447),new Point(-107,-207),new Point(129.5,560.1865334794732)],[new Point(-190.49613893835684,-350.86824314212447),new Point(-107,-207),new Point(129.5,523.8134665205268)],[new Point(-190.49613893835684,-350.86824314212447),new Point(647,320)],[new Point(-190.49613893835684,-350.86824314212447),new Point(584,356.3730669589464)],[new Point(-190.49613893835684,-350.86824314212447),new Point(584,283.6269330410536)],[new Point(-190.49613893835684,-350.86824314212447),new Point(728.25,-8.652867178156207),new Point(838.5,55)],[new Point(-190.49613893835684,-350.86824314212447),new Point(728.25,118.65286717815624)],[new Point(-190.49613893835684,-350.86824314212447),new Point(728.25,-8.652867178156207)],[new Point(-190.49613893835684,-350.86824314212447),new Point(260.59999999999997,90)],[new Point(-190.49613893835684,-350.86824314212447),new Point(-107,-207),new Point(-10.29999999999994,246.4041879234696)],[new Point(-190.49613893835684,-350.86824314212447),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(-107,-207),new Point(271,-479)],[new Point(-107,-207),new Point(360.0604335563131,-529.0018277777501)],[new Point(-107,-207),new Point(647,320),new Point(1055,664)],[new Point(-107,-207),new Point(260.59999999999997,90),new Point(784,674)],[new Point(-107,-207),new Point(-10.29999999999994,246.4041879234696),new Point(417,656)],[new Point(-107,-207),new Point(129.5,560.1865334794732),new Point(203,759)],[new Point(-107,-207),new Point(56,674)],[new Point(-107,-207),new Point(-153.26497814579386,362.6780434158956),new Point(-289.3991018391502,729.2006744090877)],[new Point(-107,-207),new Point(-283.73502185420614,242.3219565841044),new Point(-381.4843460976219,649.1432030269882)],[new Point(-107,-207),new Point(-89.03523617876226,-499.7368825942079)],[new Point(-107,-207),new Point(-200.96476382123774,-499.7368825942079),new Point(-200.96476382123774,-530.2631174057921)],[new Point(-107,-207),new Point(-200.96476382123774,-499.7368825942079)],[new Point(-107,-207),new Point(-10.300000000000068,-66.40418792346955),new Point(-89.03523617876226,-530.2631174057921)],[new Point(-107,-207),new Point(1004.696796342723,-29.047074219986737)],[new Point(-107,-207),new Point(1040.303203657277,-140.95292578001326)],[new Point(-107,-207),new Point(728.25,-8.652867178156207),new Point(1040.303203657277,-29.047074219986737)],[new Point(-107,-207),new Point(1004.696796342723,-140.95292578001326)],[new Point(-107,-207),new Point(1004.7206704591699,249.0398047033964)],[new Point(-107,-207),new Point(1004.7206704591699,360.96019529660356),new Point(1037.27932954083,360.96019529660356)],[new Point(-107,-207),new Point(1004.7206704591699,360.96019529660356)],[new Point(-107,-207),new Point(1037.27932954083,249.0398047033964)],[new Point(-107,-207),new Point(471.13992102513606,-235.48983908715294)],[new Point(-107,-207),new Point(588.4106157414747,-343.91180848474517)],[new Point(-107,-207),new Point(519.5893842585253,-191.08819151525486)],[new Point(-107,-207),new Point(-283.73502185420614,242.3219565841044)],[new Point(-107,-207),new Point(-153.26497814579386,362.6780434158956)],[new Point(-107,-207),new Point(-10.29999999999994,246.4041879234696),new Point(-190.75,622.7201997807902),new Point(-213.94893036447175,389.9986950947747)],[new Point(-107,-207),new Point(-223.05106963552825,212.0013049052253)],[new Point(-107,-207),new Point(-190.49613893835684,-350.86824314212447)],[new Point(-107,-207)],[new Point(-107,-207),new Point(-296.99632055783536,-193.9142950057776)],[new Point(-107,-207),new Point(721,-565.4922678357856),new Point(973,-420)],[new Point(-107,-207),new Point(260.59999999999997,90),new Point(721,-274.5077321642143)],[new Point(-107,-207),new Point(721,-565.4922678357856)],[new Point(-107,-207),new Point(-143.5,650)],[new Point(-107,-207),new Point(-143.5,650),new Point(-190.75,677.2798002192098)],[new Point(-107,-207),new Point(-10.29999999999994,246.4041879234696),new Point(-190.75,622.7201997807902)],[new Point(-107,-207),new Point(129.5,523.8134665205268),new Point(161,542)],[new Point(-107,-207),new Point(129.5,560.1865334794732)],[new Point(-107,-207),new Point(129.5,523.8134665205268)],[new Point(-107,-207),new Point(647,320)],[new Point(-107,-207),new Point(584,356.3730669589464)],[new Point(-107,-207),new Point(584,283.6269330410536)],[new Point(-107,-207),new Point(728.25,-8.652867178156207),new Point(838.5,55)],[new Point(-107,-207),new Point(728.25,118.65286717815624)],[new Point(-107,-207),new Point(728.25,-8.652867178156207)],[new Point(-107,-207),new Point(260.59999999999997,90)],[new Point(-107,-207),new Point(-10.29999999999994,246.4041879234696)],[new Point(-107,-207),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(-296.99632055783536,-193.9142950057776),new Point(-107,-207),new Point(271,-479)],[new Point(-296.99632055783536,-193.9142950057776),new Point(-107,-207),new Point(360.0604335563131,-529.0018277777501)],[new Point(-296.99632055783536,-193.9142950057776),new Point(-10.300000000000068,-66.40418792346955),new Point(260.59999999999997,90),new Point(584,356.3730669589464),new Point(1055,664)],[new Point(-296.99632055783536,-193.9142950057776),new Point(-10.300000000000068,-66.40418792346955),new Point(260.59999999999997,90),new Point(784,674)],[new Point(-296.99632055783536,-193.9142950057776),new Point(417,656)],[new Point(-296.99632055783536,-193.9142950057776),new Point(203,759)],[new Point(-296.99632055783536,-193.9142950057776),new Point(56,674)],[new Point(-296.99632055783536,-193.9142950057776),new Point(-289.3991018391502,729.2006744090877)],[new Point(-296.99632055783536,-193.9142950057776),new Point(-381.4843460976219,649.1432030269882)],[new Point(-296.99632055783536,-193.9142950057776),new Point(-89.03523617876226,-499.7368825942079)],[new Point(-296.99632055783536,-193.9142950057776),new Point(-200.96476382123774,-530.2631174057921)],[new Point(-296.99632055783536,-193.9142950057776),new Point(-200.96476382123774,-499.7368825942079)],[new Point(-296.99632055783536,-193.9142950057776),new Point(-10.300000000000068,-66.40418792346955),new Point(-89.03523617876226,-530.2631174057921)],[new Point(-296.99632055783536,-193.9142950057776),new Point(1004.696796342723,-29.047074219986737)],[new Point(-296.99632055783536,-193.9142950057776),new Point(1040.303203657277,-140.95292578001326)],[new Point(-296.99632055783536,-193.9142950057776),new Point(728.25,-8.652867178156207),new Point(1040.303203657277,-29.047074219986737)],[new Point(-296.99632055783536,-193.9142950057776),new Point(1004.696796342723,-140.95292578001326)],[new Point(-296.99632055783536,-193.9142950057776),new Point(1004.7206704591699,249.0398047033964)],[new Point(-296.99632055783536,-193.9142950057776),new Point(1004.7206704591699,360.96019529660356),new Point(1037.27932954083,360.96019529660356)],[new Point(-296.99632055783536,-193.9142950057776),new Point(1004.7206704591699,360.96019529660356)],[new Point(-296.99632055783536,-193.9142950057776),new Point(1037.27932954083,249.0398047033964)],[new Point(-296.99632055783536,-193.9142950057776),new Point(471.13992102513606,-235.48983908715294)],[new Point(-296.99632055783536,-193.9142950057776),new Point(-107,-207),new Point(588.4106157414747,-343.91180848474517)],[new Point(-296.99632055783536,-193.9142950057776),new Point(519.5893842585253,-191.08819151525486)],[new Point(-296.99632055783536,-193.9142950057776),new Point(-283.73502185420614,242.3219565841044)],[new Point(-296.99632055783536,-193.9142950057776),new Point(-153.26497814579386,362.6780434158956)],[new Point(-296.99632055783536,-193.9142950057776),new Point(-10.29999999999994,246.4041879234696),new Point(-190.75,622.7201997807902),new Point(-213.94893036447175,389.9986950947747)],[new Point(-296.99632055783536,-193.9142950057776),new Point(-223.05106963552825,212.0013049052253)],[new Point(-296.99632055783536,-193.9142950057776),new Point(-190.49613893835684,-350.86824314212447)],[new Point(-296.99632055783536,-193.9142950057776),new Point(-107,-207)],[new Point(-296.99632055783536,-193.9142950057776)],[new Point(-296.99632055783536,-193.9142950057776),new Point(-10.300000000000068,-66.40418792346955),new Point(721,-565.4922678357856),new Point(973,-420)],[new Point(-296.99632055783536,-193.9142950057776),new Point(-10.300000000000068,-66.40418792346955),new Point(260.59999999999997,90),new Point(721,-274.5077321642143)],[new Point(-296.99632055783536,-193.9142950057776),new Point(-10.300000000000068,-66.40418792346955),new Point(721,-565.4922678357856)],[new Point(-296.99632055783536,-193.9142950057776),new Point(-10.29999999999994,246.4041879234696),new Point(-143.5,650)],[new Point(-296.99632055783536,-193.9142950057776),new Point(-10.29999999999994,246.4041879234696),new Point(-190.75,622.7201997807902),new Point(-190.75,677.2798002192098)],[new Point(-296.99632055783536,-193.9142950057776),new Point(-10.29999999999994,246.4041879234696),new Point(-190.75,622.7201997807902)],[new Point(-296.99632055783536,-193.9142950057776),new Point(161,542)],[new Point(-296.99632055783536,-193.9142950057776),new Point(129.5,560.1865334794732)],[new Point(-296.99632055783536,-193.9142950057776),new Point(129.5,523.8134665205268)],[new Point(-296.99632055783536,-193.9142950057776),new Point(-10.300000000000068,-66.40418792346955),new Point(647,320)],[new Point(-296.99632055783536,-193.9142950057776),new Point(-10.300000000000068,-66.40418792346955),new Point(260.59999999999997,90),new Point(584,356.3730669589464)],[new Point(-296.99632055783536,-193.9142950057776),new Point(-10.300000000000068,-66.40418792346955),new Point(584,283.6269330410536)],[new Point(-296.99632055783536,-193.9142950057776),new Point(728.25,-8.652867178156207),new Point(838.5,55)],[new Point(-296.99632055783536,-193.9142950057776),new Point(728.25,118.65286717815624)],[new Point(-296.99632055783536,-193.9142950057776),new Point(728.25,-8.652867178156207)],[new Point(-296.99632055783536,-193.9142950057776),new Point(-10.300000000000068,-66.40418792346955),new Point(260.59999999999997,90)],[new Point(-296.99632055783536,-193.9142950057776),new Point(-10.29999999999994,246.4041879234696)],[new Point(-296.99632055783536,-193.9142950057776),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(973,-420),new Point(721,-565.4922678357856),new Point(271,-479)],[new Point(973,-420),new Point(721,-565.4922678357856),new Point(360.0604335563131,-529.0018277777501)],[new Point(973,-420),new Point(1004.696796342723,-29.047074219986737),new Point(1037.27932954083,249.0398047033964),new Point(1055,664)],[new Point(973,-420),new Point(784,674)],[new Point(973,-420),new Point(584,283.6269330410536),new Point(417,656)],[new Point(973,-420),new Point(203,759)],[new Point(973,-420),new Point(56,674)],[new Point(973,-420),new Point(-289.3991018391502,729.2006744090877)],[new Point(973,-420),new Point(-381.4843460976219,649.1432030269882)],[new Point(973,-420),new Point(721,-274.5077321642143),new Point(519.5893842585253,-191.08819151525486),new Point(-89.03523617876226,-499.7368825942079)],[new Point(973,-420),new Point(721,-274.5077321642143),new Point(519.5893842585253,-191.08819151525486),new Point(-89.03523617876226,-530.2631174057921),new Point(-200.96476382123774,-530.2631174057921)],[new Point(973,-420),new Point(721,-274.5077321642143),new Point(519.5893842585253,-191.08819151525486),new Point(-200.96476382123774,-499.7368825942079)],[new Point(973,-420),new Point(721,-274.5077321642143),new Point(519.5893842585253,-191.08819151525486),new Point(-89.03523617876226,-530.2631174057921)],[new Point(973,-420),new Point(1004.696796342723,-29.047074219986737)],[new Point(973,-420),new Point(1040.303203657277,-140.95292578001326)],[new Point(973,-420),new Point(838.5,55),new Point(1040.303203657277,-29.047074219986737)],[new Point(973,-420),new Point(1004.696796342723,-140.95292578001326)],[new Point(973,-420),new Point(1004.7206704591699,249.0398047033964)],[new Point(973,-420),new Point(1004.7206704591699,360.96019529660356),new Point(1037.27932954083,360.96019529660356)],[new Point(973,-420),new Point(1004.7206704591699,360.96019529660356)],[new Point(973,-420),new Point(838.5,55),new Point(1037.27932954083,249.0398047033964)],[new Point(973,-420),new Point(721,-274.5077321642143),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294)],[new Point(973,-420),new Point(721,-565.4922678357856),new Point(588.4106157414747,-343.91180848474517)],[new Point(973,-420),new Point(721,-274.5077321642143),new Point(519.5893842585253,-191.08819151525486)],[new Point(973,-420),new Point(260.59999999999997,90),new Point(-10.29999999999994,246.4041879234696),new Point(-223.05106963552825,212.0013049052253),new Point(-283.73502185420614,242.3219565841044)],[new Point(973,-420),new Point(-153.26497814579386,362.6780434158956)],[new Point(973,-420),new Point(728.25,-8.652867178156207),new Point(-213.94893036447175,389.9986950947747)],[new Point(973,-420),new Point(260.59999999999997,90),new Point(-10.29999999999994,246.4041879234696),new Point(-223.05106963552825,212.0013049052253)],[new Point(973,-420),new Point(721,-565.4922678357856),new Point(-190.49613893835684,-350.86824314212447)],[new Point(973,-420),new Point(721,-565.4922678357856),new Point(-107,-207)],[new Point(973,-420),new Point(721,-565.4922678357856),new Point(-10.300000000000068,-66.40418792346955),new Point(-296.99632055783536,-193.9142950057776)],[new Point(973,-420)],[new Point(973,-420),new Point(721,-274.5077321642143)],[new Point(973,-420),new Point(721,-565.4922678357856)],[new Point(973,-420),new Point(-143.5,650)],[new Point(973,-420),new Point(-143.5,650),new Point(-190.75,677.2798002192098)],[new Point(973,-420),new Point(-190.75,622.7201997807902)],[new Point(973,-420),new Point(161,542)],[new Point(973,-420),new Point(161,542),new Point(129.5,560.1865334794732)],[new Point(973,-420),new Point(129.5,523.8134665205268)],[new Point(973,-420),new Point(728.25,-8.652867178156207),new Point(647,320)],[new Point(973,-420),new Point(584,283.6269330410536),new Point(584,356.3730669589464)],[new Point(973,-420),new Point(584,283.6269330410536)],[new Point(973,-420),new Point(838.5,55)],[new Point(973,-420),new Point(728.25,-8.652867178156207),new Point(728.25,118.65286717815624)],[new Point(973,-420),new Point(728.25,-8.652867178156207)],[new Point(973,-420),new Point(260.59999999999997,90)],[new Point(973,-420),new Point(260.59999999999997,90),new Point(-10.29999999999994,246.4041879234696)],[new Point(973,-420),new Point(721,-565.4922678357856),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(721,-274.5077321642143),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294),new Point(271,-479)],[new Point(721,-274.5077321642143),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294),new Point(360.0604335563131,-529.0018277777501)],[new Point(721,-274.5077321642143),new Point(1055,664)],[new Point(721,-274.5077321642143),new Point(728.25,118.65286717815624),new Point(784,674)],[new Point(721,-274.5077321642143),new Point(417,656)],[new Point(721,-274.5077321642143),new Point(203,759)],[new Point(721,-274.5077321642143),new Point(161,542),new Point(56,674)],[new Point(721,-274.5077321642143),new Point(-289.3991018391502,729.2006744090877)],[new Point(721,-274.5077321642143),new Point(-381.4843460976219,649.1432030269882)],[new Point(721,-274.5077321642143),new Point(519.5893842585253,-191.08819151525486),new Point(-89.03523617876226,-499.7368825942079)],[new Point(721,-274.5077321642143),new Point(519.5893842585253,-191.08819151525486),new Point(-89.03523617876226,-530.2631174057921),new Point(-200.96476382123774,-530.2631174057921)],[new Point(721,-274.5077321642143),new Point(519.5893842585253,-191.08819151525486),new Point(-200.96476382123774,-499.7368825942079)],[new Point(721,-274.5077321642143),new Point(519.5893842585253,-191.08819151525486),new Point(-89.03523617876226,-530.2631174057921)],[new Point(721,-274.5077321642143),new Point(1004.696796342723,-29.047074219986737)],[new Point(721,-274.5077321642143),new Point(1040.303203657277,-140.95292578001326)],[new Point(721,-274.5077321642143),new Point(838.5,55),new Point(1040.303203657277,-29.047074219986737)],[new Point(721,-274.5077321642143),new Point(1004.696796342723,-140.95292578001326)],[new Point(721,-274.5077321642143),new Point(1004.7206704591699,249.0398047033964)],[new Point(721,-274.5077321642143),new Point(1037.27932954083,249.0398047033964),new Point(1037.27932954083,360.96019529660356)],[new Point(721,-274.5077321642143),new Point(1004.7206704591699,360.96019529660356)],[new Point(721,-274.5077321642143),new Point(1037.27932954083,249.0398047033964)],[new Point(721,-274.5077321642143),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294)],[new Point(721,-274.5077321642143),new Point(973,-420),new Point(721,-565.4922678357856),new Point(588.4106157414747,-343.91180848474517)],[new Point(721,-274.5077321642143),new Point(519.5893842585253,-191.08819151525486)],[new Point(721,-274.5077321642143),new Point(260.59999999999997,90),new Point(-10.29999999999994,246.4041879234696),new Point(-223.05106963552825,212.0013049052253),new Point(-283.73502185420614,242.3219565841044)],[new Point(721,-274.5077321642143),new Point(260.59999999999997,90),new Point(-153.26497814579386,362.6780434158956)],[new Point(721,-274.5077321642143),new Point(728.25,-8.652867178156207),new Point(-213.94893036447175,389.9986950947747)],[new Point(721,-274.5077321642143),new Point(260.59999999999997,90),new Point(-10.29999999999994,246.4041879234696),new Point(-223.05106963552825,212.0013049052253)],[new Point(721,-274.5077321642143),new Point(260.59999999999997,90),new Point(-190.49613893835684,-350.86824314212447)],[new Point(721,-274.5077321642143),new Point(260.59999999999997,90),new Point(-107,-207)],[new Point(721,-274.5077321642143),new Point(260.59999999999997,90),new Point(-10.300000000000068,-66.40418792346955),new Point(-296.99632055783536,-193.9142950057776)],[new Point(721,-274.5077321642143),new Point(973,-420)],[new Point(721,-274.5077321642143)],[new Point(721,-274.5077321642143),new Point(260.59999999999997,90),new Point(-10.300000000000068,-66.40418792346955),new Point(721,-565.4922678357856)],[new Point(721,-274.5077321642143),new Point(-143.5,650)],[new Point(721,-274.5077321642143),new Point(-143.5,650),new Point(-190.75,677.2798002192098)],[new Point(721,-274.5077321642143),new Point(-190.75,622.7201997807902)],[new Point(721,-274.5077321642143),new Point(161,542)],[new Point(721,-274.5077321642143),new Point(161,542),new Point(129.5,560.1865334794732)],[new Point(721,-274.5077321642143),new Point(129.5,523.8134665205268)],[new Point(721,-274.5077321642143),new Point(647,320)],[new Point(721,-274.5077321642143),new Point(584,283.6269330410536),new Point(584,356.3730669589464)],[new Point(721,-274.5077321642143),new Point(584,283.6269330410536)],[new Point(721,-274.5077321642143),new Point(838.5,55)],[new Point(721,-274.5077321642143),new Point(728.25,118.65286717815624)],[new Point(721,-274.5077321642143),new Point(728.25,-8.652867178156207)],[new Point(721,-274.5077321642143),new Point(260.59999999999997,90)],[new Point(721,-274.5077321642143),new Point(260.59999999999997,90),new Point(-10.29999999999994,246.4041879234696)],[new Point(721,-274.5077321642143),new Point(260.59999999999997,90),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(721,-565.4922678357856),new Point(271,-479)],[new Point(721,-565.4922678357856),new Point(360.0604335563131,-529.0018277777501)],[new Point(721,-565.4922678357856),new Point(973,-420),new Point(1004.696796342723,-29.047074219986737),new Point(1037.27932954083,249.0398047033964),new Point(1055,664)],[new Point(721,-565.4922678357856),new Point(471.13992102513606,-235.48983908715294),new Point(784,674)],[new Point(721,-565.4922678357856),new Point(471.13992102513606,-235.48983908715294),new Point(417,656)],[new Point(721,-565.4922678357856),new Point(471.13992102513606,-235.48983908715294),new Point(203,759)],[new Point(721,-565.4922678357856),new Point(471.13992102513606,-235.48983908715294),new Point(56,674)],[new Point(721,-565.4922678357856),new Point(-289.3991018391502,729.2006744090877)],[new Point(721,-565.4922678357856),new Point(471.13992102513606,-235.48983908715294),new Point(260.59999999999997,90),new Point(-381.4843460976219,649.1432030269882)],[new Point(721,-565.4922678357856),new Point(588.4106157414747,-343.91180848474517),new Point(-89.03523617876226,-499.7368825942079)],[new Point(721,-565.4922678357856),new Point(588.4106157414747,-343.91180848474517),new Point(-89.03523617876226,-530.2631174057921),new Point(-200.96476382123774,-530.2631174057921)],[new Point(721,-565.4922678357856),new Point(588.4106157414747,-343.91180848474517),new Point(-200.96476382123774,-499.7368825942079)],[new Point(721,-565.4922678357856),new Point(588.4106157414747,-343.91180848474517),new Point(-89.03523617876226,-530.2631174057921)],[new Point(721,-565.4922678357856),new Point(973,-420),new Point(1004.696796342723,-29.047074219986737)],[new Point(721,-565.4922678357856),new Point(973,-420),new Point(1040.303203657277,-140.95292578001326)],[new Point(721,-565.4922678357856),new Point(973,-420),new Point(838.5,55),new Point(1040.303203657277,-29.047074219986737)],[new Point(721,-565.4922678357856),new Point(973,-420),new Point(1004.696796342723,-140.95292578001326)],[new Point(721,-565.4922678357856),new Point(973,-420),new Point(1004.7206704591699,249.0398047033964)],[new Point(721,-565.4922678357856),new Point(973,-420),new Point(1004.7206704591699,360.96019529660356),new Point(1037.27932954083,360.96019529660356)],[new Point(721,-565.4922678357856),new Point(973,-420),new Point(1004.7206704591699,360.96019529660356)],[new Point(721,-565.4922678357856),new Point(973,-420),new Point(838.5,55),new Point(1037.27932954083,249.0398047033964)],[new Point(721,-565.4922678357856),new Point(471.13992102513606,-235.48983908715294)],[new Point(721,-565.4922678357856),new Point(588.4106157414747,-343.91180848474517)],[new Point(721,-565.4922678357856),new Point(973,-420),new Point(721,-274.5077321642143),new Point(519.5893842585253,-191.08819151525486)],[new Point(721,-565.4922678357856),new Point(-283.73502185420614,242.3219565841044)],[new Point(721,-565.4922678357856),new Point(-10.300000000000068,-66.40418792346955),new Point(-153.26497814579386,362.6780434158956)],[new Point(721,-565.4922678357856),new Point(-190.75,622.7201997807902),new Point(-213.94893036447175,389.9986950947747)],[new Point(721,-565.4922678357856),new Point(-223.05106963552825,212.0013049052253)],[new Point(721,-565.4922678357856),new Point(-190.49613893835684,-350.86824314212447)],[new Point(721,-565.4922678357856),new Point(-107,-207)],[new Point(721,-565.4922678357856),new Point(-10.300000000000068,-66.40418792346955),new Point(-296.99632055783536,-193.9142950057776)],[new Point(721,-565.4922678357856),new Point(973,-420)],[new Point(721,-565.4922678357856),new Point(-10.300000000000068,-66.40418792346955),new Point(260.59999999999997,90),new Point(721,-274.5077321642143)],[new Point(721,-565.4922678357856)],[new Point(721,-565.4922678357856),new Point(-190.75,622.7201997807902),new Point(-143.5,650)],[new Point(721,-565.4922678357856),new Point(-190.75,622.7201997807902),new Point(-190.75,677.2798002192098)],[new Point(721,-565.4922678357856),new Point(-190.75,622.7201997807902)],[new Point(721,-565.4922678357856),new Point(-10.300000000000068,-66.40418792346955),new Point(-10.29999999999994,246.4041879234696),new Point(161,542)],[new Point(721,-565.4922678357856),new Point(-10.300000000000068,-66.40418792346955),new Point(-10.29999999999994,246.4041879234696),new Point(129.5,560.1865334794732)],[new Point(721,-565.4922678357856),new Point(-10.300000000000068,-66.40418792346955),new Point(-10.29999999999994,246.4041879234696),new Point(129.5,523.8134665205268)],[new Point(721,-565.4922678357856),new Point(-10.300000000000068,-66.40418792346955),new Point(647,320)],[new Point(721,-565.4922678357856),new Point(-10.300000000000068,-66.40418792346955),new Point(260.59999999999997,90),new Point(584,356.3730669589464)],[new Point(721,-565.4922678357856),new Point(-10.300000000000068,-66.40418792346955),new Point(584,283.6269330410536)],[new Point(721,-565.4922678357856),new Point(-10.300000000000068,-66.40418792346955),new Point(728.25,-8.652867178156207),new Point(838.5,55)],[new Point(721,-565.4922678357856),new Point(-10.300000000000068,-66.40418792346955),new Point(728.25,118.65286717815624)],[new Point(721,-565.4922678357856),new Point(-10.300000000000068,-66.40418792346955),new Point(728.25,-8.652867178156207)],[new Point(721,-565.4922678357856),new Point(-10.300000000000068,-66.40418792346955),new Point(260.59999999999997,90)],[new Point(721,-565.4922678357856),new Point(-10.300000000000068,-66.40418792346955),new Point(-10.29999999999994,246.4041879234696)],[new Point(721,-565.4922678357856),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(-143.5,650),new Point(-10.300000000000068,-66.40418792346955),new Point(271,-479)],[new Point(-143.5,650),new Point(260.59999999999997,90),new Point(360.0604335563131,-529.0018277777501)],[new Point(-143.5,650),new Point(1055,664)],[new Point(-143.5,650),new Point(417,656),new Point(784,674)],[new Point(-143.5,650),new Point(417,656)],[new Point(-143.5,650),new Point(56,674),new Point(203,759)],[new Point(-143.5,650),new Point(56,674)],[new Point(-143.5,650),new Point(-289.3991018391502,729.2006744090877)],[new Point(-143.5,650),new Point(-190.75,622.7201997807902),new Point(-381.4843460976219,649.1432030269882)],[new Point(-143.5,650),new Point(-89.03523617876226,-499.7368825942079)],[new Point(-143.5,650),new Point(-107,-207),new Point(-200.96476382123774,-499.7368825942079),new Point(-200.96476382123774,-530.2631174057921)],[new Point(-143.5,650),new Point(-107,-207),new Point(-200.96476382123774,-499.7368825942079)],[new Point(-143.5,650),new Point(-10.300000000000068,-66.40418792346955),new Point(-89.03523617876226,-530.2631174057921)],[new Point(-143.5,650),new Point(1004.696796342723,-29.047074219986737)],[new Point(-143.5,650),new Point(728.25,-8.652867178156207),new Point(1004.696796342723,-140.95292578001326),new Point(1040.303203657277,-140.95292578001326)],[new Point(-143.5,650),new Point(1040.303203657277,-29.047074219986737)],[new Point(-143.5,650),new Point(728.25,-8.652867178156207),new Point(1004.696796342723,-140.95292578001326)],[new Point(-143.5,650),new Point(129.5,560.1865334794732),new Point(1004.7206704591699,249.0398047033964)],[new Point(-143.5,650),new Point(1037.27932954083,360.96019529660356)],[new Point(-143.5,650),new Point(1004.7206704591699,360.96019529660356)],[new Point(-143.5,650),new Point(728.25,118.65286717815624),new Point(1037.27932954083,249.0398047033964)],[new Point(-143.5,650),new Point(471.13992102513606,-235.48983908715294)],[new Point(-143.5,650),new Point(-10.300000000000068,-66.40418792346955),new Point(588.4106157414747,-343.91180848474517)],[new Point(-143.5,650),new Point(519.5893842585253,-191.08819151525486)],[new Point(-143.5,650),new Point(-283.73502185420614,242.3219565841044)],[new Point(-143.5,650),new Point(-153.26497814579386,362.6780434158956)],[new Point(-143.5,650),new Point(-213.94893036447175,389.9986950947747)],[new Point(-143.5,650),new Point(-10.29999999999994,246.4041879234696),new Point(-223.05106963552825,212.0013049052253)],[new Point(-143.5,650),new Point(-107,-207),new Point(-190.49613893835684,-350.86824314212447)],[new Point(-143.5,650),new Point(-107,-207)],[new Point(-143.5,650),new Point(-10.29999999999994,246.4041879234696),new Point(-296.99632055783536,-193.9142950057776)],[new Point(-143.5,650),new Point(973,-420)],[new Point(-143.5,650),new Point(721,-274.5077321642143)],[new Point(-143.5,650),new Point(-190.75,622.7201997807902),new Point(721,-565.4922678357856)],[new Point(-143.5,650)],[new Point(-143.5,650),new Point(-190.75,677.2798002192098)],[new Point(-143.5,650),new Point(-190.75,622.7201997807902)],[new Point(-143.5,650),new Point(129.5,560.1865334794732),new Point(161,542)],[new Point(-143.5,650),new Point(129.5,560.1865334794732)],[new Point(-143.5,650),new Point(129.5,523.8134665205268)],[new Point(-143.5,650),new Point(129.5,523.8134665205268),new Point(584,356.3730669589464),new Point(647,320)],[new Point(-143.5,650),new Point(129.5,523.8134665205268),new Point(584,356.3730669589464)],[new Point(-143.5,650),new Point(584,283.6269330410536)],[new Point(-143.5,650),new Point(838.5,55)],[new Point(-143.5,650),new Point(728.25,118.65286717815624)],[new Point(-143.5,650),new Point(728.25,-8.652867178156207)],[new Point(-143.5,650),new Point(260.59999999999997,90)],[new Point(-143.5,650),new Point(-10.29999999999994,246.4041879234696)],[new Point(-143.5,650),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(-190.75,677.2798002192098),new Point(-190.75,622.7201997807902),new Point(-10.300000000000068,-66.40418792346955),new Point(271,-479)],[new Point(-190.75,677.2798002192098),new Point(-190.75,622.7201997807902),new Point(-10.300000000000068,-66.40418792346955),new Point(360.0604335563131,-529.0018277777501)],[new Point(-190.75,677.2798002192098),new Point(417,656),new Point(1055,664)],[new Point(-190.75,677.2798002192098),new Point(417,656),new Point(784,674)],[new Point(-190.75,677.2798002192098),new Point(417,656)],[new Point(-190.75,677.2798002192098),new Point(56,674),new Point(203,759)],[new Point(-190.75,677.2798002192098),new Point(56,674)],[new Point(-190.75,677.2798002192098),new Point(-289.3991018391502,729.2006744090877)],[new Point(-190.75,677.2798002192098),new Point(-381.4843460976219,649.1432030269882)],[new Point(-190.75,677.2798002192098),new Point(-190.75,622.7201997807902),new Point(-153.26497814579386,362.6780434158956),new Point(-107,-207),new Point(-89.03523617876226,-499.7368825942079)],[new Point(-190.75,677.2798002192098),new Point(-190.75,622.7201997807902),new Point(-153.26497814579386,362.6780434158956),new Point(-107,-207),new Point(-200.96476382123774,-499.7368825942079),new Point(-200.96476382123774,-530.2631174057921)],[new Point(-190.75,677.2798002192098),new Point(-190.75,622.7201997807902),new Point(-153.26497814579386,362.6780434158956),new Point(-107,-207),new Point(-200.96476382123774,-499.7368825942079)],[new Point(-190.75,677.2798002192098),new Point(-190.75,622.7201997807902),new Point(-10.300000000000068,-66.40418792346955),new Point(-89.03523617876226,-530.2631174057921)],[new Point(-190.75,677.2798002192098),new Point(1004.696796342723,-29.047074219986737)],[new Point(-190.75,677.2798002192098),new Point(-143.5,650),new Point(728.25,-8.652867178156207),new Point(1004.696796342723,-140.95292578001326),new Point(1040.303203657277,-140.95292578001326)],[new Point(-190.75,677.2798002192098),new Point(1040.303203657277,-29.047074219986737)],[new Point(-190.75,677.2798002192098),new Point(-143.5,650),new Point(728.25,-8.652867178156207),new Point(1004.696796342723,-140.95292578001326)],[new Point(-190.75,677.2798002192098),new Point(1004.7206704591699,249.0398047033964)],[new Point(-190.75,677.2798002192098),new Point(1037.27932954083,360.96019529660356)],[new Point(-190.75,677.2798002192098),new Point(1004.7206704591699,360.96019529660356)],[new Point(-190.75,677.2798002192098),new Point(728.25,118.65286717815624),new Point(1037.27932954083,249.0398047033964)],[new Point(-190.75,677.2798002192098),new Point(-143.5,650),new Point(471.13992102513606,-235.48983908715294)],[new Point(-190.75,677.2798002192098),new Point(-190.75,622.7201997807902),new Point(-10.300000000000068,-66.40418792346955),new Point(588.4106157414747,-343.91180848474517)],[new Point(-190.75,677.2798002192098),new Point(-143.5,650),new Point(519.5893842585253,-191.08819151525486)],[new Point(-190.75,677.2798002192098),new Point(-283.73502185420614,242.3219565841044)],[new Point(-190.75,677.2798002192098),new Point(-190.75,622.7201997807902),new Point(-153.26497814579386,362.6780434158956)],[new Point(-190.75,677.2798002192098),new Point(-213.94893036447175,389.9986950947747)],[new Point(-190.75,677.2798002192098),new Point(-190.75,622.7201997807902),new Point(-10.29999999999994,246.4041879234696),new Point(-223.05106963552825,212.0013049052253)],[new Point(-190.75,677.2798002192098),new Point(-143.5,650),new Point(-107,-207),new Point(-190.49613893835684,-350.86824314212447)],[new Point(-190.75,677.2798002192098),new Point(-143.5,650),new Point(-107,-207)],[new Point(-190.75,677.2798002192098),new Point(-190.75,622.7201997807902),new Point(-10.29999999999994,246.4041879234696),new Point(-296.99632055783536,-193.9142950057776)],[new Point(-190.75,677.2798002192098),new Point(-143.5,650),new Point(973,-420)],[new Point(-190.75,677.2798002192098),new Point(-143.5,650),new Point(721,-274.5077321642143)],[new Point(-190.75,677.2798002192098),new Point(-190.75,622.7201997807902),new Point(721,-565.4922678357856)],[new Point(-190.75,677.2798002192098),new Point(-143.5,650)],[new Point(-190.75,677.2798002192098)],[new Point(-190.75,677.2798002192098),new Point(-190.75,622.7201997807902)],[new Point(-190.75,677.2798002192098),new Point(129.5,560.1865334794732),new Point(161,542)],[new Point(-190.75,677.2798002192098),new Point(129.5,560.1865334794732)],[new Point(-190.75,677.2798002192098),new Point(129.5,523.8134665205268)],[new Point(-190.75,677.2798002192098),new Point(129.5,560.1865334794732),new Point(584,356.3730669589464),new Point(647,320)],[new Point(-190.75,677.2798002192098),new Point(129.5,560.1865334794732),new Point(584,356.3730669589464)],[new Point(-190.75,677.2798002192098),new Point(584,283.6269330410536)],[new Point(-190.75,677.2798002192098),new Point(838.5,55)],[new Point(-190.75,677.2798002192098),new Point(728.25,118.65286717815624)],[new Point(-190.75,677.2798002192098),new Point(129.5,523.8134665205268),new Point(728.25,-8.652867178156207)],[new Point(-190.75,677.2798002192098),new Point(-190.75,622.7201997807902),new Point(260.59999999999997,90)],[new Point(-190.75,677.2798002192098),new Point(-190.75,622.7201997807902),new Point(-10.29999999999994,246.4041879234696)],[new Point(-190.75,677.2798002192098),new Point(-190.75,622.7201997807902),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(-190.75,622.7201997807902),new Point(-10.300000000000068,-66.40418792346955),new Point(271,-479)],[new Point(-190.75,622.7201997807902),new Point(-10.300000000000068,-66.40418792346955),new Point(360.0604335563131,-529.0018277777501)],[new Point(-190.75,622.7201997807902),new Point(1055,664)],[new Point(-190.75,622.7201997807902),new Point(784,674)],[new Point(-190.75,622.7201997807902),new Point(417,656)],[new Point(-190.75,622.7201997807902),new Point(56,674),new Point(203,759)],[new Point(-190.75,622.7201997807902),new Point(56,674)],[new Point(-190.75,622.7201997807902),new Point(-289.3991018391502,729.2006744090877)],[new Point(-190.75,622.7201997807902),new Point(-381.4843460976219,649.1432030269882)],[new Point(-190.75,622.7201997807902),new Point(-153.26497814579386,362.6780434158956),new Point(-107,-207),new Point(-89.03523617876226,-499.7368825942079)],[new Point(-190.75,622.7201997807902),new Point(-153.26497814579386,362.6780434158956),new Point(-107,-207),new Point(-200.96476382123774,-499.7368825942079),new Point(-200.96476382123774,-530.2631174057921)],[new Point(-190.75,622.7201997807902),new Point(-153.26497814579386,362.6780434158956),new Point(-107,-207),new Point(-200.96476382123774,-499.7368825942079)],[new Point(-190.75,622.7201997807902),new Point(-10.300000000000068,-66.40418792346955),new Point(-89.03523617876226,-530.2631174057921)],[new Point(-190.75,622.7201997807902),new Point(1004.696796342723,-29.047074219986737)],[new Point(-190.75,622.7201997807902),new Point(1004.696796342723,-140.95292578001326),new Point(1040.303203657277,-140.95292578001326)],[new Point(-190.75,622.7201997807902),new Point(1040.303203657277,-29.047074219986737)],[new Point(-190.75,622.7201997807902),new Point(1004.696796342723,-140.95292578001326)],[new Point(-190.75,622.7201997807902),new Point(1004.7206704591699,249.0398047033964)],[new Point(-190.75,622.7201997807902),new Point(129.5,560.1865334794732),new Point(1037.27932954083,360.96019529660356)],[new Point(-190.75,622.7201997807902),new Point(129.5,560.1865334794732),new Point(1004.7206704591699,360.96019529660356)],[new Point(-190.75,622.7201997807902),new Point(728.25,118.65286717815624),new Point(1037.27932954083,249.0398047033964)],[new Point(-190.75,622.7201997807902),new Point(471.13992102513606,-235.48983908715294)],[new Point(-190.75,622.7201997807902),new Point(-10.300000000000068,-66.40418792346955),new Point(588.4106157414747,-343.91180848474517)],[new Point(-190.75,622.7201997807902),new Point(519.5893842585253,-191.08819151525486)],[new Point(-190.75,622.7201997807902),new Point(-283.73502185420614,242.3219565841044)],[new Point(-190.75,622.7201997807902),new Point(-153.26497814579386,362.6780434158956)],[new Point(-190.75,622.7201997807902),new Point(-213.94893036447175,389.9986950947747)],[new Point(-190.75,622.7201997807902),new Point(-10.29999999999994,246.4041879234696),new Point(-223.05106963552825,212.0013049052253)],[new Point(-190.75,622.7201997807902),new Point(-10.29999999999994,246.4041879234696),new Point(-107,-207),new Point(-190.49613893835684,-350.86824314212447)],[new Point(-190.75,622.7201997807902),new Point(-10.29999999999994,246.4041879234696),new Point(-107,-207)],[new Point(-190.75,622.7201997807902),new Point(-10.29999999999994,246.4041879234696),new Point(-296.99632055783536,-193.9142950057776)],[new Point(-190.75,622.7201997807902),new Point(973,-420)],[new Point(-190.75,622.7201997807902),new Point(721,-274.5077321642143)],[new Point(-190.75,622.7201997807902),new Point(721,-565.4922678357856)],[new Point(-190.75,622.7201997807902),new Point(-143.5,650)],[new Point(-190.75,622.7201997807902),new Point(-190.75,677.2798002192098)],[new Point(-190.75,622.7201997807902)],[new Point(-190.75,622.7201997807902),new Point(129.5,560.1865334794732),new Point(161,542)],[new Point(-190.75,622.7201997807902),new Point(129.5,560.1865334794732)],[new Point(-190.75,622.7201997807902),new Point(129.5,523.8134665205268)],[new Point(-190.75,622.7201997807902),new Point(584,356.3730669589464),new Point(647,320)],[new Point(-190.75,622.7201997807902),new Point(584,356.3730669589464)],[new Point(-190.75,622.7201997807902),new Point(584,283.6269330410536)],[new Point(-190.75,622.7201997807902),new Point(838.5,55)],[new Point(-190.75,622.7201997807902),new Point(728.25,118.65286717815624)],[new Point(-190.75,622.7201997807902),new Point(728.25,-8.652867178156207)],[new Point(-190.75,622.7201997807902),new Point(260.59999999999997,90)],[new Point(-190.75,622.7201997807902),new Point(-10.29999999999994,246.4041879234696)],[new Point(-190.75,622.7201997807902),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(161,542),new Point(271,-479)],[new Point(161,542),new Point(360.0604335563131,-529.0018277777501)],[new Point(161,542),new Point(1055,664)],[new Point(161,542),new Point(784,674)],[new Point(161,542),new Point(417,656)],[new Point(161,542),new Point(203,759)],[new Point(161,542),new Point(56,674)],[new Point(161,542),new Point(129.5,560.1865334794732),new Point(-289.3991018391502,729.2006744090877)],[new Point(161,542),new Point(129.5,560.1865334794732),new Point(-381.4843460976219,649.1432030269882)],[new Point(161,542),new Point(-10.29999999999994,246.4041879234696),new Point(-89.03523617876226,-499.7368825942079)],[new Point(161,542),new Point(129.5,523.8134665205268),new Point(-200.96476382123774,-499.7368825942079),new Point(-200.96476382123774,-530.2631174057921)],[new Point(161,542),new Point(129.5,523.8134665205268),new Point(-200.96476382123774,-499.7368825942079)],[new Point(161,542),new Point(-10.29999999999994,246.4041879234696),new Point(-89.03523617876226,-530.2631174057921)],[new Point(161,542),new Point(1004.696796342723,-29.047074219986737)],[new Point(161,542),new Point(838.5,55),new Point(1004.696796342723,-140.95292578001326),new Point(1040.303203657277,-140.95292578001326)],[new Point(161,542),new Point(1040.303203657277,-29.047074219986737)],[new Point(161,542),new Point(838.5,55),new Point(1004.696796342723,-140.95292578001326)],[new Point(161,542),new Point(1004.7206704591699,249.0398047033964)],[new Point(161,542),new Point(1037.27932954083,360.96019529660356)],[new Point(161,542),new Point(1004.7206704591699,360.96019529660356)],[new Point(161,542),new Point(728.25,118.65286717815624),new Point(1037.27932954083,249.0398047033964)],[new Point(161,542),new Point(471.13992102513606,-235.48983908715294)],[new Point(161,542),new Point(-10.29999999999994,246.4041879234696),new Point(-10.300000000000068,-66.40418792346955),new Point(588.4106157414747,-343.91180848474517)],[new Point(161,542),new Point(519.5893842585253,-191.08819151525486)],[new Point(161,542),new Point(129.5,523.8134665205268),new Point(-213.94893036447175,389.9986950947747),new Point(-283.73502185420614,242.3219565841044)],[new Point(161,542),new Point(-153.26497814579386,362.6780434158956)],[new Point(161,542),new Point(129.5,523.8134665205268),new Point(-213.94893036447175,389.9986950947747)],[new Point(161,542),new Point(-223.05106963552825,212.0013049052253)],[new Point(161,542),new Point(129.5,523.8134665205268),new Point(-107,-207),new Point(-190.49613893835684,-350.86824314212447)],[new Point(161,542),new Point(129.5,523.8134665205268),new Point(-107,-207)],[new Point(161,542),new Point(-296.99632055783536,-193.9142950057776)],[new Point(161,542),new Point(973,-420)],[new Point(161,542),new Point(721,-274.5077321642143)],[new Point(161,542),new Point(-10.29999999999994,246.4041879234696),new Point(-10.300000000000068,-66.40418792346955),new Point(721,-565.4922678357856)],[new Point(161,542),new Point(129.5,560.1865334794732),new Point(-143.5,650)],[new Point(161,542),new Point(129.5,560.1865334794732),new Point(-190.75,677.2798002192098)],[new Point(161,542),new Point(129.5,560.1865334794732),new Point(-190.75,622.7201997807902)],[new Point(161,542)],[new Point(161,542),new Point(129.5,560.1865334794732)],[new Point(161,542),new Point(129.5,523.8134665205268)],[new Point(161,542),new Point(584,356.3730669589464),new Point(647,320)],[new Point(161,542),new Point(584,356.3730669589464)],[new Point(161,542),new Point(584,283.6269330410536)],[new Point(161,542),new Point(838.5,55)],[new Point(161,542),new Point(728.25,118.65286717815624)],[new Point(161,542),new Point(728.25,-8.652867178156207)],[new Point(161,542),new Point(260.59999999999997,90)],[new Point(161,542),new Point(-10.29999999999994,246.4041879234696)],[new Point(161,542),new Point(-10.29999999999994,246.4041879234696),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(129.5,560.1865334794732),new Point(129.5,523.8134665205268),new Point(271,-479)],[new Point(129.5,560.1865334794732),new Point(129.5,523.8134665205268),new Point(360.0604335563131,-529.0018277777501)],[new Point(129.5,560.1865334794732),new Point(1055,664)],[new Point(129.5,560.1865334794732),new Point(784,674)],[new Point(129.5,560.1865334794732),new Point(417,656)],[new Point(129.5,560.1865334794732),new Point(203,759)],[new Point(129.5,560.1865334794732),new Point(56,674)],[new Point(129.5,560.1865334794732),new Point(-289.3991018391502,729.2006744090877)],[new Point(129.5,560.1865334794732),new Point(-381.4843460976219,649.1432030269882)],[new Point(129.5,560.1865334794732),new Point(-10.29999999999994,246.4041879234696),new Point(-89.03523617876226,-499.7368825942079)],[new Point(129.5,560.1865334794732),new Point(-107,-207),new Point(-200.96476382123774,-499.7368825942079),new Point(-200.96476382123774,-530.2631174057921)],[new Point(129.5,560.1865334794732),new Point(-107,-207),new Point(-200.96476382123774,-499.7368825942079)],[new Point(129.5,560.1865334794732),new Point(-10.29999999999994,246.4041879234696),new Point(-89.03523617876226,-530.2631174057921)],[new Point(129.5,560.1865334794732),new Point(161,542),new Point(1004.696796342723,-29.047074219986737)],[new Point(129.5,560.1865334794732),new Point(161,542),new Point(838.5,55),new Point(1004.696796342723,-140.95292578001326),new Point(1040.303203657277,-140.95292578001326)],[new Point(129.5,560.1865334794732),new Point(161,542),new Point(1040.303203657277,-29.047074219986737)],[new Point(129.5,560.1865334794732),new Point(161,542),new Point(838.5,55),new Point(1004.696796342723,-140.95292578001326)],[new Point(129.5,560.1865334794732),new Point(1004.7206704591699,249.0398047033964)],[new Point(129.5,560.1865334794732),new Point(1037.27932954083,360.96019529660356)],[new Point(129.5,560.1865334794732),new Point(1004.7206704591699,360.96019529660356)],[new Point(129.5,560.1865334794732),new Point(161,542),new Point(728.25,118.65286717815624),new Point(1037.27932954083,249.0398047033964)],[new Point(129.5,560.1865334794732),new Point(129.5,523.8134665205268),new Point(471.13992102513606,-235.48983908715294)],[new Point(129.5,560.1865334794732),new Point(-10.29999999999994,246.4041879234696),new Point(-10.300000000000068,-66.40418792346955),new Point(588.4106157414747,-343.91180848474517)],[new Point(129.5,560.1865334794732),new Point(129.5,523.8134665205268),new Point(519.5893842585253,-191.08819151525486)],[new Point(129.5,560.1865334794732),new Point(-213.94893036447175,389.9986950947747),new Point(-283.73502185420614,242.3219565841044)],[new Point(129.5,560.1865334794732),new Point(-153.26497814579386,362.6780434158956)],[new Point(129.5,560.1865334794732),new Point(-213.94893036447175,389.9986950947747)],[new Point(129.5,560.1865334794732),new Point(-223.05106963552825,212.0013049052253)],[new Point(129.5,560.1865334794732),new Point(-107,-207),new Point(-190.49613893835684,-350.86824314212447)],[new Point(129.5,560.1865334794732),new Point(-107,-207)],[new Point(129.5,560.1865334794732),new Point(-296.99632055783536,-193.9142950057776)],[new Point(129.5,560.1865334794732),new Point(161,542),new Point(973,-420)],[new Point(129.5,560.1865334794732),new Point(161,542),new Point(721,-274.5077321642143)],[new Point(129.5,560.1865334794732),new Point(-10.29999999999994,246.4041879234696),new Point(-10.300000000000068,-66.40418792346955),new Point(721,-565.4922678357856)],[new Point(129.5,560.1865334794732),new Point(-143.5,650)],[new Point(129.5,560.1865334794732),new Point(-190.75,677.2798002192098)],[new Point(129.5,560.1865334794732),new Point(-190.75,622.7201997807902)],[new Point(129.5,560.1865334794732),new Point(161,542)],[new Point(129.5,560.1865334794732)],[new Point(129.5,560.1865334794732),new Point(129.5,523.8134665205268)],[new Point(129.5,560.1865334794732),new Point(584,356.3730669589464),new Point(647,320)],[new Point(129.5,560.1865334794732),new Point(584,356.3730669589464)],[new Point(129.5,560.1865334794732),new Point(584,283.6269330410536)],[new Point(129.5,560.1865334794732),new Point(584,283.6269330410536),new Point(838.5,55)],[new Point(129.5,560.1865334794732),new Point(584,283.6269330410536),new Point(728.25,118.65286717815624)],[new Point(129.5,560.1865334794732),new Point(129.5,523.8134665205268),new Point(728.25,-8.652867178156207)],[new Point(129.5,560.1865334794732),new Point(129.5,523.8134665205268),new Point(260.59999999999997,90)],[new Point(129.5,560.1865334794732),new Point(-10.29999999999994,246.4041879234696)],[new Point(129.5,560.1865334794732),new Point(-10.29999999999994,246.4041879234696),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(129.5,523.8134665205268),new Point(271,-479)],[new Point(129.5,523.8134665205268),new Point(360.0604335563131,-529.0018277777501)],[new Point(129.5,523.8134665205268),new Point(1055,664)],[new Point(129.5,523.8134665205268),new Point(784,674)],[new Point(129.5,523.8134665205268),new Point(417,656)],[new Point(129.5,523.8134665205268),new Point(129.5,560.1865334794732),new Point(203,759)],[new Point(129.5,523.8134665205268),new Point(56,674)],[new Point(129.5,523.8134665205268),new Point(-289.3991018391502,729.2006744090877)],[new Point(129.5,523.8134665205268),new Point(-381.4843460976219,649.1432030269882)],[new Point(129.5,523.8134665205268),new Point(-10.29999999999994,246.4041879234696),new Point(-89.03523617876226,-499.7368825942079)],[new Point(129.5,523.8134665205268),new Point(-200.96476382123774,-499.7368825942079),new Point(-200.96476382123774,-530.2631174057921)],[new Point(129.5,523.8134665205268),new Point(-200.96476382123774,-499.7368825942079)],[new Point(129.5,523.8134665205268),new Point(-10.29999999999994,246.4041879234696),new Point(-89.03523617876226,-530.2631174057921)],[new Point(129.5,523.8134665205268),new Point(1004.696796342723,-29.047074219986737)],[new Point(129.5,523.8134665205268),new Point(838.5,55),new Point(1004.696796342723,-140.95292578001326),new Point(1040.303203657277,-140.95292578001326)],[new Point(129.5,523.8134665205268),new Point(1040.303203657277,-29.047074219986737)],[new Point(129.5,523.8134665205268),new Point(838.5,55),new Point(1004.696796342723,-140.95292578001326)],[new Point(129.5,523.8134665205268),new Point(1004.7206704591699,249.0398047033964)],[new Point(129.5,523.8134665205268),new Point(1037.27932954083,360.96019529660356)],[new Point(129.5,523.8134665205268),new Point(1004.7206704591699,360.96019529660356)],[new Point(129.5,523.8134665205268),new Point(728.25,118.65286717815624),new Point(1037.27932954083,249.0398047033964)],[new Point(129.5,523.8134665205268),new Point(471.13992102513606,-235.48983908715294)],[new Point(129.5,523.8134665205268),new Point(-10.29999999999994,246.4041879234696),new Point(-10.300000000000068,-66.40418792346955),new Point(588.4106157414747,-343.91180848474517)],[new Point(129.5,523.8134665205268),new Point(519.5893842585253,-191.08819151525486)],[new Point(129.5,523.8134665205268),new Point(-213.94893036447175,389.9986950947747),new Point(-283.73502185420614,242.3219565841044)],[new Point(129.5,523.8134665205268),new Point(-153.26497814579386,362.6780434158956)],[new Point(129.5,523.8134665205268),new Point(-213.94893036447175,389.9986950947747)],[new Point(129.5,523.8134665205268),new Point(-223.05106963552825,212.0013049052253)],[new Point(129.5,523.8134665205268),new Point(-107,-207),new Point(-190.49613893835684,-350.86824314212447)],[new Point(129.5,523.8134665205268),new Point(-107,-207)],[new Point(129.5,523.8134665205268),new Point(-296.99632055783536,-193.9142950057776)],[new Point(129.5,523.8134665205268),new Point(973,-420)],[new Point(129.5,523.8134665205268),new Point(721,-274.5077321642143)],[new Point(129.5,523.8134665205268),new Point(-10.29999999999994,246.4041879234696),new Point(-10.300000000000068,-66.40418792346955),new Point(721,-565.4922678357856)],[new Point(129.5,523.8134665205268),new Point(-143.5,650)],[new Point(129.5,523.8134665205268),new Point(-190.75,677.2798002192098)],[new Point(129.5,523.8134665205268),new Point(-190.75,622.7201997807902)],[new Point(129.5,523.8134665205268),new Point(161,542)],[new Point(129.5,523.8134665205268),new Point(129.5,560.1865334794732)],[new Point(129.5,523.8134665205268)],[new Point(129.5,523.8134665205268),new Point(584,356.3730669589464),new Point(647,320)],[new Point(129.5,523.8134665205268),new Point(584,356.3730669589464)],[new Point(129.5,523.8134665205268),new Point(584,283.6269330410536)],[new Point(129.5,523.8134665205268),new Point(838.5,55)],[new Point(129.5,523.8134665205268),new Point(728.25,118.65286717815624)],[new Point(129.5,523.8134665205268),new Point(728.25,-8.652867178156207)],[new Point(129.5,523.8134665205268),new Point(260.59999999999997,90)],[new Point(129.5,523.8134665205268),new Point(-10.29999999999994,246.4041879234696)],[new Point(129.5,523.8134665205268),new Point(-10.29999999999994,246.4041879234696),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(647,320),new Point(271,-479)],[new Point(647,320),new Point(360.0604335563131,-529.0018277777501)],[new Point(647,320),new Point(1055,664)],[new Point(647,320),new Point(784,674)],[new Point(647,320),new Point(417,656)],[new Point(647,320),new Point(203,759)],[new Point(647,320),new Point(56,674)],[new Point(647,320),new Point(584,356.3730669589464),new Point(129.5,560.1865334794732),new Point(-289.3991018391502,729.2006744090877)],[new Point(647,320),new Point(584,356.3730669589464),new Point(-381.4843460976219,649.1432030269882)],[new Point(647,320),new Point(-89.03523617876226,-499.7368825942079)],[new Point(647,320),new Point(-200.96476382123774,-499.7368825942079),new Point(-200.96476382123774,-530.2631174057921)],[new Point(647,320),new Point(-200.96476382123774,-499.7368825942079)],[new Point(647,320),new Point(-89.03523617876226,-530.2631174057921)],[new Point(647,320),new Point(1004.696796342723,-29.047074219986737)],[new Point(647,320),new Point(1004.696796342723,-140.95292578001326),new Point(1040.303203657277,-140.95292578001326)],[new Point(647,320),new Point(1040.303203657277,-29.047074219986737)],[new Point(647,320),new Point(1004.696796342723,-140.95292578001326)],[new Point(647,320),new Point(1004.7206704591699,249.0398047033964)],[new Point(647,320),new Point(1004.7206704591699,360.96019529660356),new Point(1037.27932954083,360.96019529660356)],[new Point(647,320),new Point(1004.7206704591699,360.96019529660356)],[new Point(647,320),new Point(728.25,118.65286717815624),new Point(1037.27932954083,249.0398047033964)],[new Point(647,320),new Point(471.13992102513606,-235.48983908715294)],[new Point(647,320),new Point(728.25,-8.652867178156207),new Point(973,-420),new Point(721,-565.4922678357856),new Point(588.4106157414747,-343.91180848474517)],[new Point(647,320),new Point(519.5893842585253,-191.08819151525486)],[new Point(647,320),new Point(584,283.6269330410536),new Point(-223.05106963552825,212.0013049052253),new Point(-283.73502185420614,242.3219565841044)],[new Point(647,320),new Point(584,356.3730669589464),new Point(-153.26497814579386,362.6780434158956)],[new Point(647,320),new Point(584,356.3730669589464),new Point(-213.94893036447175,389.9986950947747)],[new Point(647,320),new Point(584,283.6269330410536),new Point(-223.05106963552825,212.0013049052253)],[new Point(647,320),new Point(-190.49613893835684,-350.86824314212447)],[new Point(647,320),new Point(-107,-207)],[new Point(647,320),new Point(-10.300000000000068,-66.40418792346955),new Point(-296.99632055783536,-193.9142950057776)],[new Point(647,320),new Point(728.25,-8.652867178156207),new Point(973,-420)],[new Point(647,320),new Point(721,-274.5077321642143)],[new Point(647,320),new Point(-10.300000000000068,-66.40418792346955),new Point(721,-565.4922678357856)],[new Point(647,320),new Point(584,356.3730669589464),new Point(129.5,523.8134665205268),new Point(-143.5,650)],[new Point(647,320),new Point(584,356.3730669589464),new Point(129.5,560.1865334794732),new Point(-190.75,677.2798002192098)],[new Point(647,320),new Point(584,356.3730669589464),new Point(-190.75,622.7201997807902)],[new Point(647,320),new Point(584,356.3730669589464),new Point(161,542)],[new Point(647,320),new Point(584,356.3730669589464),new Point(129.5,560.1865334794732)],[new Point(647,320),new Point(584,356.3730669589464),new Point(129.5,523.8134665205268)],[new Point(647,320)],[new Point(647,320),new Point(584,356.3730669589464)],[new Point(647,320),new Point(584,283.6269330410536)],[new Point(647,320),new Point(838.5,55)],[new Point(647,320),new Point(728.25,118.65286717815624)],[new Point(647,320),new Point(728.25,-8.652867178156207)],[new Point(647,320),new Point(260.59999999999997,90)],[new Point(647,320),new Point(584,283.6269330410536),new Point(-10.29999999999994,246.4041879234696)],[new Point(647,320),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(584,356.3730669589464),new Point(271,-479)],[new Point(584,356.3730669589464),new Point(360.0604335563131,-529.0018277777501)],[new Point(584,356.3730669589464),new Point(1055,664)],[new Point(584,356.3730669589464),new Point(784,674)],[new Point(584,356.3730669589464),new Point(417,656)],[new Point(584,356.3730669589464),new Point(203,759)],[new Point(584,356.3730669589464),new Point(56,674)],[new Point(584,356.3730669589464),new Point(129.5,560.1865334794732),new Point(-289.3991018391502,729.2006744090877)],[new Point(584,356.3730669589464),new Point(-381.4843460976219,649.1432030269882)],[new Point(584,356.3730669589464),new Point(-89.03523617876226,-499.7368825942079)],[new Point(584,356.3730669589464),new Point(-200.96476382123774,-499.7368825942079),new Point(-200.96476382123774,-530.2631174057921)],[new Point(584,356.3730669589464),new Point(-200.96476382123774,-499.7368825942079)],[new Point(584,356.3730669589464),new Point(-89.03523617876226,-530.2631174057921)],[new Point(584,356.3730669589464),new Point(647,320),new Point(1004.696796342723,-29.047074219986737)],[new Point(584,356.3730669589464),new Point(647,320),new Point(1004.696796342723,-140.95292578001326),new Point(1040.303203657277,-140.95292578001326)],[new Point(584,356.3730669589464),new Point(647,320),new Point(1040.303203657277,-29.047074219986737)],[new Point(584,356.3730669589464),new Point(647,320),new Point(1004.696796342723,-140.95292578001326)],[new Point(584,356.3730669589464),new Point(1004.7206704591699,249.0398047033964)],[new Point(584,356.3730669589464),new Point(1037.27932954083,360.96019529660356)],[new Point(584,356.3730669589464),new Point(1004.7206704591699,360.96019529660356)],[new Point(584,356.3730669589464),new Point(647,320),new Point(728.25,118.65286717815624),new Point(1037.27932954083,249.0398047033964)],[new Point(584,356.3730669589464),new Point(471.13992102513606,-235.48983908715294)],[new Point(584,356.3730669589464),new Point(260.59999999999997,90),new Point(-10.300000000000068,-66.40418792346955),new Point(588.4106157414747,-343.91180848474517)],[new Point(584,356.3730669589464),new Point(519.5893842585253,-191.08819151525486)],[new Point(584,356.3730669589464),new Point(-223.05106963552825,212.0013049052253),new Point(-283.73502185420614,242.3219565841044)],[new Point(584,356.3730669589464),new Point(-153.26497814579386,362.6780434158956)],[new Point(584,356.3730669589464),new Point(-213.94893036447175,389.9986950947747)],[new Point(584,356.3730669589464),new Point(-223.05106963552825,212.0013049052253)],[new Point(584,356.3730669589464),new Point(-190.49613893835684,-350.86824314212447)],[new Point(584,356.3730669589464),new Point(-107,-207)],[new Point(584,356.3730669589464),new Point(260.59999999999997,90),new Point(-10.300000000000068,-66.40418792346955),new Point(-296.99632055783536,-193.9142950057776)],[new Point(584,356.3730669589464),new Point(584,283.6269330410536),new Point(973,-420)],[new Point(584,356.3730669589464),new Point(584,283.6269330410536),new Point(721,-274.5077321642143)],[new Point(584,356.3730669589464),new Point(260.59999999999997,90),new Point(-10.300000000000068,-66.40418792346955),new Point(721,-565.4922678357856)],[new Point(584,356.3730669589464),new Point(129.5,523.8134665205268),new Point(-143.5,650)],[new Point(584,356.3730669589464),new Point(129.5,560.1865334794732),new Point(-190.75,677.2798002192098)],[new Point(584,356.3730669589464),new Point(-190.75,622.7201997807902)],[new Point(584,356.3730669589464),new Point(161,542)],[new Point(584,356.3730669589464),new Point(129.5,560.1865334794732)],[new Point(584,356.3730669589464),new Point(129.5,523.8134665205268)],[new Point(584,356.3730669589464),new Point(647,320)],[new Point(584,356.3730669589464)],[new Point(584,356.3730669589464),new Point(584,283.6269330410536)],[new Point(584,356.3730669589464),new Point(584,283.6269330410536),new Point(838.5,55)],[new Point(584,356.3730669589464),new Point(584,283.6269330410536),new Point(728.25,118.65286717815624)],[new Point(584,356.3730669589464),new Point(584,283.6269330410536),new Point(728.25,-8.652867178156207)],[new Point(584,356.3730669589464),new Point(260.59999999999997,90)],[new Point(584,356.3730669589464),new Point(-10.29999999999994,246.4041879234696)],[new Point(584,356.3730669589464),new Point(260.59999999999997,90),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(584,283.6269330410536),new Point(271,-479)],[new Point(584,283.6269330410536),new Point(360.0604335563131,-529.0018277777501)],[new Point(584,283.6269330410536),new Point(647,320),new Point(1055,664)],[new Point(584,283.6269330410536),new Point(584,356.3730669589464),new Point(784,674)],[new Point(584,283.6269330410536),new Point(417,656)],[new Point(584,283.6269330410536),new Point(203,759)],[new Point(584,283.6269330410536),new Point(56,674)],[new Point(584,283.6269330410536),new Point(-289.3991018391502,729.2006744090877)],[new Point(584,283.6269330410536),new Point(-381.4843460976219,649.1432030269882)],[new Point(584,283.6269330410536),new Point(-89.03523617876226,-499.7368825942079)],[new Point(584,283.6269330410536),new Point(-200.96476382123774,-499.7368825942079),new Point(-200.96476382123774,-530.2631174057921)],[new Point(584,283.6269330410536),new Point(-200.96476382123774,-499.7368825942079)],[new Point(584,283.6269330410536),new Point(-89.03523617876226,-530.2631174057921)],[new Point(584,283.6269330410536),new Point(1004.696796342723,-29.047074219986737)],[new Point(584,283.6269330410536),new Point(838.5,55),new Point(1004.696796342723,-140.95292578001326),new Point(1040.303203657277,-140.95292578001326)],[new Point(584,283.6269330410536),new Point(1040.303203657277,-29.047074219986737)],[new Point(584,283.6269330410536),new Point(838.5,55),new Point(1004.696796342723,-140.95292578001326)],[new Point(584,283.6269330410536),new Point(1004.7206704591699,249.0398047033964)],[new Point(584,283.6269330410536),new Point(1004.7206704591699,360.96019529660356),new Point(1037.27932954083,360.96019529660356)],[new Point(584,283.6269330410536),new Point(1004.7206704591699,360.96019529660356)],[new Point(584,283.6269330410536),new Point(728.25,118.65286717815624),new Point(1037.27932954083,249.0398047033964)],[new Point(584,283.6269330410536),new Point(471.13992102513606,-235.48983908715294)],[new Point(584,283.6269330410536),new Point(-10.300000000000068,-66.40418792346955),new Point(588.4106157414747,-343.91180848474517)],[new Point(584,283.6269330410536),new Point(519.5893842585253,-191.08819151525486)],[new Point(584,283.6269330410536),new Point(-223.05106963552825,212.0013049052253),new Point(-283.73502185420614,242.3219565841044)],[new Point(584,283.6269330410536),new Point(-153.26497814579386,362.6780434158956)],[new Point(584,283.6269330410536),new Point(-213.94893036447175,389.9986950947747)],[new Point(584,283.6269330410536),new Point(-223.05106963552825,212.0013049052253)],[new Point(584,283.6269330410536),new Point(-190.49613893835684,-350.86824314212447)],[new Point(584,283.6269330410536),new Point(-107,-207)],[new Point(584,283.6269330410536),new Point(-10.300000000000068,-66.40418792346955),new Point(-296.99632055783536,-193.9142950057776)],[new Point(584,283.6269330410536),new Point(973,-420)],[new Point(584,283.6269330410536),new Point(721,-274.5077321642143)],[new Point(584,283.6269330410536),new Point(-10.300000000000068,-66.40418792346955),new Point(721,-565.4922678357856)],[new Point(584,283.6269330410536),new Point(-143.5,650)],[new Point(584,283.6269330410536),new Point(-190.75,677.2798002192098)],[new Point(584,283.6269330410536),new Point(-190.75,622.7201997807902)],[new Point(584,283.6269330410536),new Point(161,542)],[new Point(584,283.6269330410536),new Point(129.5,560.1865334794732)],[new Point(584,283.6269330410536),new Point(129.5,523.8134665205268)],[new Point(584,283.6269330410536),new Point(647,320)],[new Point(584,283.6269330410536),new Point(584,356.3730669589464)],[new Point(584,283.6269330410536)],[new Point(584,283.6269330410536),new Point(838.5,55)],[new Point(584,283.6269330410536),new Point(728.25,118.65286717815624)],[new Point(584,283.6269330410536),new Point(728.25,-8.652867178156207)],[new Point(584,283.6269330410536),new Point(260.59999999999997,90)],[new Point(584,283.6269330410536),new Point(-10.29999999999994,246.4041879234696)],[new Point(584,283.6269330410536),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(838.5,55),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294),new Point(271,-479)],[new Point(838.5,55),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294),new Point(360.0604335563131,-529.0018277777501)],[new Point(838.5,55),new Point(1055,664)],[new Point(838.5,55),new Point(784,674)],[new Point(838.5,55),new Point(417,656)],[new Point(838.5,55),new Point(584,283.6269330410536),new Point(203,759)],[new Point(838.5,55),new Point(56,674)],[new Point(838.5,55),new Point(-143.5,650),new Point(-289.3991018391502,729.2006744090877)],[new Point(838.5,55),new Point(728.25,118.65286717815624),new Point(-381.4843460976219,649.1432030269882)],[new Point(838.5,55),new Point(-89.03523617876226,-499.7368825942079)],[new Point(838.5,55),new Point(-89.03523617876226,-530.2631174057921),new Point(-200.96476382123774,-530.2631174057921)],[new Point(838.5,55),new Point(728.25,-8.652867178156207),new Point(-200.96476382123774,-499.7368825942079)],[new Point(838.5,55),new Point(-89.03523617876226,-530.2631174057921)],[new Point(838.5,55),new Point(1004.696796342723,-29.047074219986737)],[new Point(838.5,55),new Point(1004.696796342723,-140.95292578001326),new Point(1040.303203657277,-140.95292578001326)],[new Point(838.5,55),new Point(1040.303203657277,-29.047074219986737)],[new Point(838.5,55),new Point(1004.696796342723,-140.95292578001326)],[new Point(838.5,55),new Point(1004.7206704591699,249.0398047033964)],[new Point(838.5,55),new Point(1004.7206704591699,360.96019529660356),new Point(1037.27932954083,360.96019529660356)],[new Point(838.5,55),new Point(1004.7206704591699,360.96019529660356)],[new Point(838.5,55),new Point(1037.27932954083,249.0398047033964)],[new Point(838.5,55),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294)],[new Point(838.5,55),new Point(973,-420),new Point(721,-565.4922678357856),new Point(588.4106157414747,-343.91180848474517)],[new Point(838.5,55),new Point(519.5893842585253,-191.08819151525486)],[new Point(838.5,55),new Point(728.25,118.65286717815624),new Point(-223.05106963552825,212.0013049052253),new Point(-283.73502185420614,242.3219565841044)],[new Point(838.5,55),new Point(728.25,118.65286717815624),new Point(-153.26497814579386,362.6780434158956)],[new Point(838.5,55),new Point(728.25,118.65286717815624),new Point(-213.94893036447175,389.9986950947747)],[new Point(838.5,55),new Point(728.25,118.65286717815624),new Point(-223.05106963552825,212.0013049052253)],[new Point(838.5,55),new Point(728.25,-8.652867178156207),new Point(-190.49613893835684,-350.86824314212447)],[new Point(838.5,55),new Point(728.25,-8.652867178156207),new Point(-107,-207)],[new Point(838.5,55),new Point(728.25,-8.652867178156207),new Point(-296.99632055783536,-193.9142950057776)],[new Point(838.5,55),new Point(973,-420)],[new Point(838.5,55),new Point(721,-274.5077321642143)],[new Point(838.5,55),new Point(728.25,-8.652867178156207),new Point(-10.300000000000068,-66.40418792346955),new Point(721,-565.4922678357856)],[new Point(838.5,55),new Point(-143.5,650)],[new Point(838.5,55),new Point(-190.75,677.2798002192098)],[new Point(838.5,55),new Point(-190.75,622.7201997807902)],[new Point(838.5,55),new Point(161,542)],[new Point(838.5,55),new Point(584,283.6269330410536),new Point(129.5,560.1865334794732)],[new Point(838.5,55),new Point(129.5,523.8134665205268)],[new Point(838.5,55),new Point(647,320)],[new Point(838.5,55),new Point(584,283.6269330410536),new Point(584,356.3730669589464)],[new Point(838.5,55),new Point(584,283.6269330410536)],[new Point(838.5,55)],[new Point(838.5,55),new Point(728.25,118.65286717815624)],[new Point(838.5,55),new Point(728.25,-8.652867178156207)],[new Point(838.5,55),new Point(728.25,118.65286717815624),new Point(260.59999999999997,90)],[new Point(838.5,55),new Point(728.25,118.65286717815624),new Point(-10.29999999999994,246.4041879234696)],[new Point(838.5,55),new Point(728.25,-8.652867178156207),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(728.25,118.65286717815624),new Point(271,-479)],[new Point(728.25,118.65286717815624),new Point(471.13992102513606,-235.48983908715294),new Point(360.0604335563131,-529.0018277777501)],[new Point(728.25,118.65286717815624),new Point(1055,664)],[new Point(728.25,118.65286717815624),new Point(784,674)],[new Point(728.25,118.65286717815624),new Point(647,320),new Point(417,656)],[new Point(728.25,118.65286717815624),new Point(203,759)],[new Point(728.25,118.65286717815624),new Point(56,674)],[new Point(728.25,118.65286717815624),new Point(-143.5,650),new Point(-289.3991018391502,729.2006744090877)],[new Point(728.25,118.65286717815624),new Point(-381.4843460976219,649.1432030269882)],[new Point(728.25,118.65286717815624),new Point(-89.03523617876226,-499.7368825942079)],[new Point(728.25,118.65286717815624),new Point(-200.96476382123774,-499.7368825942079),new Point(-200.96476382123774,-530.2631174057921)],[new Point(728.25,118.65286717815624),new Point(-200.96476382123774,-499.7368825942079)],[new Point(728.25,118.65286717815624),new Point(-89.03523617876226,-530.2631174057921)],[new Point(728.25,118.65286717815624),new Point(1004.696796342723,-29.047074219986737)],[new Point(728.25,118.65286717815624),new Point(838.5,55),new Point(1004.696796342723,-140.95292578001326),new Point(1040.303203657277,-140.95292578001326)],[new Point(728.25,118.65286717815624),new Point(1040.303203657277,-29.047074219986737)],[new Point(728.25,118.65286717815624),new Point(838.5,55),new Point(1004.696796342723,-140.95292578001326)],[new Point(728.25,118.65286717815624),new Point(1004.7206704591699,249.0398047033964)],[new Point(728.25,118.65286717815624),new Point(1004.7206704591699,360.96019529660356),new Point(1037.27932954083,360.96019529660356)],[new Point(728.25,118.65286717815624),new Point(1004.7206704591699,360.96019529660356)],[new Point(728.25,118.65286717815624),new Point(1037.27932954083,249.0398047033964)],[new Point(728.25,118.65286717815624),new Point(471.13992102513606,-235.48983908715294)],[new Point(728.25,118.65286717815624),new Point(728.25,-8.652867178156207),new Point(973,-420),new Point(721,-565.4922678357856),new Point(588.4106157414747,-343.91180848474517)],[new Point(728.25,118.65286717815624),new Point(519.5893842585253,-191.08819151525486)],[new Point(728.25,118.65286717815624),new Point(-223.05106963552825,212.0013049052253),new Point(-283.73502185420614,242.3219565841044)],[new Point(728.25,118.65286717815624),new Point(-153.26497814579386,362.6780434158956)],[new Point(728.25,118.65286717815624),new Point(-213.94893036447175,389.9986950947747)],[new Point(728.25,118.65286717815624),new Point(-223.05106963552825,212.0013049052253)],[new Point(728.25,118.65286717815624),new Point(-190.49613893835684,-350.86824314212447)],[new Point(728.25,118.65286717815624),new Point(-107,-207)],[new Point(728.25,118.65286717815624),new Point(-296.99632055783536,-193.9142950057776)],[new Point(728.25,118.65286717815624),new Point(728.25,-8.652867178156207),new Point(973,-420)],[new Point(728.25,118.65286717815624),new Point(721,-274.5077321642143)],[new Point(728.25,118.65286717815624),new Point(-10.300000000000068,-66.40418792346955),new Point(721,-565.4922678357856)],[new Point(728.25,118.65286717815624),new Point(-143.5,650)],[new Point(728.25,118.65286717815624),new Point(-190.75,677.2798002192098)],[new Point(728.25,118.65286717815624),new Point(-190.75,622.7201997807902)],[new Point(728.25,118.65286717815624),new Point(161,542)],[new Point(728.25,118.65286717815624),new Point(584,283.6269330410536),new Point(129.5,560.1865334794732)],[new Point(728.25,118.65286717815624),new Point(129.5,523.8134665205268)],[new Point(728.25,118.65286717815624),new Point(647,320)],[new Point(728.25,118.65286717815624),new Point(584,283.6269330410536),new Point(584,356.3730669589464)],[new Point(728.25,118.65286717815624),new Point(584,283.6269330410536)],[new Point(728.25,118.65286717815624),new Point(838.5,55)],[new Point(728.25,118.65286717815624)],[new Point(728.25,118.65286717815624),new Point(728.25,-8.652867178156207)],[new Point(728.25,118.65286717815624),new Point(260.59999999999997,90)],[new Point(728.25,118.65286717815624),new Point(-10.29999999999994,246.4041879234696)],[new Point(728.25,118.65286717815624),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(728.25,-8.652867178156207),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294),new Point(271,-479)],[new Point(728.25,-8.652867178156207),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294),new Point(360.0604335563131,-529.0018277777501)],[new Point(728.25,-8.652867178156207),new Point(728.25,118.65286717815624),new Point(1055,664)],[new Point(728.25,-8.652867178156207),new Point(728.25,118.65286717815624),new Point(784,674)],[new Point(728.25,-8.652867178156207),new Point(417,656)],[new Point(728.25,-8.652867178156207),new Point(203,759)],[new Point(728.25,-8.652867178156207),new Point(56,674)],[new Point(728.25,-8.652867178156207),new Point(-143.5,650),new Point(-289.3991018391502,729.2006744090877)],[new Point(728.25,-8.652867178156207),new Point(-381.4843460976219,649.1432030269882)],[new Point(728.25,-8.652867178156207),new Point(-89.03523617876226,-499.7368825942079)],[new Point(728.25,-8.652867178156207),new Point(-89.03523617876226,-530.2631174057921),new Point(-200.96476382123774,-530.2631174057921)],[new Point(728.25,-8.652867178156207),new Point(-200.96476382123774,-499.7368825942079)],[new Point(728.25,-8.652867178156207),new Point(-89.03523617876226,-530.2631174057921)],[new Point(728.25,-8.652867178156207),new Point(1004.696796342723,-29.047074219986737)],[new Point(728.25,-8.652867178156207),new Point(1004.696796342723,-140.95292578001326),new Point(1040.303203657277,-140.95292578001326)],[new Point(728.25,-8.652867178156207),new Point(1040.303203657277,-29.047074219986737)],[new Point(728.25,-8.652867178156207),new Point(1004.696796342723,-140.95292578001326)],[new Point(728.25,-8.652867178156207),new Point(838.5,55),new Point(1004.7206704591699,249.0398047033964)],[new Point(728.25,-8.652867178156207),new Point(838.5,55),new Point(1004.7206704591699,360.96019529660356),new Point(1037.27932954083,360.96019529660356)],[new Point(728.25,-8.652867178156207),new Point(838.5,55),new Point(1004.7206704591699,360.96019529660356)],[new Point(728.25,-8.652867178156207),new Point(838.5,55),new Point(1037.27932954083,249.0398047033964)],[new Point(728.25,-8.652867178156207),new Point(519.5893842585253,-191.08819151525486),new Point(471.13992102513606,-235.48983908715294)],[new Point(728.25,-8.652867178156207),new Point(973,-420),new Point(721,-565.4922678357856),new Point(588.4106157414747,-343.91180848474517)],[new Point(728.25,-8.652867178156207),new Point(519.5893842585253,-191.08819151525486)],[new Point(728.25,-8.652867178156207),new Point(-10.29999999999994,246.4041879234696),new Point(-223.05106963552825,212.0013049052253),new Point(-283.73502185420614,242.3219565841044)],[new Point(728.25,-8.652867178156207),new Point(-153.26497814579386,362.6780434158956)],[new Point(728.25,-8.652867178156207),new Point(-213.94893036447175,389.9986950947747)],[new Point(728.25,-8.652867178156207),new Point(-10.29999999999994,246.4041879234696),new Point(-223.05106963552825,212.0013049052253)],[new Point(728.25,-8.652867178156207),new Point(-190.49613893835684,-350.86824314212447)],[new Point(728.25,-8.652867178156207),new Point(-107,-207)],[new Point(728.25,-8.652867178156207),new Point(-296.99632055783536,-193.9142950057776)],[new Point(728.25,-8.652867178156207),new Point(973,-420)],[new Point(728.25,-8.652867178156207),new Point(721,-274.5077321642143)],[new Point(728.25,-8.652867178156207),new Point(-10.300000000000068,-66.40418792346955),new Point(721,-565.4922678357856)],[new Point(728.25,-8.652867178156207),new Point(-143.5,650)],[new Point(728.25,-8.652867178156207),new Point(129.5,523.8134665205268),new Point(-190.75,677.2798002192098)],[new Point(728.25,-8.652867178156207),new Point(-190.75,622.7201997807902)],[new Point(728.25,-8.652867178156207),new Point(161,542)],[new Point(728.25,-8.652867178156207),new Point(129.5,523.8134665205268),new Point(129.5,560.1865334794732)],[new Point(728.25,-8.652867178156207),new Point(129.5,523.8134665205268)],[new Point(728.25,-8.652867178156207),new Point(647,320)],[new Point(728.25,-8.652867178156207),new Point(584,283.6269330410536),new Point(584,356.3730669589464)],[new Point(728.25,-8.652867178156207),new Point(584,283.6269330410536)],[new Point(728.25,-8.652867178156207),new Point(838.5,55)],[new Point(728.25,-8.652867178156207),new Point(728.25,118.65286717815624)],[new Point(728.25,-8.652867178156207)],[new Point(728.25,-8.652867178156207),new Point(260.59999999999997,90)],[new Point(728.25,-8.652867178156207),new Point(-10.29999999999994,246.4041879234696)],[new Point(728.25,-8.652867178156207),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(260.59999999999997,90),new Point(271,-479)],[new Point(260.59999999999997,90),new Point(360.0604335563131,-529.0018277777501)],[new Point(260.59999999999997,90),new Point(584,356.3730669589464),new Point(1055,664)],[new Point(260.59999999999997,90),new Point(784,674)],[new Point(260.59999999999997,90),new Point(417,656)],[new Point(260.59999999999997,90),new Point(203,759)],[new Point(260.59999999999997,90),new Point(56,674)],[new Point(260.59999999999997,90),new Point(-289.3991018391502,729.2006744090877)],[new Point(260.59999999999997,90),new Point(-381.4843460976219,649.1432030269882)],[new Point(260.59999999999997,90),new Point(-89.03523617876226,-499.7368825942079)],[new Point(260.59999999999997,90),new Point(-200.96476382123774,-499.7368825942079),new Point(-200.96476382123774,-530.2631174057921)],[new Point(260.59999999999997,90),new Point(-200.96476382123774,-499.7368825942079)],[new Point(260.59999999999997,90),new Point(-89.03523617876226,-530.2631174057921)],[new Point(260.59999999999997,90),new Point(1004.696796342723,-29.047074219986737)],[new Point(260.59999999999997,90),new Point(1004.696796342723,-140.95292578001326),new Point(1040.303203657277,-140.95292578001326)],[new Point(260.59999999999997,90),new Point(1040.303203657277,-29.047074219986737)],[new Point(260.59999999999997,90),new Point(1004.696796342723,-140.95292578001326)],[new Point(260.59999999999997,90),new Point(1004.7206704591699,249.0398047033964)],[new Point(260.59999999999997,90),new Point(1004.7206704591699,360.96019529660356),new Point(1037.27932954083,360.96019529660356)],[new Point(260.59999999999997,90),new Point(1004.7206704591699,360.96019529660356)],[new Point(260.59999999999997,90),new Point(1037.27932954083,249.0398047033964)],[new Point(260.59999999999997,90),new Point(471.13992102513606,-235.48983908715294)],[new Point(260.59999999999997,90),new Point(-10.300000000000068,-66.40418792346955),new Point(588.4106157414747,-343.91180848474517)],[new Point(260.59999999999997,90),new Point(519.5893842585253,-191.08819151525486)],[new Point(260.59999999999997,90),new Point(-10.29999999999994,246.4041879234696),new Point(-223.05106963552825,212.0013049052253),new Point(-283.73502185420614,242.3219565841044)],[new Point(260.59999999999997,90),new Point(-153.26497814579386,362.6780434158956)],[new Point(260.59999999999997,90),new Point(129.5,523.8134665205268),new Point(-213.94893036447175,389.9986950947747)],[new Point(260.59999999999997,90),new Point(-10.29999999999994,246.4041879234696),new Point(-223.05106963552825,212.0013049052253)],[new Point(260.59999999999997,90),new Point(-190.49613893835684,-350.86824314212447)],[new Point(260.59999999999997,90),new Point(-107,-207)],[new Point(260.59999999999997,90),new Point(-10.300000000000068,-66.40418792346955),new Point(-296.99632055783536,-193.9142950057776)],[new Point(260.59999999999997,90),new Point(973,-420)],[new Point(260.59999999999997,90),new Point(721,-274.5077321642143)],[new Point(260.59999999999997,90),new Point(-10.300000000000068,-66.40418792346955),new Point(721,-565.4922678357856)],[new Point(260.59999999999997,90),new Point(-143.5,650)],[new Point(260.59999999999997,90),new Point(-190.75,622.7201997807902),new Point(-190.75,677.2798002192098)],[new Point(260.59999999999997,90),new Point(-190.75,622.7201997807902)],[new Point(260.59999999999997,90),new Point(161,542)],[new Point(260.59999999999997,90),new Point(129.5,523.8134665205268),new Point(129.5,560.1865334794732)],[new Point(260.59999999999997,90),new Point(129.5,523.8134665205268)],[new Point(260.59999999999997,90),new Point(647,320)],[new Point(260.59999999999997,90),new Point(584,356.3730669589464)],[new Point(260.59999999999997,90),new Point(584,283.6269330410536)],[new Point(260.59999999999997,90),new Point(728.25,118.65286717815624),new Point(838.5,55)],[new Point(260.59999999999997,90),new Point(728.25,118.65286717815624)],[new Point(260.59999999999997,90),new Point(728.25,-8.652867178156207)],[new Point(260.59999999999997,90)],[new Point(260.59999999999997,90),new Point(-10.29999999999994,246.4041879234696)],[new Point(260.59999999999997,90),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(-10.29999999999994,246.4041879234696),new Point(-10.300000000000068,-66.40418792346955),new Point(271,-479)],[new Point(-10.29999999999994,246.4041879234696),new Point(-10.300000000000068,-66.40418792346955),new Point(360.0604335563131,-529.0018277777501)],[new Point(-10.29999999999994,246.4041879234696),new Point(1055,664)],[new Point(-10.29999999999994,246.4041879234696),new Point(784,674)],[new Point(-10.29999999999994,246.4041879234696),new Point(417,656)],[new Point(-10.29999999999994,246.4041879234696),new Point(203,759)],[new Point(-10.29999999999994,246.4041879234696),new Point(56,674)],[new Point(-10.29999999999994,246.4041879234696),new Point(-289.3991018391502,729.2006744090877)],[new Point(-10.29999999999994,246.4041879234696),new Point(-381.4843460976219,649.1432030269882)],[new Point(-10.29999999999994,246.4041879234696),new Point(-89.03523617876226,-499.7368825942079)],[new Point(-10.29999999999994,246.4041879234696),new Point(-107,-207),new Point(-200.96476382123774,-499.7368825942079),new Point(-200.96476382123774,-530.2631174057921)],[new Point(-10.29999999999994,246.4041879234696),new Point(-107,-207),new Point(-200.96476382123774,-499.7368825942079)],[new Point(-10.29999999999994,246.4041879234696),new Point(-89.03523617876226,-530.2631174057921)],[new Point(-10.29999999999994,246.4041879234696),new Point(728.25,-8.652867178156207),new Point(1004.696796342723,-29.047074219986737)],[new Point(-10.29999999999994,246.4041879234696),new Point(1004.696796342723,-140.95292578001326),new Point(1040.303203657277,-140.95292578001326)],[new Point(-10.29999999999994,246.4041879234696),new Point(728.25,-8.652867178156207),new Point(1040.303203657277,-29.047074219986737)],[new Point(-10.29999999999994,246.4041879234696),new Point(1004.696796342723,-140.95292578001326)],[new Point(-10.29999999999994,246.4041879234696),new Point(1004.7206704591699,249.0398047033964)],[new Point(-10.29999999999994,246.4041879234696),new Point(584,283.6269330410536),new Point(1004.7206704591699,360.96019529660356),new Point(1037.27932954083,360.96019529660356)],[new Point(-10.29999999999994,246.4041879234696),new Point(584,283.6269330410536),new Point(1004.7206704591699,360.96019529660356)],[new Point(-10.29999999999994,246.4041879234696),new Point(1037.27932954083,249.0398047033964)],[new Point(-10.29999999999994,246.4041879234696),new Point(260.59999999999997,90),new Point(471.13992102513606,-235.48983908715294)],[new Point(-10.29999999999994,246.4041879234696),new Point(-10.300000000000068,-66.40418792346955),new Point(588.4106157414747,-343.91180848474517)],[new Point(-10.29999999999994,246.4041879234696),new Point(260.59999999999997,90),new Point(519.5893842585253,-191.08819151525486)],[new Point(-10.29999999999994,246.4041879234696),new Point(-223.05106963552825,212.0013049052253),new Point(-283.73502185420614,242.3219565841044)],[new Point(-10.29999999999994,246.4041879234696),new Point(-153.26497814579386,362.6780434158956)],[new Point(-10.29999999999994,246.4041879234696),new Point(-190.75,622.7201997807902),new Point(-213.94893036447175,389.9986950947747)],[new Point(-10.29999999999994,246.4041879234696),new Point(-223.05106963552825,212.0013049052253)],[new Point(-10.29999999999994,246.4041879234696),new Point(-107,-207),new Point(-190.49613893835684,-350.86824314212447)],[new Point(-10.29999999999994,246.4041879234696),new Point(-107,-207)],[new Point(-10.29999999999994,246.4041879234696),new Point(-296.99632055783536,-193.9142950057776)],[new Point(-10.29999999999994,246.4041879234696),new Point(260.59999999999997,90),new Point(973,-420)],[new Point(-10.29999999999994,246.4041879234696),new Point(260.59999999999997,90),new Point(721,-274.5077321642143)],[new Point(-10.29999999999994,246.4041879234696),new Point(-10.300000000000068,-66.40418792346955),new Point(721,-565.4922678357856)],[new Point(-10.29999999999994,246.4041879234696),new Point(-143.5,650)],[new Point(-10.29999999999994,246.4041879234696),new Point(-190.75,622.7201997807902),new Point(-190.75,677.2798002192098)],[new Point(-10.29999999999994,246.4041879234696),new Point(-190.75,622.7201997807902)],[new Point(-10.29999999999994,246.4041879234696),new Point(161,542)],[new Point(-10.29999999999994,246.4041879234696),new Point(129.5,560.1865334794732)],[new Point(-10.29999999999994,246.4041879234696),new Point(129.5,523.8134665205268)],[new Point(-10.29999999999994,246.4041879234696),new Point(584,283.6269330410536),new Point(647,320)],[new Point(-10.29999999999994,246.4041879234696),new Point(584,356.3730669589464)],[new Point(-10.29999999999994,246.4041879234696),new Point(584,283.6269330410536)],[new Point(-10.29999999999994,246.4041879234696),new Point(728.25,118.65286717815624),new Point(838.5,55)],[new Point(-10.29999999999994,246.4041879234696),new Point(728.25,118.65286717815624)],[new Point(-10.29999999999994,246.4041879234696),new Point(728.25,-8.652867178156207)],[new Point(-10.29999999999994,246.4041879234696),new Point(260.59999999999997,90)],[new Point(-10.29999999999994,246.4041879234696)],[new Point(-10.29999999999994,246.4041879234696),new Point(-10.300000000000068,-66.40418792346955)]],[[new Point(-10.300000000000068,-66.40418792346955),new Point(271,-479)],[new Point(-10.300000000000068,-66.40418792346955),new Point(360.0604335563131,-529.0018277777501)],[new Point(-10.300000000000068,-66.40418792346955),new Point(260.59999999999997,90),new Point(584,356.3730669589464),new Point(1055,664)],[new Point(-10.300000000000068,-66.40418792346955),new Point(260.59999999999997,90),new Point(784,674)],[new Point(-10.300000000000068,-66.40418792346955),new Point(260.59999999999997,90),new Point(417,656)],[new Point(-10.300000000000068,-66.40418792346955),new Point(-10.29999999999994,246.4041879234696),new Point(203,759)],[new Point(-10.300000000000068,-66.40418792346955),new Point(-10.29999999999994,246.4041879234696),new Point(56,674)],[new Point(-10.300000000000068,-66.40418792346955),new Point(-153.26497814579386,362.6780434158956),new Point(-289.3991018391502,729.2006744090877)],[new Point(-10.300000000000068,-66.40418792346955),new Point(-153.26497814579386,362.6780434158956),new Point(-381.4843460976219,649.1432030269882)],[new Point(-10.300000000000068,-66.40418792346955),new Point(-89.03523617876226,-499.7368825942079)],[new Point(-10.300000000000068,-66.40418792346955),new Point(-200.96476382123774,-499.7368825942079),new Point(-200.96476382123774,-530.2631174057921)],[new Point(-10.300000000000068,-66.40418792346955),new Point(-200.96476382123774,-499.7368825942079)],[new Point(-10.300000000000068,-66.40418792346955),new Point(-89.03523617876226,-530.2631174057921)],[new Point(-10.300000000000068,-66.40418792346955),new Point(1004.696796342723,-29.047074219986737)],[new Point(-10.300000000000068,-66.40418792346955),new Point(1004.696796342723,-140.95292578001326),new Point(1040.303203657277,-140.95292578001326)],[new Point(-10.300000000000068,-66.40418792346955),new Point(728.25,-8.652867178156207),new Point(1040.303203657277,-29.047074219986737)],[new Point(-10.300000000000068,-66.40418792346955),new Point(1004.696796342723,-140.95292578001326)],[new Point(-10.300000000000068,-66.40418792346955),new Point(1004.7206704591699,249.0398047033964)],[new Point(-10.300000000000068,-66.40418792346955),new Point(1004.7206704591699,360.96019529660356),new Point(1037.27932954083,360.96019529660356)],[new Point(-10.300000000000068,-66.40418792346955),new Point(1004.7206704591699,360.96019529660356)],[new Point(-10.300000000000068,-66.40418792346955),new Point(1037.27932954083,249.0398047033964)],[new Point(-10.300000000000068,-66.40418792346955),new Point(471.13992102513606,-235.48983908715294)],[new Point(-10.300000000000068,-66.40418792346955),new Point(588.4106157414747,-343.91180848474517)],[new Point(-10.300000000000068,-66.40418792346955),new Point(519.5893842585253,-191.08819151525486)],[new Point(-10.300000000000068,-66.40418792346955),new Point(-283.73502185420614,242.3219565841044)],[new Point(-10.300000000000068,-66.40418792346955),new Point(-153.26497814579386,362.6780434158956)],[new Point(-10.300000000000068,-66.40418792346955),new Point(-190.75,622.7201997807902),new Point(-213.94893036447175,389.9986950947747)],[new Point(-10.300000000000068,-66.40418792346955),new Point(-223.05106963552825,212.0013049052253)],[new Point(-10.300000000000068,-66.40418792346955),new Point(-190.49613893835684,-350.86824314212447)],[new Point(-10.300000000000068,-66.40418792346955),new Point(-107,-207)],[new Point(-10.300000000000068,-66.40418792346955),new Point(-296.99632055783536,-193.9142950057776)],[new Point(-10.300000000000068,-66.40418792346955),new Point(721,-565.4922678357856),new Point(973,-420)],[new Point(-10.300000000000068,-66.40418792346955),new Point(260.59999999999997,90),new Point(721,-274.5077321642143)],[new Point(-10.300000000000068,-66.40418792346955),new Point(721,-565.4922678357856)],[new Point(-10.300000000000068,-66.40418792346955),new Point(-143.5,650)],[new Point(-10.300000000000068,-66.40418792346955),new Point(-190.75,622.7201997807902),new Point(-190.75,677.2798002192098)],[new Point(-10.300000000000068,-66.40418792346955),new Point(-190.75,622.7201997807902)],[new Point(-10.300000000000068,-66.40418792346955),new Point(-10.29999999999994,246.4041879234696),new Point(161,542)],[new Point(-10.300000000000068,-66.40418792346955),new Point(-10.29999999999994,246.4041879234696),new Point(129.5,560.1865334794732)],[new Point(-10.300000000000068,-66.40418792346955),new Point(-10.29999999999994,246.4041879234696),new Point(129.5,523.8134665205268)],[new Point(-10.300000000000068,-66.40418792346955),new Point(647,320)],[new Point(-10.300000000000068,-66.40418792346955),new Point(260.59999999999997,90),new Point(584,356.3730669589464)],[new Point(-10.300000000000068,-66.40418792346955),new Point(584,283.6269330410536)],[new Point(-10.300000000000068,-66.40418792346955),new Point(728.25,-8.652867178156207),new Point(838.5,55)],[new Point(-10.300000000000068,-66.40418792346955),new Point(728.25,118.65286717815624)],[new Point(-10.300000000000068,-66.40418792346955),new Point(728.25,-8.652867178156207)],[new Point(-10.300000000000068,-66.40418792346955),new Point(260.59999999999997,90)],[new Point(-10.300000000000068,-66.40418792346955),new Point(-10.29999999999994,246.4041879234696)],[new Point(-10.300000000000068,-66.40418792346955)]]]
			);*/

			//NOTE--The above line is too freaking long.  It's like, so long.  Pages probably.  Contains all of the path information.
			/*
			var sp:Sprite = new Sprite();
			totalLayer.addChild(sp);
			sp.graphics.lineStyle(1, 255);
			var pts:Array = [new Point(271, -479), new Point(360.0604335563131, -529.0018277777501), new Point(1055, 664), new Point(784, 674), new Point(417, 656), new Point(203, 759), new Point(56, 674), new Point( -289.3991018391502, 729.2006744090877), new Point( -381.4843460976219, 649.1432030269882), new Point( -89.03523617876226, -499.7368825942079), new Point( -200.96476382123774, -530.2631174057921), new Point( -200.96476382123774, -499.7368825942079), new Point( -89.03523617876226, -530.2631174057921), new Point(1004.696796342723, -29.047074219986737), new Point(1040.303203657277, -140.95292578001326), new Point(1040.303203657277, -29.047074219986737), new Point(1004.696796342723, -140.95292578001326), new Point(1004.7206704591699, 249.0398047033964), new Point(1037.27932954083, 360.96019529660356), new Point(1004.7206704591699, 360.96019529660356), new Point(1037.27932954083, 249.0398047033964), new Point(471.13992102513606, -235.48983908715294), new Point(588.4106157414747, -343.91180848474517), new Point(519.5893842585253, -191.08819151525486), new Point( -283.73502185420614, 242.3219565841044), new Point( -153.26497814579386, 362.6780434158956), new Point( -213.94893036447175, 389.9986950947747), new Point( -223.05106963552825, 212.0013049052253), new Point( -190.49613893835684, -350.86824314212447), new Point( -107, -207), new Point( -296.99632055783536, -193.9142950057776), new Point(973, -420), new Point(721, -274.5077321642143), new Point(721, -565.4922678357856), new Point( -143.5, 650), new Point( -190.75, 677.2798002192098), new Point( -190.75, 622.7201997807902), new Point(161, 542), new Point(129.5, 560.1865334794732), new Point(129.5, 523.8134665205268), new Point(647, 320), new Point(584, 356.3730669589464), new Point(584, 283.6269330410536), new Point(838.5, 55), new Point(728.25, 118.65286717815624), new Point(728.25, -8.652867178156207), new Point(260.59999999999997, 90), new Point( -10.29999999999994, 246.4041879234696), new Point( -10.300000000000068, -66.40418792346955)];
			for (var a:uint = 0; a < pts.length; a++) {//draws the points
				sp.graphics.drawCircle(pts[a].x, pts[a].y, 5);
			}*/
			
			//levelGen(1);
			leveltext.text = "Level " + numtotext(Global.level);
			var currentTemp:uint = 51;	//only used to decrement the text size.  size is not readable from textformat
			do{	//put as a do/while so that the size will be reset to 50, regardless of the previous size (if the previous word was longer)
				currentTemp--;
				leveltext.defaultTextFormat = new TextFormat("batik", currentTemp, 0xFFFFFF);
				leveltext.text = leveltext.text;	//needed to refresh the text
			}while(leveltext.textWidth > 450);
			leveltext.x = -leveltext.textWidth;
			addChild(leveltext);
			SmoothTween.add(leveltext, new Point((500 - leveltext.textWidth) / 2, leveltext.y), 500);
			var gd:StarWarsClock = new StarWarsClock(new TextFormat("batik", 24, 0xFFFFFF), 500, 5, function():void { levelGen(Global.level); stage.focus = null; SmoothTween.add(leveltext, new Point(500, leveltext.y), 500, function():void { removeChild(leveltext); stage.focus = null; } ) } );
			
			addChild(gd);
			gd.x = 250;
			gd.y = 250;
			
			AmbientZombies.uprising();
			AmbientZombies.update(50);
			
			/*
			var z:DestructableMeleeFighter = new Longarm(zom);
			z.x = 200;
			z.y = 200;
			zombieLayer.addChild(z);
			*/
			
			/*Point Indicator.*/
			//addChild(moneyBar);
			
			//Sets up the health indicator
			[Embed(source = '../graphics/health indicator/1.png')]const hp1:Class;
			[Embed(source = '../graphics/health indicator/2.png')]const hp2:Class;
			[Embed(source = '../graphics/health indicator/3.png')]const hp3:Class;
			[Embed(source = '../graphics/health indicator/4.png')]const hp4:Class;
			[Embed(source = '../graphics/health indicator/5.png')]const hp5:Class;
			[Embed(source = '../graphics/health indicator/6.png')]const hp6:Class;
			[Embed(source='../graphics/health indicator/7.png')]const hp7:Class;
			healthIndicator = new Clip(0, [new hp1(), new hp2(), new hp3(), new hp4(), new hp5(), new hp6(), new hp7()]);
			healthIndicator.x = 450;
			healthIndicator.y = 450;
			addChild(healthIndicator);
			jim.healthIndicator = healthIndicator;
			jim.health = 6;
			
			ShopMenu.exitFunction = exitMenu;
			
			enableKeys();
			enableMouse();
			
			removeChild(back);
			/*
			reverseBurn = new Clip();
			for (var i:uint = 0; i < whiteBurn.totalFrames; i++) {
				reverseBurn.insertFrame(whiteBurn.getFrame(i), 1);
			}
			reverseBurn.frameRate = 30;
			reverseBurn.loop = false;
			reverseBurn.x = 250;
			reverseBurn.y = 250;
			reverseBurn.scaleX = 2;
			reverseBurn.scaleY = 2;
			reverseBurn.onComplete = decompose;
			addChild(reverseBurn);
			*/
			//removeChild(whiteBurn); whiteBurn = null;
			
			//whiteBurn.frameRate = -10;
			addChild(whiteBurn);	//children need to be re-added, because they are moved to the bottom of the child stack.
			addChild(txLoad);
			//addChild(tx2);
			
			whiteBurn.currentFrame--;
			whiteBurn.frameRate = -30;
			whiteBurn.onComplete = decompose;
			
			/*
			var reverseMask:Clip = new Clip();
			for (i = 0; i < whiteMask.totalFrames; i++) {
				reverseMask.insertFrame(whiteMask.getFrame(i), 1);
			}
			reverseMask.frameRate = 30;
			reverseMask.x = 250;
			reverseMask.y = 250;
			reverseMask.scaleX = 2;
			reverseMask.scaleY = 2;
			txLoad.mask = reverseMask;
			addChild(txLoad);
			whiteMask = null;
			//enterMenu();
			*/
			//whiteMask.currentFrame -= 2;
			whiteMask.currentFrame = whiteMask.totalFrames - 2;
			whiteMask.frameRate = -30;
			removeChild(cursor);
			cursor = crosshair;
			addChild(cursor);
		}
		public function enterMenu():void {
			disableKeys();
			disableMouse();
			addChild(Global.shopMenu);
			Global.shopMenu.x = -600;
			Global.shopMenu.updateMoney();
			Global.shopMenu.fresh();
			SmoothTween.add(Global.shopMenu, new Point(), 200);
			songChannel = startingSong.play(0, int.MAX_VALUE, new SoundTransform(.2));
			removeChild(cursor);
			cursor = hand;
			addChild(cursor);
		}
		public function exitMenu():void {
			enableKeys();
			enableMouse();
			stage.focus = null;	//makes sure key events dont stall.
			jim.health = 7;
			
			SmoothTween.add(Global.shopMenu, new Point(540), 200, disableMenu);
			
			Global.level++;	//next level
			leveltext.text = "Level " + Global.level;
			leveltext.x = -leveltext.textWidth;
			addChild(leveltext);
			SmoothTween.add(leveltext, new Point((500 - leveltext.textWidth) / 2, leveltext.y), 500);
			var b:StarWarsClock = new StarWarsClock(new TextFormat("batik", 24, 0xFFFFFF), 500, 5, function():void { levelGen(Global.level); stage.focus = null; SmoothTween.add(leveltext, new Point(500, leveltext.y), 500, function():void { removeChild(leveltext); stage.focus = null; } ) } );
			b.x = 225;
			b.y = 235;
			addChild(b);
			
			AmbientZombies.uprising();
			AmbientZombies.update(50);
			var t:Timer = new Timer(50, 20);
			t.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void {songChannel.soundTransform = new SoundTransform(songChannel.soundTransform.volume - .011)});
			t.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent):void {songChannel.stop()});
			t.start();
			jim.setState("pistol");	//Resets the stats after shopping.
			gunBox.currentFrame = 0;
			removeChild(cursor);
			cursor = crosshair;
			addChild(cursor);
			
			retemp = new SaveFile();
			retemp.saveGlobal();
		}
		public function disableMenu():void {
			stage.focus = null;
			removeChild(Global.shopMenu);
		}
		
		public function visuals():void {
			//block		ocean water
			[Embed(source = '../graphics/environment/ocean/frame1.jpg')]const oceanwater1:Class;
			[Embed(source = '../graphics/environment/ocean/frame2.jpg')]const oceanwater2:Class;
			[Embed(source = '../graphics/environment/ocean/frame3.jpg')]const oceanwater3:Class;
			var ocean1:FadeBlender = new FadeBlender([new oceanwater1(), new oceanwater2(), new oceanwater3()], .9, 3, 10000);
			ocean1.y = -1000;
			ocean1.x = -1000;
			oceanLayer.addChild(ocean1);
			var ocean2:FadeBlender = new FadeBlender([new oceanwater1(), new oceanwater2(), new oceanwater3()], .9, 3, 10000);
			ocean2.y = -1000;
			ocean2.x = -500;
			oceanLayer.addChild(ocean2);
			var ocean3:FadeBlender = new FadeBlender([new oceanwater1(), new oceanwater2(), new oceanwater3()], .9, 3, 10000);
			ocean3.y = -1000;
			ocean3.x = 0;
			oceanLayer.addChild(ocean3);
			var ocean4:FadeBlender = new FadeBlender([new oceanwater1(), new oceanwater2(), new oceanwater3()], .9, 3, 10000);
			ocean4.y = -1000;
			ocean4.x = 500;
			oceanLayer.addChild(ocean4);
			var ocean5:FadeBlender = new FadeBlender([new oceanwater1(), new oceanwater2(), new oceanwater3()], .9, 3, 10000);
			ocean5.y = -1000;
			ocean5.x = 1000;
			oceanLayer.addChild(ocean5);
			var ocean6:FadeBlender = new FadeBlender([new oceanwater1(), new oceanwater2(), new oceanwater3()], .9, 3, 10000);
			ocean6.y = -1000;
			ocean6.x = 1500;
			ocean6.rotation = 90;
			oceanLayer.addChild(ocean6);
			var ocean7:FadeBlender = new FadeBlender([new oceanwater1(), new oceanwater2(), new oceanwater3()], .9, 3, 10000);
			ocean7.y = -500;
			ocean7.x = 1500;
			ocean7.rotation = 90;
			oceanLayer.addChild(ocean7);
			var ocean8:FadeBlender = new FadeBlender([new oceanwater1(), new oceanwater2(), new oceanwater3()], .9, 3, 10000);
			ocean8.y = 0;
			ocean8.x = 1500;
			ocean8.rotation = 90;
			oceanLayer.addChild(ocean8);
			var ocean9:FadeBlender = new FadeBlender([new oceanwater1(), new oceanwater2(), new oceanwater3()], .9, 3, 10000);
			ocean9.y = 500;
			ocean9.x = 1500;
			ocean9.rotation = 90;
			oceanLayer.addChild(ocean9);
			var ocean10:FadeBlender = new FadeBlender([new oceanwater1(), new oceanwater2(), new oceanwater3()], .9, 3, 10000);
			ocean10.y = 1000;
			ocean10.x = 1500;
			ocean10.rotation = 90;
			oceanLayer.addChild(ocean10);
			//end
			
			//block 	Sea Rocks
			[Embed(source = '../graphics/environment/searocks.png')]const crocks:Class;
			var searocks:Bitmap = new crocks();
			searocks.y = -875;
			searocks.x = -800;
			environment.addChild(searocks);
			var searocks2:Bitmap = new crocks();
			searocks2.y = -875;
			searocks2.x = searocks.x + searocks.width - 35;
			environment.addChild(searocks2);
			var searocks3:Bitmap = new crocks();
			searocks3.y = -875;
			searocks3.x = searocks2.x + searocks2.width - 35;
			environment.addChild(searocks3);
			var searocks4andhalf:Bitmap = new crocks();
			searocks4andhalf.x = 550;
			searocks4andhalf.y = -700;
			environment.addChild(searocks4andhalf);
			var searocks4:Bitmap = new crocks();
			searocks4.x = 1400;
			searocks4.y = -750;
			searocks4.rotation = 90;
			environment.addChild(searocks4);
			var searocks5:Bitmap = new crocks();
			searocks5.x = 1400;
			searocks5.y = -75;
			searocks5.rotation = 90;
			environment.addChild(searocks5);
			var searocks6:Bitmap = new crocks();
			searocks6.x = 1400;
			searocks6.y = 625;
			searocks6.rotation = 90;
			environment.addChild(searocks6);
			var searocks7:Bitmap = new crocks();
			searocks7.x = 1400;
			searocks7.y = 1325;
			searocks7.rotation = 90;
			environment.addChild(searocks7);
			//end			
			
			//block		Grass Patches
			[Embed(source='../graphics/environment/grass.jpg')]const grassPatch:Class;
			var grass:Bitmap = new grassPatch();
			environment.addChild(grass);
			var grass2:Bitmap = new grassPatch();
			grass2.x = grass.x + grass.width;
			environment.addChild(grass2);
			var grass3:Bitmap = new grassPatch();
			grass3.y = -500;
			environment.addChild(grass3);
			var grass4:Bitmap = new grassPatch();
			grass4.y = -500;
			grass4.x = 500;
			environment.addChild(grass4);
			var grass5:Bitmap = new grassPatch();
			grass5.y = -500;
			grass5.x = -500;
			environment.addChild(grass5);
			var grass6:Bitmap = new grassPatch();
			grass6.x = -500;
			environment.addChild(grass6);
			var grass7:Bitmap = new grassPatch();
			grass7.x = -500;
			grass7.y = 500;
			environment.addChild(grass7);
			var grass8:Bitmap = new grassPatch();
			grass8.x = 0;
			grass8.y = 500;
			environment.addChild(grass8);
			var grass9:Bitmap = new grassPatch();
			grass9.x = 500;
			grass9.y = 500;
			environment.addChild(grass9);
			//end
			
			//block		dirt patch
			[Embed(source = '../graphics/environment/dirtpatch.png')]const drtpatch:Class;
			var dirtpatch:Bitmap = new drtpatch();
			dirtpatch.x = 525;
			dirtpatch.y = -380;
			environment.addChild(dirtpatch);
			var dirtpatch2:Bitmap = new drtpatch();
			dirtpatch2.x = 530;
			dirtpatch2.y = 270;
			environment.addChild(dirtpatch2);
			var dirtpatch3:Bitmap = new drtpatch();
			dirtpatch3.x = 60;
			dirtpatch3.y = 470;
			environment.addChild(dirtpatch3);
			var dirtpatch4:Bitmap = new drtpatch();
			dirtpatch4.x = -200;
			dirtpatch4.y = 615;
			dirtpatch4.scaleX = dirtpatch4.scaleY = .5;
			environment.addChild(dirtpatch4);
			var dirtpatch5:Bitmap = new drtpatch();
			dirtpatch5.x = -280;
			dirtpatch5.y = -325;
			environment.addChild(dirtpatch5);
			//end
			
			//block 	dirt forest
			[Embed(source = '../graphics/environment/dirt blend.png')]const dirtgrnd:Class;
			var dirtGround:Bitmap = new dirtgrnd();
			dirtGround.y = 714;
			dirtGround.x = -500;
			environment.addChild(dirtGround);
			var dirtGround2:Bitmap = new dirtgrnd();
			dirtGround2.y = 714;
			environment.addChild(dirtGround2);
			var dirtGround3:Bitmap = new dirtgrnd();
			dirtGround3.y = 714;
			dirtGround3.x = 500;
			environment.addChild(dirtGround3);
			var dirtGround4:Bitmap = new dirtgrnd();
			dirtGround4.x = 0;
			dirtGround4.y = 1214;
			dirtGround4.rotation = 180;
			environment.addChild(dirtGround4);
			var dirtGround5:Bitmap = new dirtgrnd();
			dirtGround5.x = 500;
			dirtGround5.y = 1214;
			dirtGround5.rotation = 180;
			environment.addChild(dirtGround5);
			var dirtGround6:Bitmap = new dirtgrnd();
			dirtGround6.x = 1000;
			dirtGround6.y = 1214;
			dirtGround6.rotation = 180;
			environment.addChild(dirtGround6);
			var dirtGround7:Bitmap = new dirtgrnd();
			dirtGround7.x = -830;
			dirtGround7.scaleY = 1.2
			dirtGround7.rotation = -90;
			environment.addChild(dirtGround7);
			var dirtGround8:Bitmap = new dirtgrnd();
			dirtGround8.x = -830;
			dirtGround8.y = 500;
			dirtGround8.scaleY = 1.2
			dirtGround8.rotation = -90;
			environment.addChild(dirtGround8);
			var dirtGround9:Bitmap = new dirtgrnd();
			dirtGround9.x = -830;
			dirtGround9.y = 1000;
			dirtGround9.scaleY = 1.2
			dirtGround9.rotation = -90;
			environment.addChild(dirtGround9);
			var dirtGround10:Bitmap = new dirtgrnd();
			dirtGround10.x = -830;
			dirtGround10.y = 1500;
			dirtGround10.scaleY = 1.2
			dirtGround10.rotation = -90;
			environment.addChild(dirtGround10);
			//end
			
			//block 	DirtPath
			[Embed(source='../graphics/environment/dirth path.png')]const doity:Class;
			var dirtPath:Bitmap = new doity();
			environment.addChild(dirtPath);
			dirtPath.y = -500;
			dirtPath.x = -50;
			//end
			
			//block		brick path
			[Embed(source = '../graphics/environment/brick path.png')]const brckpth:Class;
			var brickPath:Bitmap = new brckpth();
			brickPath.y = -480;
			brickPath.x = -500;
			brickPath.rotation = -90;
			environment.addChild(brickPath);
			var brickPath2:Bitmap = new brckpth();
			brickPath2.y = -480;
			brickPath2.x = brickPath.x + brickPath.width;
			brickPath2.rotation = -90;
			environment.addChild(brickPath2);
			var brickPath3:Bitmap = new brckpth();
			brickPath3.y = -480;
			brickPath3.x = 412;
			brickPath3.rotation = -90;
			environment.addChild(brickPath3);
			var brickPath4:Bitmap = new brckpth();
			brickPath4.y = -500;
			brickPath4.x = 991;
			environment.addChild(brickPath4);
			var brickPath5:Bitmap = new brckpth();
			brickPath5.y = 88;
			brickPath5.x = 991;
			environment.addChild(brickPath5);
			var brickPath6:Bitmap = new brckpth();
			brickPath6.y = 676;
			brickPath6.x = 991;
			environment.addChild(brickPath6);
			var brickPath7:Bitmap = new brckpth();
			brickPath7.y = -480;
			brickPath7.x = -1088;
			brickPath7.rotation = -90;
			environment.addChild(brickPath7);
			//end
			
			//block		brick circle quarter
			[Embed(source = '../graphics/environment/quarter brick circle.png')]const brkcrcl:Class;
			var brickCircle:Bitmap = new brkcrcl();
			brickCircle.x = 992;
			brickCircle.y = -679;
			environment.addChild(brickCircle);
			//end
			
			//block		Fountain, Brick Circle
			[Embed(source = '../graphics/environment/brick circle.png')]const brckcrcl:Class;
			var brickcircle:Bitmap = new brckcrcl();
			environment.addChild(brickcircle);
			//brickcircle.scaleX = brickcircle.scaleY = 1.45; 
			brickcircle.x = -177;
			brickcircle.y = -177;
			var fountain:Fountain = new Fountain();
			middleLayer.addChild(fountain);
			//end
			
			//block	 fence
			[Embed(source = '../graphics/environment/broken fence.png')]const fnce:Class;
			var fence:Bitmap = new fnce();
			environment.addChild(fence);
			fence.x = -365;
			fence.y = -704;
			[Embed(source = '../graphics/environment/metal fence.png')]const fnce2:Class;
			var fence2:Bitmap = new fnce2();
			environment.addChild(fence2);
			fence2.x = 1190;
			fence2.y = -485;
			fence2.rotation = 90;
			[Embed(source = '../graphics/environment/round fence.png')]const rndfnc:Class;
			var roundfence:Bitmap = new rndfnc();
			roundfence.x = 1017;
			roundfence.y = -678;
			environment.addChild(roundfence);
			var fence3:Bitmap = new fnce2();
			environment.addChild(fence3);
			fence3.x = 1190;
			fence3.y = 900;
			fence3.rotation = 90;
			var fence4:Bitmap = new fnce2();
			environment.addChild(fence4);
			fence4.x = -1888;
			fence4.y = -678;
			
			//end
			
			//block		Tree
			[Embed(source = '../graphics/environment/tree.png')]const tre:Class;
			var tree1:Bitmap = new tre();
			topLevel.addChild(tree1);
			tree1.x = 500;
			tree1.y = 217;
			tree1.scaleX = tree1.scaleY = 2.5;
			
			[Embed(source = '../graphics/environment/yellowtree.png')]const tre2:Class;
			var tree2:Bitmap = new tre2();
			topLevel.addChild(tree2);
			tree2.x = 640;
			tree2.y = -75;
			tree2.scaleX = tree2.scaleY = 3;
			
			var tre5:Bitmap = new tre2();
			tre5.x = 66;
			tre5.y = 470;
			tre5.scaleX = tre5.scaleY = 1.7;
			topLevel.addChild(tre5);
			//end
			
			//block		leaves
			[Embed(source = '../graphics/environment/leaf pile.png')]const leafpile1:Class;
			var leaves:Bitmap = new leafpile1();
			leaves.smoothing = true;
			environment.addChild(leaves);
			leaves.x = 600;
			leaves.y = -100;
			leaves.scaleX = leaves.scaleY = 4;
			//end
			
			//block		blood and body
			[Embed(source = '../graphics/blood/condensed/spatter1.png')]const bld:Class;
			var blood:Bitmap = new bld();
			blood.x = -285;
			blood.y = 180;
			environment.addChild(blood);
			[Embed(source = '../graphics/environment/corpse.png')]const crps:Class;
			var corpse:Bitmap = new crps();
			corpse.x = -270;
			corpse.y = 180;
			environment.addChild(corpse);
			corpse.rotation = -15;
			//end
			
			//block		cop car, skid blood
			[Embed(source = '../graphics/blood/condensed/blood skid.png')]const bludskid:Class;
			var bloodSkid:Bitmap = new bludskid();
			bloodSkid.x = -273;
			bloodSkid.y = 200;
			bloodSkid.rotation = -25;
			environment.addChild(bloodSkid);
			
			[Embed(source = '../graphics/cop car/copcar20001.png')]const cpcr1:Class;
			[Embed(source = '../graphics/cop car/copcar20002.png')]const cpcr2:Class;
			[Embed(source = '../graphics/cop car/copcar20003.png')]const cpcr3:Class;
			[Embed(source = '../graphics/cop car/copcar20004.png')]const cpcr4:Class;
			[Embed(source = '../graphics/cop car/copcar20005.png')]const cpcr5:Class;
			[Embed(source = '../graphics/cop car/copcar20006.png')]const cpcr6:Class;
			var copcar:Clip = new Clip(12, [new cpcr1(), new cpcr2(), new cpcr3(), new cpcr4(), new cpcr5(), new cpcr6()]);
			copcar.loop = true;
			copcar.x = -205;
			copcar.y = 200;
			copcar.scaleX = copcar.scaleY = 1.15;
			copcar.rotation = 65;
			middleLayer.addChild(copcar);
			//end
			
			//block		crashed car, fallen tree, stop sign, skid marks
			[Embed(source = '../graphics/environment/toppledTree.png')]const treeTopp:Class;
			var toppledTree:Bitmap = new treeTopp();
			toppledTree.x = 590;
			toppledTree.y = -510;
			environment.addChild(toppledTree);
			[Embed(source = '../graphics/environment/skidmark compressed.png')]const skdmrk:Class;
			var skidmark:Bitmap = new skdmrk();
			var skidmark2:Bitmap = new skdmrk();
			skidmark.x = 565;
			skidmark.y = -300;
			skidmark2.x = 590;
			skidmark2.y = -265;
			skidmark.scaleX = skidmark.scaleY = 1.25;
			skidmark2.scaleX = skidmark2.scaleY = 1.25
			skidmark.rotation = 135;
			skidmark2.rotation = 135;
			environment.addChild(skidmark);
			environment.addChild(skidmark2);
			[Embed(source = '../graphics/car/car crashed.png')]const cahcrash:Class;
			var carcrash:Bitmap = new cahcrash();
			carcrash.x = 575;
			carcrash.y = -345;
			carcrash.rotation = 45;
			carcrash.scaleX = carcrash.scaleY = 1.35;
			environment.addChild(carcrash);
			[Embed(source = '../graphics/environment/stopsign.png')]const stpsign:Class;
			var stopsign:Bitmap = new stpsign();
			stopsign.x = 490;
			stopsign.y = -150;
			stopsign.rotation = -25;
			environment.addChild(stopsign);
			var toppledTree2:Bitmap = new treeTopp();	//This one blocks the southern path
			toppledTree2.x = 875;
			toppledTree2.y = 650;
			toppledTree2.scaleX = toppledTree2.scaleY = 1.25;
			environment.addChild(toppledTree2);
			//end
			
			//block rubble garbage paper trash
			[Embed(source = '../graphics/environment/colored trash.png')]const clrdtrash:Class;
			var coloredTrash:Bitmap = new clrdtrash();
			environment.addChild(coloredTrash);
			coloredTrash.x = -540;
			coloredTrash.y = -575;
			coloredTrash.scaleX = coloredTrash.scaleY = 1.5;
			[Embed(source = '../graphics/environment/trashpile.png')]const trsh:Class;
			var trashPile:Bitmap = new trsh();
			environment.addChild(trashPile);
			trashPile.x = -475;
			trashPile.y = -700;
			trashPile.scaleX = trashPile.scaleY = 1.5;
			//end
			
			//block		 billboard
			[Embed(source = '../graphics/environment/billboard.png')]const billbrd:Class;
			var billboard:Bitmap = new billbrd();
			billboard.smoothing = true;
			topLevel.addChild(billboard);
			billboard.x = -500;
			billboard.y = -800;
			billboard.rotation = 45;
			//end
			
			//block		concrete wall
			[Embed(source = '../graphics/environment/concrete wall.png')]const concwall:Class;
			var concreteWall:Bitmap = new concwall();
			concreteWall.x = -500;
			concreteWall.y = -500;
			environment.addChild(concreteWall);
			var concreteWall2:Bitmap = new concwall();
			concreteWall2.x = -500;
			environment.addChild(concreteWall2);
			var concreteWall3:Bitmap = new concwall();
			concreteWall3.x = -500;
			concreteWall3.y = 500;
			environment.addChild(concreteWall3);
			var concretewall4:Bitmap = new concwall();
			concretewall4.x = -500;
			concretewall4.y = 1000;
			environment.addChild(concretewall4);
			//end
			
			//block		benches
			[Embed(source = '../graphics/environment/bench.png')]const bnch:Class;
			var bench1:Bitmap = new bnch();
			bench1.x = -200;
			bench1.y = -490;
			bench1.scaleX = bench1.scaleY = 1.3;
			bench1.rotation = -90;
			environment.addChild(bench1);
			var bench2:Bitmap = new bnch();
			bench2.x = 275;
			bench2.y = -475;
			bench2.scaleX = bench2.scaleY = 1.3;
			bench2.rotation = -120;
			environment.addChild(bench2);
			var bench3:Bitmap = new bnch();
			bench3.x = 1000;
			bench3.y = 250;
			bench3.scaleX = bench3.scaleY = 1.3;
			environment.addChild(bench3);
			var bench4:Bitmap = new bnch();
			bench4.x = 1000;
			bench4.y = -140;
			bench4.scaleX = bench4.scaleY = 1.3;
			environment.addChild(bench4);
			[Embed(source = '../graphics/environment/roundbench.png')]const rndbnch:Class;
			var roundbench:Bitmap = new rndbnch();
			roundbench.scaleX = roundbench.scaleY = 1.65;
			roundbench.x = -11;
			roundbench.y = 100;
			environment.addChild(roundbench);
			//end
			
			//block 	taxi
			[Embed(source = '../graphics/car/taxi.png')]const txi:Class;
			var taxi:Bitmap = new txi();
			taxi.x = 271;
			taxi.y = -700;
			taxi.scaleX = taxi.scaleY = 1.4;
			taxi.rotation = 10;
			environment.addChild(taxi);
			//end
			
			//block			tree and bush grove
			[Embed(source='../graphics/environment/bushes/bush.png')]const bsh:Class;
			[Embed(source='../graphics/environment/bushes/bush2.png')]const bsh2:Class;
			[Embed(source = '../graphics/environment/bushes/bush3.png')]const bsh3:Class;
			[Embed(source = '../graphics/environment/bushes/bush4.png')]const bsh4:Class;
			[Embed(source = '../graphics/environment/bushes/bush5.png')]const bsh5:Class;
			[Embed(source = '../graphics/environment/bushes/bush6.png')]const bsh6:Class;
			[Embed(source = '../graphics/environment/bushes/bush7.png')]const bsh7:Class;
			[Embed(source = '../graphics/environment/bushes/bush8.png')]const bsh8:Class;
			[Embed(source = '../graphics/environment/bushes/bush9.png')]const bsh9:Class;
			[Embed(source = '../graphics/environment/bushes/bush10.png')]const bsh10:Class;
			[Embed(source = '../graphics/environment/bushes/bush11.png')]const bsh11:Class;
			[Embed(source = '../graphics/environment/bushes/bush12.png')]const bsh12:Class;
			[Embed(source = '../graphics/environment/bushes/bush13.png')]const bsh13:Class;
			[Embed(source = '../graphics/environment/bushes/bush14.png')]const bsh14:Class;
			[Embed(source = '../graphics/environment/bushes/bush15.png')]const bsh15:Class;
			var bush1:Bitmap = new bsh();
			var bush2:Bitmap = new bsh2();
			var bush3:Bitmap = new bsh3();
			var bush4:Bitmap = new bsh4();
			var bush5:Bitmap = new bsh5();
			var bush6:Bitmap = new bsh6();
			var bush7:Bitmap = new bsh7();
			var bush8:Bitmap = new bsh8();
			var bush9:Bitmap = new bsh9();
			var bush10:Bitmap = new bsh10();
			var bush11:Bitmap = new bsh11();
			var bush12:Bitmap = new bsh12();
			var bush13:Bitmap = new bsh13();
			var bush14:Bitmap = new bsh14();
			var bush15:Bitmap = new bsh15();
			var bush16:Bitmap = new bsh();
			var bush17:Bitmap = new bsh2();
			var bush18:Bitmap = new bsh3();
			var bush19:Bitmap = new bsh4();
			var bush20:Bitmap = new bsh5();
			var bush21:Bitmap = new bsh6();
			var bush22:Bitmap = new bsh7();
			var bush23:Bitmap = new bsh8();
			var bush24:Bitmap = new bsh9();
			var bush25:Bitmap = new bsh10();
			var bush26:Bitmap = new bsh11();
			var bush27:Bitmap = new bsh12();
			var bush28:Bitmap = new bsh13();
			var bush29:Bitmap = new bsh14();
			var bush30:Bitmap = new bsh15();
			var bush31:Bitmap = new bsh();
			var bush32:Bitmap = new bsh2();
			var bush33:Bitmap = new bsh3();
			var bush34:Bitmap = new bsh4();
			var bush35:Bitmap = new bsh5();
			var bush36:Bitmap = new bsh6();
			var bush37:Bitmap = new bsh7();
			var bush38:Bitmap = new bsh8();
			var bush39:Bitmap = new bsh9();
			var bush40:Bitmap = new bsh10();
			environment.addChild(bush1);
			environment.addChild(bush2);
			environment.addChild(bush3);
			environment.addChild(bush4);
			environment.addChild(bush5);
			environment.addChild(bush6);
			environment.addChild(bush7);
			environment.addChild(bush8);
			environment.addChild(bush9);
			environment.addChild(bush10);
			environment.addChild(bush11);
			environment.addChild(bush12);
			environment.addChild(bush13);
			environment.addChild(bush14);
			environment.addChild(bush15);
			environment.addChild(bush16);
			environment.addChild(bush17);
			environment.addChild(bush18);
			environment.addChild(bush22);
			environment.addChild(bush19);
			environment.addChild(bush20);
			environment.addChild(bush21);
			environment.addChild(bush23);
			environment.addChild(bush24);
			environment.addChild(bush25);
			environment.addChild(bush26);
			environment.addChild(bush27);
			environment.addChild(bush28);
			environment.addChild(bush29);
			environment.addChild(bush30);
			environment.addChild(bush31);
			environment.addChild(bush32);
			environment.addChild(bush33);
			environment.addChild(bush34);
			environment.addChild(bush35);
			environment.addChild(bush36);
			environment.addChild(bush37);
			environment.addChild(bush38);
			environment.addChild(bush39);
			environment.addChild(bush40);
			
			bush1.x = -100;
			bush1.y = 780;
			bush2.x = -356;
			bush2.y = 715;
			bush3.x = 690;
			bush3.y = 700;
			bush4.x = 871;
			bush4.y = 930;
			bush5.x = 353;
			bush5.y = 687;
			bush6.x = 258;
			bush6.y = 796;
			bush7.x = 150;
			bush7.y = 760;
			bush8.x = 12;
			bush8.y = 700;
			bush9.x = 55;
			bush9.y = 805;
			bush10.x = 670;
			bush10.y = 875;
			bush11.x = 761;
			bush11.y = 900;
			bush13.x = 550;
			bush13.y = 775;
			bush15.x = 473;
			bush15.y = 910;
			bush12.x = 569;
			bush12.y = 943;
			bush14.x = 473;
			bush14.y = 812;
			bush16.x = -220;
			bush16.y = 850;
			bush17.x = -320;
			bush17.y = 890;
			bush18.x = -350;
			bush18.y = 950;
			bush19.x = 374;
			bush19.y = 1015;
			bush20.x = -130;
			bush20.y = 980;
			bush21.x = -500;
			bush21.y = 710;
			bush22.x = -425;
			bush22.y = 650;
			bush23.x = -240;
			bush23.y = -350;
			bush24.x = -180;
			bush24.y = -270;
			bush25.x = -310;
			bush25.y = -252;
			bush26.x = -622;
			bush26.y = 339;
			bush27.x = -475;
			bush27.y = 980;
			bush28.x = -690;
			bush28.y = 100;
			bush29.x = -725;
			bush29.y = 275;
			bush30.x = -750;
			bush30.y = 680;
			bush31.x = -605;
			bush31.y = 715;
			bush32.x = -625;
			bush32.y = -470;
			bush33.x = -675;
			bush33.y = 800;
			bush34.x = -750;
			bush34.y = -240;
			bush35.x = -666;
			bush35.y = -314;
			bush36.x = -680;
			bush36.y = -240;
			bush37.x = -675;
			bush37.y = -113;
			bush38.x = -750;
			bush38.y = 910;
			bush39.x = -740;
			bush39.y = 350;
			bush40.x = -800;
			bush40.y = -38;
			bush3.scaleX = bush3.scaleY = 2;
			bush4.scaleX = bush4.scaleY = 3;
			bush5.scaleX = bush5.scaleY = 1.5;
			bush6.scaleX = bush6.scaleY = 2.9;
			bush7.scaleX = bush7.scaleY = 1.3;
			bush11.scaleX = bush11.scaleY = 1.4;
			bush13.scaleX = bush13.scaleY = 2;
			bush14.scaleX = bush14.scaleY = 1.2;
			bush15.scaleX = bush15.scaleY = 1.3;
			bush16.scaleX = bush16.scaleY = 1.5;
			bush18.scaleX = bush18.scaleY = 2.5;
			bush19.scaleX = bush19.scaleY = 4;
			bush20.scaleX = bush20.scaleY = 4;
			bush21.scaleX = bush21.scaleY = 2;
			bush26.scaleX = bush26.scaleY = 1.55;
			bush27.scaleX = bush27.scaleY = 1.7;
			bush28.scaleX = bush28.scaleY = 2;
			bush30.scaleX = bush30.scaleY = 2;
			bush32.scaleX = bush32.scaleY = 1.5;
			bush33.scaleX = bush33.scaleY = 1.5;
			bush39.scaleX = bush39.scaleY = 2;
			bush40.scaleX = bush40.scaleY = 3;			
			
			var tree3:Bitmap = new tre();
			tree3.x = 630;
			tree3.y = 880;
			environment.addChild(tree3);
			tree3.scaleX = tree3.scaleY = 2.5;
			var tree4:Bitmap = new tre();
			tree4.x = 100;
			tree4.y = 855;
			tree4.scaleX = tree4.scaleY = 2.3;
			environment.addChild(tree4);
			var tree6:Bitmap = new tre();
			tree6.x = -100;
			tree6.y = 750;
			tree6.scaleX = tree6.scaleY = 3;
			topLevel.addChild(tree6);
			var tree7:Bitmap = new tre();
			tree7.x = -250;
			tree7.y = 570;
			tree7.scaleX = tree7.scaleY = 1.75;
			topLevel.addChild(tree7);
			var tree8:Bitmap = new tre2();
			tree8.x = -475;
			tree8.y = 790;
			tree8.scaleX = tree8.scaleY = 2.3;
			topLevel.addChild(tree8);
			var tree9:Bitmap = new tre();
			tree9.x = -290;
			tree9.y = -330;
			tree9.scaleX = tree9.scaleY = 2;
			topLevel.addChild(tree9);
			var tree10:Bitmap = new tre();
			tree10.x = -775;
			tree10.x = -775;
			tree10.y = 400;
			tree10.scaleX = tree10.scaleY = 4;
			topLevel.addChild(tree10);
			var tree11:Bitmap = new tre();
			tree11.x = -650;
			tree11.y = -109;
			tree11.scaleX = tree11.scaleY = 2;
			topLevel.addChild(tree11);
			var tree12:Bitmap = new tre2();
			tree12.x = -950;
			tree12.y = -550;
			tree12.scaleX = tree12.scaleY = 4;
			topLevel.addChild(tree12);
			var tree13:Bitmap = new tre();
			tree13.x = -740;
			tree13.y = -170;
			topLevel.addChild(tree13);
			var tree14:Bitmap = new tre();
			tree14.x = -600;
			tree14.y = 940;
			tree14.scaleX = tree14.scaleY = 1.3;
			topLevel.addChild(tree14);
			//end
			//environment = reduceToBitmaps(environment)
			
			oldGuts.x = -584;
			oldGuts.y = -769;
			
			//Converts environment layer into a giant bitmap
			//not all of environment layer is rendered, because much of it, apparently, isn't visible.
			var m1:Bitmap = new Bitmap(new BitmapData(2880, 2880, true, 0));
			var r:Rectangle = environment.getBounds(stage);
			m1.x = r.x;
			m1.y = r.y;
			var m2:Bitmap = new Bitmap(new BitmapData(408, 2880, true, 0));
			m2.x = 2880 + r.x;
			m2.y = r.y
			m1.bitmapData.draw(environment, new Matrix(1, 0, 0, 1, -r.x, -r.y), null, null, new Rectangle(0, 0, 2880, 2880));
			m2.bitmapData.draw(environment, new Matrix(1, 0, 0, 1, -2880 - r.x, -r.y), null, null, new Rectangle(0, 0, 408, 2880));
			//end conversion
			
			//converts topLevel into giant bitmap
			var m3:Bitmap = new Bitmap(new BitmapData(1851, 1844, true, 0));
			r = topLevel.getBounds(stage);
			m3.x = r.x;
			m3.y = r.y;
			m3.bitmapData.draw(topLevel, new Matrix(1, 0, 0, 1, -r.x, -r.y), null, null, new Rectangle(0, 0, 1851, 1844));
			//end conversion

			totalLayer.addChild(oceanLayer);
			totalLayer.addChild(m1);	//environment layer is consolidated into two bitmaps (m1 and m2) for performance.
			totalLayer.addChild(m2);
			totalLayer.addChild(oldGuts);
			totalLayer.addChild(guts);
			totalLayer.addChild(middleLayer);
			totalLayer.addChild(heroLayer);
			totalLayer.addChild(zombieLayer);
			totalLayer.addChild(m3);	//topLevel layer is consolidated into the m3 bitmap for performance.
			addChild(cammy);
			
			/*Gunbox displays the weapon currently in use.*/
			[Embed(source = '../graphics/Gun Sketches/pngs/compressed/gatling.png')]const gat:Class;
			[Embed(source = '../graphics/Gun Sketches/pngs/compressed/pistol.png')]const pis:Class;
			[Embed(source = '../graphics/Gun Sketches/pngs/compressed/shotgun.png')]const sho:Class;
			[Embed(source = '../graphics/Gun Sketches/pngs/compressed/sniper.png')]const sni:Class;
			[Embed(source = '../graphics/Gun Sketches/pngs/compressed/uzi.png')]const uzi:Class;
			gunBox = new Clip(0, [new pis(), new sho(), new uzi(), new sni(), new gat()]);
			gunBox.getFrame(0).x = 23;
			gunBox.getFrame(1).x = 25;
			gunBox.getFrame(1).y = -15;
			gunBox.getFrame(2).x = 23;
			gunBox.getFrame(3).x = 5;
			gunBox.getFrame(3).y = -3;
			gunBox.getFrame(4).x = -2;
			gunBox.getFrame(4).y = -2;
			gunBox.x = 370;
			gunBox.y = 460;
			addChild(gunBox);
			[Embed(source = '../graphics/Phonograph/mini phonograph.png')]const mt:Class;
			[Embed(source = '../graphics/Phonograph/mini phonograph cancel.png')]const umt:Class;
			muteButton.addChild(new Clip(0, [new mt(), new umt()]));
			muteButton.release = toggleMute;
			muteButton.y = 436;
			addChild(muteButton);
		}
		public function obstacles():void {
			//vector
			//around brick path to fallen tree
			Hero.staticObstacles.push(new LinearVector(new Point(-375, -672), new Point(1040, -672)));
			Hero.staticObstacles.push(new LinearVector(new Point(269, -674), new Point(257, -510)));	//bench and taxi start here
			Hero.staticObstacles.push(new LinearVector(new Point(257, -510), new Point(273, -480)));
			Hero.staticObstacles.push(new LinearVector(new Point(273, -480), new Point(369, -536)));
			Hero.staticObstacles.push(new LinearVector(new Point(369, -536), new Point(343, -671)));	//and end here
			Hero.staticObstacles.push(new LinearVector(new Point(1040, -672), new Point(1131, -630)));
			Hero.staticObstacles.push(new LinearVector(new Point(1131, -630), new Point(1180, -535)));
			Hero.staticObstacles.push(new LinearVector(new Point(1180, -535), new Point(1185, 660)));
			Hero.staticObstacles.push(new LinearVector(new Point(1066, 795), new Point(945, 849)));
			Hero.staticObstacles.push(new LinearVector(new Point(945, 849), new Point(860, 822)));
			Hero.staticObstacles.push(new RadialVector(new Point(1140, 740), 0, 0, 95));
			DestructableWalker.staticObstacles.push(new LinearVector(new Point(271, -2000), new Point(271, -480)));
			DestructableWalker.staticObstacles.push(new LinearVector(new Point(271, -2000), new Point(360, -530)));
			//from fallen tree to concrete wall
			Hero.staticObstacles.push(new RadialVector(new Point(785, 790), 0, 0, 85));
			Hero.staticObstacles.push(new RadialVector(new Point(415, 750), 0, 0, 50));
			Hero.staticObstacles.push(new RadialVector(new Point(205, 812), 0, 0, 50));
			Hero.staticObstacles.push(new RadialVector(new Point(60, 744), 0, 0, 47));
			Hero.staticObstacles.push(new RadialVector(new Point(-316, 752), 0, 0, 35));
			Hero.staticObstacles.push(new RadialVector(new Point( -381, 690), 0, 0, 40));
			Hero.staticObstacles.push(new RadialVector(new Point(632, 846), 0, 0, 78));
			Hero.staticObstacles.push(new LinearVector(new Point(560, 817), new Point(92, 802)));
			Hero.staticObstacles.push(new LinearVector(new Point(92, 802), new Point(-86, 797)));
			Hero.staticObstacles.push(new LinearVector(new Point(-86, 797), new Point(-98, 859)));
			Hero.staticObstacles.push(new LinearVector(new Point(-98, 859), new Point(-316, 907)));
			Hero.staticObstacles.push(new LinearVector(new Point(-316, 907), new Point(-376, 843)));
			Hero.staticObstacles.push(new LinearVector(new Point(-376, 843), new Point(-335, 775)));
			Hero.staticObstacles.push(new LinearVector(new Point(-415, 703), new Point(-483, 726)));
			Hero.staticObstacles.push(new LinearVector(new Point(-483, 726), new Point(-481, -465)));
			Hero.staticObstacles.push(new LinearVector(new Point( -481, -465), new Point( -375, -672)));
			Hero.staticObstacles.push(new LinearVector(new Point( -357, 712), new Point( -335, 732)));//closes that gap between two circiular bushes, for complete continuity.
			DestructableWalker.staticObstacles.push(new LinearVector(new Point(1055, 665), new Point(1055, 5000)));
			DestructableWalker.staticObstacles.push(new LinearVector(new Point(784, 675), new Point(784, 5000)));
			DestructableWalker.staticObstacles.push(new LinearVector(new Point(417, 657), new Point(417, 5000)));
			DestructableWalker.staticObstacles.push(new LinearVector(new Point(203, 760), new Point(203, 5000)));
			DestructableWalker.staticObstacles.push(new LinearVector(new Point(56, 675), new Point(56, 5000)));
			DestructableWalker.staticObstacles.push(new LinearVector(new Point(-290, 730), new Point(-3500, 5000)));
			DestructableWalker.staticObstacles.push(new LinearVector(new Point(-382, 650), new Point(-3000, 5000)));
			//bench vectors
			//bench1
			Hero.staticObstacles.push(new LinearVector(new Point(-199, -500), new Point(-88, -495)));
			Hero.staticObstacles.push(new LinearVector(new Point(-88, -495), new Point(-89, -529)));
			Hero.staticObstacles.push(new LinearVector(new Point( -89, -529), new Point( -198, -529)));
			DestructableWalker.staticObstacles.push(new LinearVector(new Point(-90, -500), new Point(-200, -530)));
			DestructableWalker.staticObstacles.push(new LinearVector(new Point( -200, -500), new Point( -90, -530)));
			//bench2 is w taxi && rail
			//bench3
			Hero.staticObstacles.push(new LinearVector(new Point(1030, -139), new Point(1038, -29)));
			Hero.staticObstacles.push(new LinearVector(new Point(1038, -29), new Point(1004, -28)));
			Hero.staticObstacles.push(new LinearVector(new Point(1004, -28), new Point(1005, -138)));
			DestructableWalker.staticObstacles.push(new LinearVector(new Point(1005, -30), new Point(1040, -140)));
			DestructableWalker.staticObstacles.push(new LinearVector(new Point(1040, -30), new Point(1005, -140)));
			//bench4
			Hero.staticObstacles.push(new LinearVector(new Point(1030, 252), new Point(1039, 360)));
			Hero.staticObstacles.push(new LinearVector(new Point(1039, 360), new Point(1005, 361)));
			Hero.staticObstacles.push(new LinearVector(new Point(1005, 361), new Point(1008, 253)));
			DestructableWalker.staticObstacles.push(new LinearVector(new Point(1005, 250), new Point(1037, 360)));
			DestructableWalker.staticObstacles.push(new LinearVector(new Point(1005, 360), new Point(1037, 250)));
			//crashed car and tree
			Hero.staticObstacles.push(new LinearVector(new Point(473, -237), new Point(520, -191)));
			Hero.staticObstacles.push(new LinearVector(new Point(520, -191), new Point(751, -364)));
			Hero.staticObstacles.push(new LinearVector(new Point(733, -390), new Point(650, -349)));
			Hero.staticObstacles.push(new LinearVector(new Point(650, -349), new Point(594, -356)));
			Hero.staticObstacles.push(new LinearVector(new Point(594, -356), new Point(473, -237)));
			Hero.staticObstacles.push(new RadialVector(new Point(805, -420), 0, 0, 80));
			//DestructableWalker.staticObstacles.push(new LinearVector(new Point(727, -404), new Point(520, -192)));
			DestructableWalker.staticObstacles.push(new LinearVector(new Point(472, -236), new Point(735, -392)));
			DestructableWalker.staticObstacles.push(new LinearVector(new Point(588, -343), new Point(520, -192)));
			
			//DestructableWalker.staticObstacles.push(new LinearVector(new Point(726, -402), new Point(520, -191)));
			DestructableWalker.staticObstacles.push(new RadialVector(new Point(805, -420), 0, 0, 80));
			//cop car and corpse
			Hero.staticObstacles.push(new LinearVector(new Point(-223, 213), new Point(-283, 243)));
			Hero.staticObstacles.push(new LinearVector(new Point(-283, 243), new Point(-214, 389)));
			Hero.staticObstacles.push(new LinearVector(new Point(-214, 389), new Point(-154, 362)));
			Hero.staticObstacles.push(new LinearVector(new Point( -154, 362), new Point( -223, 213)));
			DestructableWalker.staticObstacles.push(new LinearVector(new Point(-283, 243), new Point( -154, 362)));
			DestructableWalker.staticObstacles.push(new LinearVector(new Point(-214, 389), new Point( -223, 213)));

			//tree vectors
			//tree1
			Hero.staticObstacles.push(new RadialVector(new Point( -175, 650), 0, 0, 15));
			DestructableWalker.staticObstacles.push(new RadialVector(new Point( -175, 650), 0, 0, 15));
			//tree2
			Hero.staticObstacles.push(new RadialVector(new Point(140, 542), 0, 0, 10));
			DestructableWalker.staticObstacles.push(new RadialVector(new Point(140, 542), 0, 0, 10));
			//tree3
			Hero.staticObstacles.push(new RadialVector(new Point(605, 320), 0, 0, 20));
			DestructableWalker.staticObstacles.push(new RadialVector(new Point(605, 320), 0, 0, 20));
			//tree4
			Hero.staticObstacles.push(new RadialVector(new Point(765, 55), 0, 0, 35));
			DestructableWalker.staticObstacles.push(new RadialVector(new Point(765, 55), 0, 0, 35));
			//tree5 w bushes
			Hero.staticObstacles.push(new RadialVector(new Point(-210, -240), 0, 0, 60));
			Hero.staticObstacles.push(new RadialVector(new Point(-192, -307), 0, 0, 40));
			Hero.staticObstacles.push(new RadialVector(new Point(-136, -227), 0, 0, 30));
			Hero.staticObstacles.push(new RadialVector(new Point( -275, -208), 0, 0, 25));
			DestructableWalker.staticObstacles.push(new LinearVector(new Point( -190, -350), new Point( -110, -210)));
			DestructableWalker.staticObstacles.push(new LinearVector(new Point( -110, -210), new Point( -296, -194)));
			//fountain and bench
			Hero.staticObstacles.push(new RadialVector(new Point(80, 90), 0, 0, 86));
			DestructableWalker.staticObstacles.push(new RadialVector(new Point(80, 90), 0, 0, 86));
			//NODES
			//First one is least number of nodes possible
			//DestructableWalker.nodes.push(new Point(-478, -110), new Point(83, -563), new Point(86, 575), new Point(888, 380), new Point(1088, -560), new Point(543, -542));
			DestructableWalker.nodes = [new Point( -318, -581), new Point( -162, -446), new Point( -353, -44), new Point( -349, 433), new Point( -169, 734), new Point( -62, 476), new Point(364, 583), new Point(297, 241), new Point(179, -238), new Point(578, -543), new Point(970, -626), new Point(1077, -206), new Point(773, -25), new Point(691, 194), new Point(1086, 541), new Point(843, 574)];
			//end nodes
		}
		/*ALL MOUSE EVENTS ARE MANAGED HERE.*/
		public function mouseDetect(e:MouseEvent):void {
			jim.attackProtocol();
			Mouse.hide();
			//trace(jim.x, jim.y);
		}
		public function mouseRelease(e:MouseEvent):void {
			jim.ceaseProtocol();
		}
		
		/*ALL KEY EVENTS ARE MANAGED HERE!*/
		public function enableKeys():void {
			/*Key control Events*/
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDetect);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyRelease);
			/*End Key control Events*/
		}
		public function disableKeys():void {
			/*Key control Events*/
			stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDetect);
			stage.removeEventListener(KeyboardEvent.KEY_UP, keyRelease);
			/*End Key control Events*/
			left = false;
			right = false;
			up = false;
			down = false;
			jim.stop();
		}
		public function enableMouse():void {
			/*Mouse control Events*/
			stage.addEventListener(MouseEvent.MOUSE_DOWN, mouseDetect);
			stage.addEventListener(MouseEvent.MOUSE_UP, mouseRelease);
			/*End Mouse control Events*/
		}
		public function disableMouse():void {
			/*Mouse control Events*/
			stage.removeEventListener(MouseEvent.MOUSE_DOWN, mouseDetect);
			stage.removeEventListener(MouseEvent.MOUSE_UP, mouseRelease);
			/*End Mouse control Events*/
			jim.ceaseProtocol();
		}
		
		private var up:Boolean = false;
		private var down:Boolean = false;
		private var left:Boolean = false;
		private var right:Boolean = false;
		/*Handles key presses.*/
		public function keyDetect(e:KeyboardEvent):void {
			if (e.keyCode == 49) {
				jim.setState("pistol");
				gunBox.currentFrame = 0;
			}else if (e.keyCode == 50) {
				if(Global.ownsShotgun == true){
					jim.setState("shotgun");
					gunBox.currentFrame = 1;
				}
			}else if (e.keyCode == 51) {
				if (Global.ownsUzi == true) {
					jim.setState("uzi");
					gunBox.currentFrame = 2;
				}
			}else if (e.keyCode == 52) {
				if(Global.ownsSniper == true){
					jim.setState("sniper");
					gunBox.currentFrame = 3;
				}
			}else if (e.keyCode == 53) {
				if (Global.ownsGatling == true) {
					jim.setState("minigun");
					gunBox.currentFrame = 4;
				}
			}
			switch(e.keyCode) {
				case Keyboard.LEFT:
				case 65:
					left = true;
					right = false;
				break;
				case Keyboard.RIGHT:
				case 68:
					right = true;
					left = false;
				break;
				case Keyboard.DOWN:
				case 83:
					down = true;
					up = false;
				break;
				case Keyboard.UP:
				case 87:
					up = true;
					down = false;
				break;
			}
			reCalculateDirection();
		}
		/*Handles key releases*/
		public function keyRelease(e:KeyboardEvent):void {
			switch(e.keyCode) {
				case Keyboard.LEFT:
				case 65:
					left = false;
				break;
				case Keyboard.RIGHT:
				case 68:
					right = false;
				break;
				case Keyboard.DOWN:
				case 83:
					down = false;
				break;
				case Keyboard.UP:
				case 87:
					up = false;
				break;
			}
			if (left == false && right == false && up == false && down == false) {
				jim.stop();
				return;
			}
			reCalculateDirection();
		}
		/*Updates the direction based on which keys are down.*/
		private function reCalculateDirection():void {
			if (left) {
				if (up) {
					jim.move(Math.PI * 5 / 4);
					return;
				}else if (down) {
					jim.move(Math.PI * 3 / 4);
					return;
				}
				jim.move(Math.PI);
				return;
			}else if (right) {
				if (up) {
					jim.move(Math.PI * 7 / 4);
					return;
				}else if (down) {
					jim.move(Math.PI / 4);
					return;
				}
				jim.move(0);
				return;
			}
			if (up) {
				jim.move(Math.PI * 3 / 2);
				return;
			}else if (down) {
				jim.move(Math.PI / 2);
				return;
			}
		}
		/*END OF KEY DETECTION*/
		
		
		//LOADING THE LEVELS	
		public function spwn(cla:Class, num:uint):void {
			for (var i:uint = 0; i < num; i++) {
				ProximitySpawnPoint.addSpawn([cla]);
			}
		}
		
		public function levelGen(level:uint):void {
			var tmn : Timer;	//Working object.
			switch(level) {
				case 1:
				ProximitySpawnPoint.spawnTimer.delay = 1000;
				spwn(Zombie, 20);
				break;
				case 2:
				spwn(Zombie, 8);
				ProximitySpawnPoint.spawnTimer.delay = 700;
				spwn(Crawler, 1);
				spwn(Zombie, 8);
				spwn(Crawler, 1);
				break;
				case 3:
				ProximitySpawnPoint.spawnTimer.delay = 700;
				spwn(Zombie, 3);
				spwn(Bouncer, 6);
				spwn(Crawler, 2);
				tmn = new Timer(7700, 1);
				tmn.addEventListener(TimerEvent.TIMER_COMPLETE, function (e:TimerEvent) : void { ProximitySpawnPoint.spawnTimer.delay = 2000 * (Destructable.members.length == 1 ? 0 : 1);});
				tmn.start();
				spwn(Zombie, 4);
				break;
				case 4:
				ProximitySpawnPoint.spawnTimer.delay = 700;
				spwn(Bouncer, 2);
				spwn(Zombie, 8);
				spwn(Bouncer, 2);
				spwn(Zombie, 4);
				spwn(Bouncer, 2);
				spwn(Crawler, 1);
				break;
				case 5:
				spwn(Crawler, 4);
				spwn(Bouncer, 4);
				spwn(Zombie, 6);
				spwn(Crawler, 2);
				spwn(Mosher, 2);
				spwn(Crawler, 2);
				ProximitySpawnPoint.spawnTimer.delay = 1000;
				break;
				case 6:
				//easy peasy
				spwn(Zombie, 6);
				spwn(Longarm, 3);
				spwn(Bouncer, 4);
				spwn(Zombie, 8);
				ProximitySpawnPoint.spawnTimer.delay = 800;
				spwn(Zombie, 1);
				break;
				case 7:	//should be able to get uzi's before this level.  Should not be able to win with an un-upgraded pistol
				//DRAW
				ProximitySpawnPoint.spawnTimer.delay = 800;
				spwn(Crawler, 20);
				break;
				case 8:
				ProximitySpawnPoint.spawnTimer.delay = 1400;
				ProximitySpawnPoint.addSpawn([Bouncer, Flailer, Bouncer, Mosher]);
				ProximitySpawnPoint.addSpawn([Mosher, Mosher, Mosher, Crawler]);
				ProximitySpawnPoint.addSpawn([Crawler, Crawler, Crawler]);
				ProximitySpawnPoint.addSpawn([Flailer, Flailer]);
				ProximitySpawnPoint.addSpawn([Bouncer, Bouncer]);
				ProximitySpawnPoint.addSpawn([Flailer, Bouncer, Bouncer]);
				ProximitySpawnPoint.addSpawn([Mosher, Mosher, Mosher]);
				spwn(Crawler, 2);
				spwn(Flailer, 2);
				spwn(Flailer, 2);
				spwn(Crawler, 1);
				break;
				case 9:
				ProximitySpawnPoint.spawnTimer.delay = 400;
				ProximitySpawnPoint.addSpawn([Zombie, Zombie, Zombie]);
				spwn(Crawler, 1);
				ProximitySpawnPoint.addSpawn([Zombie, Zombie, Zombie]);
				spwn(Crawler, 1);
				ProximitySpawnPoint.addSpawn([Zombie, Zombie, Zombie]);
				spwn(Crawler, 2);
				ProximitySpawnPoint.addSpawn([Zombie, Zombie, Zombie]);
				spwn(Mosher, 2);
				spwn(Crawler, 2);
				break;
				case 10:
				ProximitySpawnPoint.addSpawn([Bouncer, Bouncer, Bouncer]);
				ProximitySpawnPoint.addSpawn([Mosher, Mosher, Mosher, Mosher]);
				ProximitySpawnPoint.addSpawn([Bouncer, Bouncer]);
				ProximitySpawnPoint.addSpawn([Mosher, Mosher,Mosher, Mosher]);
				ProximitySpawnPoint.addSpawn([Bouncer, Bouncer]);
				ProximitySpawnPoint.addSpawn([Mosher, Mosher, Mosher, Mosher]);
				ProximitySpawnPoint.addSpawn([Bouncer, Bouncer]);
				spwn(Crawler, 4);
				ProximitySpawnPoint.spawnTimer.delay = 2000;
				break;
				case 11:
				ProximitySpawnPoint.spawnTimer.delay = 2000;
				ProximitySpawnPoint.addSpawn([Mosher, Mosher, Mosher, Mosher]);
				ProximitySpawnPoint.addSpawn([Longarm, Longarm]);
				ProximitySpawnPoint.addSpawn([Mosher, Mosher, Mosher, Mosher]);
				ProximitySpawnPoint.addSpawn([Longarm, Longarm, Longarm, Longarm, Longarm, Longarm]);
				ProximitySpawnPoint.addSpawn([Crawler, Crawler]);
				ProximitySpawnPoint.addSpawn([Zombie, Zombie, Zombie, Zombie]);
				break;
				default:
				var m:Array = [Math.random(), Math.random(), Math.random(), Math.random(), Math.random(), Math.random()];
				var t:Number = m[0] + m[1] + m[2] + m[3] + m[4] + m[5];
				const mult : Number = 30;
				m[0] = Math.round(m[0] / t * mult);
				m[1] = Math.round(m[1] / t * mult / 1.25);
				m[2] = Math.round(m[2] / t * mult / 1.75);
				m[3] = Math.round(m[3] / t * mult / 1.25);
				m[4] = Math.round(m[4] / t * mult / 1.5);
				m[5] = Math.round(m[5] / t * mult / 2);
				t = m[0] + m[1] + m[2] + m[3] + m[4] + m[5];
				var r:Array = [Zombie, Crawler, Longarm, Bouncer, Mosher, Flailer];
				for (var i:uint = 0; i < t; i++) {
					ProximitySpawnPoint.addSpawn([r[Math.floor(Math.random() * 5.99)]]);
				}
				ProximitySpawnPoint.spawnTimer.delay = 1000 * Math.sqrt(1.8 / level);
				Hero.hero.damageTimer.delay = 200 * 12 / level;
				break;
			}
		}
		/*
		private function minorTrans1():void {
			SmoothTween.add(tx, new Point( -tx.width, tx.y), 250);
			SmoothTween.add(tx2, new Point(15, tx2.y), 250);
			
			b2 = new Button();
			b3 = new Button();
			b2.x = 15;
			b3.x = 15;
			b2.y = 350;
			b3.y = 400;
			b2.hitArea = new Sprite();
			b3.hitArea = new Sprite();
			b2.hitArea.graphics.beginFill(0, 0);
			b3.hitArea.graphics.beginFill(0, 0);
			b2.hitArea.graphics.drawRect(0, 0, 100, 28);
			b3.hitArea.graphics.drawRect(0, 0, 100, 28);
			b2.hitArea.graphics.endFill();
			b2.addChild(b2.hitArea);
			b3.addChild(b3.hitArea);
			addChild(b2);
			addChild(b3);
			b2.release = norm;
			b3.release = hard;
		}*/
		/*
		private function norm():void {
			Global.level = 1;
			minorTrans2();
		}
		private function hard():void {
			Global.level = 10;
			minorTrans2();
		}*/
		private function minorTrans2():void {
			//SmoothTween.add(tx2, new Point( -tx2.width, tx2.y), 200);
			
			//set up the visuals or something.
			[Embed(source = '../graphics/White Burn/Compressed/stage1.png')]const st1:Class;
			[Embed(source = '../graphics/White Burn/Compressed/stage2.png')]const st2:Class;
			[Embed(source = '../graphics/White Burn/Compressed/stage3.png')]const st3:Class;
			[Embed(source = '../graphics/White Burn/Compressed/stage4.png')]const st4:Class;
			[Embed(source = '../graphics/White Burn/Compressed/stage5.png')]const st5:Class;
			[Embed(source = '../graphics/White Burn/Compressed/stage6.png')]const st6:Class;
			[Embed(source = '../graphics/White Burn/Compressed/stage7.png')]const st7:Class;
			[Embed(source = '../graphics/White Burn/Compressed/stage8.png')]const st8:Class;
			[Embed(source = '../graphics/White Burn/Compressed/stage9.png')]const st9:Class;
			[Embed(source = '../graphics/White Burn/Compressed/stage10.png')]const st10:Class;
			[Embed(source = '../graphics/White Burn/Compressed/stage11.png')]const st11:Class;
			//[Embed(source = '../graphics/White Burn/Compressed/stage12.png')]const st12:Class;
			[Embed(source = '../graphics/White Burn/Compressed/stage13.png')]const st13:Class;
			[Embed(source = '../graphics/White Burn/Compressed/stage14.png')]const st14:Class;
			[Embed(source = '../graphics/White Burn/Compressed/stage15.png')]const st15:Class;
			//[Embed(source = '../graphics/White Burn/Compressed/stage16.png')]const st16:Class;
			[Embed(source = '../graphics/White Burn/Compressed/stage17.png')]const st17:Class;
			[Embed(source = '../graphics/White Burn/Compressed/stage18.png')]const st18:Class;
			[Embed(source = '../graphics/White Burn/Compressed/stage19.png')]const st19:Class;
			[Embed(source = '../graphics/White Burn/Compressed/stage20.png')]const st20:Class;
			[Embed(source = '../graphics/White Burn/Compressed/stage21.png')]const st21:Class;
			[Embed(source = '../graphics/White Burn/Compressed/stage22.png')]const st22:Class;
			[Embed(source = '../graphics/White Burn/Compressed/stage23.png')]const st23:Class;
			[Embed(source = '../graphics/White Burn/Compressed/stage24.png')]const st24:Class;
			[Embed(source = '../graphics/White Burn/Compressed/stage25.png')]const st25:Class;
			[Embed(source = '../graphics/White Burn/Compressed/stage26.png')]const st26:Class;
			[Embed(source = '../graphics/White Burn/Compressed/stage27.png')]const st27:Class;
			[Embed(source = '../graphics/White Burn/Compressed/stage28.png')]const st28:Class;
			[Embed(source = '../graphics/White Burn/Compressed/stage29.png')]const st29:Class;
			[Embed(source = '../graphics/White Burn/Compressed/stage30.png')]const st30:Class;
			var lastOne:Sprite = new Sprite();
			lastOne.graphics.beginFill(0xFFFFFF, 1);
			lastOne.graphics.drawRect(0, 0, 250, 250);
			lastOne.graphics.endFill();
			whiteBurn = new Clip(20, [new st1(), new st2(), new st3(), new st4(), new st5(), new st6(), new st7(), new st8(), new st9(), new st10(), new st11(), /*new st12(),*/ new st13(), new st14(), new st15(), /*new st16(),*/ new st17(), new st18(), new st19(), new st20(), new st21(), new st22(), new st23(), new st24(), new st25(), new st26(), new st27(), new st28(), new st29(), new st30(), lastOne, lastOne]);
			whiteBurn.loop = false;
			whiteBurn.x = 250;
			whiteBurn.y = 250;
			for (var i:uint = 0; i < whiteBurn.totalFrames; i++) {
				whiteBurn.getFrame(i).x = - whiteBurn.getFrame(i).width / 2;
				whiteBurn.getFrame(i).y = - whiteBurn.getFrame(i).height / 2;
			}
			whiteBurn.scaleX = 2;
			whiteBurn.scaleY = 2;
			addChild(whiteBurn);
			txLoad = new TextField();
			txLoad.defaultTextFormat = new TextFormat("batik", 28);
			txLoad.selectable = false;
			txLoad.embedFonts = true;
			txLoad.text = "WASD or Arrows To Move...\nClick to Fire...\n\n    Click To Continue";
			txLoad.width = 500;
			txLoad.height = 300;
			txLoad.y = 180;
			txLoad.x = 30;
			addChild(txLoad);
			whiteMask = new Clip(20, [new st1(), new st2(), new st3(), new st4(), new st5(), new st6(), new st7(), new st8(), new st9(), new st10(), new st11(), /*new st12(),*/ new st13(), new st14(), new st15(), /*new st16(),*/ new st17(), new st18(), new st19(), new st20(), new st21(), new st22(), new st23(), new st24(), new st25(), new st26(), new st27(), new st28(), new st29(), new st30()]);
			whiteMask.loop = false;
			whiteMask.x = 250;
			whiteMask.y = 250;
			for (i = 1; i < whiteMask.totalFrames; i++) {
				whiteMask.getFrame(i).x = - whiteMask.getFrame(i).width / 2;
				whiteMask.getFrame(i).y = - whiteMask.getFrame(i).height / 2;
			}
			whiteMask.scaleX = 2;
			whiteMask.scaleY = 2;
			txLoad.mask = whiteMask;
			//
			removeChild(bu); bu = null;
			//removeChild(b2); b2 = null;
			//removeChild(b3); b3 = null;
			SmoothTween.add(tx, new Point(-tx.width, tx.y), 350, function():void{removeChild(tx); tx = null});
			
			whiteBurn.onComplete = function():void { stage.addEventListener(MouseEvent.CLICK, init)};
			
			[Embed(source = '../graphics/Title and Death Screens/pngs/assembled2.png')]const dth:Class;
			var dm:Array = [new st1(), new st2(), new st3(), new st4(), new st5(), new st6(), new st7(), new st8(), new st9(), new st10(), new st11(), /*new st12(),*/ new st13(), new st14(), new st15(), /*new st16(),*/ new st17(), new st18(), new st19(), new st20(), new st21(), new st22(), new st23(), new st24(), new st25(), new st26(), new st27(), new st28(), new st29(), new st30()];
			for (i = 0; i < dm.length; i++) {
				var d:Bitmap = new dth();
				var e:BitmapData = new BitmapData(500, 500, true, 0);
				e.draw(dm[i], new Matrix(2, 0, 0, 2));
				var dh:uint = Math.min(dm[i].height, 250);
				var dw:uint = Math.min(dm[i].width, 250);
				d.bitmapData.copyChannel(e, new Rectangle(0, 0, dw*2, dh*2), new Point(250 - dw, 250 - dh), BitmapDataChannel.ALPHA, BitmapDataChannel.ALPHA);
				d.bitmapData.fillRect(new Rectangle(0, 0, 500, 250 - dh), 0);
				d.bitmapData.fillRect(new Rectangle(0, 250 + dh, 500, 250 - dh), 0);
				d.bitmapData.fillRect(new Rectangle(0, 250 - dh, 250 - dw, dh * 2), 0);
				d.bitmapData.fillRect(new Rectangle(dw + 250, 250 - dh, 250 - dw, dh * 2), 0);
				deathScreen.insertFrame(d, i);
			}
			
			submitButton = new Button();
			var stext:TextField = new TextField();
			stext.width = 121;
			stext.height = 30;
			stext.embedFonts = true;
			stext.defaultTextFormat = new TextFormat("batik", 30, 0xFFFFFF);
			stext.selectable = false;
			submitButton.addChild(stext);
			//addChild(submitButton);
			submitButton.x = -122;
			submitButton.y = 320;
			
			if (Preloader.site == "mochi") {
				stext.text = "SUBMIT";	//Button will be blank and unclickable unless its mochi
				submitButton.release = function():void {
					Mouse.show();
					var o:Object = { n: [10, 9, 3, 3, 12, 14, 3, 1, 14, 12, 2, 12, 2, 13, 4, 4], f: function (i:Number,s:String):String { if (s.length == 16) return s; return this.f(i+1,s + this.n[i].toString(16));}};
					var boardID:String = o.f(0,"");
					MochiScores.showLeaderboard( { boardID: boardID, score: (Global.earnt / 2 + Global.monies) } )
					MochiScores.onCloseHandler = function():void { Mouse.hide() };
				}
			}
			
			continueButton = new Button();
			var ctext:TextField = new TextField();
			ctext.width = 183;
			ctext.height = 41;
			ctext.embedFonts = true;
			ctext.defaultTextFormat = new TextFormat("batik", 30, 0xFFFFFF);
			ctext.selectable = false;
			ctext.text = "TRY AGAIN";
			continueButton.addChild(ctext);
			continueButton.x = -184;
			continueButton.y = 456;
			continueButton.release = continueFunction;
			scoresText = new TextField();
			scoresText.width = 201;
			scoresText.height = 81;
			scoresText.embedFonts = true;
			scoresText.defaultTextFormat = new TextFormat("batik", 24, 0);
			scoresText.selectable = false;
			scoresText.x = -202;
			scoresText.y = (Preloader.site == "mochi") ? 356 : 320;
			
			restartButton = new Button();
			var rtext:TextField = new TextField();
			rtext.embedFonts = true;
			rtext.defaultTextFormat = new TextFormat("batik", 30, 0xFFFFFF);
			rtext.selectable = false;
			rtext.text = "RESTART";
			rtext.width = rtext.textWidth;
			restartButton.addChild(rtext);
			restartButton.x = 500;
			restartButton.y = 320;
			restartButton.release = function():void { addChild(new YesNotification("Are you sure you want to restart?  This will erase ALL of your previous progress, and bring you back to level 1.", new TextFormat("batik", 24, 0), 400, restartFunction));addChild(cursor) }//restartFunction;
			
			retoolButton = new Button();
			var retext:TextField = new TextField();
			retext.embedFonts = true;
			retext.defaultTextFormat = new TextFormat("batik", 30, 0xFFFFFF);
			retext.selectable = false;
			retext.text = "RETOOL";
			retext.width = retext.textWidth;
			retoolButton.addChild(retext);
			retoolButton.x = 500;
			retoolButton.y = 456;
			retoolButton.release = function():void { retool = true; continueFunction(); retool = false; }
			
			var t:Timer = new Timer(50, 20);
			t.addEventListener(TimerEvent.TIMER, function(e:TimerEvent):void {songChannel.soundTransform = new SoundTransform(songChannel.soundTransform.volume - .05)});
			t.addEventListener(TimerEvent.TIMER_COMPLETE, function(e:TimerEvent):void {songChannel.stop()});
			t.start();
			
			addChild(cursor);
		}
		
		private var continueFunction:Function = function():void {
			AmbientZombies.stop();
			if (Global.level == 1) {	//level starts at 1, so you subtract
				if(retool){
					addChild(new Notification("You can't retool until you get past the first level.", new TextFormat("batik", 24, 0), 400, 2000));	
				}
				restartFunction();			//Stops the menu from appearing if death occurs on first level
				return;
			}
			continueButton.release = function():void { };
			SmoothTween.add(continueButton, new Point( -continueButton.width - 1, continueButton.y), 200, function():void { removeChild(continueButton); removeChild(scoresText); removeChild(submitButton); removeChild(restartButton); removeChild(retoolButton);  continueButton.release = continueFunction; } );
			SmoothTween.add(submitButton, new Point( -submitButton.width - 1, submitButton.y), 200);
			SmoothTween.add(scoresText, new Point( -scoresText.width - 1, scoresText.y), 200);
			SmoothTween.add(restartButton, new Point(500, restartButton.y), 200);
			SmoothTween.add(retoolButton, new Point(500, retoolButton.y), 200);
			
				//TAKE THIS OUT AFTER TESTING REMOVE
			Global.level--;
			if (saveArray[Global.level - 1] != null) {//true is the real one
				if(retool == false){
					retemp.loadGlobal();
				}else{
					saveArray[Global.level].loadGlobal();	//enterMenu() increases level by 1
				}
			}else {
				saveArray[0].loadGlobal();
			}
			enterMenu();
			if (retool) {
				Global.shopMenu.x = 0;
			}else {
				removeChild(cursor);
				cursor = crosshair;
				addChild(cursor);
				exitMenu();
				Global.shopMenu.x = 500;
			}
			addChild(deathScreen);

			deathScreen.currentFrame = deathScreen.totalFrames - 2;
			deathScreen.frameRate = -20;
			deathScreen.onComplete = function():void{removeChild(deathScreen)}//Can be blank, because it is reset when death() is called.
			
			var q:uint = totalLayer.getChildIndex(oldGuts);
			totalLayer.removeChild(oldGuts);				
			oldGuts = new StaticMap(1838, 1785);	//cleans up guts
			oldGuts.x = -584;
			oldGuts.y = -769;
			totalLayer.addChildAt(oldGuts, q);
		}
		private function restartFunction():void {
			continueButton.release = function():void { };
			SmoothTween.add(continueButton, new Point(-continueButton.width - 1, continueButton.y), 200, function():void { removeChild(continueButton); removeChild(scoresText); removeChild(submitButton);removeChild(restartButton); continueButton.release = continueFunction;});
			SmoothTween.add(submitButton, new Point(-submitButton.width - 1, submitButton.y), 200);
			SmoothTween.add(scoresText, new Point(-scoresText.width - 1, scoresText.y), 200);
			SmoothTween.add(restartButton, new Point(500, restartButton.y), 200);
			SmoothTween.add(retoolButton, new Point(500, retoolButton.y), 200);
			
			//saveArray = [saveArray[0]];
			Global.level = 1;
			saveArray[0].loadGlobal();
			//Global.resetDefaults();
			jim.x = 72;
			jim.y = -173;
			
			deathScreen.currentFrame = deathScreen.totalFrames - 2;
			deathScreen.frameRate = -20;
			deathScreen.onComplete = function():void {removeChild(deathScreen)}//Can be blank, because it is reset when death() is called.
			
			var q:uint = totalLayer.getChildIndex(oldGuts);
			totalLayer.removeChild(oldGuts);				
			oldGuts = new StaticMap(1838, 1785);	//cleans up guts
			oldGuts.x = -584;
			oldGuts.y = -769;
			totalLayer.addChildAt(oldGuts, q);
			
			enableKeys();
			enableMouse();
			jim.health = 7;
			
			leveltext.text = "Level " + Global.level;
			leveltext.x = -leveltext.textWidth;
			addChild(leveltext);
			SmoothTween.add(leveltext, new Point((500 - leveltext.textWidth) / 2, leveltext.y), 500);
			var a:StarWarsClock = new StarWarsClock(new TextFormat("batik", 24, 0xFFFFFF), 500, 5, function():void { levelGen(Global.level);stage.focus = null; SmoothTween.add(leveltext, new Point(500, leveltext.y), 500, function():void { removeChild(leveltext);stage.focus = null; } ) } );
			a.x = 225;
			a.y = 235;
			addChild(a);
			AmbientZombies.uprising();
			AmbientZombies.update(50);
			removeChild(cursor);
			cursor = crosshair;
			addChild(cursor);
		}
		private function addspaces(num:uint):String {//Generates spaces for the scoresText to fit.
			var s:String = "";
			switch(true) {
				case num < 10:s += " ";case num < 100:s += " ";case num < 1000:s += " ";case num < 10000:s += " ";case num < 100000:s += " ";
			}
			return String(s + num);
		}
		private function decompose():void {
			//removeChild(tx2); tx2 = null;
			//removeChild(reverseBurn); reverseBurn = null;
			removeChild(whiteBurn); whiteBurn = null;
			removeChild(txLoad); txLoad.mask = null; txLoad = null;
		}
		public function death():void {
			jim.regenerator.stop();
			deathScreen.frameRate = 20;
			deathScreen.currentFrame = 1;
			deathScreen.loop = false;
			//scoresText.text = "EARNED:" + addspaces(Global.earnt / 2) + "\nSPENT: " + addspaces(Global.earnt/2-Global.monies) + "\nSCORE: " + addspaces(Global.earnt - Global.monies);
			addChild(deathScreen);
			ProximitySpawnPoint.clearSpawns();
			disableMouse();
			disableKeys();
			deathScreen.onComplete = function():void {
				addChild(submitButton);
				addChild(continueButton);
				addChild(scoresText);
				addChild(restartButton);
				addChild(retoolButton);
				SmoothTween.add(submitButton, new Point(62, 321), 300);
				SmoothTween.add(continueButton, new Point(27, 459), 300);
				SmoothTween.add(scoresText, new Point(25, scoresText.y), 300);
				SmoothTween.add(restartButton, new Point(300, restartButton.y), 300);
				SmoothTween.add(retoolButton, new Point(300, retoolButton.y), 300);
				jim.setState("pistol");
				gunBox.currentFrame = 0;
				jim.regenerator.start();
				if (foolmeonce == false) {
					addChild(new Notification("Welcome to YOU ARE DEAD.  \nPopulation: 0 \n\nFortunately, your self esteem is the only thing that truly dies in this game.  The RETOOL button will undo recent inventory changes, restore funds from said changes, and allow you to revisit the shop screen.  Use the submit button to check up on your high scores.\n\nClick to continue embarassing yourself.", new TextFormat("batik", 18, 0), 400, 0));
					foolmeonce = true;
				}
				removeChild(cursor);
				cursor = hand;
				addChild(cursor);
			}
			var s:uint =  Destructable.members.length-1; //it is length - 1 because the Hero is a destructable
			for (var i:uint = 0; i < s; i++) {
				switch(true) {
					case Destructable.members[1] is Zombie:
					Global.monies -= Global.zombiePayout;
					//Global.earnt -= Global.zombiePayout * 2;
					break;
					case Destructable.members[1] is Crawler:
					Global.monies -= Global.crawlerPayout;
					//Global.earnt -= Global.crawlerPayout * 2;
					break;
					case Destructable.members[1] is Bouncer:
					Global.monies -= Global.bouncerPayout;
					//Global.earnt = -Global.bouncerPayout * 2;
					break;
					/*case Destructable.members[1] is Flailer:
					Global.monies -= Global.flailerPayout;
					//Global.earnt -= Global.flailerPayout * 2;
					break;*/
					case Destructable.members[1] is Mosher:
					Global.monies -= Global.mosherPayout;
					//Global.earnt -= Global.mosherPayout * 2;
					break;
					case Destructable.members[1] is Longarm:
					Global.monies -= Global.longarmPayout;
					//Global.earnt -= Global.longarmPayout * 2;
					break;
				}
				Destructable.members[1].health = 0;
			}
			AmbientZombies.lowkey();//keeps the zombies going after they all die													//you still get half credit for spent money
			
			if (Preloader.site == "mochi")
				scoresText.text = "EARNED:" + addspaces(Global.earnt / 2) + "\nSPENT: " + addspaces(Global.earnt/2-Global.monies) + "\nSCORE: " + addspaces(Global.earnt / 2 + Global.monies);
			else {
				topscore = Math.max(topscore,Global.earnt / 2 + Global.monies);
				scoresText.height = 110;
				scoresText.text = "BEST:  " + addspaces(topscore) + "\nEARNED:" + addspaces(Global.earnt / 2) + "\nSPENT: " + addspaces(Global.earnt/2-Global.monies) + "\nSCORE: " + addspaces(Global.earnt / 2 + Global.monies);
			}
			removeChild(cursor);
			cursor = hand;
			addChild(cursor);
		}
		public function endLevelMaybe():void {
			AmbientZombies.update(ProximitySpawnPoint.queue.length + Destructable.members.length - 1);
			if (Destructable.members.length + ProximitySpawnPoint.queue.length == 1 && jim.health > 0) {
				disableMouse();disableKeys();
				var t:Timer = new Timer(2000, 1);	//2 second delay between killing everything and menu.
				t.addEventListener(TimerEvent.TIMER_COMPLETE, function():void { enterMenu(); saveArray[Global.level] = new SaveFile();saveArray[Global.level].saveGlobal()} );
				t.start();
			}
		}
		public function numtotext(num:int):String {
			if (num < 0) {
				return "Negative " + numtotext(num * -1);
			}
			//irregulars under 100
			switch(num) {
				case 0:return "Zero";
				case 1:return "One";
				case 2:return "Two";
				case 3:return "Three";
				case 4:return "Four";
				case 5:return "Five";
				case 6:return "Six";
				case 7:return "Seven";
				case 8:return "Eight";
				case 9:return "Nine";
				case 10:return "Ten";
			}
			//Everything at this point is greater than ten, because of the above switch statement.
			//greater than 100
			if (num >= 100) {
				return numtotext(Math.floor(num / 100)) + " Hundred" + (num % 100 == 0 ? "":" and ") + numtotext(num % 100);
			}
			if (num < 20) {
				switch(num) {
					case 11:return "Eleven";
					case 12:return "Twelve";
					case 13:return "Thirteen";
					case 15:return "Fifteen";
					case 18:return "Eighteen";
					default:
					return numtotext(num - 10) + "teen";
				}
			}
			//greater than or equal to 20;
			var tens:uint = Math.floor(num / 10);
			var pre:String;
			switch(tens) {
				case 2:pre = "Twenty"; break;
				case 3:pre = "Thirty"; break;
				case 5:pre = "Fifty"; break;
				case 8:pre = "Eighty"; break;
				default:pre = numtotext(tens) + "ty";
			}
			if (num % 10 == 0) {
				return pre;
			}else {
				return pre + "-" + numtotext(num % 10);
			}
		}
		public function toggleMute():void {
			if(SoundMixer.soundTransform.volume != 0){
				SoundMixer.soundTransform = new SoundTransform(0);
				Clip(muteButton.getChildAt(0)).currentFrame = 1;
			}else {
				SoundMixer.soundTransform = new SoundTransform(1);
				Clip(muteButton.getChildAt(0)).currentFrame = 0;
			}
		}
	}
}