package {
	import flash.display.BitmapData;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.textures.Texture;
	/** 
	 * ...
	 * @author waltassar 
	 */
	public class Fader extends Sprite {
		
		private static var instance:Fader;
		private var canvas:BitmapData; 
		
		public function Fader() {
			canvas = new BitmapData(800, 480, false, 0xFF000000);
			var texture:Texture = Texture.fromBitmapData(canvas);
			var fad:Image = new Image(texture); 
			addChild(fad);
			canvas.dispose(); 
			this.alpha = 0;  
		}
		 
		public static function getInstance():Fader { 
			if (instance == null) { 
				Fader.instance = new Fader(); 
			}
			return Fader.instance;
		}
//-----		
	}
}