package waters {
	
	import starling.display.Sprite;  
	import waters.Wave;
	
	public class Dot extends Sprite {
		
		private var waves:Array;
		
		public function Dot() {
			waves = new Array();
		}
		
		public function addWave(w:Wave):void {
			waves.push(w);
		}  

		public function toString():String {
			return "x: "+Math.round(x).toString()+" , "+Math.round(y).toString();
		}
		
		public function getWaves():Array {
			return waves;
		}
//-----		
	}
}