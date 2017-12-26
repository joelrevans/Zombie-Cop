package 
{
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.events.TimerEvent;
	import flash.utils.getDefinitionByName;
	import flash.utils.Timer;
	import mochi.as3.*;
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.external.ExternalInterface;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.events.ContextMenuEvent;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	/**
	 * ...
	 * @author Joel
	 */

	 public class Preloader extends MovieClip
	{
		private var but : Button;		//Contains clp, adds click functionality.
		private var clp : Clip;			//Contains the preloader clip.
		public static var site : String;
		private var introPlayed : Boolean = false;
		private var loadingComplete : Boolean = false;
		//private var main : Main;
		
		private var loadBar : Shape;
		
		//public static var Main : Class;
		
		public static var preloader : Preloader;
		
		/**/
		public var _mochiad : MovieClip;
		public var _mochiad_loaded : Boolean;
		public var origFrameRate : uint;
		public var clip : MovieClip;
		/**/
		
		public function Preloader() 
		{
			stop();
			preloader = this;
			
			var url : String = ExternalInterface.available ? ExternalInterface.call("window.location.href.toString") : url = loaderInfo.url;
			
			if (url == null || url.indexOf("file://") != -1){
				jolSplash();
			}else if (url.indexOf("addictinggames") != -1) {
				site = "addictinggames";
				jolSplash();
			}else {
				site = "mochi";
				MochiServices.connect("82d8b781c11c25a9", this);
				MochiAd.showPreGameAd( {clip: this, id:"82d8b781c11c25a9", res:"500x440", no_bg: true, no_progress_bar: true, ad_finished: jolSplash});
			}
			
			loaderInfo.addEventListener(ProgressEvent.PROGRESS, progress);
			loaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioError);
			
			loadBar = new Shape();
			addChild(loadBar);
			
			//Context Menu
			var author:ContextMenuItem = new ContextMenuItem("Created by Joel Evans");
			author.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(e:Event):void { navigateToURL(new URLRequest("http://adventuresofjoel.com/pages/home.htm")) } );
			if(site=="addictinggames"){
				var sponsor:ContextMenuItem = new ContextMenuItem("Play More Games at Addictinggames.com!");	//SPONSOR INFO INSERT
				sponsor.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, function(e:Event):void { navigateToURL(new URLRequest("http://www.addictinggames.com/")) } );
			}
			
			var con:ContextMenu = new ContextMenu();
			con.hideBuiltInItems();
			
			if(site == "addictinggames")
				con.customItems = [author, sponsor];
			else
				con.customItems = [author];
			
			contextMenu = con;
			
			contextMenu.addEventListener(ContextMenuEvent.MENU_SELECT, menuselect);
		}
		
		private function jolSplash():void {
			[Embed(source = '../graphics/Preloader Splash Page/Compressed/sequence0001.jpg')]var f1 : Class;
			[Embed(source = '../graphics/Preloader Splash Page/Compressed/sequence0002.jpg')]var f2 : Class;
			[Embed(source = '../graphics/Preloader Splash Page/Compressed/sequence0003.jpg')]var f3 : Class;
			[Embed(source = '../graphics/Preloader Splash Page/Compressed/sequence0004.jpg')]var f4 : Class;
			[Embed(source = '../graphics/Preloader Splash Page/Compressed/sequence0005.jpg')]var f5 : Class;
			[Embed(source = '../graphics/Preloader Splash Page/Compressed/sequence0006.jpg')]var f6 : Class;
			[Embed(source = '../graphics/Preloader Splash Page/Compressed/sequence0007.jpg')]var f7 : Class;
			[Embed(source = '../graphics/Preloader Splash Page/Compressed/sequence0008.jpg')]var f8 : Class;
			[Embed(source = '../graphics/Preloader Splash Page/Compressed/sequence0009.jpg')]var f9 : Class;
			[Embed(source = '../graphics/Preloader Splash Page/Compressed/sequence0010.jpg')]var f10 : Class;
			[Embed(source = '../graphics/Preloader Splash Page/Compressed/sequence0011.jpg')]var f11 : Class;
			[Embed(source = '../graphics/Preloader Splash Page/Compressed/sequence0012.jpg')]var f12 : Class;
			[Embed(source = '../graphics/Preloader Splash Page/Compressed/sequence0013.jpg')]var f13 : Class;
			[Embed(source = '../graphics/Preloader Splash Page/Compressed/sequence0014.jpg')]var f14 : Class;
			[Embed(source='../graphics/Preloader Splash Page/Compressed/sequence0015.jpg')]var f15 : Class;
			var lastframe : Bitmap = new f15();
			clp = new Clip(16, [new f1(),new f2(),new f3(),new f4(),new f5(),new f6(),new f7(),new f8(),new f9(),new f10(),new f11(),new f12(),new f13(),new f14(), lastframe, lastframe, lastframe, lastframe, lastframe, lastframe, lastframe, lastframe, lastframe, lastframe, lastframe, lastframe, lastframe, lastframe, lastframe, lastframe, lastframe]);
			clp.loop = false;
			clp.onComplete = function():void { introPlayed = true;  startup();};
			clp.y = (500 - clp.height) / 2;
			but = new Button();
			but.target = clp;
			but.release = function():void { navigateToURL(new URLRequest("http://adventuresofjoel.com"));}
			addChild(clp);
		}
		
		private function menuselect(e:Event):void {
			addEventListener(MouseEvent.CLICK, menureturn);	//THIS IS NOT CALLED WHEN OTHER CLICK EVENTS ARE PRESENT.  IDK WHY.	  Putting mouse.hide in other event listeners.
		}
		private function menureturn(e:MouseEvent):void {
			removeEventListener(MouseEvent.CLICK, menureturn);
			Mouse.hide();
		}
		
		private function ioError(e:IOErrorEvent):void 
		{
			trace(e.text);
		}
		
		private function progress(e:ProgressEvent):void 
		{
			loadBar.graphics.clear();
			loadBar.graphics.beginFill(0);
			loadBar.graphics.drawRect(0, 470, 500, 30);
			loadBar.graphics.endFill();
			loadBar.graphics.lineStyle(1, 0xFFFFFFFF);
			loadBar.graphics.drawRect(20, 470, 460, 10);
			loadBar.graphics.beginFill(0xFFFFFF, 1);
			loadBar.graphics.drawRect(20, 470, 460 * e.bytesLoaded / e.bytesTotal, 10);
			loadBar.graphics.endFill();
			
			if (e.bytesLoaded / e.bytesTotal == 1){
				loadingComplete = true;
				loaderInfo.removeEventListener(ProgressEvent.PROGRESS, progress);
				loaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, ioError);
				startup();
			}
		}
		
		private function startup():void
		{
			if (loadingComplete && introPlayed) {
				removeChild(clp);
				but.release = null;
				but = null;
				clp = null;
				removeChild(loadBar);
				
				if(site == "addictinggames"){
					[Embed(source = '../graphics/AGteaser_mc.swf', symbol = 'AGteaser_mc')]var agint:Class;
					var n : MovieClip = new agint();
					n.addEventListener(Event.ENTER_FRAME, agclose);
					n.y = 62;
					addChild(n);
					n.addEventListener(MouseEvent.CLICK, function(e:Event):void{navigateToURL(new URLRequest("http://www.addictinggames.com/"));});
				}else {
					attachMain();
				}
			}
		}
		
		private function agclose(e:Event):void {
			var m : MovieClip = MovieClip(getChildAt(0));
			if (m.currentFrame == m.totalFrames) {
				removeChild(m);
				m.stop();
				attachMain();
				m.removeEventListener(Event.ENTER_FRAME, agclose);
			}
		}
		
		private function attachMain():void {
			gotoAndStop(2);
			var mainClass : Class = getDefinitionByName("Main") as Class;
			addChild(new mainClass() as Sprite);
		}
	}
}