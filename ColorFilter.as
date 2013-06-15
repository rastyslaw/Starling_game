package {
	import starling.filters.ColorMatrixFilter;
	/** 
	 * ...
	 * @author waltassar
	 */
	public class ColorFilter extends ColorMatrixFilter {
		
		private var _brightness:Number;
	 
		public function ColorFilter() {
			_brightness = 0;
		}
	  
		public function get brightness():Number { return _brightness; }
		
		public function set brightness(value:Number):void {
			_brightness = value;
			reset();
			adjustBrightness(value);
		}
//-----		
	}
}