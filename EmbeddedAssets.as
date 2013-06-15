package {
	/**
	 * ...
	 * @author waltasar
	 */
    public class EmbeddedAssets {
        /** ATTENTION: Naming conventions!
         *  
         *  - Classes for embedded IMAGES should have the exact same name as the file,
         *    without extension. This is required so that references from XMLs (atlas, bitmap font)
         *    won't break.
         *    
         *  - Atlas and Font XML files can have an arbitrary name, since they are never
         *    referenced by file name.
         * 
         */
        
        // Texture Atlas
        
        [Embed(source="../textures/1x/pack.xml", mimeType="application/octet-stream")]
        public static const pack_xml:Class; 
        [Embed(source="../textures/1x/pack.png")]
        public static const pack:Class; 
		
		[Embed(source="../textures/1x/fish.xml", mimeType="application/octet-stream")]
        public static const fish_xml:Class;
        [Embed(source="../textures/1x/fish.png")]  
        public static const fish:Class;
		
        // Bitmap Fonts
        
        [Embed(source="../fonts/1x/arnold.fnt", mimeType="application/octet-stream")]
        public static const arnold_fnt:Class;   
        
        [Embed(source = "../fonts/1x/arnold.png")]
        public static const arnold:Class;
       
//-----		
    }
}