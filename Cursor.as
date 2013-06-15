package  {
	import flash.events.Event;
	import flash.geom.Point;
	import flash.ui.Mouse;
	import starling.events.Touch;
	
	import starling.display.Sprite;
	import starling.display.MovieClip;
	import starling.events.TouchEvent;
	import starling.textures.Texture;
	/**
	 * ...
	 * @author waltassar
	 */
	public class Cursor extends Sprite {
		
		private var mouse:MovieClip;
		private var hide_cur_trig:Boolean;
		 
		public function Cursor() {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		} 
		
		private function init():void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			var frames:Vector.<Texture> = Game.assets.getTextures("cursor"); 
			mouse = new MovieClip(frames);   
		    addChild(mouse);    
			Mouse.hide();  
			mouse.visible = false; 
			mouse.touchable = false; 
			   
			//stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave);  
		    stage.addEventListener(TouchEvent.TOUCH, mouse_move); 
		} 
		
		private function onMouseLeave(event:Event):void {
			 mouse.visible = false;
			 hide_cur_trig = true;  
		}
		 
		private function mouse_move(event:TouchEvent):void {
			var touch:Touch = event.getTouch(stage);
			if(touch == null) return; 
			var pos:Point = touch.getLocation(stage);
			if (!mouse.visible) mouse.visible = true;
			mouse.x = pos.x;
			mouse.y = pos.y-20;
			
			if (hide_cur_trig == true) {
				 Mouse.hide();
				 mouse.visible = true; 
				 hide_cur_trig = false; 
			}
		}
		
		public function set _mouse(frame:int):void {
			mouse.currentFrame = frame;  
		}
//-----		
	}
}