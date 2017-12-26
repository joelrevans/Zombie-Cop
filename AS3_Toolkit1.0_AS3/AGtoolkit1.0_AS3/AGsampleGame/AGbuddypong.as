package {
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.net.*;
	import flash.utils.*;
	import flash.media.*
	
	public class AGbuddypong extends MovieClip {
		public var myToolkit:AGtoolkit;
		
		public var user:Object = null;
		public var leaderboard:Array = null;
		
		public var score:Number = 0;
		public var xv:Number;
		public var yv:Number;
		public var speed:Number = 5;
		public var bounce:Sound = new sndBounce();
		public var point:Sound = new sndPoint();
		
		public var nextIndex:int;
		public var nextLoader:Loader = new Loader();
		public var nextRequest:URLRequest = new URLRequest();
		public var pongLoader:Loader = new Loader();
		public var pongRequest:URLRequest = new URLRequest();
		
		public var timer:Timer = new Timer(10);
		public var running:Boolean = false;
		
		//::::: constructor - document class
		public function AGbuddypong():void {
			//begin AGtoolkit initialization methods
			myToolkit = new AGtoolkit(this, '5006', 'hs_sdk', 'beech');
			myToolkit.AGsetToolbar('restart', gameInit);
			myToolkit.AGsetToolbar('pause', gamePause);
			myToolkit.AGgameScore('score', 'pongs', 'integer');
			myToolkit.AGinitToolkit(gameInit);
			//end AGtoolkit initialization methods
			
			nextBox.addChild(nextLoader);
			pong.addChild(pongLoader);
			
			nextLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, setNext);
			pongLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, setPong);
			
			startBtn.addEventListener(MouseEvent.CLICK, gameStart);
			timer.addEventListener(TimerEvent.TIMER, updateGame);
		}
		
		//::::: game initialization method - also used as the 'restart' method in this game configuration
		public function gameInit():void {
			timer.stop();
			
			running = false;
			startBtn.visible = true;
			getEm.visible = false;
			
			pong.x = 80;
			pong.y = 200;
			paddle.y = 200;
			xv = yv = speed;
			score = 0;
			scoreTxt.text = String(score);
			
			//initiate userdata loading
			myToolkit.AGgetUser(returnUser);
		}
		
		public function returnUser(userObject:Object):void {
			 //userObject: {name:String, rank:int, score:Number, time:int, image:String, page:String}
			 user = userObject; trace('user: ' + user);
			
			//if the user is logged in we can then attempt to get a leaderboard
			if(user != null) {
				userTxt.text = user.name;
				myToolkit.AGgetLeaderboard(returnLeaderboard, 'Friends', 'AllTime');
			}
		}
		
		public function returnLeaderboard(userObjectArray:Array):void {
			leaderboard = userObjectArray; trace('board: ' + leaderboard);
			if(leaderboard != null && leaderboard.length>1) { nextIndex = leaderboard.length-1; updateNext(); }
		}
		
		//::::: game pause method
		public function gamePause(state:String):void {
			if(!running) return;
			if(state == 'on') timer.start();
			if(state == 'off') timer.stop();
		}
		
		//::::: game gameover method
		public function gameOver():void {
			timer.stop();
			running = false;
			
			//at endgame call the AGtoolkit method to initiate the gameover sequence
			myToolkit.AGgameover(); 
		}
		
		//::::: game start play method
		public function gameStart(e:MouseEvent):void {
			startBtn.visible = false;
			running = true;
			timer.start();
		}
		
		//::::: game runtime operations method
		public function updateGame(e:TimerEvent):void {
			pong.x += xv;
			pong.y += yv;
			
			if(frame.hitTestPoint(pong.x-(pong.width/2), pong.y, true) || frame.hitTestPoint(pong.x+(pong.width/2), pong.y, true)) {  pong.x -= xv; pong.y -= yv; xv *= -1; var channelx:SoundChannel = bounce.play(); }
			if(frame.hitTestPoint(pong.x, pong.y-(pong.height/2), true) || frame.hitTestPoint(pong.x, pong.y+(pong.height/2), true)) { pong.x -= xv; pong.y -= yv; yv *= -1; var channely:SoundChannel = bounce.play(); }
			
			if(paddle.hitTestPoint(pong.x-(pong.width/2), pong.y, true)) { pong.x = paddle.x+(10+(pong.width/2)); xv *= -1; updateScore(); }
			if(paddle.hitTestPoint(pong.x+(pong.width/2), pong.y, true)) { pong.x = paddle.x-(10+(pong.width/2)); xv *= -1; updateScore(); }
			if(paddle.hitTestPoint(pong.x, pong.y-(pong.height/2), true)) { pong.y = paddle.y+(25+(pong.height/2)); yv *= -1; updateScore(); }
			if(paddle.hitTestPoint(pong.x, pong.y+(pong.height/2), true)) { pong.y = paddle.y-(25+(pong.height/2)); yv *= -1; updateScore(); }
			
			if(pong.x < -20) gameOver();
			
			paddle.y = mouseY;
			if(paddle.y - 25 < 60) paddle.y = 85;
			if(paddle.y + 25 > 340) paddle.y = 315;
		}
		
		//::::: game score update method
		public function updateScore():void {
			paddle.play();
			var channel:SoundChannel = point.play();
			score++; scoreTxt.text = String(score);
			
			//check to assure we have a user and user friends in the leaderboard
			if(user != null && leaderboard != null) {
				if(nextIndex < 0) return; //skips the rest of the statement if the player is in the top rank position
				
				if(getEm.visible) {
					getEm.visible = false;
					pongLoader.unload();
					pong.gotoAndStop(1);
					nextIndex--;
					updateNext();
				}
				
				//iterates through the leaderboard and determines if the player will pass the 'next' friend with the next point
				for(var i=0; i<leaderboard.length; i++) {
					if(score == leaderboard[i].score) { setTimeout(initPong, 100, i); break; }
				}
			}
		}
		
		//helper method updates the 'next' friend you will pass
		public function updateNext():void {
			nextLoader.unload();
			nextRequest.url = (nextIndex < 0) ? user.image : leaderboard[nextIndex].image;
			nextLoader.load(nextRequest);
			nextTxt.text = (nextIndex < 0) ? user.name : leaderboard[nextIndex].name;
		}
		
		//helper method sets the image of the 'next' friend box to the correct size for the space
		public function setNext(e:Event):void {
			var img = e.target.content;
			var scale = (img.width >= img.height) ? (30 / img.width) : (30 / img.height);
			img.scaleX = img.scaleY = scale;
			img.x = -img.width / 2;
			img.y = -img.height / 2;
		}
		
		//helper method sets the 'pong' to an image of the friend you are about to pass on the next point
		public function initPong(index:int):void {
			timer.stop();
			getEm.visible = true;
			pong.gotoAndStop(2);
			pongRequest.url = leaderboard[index].image;
			pongLoader.load(pongRequest);
		}
		
		//helper method sets the image of the friend to the pong size
		public function setPong(e:Event):void {
			var img = e.target.content;
			img.width = img.height = 20;
			img.x = img.y = -10;
			timer.start();
		}
		
		
	}
	
}