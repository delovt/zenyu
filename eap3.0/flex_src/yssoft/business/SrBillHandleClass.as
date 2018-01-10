package yssoft.business
{
	import yssoft.tools.AccessUtil;
	/**
	 * 
	 * 	服务派工单其他业务操作
	 *  包含以下功能点：
	 * 	1、服务派工单保存后更新服务请求单状态为派单
	 *  2、服务派工单删除时更新服务请求单状态为新建
	 *  3、
	 * 
	 * 	创建人： 	YJ
	 *  创建时间:	2012-04-05
	 *  
	 * */
	public class SrBillHandleClass
	{
		public function SrBillHandleClass(){}
		
		private var _iinvoice:int;//服务派工单中对应的相关单据内码(也就是服务申请单中的内码)
		
		public function set iinvoice(value:int):void{
			this._iinvoice = value;
		}
		
		private var _istatus:int;//服务申请单状态
		
		public function set istatus(value:int):void{
			this._istatus = value;
		}
		
		/*
			更新服务申请单的状态
		*/
		public function onUpdateSrRequestStatus():void{
			
			var objvalue:Object = {};
			objvalue.istatus = this._istatus;
			objvalue.iid	 = this._iinvoice;
			
			AccessUtil.remoteCallJava("SrBillDest","onUpdateSrRequestStatus",null,objvalue);			
			
		}
	}
}