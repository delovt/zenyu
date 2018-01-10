package yssoft.vos
{
	[Bindable]
	[RemoteClass(alias="yssoft.vos.wf_invosetVo")]
	public class wf_invosetVo
	{
		public var iid:int;
		public var ifuncregedit:int;	// 表单iid
		public var ifuncname:String;	//表单名称
		public var ccode:String;
		public var cname:String;
		public var brelease:int;
		public var dmaker:String;
		public var imaker:int;
		public var imakername:String;
	}
}