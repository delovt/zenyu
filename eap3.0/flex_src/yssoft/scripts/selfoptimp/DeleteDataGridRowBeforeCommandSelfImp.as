/**
 * 单据操作，自定义执行命令
 * 方法定义规则：public function onExcute_IFun功能内码(cmdparam:CommandParam):void
 * cmdparam参数属性：
 *  param:*;						  //传递的参数
	nextCommand:ICommand;			  //要执行的下一个命令
	excuteNextCommand:Boolean=false;  //是否立即执行下一条命令
	context:Container=null;           //环境容器变量
	optType:String="";                //操作类型
	cmdselfName:String="";            //自定义命令名称
 */
package yssoft.scripts.selfoptimp
{
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.rpc.events.ResultEvent;
	
	import yssoft.comps.frame.module.CrmEapDataGrid;
	import yssoft.comps.frame.module.CrmEapRadianVbox;
	import yssoft.frameui.FrameCore;
	import yssoft.frameui.formopt.selfopt.DeleteDataGridRowCommandSelf;
	import yssoft.tools.AccessUtil;
	import yssoft.tools.CRMtool;
	import yssoft.vos.CommandParam;


	public class DeleteDataGridRowBeforeCommandSelfImp
	{
		public var deleteDataGridRowCommandSelf:DeleteDataGridRowCommandSelf;
		
		public function DeleteDataGridRowBeforeCommandSelfImp()
		{
		}
		/**
		 * 方法功能：
		 * 编写作者：
		 * 创建日期：
		 * 更新日期：
		 */
		/*public function onExcute_IFun162(cmdparam:CommandParam):void
		{
		}*/
		
		/**
		 * 对应单据： 客商资产
		 * lzx add
		 **/
		/*public function onExcute_IFun216(cmdparam:CommandParam):void
		{
			var curDataGrid:CrmEapDataGrid=cmdparam.context.triggerCrmEapControl as CrmEapDataGrid;
			if (curDataGrid.ctableName == "cs_custproducts")
			{
				var crmeap:CrmEapRadianVbox = cmdparam.context["crmeap"] as CrmEapRadianVbox;
			    //当前单据数据
			    var itemdata:Object=crmeap.getValue();
		     	//ifuncregedit=228时不允许删除
				var ifuncregedit:int = itemdata.ifuncregedit;

				var sql:String = "";
				var iids:String = "";
				
				for (var i:int =0; i<curDataGrid.tableList.length; i++) {
					if(curDataGrid.tableList[i].checked) {
						iids += curDataGrid.tableList[i].iid + ",";
					}
				}
				
				iids = iids.substr(0, iids.length-1);
				sql = "cs_custproducts.iid in(" + iids + ")";
				
				*//*if(ifuncregedit == 228){
					AccessUtil.remoteCallJava("GetCcodeDest","getRdrecordCcode", function (e:ResultEvent):void {
						var res:ArrayCollection = e.result as ArrayCollection;
						var middle:String = "";
						for (var i:int = 0; i<res.length; i++) {
							middle += res[i].ccode.toString() + ",";
						}
						middle = middle.substr(0, middle.length-1);
						CRMtool.showAlert("请撤销单据号为：" + middle + "的出库单后再进行删除操作！");
					},sql);	
					(crmeap.paramForm as FrameCore).curButtonStatus="onGiveUp";
					cmdparam.excuteNextCommand=false;
					return;
				}else*//*
					deleteDataGridRowCommandSelf.onNext();
				
				//cmdparam.excuteNextCommand=true;	
			}
		}*/
		
	}
}