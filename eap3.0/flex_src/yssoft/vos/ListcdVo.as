package yssoft.vos
{
	[Bindable]
	[RemoteClass(alias="yssoft.vos.ListcdVo")]//对应的java类，不需要数据转换了
	
	public class ListcdVo
	{
		public function ListcdVo()
		{
		}
		
		//内码
		public var iid:int;
		
		//列表配置上级内码
		public var ipid:int;
		
		//关联功能注册码
		public var ifuncregedit:int;
		
		//常用条件编码
		public var ccode:String;
		
		//常用条件名
		public var cname:String;
		
		//SQL语句
		public var csql:String;
		
		//老编码
		public var oldCcode:String;
	}
}