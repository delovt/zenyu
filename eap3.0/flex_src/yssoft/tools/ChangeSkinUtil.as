package yssoft.tools
{
	import mx.styles.StyleManager;

	public class ChangeSkinUtil
	{
		//更换样式皮肤
		public static function changeSkin(newSkin:String,oldSkin:String=null):void{
			unloadStyleSkin(oldSkin);
			loadStyleSkin(newSkin);
		}
		//卸载样式皮肤
		public static function unloadStyleSkin(skinName:String=null):void{
			if(skinName){ // 先卸载，之前的皮肤，如果有的话
				StyleManager.unloadStyleDeclarations(skinName);
			}
		}
		//加载样式皮肤
		public static function loadStyleSkin(skinName:String=null):void{
			if(skinName){ // 记载新的皮肤
				StyleManager.loadStyleDeclarations(skinName);
			}
		}
	}
}