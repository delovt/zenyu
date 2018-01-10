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
	import mx.events.FlexEvent;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	
	import yssoft.comps.frame.module.CrmEapDataGrid;
	import yssoft.comps.frame.module.CrmEapRadianVbox;
	import yssoft.comps.frame.module.CrmEapTextInput;
	import yssoft.frameui.FrameCore;
	import yssoft.frameui.formopt.SaveBeforeCommand;
	import yssoft.scripts.selfoptimp.SaveBeforeCommandSelfImp;
	import yssoft.tools.AccessUtil;
	import yssoft.tools.CRMtool;
	import yssoft.vos.CommandParam;

	public class InitAfterCommandSelfImp
	{
		public function InitAfterCommandSelfImp()
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
		 * 方法功能：服务申请单
		 * 编写作者：ZJ
		 * 创建日期：2012.6.27
		 * 
		 */
		public function onExcute_IFun194(cmdparam:CommandParam):void
		{
			try
			{
				var crmeap:CrmEapRadianVbox = cmdparam.context["crmeap"] as CrmEapRadianVbox;
				var value:Object = crmeap.getValue() as Object;
				
				if(cmdparam!=null&&cmdparam.context.hasOwnProperty("winParam")
					&&cmdparam.context["winParam"].hasOwnProperty("formTriggerType")
					&&cmdparam.context["winParam"]["formTriggerType"]=="fromOther"){
					
					var obj:Object = new Object();
					var mainValue:Object = crmeap.getValue();
					var srbillObj:Object = cmdparam.context["winParam"]["hotlineParam"];
					
					var objInfo:Object=ObjectUtil.getClassInfo(srbillObj);
					var fieldName:Array=objInfo["properties"] as Array;  
					for each (var q:QName in fieldName)  
					{  
						mainValue[q.localName]=srbillObj[q.localName]; 
					}
					
					obj.mainValue = mainValue;
					crmeap.setValue(obj,1,1);
				}
				cmdparam.excuteNextCommand=true;
			}
			catch(e:Error)
			{
				cmdparam.excuteNextCommand=false;
				CRMtool.showAlert("服务申请单数据填充失败。原因："+e.message);
			}					
		}
		
		
		/**
		 * 方法功能：服务申请单
		 * 编写作者：ZJ
		 * 创建日期：2012.6.27
		 * 
		 */
		public function onExcute_IFun149(cmdparam:CommandParam):void
		{
			try
			{
				var crmeap:CrmEapRadianVbox = cmdparam.context["crmeap"] as CrmEapRadianVbox;
				var value:Object = crmeap.getValue() as Object;
				
				if(cmdparam!=null&&cmdparam.context.hasOwnProperty("winParam")
					&&cmdparam.context["winParam"].hasOwnProperty("formTriggerType")
					&&cmdparam.context["winParam"]["formTriggerType"]=="fromOther"){
					
					var obj:Object = new Object();
					var mainValue:Object = crmeap.getValue();
					var srbillObj:Object = cmdparam.context["winParam"]["hotlineParam"];
					
					var objInfo:Object=ObjectUtil.getClassInfo(srbillObj);
					var fieldName:Array=objInfo["properties"] as Array;  
					for each (var q:QName in fieldName)  
					{  
						mainValue[q.localName]=srbillObj[q.localName]; 
					}
					
					obj.mainValue = mainValue;
					crmeap.setValue(obj,1,1);
				}
				cmdparam.excuteNextCommand=true;
			}
			catch(e:Error)
			{
				cmdparam.excuteNextCommand=false;
				CRMtool.showAlert("服务申请单数据填充失败。原因："+e.message);
			}					
		}
		
		
		/**
		 * 方法功能：服务申请单
		 * 编写作者：ZJ
		 * 创建日期：2012.6.27
		 * 
		 */
		public function onExcute_IFun206(cmdparam:CommandParam):void
		{
			try
			{
				var crmeap:CrmEapRadianVbox = cmdparam.context["crmeap"] as CrmEapRadianVbox;
				var value:Object = crmeap.getValue() as Object;
				
				if(cmdparam!=null&&cmdparam.context.hasOwnProperty("winParam")
					&&cmdparam.context["winParam"].hasOwnProperty("formTriggerType")
					&&cmdparam.context["winParam"]["formTriggerType"]=="fromOther"){
					
					var obj:Object = new Object();
					var mainValue:Object = crmeap.getValue();
					var srbillObj:Object = cmdparam.context["winParam"]["hotlineParam"];
					
					var objInfo:Object=ObjectUtil.getClassInfo(srbillObj);
					var fieldName:Array=objInfo["properties"] as Array;  
					for each (var q:QName in fieldName)  
					{  
						mainValue[q.localName]=srbillObj[q.localName]; 
					}
					
					obj.mainValue = mainValue;
					crmeap.setValue(obj,1,1);
				}
				cmdparam.excuteNextCommand=true;
			}
			catch(e:Error)
			{
				cmdparam.excuteNextCommand=false;
				CRMtool.showAlert("服务申请单数据填充失败。原因："+e.message);
			}					
		}
		
		//拉式生单或参照代入数据，需要参与计算公式计算，但是不会自动触发，需要参照以下写法，手动计算并赋值。
		//重点 removeEventListener 如果使用，则代码只会触发一次，如果不使用removeEventListener ，请一定记得 调用 setValue 的条件，否则会死锁。
		public function onExcute_IFun165(cmdparam:CommandParam):void
		{
			var crmeap:CrmEapRadianVbox = cmdparam.context["crmeap"] as CrmEapRadianVbox;
			var ssdg:CrmEapDataGrid = null;
			for each(var dg:CrmEapDataGrid in crmeap.gridList){
				if(dg.ctableName=="sc_spinvoices")
					ssdg = dg;
			}
			if(ssdg){
				ssdg.addEventListener(FlexEvent.VALUE_COMMIT,dgChange);
			}
			
			function dgChange(event:FlexEvent):void{
				var ac:ArrayCollection  = ssdg.dataProvider as ArrayCollection;
				if(ac&&ac.length>0){
					//ssdg.removeEventListener(FlexEvent.VALUE_COMMIT,dgChange);
					var fsum:Number = 0;
					for each(var item:Object in ac){
						if(item.ftaxsum==null){
							item.ftaxsum=0;
						}else{
							item.ftaxsum = Number(item.ftaxsum);
						}					
						fsum+=(item.ftaxsum as Number);
					}
					var obj:Object = crmeap.getValue();
					if(obj.fsum != fsum){
						obj.fsum = fsum;
						obj.mainValue = obj;
						crmeap.setValue(obj,1,1);
					}
	
				}
			}
		}
	
		/**
		 * 产品出库，求和
		 * 作者:王炫皓
		 * 创建时间：2012-10-29
		 * */
		public function onExcute_IFun228(cmdparam:CommandParam):void
		{	
			var crmeap:CrmEapRadianVbox = cmdparam.context["crmeap"] as CrmEapRadianVbox;
			var ssdg:CrmEapDataGrid = null;
			for each(var dg:CrmEapDataGrid in crmeap.gridList){
				if(dg.ctableName=="sc_rdrecords")
					ssdg = dg;
			}
			if(ssdg){
				ssdg.addEventListener(FlexEvent.VALUE_COMMIT,dgChange);
			}
			
			function dgChange(event:FlexEvent):void{
				var ac:ArrayCollection  = ssdg.dataProvider as ArrayCollection;
				if(ac&&ac.length>0){
					//ssdg.removeEventListener(FlexEvent.VALUE_COMMIT,dgChange);
					var fsum:Number = 0;
					for each(var item:Object in ac){
						
						if(item.fsum==null){
							item.fsum=0;
						}else{
							item.fsum = Number(item.fsum);
						}					
						fsum+=(item.fsum as Number);
					}
					var obj:Object = crmeap.getValue();
					if(obj.fsum != fsum){
						obj.fsum = fsum;
						obj.mainValue = obj;
						crmeap.setValue(obj,1,1);
					}
				}
			}
		}

		/**
		 * 非产品出库，求和
		 * 作者：王炫皓
		 * 创建时间:2012-10-29
		 * */
		public function onExcute_IFun167(cmdparam:CommandParam):void
		{
			var crmeap:CrmEapRadianVbox = cmdparam.context["crmeap"] as CrmEapRadianVbox;
			var ssdg:CrmEapDataGrid = null;
			for each(var dg:CrmEapDataGrid in crmeap.gridList){
				if(dg.ctableName=="sc_rdrecords")
					ssdg = dg;
			}
			if(ssdg){
				ssdg.addEventListener(FlexEvent.VALUE_COMMIT,dgChange);
			}
			function dgChange(event:FlexEvent):void{
				var ac:ArrayCollection  = ssdg.dataProvider as ArrayCollection;
				if(ac&&ac.length>0){
					var fsum:Number = 0;
					for each(var item:Object in ac){
						
						if(item.fsum==null){
							item.fsum=0;
						}else{
							item.fsum = Number(item.fsum);
						}					
						fsum+=(item.fsum as Number);
					}
					var obj:Object = crmeap.getValue();
					if(obj.fsum != fsum){
						obj.fsum = fsum;
						obj.mainValue = obj;
						crmeap.setValue(obj,1,1);
					}
				}
			}
		}
		//公司目标
		public function onExcute_IFun315(cmdparam:CommandParam):void{
			writeBackGoal(cmdparam);
		}
		//部门目标
		public function onExcute_IFun313(cmdparam:CommandParam):void{
			writeBackGoal(cmdparam);
		}
		//人员目标
		public function onExcute_IFun317(cmdparam:CommandParam):void{
			writeBackGoal(cmdparam);
		}
       /* public function onExcute_IFun216(cmdparam:CommandParam):void{
            var fc:FrameCore = cmdparam.context as FrameCore;
            var crmeap:Object = fc.crmeap as CrmEapRadianVbox;
            var value:Object = crmeap.getValue() as Object;
            var iproduct_old = value.iproduct;
            var ac:ArrayCollection=new ArrayCollection();
            var asc:ArrayCollection=value.cs_custproducts;
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

        }*/
		/**
		 * ，通过目标方案回写值
		 * 作者：SZC 
		 * 创建时间:2015-2-3
		 * */
		public function writeBackGoal(cmdparam:CommandParam):void {
			var fc:FrameCore = cmdparam.context as FrameCore;
			var crmeap:Object = fc.crmeap as CrmEapRadianVbox;
			var ac:ArrayCollection=new ArrayCollection();
			for each (var CRMac:Object in crmeap.crmAllInputList ){
				if(CRMac.className=="CrmEapTextInput"){
					ac.addItem(CRMac);
				}
			}
			for each(var input:CrmEapTextInput in ac) {
				if (input.crmName == "ui_bm_bgrecord_igoalprogram") {
					//var date:DateField = input.crmDateFai;
					input.addEventListener("valueChange", function (event:Event):void {
						var igoalprogram:CrmEapTextInput = event.currentTarget as CrmEapTextInput;
						var deSql:String="delete bm_bgrecords where ibgrecord="+crmeap.getValue().iid;
						AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null,deSql);
						var obj:Object = new Object();
						obj.igoalprogram = crmeap.getValue().igoalprogram;
						if (obj.igoalprogram != null || obj.igoalprogram != "") {
							var sql:String="select imonth,irate from sr_goalprograms where igoalprogram="+crmeap.getValue().igoalprogram;
							AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
								var datagridlist:ArrayCollection = event.result as ArrayCollection;
								var fvalue1:Number=crmeap.getValue().fvalue1;
								var fvalue2:Number=crmeap.getValue().fvalue2;
								var resAc:ArrayCollection=new ArrayCollection();
								for each(var item:Object in datagridlist) {
									item.imonth = parseInt(item.imonth);
									item.fvalue1 =fvalue1*item.irate/100 ;
									item.fvalue2 =fvalue2*item.irate/100 ;
									resAc.addItem(item);
								}
								var object:Object = new Object;
								var eap:Object = crmeap.getValue();
								eap.mainValue = eap;
								eap.bm_bgrecords = resAc;
								crmeap.setValue(eap, 1, 1);
							}, sql);
						}
					});
				}
			}
			cmdparam.excuteNextCommand=true;
		}
		
		
		/**
		 * 新建服务回访   计算综合评分
		 * 作者：王炫皓
		 * 创建时:2012-10-31
		 * */
		/*public function onExcute_IFun154(cmdparam:CommandParam):void{
			var allScores:CrmEapTextInput = null;
			var crmeap:CrmEapRadianVbox = cmdparam.context["crmeap"] as CrmEapRadianVbox;
			var ssdg:CrmEapDataGrid = null;
			for each(var dg:CrmEapDataGrid in crmeap.gridList){
				if(dg.ctableName=="sr_feedbacks")
					ssdg = dg;
			}
			for each(var ti:CrmEapTextInput in crmeap.textInputList){
				if(ti.crmName=="UI_SR_FEEDBACK_FSCORE"){
					allScores=ti;
				}
			}
			
			if(ssdg){
				ssdg.addEventListener(FlexEvent.VALUE_COMMIT,dgChange);
			}
			
			function dgChange(event:FlexEvent):void{
				var ac:ArrayCollection  = ssdg.dataProvider as ArrayCollection;
				if(ac&&ac.length>0){
					var fscore:Number = 0;
					for each(var item:Object in ac){
						
						if(item.fscore==null){
							item.fscore=0;
						}else{
							
							
							item.fscore = Number(item.fscore);
						}					
						fscore+=(item.fscore as Number);
					}
					allScores.text = fscore.toString();
				}
			}
		}*/
		/**
		*产品购入求合
		*创建人:王炫皓
		* 创建时间：20130107
		*点击增行按钮会出现死循环
		*/
/*		public function onExcute_IFun231(cmdparam:CommandParam):void
		{
			var crmeap:CrmEapRadianVbox = cmdparam.context["crmeap"] as CrmEapRadianVbox;
			var ssdg:CrmEapDataGrid = null;
			for each(var dg:CrmEapDataGrid in crmeap.gridList){
				if(dg.ctableName=="sc_rdrecords")
					ssdg = dg;
			}
			if(ssdg){
				ssdg.addEventListener(FlexEvent.VALUE_COMMIT,dgChange);
			}
			
			function dgChange(event:FlexEvent):void{
				var ac:ArrayCollection  = ssdg.dataProvider as ArrayCollection;
				if(ac&&ac.length>0){
					var fsum:Number = 0;
					for each(var item:Object in ac){
						
						if(item.fsum==null){
							item.fsum=0;
						}else{
							item.fsum = Number(item.fsum);
						}					
						fsum+=(item.fsum as Number);
					}
					var obj:Object = crmeap.getValue();
					if(obj.fsum != fsum){
						obj.fsum = fsum;
						obj.mainValue = obj;
						crmeap.setValue(obj,1,1);
					}
				}
			}
		}*/
	}


/**
 * 获取产品服务状态
 * 作者：唐波
 * 创建时间:2015-3-10
 * */
/*public function getServiceState(cmdparam:CommandParam):void {
    var fc:FrameCore = cmdparam.context as FrameCore;
    var crmeap:Object = fc.crmeap as CrmEapRadianVbox;
    var ac:ArrayCollection=new ArrayCollection();
    for each (var CRMac:Object in crmeap.crmAllInputList ){
        if(CRMac.className=="CrmEapTextInput"){
            ac.addItem(CRMac);
        }
    }
    for each(var input:CrmEapTextInput in ac) {
        if (input.crmName == "UI_sr_request_icustproduct") {
            //var date:DateField = input.crmDateFai;
            input.addEventListener("valueChange", function (event:Event):void {
                var icustproduct:CrmEapTextInput = event.currentTarget as CrmEapTextInput;
                var obj:Object = new Object();
                obj.igoalprogram = crmeap.getValue().igoalprogram;
                if (obj.igoalprogram != null || obj.igoalprogram != "") {
                    var sql:String="select imonth,irate from sr_goalprograms where igoalprogram="+crmeap.getValue().igoalprogram;
                    AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
                        var datagridlist:ArrayCollection = event.result as ArrayCollection;
                        var fvalue1:Number=crmeap.getValue().fvalue1;
                        var fvalue2:Number=crmeap.getValue().fvalue2;
                        var resAc:ArrayCollection=new ArrayCollection();
                        for each(var item:Object in datagridlist) {
                            item.imonth = parseInt(item.imonth);
                            item.fvalue1 =fvalue1*item.irate/100 ;
                            item.fvalue2 =fvalue2*item.irate/100 ;
                            resAc.addItem(item);
                        }
                        var object:Object = new Object;
                        var eap:Object = crmeap.getValue();
                        eap.mainValue = eap;
                        eap.bm_bgrecords = resAc;
                        crmeap.setValue(eap, 1, 1);
                    }, sql);
                }
            });
        }
    }
    cmdparam.excuteNextCommand=true;
}*/
}