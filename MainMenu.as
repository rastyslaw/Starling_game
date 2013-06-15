package {
	import flash.system.ImageDecodingPolicy;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
    import flash.utils.getQualifiedClassName;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.events.Event;
	
	import starling.display.DisplayObject;
	import starling.events.Touch;
	import starling.display.Button; 
	import starling.display.MovieClip;
    import starling.core.Starling;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.TouchEvent;
    import starling.events.TouchPhase;
    //import starling.text.TextField;
    import starling.textures.Texture;
    //import starling.utils.VAlign;
	import scenes.Scene;  
	/**
	 * ...
	 * @author waltasar
	 */
    public class MainMenu extends Scene { 
		
		//private var container:Sprite = new Sprite;   
		private var ammContainer:AmmFish;      
		private var btnmas:Vector.<String> = Vector.<String>(["Start", "Tweet", "Facebook", "Credit", "Moregames"]);
		private var btnmas_x:Vector.<int> = Vector.<int>([144, 11, 48, 210, 96]); 
		private var btnmas_y:Vector.<int> = Vector.<int>([129, 9, 9, 180, 180]); 
		private var cont:Sprite;
		
		private var clip1:MovieClip;   
		private var clip2:MovieClip; 
		private var clip3:MovieClip;
		private var clip4:MovieClip;
		private var clip5:MovieClip;
		 
		private var tween:Tween;
		private var bigFishCont:Sprite = new Sprite;
		
		public function MainMenu() {  
            init();
        }     
          
        private function init():void {
			var curwidth:int = Constants.STAGE_WIDTH;
			var curheight:int = Constants.STAGE_HEIGHT;
			var factor:int = int(Starling.contentScaleFactor);
		
			var foneImage:Image = new Image(Game.assets.getTexture("fone"));
			foneImage.x = 97;    
			foneImage.y = 27;
			addChild(foneImage);   
				 
			var frames1:Vector.<Texture> = Game.assets.getTextures("logotip"); 
			clip1 = new MovieClip(frames1, 20); 
			clip1.x = foneImage.x + 3;  
		    clip1.y = foneImage.y + 2.5; 
		    addChild(clip1);   
			  
			var frames2:Vector.<Texture> = Game.assets.getTextures("smallfish"); 
			clip2 = new MovieClip(frames2, 30); 
			clip2.x = 55; 
		    clip2.y = 135;  
		    addChild(clip2); 
			 
			var frames3:Vector.<Texture> = Game.assets.getTextures("hvost"); 
			clip3 = new MovieClip(frames3, 20); 
			clip3.x = 65;
		    clip3.y = 16;
		    bigFishCont.addChild(clip3);
			
			var frames5:Vector.<Texture> = Game.assets.getTextures("ugo"); 
			clip5 = new MovieClip(frames5, 20); 
		    clip5.y = -18; 
		    bigFishCont.addChild(clip5);
			
			var fishImage:Image = new Image(Game.assets.getTexture("bigfish"));
			bigFishCont.addChild(fishImage);
			
			var frames4:Vector.<Texture> = Game.assets.getTextures("plawn"); 
			clip4 = new MovieClip(frames4, 20); 
			clip4.x = 53; 
		    clip4.y = 35;
		    bigFishCont.addChild(clip4);
			
			addChild(bigFishCont);   
			bigFishCont.x = 346 - (bigFishCont.width >> 1);   
		    bigFishCont.y = 154 - (bigFishCont.height >> 1);
			 
			onfinishedTween2(); 
			
			var btnTexture:Texture;
			var button:Button; 
			for (var h:int; h < 5; h++ ) {
				btnTexture = Game.assets.getTexture(btnmas[h]); 
				button = new Button(btnTexture, "");
				button.x = btnmas_x[h];   
				button.y = btnmas_y[h]; 
				if(h==0 || h == 3) button.name = btnmas[h];    
               // button.name = getQualifiedClassName(sceneClass); 
                addChild(button);
			} 
			
			var btn6Texture:Texture = Game.assets.getTexture("close"); 
			var button6:Button = new Button(btn6Texture, ""); 
            button6.x = 367; 
            button6.y = 210;   
			button6.name = "close";   
            addChild(button6);
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
        }
		
		public function onfinishedTween():void {
			Starling.juggler.removeTweens(bigFishCont);
			tween = new Tween(bigFishCont, 1.4, Transitions.LINEAR);
			tween.animate("x", bigFishCont.x + 20);   
			tween.onComplete = onfinishedTween2;  
			Starling.juggler.add(tween); 
		} 
		 
		private function onfinishedTween2():void {
			Starling.juggler.removeTweens(bigFishCont);
			tween = new Tween(bigFishCont, 1.4, Transitions.LINEAR);
			tween.animate("x", bigFishCont.x - 20);
			tween.onComplete = onfinishedTween; 
			Starling.juggler.add(tween);
		}
		
		private function onAddedToStage():void {
			Starling.juggler.add(clip1);
            Starling.juggler.add(clip2);
			Starling.juggler.add(clip3);
			Starling.juggler.add(clip4);
			Starling.juggler.add(clip5); 
        } 
        
        private function onRemovedFromStage():void {
			Starling.juggler.remove(clip1);
			Starling.juggler.remove(clip2);
            Starling.juggler.remove(clip3);
			Starling.juggler.remove(clip4); 
			Starling.juggler.remove(clip5);
        }
		
		private function createFish():void {
			ammContainer = new AmmFish;
			ammContainer.x = 900;  
			addChild(ammContainer); 
		}
		
		public override function create_more():void { } 
		public override function create_back():void { } 
	
		public function get ammCont():AmmFish { return ammContainer; }
		
		public override function dispose():void { 
            removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
            removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
            super.dispose();
        }
//-----
    }
}