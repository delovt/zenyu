package yssoft.vos
{
	
	[Bindable]
	[RemoteClass(alias="yssoft.vos.twitter.TwitterTypeVo")]
	public class TwitterTypeVo
	{
		public function TwitterTypeVo()
		{
		}
		
		public var iid:int;			 //内码		
		
		public var ipid:int;			//父级内码		
		
		public var ccode:String;       //编码		
		
		public var cname:String;		//功能模块名称		
		
		public var ihot:int;
		
		public var cmemo:String;
		
		public var imaker:int;
		
		public var dmaker:String;
		
		public var person:String;
		
		public var personName:String;
	}


}