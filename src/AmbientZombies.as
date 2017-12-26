package 
{
	import flash.events.TimerEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundTransform;
	import flash.utils.Timer;
	/**
	 * ...
	 * @author DefaultUser (Tools -> Custom Arguments...)
	 */
	public class AmbientZombies 
	{
		[Embed(source = '../Sound/final/zombiegroan.mp3')]private static const grn1:Class;
		[Embed(source = '../Sound/final/zombiegroanDuos.mp3')]private static const grn2:Class;
		[Embed(source = '../Sound/final/zombiegroanQuatros.mp3')]private static const grn3:Class;
		[Embed(source = '../Sound/final/uprising.mp3')]private static const upr:Class;
		[Embed(source = '../Sound/final/splatter1.mp3')]private static const spl1:Class;
		[Embed(source = '../Sound/final/splatter2.mp3')]private static const spl2:Class;
		[Embed(source = '../Sound/final/splatter3.mp3')]private static const spl3:Class;
		private static var sn1:Sound = new grn1();
		private static var sn2:Sound = new grn2();
		private static var sn3:Sound = new grn3();
		private static var sn4:Sound = new upr();
		private static var sn5:Sound = new spl1();
		private static var sn6:Sound = new spl2();
		private static var sn7:Sound = new spl3();
		//trace(sn1.length, sn2.length, sn3.length);
		private static var chan1:SoundChannel = sn1.play(0,int.MAX_VALUE, new SoundTransform(0));
		private static var chan2:SoundChannel = sn2.play(0,int.MAX_VALUE, new SoundTransform(0));
		private static var chan3:SoundChannel = sn3.play(0,int.MAX_VALUE, new SoundTransform(0));
		private static var vol1:Number = 0;
		private static var vol2:Number = 0;
		private static var vol3:Number = 0;	
		private static var t:Timer = new Timer(/*20*/50, 0);
		t.start();
		private static var vl:Number = .4;  //Kind of like the maximum volume cap. 
		
		public static function update(zombiesLeft:uint):void {
			switch(zombiesLeft) {
				case 0:
				easeTo(1, 0);
				easeTo(2, 0);
				easeTo(3, 0);
				return;
				case 1:
				easeTo(1, vl);
				easeTo(2, 0);
				easeTo(3, 0);
				return;
				case 2:
				easeTo(2, vl);
				easeTo(1, 0);
				easeTo(3, 0);
				return;
				case 3:
				easeTo(1, vl);
				easeTo(2, vl);
				easeTo(3, 0);
				return;
				case 4:
				easeTo(1, 0);
				easeTo(2, 0);
				easeTo(3, vl);
				return;
				case 5:
				easeTo(1, vl);
				easeTo(2, 0);
				easeTo(3, vl);
				return;
				case 6:
				easeTo(1, 0);
				easeTo(2, vl);
				easeTo(3, vl);
				return;
				default:
				easeTo(1, vl);
				easeTo(2, vl);
				easeTo(3, vl);
			}
		}
		public static function uprising():void {
			sn4.play();
		}
		public static function lowkey():void {
			easeTo(1, .1);
			easeTo(2, .1);
			easeTo(3, .1);
		}
		private static var num:uint = 0;
		public static function splatter():void {
			switch(++num%3) {
				case 0:
				sn5.play(0,0, new SoundTransform(2));
				break;
				case 1:
				sn6.play(0,0, new SoundTransform(2));
				break;
				case 2:
				sn7.play(0,0, new SoundTransform(2));
			}
		}
		public static function stop():void {
			easeTo(1, 0);
			easeTo(2, 0);
			easeTo(3, 0);
		}
		private static function easeTo(snd:uint, lvl:Number):void {
			switch(snd) {
				case 1:
				vol1 = lvl;
				//vol1 = 0;
				t.addEventListener(TimerEvent.TIMER, ease1);
				break;
				case 2:
				vol2 = lvl;
				t.addEventListener(TimerEvent.TIMER, ease2);
				break;
				case 3:
				vol3 = lvl;
				t.addEventListener(TimerEvent.TIMER, ease3);
				break;
			}
		}
		private static function ease1(e:TimerEvent):void {
			if (chan1.soundTransform.volume == vol1) {
				t.removeEventListener(TimerEvent.TIMER, ease1);
			}
			chan1.soundTransform = new SoundTransform(chan1.soundTransform.volume + (chan1.soundTransform.volume > vol1 ? -.011 : .011));
		}
		private static function ease2(e:TimerEvent):void {
			if (chan2.soundTransform.volume == vol2) {
				t.removeEventListener(TimerEvent.TIMER, ease2);
			}
			chan2.soundTransform = new SoundTransform(chan2.soundTransform.volume + (chan2.soundTransform.volume > vol2 ? -.011 : .011));
		}
		private static function ease3(e:TimerEvent):void {
			if (chan3.soundTransform.volume == vol3) {
				t.removeEventListener(TimerEvent.TIMER, ease3);
			}
			chan3.soundTransform = new SoundTransform(chan3.soundTransform.volume + (chan3.soundTransform.volume > vol3 ? -.011 : .011));
		}
	}
	
}