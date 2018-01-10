package yssoft.tools
{
	public class StringTool
	{
		import mx.utils.StringUtil;
		
		public static function trim(src:String=null):String
		{
			return "";
		}
		
		/**
		 * string 为空后，用指定的string来代替
		 */
		public static function isNull(src:String,replace:String=""):String
		{
			if(src==null || StringUtil.trim(src)==""){
				return replace;
			}else{
				return src;
			}
		}
	}
}