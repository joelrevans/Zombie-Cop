package 
{
	import flash.geom.Point;
	
	/**
	 * ...
	 * @author ...
	 */
	public class SaveFile 
	{
		private var ownsShotgun:Boolean;
		private var ownsUzi:Boolean;
		private var ownsSniper:Boolean;
		private var ownsGatling:Boolean;
		/*
		private var pistolRange:Number;
		private var shotgunRange:Number;
		private var uziRange:Number;
		private var gatlingRange:Number;
		
		private var pistolAccuracy:Number;
		private var shotgunAccuracy:Number;
		private var uziAccuracy:Number;
		private var gatlingAccuracy:Number;
		
		private var pistolDamage:Number;
		private var shotgunDamage:Number;
		private var uziDamage:Number;
		private var sniperDamage:Number;
		private var gatlingDamage:Number;
		
		private var pistolRate:Number;
		private var shotgunRate:Number;
		private var uziRate:Number;
		private var sniperRate:Number;
		private var gatlingRate:Number;
		
		private var pistolLightness:Number;
		private var shotgunLightness:Number;
		private var uziLightness:Number;
		private var sniperLightness:Number;
		private var gatlingLightness:Number;
		*/
		private var buckShot:uint;
		private var piercing:uint;
		private var rollover:Boolean;
		
		private var monies:Number;
		private var earnt:Number;
		
		private var heroPosition:Point;
		
		private var weaponUpgrade:Array = new Array();
		
		public function saveGlobal():void {
			ownsShotgun = Global.ownsShotgun;
			ownsUzi = Global.ownsUzi;
			ownsSniper = Global.ownsSniper;
			ownsGatling = Global.ownsGatling;
			/*
			pistolAccuracy = Global.pistolAccuracy;
			shotgunAccuracy = Global.shotgunAccuracy;
			uziAccuracy = Global.uziAccuracy;
			gatlingAccuracy = Global.gatlingAccuracy;
			
			pistolDamage = Global.pistolDamage;
			shotgunDamage = Global.shotgunDamage;
			uziDamage = Global.uziDamage;
			sniperDamage = Global.sniperDamage;
			gatlingDamage = Global.gatlingDamage;
			
			pistolLightness = Global.pistolLightness;
			shotgunLightness = Global.shotgunLightness;
			uziLightness = Global.uziLightness;
			sniperLightness = Global.sniperLightness;
			gatlingLightness = Global.gatlingLightness;
			
			buckShot = Global.buckShot;
			piercing = Global.piercing;
			*/
			rollover = Global.rollover;
			
			monies = Global.monies;
			earnt = Global.earnt;
			
			heroPosition = new Point(Hero.hero.x, Hero.hero.y);
			
			//weaponUpgrade = Global.weaponUpgrade.concat();	//copies upgrade table.
			for (var i:uint = 0; i < 5; i++) {
				weaponUpgrade[i] = new Array();
				for (var b:uint =0; b < Global.weaponUpgrade[i].length; b++){
					weaponUpgrade[i][b] = Global.weaponUpgrade[i][b][0][1];
				}
			}
			//weaponUpgrade[0] = [Global.pistolUpgrade[0][0][0][1],Global.pistolUpgrade[1][0][0][1]], Global.pistolUpgrade[2][0][0][1], Global.pistolUpgrade[3][0][0][1], Global.pistolUpgrade[4][0][0][1], Global.pistolUpgrade[5][0][0][1]];
		}
		
		public function loadGlobal():void {
			Global.ownsShotgun = ownsShotgun;
			Global.ownsUzi = ownsUzi;
			Global.ownsSniper = ownsSniper;
			Global.ownsGatling = ownsGatling;
			/*
			Global.pistolAccuracy = pistolAccuracy;
			Global.shotgunAccuracy = shotgunAccuracy;
			Global.uziAccuracy = uziAccuracy;
			Global.gatlingAccuracy = gatlingAccuracy;
			
			Global.pistolDamage = pistolDamage;
			Global.shotgunDamage = shotgunDamage;
			Global.uziDamage = uziDamage;
			Global.sniperDamage = sniperDamage;
			Global.gatlingDamage = gatlingDamage;
			
			Global.pistolLightness = pistolLightness;
			Global.shotgunLightness = shotgunLightness;
			Global.uziLightness = uziLightness;
			Global.sniperLightness = sniperLightness;
			Global.gatlingLightness = gatlingLightness;
			
			Global.buckShot = buckShot;
			Global.piercing = piercing;
			*/
			Global.rollover = rollover;
			
			Global.monies = monies;
			Global.earnt = earnt;
			
			Hero.hero.x = heroPosition.x;
			Hero.hero.y = heroPosition.y;
			
			//Global.weaponUpgrade = weaponUpgrade;	//restores upgrade table
			
			for (var i:uint = 0; i < 5; i++) {
				for (var b:uint = 0; b < Global.weaponUpgrade[i].length; b++){
					Global.weaponUpgrade[i][b][0][1] = weaponUpgrade[i][b];
				}
			}
		}
	}
	
}