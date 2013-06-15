package scenes {
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	/**
	 * ...
	 * @author waltassar
	 */
	public class Wcompleted extends Sprite {
		
		private var backbtn:Button;
		
		public function Wcompleted(t1:int, t2:int) { 
			var mainimage:Image = new Image(Game.assets.getTexture("wcompleted"));
			addChild(mainimage);
			
			var ttFont:String = "Arnold 2.1";  
            var ttFontSize:int = 10;  
			var ttFontSize2:int = 12;
			
			var infoText:TextField;
			  
			infoText = new TextField(29, 15, "level", ttFont, ttFontSize2, 0xffffff); 
            infoText.x = 25; 
			infoText.y = 32;
            addChild(infoText);
			 
			infoText = new TextField(25, 18, String(Game.level), ttFont, 14, 0xffffff); 
            infoText.x = 59;  
			infoText.y = 30;  
			infoText.hAlign = HAlign.LEFT;  
            addChild(infoText);
			  
			infoText = new TextField(60, 15, "completed!", ttFont, ttFontSize2, 0xffffff); 
            infoText.x = (Game.level>9) ? 77 : 70;  
			infoText.y = 32; 
            addChild(infoText); 
			  
			infoText = new TextField(55, 11, "level score:", ttFont, ttFontSize, 0xffffff); 
            infoText.x = 35;
			infoText.y = 54;
			infoText.hAlign = HAlign.RIGHT; 
            addChild(infoText);
			
			infoText = new TextField(58, 11, "stars points:", ttFont, ttFontSize, 0xffffff); 
            infoText.x = 32;
			infoText.y = 68;
			infoText.hAlign = HAlign.RIGHT; 
            addChild(infoText);
			
			infoText = new TextField(58, 11, "total score:", ttFont, ttFontSize, 0xffffff); 
            infoText.x = 32;
			infoText.y = 83;
			infoText.hAlign = HAlign.RIGHT; 
            addChild(infoText);
			
			infoText = new TextField(30, 13, String(t1), ttFont, ttFontSize, 0xFF6600); 
            infoText.x = 94;  
			infoText.y = 53;  
			infoText.hAlign = HAlign.LEFT; 
            addChild(infoText);
			
			infoText = new TextField(30, 13, String(t2), ttFont, ttFontSize, 0xFF6600); 
            infoText.x = 94; 
			infoText.y = 67;
			infoText.hAlign = HAlign.LEFT; 
            addChild(infoText);
			 
			infoText = new TextField(30, 13, String(t1+t2), ttFont, ttFontSize, 0xFF3300); 
            infoText.x = 94;  
			infoText.y = 82;
			infoText.hAlign = HAlign.LEFT; 
            addChild(infoText);
			
			var btnTexture:Texture = Game.assets.getTexture("refresh"); 
			var refreshbtn:Button = new Button(btnTexture, ""); 
            refreshbtn.x = 5;  
            refreshbtn.y = 103;     
            addChild(refreshbtn);
			refreshbtn.name = "refresh"; 
			
			if (Game.level < 20){
				var backTexture:Texture = Game.assets.getTexture("back"); 
				backbtn = new Button(backTexture, ""); 
				backbtn.x = 144;   
				backbtn.y = 103;     
				addChild(backbtn);  
				backbtn.name = "refresh";
				backbtn.scaleX = -1;
				backbtn.addEventListener(Event.TRIGGERED, onButtonClick);
			}
				
			var moreTexture:Texture = Game.assets.getTexture("more"); 
			var morebtn:Button = new Button(moreTexture, ""); 
            morebtn.x = 80;  
            morebtn.y = 103;     
            addChild(morebtn);
			 
			var levelsTexture:Texture = Game.assets.getTexture("levels"); 
			var levelsbtn:Button = new Button(levelsTexture, ""); 
            levelsbtn.x = 42;  
            levelsbtn.y = 103;     
            addChild(levelsbtn);
			levelsbtn.name = "back_levels"; 
			
			//napeImage.addEventListener(TouchEvent.TOUCH, onInfoTextTouched);
		}
		  
		private function onButtonClick(event:Event):void {
			event.currentTarget.removeEventListener(Event.TRIGGERED, onButtonClick);
			Game.level++; 
		}
		
		private function onInfoTextTouched(event:TouchEvent):void {
            if (event.getTouch(this, TouchPhase.ENDED)) {  
				var myURL:URLRequest = new URLRequest("http://napephys.com/");   
				navigateToURL(myURL, "_blank"); 
			}
        }
		
		public function setTexter():void {
            var texter:Image = new Image(Game.assets.getTexture("texter"));
			texter.x = 104;   
			texter.y = 78;    
			addChild(texter); 
			texter.alpha = 0;  
			texter.scaleX = texter.scaleY = 2; 
			var tween:Tween = new Tween(texter, 0.5, Transitions.EASE_OUT);
			tween.delay = 1.4;  
			tween.fadeTo(1); 
			tween.scaleTo(1); 
			Starling.juggler.add(tween);   
        }
		
		public override function dispose():void {  
            if (Game.level < 20) backbtn.removeEventListener(Event.TRIGGERED, onButtonClick);
            super.dispose();
        }
		
//-----		
	}
}