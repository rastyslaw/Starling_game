package waters {
	
	import starling.display.Sprite;
	 
	public class Wave extends Sprite {
		
		private var index:int;
		private var A:Number;
		private var dir:Number;
		private var startTime:Number;
		private var firstOne:Boolean;
		private var startX:Number;
		 
		public function setIndex(val:int):void { 
			index = val;
		}
		public function getIndex():int { 
			 return index;
		}
		public function setA(val:Number):void { 
			A = val;
		}
		public function getA():Number { 
			 return A;
		}
		public function setDir(val:Number):void { 
			dir = val;
		}
		public function getDir():Number { 
			 return dir;
		}
		public function setStartTime(val:Number):void { 
			startTime = val;
		}
		public function getStartTime():Number { 
			 return startTime;
		}
		public function setFirstOne(val:Boolean):void { 
			firstOne = val;
		}
		public function getFirstOne():Boolean { 
			 return firstOne;
		}
		public function setStartX(val:Number):void { 
			startX = val;
		} 
		public function getStartX():Number { 
			 return startX;
		}
//-----		
	}
}