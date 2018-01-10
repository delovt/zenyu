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
	import mx.utils.ObjectUtil;
	
	import yssoft.comps.frame.module.CrmEapRadianVbox;
	import yssoft.tools.AccessUtil;
	import yssoft.tools.CRMtool;
	import yssoft.vos.CommandParam;

	public class OpenAfterCommandSelfImp
	{
		public function OpenAfterCommandSelfImp()
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
		 * 方法功能：由呼叫中心初始化销售线索数据
		 * 编写作者：刘睿  
		 * 创建日期：2012.4.1
		 * 更新日期：
		 */
		public function onExcute_IFun62(cmdparam:CommandParam):void
		{
			try
			{
				if(cmdparam!=null&&cmdparam.context.hasOwnProperty("winParam")
					&&cmdparam.context["winParam"].hasOwnProperty("formTriggerType")
					&&cmdparam.context["winParam"]["formTriggerType"]=="fromOther"){
					
					var crmeap:CrmEapRadianVbox = cmdparam.context["crmeap"] as CrmEapRadianVbox;
					var obj:Object = new Object();
					var mainValue:Object = crmeap.getValue();
					var newobj:Object = cmdparam.context["winParam"]["custParam"];
					
					var objInfo:Object=ObjectUtil.getClassInfo(newobj);
					var fieldName:Array=objInfo["properties"] as Array;  
					for each (var q:QName in fieldName)  
					{  
						mainValue[q.localName]=newobj[q.localName]; 
					}
					
					obj.mainValue = mainValue;
					crmeap.setValue(obj,1,1);
				}
				cmdparam.excuteNextCommand=true;
			}
			catch(e:Error)
			{
				cmdparam.excuteNextCommand=false;
				CRMtool.showAlert("销售线索数据填充失败。原因："+e.message);
			}
		}
		
		/**
		 * 方法功能：由实施日志初始化实施变更数据
		 * 编写作者：刘睿  
		 * 创建日期：2012.6.8
		 * 更新日期：
		 */
		public function onExcute_IFun259(cmdparam:CommandParam):void
		{
			try
			{
				if(cmdparam!=null&&cmdparam.context.hasOwnProperty("winParam")
					&&cmdparam.context["winParam"].hasOwnProperty("formTriggerType")
					&&cmdparam.context["winParam"]["formTriggerType"]=="fromOther"){
					
					var crmeap:CrmEapRadianVbox = cmdparam.context["crmeap"] as CrmEapRadianVbox;
					var obj:Object = new Object();
					var mainValue:Object = crmeap.getValue();
					var newobj:Object = cmdparam.context["winParam"]["srproject"];
					
					var objInfo:Object=ObjectUtil.getClassInfo(newobj);
					var fieldName:Array=objInfo["properties"] as Array;  
					for each (var q:QName in fieldName)  
					{  
						mainValue[q.localName]=newobj[q.localName]; 
					}
					
					obj.mainValue = mainValue;
					crmeap.setValue(obj,1,1);
				}
				cmdparam.excuteNextCommand=true;
			}
			catch(e:Error)
			{
				cmdparam.excuteNextCommand=false;
				CRMtool.showAlert("实施变更单数据填充失败。原因："+e.message);
			}
		}
		
		/**
		 * 方法功能：销售线索生成客户档案
		 * 编写作者：YJ  
		 * 创建日期：2012.04.25
		 * 更新日期：
		 */
/*		public function onExcute_IFun44(cmdparam:CommandParam):void
		{
			if(cmdparam!=null&&cmdparam.context.hasOwnProperty("winParam")
				&&cmdparam.context["winParam"].hasOwnProperty("formTriggerType")
				&&cmdparam.context["winParam"]["formTriggerType"]=="fromOther"){
				
				var injectObj:Object = cmdparam.context["winParam"]["injectObj"];
				if(!injectObj){
					var crmeap:CrmEapRadianVbox = cmdparam.context["crmeap"] as CrmEapRadianVbox;
					var obj:Object = new Object();
					var mainValue:Object = new Object();
					obj.mainValue = cmdparam.context["winParam"]["cscustomerObj"];
					obj.CS_custperson = cmdparam.context["winParam"]["custpersonArr"];
					crmeap.setValue(obj,1,1);
					
				}
			}
			
			cmdparam.excuteNextCommand=true;
		}*/
		/**
		 * 方法功能：服务申请单
		 * 编写作者：YJ  
		 * 创建日期：2012.4.20
		 * 更新日期：lr  2012.6.4
		 */
		public function onExcute_IFun149(cmdparam:CommandParam):void
		{
			try
			{
				var crmeap:CrmEapRadianVbox = cmdparam.context["crmeap"] as CrmEapRadianVbox;
				var value:Object = crmeap.getValue() as Object;
				
				if(value.iid&&value.iid!=0){///服务申请 编辑前 校验是否生单。如果已生单，像容器中添加一个变量。 
					
					AccessUtil.remoteCallJava("CallCenterDest","getSrbilloniinvoice",function(event:ResultEvent):void{
						var srbillAc:ArrayCollection = event.result as ArrayCollection;
						if(srbillAc.length>0){
							crmeap.publicFlagObject["checkAlreadyhave"+value.iifuncregedit+":"+value.iid] = true;
						}else{
							crmeap.publicFlagObject["checkAlreadyhave"+value.iifuncregedit+":"+value.iid] = false;
						}					
					},{ccfunid:value.iifuncregedit,ccid:value.iid});
				}else if(cmdparam!=null&&cmdparam.context.hasOwnProperty("winParam")
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
		 * 服务工单  lr
		 */
		public function onExcute_IFun150(cmdparam:CommandParam):void
		{
			try
			{
				var crmeap:CrmEapRadianVbox = cmdparam.context["crmeap"] as CrmEapRadianVbox;
				var value:Object = crmeap.getValue() as Object;
				
				if(value.iid&&value.iid!=0){///服务申请 编辑前 校验是否生单。如果已生单，像容器中添加一个变量。 
					
					AccessUtil.remoteCallJava("SrBillDest","getSRfeedbackoniinvoice",function(event:ResultEvent):void{
						var srbillAc:ArrayCollection = event.result as ArrayCollection;
						if(srbillAc.length>0){
							crmeap.publicFlagObject["checkAlreadyhave"+value.iifuncregedit+":"+value.iid] = true;
						}else{
							crmeap.publicFlagObject["checkAlreadyhave"+value.iifuncregedit+":"+value.iid] = false;
						}					
					},{ifuncregedit:value.iifuncregedit,iinvoice:value.iid});
				}else if(cmdparam!=null&&cmdparam.context.hasOwnProperty("winParam")
					&&cmdparam.context["winParam"].hasOwnProperty("formTriggerType")
					&&cmdparam.context["winParam"]["formTriggerType"]=="fromOther"){
					
					var obj:Object = new Object();
					var mainValue:Object = crmeap.getValue();
					var srbillObj:Object = cmdparam.context["winParam"]["srbillObj"];
					
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
				CRMtool.showAlert("失败。原因："+e.message);
			}
		}
		
		/**
		 * 方法功能：销售线索生成销售商机
		 * 编写作者：lr
		 * 创建日期：
		 * 更新日期：
		 */
		public function onExcute_IFun80(cmdparam:CommandParam):void
		{
			if(cmdparam!=null&&cmdparam.context.hasOwnProperty("winParam")
				&&cmdparam.context["winParam"].hasOwnProperty("formTriggerType")
				&&cmdparam.context["winParam"]["formTriggerType"]=="fromOther"){
				
				var crmeap:CrmEapRadianVbox = cmdparam.context["crmeap"] as CrmEapRadianVbox;
				var obj:Object = new Object();
				var mainValue:Object = crmeap.getValue();
				var srbillObj:Object = cmdparam.context["winParam"]["opportunityObj"];
				
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
		
		/**
		 * 方法功能: 产品出库单 编辑前 校验是否生单。如果已生单，像容器中添加一个变量。
		 * 编写作者：lr
		 */
		public function onExcute_IFun228(cmdparam:CommandParam):void
		{
			var crmeap:CrmEapRadianVbox = cmdparam.context["crmeap"] as CrmEapRadianVbox;
			var value:Object = crmeap.getValue() as Object;
		
			var sc_rdrecords:ArrayCollection = value.sc_rdrecords;
			var sc_rdrecordsbom:ArrayCollection = value.sc_rdrecordsbom;
			
			for each(var obj:Object in sc_rdrecords){
				obj.ifuncregedit = value.iifuncregedit;//当前单据功能内码
				obj.iinvoice = value.iid;
				var bomList:ArrayCollection;
				for each(var bomobj:Object in sc_rdrecordsbom){
					if(obj.iproduct==bomobj.iproductp){
						if(bomList==null){
							bomList=  new ArrayCollection();
							obj.bomList = bomList;
						}				
						bomList.addItem(bomobj);
					}				
				}
			}	
			
			var obj:Object = new Object();
			obj.ifuncregedit = value.iifuncregedit;//当前单据功能内码
			obj.iinvoice = value.iid;
			
			AccessUtil.remoteCallJava("customerDest","checkAlreadyhaveCsProductOrBom",function(event:ResultEvent):void{
				if(event.result){
					//CRMtool.showAlert("已生单");
					crmeap.publicFlagObject["checkAlreadyhave"+value.iifuncregedit+":"+value.iid] = true;
				}		
			},sc_rdrecords);
			
			cmdparam.excuteNextCommand=true;
		}
		
		/**
		 * 方法功能: 生成报销单。
		 * 编写作者：lr
		 */
/*		public function onExcute_IFun226(cmdparam:CommandParam):void
		{
			try
			{
				if(cmdparam!=null&&cmdparam.context.hasOwnProperty("winParam")
					&&cmdparam.context["winParam"].hasOwnProperty("formTriggerType")
					&&cmdparam.context["winParam"]["formTriggerType"]=="fromOther"){
					
					var crmeap:CrmEapRadianVbox = cmdparam.context["crmeap"] as CrmEapRadianVbox;
					var obj:Object = new Object();
					var mainValue:Object = crmeap.getValue();
					mainValue.fsum = cmdparam.context["winParam"]["fsum"];
					mainValue.inumber = cmdparam.context["winParam"]["inumber"];
					obj.mainValue = mainValue;
					obj.oa_expenses = cmdparam.context["winParam"]["OA_expenses"];
					crmeap.setValue(obj,1,1);
				}
				cmdparam.excuteNextCommand=true;
			}
			catch(e:Error)
			{
				cmdparam.excuteNextCommand=false;
				CRMtool.showAlert("报销单填充失败。原因："+e.message);
			}
		}*/
		
		/**
		 * 方法功能：服务回访 //服务派工单生成服务回访
		 * 编写作者：YJ  
		 * 创建日期：2012.04.05
		 * 更新日期：lr 修改
		 */
		public function onExcute_IFun154(cmdparam:CommandParam):void
		{
			if(cmdparam!=null&&cmdparam.context.hasOwnProperty("winParam")
				&&cmdparam.context["winParam"].hasOwnProperty("formTriggerType")
				&&cmdparam.context["winParam"]["formTriggerType"]=="fromOther"){
				
				var crmeap:CrmEapRadianVbox = cmdparam.context["crmeap"] as CrmEapRadianVbox;
				var obj:Object = new Object();
				var mainValue:Object = crmeap.getValue();
				var srbillObj:Object = cmdparam.context["winParam"]["srfeedbackObj"];
				
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
		
		/**
		 * 方法功能：服务申请单
		 * 编写作者：ZJ
		 * 创建日期：2012.6.27
		 * 
		 */
		public function onExcute_IFun200(cmdparam:CommandParam):void
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
	
	}
}