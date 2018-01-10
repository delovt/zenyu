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
	import mx.core.IFactory;
	import mx.rpc.events.ResultEvent;
	
	import yssoft.comps.frame.module.CrmEapDataGrid;
	import yssoft.tools.AccessUtil;
	import yssoft.tools.CRMtool;
	import yssoft.vos.CommandParam;

	public class DClickDataGridRowAfterCommandSelfImp
	{
		public function DClickDataGridRowAfterCommandSelfImp()
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
		 * 工单费用双击datagrid中某一行打开对应的单据
		 * 创建人：王炫皓
		 * 创建时间：201201219
		 * */
		public function onExcute_IFun226(cmdparam:CommandParam):void{
			var curDataGrid:CrmEapDataGrid=cmdparam.context.triggerCrmEapControl as CrmEapDataGrid;
			var obj:Object = cmdparam.context["crmeap"].getValue();
			if(obj && obj["oa_expenses"]&& obj["oa_expenses"][curDataGrid.selectedIndex]&& obj["oa_expenses"][curDataGrid.selectedIndex].iid >0){
				var sqls:String = "select ctable from as_funcregedit where iid = (select ifuncregedit from oa_expenses where iid = "+obj["oa_expenses"][curDataGrid.selectedIndex].iid+" )";
				AccessUtil.remoteCallJava("CommonalityDest","assemblyQuerySql",function(event:ResultEvent):void{
					var ctable:Object = event.result ;
					var  sql:String = "select*from "+ctable[0].ctable+" where iid =  (select iinvoice from oa_expenses where iid ="+obj["oa_expenses"][curDataGrid.selectedIndex].iid+")";
					AccessUtil.remoteCallJava("CommonalityDest","assemblyQuerySql",function(event:ResultEvent):void{
						var relatedDocuments:ArrayCollection = event.result as ArrayCollection;
						if(relatedDocuments&&relatedDocuments.length >0){		
							var obj:Object = relatedDocuments[0];
							CRMtool.openbillonbrowse(obj.iifuncregedit,obj.iid,"");
						}
					},sql)
				},sqls)
			}
		}
	}
}