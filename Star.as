package  {
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	/**
	 * ...
	 * @author waltassar
	 */
	public class Star extends Sprite {
		
		private var tween:Tween;
		private var image:Image;
		private var darkimage:Image; 
		private var _ani:Boolean;
		private var cfil:ColorFilter;
		
		public function Star() {
			darkimage = new Image(Game.assets.getTexture("darkstar"));      
			addChild(darkimage);
			darkimage.x = darkimage.y = 1;
			darkimage.scaleX = darkimage.scaleY = 0.9;    
			image = new Image(Game.assets.getTexture("star"));     
			addChild(image); 
			//cfil = new ColorFilter();  
			//image.filter = cfil;
			//Starling.juggler.tween(image.filter, 50, { brightness: -20 }); 
		}
		
		public function animate():void {
			_ani = true;
			tween = new Tween(image, 1);
			//tween = new Tween(image.filter, 1);
			//tween.animate("brightness", -0.6);  
			tween.fadeTo(0.1);
			tween.onComplete = finishedTween;
			Starling.juggler.add(tween); 
		}
		 
		private function finishedTween():void { 
			tween = new Tween(image, 1);
			//tween = new Tween(image.filter, 1);
			tween.fadeTo(1); 
			//tween.animate("brightness", 0);    
			tween.onComplete = animate;
			Starling.juggler.add(tween);  
		}
		
		public function stopTween():void {
			//tween.reset(); 
			_ani = false;
			image.alpha = 0.1; 
			//cfil.brightness = -0.6;
			Starling.juggler.remove(tween); 
		}
		 
		public function get ani():Boolean {
			return _ani;
		}
//-----		
	}
}