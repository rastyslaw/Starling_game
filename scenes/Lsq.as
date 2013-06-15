package scenes {
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author waltassar
	 */
	public class Lsq extends Sprite{ 
		
		private var ttFont:String = "Arnold 2.1";
		private var frames:Vector.<Texture>;
		private var frames2:Vector.<Texture>;
		private var _str:String;
		private var lockImg:Image;
		private var islock:Boolean;
		
		public function Lsq(s:String, bol:Boolean=true, frame:int=0) { 
			var clip:MovieClip;
			islock = bol;  
			_str = s;   
			frames = Game.assets.getTextures("levelsq");  
			clip = new MovieClip(frames);
			addChild(clip);
			if(bol){	 
				frames2 = Game.assets.getTextures("starbar"); 
				clip = new MovieClip(frames2);  
				clip.x = 5; 
				clip.y = 23;  
				addChild(clip); 
				clip.currentFrame = frame;
				 
				var infoText:TextField = new TextField(30, 24, s, ttFont, 20, 0xffffff);    
				infoText.x = 4;     
				infoText.y = 2;  
				addChild(infoText);  
			}
			else {
				lockImg = new Image(Game.assets.getTexture("lock"));
				lockImg.x = 9;
				lockImg.y = 8; 
				addChild(lockImg); 
			}
			addEventListener(TouchEvent.TOUCH, clickMy);
		}
		 
		public function clickMy(event:TouchEvent):void {
            if (event.getTouch(this, TouchPhase.BEGAN)) { 
				this.scaleX = this.scaleY = 0.9;
				this.x += 2;
				this.y += 2;
			} 
			else if (event.getTouch(this, TouchPhase.ENDED)) { 
				this.scaleX = this.scaleY = 1;
				this.x -= 2;
				this.y -= 2;
				dispatchEvent(new Event("LsqClick"));    
			}
		}
		
		public override function dispose():void {
			var i:int; 
			for (i = 0; i < frames.length; i++) {
				frames[i].dispose();
			}
			if(islock) {
				for (i = 0; i < frames2.length; i++) {
					frames2[i].dispose();
				}
			}
            super.dispose();
        }
		
		public function get str():String { 
			return _str;
		}
		
//-----		
	}
}