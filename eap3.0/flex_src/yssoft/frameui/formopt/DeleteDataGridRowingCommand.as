package yssoft.frameui.formopt
{
	import mx.collections.ArrayCollection;
	import mx.core.Container;
	
	import yssoft.comps.frame.module.CrmEapDataGrid;
	import yssoft.frameui.VouchForm;
	import yssoft.impls.ICommand;
	import yssoft.tools.CRMtool;
	
	public class DeleteDataGridRowingCommand extends BaseCommand
	{
		
		private var primaryKey:String="";//子表主键
		private var foreignKey:String="";//子表外键及母表主键
		
		public function DeleteDataGridRowingCommand(context:CrmEapDataGrid, optType:String="", param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
		{
			super(context, optType, param, nextCommand, excuteNextCommand);
		}
		
		override public function onExcute():void{
			
			var selectedArr:ArrayCollection = context["getSelectRows"]();
			
			if(selectedArr.length==0)
			{
				CRMtool.tipAlert("请选择要删除的记录集...");
				return;
			}
/* 修改前代码   屏蔽原因：无法满足在删除母表的同时删除其对应的子表数据****************************
			for each(var item:Object in selectedArr)
			{
				context["tableList"].removeItemAt(context["tableList"].getItemIndex(item));
			}
			context["dataProvider"]=context["tableList"];
*****************************************************************************/
			
// **********XZQWJ 修改 **************************************************************
			var dataProvider:ArrayCollection = context["dataProvider"];
			var all_tableList:ArrayCollection = context["all_tableList"];
			if(!(context.paramForm.paramForm is VouchForm)){
				for each(var item:Object in selectedArr)
				{
					deleteChildData(context as CrmEapDataGrid,item);
					if(all_tableList.getItemIndex(item)>-1){
						all_tableList.removeItemAt(all_tableList.getItemIndex(item));
					}
					if(dataProvider.getItemIndex(item)>-1){
						dataProvider.removeItemAt(dataProvider.getItemIndex(item));
					}
				}
				context["all_tableList"]=all_tableList;
				context["dataProvider"]=dataProvider;
			}else{
				for each(var item:Object in selectedArr)
				{
					context["tableList"].removeItemAt(context["tableList"].getItemIndex(item));
				}
				context["dataProvider"]=context["tableList"];
			}
			
//*********结束*******************************************************************			
			this.onNext();
		}
		
		/**
		 * 作者：XZQWJ	
		 * 创建时间：2013-01-12
		 * 功能：删除对应的子表记录
		 * 参数：context 当前 CrmEapDataGrid ；selectItem 选中要删除的记录之一
		 * */
		public function deleteChildData(context:CrmEapDataGrid,selectItem:Object):void{
			var tableMessage:ArrayCollection = new ArrayCollection();
			if(context.paramForm.paramForm.hasOwnProperty("crmeap")) {
				tableMessage=context.paramForm.paramForm.crmeap.tableMessage;//表之间关系
			}else {
				tableMessage=context.paramForm.tableMessage;
			}
			var currDGridName:Object=context.ctableName;//当前表名
			var ctable2:String="";
			var ctable:String="";
			var primaryKey:String="";
			var foreignKey:String="";
			var l:int = tableMessage.length;
			for(var i:int=0;i<l;i++){
				if(!tableMessage.getItemAt(i).bMain&&tableMessage.getItemAt(i).ctable2==currDGridName){
					ctable2=currDGridName.toString();
					ctable=tableMessage.getItemAt(i).ctable as String;//子表表名
					for each(var dg:CrmEapDataGrid in context.paramForm.paramForm.crmeap.gridList){
						if(dg.ctableName==ctable){
							primaryKey=tableMessage.getItemAt(i).primaryKey;
							foreignKey=tableMessage.getItemAt(i).foreignKey;
							
							var dataProvider:ArrayCollection = dg["dataProvider"];
							var all_tableList:ArrayCollection = dg["all_tableList"];
							
							var dp_l:int=dataProvider.length;
							
							for(var ii:int=dp_l-1;ii>=0;ii--){
								 if (dataProvider.getItemAt(ii)[foreignKey]==selectItem[primaryKey]){
									 dataProvider.removeItemAt(ii);
								 }
							}
							var table_l:int=all_tableList.length;
							for(var j:int=table_l-1;j>=0;j--){
								if(all_tableList.getItemAt(j)[foreignKey]==selectItem[primaryKey]){
									all_tableList.removeItemAt(j);
								}
							}
							
							dg["dataProvider"]=dataProvider;
							dg["all_tableList"]=all_tableList;
							break;
						}
					}
				}
			}
		}
	}
}