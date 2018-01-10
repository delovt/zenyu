package yssoft.vos
{
	public class AbInvoicepropertyVo
	{
		public function AbInvoicepropertyVo()
		{
		}
		
		//自增值
		public var iid:int;
		//业务单据类型内码
		public var ifuncregedit:int;
		//业务单据内码ID
		public var iinvoice:int;
		//业务单据编码
		public var ccode:String;
		//工作流ID
		public var iworkflow:int;
		//UI界面ID
		public var iform:int;
		//源单类型内码
		public var isourceregedit:int;
		//源单内码ID
		public var isource:int;
		//制单人
		public var imaker:int;
		//制单时间
		public var dmaker:Date;
		//最后修改人	
		public var imodify:int;
		//最后修改时间
		public var dmodify:Date;
		//审核人
		public var iverify:int;
		//审核时间
		public var dverify:Date;
		//记账人
		public var iaccounting:int;
		//记账时间
		public var daccounting:Date;
		//关闭人
		public var iclose:int;
		//关闭时间
		public var dclose:Date;
		//删除人
		public var idelete:int;
		//删除时间
		public var ddelete:Date;
		//信息完整度
		public var ffullrate:int;
	}
}