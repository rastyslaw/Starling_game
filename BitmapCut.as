package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.IBitmapDrawable;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import starling.core.Starling;
	import starling.textures.Texture;
	  
	import nape.geom.Vec2;
	import nape.geom.Vec2List;
	
	import starling.display.Image; 
	
	public class BitmapCut extends Image {
		
		[Embed(source = "../textures/LD/balk1.png")]   
        private var Balk1LD:Class;
		[Embed(source = "../textures/LD/balk2.png")]   
        private var Balk2LD:Class;
		[Embed(source = "../textures/LD/balk3.png")]   
        private var Balk3LD:Class;
		[Embed(source = "../textures/LD/balk4.png")]   
        private var Balk4LD:Class;
		
		[Embed(source = "../textures/SD/balk1.png")]   
        private var Balk1SD:Class;
		[Embed(source = "../textures/SD/balk2.png")]   
        private var Balk2SD:Class;
		[Embed(source = "../textures/SD/balk3.png")]   
        private var Balk3SD:Class;
		[Embed(source = "../textures/SD/balk4.png")]   
        private var Balk4SD:Class;
		
		[Embed(source = "../textures/HD/balk1.png")]    
        private var Balk1HD:Class;
		[Embed(source = "../textures/HD/balk2.png")]   
        private var Balk2HD:Class; 
		[Embed(source = "../textures/HD/balk3.png")]   
        private var Balk3HD:Class;
		[Embed(source = "../textures/HD/balk4.png")]   
        private var Balk4HD:Class;
		
		private var textur:BitmapData;
		private var colores:uint;   
		private var paint:Shape = new Shape;
		private var clip:Bitmap;
		private var _tip:String = "";
		
		public function BitmapCut(id:String, verticesVec:Vec2List, vec:Vec2, bmd:BitmapData = null) {
			var bb:Boolean;
			_tip = id;
			var sc:int = Game.factor; 
			switch(id){  
				case "Balk2b":  
				case "Balk2":
					colores = 0x29D3FE;
					switch(sc) {  
						case 1: 
							clip = new Balk2LD();
						break;
						case 3: 
							clip = new Balk2HD();
						break;  
						default: clip = new Balk2SD();
					}
				break; 
				case "Balk1b": 
				case "Balk1":
					colores = 0x01B7E4;
					switch(sc) {  
						case 1: 
							clip = new Balk1LD();
						break;
						case 3: 
							clip = new Balk1HD();
						break;  
						default: clip = new Balk1SD();
					}
				break;
				case "Balk3b":  
				case "Balk3": 
					colores = 0x5437B5; 
					switch(sc) {  
						case 1: 
							clip = new Balk3LD();
						break;
						case 3: 
							clip = new Balk3HD();
						break;  
						default: clip = new Balk3SD();
					}
				break; 
				case "Balk4b":   
				case "Balk4": 
					colores = 0xC46200;
					switch(sc) {    
						case 1: 
							clip = new Balk4LD();
						break;
						case 3: 
							clip = new Balk4HD();
						break;  
						default: clip = new Balk4SD();
					}
				break; 
				default: colores = 0;   
			}
			if (bmd == null) { 
				if (id.substr(5, 1) == "b") {
					bb = true; 
					var mt:Matrix = new Matrix();
					mt.rotate(-Math.PI/2); 
					mt.ty = clip.width; 
				}

				if (!bb) {
					textur = new BitmapData(clip.width, clip.height, true, 0);  
					textur.draw(clip);
				}
				else { 
					textur = new BitmapData(clip.height, clip.width, true, 0);  
					textur.draw(clip, mt);  
				}
			}
			else {
				clip = null;
				textur = bmd; 
			}
 
			var m:Matrix = new Matrix(); 
			m.tx = - textur.width * 0.5 - vec.x*sc;  
			m.ty = - textur.height * 0.5 - vec.y*sc; 
		   
			if(colores != 0) paint.graphics.lineStyle(1, colores, 0.8);  
			paint.graphics.beginBitmapFill(textur, m, true, false);
			paint.graphics.moveTo(verticesVec.at(0).x*sc, verticesVec.at(0).y*sc);
			
			for (var i:int = 1; i < verticesVec.length; i++) {
				paint.graphics.lineTo(verticesVec.at(i).x*sc, verticesVec.at(i).y*sc);
			} 
			paint.graphics.lineTo(verticesVec.at(0).x*sc, verticesVec.at(0).y*sc);
			paint.graphics.endFill();

		//	paint.width-=1;
			//paint.height-=1; 
			var painW:int = paint.width;
			var painH:int = paint.height; 
		
			m = new Matrix(); 
			m.tx = painW * 0.5;    
			m.ty = painH * 0.5; 
			textur = new BitmapData(painW, painH, true, 0);   
			textur.draw(paint,m);
			var starttexture:Texture = Texture.fromBitmapData(textur, false, false, sc);
			super(starttexture);
			this.pivotX =  painW / 2 / sc;   
			this.pivotY =  painH / 2 / sc;  
		}
		
		public function get tip():String {
			return _tip;
		}
		
		public function get bmpd():BitmapData {
			return textur;  
		}
//-----		
	}
}