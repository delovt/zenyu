package yssoft.vos
{
	[Bindable]
	[RemoteClass(alias="yssoft.vos.WfInvosetVo")]
	public class WfInvosetVo
	{
		public var iid:int;
		public var cnodeid:String
		public var cpnodeid:String;
		public var inodelevel:int
		public var ipid:int;
		public var iinvoset:int;
		public var inodetype:int;
		public var inodevalue:int;
		public var inodeattribute:int;
		public var inodemode:int;
		public var bfinalverify:int;
		public var baddnew:int;
		public var bsendnew:int;
		public var cnotice:String;
	}
}