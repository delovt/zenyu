package yssoft.vos
{
	[Bindable]
	[RemoteClass(alias="yssoft.vos.HrPostclassVo")]
	public class PostclassVo
	{
		public function PostclassVo()
		{
		}
		
		//内码
		public var iid:int;
		
		//编码
		public var ccode:String;
		
		//名称
		public var cname:String;
		
		//备注
		public var cmemo:String;
		
		//父节点编码
		public var ipid:int;
		
		public var oldCcode:String;
	}
}