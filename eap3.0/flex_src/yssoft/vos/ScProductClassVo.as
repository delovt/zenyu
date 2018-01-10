package yssoft.vos
{	
	[Bindable]
	[RemoteClass(alias="yssoft.vos.ScProductClass")]
	public class ScProductClassVo
	{
		
		public function ScProductClassVo()
		{
		}
		
		public var iid:int;
		public var ipid:int;
		public var ccode:String;
		public var cname:String;
		public var cmemo:String;
		public var cabbreviation:String;//YJ Add 单位分类编码前缀
		
	}
}