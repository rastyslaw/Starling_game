package {
	import flash.desktop.SystemIdleMode;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.events.KeyboardEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.SharedObject;
	import flash.system.System;
    import flash.ui.Keyboard;
	import flash.ui.Mouse;
    import flash.utils.getDefinitionByName;
	import nape.geom.Vec2;
	import starling.animation.DelayedCall;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.RenderTexture;
    
    import scenes.*; 
    import flash.desktop.NativeApplication; 
	 
    import starling.core.Starling; 
    import starling.display.Button;
    import starling.display.Image;
    import starling.display.Sprite;
    import starling.events.Event;
    import starling.textures.Texture;
    import starling.utils.AssetManager;
	
	/** 
	 * ...
	 * @author waltasar
	 */ 
    public class Game extends Sprite {
		
		[Embed(source = "../textures/LD/luchLD.png")]   
        private var LuchLD:Class;
		
		[Embed(source = "../textures/SD/luchSD.png")]   
        private var LuchSD:Class;
		 
		[Embed(source = "../textures/HD/luchHD.png")]   
        private var LuchHD:Class;
		
		[Embed(source="../textures/levels.xml", mimeType="application/octet-stream")]
        public static var levels_xml:Class;
		
		public static var level:int = 1; 
		public static var maxlevels:int;
		public static var factor:int;  
		private static var _sound:Boolean = true;      
		private static var _music:Boolean = true;  
		private static var stp:Vec2;
		public static var soundManager:SoundManager;    
		 
		private  var mCurrentScene:Scene;
		private var amm:AmmFish;  
        private var mMainMenu:MainMenu;  
        private var mLoadingProgress:ProgressBar;
        private static var sAssets:AssetManager; 
        private var foneImage:Image;
		private var lImage:Image;
		private var mouse:Cursor; 
		private static var isDraw:Boolean;
		private var image:Image;
		private var texture:Texture;
		private var bmpd:BitmapData;
		private var line:Shape = new Shape;
		private var mousePoint:Point;
		private var mRenderTexture:RenderTexture;
		private var mCanvas:Image;
		private var fader:Fader;
		
        public function Game() {
			Credit;
			Start;
			Shells; 
			Level;
			soundManager = SoundManager.getInstance(); 
			var mySo:SharedObject = SharedObject.getLocal("save_game_data_fish");
			if (mySo.data.S_sound != undefined) _sound = mySo.data.S_sound;  
			if (mySo.data.S_music != undefined) _music = mySo.data.S_music;
			if (mySo.data.Smaxlevels != undefined) maxlevels = mySo.data.Smaxlevels;
				else maxlevels = 1;
        } 
       
        public function start(background:Texture, assets:AssetManager, num:int):void {
			sAssets = assets;
            factor = num;  

			foneImage = new Image(background); 
            addChild(foneImage);  
			
			var luch:Texture; 
			switch(factor) {    
				case 1:
					luch = Texture.fromBitmap(new LuchLD(), false, false, factor);
				break;
				case 3:
					luch = Texture.fromBitmap(new LuchHD(), false, false, factor);
				break;
				default: luch = Texture.fromBitmap(new LuchSD(), false, false, factor);
			}
			lImage = new Image(luch);    
            lImage.x = 108;   
            //lImage.y = int(Constants.CenterY - lImage.height >> 1);  
            addChild(lImage);
			lImage.touchable = false;
			
			LuchLD = LuchSD = LuchHD = null;
			
            mLoadingProgress = new ProgressBar(90, 10);
            mLoadingProgress.x = (background.width  - mLoadingProgress.width) / 2;
            mLoadingProgress.y = background.height * 0.7;
            addChild(mLoadingProgress); 
       // Starling.current.showStats = !Starling.current.showStats;
			assets.loadQueue(function(ratio:Number):void {
               // trace("Loading assets, progress:", ratio);
				mLoadingProgress.ratio = ratio; 
                 
                if (ratio == 1)
                    Starling.juggler.delayCall(function():void {
                        mLoadingProgress.removeFromParent(true);
                        mLoadingProgress = null; 
						mouse = new Cursor(); 
						addChild(mouse);
						addEventListener(TouchEvent.TOUCH, cursorChanger);
						soundManager.addSound("menu", sAssets.getSound("easy") );
						soundManager.crossFade(null, "menu", 5, 0.9, 999);
						NativeApplication.nativeApplication.addEventListener(flash.events.Event.ACTIVATE, onfocus, false, 0, true); 
						NativeApplication.nativeApplication.addEventListener(flash.events.Event.DEACTIVATE, outfocus, false, 0, true);
						//musicEnv.init();        
						//if (_music) musicEnv.fadeTo('menu');   
						//	else musicEnv.curMusName = 'menu'; 
						//musicEnv.played(_music);
                        showMainMenu();  
                    },
					0.15);  
            });
			
            addEventListener(Event.TRIGGERED, onButtonTriggered);
			foneImage.addEventListener(TouchEvent.TOUCH, moveBg);
			NativeApplication.nativeApplication.addEventListener(KeyboardEvent.KEY_DOWN, fl_OptionsMenuHandler);
		}
		 
		private function onfocus(e:flash.events.Event):void {
			//Starling.current.nativeStage.frameRate = 30;
			//System.resume();
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			if (music) soundManager.crossFade(null, "menu", 5, 0.9, 999); 
		} 
		 
		private function outfocus(e:flash.events.Event):void {
			if(music) soundManager.stopSound("menu"); 
			//Starling.current.nativeStage.frameRate = 0.1;
			//System.pause();
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.NORMAL; 
		}
		
		private function fl_OptionsMenuHandler(e:KeyboardEvent):void  { 
		   if (e.keyCode == Keyboard.BACK) {
			  e.preventDefault();
			  var s:String = String(mCurrentScene).replace("object ", "");
			  switch(s) {   
					case "[Start]":
						onButtonTriggered(new Event("back"));   
					break;
					case "[Credit]":
					    onButtonTriggered(new Event("back_cred"));   
					break;
					case "[Shells]":
					case "[Level]":
					    onButtonTriggered(new Event("back_levels"));   
					break;  
					default: NativeApplication.nativeApplication.exit();  
			  }
		   }
		}
		
		private function moveBg(event:TouchEvent):void {  
			//foneImage.x = 310 + (mouseX / 640) * 20; 
			//lImage.x = 220 + (mouseX / 640) * -20;
			var touch:Touch = event.getTouch(stage);
			if (touch == null) return;  
			var pos:Point = touch.getLocation(stage);
			foneImage.x = -10 + (pos.x / 400) * 10;    
			lImage.x = 110 + (pos.x / 400) * -10;    
		}
		 
		private function cursorChanger(event:TouchEvent):void {
			var touch:Touch = event.getTouch(stage); 
			if(touch == null) return;
            if (touch.phase == "began") { 
				var pos:Point = touch.getLocation(stage);
				if (isDraw && pos.y > Constants.STAGE_HEIGHT >> 3) { 
					mouse._mouse = 1;
					stp = Vec2.get(pos.x, pos.y);
					//addEventListener(TouchEvent.TOUCH, regraw); 
					addEventListener(TouchEvent.TOUCH, onTouch);
					setChildIndex(mouse, numChildren - 1);
					//addEventListener(Event.ENTER_FRAME, drawing); 
				}
				else {   
					mouse._mouse = 2;  
					stp = null; 
				}
			} 
			else if (touch.phase == "ended") {
				mouse._mouse = 0;
				//removeEventListener(Event.ENTER_FRAME, drawing); 
				//removeEventListener(TouchEvent.TOUCH, regraw);
				removeEventListener(TouchEvent.TOUCH, onTouch);
				if (texture != null) { 
					texture.dispose();
				}
				if (image != null) { 
					removeChild(image); 
				}
				if (bmpd != null) {
					bmpd.dispose();    
					bmpd = null; 
				} 
			} 
		}
		
		private function onTouch(event:TouchEvent):void {
			var touch:Touch = event.getTouch(this); 
			if (touch == null) return; 
			if (touch.phase == TouchPhase.MOVED) {
				var location:Point = touch.getLocation(stage);
				location.x *= factor;
				location.y *= factor;
					line.graphics.clear();     
					line.graphics.lineStyle(factor, 0x0066FF);  
					line.graphics.moveTo(stp.x*factor, stp.y*factor);  
					line.graphics.lineTo(location.x, location.y);  
					line.graphics.beginFill(0xffffff); 
					line.graphics.drawCircle(stp.x*factor, stp.y*factor, 3*factor); 
					line.graphics.endFill();
					 
					if (bmpd!=null) {
						bmpd.dispose();
						bmpd = null;
					}
					var bmpdW:Number = stp.x*factor - location.x;
					var bmpdH:Number = stp.y*factor - location.y; 
					var startX:Number = (stp.x-4)*factor;
					var startY:Number = (stp.y-4)*factor;  
					if (bmpdW > 0) startX = location.x; 
						else bmpdW *= -1; 
					if (bmpdH > 0) startY = location.y; 
						else bmpdH *= -1; 
					if (bmpdW <= 15) bmpdW = 16;  
					if (bmpdH <= 15) bmpdH = 16;   
					var m:Matrix = new Matrix(); 
					bmpd = new BitmapData(bmpdW+4*factor, bmpdH+4*factor, true, 0);
					m.tx = -startX;
					m.ty = -startY;    
					//bmpd.fillRect(new Rectangle(0, 0, 800, 480), 0); 
					bmpd.draw(line, m);     
					
					if(texture != null) texture.dispose();  
						texture = Texture.fromBitmapData(bmpd, false, false, factor);
					if (image != null) removeChild(image); 
					image = new Image(texture);
					addChild(image);
					image.x = (startX+4)/factor;
					image.y = (startY+4)/factor;
			}
		}
					
		private function drawing(event:Event):void {
			if (mousePoint == null) return;
			line.graphics.clear();  
            line.graphics.lineStyle(1.5, 0x0066FF);
			line.graphics.moveTo(stp.x, stp.y); 
			line.graphics.lineTo(mousePoint.x, mousePoint.y); 
			line.graphics.beginFill(0xffffff);
			line.graphics.drawCircle(stp.x, stp.y, 4);
			line.graphics.endFill();
			//var bmpdW:Number = stp.x - pos.x;
			//var bmpdH:Number = stp.y - pos.y;
			//if (bmpdW < 0) bmpdW *= -1; 
			//if (bmpdH < 0) bmpdH *= -1;
			if (bmpd == null) bmpd = new BitmapData(800, 480, true, 0);
			bmpd.fillRect(new Rectangle(0, 0, 800, 480), 0);
			bmpd.draw(line);  
			 
			if (image != null) {
				texture.dispose();
				removeChild(image);
			}
			texture = Texture.fromBitmapData(bmpd); 
			image = new Image(texture); 
			addChild(image);
		}
		
		private function regraw(event:TouchEvent):void {
			var touch:Touch = event.getTouch(stage);
			if (touch == null) return; 
			mousePoint = touch.getLocation(stage);
		}
		
        private function showMainMenu():void {
			isDraw = false;
            if (mMainMenu == null)   
                mMainMenu = new MainMenu(); 
            addChild(mMainMenu); 
			setChildIndex(lImage, numChildren - 1);
			 if (fader != null) setChildIndex(fader, numChildren - 1);
		     if (contains(amm)) setChildIndex(amm, numChildren - 1);
			 setChildIndex(mouse, numChildren - 1);
        }

        private function onButtonTriggered(event:Event=null):void {
			var s:String;
			if(_sound) sAssets.playSound("click");  
			if (event.type == "triggered") s = Button(event.target).name;
				else s = event.type;      
			if (s == null || contains(amm)) return;
			var tween:Tween; 
			var texture:Texture;  
			if (s == "close") {
				NativeApplication.nativeApplication.exit();   
			}
			else  if (s == "back_cred"|| s == "refresh") {  
                fader = Fader.getInstance();
				addChild(fader); 
				tween = new Tween(fader, 0.3, Transitions.LINEAR); 
				tween.fadeTo(1);    
				tween.onComplete = onfinishedTween;  
				if (s == "back_cred") tween.onCompleteArgs = [null];
				else tween.onCompleteArgs = ["Level"]; 
				Starling.juggler.add(tween); 
			}   
			else if (s.substr(0, 4) == "back") {
				/*
				fader = Fader.getInstance();
				addChild(fader);
				tween = new Tween(fader, 0.3, Transitions.LINEAR); 
				tween.fadeTo(1);    
				tween.onComplete = onfinishedTween;  
				tween.onCompleteArgs = [null];
				Starling.juggler.add(tween); 
				*/
                amm = AmmFish.getInstance();
				amm.x = Constants.STAGE_WIDTH;   
				addChild(amm);  
				amm.init();
				if(_sound) Game.assets.playSound("sweem"); 
				tween = new Tween(amm, 1.4, Transitions.EASE_IN_OUT);
				tween.animate("x", -Constants.STAGE_WIDTH >> 4);
				tween.onComplete = ammFTween;
				tween.onCompleteArgs = [s, true];
				Starling.juggler.add(tween);
			} 
            else { 
				if (s == "Credit") {   
					fader = Fader.getInstance();
					addChild(fader);
					tween = new Tween(fader, 0.3, Transitions.LINEAR);
					tween.fadeTo(1);   
					tween.onComplete = onfinishedTween; 
				}
				else {
					/*
					fader = Fader.getInstance();
					addChild(fader);
					tween = new Tween(fader, 0.3, Transitions.LINEAR);
					tween.fadeTo(1);   
					tween.onComplete = onfinishedTween; 
					*/
					amm = AmmFish.getInstance();
					amm.x = Constants.STAGE_WIDTH; 
					addChild(amm);
					amm.init();
					if(_sound) Game.assets.playSound("sweem"); 
					tween = new Tween(amm, 1.4, Transitions.EASE_IN_OUT);
					tween.animate("x", -Constants.STAGE_WIDTH >> 4);
					tween.onComplete = ammFTween; 
				}
				tween.onCompleteArgs = [s]; 
				Starling.juggler.add(tween);  
			} 
        } 
        
		private function ammFTween(s:String, k:Boolean=false):void { 
		    if (!k) showScene(s);  
				else {
					mCurrentScene.removeFromParent(true);
					mCurrentScene = null;
					switch(s) {
						case "back": 
							showMainMenu(); 
						break; 
						case "back_levels":  
							showScene("Start");  
						break;
						case "back_refresh":   
							showScene("Level");  
						break; 
					}
				} 
			amm.onfinishedTween();  
		}
		
		private function onfinishedTween(s:String):void {
		   if (s != null) showScene(s);
				else closeScene();   	
           var delayedCall:DelayedCall = new DelayedCall(killerTween, 0.3);
		   Starling.juggler.add(delayedCall); 
        }
		
		private function killerTween():void {
		   var tween:Tween = new Tween(fader, 0.3, Transitions.LINEAR);
		   tween.fadeTo(0);     
		   tween.onComplete = killerFader;
		   Starling.juggler.add(tween); 
        }
		
		private function killerFader():void {
			//fader.texture.dispose();  
		    fader.removeFromParent();
		    fader = null; 
        }
		
        private function closeScene():void {
            mCurrentScene.removeFromParent(true);
            mCurrentScene = null;
            showMainMenu();
        }
        
        private function showScene(name:String):void {
            //if (mCurrentScene) return;
			switch(name) {
			    case "op": 
				   // foneImage.texture.dispose();
					//removeChild(foneImage);
					//foneImage = null;   
				break;   
				case "Credit": 
				case "Start": 
				case "Shells":
				case "Level":  
					lImage.visible = true;
					isDraw = false; 
					if (mCurrentScene != null) {
						mCurrentScene.removeFromParent(true);
						mCurrentScene = null;    
					}
					mCurrentScene = new (getDefinitionByName("scenes."+name))();
				    // var sceneClass:Class = getDefinitionByName("scenes."+name) as Class;
					// mCurrentScene = new sceneClass() as Scene;
					if(mMainMenu!= null){    
						mMainMenu.removeFromParent(); 
					    mMainMenu = null;
					} 
					addChild(mCurrentScene);
					setChildIndex(lImage, numChildren-1);  
				break;  
		   }
		   if (name == "Start") { 
			   mCurrentScene.addEventListener("back", onButtonTriggered);
			   mCurrentScene.addEventListener("Level", onButtonTriggered);
			   if (!foneImage.hasEventListener(TouchEvent.TOUCH))  
				  foneImage.addEventListener(TouchEvent.TOUCH, moveBg);
		   }
		   else if (name == "Level") {   
			    foneImage.removeEventListener(TouchEvent.TOUCH, moveBg);
				lImage.visible = false; 
				isDraw = true; 
		   }
		   if (fader != null) setChildIndex(fader, numChildren - 1);
		   if (contains(amm)) setChildIndex(amm, numChildren - 1);
		   setChildIndex(mouse, numChildren - 1);
        }
        
        public static function get assets():AssetManager { return sAssets; }
		
		public static function get sound():Boolean {
			return _sound; 
		}  
		public static function set sound(value:Boolean):void {
			_sound = value;
		}
		public static function get music():Boolean {
			return _music;
		}
		public static function set music(value:Boolean):void {
			_music = value;
		}
		public static function get _stp():Vec2 {
			return stp;
		}
		public static function get levxml():XML { 
			return XML(new levels_xml());
		}
		public static function set _isDraw(b:Boolean):void { isDraw = b; } 

//-----		
    }
}