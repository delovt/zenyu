package yssoft.vos
{
	[Bindable]
	[RemoteClass(alias="yssoft.vos.WfMessageVo")]
	public class WfMessageVo
	{
		public function WfMessageVo()
		{
			
		}
		public var iid:int;
		public var ioainvoice:int;
		public var iperson:int;
		public var dprocess:String;
		public var iresult:int;
		public var cmessage:String;
		public var bhide:int;
		public var inoticeperson:int;
		public var breceive:int;
		public var bdiary:int;
		public var cname:String;
		public var resultname:String;
		public var fdate:String;
	}
}