package scenes {
	import flash.net.navigateToURL;
	import flash.net.URLRequest;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import starling.display.Button;
	import starling.display.Image;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.VAlign;
	/**
	 * ...
	 * @author waltassar
	 */
	public class Credit extends Scene {
		
		private var napeImage:Image;
		
		public function Credit() {
			super.backname = "back_cred";
			init();
		}
		
		private function init():void {
            var ttFont:String = "Arnold 2.1";  
            var ttFontSize:int = 12; 
			var ttFontSizeOrange:int = 13;  
			var baseColor:uint = 0xffffff; 
			var secondColor:uint = 0xFF6600; 
			
			var infoText:TextField = new TextField(136, 15, 
                "programming, graphics:", ttFont, ttFontSize, baseColor); 
            infoText.x = 140; 
			infoText.y = 26; 
           // infoText.border = true; 
            addChild(infoText);
			
			var infoText2:TextField = new TextField(60, 16, 
                "waltasar", ttFont, ttFontSizeOrange, secondColor);  
            infoText2.x = 176;
			infoText2.y = 44; 
            addChild(infoText2); 
			
			var infoText3:TextField = new TextField(78, 15, 
                "phisics engine:", ttFont, ttFontSize, baseColor);  
            infoText3.x = 167;
			infoText3.y = 111;  
            addChild(infoText3);
			
			var infoText4:TextField = new TextField(42, 16,  
                "nape", ttFont, ttFontSizeOrange, secondColor);  
            infoText4.x = 187;    
			infoText4.y = 129;     
            addChild(infoText4);  
			
			var text:Texture = Game.assets.getTexture("slis");
			//text.repeat = true; 
			var slisImage:Image = new Image(text);
			slisImage.x = 184;     
			slisImage.y = 70;
			addChild(slisImage); 
			//slisImage.tile(2,1);
			//slisImage.width *= 2;
			
			napeImage = new Image(Game.assets.getTexture("nape"));
			napeImage.x = 184;      
			napeImage.y = 155;
			addChild(napeImage); 
			napeImage.addEventListener(TouchEvent.TOUCH, onInfoTextTouched);
		}
		
		private function onInfoTextTouched(event:TouchEvent):void { 
            if (event.getTouch(this, TouchPhase.ENDED)) { 
				var myURL:URLRequest = new URLRequest("http://napephys.com/");   
				navigateToURL(myURL, "_blank"); 
			}
        }
		
		public override function dispose():void { 
            napeImage.removeEventListener(TouchEvent.TOUCH, onInfoTextTouched);
            super.dispose();
        }
//-----		
	}
}