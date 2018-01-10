package yssoft.vos
{
	import flash.utils.ByteArray;

	[Bindable]
	[RemoteClass(alias="yssoft.vos.AbInvoiceatmVo")]
	public class AbInvoiceatmVo
	{
		
		public function AbInvoiceatmVo()
		{
		}
		
		public var iid:int
		public var ifuncregedit:int
		public var iinvoice:int
		public var iinvoices:int
		public var cname:String
		public var cextname:String
		public var cdataauth:String
		public var iperson:int
		public var dupload:String
		public var pcname:String;
		public var size:String;
		public var fdata:ByteArray;
		public var csysname:String;
	}
}