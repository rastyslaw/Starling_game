package waters {
	
	import flash.display.BitmapData;
    import flash.display.Graphics;
    import flash.display.Shape; 
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import flash.utils.*;
	import starling.events.Event;
	import starling.textures.Texture;
	
	import starling.display.Image;
	import starling.display.DisplayObject;
	import starling.display.Sprite; 
	
	import flash.display3D.textures.Texture;
	
	public class Water extends Sprite {
		
		private var dots:Array = [];
		private var waves:Array = [];
		private var shape:Shape; 
		private var numDots:Number;
		private var spacing:Number;
		private var waterWidth:Number; 
		private var floatingItems:Array = [];
		private var image:Image;
		private var texture:starling.textures.Texture;
		private var bmpd:BitmapData;
		
		public function Water() {
			waterWidth = 440;  
			this.y = 200;    
			numDots = 20; 
			spacing = waterWidth/numDots;
			
			addEventListener(Event.ENTER_FRAME, enterFrameHandler);
			initDots();  
            shape = new Shape();
			drawBack();
			renderWater(); 
			gentlyDisturbWater(); 
			gentlyDisturbWater(); 
		}
		  
		public function drawBack():void {
			shape.graphics.clear(); 
            shape.graphics.beginFill(0x79BCFF); 
			shape.graphics.drawRect(0, 0, waterWidth, 40); 
			shape.graphics.endFill();
			  
			bmpd = new BitmapData(waterWidth, 40, true, 0); 
			bmpd.draw(shape);
			
			var baseTexture:starling.textures.Texture =  starling.textures.Texture.fromBitmapData(bmpd);  
			var img:Image = new Image(baseTexture);
			addChild(img);
			img.y = 20; 
		}
		
		public function enterFrameHandler(ev:Event):void {
			if (Math.round(Math.random()*20) == 0) {
				gentlyDisturbWater();
			}
			propogateWaves();
			renderWater();
		}
		 
		public function gentlyDisturbWater():void { 
			injectWave(2, Math.random()*waterWidth);
		}
		
		public function addWave(A:Number, startx:Number, dir:Number):void{
			//f(x) = A*sin(w*t)
			var wave:Wave = new Wave();
			wave.setIndex(Math.floor(startx/spacing));
			wave.setA(A);
			wave.setDir(dir);
			wave.setFirstOne(true); 
			wave.setStartX(startx);
			wave.setStartTime(getTimer());
			getWaves().push(wave);
		}
		
		public function injectWave(A:Number, x:Number):void{
			//f(x) = A*sin(w*t) {
			addWave(A, x, 1);
			addWave(A, x, -1);
		}
		
		public function propogateWaves():void {
			var t:Number = getTimer();
			var speed:Number = waterWidth/2000;
			var j:int;
			var i:int;
			var wave:Wave;
			var d:Number;
			var dot:Dot;
			for (j=waves.length-1;j>=0;--j) {
				wave = getWaves()[j];
				d = .0001;
				wave.setA(wave.getA() / Math.pow(Math.E, d*(t-wave.getStartTime())));
				var index:Number = Math.floor((wave.getStartX()+wave.getDir()*(t-wave.getStartTime())*speed)/spacing);
				if (index < 0 || index > numDots-1) {
					waves.splice(j, 1);
				} else if (index != wave.getIndex() || (index == wave.getIndex() && wave.getDir() == 1 && wave.getFirstOne())) {
					var w:Wave;
					if (wave.getFirstOne() && wave.getDir() == 1) {
						w = new Wave();
						w.setA(wave.getA());
						w.setStartTime(t);
						dot = getDots()[wave.getIndex()];
						try { dot.getWaves().push(w); }
						catch (err:Error){}
					}
					if (wave.getDir() == 1) {
						for (i=wave.getIndex()+1;i<=index;++i) {
							w = new Wave();
							w.setA(wave.getA());
							w.setStartTime(t);
							dot = getDots()[i];
							dot.getWaves().push(w);
						}
					} else {
						for (i=wave.getIndex()-1;i>=index;--i) {
							w = new Wave();
							w.setA(wave.getA());
							w.setStartTime(t);
							dot = getDots()[i];
							dot.getWaves().push(w);
						}
					}
					wave.setIndex(index);
					wave.setFirstOne(false);
				}
			}
			for (i=0;i<dots.length;++i) {
				dot = dots[i];
				var y:Number = 0;
				for (j = dot.getWaves().length-1;j>=0;--j) {
					wave = dot.getWaves()[j];
					var freq:Number = .005;
					d = .99;
					wave.setA(wave.getA()*d);
					y += wave.getA()*Math.sin(freq*(t-wave.getStartTime()));
					if (wave.getA()<.5) {
						dot.getWaves().splice(j, 1);
					}
				}
				dot.y = y;
			}
		}
	
		public function renderWater():void {
			var factor:int = Game.factor;  
			shape.graphics.clear(); 
            shape.graphics.beginFill(0x79BCFF);  
            shape.graphics.lineStyle(0, 0x062CFD, 1);      
			shape.graphics.moveTo(0, 0);  
			var t:Number = getTimer(); 
			for (var i:int=0;i<dots.length;++i) {
				var dot:Dot = dots[i];
				shape.graphics.lineTo(dot.x*factor, dot.y*factor);
			}
			shape.graphics.lineTo(dots[dots.length-1].x*factor, 20*factor);
			shape.graphics.lineTo(0, 20*factor);
			shape.graphics.endFill();
			 
			var size:Number = shape.height;  
			if (bmpd != null) bmpd.dispose(); 
			bmpd = new BitmapData(waterWidth*factor, size, true, 0); 
			bmpd.fillRect(new Rectangle(0, 0, waterWidth*factor, size), 0); 
			var mtr:Matrix = new Matrix();
			mtr.translate(0,size-19*factor);   
			bmpd.draw(shape, mtr);
			 
			if (texture == null) {  
				texture = starling.textures.Texture.fromBitmapData(bmpd, false, false, factor); 
			}    
			else flash.display3D.textures.Texture(texture.base).uploadFromBitmapData(bmpd); 
			
			if (image == null) { 
				image = new Image(texture);
				//texture.dispose(); 
				addChild(image);
			}
			//image.y = -(size - 32);   
			//image.readjustSize();  
			//addChild(image);  
		}
		
		public function getWaves():Array {
			return waves;
		}
		
		public function initDots():void { 
			for (var i:int=0;i<numDots;++i ){
				var dot:Dot = new Dot();
				dot.x = i*spacing;
				dot.y = 0;
				addDot(dot);
			}
		}
		
		public function addDot(d:Dot):void {
			getDots().push(d);
		}
		
		public function getDots():Array {
			return dots;
		}
//----- 		
	}
}