package scenes {
	
	import flash.events.NetStatusEvent;
	import flash.geom.Point;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.net.SharedObject;
	import flash.net.SharedObjectFlushStatus;
	import flash.utils.getDefinitionByName;
	import flash.utils.getTimer;
	import nape.dynamics.InteractionFilter;
	import nape.geom.GeomPoly;
	import nape.geom.GeomPolyList;
	import nape.geom.Ray;
	import nape.geom.RayResultList;
	import starling.animation.DelayedCall;
	import starling.animation.Transitions;
	import starling.animation.Tween;
	import starling.core.Starling;
	import starling.display.Button;
	import starling.display.DisplayObject;
	import starling.display.Image;
	import starling.display.MovieClip;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.text.TextField;
	import starling.textures.Texture;
	import starling.utils.HAlign;
	import waters.*;
	
	import nape.callbacks.CbEvent;
	import nape.callbacks.CbType;
	import nape.callbacks.InteractionCallback;
	import nape.callbacks.InteractionListener;
	import nape.callbacks.InteractionType;
	import nape.constraint.PivotJoint;
	import nape.phys.BodyList;
	import nape.shape.ShapeList;
	import nape.space.Space;
	import nape.util.BitmapDebug;
	import nape.util.Debug;
    import nape.geom.Vec2;
    import nape.phys.Body;
    import nape.phys.BodyType;
    import nape.shape.Shape;
    import nape.shape.Circle;
    import nape.shape.Polygon;
	import nape.phys.Material; 
	/**
	 * ...
	 * @author waltassar
	 */
	public class Level extends Scene {
		 
		private var xml:XML; 
		private var xmllist:XMLList; 
		
		private var world:Space;
        private var prevTimeMS:int;
        private var simulationTime:Number;
		private var water:Water; 
		private var pcontainer:Sprite;  
		
		private var ENEMY:CbType;
		private var FLUID:CbType;   
		private var BOX:CbType;
		
		private var grclip:Sprite = new Sprite;    
		private var bodyMas:Vector.<Body> = new Vector.<Body>();
		private var mas:Vector.<int>;
		private var masLevel:Vector.<int>; 
		
		private var score:int; 
		private var starScore:int = 1500; 
		private var stars:int;
		
		private var wclip:Wcompleted;
		private var fclip:Wfailed;
		private var level:int;
		private var badge_mas:Array;
		
		private var badge_cont:Sprite = new Sprite();
		
		private var channel:SoundChannel = new SoundChannel();
		private var channel_active:Boolean;
		 
		public function Level() {
			super.backname = "back_levels";
			level = Game.level; 
			xml = Game.levxml;
			xmllist = xml.level[level-1].o;
			addChild(grclip);
			 
			var mySo:SharedObject = SharedObject.getLocal("save_game_data_fish"); 
			if (mySo.data.Sbadge_mas != undefined) badge_mas = mySo.data.Sbadge_mas;
				else badge_mas = [0,0,0,0]; 
			if (mySo.data.Smas != undefined) mas = mySo.data.Smas;
				else mas = new Vector.<int>(20, true);  
			if (mySo.data.SmasLevel != undefined) masLevel = mySo.data.SmasLevel;
				else masLevel = new Vector.<int>(20);
			if (mySo.data.Sstars != undefined) stars = mySo.data.Sstars; 
				else stars = 0;
			if (mySo.data.Smaxlevels != undefined) Game.maxlevels = mySo.data.Smaxlevels;
				else Game.maxlevels = 1; 
			
			addEventListener(Event.ADDED_TO_STAGE, init);
		} 
		
		private function SaveData():void {
			
            var flushStatus:String = null;
			var mySo:SharedObject = SharedObject.getLocal("save_game_data_fish");
			
            try {
                flushStatus = mySo.flush(10000);
            } catch (error:Error) {
                trace("Need more memory on disk");
            }
            if (flushStatus != null) {
                switch (flushStatus) {
                    case SharedObjectFlushStatus.PENDING:
							mySo.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
                        break;
                    case SharedObjectFlushStatus.FLUSHED:
							trace("AUTOSAVE");
                        break;
                }
				mySo.data.Smaxlevels = Game.maxlevels;  
				mySo.data.Sbadge_mas = badge_mas; 
				mySo.data.Smas = mas;
				mySo.data.SmasLevel = masLevel;
				mySo.data.Sstars = stars;  
				mySo.flush(); 
				//mySo2.close(); 
				//mySo2 = null;
		   }
		}
		 
		private function onFlushStatus(event:NetStatusEvent):void {
         
		 	var mySo:SharedObject = SharedObject.getLocal("save_game_data_fish"); 
            switch (event.info.code) { 
                case "SharedObject.Flush.Success":
						trace("Player granted permission - data saved");
                    break;
                case "SharedObject.Flush.Failed":
						trace("Player denied permission - data not save");
                    break;
            }
            mySo.removeEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
        }
		
		private function init():void {  
			removeEventListener(Event.ADDED_TO_STAGE, init);
			var grav:int = Game.factor == 1 ? 150 : 200;   
			world = new Space(new Vec2(0, grav));
			createInteractorType();
			initCollisionListeners();
			
			addWall(200,0,400,10);
			addWall(200,260,400,10);  
			addWall(-20,120,10,320);    
			addWall(420, 120, 10, 320);  
			
			var image:Image; 
			if (level == 3 || level == 4 || level == 8 || level == 9 || level == 13 || level == 14 || level == 18 || level == 19)
				 image = new Image(Game.assets.getTexture("bgs2"));
			else image = new Image(Game.assets.getTexture("bgs"));
			addChildAt(image, 0);    
			
			var btnTexture:Texture = Game.assets.getTexture("refresh"); 
			var backbtn:Button = new Button(btnTexture, ""); 
            backbtn.x = 44;   
            backbtn.y = 9;  
			backbtn.name = "refresh";    
            addChild(backbtn);
			 
			pcontainer = new Sprite;
			image = new Image(Game.assets.getTexture("plant1"));
			pcontainer.addChild(image);
			image = new Image(Game.assets.getTexture("plant2"));
			image.y = 10;  
			pcontainer.addChild(image);
			 
			addChild(pcontainer);
			pcontainer.y = 190;
			
			drawlevel();
			addChild(badge_cont);
			
			var star:Star; 
			for (var i:int; i < 3; i++ ) {
				star = new Star(); 
				star.x = 170 + i*26;     
				star.y = 11;           
				star.name = "star" + i;
				addChild(star); 
			} 
			
			water = new Water(); 
			water.x = -20;    
			water.alpha = 0.3;         
			water.touchable = false;   
			addChild(water);
			
			var fluidBody:Body = new Body(BodyType.STATIC);
            var fluidShape:Shape = new Polygon(Polygon.rect(0, 210, 400, 40));    
            fluidShape.fluidEnabled = true;
		    // fluidShape.filter = new InteractionFilter(0x000000001, 0x000000001);  
            // fluidShape.filter.fluidMask = 2;
            fluidShape.fluidProperties.density = 2; 
            fluidShape.fluidProperties.viscosity = 4;
            fluidShape.body = fluidBody;  
			fluidBody.cbTypes.add(FLUID); 
            fluidBody.space = world;
			
			prevTimeMS = getTimer();
            simulationTime = 0.0;
			 
			addEventListener(Event.ENTER_FRAME, update);
			addEventListener(TouchEvent.TOUCH, mouseUpHandler);
			
			super.createCloud(); 
			 
			fish_timer(true, 7);    
			var delayedCall:DelayedCall = new DelayedCall(fish_timer, 6); 
			delayedCall.repeatCount = int.MAX_VALUE;  
			Starling.juggler.add(delayedCall);
			
			delayedCall = new DelayedCall(bubble_timer, 2.5);  
			delayedCall.repeatCount = int.MAX_VALUE;  
			Starling.juggler.add(delayedCall);
			
			level < 16 ? starScore = 1500 : starScore = 2000; 
		}   
		
		private function initCollisionListeners():void	{   
			var beginCollision:InteractionListener = new InteractionListener(CbEvent.BEGIN, InteractionType.FLUID, ENEMY, FLUID, beginCollisionFluid);
			world.listeners.add(beginCollision);
			var beginCollision2:InteractionListener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, ENEMY, BOX, beginCollisionBox);
			world.listeners.add(beginCollision2); 
			var beginCollision3:InteractionListener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, BOX, BOX, BoxHitBox);     
			world.listeners.add(beginCollision3);
			var beginCollision4:InteractionListener = new InteractionListener(CbEvent.BEGIN, InteractionType.FLUID, BOX, FLUID, FHitBox);
			world.listeners.add(beginCollision4);
			var beginCollision5:InteractionListener = new InteractionListener(CbEvent.BEGIN, InteractionType.COLLISION, ENEMY, ENEMY, beginEnemyKill);
			world.listeners.add(beginCollision5);
		} 
		
		private function BoxHitBox(cb:InteractionCallback):void {
			if(int(cb.int1.castBody.rotation) != 0 || int(cb.int2.castBody.rotation) != 0) { 
				if(cb.int1.castBody.position.y < 200 && cb.int2.castBody.position.y < 200 && Game.sound) { 
					//if(!channel_active){  
					Game.assets.playSound("stuk") 
						//var obj:Sound = Game.assets.getSound("stuksnd");   
						//channel = obj.play(); 
						//channel_active = true; 
						//channel.addEventListener(Event.COMPLETE, soundCompleteHandler);
					//}
				}
			} 
		}  
		 
		private function soundCompleteHandler(event:Event):void {
			trace("1111");
			channel.removeEventListener(Event.COMPLETE, soundCompleteHandler); 
            channel_active = false;
        }
		
		private function beginEnemyKill(cb:InteractionCallback):void {
			var per:int;  
			var body1:Body = cb.int1.castBody; 
			var body2:Body = cb.int2.castBody;
			if (body1.position.y > 205 || body2.position.y > 205) return;
			if (body1.userData.sprite.name == "good") { 
				if (body2.userData.sprite.name == "good") {
					return;  
				} 
				else {   
					 KillFish(body1); 
				     if(Game.sound) Game.assets.playSound("oops"); 
					 finished(); 
				}
			}
			else if (body2.userData.sprite.name == "good") {
				 KillFish(body2);   
				 if(Game.sound) Game.assets.playSound("oops");
				 finished();  
			} 
			else {
				 KillFish(body1, true);   
				 KillFish(body2, true);
				 if(Game.sound) Game.assets.playSound("oops");
				
				 if (badge_mas[2] == 0) {
					if(badge_cont.numChildren < 2){  
						badge_mas[2] = 1; 
						var badg2:Badg = new Badg("badge3");
						badg2.x = 370;
						badg2.y = 60 + 60 * badge_cont.numChildren;    
						badge_cont.addChild(badg2);
					}
				}
				scanBodyMas(); 
			}
		}
		
		private function KillFish(b:Body, flag:Boolean=false):void {
			grclip.removeChild(b.userData.sprite); 
			delFromBodyMas(b); 
			world.bodies.remove(b);  
			 
			var frames:Vector.<Texture> = Game.assets.getTextures("boom"); 
			var boom:MovieClip = new MovieClip(frames, 30); 
			boom.x = b.position.x - (boom.width>>1);  
			boom.y = b.position.y - (boom.height>>1); 
			addChild(boom);  
			boom.loop = false; 
			Starling.juggler.add(boom);  
			boom.addEventListener(Event.COMPLETE, onAnimationComplete);
				
			if (flag) {
				createScore(b.position.x, b.position.y, "500");  
				score += 500; 
			} 
		} 
		
		private function FHitBox(cb:InteractionCallback):void {
			if (!channel_active && cb.int1.castBody.position.y > 205 && Game.sound) { 
				cb.int1.castBody.cbTypes.pop();
				Game.assets.playSound("pleskwood");
				//var obj:Sound = Game.assets.getSound("pleskwoodsnd");   
				//channel = obj.play();  
				//channel_active = true;  
				//channel.addEventListener(Event.COMPLETE, soundCompleteHandler);
			}
		}
		
		private function delFromBodyMas(b:Body):void {  
			for (var i:int; i < bodyMas.length; i++) {   
				if (bodyMas[i] == b) bodyMas.splice(i,1);   
			} 
		}
		
		private function onAnimationComplete(event:Event):void {
			var obg:DisplayObject = DisplayObject(event.target);
			obg.removeFromParent();   
		}
		
		private function beginCollisionBox(cb:InteractionCallback):void {
			//check size  
			var body1:Body = cb.int1.castBody;  
			var body2:Body = cb.int2.castBody;  
			if (body1.position.y < 195) {
				//trace( cb.arbiters.at(0).collisionArbiter.contacts.at(0).position);
				//var j:Number = body1.position.y - body2.position.y;  
				if (cb.arbiters.length != 0) {
					if (cb.arbiters.at(0).collisionArbiter.contacts.at(0).position.y < (body1.position.y-3)) {  
						var sh:ShapeList = body2.shapes;
						if (sh.at(0).area > 270) {  
							grclip.removeChild(body1.userData.sprite); 
							delFromBodyMas(body1); 
							world.bodies.remove(body1); 
							if(Game.sound) Game.assets.playSound("oops");  
							var frames:Vector.<Texture> = Game.assets.getTextures("boom"); 
							var boom:MovieClip = new MovieClip(frames, 30); 
							boom.x = body1.position.x - (boom.width>>1);  
							boom.y = body1.position.y - (boom.height>>1); 
							addChild(boom); 
							boom.loop = false; 
							Starling.juggler.add(boom);  
							boom.addEventListener(Event.COMPLETE, onAnimationComplete);
			
							if (body1.userData.sprite.name == "bad") {
								scanBodyMas();   
								createScore(body1.position.x, body1.position.y, "500");
								score += 500; 
							} 
							else { 
								finished(); 
							}
						} 
						//trace("столкновение"); 
					}
				}
			}
		} 
		
		private function createScore(sx:Number, sy:Number, s:String):void {
				var scor:TextField = new TextField(52, 36, s, "Arnold 2.1", 30, 0xF14301);   
				scor.x = sx;   
				scor.y = sy;   
				addChild(scor);      
				scor.pivotX = 20;   
				scor.pivotY = 18; 
				var tween2:Tween = new Tween(scor, 0.4, Transitions.LINEAR); 
				tween2.scaleTo(0.6);   
				tween2.onComplete = onfnishedScore;
				tween2.onCompleteArgs = [scor];  
				Starling.juggler.add(tween2);
		}  
		
		private function beginCollisionFluid(cb:InteractionCallback):void {
			water.injectWave(7, cb.int1.castBody.position.x);     
			
			var frames:Vector.<Texture> = Game.assets.getTextures("bulk"); 
			var bulk:MovieClip = new MovieClip(frames, 30); 
			bulk.x = cb.int1.castBody.position.x - (bulk.width>>1); 
		    bulk.y = 17 - (bulk.height>>1); 
		    pcontainer.addChild(bulk);
			bulk.loop = false; 
			Starling.juggler.add(bulk);  
			bulk.alpha = 0.3;
			if(Game.sound) Game.assets.playSound("plesk");
			bulk.addEventListener(Event.COMPLETE, onAnimationComplete);
			
			var clip:MovieClip = cb.int1.castBody.userData.sprite;
			clip.currentFrame = 4;   
			if (clip.name == "bad") { 
				finished();   
			}
			else {
				createScore(cb.int1.castBody.position.x, cb.int1.castBody.position.y, "500"); 
				score += 500;
				scanBodyMas();
			}
		}
		 
		private function bubble_timer():void {
			var babl:Image = new Image(Game.assets.getTexture("buble"));
			babl.y = 50;
			babl.x = 10 + Math.random() * 390;
			babl.scaleX = babl.scaleY = 0.7;  
			pcontainer.addChild(babl);     
			var tween:Tween = new Tween(babl, 1, Transitions.LINEAR); 
			tween.moveTo(babl.x, 20);  
			tween.onComplete = babl.removeFromParent; 
			Starling.juggler.add(tween); 
		}
		
		private function fish_timer(bol:Boolean = false, time:int=14):void {    
			 var n:int = 1 + Math.floor(Math.random() * 4.99);
			 var clip:Image; 
			 var tween:Tween;
			 if(n != 5){   
				 clip = new Image(Game.assets.getTexture("fish_small_"+n));   
				 if(!bol) clip.x = Math.random()>0.5 ? 800+clip.width : -clip.width;  
					else clip.x = 200;      
				 clip.y = 16 + Math.random() * 20;     
				 if (clip.x < 150) clip.scaleX = -1; 
				 Math.random() > 0.5 ? pcontainer.addChild(clip) : pcontainer.addChildAt(clip, 1); 
				 tween = new Tween(clip, time, Transitions.LINEAR);
				 var pos:Number = 400 + clip.width;
				 if (clip.scaleX == 1) pos = -clip.width;  
				 tween.moveTo(pos, clip.y);    
				 tween.onComplete = clip.removeFromParent; 
				 Starling.juggler.add(tween);  
			 }  
			 else {  
				clip = new Image(Game.assets.getTexture("deepfish"));
				clip.x = Math.random() > 0.5 ? 120 : 262; 
				clip.y = 50; 
				pcontainer.addChild(clip);
				 tween = new Tween(clip, 1.5, Transitions.LINEAR);
				 tween.moveTo(clip.x, clip.y - 20);      
				 tween.onComplete = backdeep;
				 tween.onCompleteArgs = [clip]; 
				 Starling.juggler.add(tween);
			 }
			 
		}
		
		private function backdeep(clip:Image):void {
			 var tween:Tween = new Tween(clip, 1.5, Transitions.LINEAR);
			 tween.moveTo(clip.x, 50);     
			 tween.onComplete = clip.removeFromParent; 
			 Starling.juggler.add(tween);
		}
		
		private function scanBodyMas():void { 
			var bol:Boolean;
			loop: for (var i:int; i < bodyMas.length; i++) {
				if (bodyMas[i].position.y < 180) {  
					bol = true;
					break loop;    
				}
			}  
			if (!bol) {  
				if (wclip != null || fclip != null) return;    
				bodyMas.splice(0, bodyMas.length);
				if(starScore < 1500) starScore += 500;    
				wclip = new Wcompleted(score, starScore);
				wclip.x = 200 - (wclip.width >> 1);
				wclip.y = -75;   
				addChild(wclip);      
				wclip.alpha = 0;
				Game._isDraw = false;   
				var tween:Tween = new Tween(wclip, 0.9, Transitions.EASE_OUT);
				tween.delay = 1;  
			    tween.fadeTo(1); 
				tween.moveTo(wclip.x, 50); 
			    Starling.juggler.add(tween);  
				
				if (Game.level >= Game.maxlevels) Game.maxlevels++;
				
				var tot:int = score + starScore;
				
				if (tot > masLevel[level - 1]) {
					wclip.setTexter();    
					masLevel[level - 1] = tot;  
					mas[level - 1] = starScore / 500;
				}
				score = 0;
				stars = 0;    
			
				var starbadge:int;    
				for (var r:int; r < mas.length; r++ ) {
					stars += mas[r]; 
					if (mas[r] == 3) starbadge++; 
					else if (starbadge < 5) starbadge = 0;     
				}
				 
				if (starbadge >= 5 && badge_mas[3] == 0) {
					if(badge_cont.numChildren < 2){ 
						badge_mas[3] = 1;
						var badg:Badg = new Badg("badge4"); 
						badg.x = 370; 
						badg.y = 60 + 60 * badge_cont.numChildren;    
						badge_cont.addChild(badg);
					}
				}
				if(starScore < 1500 && starScore > 0) starScore += 500;   
				level < 16 ? starScore = 1500 : starScore = 2000; 
				if(Game.sound) Game.assets.playSound("win");
				SaveData();  
			}
		}
		
		private function finished():void {  
			if (fclip != null || wclip != null) return;   
			bodyMas.splice(0, bodyMas.length); 
			level < 16 ? starScore = 1500 : starScore = 2000; 
			score = 0;   
			fclip = new Wfailed; 
			fclip.x = 200 - (fclip.width >> 1);  
			fclip.y = -95; 
			addChild(fclip); 
			fclip.alpha = 0;  
			Game._isDraw = false;    
			var tween:Tween = new Tween(fclip, 0.9, Transitions.EASE_OUT);
			tween.delay = 1; 
		    tween.fadeTo(1); 
			tween.moveTo(fclip.x, 68);  
  		    Starling.juggler.add(tween);  
			if(Game.sound) Game.assets.playSound("lose"); 
		}
		
		private function drawlevel():void {
			var s:String;
			var prop:XML;
			for each(prop in xmllist) {
				s = prop.@id;
				s = s.substr(0,4);
					switch(s) {  
						case "Balk": 
							if (Game.factor == 1 && level == 4 && prop.@y==299 ) addBalka(199, prop.@y>>1, prop.@width>>1, prop.@height>>1, prop.@id);  
							else addBalka(prop.@x>>1, prop.@y>>1, prop.@width>>1, prop.@height>>1, prop.@id);   
						break;   
						case "Ston": 
							addSq(prop.@x>>1, prop.@y>>1, prop.@id);   
						break; 
						case "Stol":    
							addPlatform(prop.@x>>1, prop.@y>>1);    
						break;
					}
			} 
			for each(prop in xmllist) {  
				s = prop.@id;  
				s = s.substr(0,4); 
					switch(s) {  
						case "Fish":   
							var fr:int = Math.floor(Math.random() * 2.99);
							if (Game.factor == 1 && level == 7) {  
								if ( prop.@x == 232) addFish(121, prop.@y >> 1, prop.@id, fr);
								else if ( prop.@x == 592) addFish(292.5, prop.@y >> 1, prop.@id, fr);
								else addPoor();
							}
							else if (Game.factor == 1 && level == 12 && prop.@x == 461)
								addFish(231, prop.@y >> 1, prop.@id, fr); 
							else addPoor();
						break;   
					}
			}
			function addPoor():void {
				addFish(prop.@x>>1, prop.@y>>1, prop.@id, fr);   
			}
			var k:int = level; 
			if (k < 6) {
				switch(k) {
					case 1:
						var help3:Image = new Image(Game.assets.getTexture("help3"));
						help3.x = 172;       
						help3.y = 112; 
						addChild(help3); 
						create_help1(); 
					break;
					case 2:
						create_help2();  
					break;
					case 3:
						create_text_fish("Fish40004");
					break; 
					case 5: 
						create_text_fish("Fish30004");  
					break;
				}
			}
		}  
		
		private function create_text_fish(s:String):void {
			var infoText:TextField; 
			infoText = new TextField(42, 25, "new bad fish!", "Arnold 2.1", 11, 0xFF3300); 
			infoText.x = 21;  
			infoText.y = 43; 
			addChild(infoText);
			var textute:Texture = Game.assets.getTexture(s);
			var fishImage:Image = new Image(textute);
			fishImage.x = 22;      
			fishImage.y = 70;
			addChild(fishImage); 
		}
		
		private function create_help1():void {
			var ttFont:String = "Arnold 2.1";  
            var ttFontSize:int = 10;
			var ttFontSize2:int = 12; 
			var baseColor:uint = 0x0066FF;  
			var secondColor:uint = 0xFF6600; 
			var container:Sprite = new Sprite;
			
			var infoText:TextField;
				infoText = new TextField(108, 26,
				"good fish has to fall into the  water!", ttFont, 11, 0xFF5328); 
            infoText.x = 152;  
			infoText.y = 46; 
            container.addChild(infoText);
			
			infoText = new TextField(13, 15, 
                "1:", ttFont, ttFontSize2, baseColor); 
            infoText.x = 107;  
			infoText.y = 104; 
            container.addChild(infoText);
			 
			infoText = new TextField(45, 12, 
                "click and", ttFont, ttFontSize, secondColor);  
            infoText.x = 117;   
			infoText.y = 105; 
            container.addChild(infoText);
			
			infoText = new TextField(67, 24,   
                "hold to start the slice", ttFont, ttFontSize, secondColor); 
            infoText.x = 108; 
			infoText.y = 116;
			infoText.hAlign = HAlign.LEFT;  
            container.addChild(infoText);
			
			infoText = new TextField(15, 15, 
                "2:", ttFont, ttFontSize2, baseColor); 
            infoText.x = 220; 
			infoText.y = 170; 
            container.addChild(infoText);
			
			infoText = new TextField(33, 13,  
                "release", ttFont, ttFontSize, secondColor);  
            infoText.x = 235;  
			infoText.y = 170; 
            container.addChild(infoText);
			
			infoText = new TextField(59, 24,    
                "to perform the slice", ttFont, ttFontSize, secondColor); 
            infoText.x = 223; 
			infoText.y = 181;
			infoText.hAlign = HAlign.LEFT;  
            container.addChild(infoText);
			
			addChildAt(container, 1);   
		}
		
		private function create_help2():void {
			var ttFont:String = "Arnold 2.1";  
            var ttFontSize:int = 10;
			var baseColor:uint = 0xFF3300;   
			var container:Sprite = new Sprite;
			 
			var infoText:TextField;
				infoText = new TextField(150, 23,  
				"number of slices left to collect 3, 2 and 1 star", ttFont, ttFontSize, 0xFF6600);  
            infoText.x = 131;  
			infoText.y = 40; 
            container.addChild(infoText);
			
			infoText = new TextField(74, 14,   
                "kill a bad fish!", ttFont, ttFontSize, baseColor);  
            infoText.x = 87;   
			infoText.y = 141;  
            container.addChild(infoText);
			 
			infoText = new TextField(74, 23,   
                "good fish must survive!", ttFont, ttFontSize, baseColor);  
            infoText.x = 239;   
			infoText.y = 88;  
            container.addChild(infoText);
			
			addChildAt(container, 1);    
		}  
		
		private function addPlatform(pX:Number,pY:Number):void {
			var napeBody:Body=new Body(BodyType.STATIC,new Vec2(pX,pY));
			var polygon:Polygon = new Polygon(Polygon.box(10, 71));     
			polygon.filter = new InteractionFilter(0x000000011, 0x000000001);
			polygon.material.elasticity=0.1; 
			polygon.material.density=1;
			//polygon.material.staticFriction=0;
			napeBody.shapes.add(polygon);
			napeBody.space = world;
			var img:Image = new Image(Game.assets.getTexture("Stolb"));
			img.pivotX = img.width>>1; 
			img.pivotY = img.height>>1;
			napeBody.userData.sprite = img;    
			grclip.addChild(napeBody.userData.sprite);
		}
		
		private function addBalka(pX:Number,pY:Number,w:Number,h:Number, id:String):void {  
			var napeBody:Body=new Body(BodyType.DYNAMIC,new Vec2(pX,pY)); 
			var polygon:Polygon = new Polygon(Polygon.box(w, h)); 
			polygon.material.elasticity = 0.1;  
			polygon.material.density = 1; 
			//polygon.material.dynamicFriction = 10;
			//polygon.material.staticFriction = 10;
			napeBody.cbTypes.add(BOX);  
			polygon.filter = new InteractionFilter(0x000000011, 0x000000001); 
			//polygon.material.staticFriction=0;
			napeBody.shapes.add(polygon);
			napeBody.space = world;  
			napeBody.userData.sprite = new BitmapCut(id, polygon.localVerts, new Vec2(0,0));     
			grclip.addChild(napeBody.userData.sprite);       
		}
		
		private function addFish(x:int, y:int, id:String, frame:int):void {  
			var dynamicBox:Body = new Body(BodyType.DYNAMIC,new Vec2(x,y)); 
				var circl:Circle = new Circle(12.5);       
                circl.filter = new InteractionFilter(0x000000001, 0x000000001);    
				//circl.material.elasticity = 0.5; 
				circl.material.density = 1;   
				dynamicBox.cbTypes.add(ENEMY);    
				dynamicBox.shapes.add(circl); 
				var frames:Vector.<Texture> = Game.assets.getTextures(id);
				var fishclip:MovieClip = new MovieClip(frames);
				fishclip.name = (id.substr(4, 1) == "1" || id.substr(4, 1) == "3") ? "good": "bad";
				fishclip.pivotX = fishclip.width >> 1; 
				fishclip.pivotY = fishclip.height >> 1;
				if (id.substr(4, 1) == "2") fishclip.pivotY ++;  
				fishclip.currentFrame = frame; 
				dynamicBox.userData.sprite = fishclip; 
				grclip.addChild(dynamicBox.userData.sprite);
				dynamicBox.space = world;
				bodyMas.push(dynamicBox);
		}
		
		private function addSq(pX:Number,pY:Number,id:String):void {
			var napeBody:Body=new Body(BodyType.STATIC,new Vec2(pX,pY));
			var polygon:Polygon = new Polygon(Polygon.box(10, 10));
			polygon.filter = new InteractionFilter(0x000000011, 0x000000001);
			polygon.material.elasticity=0.1; 
			polygon.material.density=1;
			//polygon.material.staticFriction=0;
			napeBody.shapes.add(polygon);
			napeBody.space = world; 
			// var clip:MovieClip;
			// ih ? clip = new Stone : clip = new Stone2;  
			var img:Image = new Image(Game.assets.getTexture(id));
			img.pivotX = img.width>>1; 
			img.pivotY = img.height>>1; 
			napeBody.userData.sprite = img;
			grclip.addChild(napeBody.userData.sprite);
		}
		
		private function addWall(pX:Number,pY:Number,w:Number,h:Number):void {
			var napeBody:Body=new Body(BodyType.STATIC,new Vec2(pX,pY));
			var polygon:Polygon=new Polygon(Polygon.box(w,h));
			polygon.material.elasticity=0.5; 
			polygon.material.density=1;
			polygon.material.staticFriction=0;
			napeBody.shapes.add(polygon);
			napeBody.space = world;
		}
		
		private function createInteractorType():void {
			ENEMY = new CbType();
			FLUID = new CbType(); 
			BOX = new CbType();
		}
		
		private function update(e:Event):void {
			/*
			var curTimeMS:uint = getTimer();
            if (curTimeMS == prevTimeMS) { 
                // No time has passed! 
                return;
            } 
		    
            // Amount of time we need to try and simulate (in seconds).
            var deltaTime:Number = (curTimeMS - prevTimeMS) / 1000;
            // We cap this value so that if execution is paused we do
            // not end up trying to simulate 10 minutes at once.
            if (deltaTime > 0.05) {
                deltaTime = 0.05;
            }
            prevTimeMS = curTimeMS;
            simulationTime += deltaTime;
			*/
			 // Keep on stepping forward by fixed time step until amount of time
            // needed has been simulated.
			// while (world.elapsedTime < simulationTime) { 
                world.step(1 / 30);
           // }

			var bodies:BodyList=world.bodies; 
			for (var i:int = 0; i < bodies.length; i++) {
				var body:Body = bodies.at(i);
				var dobj:DisplayObject = body.userData.sprite; 
				if (dobj != null) { 
					dobj.x = body.position.x;
					dobj.y = body.position.y;
					dobj.rotation = body.rotation;  
					if (body.userData.sprite is MovieClip) {  
						if (body.rotation > 0.5 || body.rotation < -0.5) {
							if(body.userData.sprite.currentFrame < 3) body.userData.sprite.currentFrame=3; 
						} 
					}
				}
				dobj = null; 
			}
		}

		public function onfnishedScore(s:TextField):void {
			var delayedCall:DelayedCall = new DelayedCall(s.removeFromParent, 0.6);
		    Starling.juggler.add(delayedCall); 
		}

		public override function dispose():void { 
			Starling.juggler.purge();
            removeEventListener(Event.ENTER_FRAME, update); 
			removeEventListener(TouchEvent.TOUCH, mouseUpHandler);
            super.dispose();
        }
		
		public override function create_more():void { }
		
//-----		
	}
}