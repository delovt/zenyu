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
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.rpc.events.ResultEvent;
	
	import yssoft.comps.frame.module.CrmEapRadianVbox;
	import yssoft.comps.frame.module.CrmEapTextInput;
	import yssoft.frameui.FrameCore;
	import yssoft.tools.AccessUtil;
	import yssoft.tools.CRMtool;
	import yssoft.vos.CommandParam;

	public class EditBeforeCommandSelfImp
	{
		public function EditBeforeCommandSelfImp()
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
		 * 方法功能：服务派工单修改之前,分析是否已经回访
		 * 编写作者：刘睿
		 * 创建日期：2012-04-23
		 * 更新日期：0614
		 */
		public function onExcute_IFun150(cmdparam:CommandParam):void
		{
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var value:Object = crmeap.getValue() as Object;
			
			if(crmeap.publicFlagObject["checkAlreadyhave"+value.iifuncregedit+":"+value.iid]){
				(crmeap.paramForm as FrameCore).curButtonStatus="onGiveUp";
				CRMtool.tipAlert("当前单据已经被服务回访单引用，不允许修改!");
				cmdparam.excuteNextCommand = false;
				return;
			}					
			if(Number(value.istatus)> 1){
				(crmeap.paramForm as FrameCore).curButtonStatus="onGiveUp";
				CRMtool.tipAlert("当前单据已经填单，不允许修改!");
				cmdparam.excuteNextCommand = false;
				return;
			}		
			
			cmdparam.excuteNextCommand=true;
		}
		
		/**
		 * 方法功能: 回款单核销
		 * 编写作者：lr
		 */
		public function onExcute_IFun163(cmdparam:CommandParam):void
		{
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var sc_ctrpclose:ArrayCollection=cmdparam.context.vouchFormValue.sc_ctrpclose as ArrayCollection;
			if(crmeap.getValue().istatus==2 || crmeap.getValue().istatus==4 || crmeap.getValue().istatus==5){
				CRMtool.tipAlert("单据已审核，或者已经存在核销记录,不允许修改!");
				(crmeap.paramForm as FrameCore).curButtonStatus="onGiveUp";
				cmdparam.excuteNextCommand = false;	
				return;
			}
			if(sc_ctrpclose&&sc_ctrpclose.length>0){
				
				CRMtool.tipAlert("存在已核销记录,不允许修改!");
				(crmeap.paramForm as FrameCore).curButtonStatus="onGiveUp";
				cmdparam.excuteNextCommand = false;				
				return;
			}else{
				cmdparam.excuteNextCommand=true;
			}
			/*var obj:Object = (cmdparam.context as CrmEapRadianVbox).getValue();		
			if(obj.fclosemoney&&Number(obj.fclosemoney)!==0){
				
				CRMtool.tipAlert("存在已核销记录,不允许修改!");
				(crmeap.paramForm as FrameCore).curButtonStatus="onGiveUp";
				cmdparam.excuteNextCommand = false;
			}else{
				cmdparam.excuteNextCommand=true;
			}*/
			
		}
		
		/**
		 * 方法功能: 产品出库单 编辑前 校验是否生单。如果已生单，不允许修改。
		 * 编写作者：lr
		 */
		public function onExcute_IFun228(cmdparam:CommandParam):void
		{
			
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var value:Object = crmeap.getValue() as Object;
			
			if(crmeap.publicFlagObject["checkAlreadyhave"+value.iifuncregedit+":"+value.iid]){
				CRMtool.showAlert("当前单据已生单,不允许修改!");
				cmdparam.excuteNextCommand=false;
				(crmeap.paramForm as FrameCore).curButtonStatus="onGiveUp";
				//this.curButtonStatus
			}else{
				cmdparam.excuteNextCommand=true;
			}
			
		}
		
		/**
		 * 客商资产中产品产品修改，清除客商资产子表
		 * 编写作者：SZC
		 */
		public function onExcute_IFun216(cmdparam:CommandParam):void{
			//var fc:FrameCore = cmdparam.context as FrameCore;
			//var crmeap:Object = fc.crmeap as CrmEapRadianVbox;
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var value:Object = crmeap.getValue() as Object;
			var iproduct_old = value.iproduct;
			var ac:ArrayCollection=new ArrayCollection();
			var asc:ArrayCollection=value.cs_custproducts;
			if(crmeap.curButtonStatus == "onEdit"){
			for each (var CRMac:Object in crmeap.crmAllInputList ){
				if(CRMac.className=="CrmEapTextInput"){
					ac.addItem(CRMac);
				}
			}
			
			for each(var input:CrmEapTextInput in ac) {
				if (input.crmName == "UI_CS_custproduct_iproduct") {
					input.addEventListener("valueChange", function (event:Event):void {
						var iproduct=crmeap.getValue().iproduct;
						if(iproduct!=null && iproduct!="" && iproduct!=iproduct_old){
							asc.removeAll();
							var sql:String="select 1 as a";
							AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
								value.mainValue = value;
								value.iproduct=iproduct;
								crmeap.setValue(value, 1, 1);
							}, sql);
						}
					});
				}
			}
			}
		}
	
		
		//新购
		public function onExcute_IFun162(cmdparam:CommandParam):void
		{
			this.checkAllow(cmdparam);
			setOrderapportionValue(cmdparam);
		}
		
		//升级
		public function onExcute_IFun161(cmdparam:CommandParam):void
		{
			this.checkAllow(cmdparam);
			setOrderapportionValue(cmdparam);
		}
		
		//耗材
		public function onExcute_IFun157(cmdparam:CommandParam):void
		{
			this.checkAllow(cmdparam);
			setOrderapportionValue(cmdparam);
		}
		
		//服务
		public function onExcute_IFun159(cmdparam:CommandParam):void
		{
			this.checkAllow(cmdparam);
			setOrderapportionValue(cmdparam);
		}
		
		//租赁
		public function onExcute_IFun462(cmdparam:CommandParam):void
		{
			this.checkAllow(cmdparam);
			setOrderapportionValue(cmdparam);
		}
		
		//培训
		public function onExcute_IFun160(cmdparam:CommandParam):void
		{
			this.checkAllow(cmdparam);
			setOrderapportionValue(cmdparam);
		}
		
		//开发
		public function onExcute_IFun210(cmdparam:CommandParam):void
		{
			this.checkAllow(cmdparam);
			setOrderapportionValue(cmdparam);
		}
		//实施合同
		public function onExcute_IFun459(cmdparam:CommandParam):void
		{
			this.checkAllow(cmdparam);
			setOrderapportionValue(cmdparam);
		}
		
		
		//lr  检查  已出库、已核销、已开票的合同 不允许修改
		private function checkAllow(cmdparam:CommandParam):void{
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var value:Object = crmeap.getValue() as Object;
			var sc_orders:ArrayCollection=value.sc_orders as ArrayCollection;
			var sc_orders_frd:Number = 0;//产品表出库数量
			var sc_orders_fsp:Number = 0 ;//产品表开票数量
			
			var frpsum:Number=Number(value.frpsum);//累计回款金额   一定可用
			var frdsum:Number=Number(value.frdsum);//累计出库金额   暂时不用
			var fspsum:Number=Number(value.fspsum);//累计开票金额   要求可用
			
			for each (var item:Object in sc_orders) 
			{
				sc_orders_frd=sc_orders_frd+Number(item.frdquantity);
				sc_orders_fsp=sc_orders_fsp+Number(item.fspquantity);
			}
			
			var str:String = "修改";
			if(frpsum&&frpsum>0){
				CRMtool.showAlert("本合同已产生回款核销记录，不允许"+str+"。");
				(crmeap.paramForm as FrameCore).curButtonStatus="onGiveUp";
				cmdparam.excuteNextCommand=false;
				return;
			}
			
			if((fspsum&&fspsum>0)||sc_orders_fsp>0){
				CRMtool.showAlert("本合同已产生开票记录，不允许"+str+"。");
				(crmeap.paramForm as FrameCore).curButtonStatus="onGiveUp";
				cmdparam.excuteNextCommand=false;
				return;
			}
			
			if((frdsum&&frdsum>0)||sc_orders_frd>0){
				CRMtool.showAlert("本合同已产生出库记录，不允许"+str+"。");
				(crmeap.paramForm as FrameCore).curButtonStatus="onGiveUp";
				cmdparam.excuteNextCommand=false;
				return;
			}
			cmdparam.excuteNextCommand=true;
			
		}
		
		public function onExcute_IFun149(cmdparam:CommandParam):void
		{
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var value:Object = crmeap.getValue() as Object;
			
			if(crmeap.publicFlagObject["checkAlreadyhave"+value.iifuncregedit+":"+value.iid]){
				CRMtool.showAlert("当前单据已生单,不允许修改!");
				(crmeap.paramForm as FrameCore).curButtonStatus="onGiveUp";
				cmdparam.excuteNextCommand=false;
			}else{
				cmdparam.excuteNextCommand=true;
			}
			
		}
		
	   
		
		//实施变更
		public function onExcute_IFun259(cmdparam:CommandParam):void
		{
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var myMainValue:Object =crmeap.getValue() as Object;
			if(myMainValue.istate==575){
				CRMtool.showAlert("已经提交变更，不允许修改。");
				(crmeap.paramForm as FrameCore).curButtonStatus="onGiveUp";
				cmdparam.excuteNextCommand=false;
				return;
			}
			cmdparam.excuteNextCommand=true;
		}
		
		/**
		 * 从新给业绩分摊赋值
		 * 创建人:王炫皓
		 * 创建时间:20130117
		 * */
		public function setOrderapportionValue(cmdparam:CommandParam):void{
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var myMainValue:Object =crmeap.getValue() as Object;
			var sql:String = "select*from sc_orderapportion where iorder = "+myMainValue.iid;
			AccessUtil.remoteCallJava("CommonalityDest","assemblyQuerySql",function(event:ResultEvent):void{	
				myMainValue["sc_orderapportion"] = event.result as Object;
			},sql);
		
		}
		
		
		/**
		 * 物料借用修改前判断归还数量是否大于0  >0 不能删除
		 * 创建人：王炫皓
		 * 创建时间：20130219
		 * */
		public function  onExcute_IFun348(cmdparam:CommandParam):void{
        var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
        var myMainValue:Object =crmeap.getValue() as Object;
        if( myMainValue.sc_rdrecords){
            for each (var rdrecord:Object in myMainValue.sc_rdrecords) {
                if(Number(rdrecord.fwoquantity) > 0){
                    (crmeap.paramForm as FrameCore).curButtonStatus="onGiveUp";
                    cmdparam.excuteNextCommand=false;
                    CRMtool.showAlert("已经产生归还不允许修改");
                    return;
                }
            }
        }
        cmdparam.excuteNextCommand=true;
    }
		
		
		/**
		 * 收费单不是完工状态不允许修改单据
		 * 创建人：李宁
		 * 创建时间：2014-04-01
		 */
		public function onExcute_IFun390(cmdparam:CommandParam):void{
			
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var myMainValue:Object =crmeap.getValue() as Object;
			
			if(myMainValue.istatus > 0) {
				(crmeap.paramForm as FrameCore).curButtonStatus="onGiveUp";
				cmdparam.excuteNextCommand=false;
				CRMtool.showAlert("非完工状态下的收费单不允许修改操作！");	
				return;
			} else {
				cmdparam.excuteNextCommand=true;
			}
		
		}
		/**
		 * 方法功能:
		 * 编写作者：SZC
		 */
		public function onExcute_IFun428(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var value:Object = crmeap.getValue() as Object;	
			if(value.istatus==2){
				CRMtool.tipAlert("当前单据已经出库，不允许修改!");
				cmdparam.excuteNextCommand = false;
				return;
			}
			cmdparam.excuteNextCommand = true;
			
		}
		
		/**
		 * 方法功能:调拨单生成其他入库不允许修改
		 * 编写作者：SZC
		 */
		public function onExcute_IFun174(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var value:Object = crmeap.getValue() as Object;	
			if(value.ifuncregedit==477){
				CRMtool.tipAlert("当前单据是调拨单生成，不允许修改!");
				cmdparam.excuteNextCommand = false;
				return;
			}
			cmdparam.excuteNextCommand = true;
			
		}
		/**
		 * 方法功能:调拨单生成其他出库不允许修改
		 * 编写作者：SZC
		 */
		public function onExcute_IFun175(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var value:Object = crmeap.getValue() as Object;	
			if(value.ifuncregedit==477){
				CRMtool.tipAlert("当前单据是调拨单生成，不允许修改!");
				cmdparam.excuteNextCommand = false;
				return;
			}
			cmdparam.excuteNextCommand = true;
			
		}
		/**
		 * 方法功能:调拨单审核状态不允许修改
		 * 编写作者：SZC
		 */
		public function onExcute_IFun477(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var value:Object = crmeap.getValue() as Object;	
		    var sql:String="select istatus from sc_transfer where iid="+value.iid;
			AccessUtil.remoteCallJava("CommonalityDest","assemblyQuerySql",function(event:ResultEvent):void{	
				var ac:ArrayCollection=event.result as ArrayCollection;
				if(ac.length==0){
				return;
				}
				if(ac[0].istatus==2){
					CRMtool.tipAlert("单据已审核，不允许修改!");
					cmdparam.excuteNextCommand = false;
					return;
				}else{
					cmdparam.excuteNextCommand = true;
				}
			},sql);
		}
        /**
         * 发票不是未使用或领用状态不允许修改单据
         * 创建人：杨政伟
         * 创建时间：2014-04-02
         */
        public function onExcute_IFun391(cmdparam:CommandParam):void{
            var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
            var myMainValue:Object =crmeap.getValue() as Object;

            if(myMainValue.istatus > 1) {
                (crmeap.paramForm as FrameCore).curButtonStatus="onGiveUp";
                cmdparam.excuteNextCommand=false;
                CRMtool.showAlert("发票非领用或未使用状态，不允许修改操作！");
                return;
            } else {
                cmdparam.excuteNextCommand=true;
            }

        }

        /*
        *crm——服务——回访管理—修改内容后培训申请显示问题
        *
         */
        /*public function onExcute_IFun196(cmdparam:CommandParam):void{
            var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
            var myMainValue:Object =crmeap.getValue() as Object;
            var trains:ArrayCollection = myMainValue.sr_trains as ArrayCollection;
            if (trains){
                var sql:String = "select b.iinvoices iinvoices from sr_train  a  left join SR_trains b on a.iid = b.itrains where a.iid = " + myMainValue.iid;
                AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
                    var list:ArrayCollection = event.result as ArrayCollection;
                    if (list && list.length > 0) {
                        for(var i=0; i<list.length;i++){
                            trains[i].iinvoices = list[i].iinvoices;
                        }
                        //myMainValue.sr_trains = trains;
                        //crmeap.setValue(myMainValue,1,1);
                    }
                }, sql);
            }
            cmdparam.excuteNextCommand = true;
        }*/
	}

}