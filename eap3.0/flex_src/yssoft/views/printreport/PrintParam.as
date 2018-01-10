package yssoft.views.printreport
{
	public class PrintParam
	{
		public function PrintParam()
		{
		}
		
		public static function AddParam(name:String,value:String):PrintParam
		{
			var param:PrintParam=new PrintParam();
			param.name=name;
			param.value=value;
			return param;
		}
		
		//参数名(以@开头)
		public var name:String;
		//参数值
		public var value:String;
	}
}