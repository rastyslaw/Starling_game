package  {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import starling.animation.DelayedCall;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author waltassar
	 */
	public class AmmFish extends Sprite { 
		
		private static var instance:AmmFish; 
		  
		[Embed(source = "../textures/amm.xml", mimeType = "application/octet-stream")]
		private var _xml:Class;  
		 
		[Embed(source = "../textures/amm1.png")] 
		private var Amm1:Class;

		[Embed(source = "../textures/amm2.png")]
		private var Amm2:Class;
		
		[Embed(source = "../textures/amm3.png")]
		private var Amm3:Class;
		
		private var amm1:Bitmap;
		private var amm2:Bitmap;
		private var amm3:Bitmap;
		private var xml:XML; 
		private var xmllist:XMLList;
		private var tween:Tween;
		
		private var ammMas:Vector.<Texture> = new Vector.<Texture>(11, true);
		
		private var am1:Image;  
		private var am2:Image;
		private var shade:Image;
		
		private var frame:int;
		
		public function AmmFish() {
			
			xml = XML(new _xml());
			xmllist = xml.F;
			amm1 = new Amm1();
		    amm2 = new Amm2();
			amm3 = new Amm3(); 
			
			var shape:Shape = new Shape; 
			shape.graphics.clear(); 
            shape.graphics.beginFill(0x000000);
			shape.graphics.moveTo(210, 0);   
			shape.graphics.lineTo(220, 120);
			shape.graphics.lineTo(210, 242);  
			shape.graphics.lineTo(426, 242);
			shape.graphics.lineTo(426, 0);
			shape.graphics.endFill();   
			
			var canvas:BitmapData = new BitmapData(230, 242, true, 0);
			canvas.fillRect(new Rectangle(0,0,230,242),0xff000000);
			var texture:Texture = Texture.fromBitmapData(canvas); 
			shade = new Image(texture); 
			  
			canvas = new BitmapData(216, 242, true, 0);
			var mtr:Matrix = new Matrix; 
			mtr.translate(-210,0);  
			canvas.draw(shape, mtr);   
			texture = Texture.fromBitmapData(canvas);  
			var body:Image = new Image(texture);
			addChild(body);
			body.x = 210;  
			  
			var texture1:Texture = Texture.fromBitmap(amm1);  
			am1 = new Image(texture1);
			addChild(am1); 
			var texture2:Texture = Texture.fromBitmap(amm2); 
			am2 = new Image(texture2);
			addChild(am2);
			  
			var ammtexture:Texture = Texture.fromBitmap(amm3); 
			var ammBody:Image = new Image(ammtexture);
            ammBody.x = 424;
			//ammBody.y = -40;
			addChild(ammBody);
			
			canvas.dispose(); 
			this.touchable = false;  
		} 
		
		public function init():void {
			var prop:XML = xmllist[0]; 
			am1.x = (prop.p.(attribute('n') == 'amm1').@x >> 1) - 25;
			am1.y = (prop.p.(attribute('n') == 'amm1').@y>>1) - 65;
			am1.rotation = prop.p.(attribute('n') == 'amm1').@r * Math.PI/180; 
				 
			am2.x = (prop.p.(attribute('n') == 'amm2').@x>>1) - 25;
			am2.y = (prop.p.(attribute('n') == 'amm2').@y>>1) - 65;
			am2.rotation = prop.p.(attribute('n') == 'amm2').@r * Math.PI / 180;
				
			var delayedCall:DelayedCall = new DelayedCall(function stdraw():void {addEventListener(Event.ENTER_FRAME, redrawFrames)}, 0.8);
		    Starling.juggler.add(delayedCall); 
		}
		  
		public function redrawFrames(e:Event):void { 
				var prop:XML = xmllist[frame];
				frame++; 
				am1.x = (prop.p.(attribute('n') == 'amm1').@x >> 1) - 25;
				am1.y = (prop.p.(attribute('n') == 'amm1').@y>>1) - 65;
				am1.rotation = prop.p.(attribute('n') == 'amm1').@r * Math.PI/180; 
				 
				am2.x = (prop.p.(attribute('n') == 'amm2').@x>>1) - 25;
				am2.y = (prop.p.(attribute('n') == 'amm2').@y>>1) - 65;
				am2.rotation = prop.p.(attribute('n') == 'amm2').@r * Math.PI/180
			if (frame == 9) {
				removeEventListener(Event.ENTER_FRAME, redrawFrames);
				frame = 0;
				addChild(shade); 
			}
		} 
		
		public function onfinishedTween():void {
			tween = new Tween(this, 1, Transitions.EASE_IN_OUT);
			tween.animate("x", this.x - this.width);  
			tween.onComplete = this.onfinishedTween2; 
			Starling.juggler.add(tween); 
		} 
		
		private function onfinishedTween2():void {
			Starling.juggler.remove(tween);
			removeChild(shade); 
			this.removeFromParent();
		}
		
		 public static function getInstance():AmmFish { 
			if (instance == null) {
				AmmFish.instance = new AmmFish(); 
			}
			return AmmFish.instance;
		}

//-----		
	}
}