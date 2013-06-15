package scenes {
	import flash.net.SharedObject;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;  
	import starling.utils.VAlign;
	/**
	 * ...
	 * @author waltassar
	 */
	public class Shells extends Scene {  
		
		private var container:Sprite = new Sprite;
		private var badgeMas:Array = []; 
		private var badgeText:TextField;
		private var textMas:Vector.<String> = Vector.<String>([
							"slice 5 or more objects in 1 slice to collect this badge", 
							"score 160 or more points in 1 slice to collect this badge",
							"kill two bad fishes simultaneously to collect this badge",
							"get 3 stars in five levels in the row to collect this badge" ]);  
		
		public function Shells() {
			super.backname = "back_levels";
			var mySo:SharedObject = SharedObject.getLocal("save_game_data_fish");  
			if (mySo.data.Sbadge_mas != undefined) badgeMas = mySo.data.Sbadge_mas;
				else badgeMas = [0,0,0,0];    
			init();
		}
		
		private function init():void {
			var badgImage:Image;
			badgImage = new Image(Game.assets.getTexture("badge1"));
			badgImage.x = 42;    
			badgImage.y = 90;
			badgImage.name = "badge1";
			if (badgeMas[0] == 0) badgImage.alpha = 0.5;
			container.addChild(badgImage);
			
			badgImage = new Image(Game.assets.getTexture("badge2"));
			badgImage.x = 118;    
			badgImage.y = 44;
			badgImage.name = "badge2";
			if (badgeMas[1] == 0) badgImage.alpha = 0.5;
			container.addChild(badgImage);
			
			badgImage = new Image(Game.assets.getTexture("badge3"));
			badgImage.x = 236;    
			badgImage.y = 40;
			badgImage.name = "badge3"; 
			if (badgeMas[2] == 0) badgImage.alpha = 0.5; 
			container.addChild(badgImage);
			
			badgImage = new Image(Game.assets.getTexture("badge4"));
			badgImage.x = 306;    
			badgImage.y = 82;
			badgImage.name = "badge4";
			if (badgeMas[3] == 0) badgImage.alpha = 0.5;
			container.addChild(badgImage);

			badgeText = new TextField(180, 46,  
                "", "Arnold 2.1", 14, 0xffffff);      
            badgeText.x = 116;    
			badgeText.y = 160;
			badgeText.vAlign = VAlign.TOP; 
			//badgeText.autoScale = true;
            addChild(badgeText);
			
			addChild(container);
			container.addEventListener(TouchEvent.TOUCH, overBadge);
		}
		
		private function overBadge(event:TouchEvent):void { 
			var clicked:Image = event.target as Image;
			var touch:Touch = event.getTouch(this);
			if (touch == null) return; 
			if (touch.phase == TouchPhase.MOVED) {
				var i:int = int(clicked.name.substr(5, 1)) - 1; 
				if (badgeText.text.substr(0,2) != textMas[i].substr(0,2)){
					badgeText.text = textMas[i]; 
				} 
			}
			else if (touch.phase == TouchPhase.BEGAN) { 
				clicked.scaleX = clicked.scaleY = 0.9;
				clicked.x += 4;
				clicked.y += 4;
			} 
			else if (touch.phase == TouchPhase.ENDED) { 
				clicked.scaleX = clicked.scaleY = 1;
				clicked.x -= 4; 
				clicked.y -= 4; 
				badgeText.text = "";
			}
			else badgeText.text = "";  
		}
		
		public override function dispose():void { 
            container.removeEventListener(TouchEvent.TOUCH, overBadge);
            super.dispose();
        }
//-----		
	}
}