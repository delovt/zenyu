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
	import mx.formatters.DateFormatter;
import mx.formatters.NumberBaseRoundType;
import mx.formatters.NumberFormatter;

import yssoft.comps.frame.module.CrmEapDataGrid;
	import yssoft.comps.frame.module.CrmEapRadianVbox;
import yssoft.frameui.FrameCore;
import yssoft.models.CRMmodel;
	import yssoft.tools.CRMtool;
	import yssoft.vos.CommandParam;

	public class AddDataGridRowAfterCommandSelfImp
	{
		public function AddDataGridRowAfterCommandSelfImp()
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
		 * 方法功能：根据成交金额自动填写收款计划金额    （产品新增）
		 *          新行收入计划金额=成交金额－收入计划金额合计
		 *          若差值为0则给出友好提示“增行失败！原因：成交金额已分配完毕。”
		 * 编写作者：刘磊
		 * 创建日期：2012-4-6
		 * 更新日期：2012-4-6
		 */
		public function onExcute_IFun162(cmdparam:CommandParam):void
		{
			this.onRestrainCheck(cmdparam);
		}
		
		
		/**
		 * 方法功能：根据成交金额自动填写收款计划金额(产品升级)
		 *          新行收入计划金额=成交金额－收入计划金额合计
		 *          若差值为0则给出友好提示“增行失败！原因：成交金额已分配完毕。”
		 * 编写作者：YJ
		 * 创建日期：2012-4-10
		 * 更新日期：
		 */
		public function onExcute_IFun161(cmdparam:CommandParam):void
		{
            checkHasIcustomer(cmdparam);
			this.onRestrainCheck(cmdparam);
		}
		
		//开发合同
		public function onExcute_IFun210(cmdparam:CommandParam):void
		{
			
			this.onRestrainCheck(cmdparam);
		}
		
		//实施合同
		public function onExcute_IFun459(cmdparam:CommandParam):void
		{
			
			this.onRestrainCheck(cmdparam);
		}
		/**
		 * 方法功能：表单设置增行后，自动移至最后一行
		 * 编写作者：刘磊
		 * 创建日期：2012-5-26
		 * 更新日期：
		 */
		public function onExcute_IFun145(cmdparam:CommandParam):void
		{
			var curDataGrid:CrmEapDataGrid=cmdparam.context.triggerCrmEapControl as CrmEapDataGrid;
			curDataGrid.verticalScrollPosition=100;
		}
		
		/**
		 * 方法功能：根据成交金额自动填写收款计划金额(配套耗材)
		 *          新行收入计划金额=成交金额－收入计划金额合计
		 *          若差值为0则给出友好提示“增行失败！原因：成交金额已分配完毕。”
		 * 编写作者：YJ
		 * 创建日期：2012-4-10
		 * 更新日期：
		 */
		public function onExcute_IFun157(cmdparam:CommandParam):void
		{
			this.onRestrainCheck(cmdparam);
		}
		
		/**
		 * 方法功能：根据成交金额自动填写收款计划金额 (服务收费)
		 *          新行收入计划金额=成交金额－收入计划金额合计
		 *          若差值为0则给出友好提示“增行失败！原因：成交金额已分配完毕。”
		 * 编写作者：YJ
		 * 创建日期：2012-4-10
		 * 更新日期：
		 */
		public function onExcute_IFun159(cmdparam:CommandParam):void
		{
            checkHasIcustomer(cmdparam);
			this.onRestrainCheck(cmdparam);
			
			var curDataGrid:CrmEapDataGrid=cmdparam.context.triggerCrmEapControl as CrmEapDataGrid;
			if (curDataGrid.ctableName == "sc_orders2")
			{
				var crmeap:CrmEapRadianVbox = cmdparam.context["crmeap"] as CrmEapRadianVbox;
				//当前单据数据
				var itemdata:Object=crmeap.getValue();
				//成交金额
				var fsum:Number=0;
				//收款计划数据集
				var sc_orders2:ArrayCollection=itemdata.sc_orders2;
				//已分配计划金额
				var fplansum:Number=0;
				for (var i:int = 0; i < sc_orders2.length-1; i++) 
				{
					var rowdata:Object=sc_orders2.getItemAt(i);
					fplansum=fplansum+Number(rowdata.ffee==null?0:rowdata.ffee);
				}
				
				if (itemdata.fsum==null)
					itemdata.fsum=0;
				
				fsum=itemdata.fsum;
				var lastindex:int=sc_orders2.length;
                if(lastindex>0){
                    var rowdata2:Object=sc_orders2.getItemAt(lastindex-1);
                    rowdata2.ffee=fsum-fplansum;
                    if (rowdata2.ffee<0)
                    {
                        sc_orders2.removeItemAt(lastindex-1);
                        CRMtool.showAlert("增行失败！原因：成交金额已分配完毕。");
                    }
                }
			}
			
			
		}
		
	   //租赁合同
		public function onExcute_IFun462(cmdparam:CommandParam):void
		{
			checkHasIcustomer(cmdparam);
			this.onRestrainCheck(cmdparam);
			
			var curDataGrid:CrmEapDataGrid=cmdparam.context.triggerCrmEapControl as CrmEapDataGrid;
			if (curDataGrid.ctableName == "sc_orders2")
			{
				var crmeap:CrmEapRadianVbox = cmdparam.context["crmeap"] as CrmEapRadianVbox;
				//当前单据数据
				var itemdata:Object=crmeap.getValue();
				//成交金额
				var fsum:Number=0;
				//收款计划数据集
				var sc_orders2:ArrayCollection=itemdata.sc_orders2;
				//已分配计划金额
				var fplansum:Number=0;
				for (var i:int = 0; i < sc_orders2.length-1; i++) 
				{
					var rowdata:Object=sc_orders2.getItemAt(i);
					fplansum=fplansum+Number(rowdata.ffee==null?0:rowdata.ffee);
				}
				
				if (itemdata.fsum==null)
					itemdata.fsum=0;
				
				fsum=itemdata.fsum;
				var lastindex:int=sc_orders2.length;
				if(lastindex>0){
					var rowdata2:Object=sc_orders2.getItemAt(lastindex-1);
					rowdata2.ffee=fsum-fplansum;
					if (rowdata2.ffee<0)
					{
						sc_orders2.removeItemAt(lastindex-1);
						CRMtool.showAlert("增行失败！原因：成交金额已分配完毕。");
					}
				}
			}
		}
		
		
		//培训合同
		public function onExcute_IFun160(cmdparam:CommandParam):void
		{
			this.onRestrainCheck(cmdparam);
			
		}
		//其他合同
		public function onExcute_IFun329(cmdparam:CommandParam):void
		{
			this.onRestrainCheck(cmdparam);
			
		}
		/**
		 * 方法功能：具有相同约束检查的公共执行方法 
		 * 新行收入计划金额=成交金额－收入计划金额合计
		 * 若差值为0则给出友好提示“增行失败！原因：成交金额已分配完毕。”
		 * 编写作者：YJ
		 * 创建日期：2012-4-10
		 * 修改人：王炫皓
		 * 修改时间:20121207
		 */
		private function onRestrainCheck(cmdparam:CommandParam):void
		{
			var curDataGrid:CrmEapDataGrid=cmdparam.context.triggerCrmEapControl as CrmEapDataGrid;
			if (curDataGrid.ctableName == "sc_orderrpplan")
			{
				var crmeap:CrmEapRadianVbox = cmdparam.context["crmeap"] as CrmEapRadianVbox;
		
				//当前单据数据
				var itemdata:Object=crmeap.getValue();
				 var list:ArrayCollection = itemdata.sc_orderrpplan as ArrayCollection;
				 for(var i:int = 0; i<list.length; i++){
					 var obj:Object = list[i];
					 if(obj.dplan == "" || obj.dplan == null ){
						 if(itemdata.ddate != ""){
						 	obj.dplan = itemdata.ddate;
						 }else{
							 obj.dplan = new Date();
						 }
					 }
				 }
				
				//成交金额
				var fsum:Number=0;
				//收款计划数据集
				var sc_orderrpplan:ArrayCollection=itemdata.sc_orderrpplan;
				//已分配计划金额
				var fplansum:Number=0;
				for (var i:int = 0; i < sc_orderrpplan.length-1; i++) 
				{
					var rowdata:Object=sc_orderrpplan.getItemAt(i);
					fplansum=fplansum+Number(rowdata.fmoney==null?0:rowdata.fmoney);
				}
				
				if (itemdata.fsum==null)
					itemdata.fsum=0;
				
				fsum=itemdata.fsum;
				var lastindex:int=sc_orderrpplan.length;
				var rowdata2:Object=sc_orderrpplan.getItemAt(lastindex-1);
				rowdata2.fmoney=fsum-fplansum;
				rowdata2.cname="第"+lastindex+"期";
				if (rowdata2.fmoney<=0)
				{
					sc_orderrpplan.removeItemAt(lastindex-1);
					CRMtool.showAlert("增行失败！原因：成交金额已分配完毕。");
				}
				
			}
			
		}
		
		/**
		 * 功能：初始化业绩分摊中的分配人、分配时间
		 * 编写者：XZQWJ
		 * 
		 * */
		public function onExcute_IFun319(cmdparam:CommandParam):void{
			
			var curDataGrid:CrmEapDataGrid = cmdparam.context["crmeap"].gridList[0] as CrmEapDataGrid;
			var itemdata:Object = cmdparam.context["crmeap"].getValue();
			var sc_orderapportion:ArrayCollection=itemdata.sc_orderapportion;
			var fr:DateFormatter=new DateFormatter();
			fr.formatString="YYYY-MM-DD";

            var fpercent:Number = 0;
            for each (var o:Object in sc_orderapportion) {
                if(CRMtool.isStringNotNull(o.fpercent))
                    fpercent+= Number(o.fpercent);
            }

            fpercent = 1-fpercent;

			sc_orderapportion[sc_orderapportion.length-1].imaker=CRMmodel.userId;//当前登录人iid
			sc_orderapportion[sc_orderapportion.length-1].imaker_Name=CRMmodel.hrperson.cname;//当前登录人姓名
			sc_orderapportion[sc_orderapportion.length-1].dmaker=fr.format(new Date());//当前日期
			sc_orderapportion[sc_orderapportion.length-1].dmaker_Name=fr.format(new Date());//当前日期

            if(fpercent>0){
                var formater:NumberFormatter = new NumberFormatter();
                formater.precision = 2;
                formater.rounding = NumberBaseRoundType.UP;
                formater.decimalSeparatorFrom = ".";
                formater.decimalSeparatorTo = ".";
                formater.useThousandsSeparator = true;
                sc_orderapportion[sc_orderapportion.length-1].fpercent = formater.format(fpercent);
            }

			itemdata.sc_orderapportion=sc_orderapportion;
			itemdata.mainValue=itemdata;
			cmdparam.context["crmeap"].setValue(itemdata,1,1);
			
		}

        private function checkHasIcustomer(cmdparam:CommandParam):void{
            var crmeap:CrmEapRadianVbox = (cmdparam.context as FrameCore).crmeap;
            var ordersbomDG:CrmEapDataGrid=cmdparam.context.triggerCrmEapControl as CrmEapDataGrid;
            if (ordersbomDG.ctableName == "sc_orders2"&&CRMtool.isStringNull(crmeap.getValue().icustomer))
            {
                var sc_orders2:ArrayCollection = crmeap.getValue().sc_orders2;
                CRMtool.showAlert("请选择相关客户后再执行此操作。");
                if(sc_orders2.length>0)
                    sc_orders2.removeItemAt(sc_orders2.length-1);
                return;
            }
        }
		
			
	}
}