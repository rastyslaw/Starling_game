package scenes {
	import starling.animation.DelayedCall;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.text.TextField;
	/**
	 * ...
	 * @author waltassar
	 */
	public class Badg extends Sprite {
		
		private var container:Sprite = new Sprite;
		 
		public function Badg(s:String) { 
			var badg:Image = new Image(Game.assets.getTexture(s));
			badg.pivotX = badg.width >> 1;
			badg.pivotY = badg.height >> 1;   
			container.addChild(badg);   
			 
			var infoText:TextField = new TextField(60, 15, 
                "new badge!", "Arnold 2.1", 11, 0xffffff);  
            infoText.x = -badg.pivotX - 8;    
			infoText.y = badg.pivotY + 5;
            container.addChild(infoText);  
			infoText.scaleX = infoText.scaleY = 1.5; 
			addChild(container); 
			container.alpha = 0;
			  
			var tween:Tween = new Tween(container, 0.5, Transitions.LINEAR);
			tween.fadeTo(1);    
			tween.scaleTo(0.5);
			tween.onComplete = onTweenFinished;  
			Starling.juggler.add(tween); 
		}
		
		public function onTweenFinished():void {  
			var delayedCall:DelayedCall = new DelayedCall(this.removeFromParent, 2);
		    Starling.juggler.add(delayedCall);
		}
		
//-----		
	}
}