package 
{
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import AGtoolkit;
	/**
	 * ...
	 * @author Joel
	 */
	public dynamic class AGcontainer extends MovieClip
	{
		public var score : Number = 0;
		public var agtools : AGtoolkit;
		
		public function init():void {
			agtools = new AGtoolkit(this, "7410", "zombiecop", "Joel Evans");
			agtools.AGgameScore("score", "points", "integer");
			agtools.AGinitToolkit(function():void { throw new Error("WORKS");} );
		}
		public function submitScores():void {
			agtools.AGgameover();
			//agtools.AGgameoverScreen(false);	//try this again with false
		}
	}
	
}