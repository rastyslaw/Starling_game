package scenes {
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	/**
	 * ...
	 * @author waltassar
	 */
	public class Wfailed extends Sprite {  
		
		public function Wfailed() {
			var mainimage:Image = new Image(Game.assets.getTexture("wfinished"));
			addChild(mainimage);
			
			var ttFont:String = "Arnold 2.1";  
			var ttFontSize:int = 12;
			
			var infoText:TextField;
			  
			infoText = new TextField(29, 15, "level", ttFont, ttFontSize, 0xffffff); 
            infoText.x = 42; 
			infoText.y = 28;
            addChild(infoText);
			 
			infoText = new TextField(25, 18, String(Game.level), ttFont, 14, 0xffffff); 
            infoText.x = 76;   
			infoText.y = 26;   
			infoText.hAlign = HAlign.LEFT;  
            addChild(infoText);
			   
			infoText = new TextField(30, 15, "failed!", ttFont, ttFontSize, 0xffffff); 
            infoText.x = (Game.level>9) ? 94 : 90;   
			infoText.y = 28;   
            addChild(infoText);
		
			infoText = new TextField(75, 15, "walk through", ttFont, 11, 0xffffff); 
            infoText.x = 44;     
			infoText.y = 46; 
            addChild(infoText);
			infoText.addEventListener(TouchEvent.TOUCH, onInfoTouched);
			
			var btnTexture:Texture = Game.assets.getTexture("refresh"); 
			var refreshbtn:Button = new Button(btnTexture, ""); 
            refreshbtn.x = 64;   
            refreshbtn.y = 63;      
            addChild(refreshbtn);
			refreshbtn.name = "refresh";
			
			var moreTexture:Texture = Game.assets.getTexture("more"); 
			var morebtn:Button = new Button(moreTexture, ""); 
            morebtn.x = 15;  
            morebtn.y = 63;     
            addChild(morebtn);
			 
			var levelsTexture:Texture = Game.assets.getTexture("levels"); 
			var levelsbtn:Button = new Button(levelsTexture, ""); 
            levelsbtn.x = 115;  
            levelsbtn.y = 63;     
            addChild(levelsbtn); 
			levelsbtn.name = "back_levels"; 
		} 
		
		private function onInfoTouched(event:TouchEvent):void {
            if (event.getTouch(this, TouchPhase.ENDED)) {  
				var myURL:URLRequest = new URLRequest("http://www.youtube.com/watch?v=Jmy4x9A3_sY&feature=youtu.be/");   
				navigateToURL(myURL, "_blank"); 
			}
		}
		
	}
//-----
}