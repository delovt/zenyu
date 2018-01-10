/**
 * 作者:zmm
 * 日期：2011-8-20
 * 功能：自由协同表、表单协同主表
 */
package yssoft.vos
{
	import mx.collections.ArrayCollection;

	[Bindable]
	[RemoteClass(alias="yssoft.vos.OAinvoiceVo")]
	public class OAinvoiceVo
	{
		public function OAinvoiceVo()
		{
		}
		public var iid:int;
		public var ifuncregedit:int;
		public var iinvoice:int;
		public var csubject:String
		public var icustomer:int;
		public var dfinished:String;
		public var bplan:int=1;
		public var cdetail:String;
		public var baddnew:int=1;
		public var bsendnew:int=1;
		public var istatus:int=0;
		
		public var csendnew:String;
		public var isendnew:int;
		
		public var imaker:int;						//制单人
		public var maker:String="";					//制单人的名称
		public var dmaker:String="";					//制单时间
		public var adiid:int;						//协同对应的单据信息
		public var nodes:String; 					//工作流，节点信息
		public var nodeDetail:String; 				//工作流中，节点对应的详细信息
		public var customername:String;			//相关客户名称
		
		public var bfinalverify:int;			//是否终审
		public var iinvoset:int;				//主表内码

	}
}