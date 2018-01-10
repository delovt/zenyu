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
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.core.UIComponent;
	import mx.rpc.events.ResultEvent;
	
	import yssoft.comps.frame.module.CrmEapDataGrid;
	import yssoft.comps.frame.module.CrmEapRadianVbox;
	import yssoft.comps.frame.module.SingleVbox;
	import yssoft.comps.product_controls.BomsWindow;
	import yssoft.tools.AccessUtil;
	import yssoft.tools.CRMtool;
	import yssoft.vos.CommandParam;

	public class DClickDataGridRowingCommandSelfImp
	{
		public function DClickDataGridRowingCommandSelfImp()
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
		 * 方法功能：公共单据浏览状态下，双击客商档案表体联系人员行，自动打开联系人卡片
		 * 编写作者：刘磊
		 * 创建日期：2012-4-13
		 * 更新日期：2012-4-13
		 */
		public function onExcute_IFun44(cmdparam:CommandParam):void
		{
			if (cmdparam.context.curButtonStatus=="onGiveUp")
			{
			   var curDataGrid:CrmEapDataGrid=cmdparam.context.triggerCrmEapControl as CrmEapDataGrid;
			   if (curDataGrid.selectedItem && curDataGrid.selectedItem.iid>0)
			   {
			      CRMtool.openbillonbrowse(45,curDataGrid.selectedItem.iid,"客商人员资料",curDataGrid.ctableName);
			   }
			}
		}
	}
}