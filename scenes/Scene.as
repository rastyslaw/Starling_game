package scenes {
	import flash.net.SharedObject;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import starling.animation.DelayedCall;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
    import starling.display.Button;
	import starling.display.Image;
	import starling.display.MovieClip;
    import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
    
    public class Scene extends Sprite {
        
		private var mBackButton:Button; 
        private var backbtn:Button;
		
        public function Scene() { 
            var frames:Vector.<Texture> = Game.assets.getTextures("music"); 
			var musMovie:MovieClip = new MovieClip(frames, 30); 
			musMovie.x = 330; 
		    musMovie.y = 8;
			musMovie.name = "mnd";
		    addChild(musMovie); 
			frames = Game.assets.getTextures("sound");  
			var sndMovie:MovieClip = new MovieClip(frames, 30); 
			sndMovie.x = 366;
		    sndMovie.y = 8; 
			sndMovie.name = "snd";
		    addChild(sndMovie); 
			sndMovie.addEventListener(TouchEvent.TOUCH, onClick);
			musMovie.addEventListener(TouchEvent.TOUCH, onClick);
	
			if (!Game.music) musMovie.currentFrame = 1;  
			if (!Game.sound) sndMovie.currentFrame = 1; 
				 
			create_back(); 
			create_more();
        } 
		
		private function onClick(event:TouchEvent):void {
			var hoverTouch:Touch = event.getTouch(this, TouchPhase.HOVER);
			Mouse.cursor = hoverTouch ? MouseCursor.BUTTON : MouseCursor.ARROW;
			if(event.getTouch(this, TouchPhase.BEGAN)) {
				var clicked:MovieClip = event.currentTarget as MovieClip;
				clicked.currentFrame == 0 ? clicked.currentFrame = 1 : clicked.currentFrame = 0;
				clicked.name == "mnd" ? Game.music = !Game.music : Game.sound = !Game.sound;
				//musicEnv.played(Game.music);   
				if(Game.music) Game.soundManager.crossFade(null, "menu", 5, 0.7, 999); 
					else Game.soundManager.crossFade("menu", null, 5, 0.7, 999);  
				var mySo:SharedObject = SharedObject.getLocal("save_game_data_fish");
				mySo.data.S_sound = Game.sound; 
				mySo.data.S_music = Game.music;   
				mySo.flush();
			} 
        } 
		
		public function createCloud():void {
			create_cloud(true, 20);  
			var delayedCall:DelayedCall = new DelayedCall(create_cloud, 12);
			delayedCall.repeatCount = int.MAX_VALUE; 
			Starling.juggler.add(delayedCall); 
		}
		  
		private function create_cloud(bol:Boolean = false, time:int=40):void {    
			var n:int = 1 + Math.floor(Math.random() * 2.99);
			var clip:Image = new Image(Game.assets.getTexture("cloud"+n));  
			bol ? clip.x = 200 : clip.x = 480;     
			clip.y = 10+ Math.random() * 70;    
			addChildAt(clip, 1);
			var level:int = Game.level; 
			if (level == 3 || level == 4 || level == 8 || level == 9 || level == 13 || level == 14 || level == 18 || level == 19)
				clip.alpha = 0.5;  
			var tween:Tween = new Tween(clip, time, Transitions.LINEAR);
			tween.moveTo(-clip.width, clip.y);   
			tween.onComplete = clip.removeFromParent; 
			Starling.juggler.add(tween);   
		}
		 
		public function create_back():void {
			var btn6Texture:Texture = Game.assets.getTexture("back"); 
			backbtn = new Button(btn6Texture, ""); 
            backbtn.x = 10;  
            backbtn.y = 9;  
			backbtn.name = "back";  
            addChild(backbtn);
		}
		
		public function create_more():void {
			var infoText5:TextField = new TextField(68, 15,  
                "more games", "Arnold 2.1", 11, 0xffffff);    
            infoText5.x = 174;    
			infoText5.y = 224;        
            addChild(infoText5);
			infoText5.addEventListener(TouchEvent.TOUCH, moreGamesClicked); 
        }
		
		private function moreGamesClicked(event:TouchEvent):void {
			var hoverTouch:Touch = event.getTouch(this, TouchPhase.HOVER);
			Mouse.cursor = hoverTouch ? MouseCursor.BUTTON : MouseCursor.ARROW;
            if (event.getTouch(this, TouchPhase.ENDED)) {
				trace("moreGamesClicked");  
				//var myURL:URLRequest = new URLRequest("");   
				//navigateToURL(myURL, "_blank");  
			}
        }
		
		public function set backname(value:String):void {
			backbtn.name = value;  
		}
//-----		
    }
}