package 
{
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.Font;
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class Global
	{
		private static var mons:int = 0;//These two intiialize equal or errors
		public static var earnt:int = 0;//keeps track of total money
		public static var level:uint = 1;
		//public static var weaponLevel:uint = 5;
		/*Handles currency.*/
		public static function set monies(value:int):void {
			if (value > monies || (value < monies && monies - value < 50)) {
				earnt += (value - monies) * 2;
			}
			mons = value * 2;
			//pointBar.text = String(mons);
		}
		public static function get monies():int {
			return mons / 2;
		}
		public static var shopMenu:ShopMenu = new ShopMenu();	//THIS MUST COME AFTER MONIES IS DEFINED, BECAUSE IT USES THAT.
		//point bar
		
		//REGISTERS THE FONT
		[Embed(source = '../graphics/batik.ttf', fontName='batik', mimeType='application/x-font', fontWeight='normal', unicodeRange='U+0020-U+0080, U+00A3')]private static var batikFont:Class;
		Font.registerFont(batikFont);
		
		/*
		private static var font:Font = new batikFont();
		private static var pointFormat:TextFormat = new TextFormat(font.fontName, 15);
		private static var ptBar:TextField = new TextField();
		ptBar.defaultTextFormat = pointFormat;
		ptBar.text = "0";
		ptBar.selectable = false;
		ptBar.embedFonts = true;
		public static function get pointBar():TextField {
			return ptBar;
		}*/
		/*Returns a textbox object, pre-formatted.*//*
		public static function textbox():TextField {
			//var frmat:TextFormat = new TextFormat(font.fontName, size);
			//var txt:TextField = new TextField();wa
			//txt.defaultTextFormat = frmat;
			//txt.text = text;
			//txt.embedFonts = true;
			return new TextField();
		}*/
		//end point bar
		
		public static var zombiePayout = 20;
		public static var crawlerPayout = 35;
		public static var bouncerPayout = 35;
		public static var longarmPayout = 30;
		public static var mosherPayout = 30;
		//public static var flailerPayout = 12;
		
		public static var ownsShotgun:Boolean = false;
		public static var ownsUzi:Boolean = false;
		public static var ownsSniper:Boolean = false;
		public static var ownsGatling:Boolean = false;
		/*
		public static var pistolRange:Number = 250;
		public static var shotgunRange:Number = 150;
		public static var uziRange:Number = 200;
		public static var gatlingRange:Number = 170;
		
		public static var pistolAccuracy:Number = .1;
		public static var shotgunAccuracy:Number = .150;
		public static var uziAccuracy:Number = .2;
		public static var gatlingAccuracy:Number = .2;
		
		public static var pistolDamage:Number = 66;
		public static var shotgunDamage:Number = 50;
		public static var uziDamage:Number = 50;
		public static var sniperDamage:Number = 200;
		public static var gatlingDamage:Number = 30;
		
		public static var pistolRate:Number = 500;
		public static var shotgunRate:Number = 750;
		public static var uziRate:Number = 1500;
		public static var sniperRate:Number = 1250;
		public static var gatlingRate:Number = 50;
		
		public static var pistolLightness:Number = 200;
		public static var shotgunLightness:Number = 175;
		public static var uziLightness:Number = 185;
		public static var sniperLightness:Number = 160;
		public static var gatlingLightness:Number = 140;
		
		public static var buckShot:uint = 4;
		public static var piercing:uint = 1;
		public static var rollover:Boolean = false;
		
		//0 = damage, 1 = range, 2 = cooldown, 3 = weight, 4 = accuracy, 5 = rollOver
		public static var pistolUpgrade:Array = [];
		//0 = damage, 1 = range, 2 = cooldown, 3 = weight, 4 = accuracy, 5 = buckshot
		public static var shotgunUpgrade:Array = [];
		//0 = damage, 1 = range, 2 = cooldown, 3 = weight, 4 = accuracy, 5 = clipSize
		public static var uziUpgrade:Array = [];
		//0 = damage, 1 = piercing, 2 = cooldown, 3 = weight
		public static var sniperUpgrade:Array = [];
		//0 = damage, 1 = range, 2 = cooldown, 3 = weight, 4 = accuracy
		public static var gatlingUpgrade:Array = [];
		
		pistolUpgrade[0] = [[66, 0], [75, 350], [85, 450], [95, 550], [105, 650], [120, 700]];
		pistolUpgrade[1] = [[250, 0], [300 , 200], [400 , 250], [500, 300]];
		pistolUpgrade[2] = [[500, 0], [450, 500], [400, 500], [350, 750], [300, 1000], [250, 1320]];
		pistolUpgrade[3] = [[200, 0], [210, 250], [220, 250], [230, 300], [240, 400], [250, 500]];
		pistolUpgrade[4] = [[.1, 0], [.09, 200], [.08, 200], [.07, 200], [.06, 200], [.05, 200]];
		
		shotgunUpgrade[0] = [[50, 0], [55, 400], [60, 400], [65, 400], [70, 450], [75, 500]];
		shotgunUpgrade[1] = [[150, 0], [175, 350], [200, 400], [225, 450], [250, 500]];
		shotgunUpgrade[2] = [[750, 0], [700, 400], [650, 500], [600, 500], [550, 500], [500, 600]];
		shotgunUpgrade[3] = [[180, 0], [190, 350], [200, 400], [210, 400], [220, 450], [225, 350]];
		shotgunUpgrade[4] = [[.2, 0], [.18, 250], [.16, 300], [.14, 350], [.12, 400], [.1, 500]];
		shotgunUpgrade[5] = [[4, 0], [5, 600], [6, 1000], [7, 1000], [8, 1200]];
		
		uziUpgrade[0] = [[42, 0], [50, 350], [60, 400], [65, 425], [70, 450], [75, 475], [80, 500], [85, 550]];
		uziUpgrade[1] = [[200, 0], [225, 350], [250, 400], [275, 450], [300, 500]];
		uziUpgrade[2] = [[1500, 0], [1475, 300], [1450, 350], [1425, 400], [1400, 500], [1350, 750], [1300, 900], [1250, 1050], [1200, 1200]];
		uziUpgrade[3] = [[200, 0], [190, 150], [200, 300], [210, 350], [220, 400], [230, 450], [240, 500], [275, 250]];
		uziUpgrade[4] = [[.15, 0], [.14, 200], [.13, 225], [.12, 250], [.11, 275], [.10, 300], [.09, 350], [.08, 400], [.075, 500]];
		uziUpgrade[5] = [[10, 0], [12, 500], [14, 650], [16, 800]];
		
		sniperUpgrade[0] = [[200, 0], [225, 500], [250, 750], [275, 1000], [300, 1250], [325, 1500], [350, 2000]];
		sniperUpgrade[2] = [[1250, 0], [1200, 700], [1150, 900], [1100, 1200], [1050, 1500], [1000, 1800], [950, 2100], [900, 2500], [850, 3000], [800, 3500], [750, 4000]];//cooldown
		sniperUpgrade[3] = [[175, 0], [180, 500], [185, 700], [190, 900], [195, 1050], [200, 1200]];//weight
		sniperUpgrade[1] = [[1, 0], [2, 1000], [3, 1200], [4, 1400], [5, 1600], [6, 1800], [7, 2000], [8, 2200]];//piercing
		
		gatlingUpgrade[0] = [[30, 0], [35, 500], [40, 800], [45, 1200], [50, 1500], [55, 1800], [60, 2300], [65, 2800], [70, 3500], [75, 5000]];
		gatlingUpgrade[1] = [[170, 0], [180, 400], [190, 600], [200, 750], [210, 900], [225, 1050], [250, 1500], [300, 2000], [350, 2500], [400, 3000], [450, 3500], [500, 4250]];
		gatlingUpgrade[2] = [[50, 0], [40, 1000], [33, 2000], [28, 3000], [25, 4500], [22, 6000], [20,  8000]];
		gatlingUpgrade[3] = [[125, 0], [130, 500], [135, 650], [140, 800], [150, 1250], [155, 1250], [160, 1500], [165, 2000], [175, 3500]];
		gatlingUpgrade[4] = [[.2, 0], [.19, 450], [.18, 600], [.17, 750], [.16, 900], [.15, 1050], [.14, 1200], [.13, 1400], [.12, 1600], [.11, 1800], [.1, 2000], [.09, 2500], [.08, 3000]];
	
		public static var weaponUpgrade:Array = [pistolUpgrade, shotgunUpgrade, uziUpgrade, sniperUpgrade, gatlingUpgrade];
		*/
		public static var rollover:Boolean = false;
		public static var weaponUpgrade:Array = 
		[
		[	//PISTOL
		[[75, 0], [85, 250], [95, 350], [105, 500], [115, 550], [125, 600]],	//damage
		[[250, 0], [300 , 200], [400 , 250], [500, 300]],//range
		[[500, 0], [450, 300], [400, 450], [350, 550], [300, 675], [250, 800]],//cooldown
		[[200, 0], [205, 300], [215, 550], [225, 750], [235, 875], [245, 1000]],//weight
		[[.1, 0], [.09, 100], [.08, 125], [.07, 150], [.06, 175], [.05, 200]]//accuracy
		],
		[	//shotgun
		[[45, 0], [50, 400], [55, 500], [60, 600], [60, 700], [75, 800]],//damage
		[[110, 0], [125, 350], [135, 400], [145, 450], [155, 500], [170, 750]],//range
		[[750, 0], [700, 400], [650, 550], [600, 600], [550, 650], [500, 700]],//cooldown
		[[175, 0], [180, 150], [190, 300], [200, 400], [210, 500], [220, 600]],//weight
		[[.2, 0], [.18, 200], [.16, 250], [.14, 300], [.12, 350], [.1, 400]],//accuracy
		[[4, 0], [5, 600], [6, 800], [7, 1000], [8, 1200]]//buckshot
		],
		[	//uzi
		[[45, 0], [50, 400], [55, 500], [60, 600], [65, 800], [70, 900], [75, 1050], [80, 1200]],//damage
		[[200, 0], [225, 300], [250, 350], [275, 400], [300, 450]],//range
		[[1100, 0], [1050, 400], [1000, 600], [950, 750], [900, 850], [850, 900], [800, 1000]],//cooldown
		[[185, 0], [190, 150], [200, 300], [210, 450], [220, 600], [235, 900]],//weight
		[[.15, 0], [.14, 175], [.13, 225], [.12, 250], [.11, 275], [.10, 300], [.09, 350], [.08, 400], [.070, 400]],//accuracy
		[[10, 0], [12, 600], [14, 800], [16, 1000]]//clip size
		],
		[	//sniper
		[[200, 0], [225, 500], [250, 750], [275, 1000], [300, 1250], [325, 1500], [350, 2000]],	//damage
		[[1, 0], [2, 1000], [3, 1200], [4, 1400], [5, 1600], [6, 1800], [7, 2000], [8, 2200]],//piercing
		[[1250, 0], [1200, 700], [1150, 900], [1100, 1200], [1050, 1500], [1000, 1800], [950, 2100], [900, 2500], [850, 3000], [800, 3500], [750, 4000]],//cooldown
		[[175, 0], [180, 500], [185, 700], [190, 900], [195, 1050], [200, 1200]]//weight
		],
		[	//gatling
		[[30, 0], [35, 500], [40, 800], [45, 1200], [50, 1500], [55, 1800], [60, 2300], [65, 2800], [70, 3500], [75, 5000]],//damage
		[[170, 0], [180, 400], [190, 600], [200, 750], [210, 900], [225, 1050], [250, 1500], [300, 2000], [350, 2500], [400, 3000], [450, 3500], [500, 4250]],//range
		[[50, 0], [40, 1000], [33, 2000], [28, 3000], [25, 4500], [22, 6000], [20,  8000]],//cooldown
		[[125, 0], [130, 500], [135, 650], [140, 800], [150, 1250], [155, 1250], [160, 1500], [165, 2000], [175, 3500]],//weight
		[[.2, 0], [.19, 450], [.18, 600], [.17, 750], [.16, 900], [.15, 1050], [.14, 1200], [.13, 1400], [.12, 1600], [.11, 1800], [.1, 2000], [.09, 2500], [.08, 3000]]//accuracy
		]
		];
	}
	
}