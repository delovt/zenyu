package yssoft.vos
{
	[Bindable]
	[RemoteClass(alias="yssoft.vos.HrPostVo")]
	public class PostVo
	{
		public function PostVo()
		{
		}
		
		// 内码
		public var iid:int;
		
		// 职类内码
		public var ipostclass:int;
		
		// 编码
		public var ccode:String;
		
		// 名称
		public var cname:String;
		
		// 级别
		public var ilevel:int;
		
		// 职务描述
		public var cwork:String;
		
		// 备注
		public var cmemo:String;
		
		public var postclassName:String;
		//在职人数
		public var irealperson:int;
	}
}