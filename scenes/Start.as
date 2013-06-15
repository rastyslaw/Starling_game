package scenes {
	import flash.net.SharedObject;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	/**
	 * ...
	 * @author waltassar
	 */
	public class Start extends Scene {
		
		private var container:Sprite = new Sprite; 
		private var btn1Texture:Texture;
		private var starImage:Image;
		private var stars:int;
		private var mas:Vector.<int>;
		private var star:int;
		  
		public function Start() {
			var mySo:SharedObject = SharedObject.getLocal("save_game_data_fish"); 
			if (mySo.data.Smas != undefined) mas = mySo.data.Smas;
				else mas = new Vector.<int>(20, true);
			if (mySo.data.Sstars != undefined) star = mySo.data.Sstars; 
				else star = 0;	
			init();
		} 
		
		private function init():void {
			var ttFont:String = "Arnold 2.1";  
			var infoText:TextField = new TextField(66, 15,  
                "clear data", ttFont, 11, 0xffffff);    
            infoText.x = 9;    
			infoText.y = 224;      
            addChild(infoText);
			infoText.addEventListener(TouchEvent.TOUCH, resetClicked);
			
			var infoText2:TextField = new TextField(63, 16,  
                "badges", ttFont, 11, 0xffffff);    
            infoText2.x = 303;    
			infoText2.y = 223;        
            addChild(infoText2);
			 
			btn1Texture = Game.assets.getTexture("shel");  
			var button1:Button = new Button(btn1Texture, ""); 
            button1.x = 350;  
            button1.y = 178;    
            addChild(button1);  
			button1.name = "Shells";   
			//button1.addEventListener(Event.TRIGGERED, onButtonTriggered);
			
			starImage = new Image(Game.assets.getTexture("star"));
			starImage.x = 166;    
			starImage.y = 5;  
			addChild(starImage); 
			
			var infoText3:TextField = new TextField(20, 18,  
               String(star), ttFont, 15, 0xffffff);      
            infoText3.x = 184;    
			infoText3.y = 7;
			infoText3.hAlign = HAlign.RIGHT;
            addChild(infoText3);
			 
			var infoText4:TextField = new TextField(27, 18,  
                "/60", ttFont, 15, 0xffffff);    
            infoText4.x = 204;     
			infoText4.y = 7; 
			infoText4.hAlign = HAlign.LEFT;
            addChild(infoText4); 
			 
			var clip:Lsq;
			var j:int;
			for (var i:int; i < 20; i++ ) {   
				if ( Game.maxlevels > i ) {
					clip = new Lsq(String(i + 1), true, mas[i]);
					clip.addEventListener("LsqClick", overSq);
				}
				else clip = new Lsq(String(i + 1), false);  
				clip.x = 68 + (i-j*5) * 58;  
				clip.y = 38 + j * 45; 
				container.addChild(clip);
				if(i%5 == 4) j++;
			}
			addChild(container);
			
		}
		 
		private function resetClicked(event:TouchEvent):void {
			var hoverTouch:Touch = event.getTouch(this, TouchPhase.HOVER);
			Mouse.cursor = hoverTouch ? MouseCursor.BUTTON : MouseCursor.ARROW;
            if (event.getTouch(this, TouchPhase.ENDED)) {
				var mySo:SharedObject = SharedObject.getLocal("save_game_data_fish");
				mySo.clear();
				Game.maxlevels = 1; 
				dispatchEvent(new Event("back"));    
			}
		} 
		
		private function overSq(event:Event):void {   
			//if (event.getTouch(this, TouchPhase.ENDED)) { 
			    var clicked:Lsq = event.target as Lsq;
				Game.level = int(clicked.str);
				dispatchEvent(new Event("Level"));   
			//}
		}
		
		private function onButtonTriggered():void {
            trace("badge_clicked");
        }
		
		public override function dispose():void {
			btn1Texture.dispose(); 
			starImage.texture.dispose(); 
			for (var i:int; i < container.numChildren-1; i++) {
				var clip:Lsq = Lsq(container.getChildAt(i));
				clip.removeEventListener("LsqClick", overSq);   
				clip.dispose(); 
			}
            super.dispose();
        }
//-----		
	}
}