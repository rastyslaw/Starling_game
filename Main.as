package {
	import flash.desktop.SystemIdleMode;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.system.Capabilities;
	import flash.system.System;
	import flash.ui.Keyboard;
	
	import starling.utils.formatString;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	
	import flash.desktop.NativeApplication;
	
	import starling.events.ResizeEvent;
	import starling.textures.Texture;
	import starling.core.Starling;
    import starling.events.Event;
    import starling.utils.AssetManager;
	/**
	 * ...
	 * @author waltasar 
	 */
	[SWF(frameRate="30", backgroundColor="#000")] 
	public class Main extends Sprite {
		
		[Embed(source = "../textures/LD/mainbgLD.png")]  
        private var BackgroundLD:Class;
		 
		[Embed(source = "../textures/SD/mainbgSD.png")]  
        private var BackgroundSD:Class; 
		
		[Embed(source = "../textures/HD/mainbgHD.png")]  
        private var BackgroundHD:Class;
		
		private var rect:Rectangle = new Rectangle(0, 0, 0, 0);
		private var mStarling:Starling;
		private var assets:AssetManager;
		private var scaleFactor:int;
		
		public function Main():void {
			if (stage) init(); 
			else addEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
		} 
		
		private function onAddedToStage(event:Object):void{
            removeEventListener(starling.events.Event.ADDED_TO_STAGE, onAddedToStage);
            init(); 
        }
		
		private function init():void { 
			removeEventListener(flash.events.Event.ADDED_TO_STAGE, init);
            //Starling.multitouchEnabled = true; // for Multitouch Scene
			 
			var stageWidth:int = Constants.STAGE_WIDTH;        
            var stageHeight:int = Constants.STAGE_HEIGHT;   
			var iOS:Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;
			 
			Starling.multitouchEnabled = true;  // useful on mobile devices
            Starling.handleLostContext = !iOS;  // not necessary on iOS. Saves a lot of memory!

			// create a suitable viewport for the screen size
            // 
            // we develop the game in a *fixed* coordinate system of 320x480; the game might 
            // then run on a device with a different resolution; for that case, we zoom the 
            // viewPort to the optimal size for any display and load the optimal textures.
            
			var screenWidth:int  = stage.fullScreenWidth;  
			var screenHeight:int = stage.fullScreenHeight;
			var sc1:Number = screenWidth / screenHeight;
			var sc2:Number = stageWidth / stageHeight; 
			var delta:Number = sc1 - sc2; 
			var viewPort:Rectangle
			if(Math.abs(delta) < 0.1)     
				viewPort = new Rectangle(0, 0, screenWidth, screenHeight)
			else  {
				viewPort = RectangleUtil.fit( 
                new Rectangle(0, 0, stageWidth, stageHeight), 
                new Rectangle(0, 0, screenWidth, screenHeight), 
                ScaleMode.SHOW_ALL, iOS);  
			} 
				scaleFactor = 1;
				if (viewPort.width > 480 && viewPort.width < 961) scaleFactor = 2; 
				else if (viewPort.width > 960) scaleFactor = 3;
				//trace(scaleFactor); 
				//scaleFactor = viewPort.width < 481 ? 1 : 2;// midway between 320 and 640
				var appDir:File = File.applicationDirectory; 
				assets = new AssetManager(scaleFactor); 
				assets.verbose = Capabilities.isDebugger; 
					assets.enqueue(
					appDir.resolvePath("audio"),  
					appDir.resolvePath(formatString("fonts/{0}x", scaleFactor)),
					appDir.resolvePath(formatString("textures/{0}x", scaleFactor))
				);
				/*
			background.x = viewPort.x;  
			background.y = viewPort.y;  
			background.width  = viewPort.width;  
			background.height = viewPort.height;
			background.smoothing = true; 
			*/
			mStarling = new Starling(Game, stage, viewPort);
            mStarling.stage.stageWidth  = stageWidth;  // <- same size on all devices!
            mStarling.stage.stageHeight = stageHeight; // <- same size on all devices!
            mStarling.simulateMultitouch  = false;
            mStarling.enableErrorChecking = Capabilities.isDebugger;
			
			NativeApplication.nativeApplication.addEventListener(
                flash.events.Event.ACTIVATE, function (e:*):void { mStarling.start(); });
            
            NativeApplication.nativeApplication.addEventListener(
                flash.events.Event.DEACTIVATE, function (e:*):void { mStarling.stop(); } );
				
			NativeApplication.nativeApplication.systemIdleMode = SystemIdleMode.KEEP_AWAKE;
			// this event is dispatched when stage3D is set up   
            mStarling.addEventListener(starling.events.Event.ROOT_CREATED, onRootCreated);
		}
		
		private function onRootCreated(e:starling.events.Event, game:Game):void {
            // set framerate to 30 in software mode
           // if (mStarling.context.driverInfo.toLowerCase().indexOf("software") != -1)
             //   mStarling.nativeStage.frameRate = 30;
            
            // define which resources to load
           // var assets:AssetManager = new AssetManager(-1, true);
           // assets.verbose = Capabilities.isDebugger;
           // assets.enqueue(EmbeddedAssets);
			
		    var bgTexture:Texture;   
			switch(scaleFactor) { 
				case 1:
					bgTexture = Texture.fromBitmap(new BackgroundLD(), false, false, scaleFactor);
				break;
				case 3:
					bgTexture = Texture.fromBitmap(new BackgroundHD(), false, false, scaleFactor);
				break;
				default: bgTexture = Texture.fromBitmap(new BackgroundSD(), false, false, scaleFactor);
			} 
			BackgroundLD = BackgroundSD = BackgroundHD = null;// no longer needed!
			
            // game will first load resources, then start menu
            game.start(bgTexture, assets, scaleFactor); 
			mStarling.start();  
		}
//-----		
	}
}