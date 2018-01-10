package yssoft.vos
{
	import flash.utils.ByteArray;

	[Bindable]
	[RemoteClass(alias="yssoft.vos.AbSmsVo")]
	public class AbSmsVo
	{
		
		public function AbSmsVo()
		{
		}
		
		public var iid:int;
		public var ifuncregedit:int;
		public var iinvoice:int;
		public var icustomer:int;
		public var imrcustomer:int;
		public var ccusname:String;
		public var icustperson:int;
		public var cpsnname:String;
		public var ctitle:String;
		public var cmobile:String;
		public var cdetail:String;
		public var istate:int;
		public var imaker:int;
		public var dmaker:Date;
		public var imodify:int;
		public var dmodify:Date;
	}
}