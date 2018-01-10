package yssoft.vos
{
	[Bindable]
	[RemoteClass(alias="yssoft.vos.AsAuthcontentVo")]
	public class AuthcontentVo
	{
		public function AuthcontentVo()
		{
			super();
		}
		
		// 自增值
		public var  iid:int;
		
		// 上级分类码
		public var  ipid:int;
		
		// 编码
		public var  ccode:String;
		
		// 名称
		public var cname:String;
		
		// 参数值
		public var coperauth:String;
		
		// 是否启用
		public var buse:Boolean;
		
		// 备注
		public var cmemo:String;
		
		public var oldCcode:String;
	}
}