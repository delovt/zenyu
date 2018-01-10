package yssoft.vos
{
	[Bindable]
	[RemoteClass(alias="yssoft.vos.AsOperauthVo")]
	public class OperauthVo
	{
		public function OperauthVo()
		{
		}
		
		//自增值
		public  var iid:int;
		
		//角色内码
		public var irole:int;
		
		//操作权限值
		public  var coperauth:String;
		
	}
}