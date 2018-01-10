/**
 * 单据操作，自定义执行命令
 * 方法定义规则：public function onExcute_IFun功能内码(cmdparam:CommandParam):void
 * cmdparam参数属性：
 *  param:*;                          //传递的参数
 nextCommand:ICommand;              //要执行的下一个命令
 excuteNextCommand:Boolean=false;  //是否立即执行下一条命令
 context:Container=null;           //环境容器变量
 optType:String="";                //操作类型
 cmdselfName:String="";            //自定义命令名称
 */
package yssoft.scripts.selfoptimp {
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.DateField;
	import mx.formatters.DateFormatter;
	import mx.rpc.events.ResultEvent;
	import mx.utils.ObjectUtil;
	import mx.utils.StringUtil;
	
	import yssoft.business.SrBillHandleClass;
	import yssoft.comps.frame.module.CrmEapRadianVbox;
	import yssoft.comps.frame.module.CrmEapTextInput;
	import yssoft.frameui.FrameCore;
	import yssoft.models.CRMmodel;
	import yssoft.models.ConstsModel;
	import yssoft.tools.AccessUtil;
	import yssoft.tools.CRMtool;
	import yssoft.tools.ServiceTool;
	import yssoft.views.billMoreViews.sale.CheckSalesTitleWindow;
	import yssoft.vos.CommandParam;
	
	public class SaveAfterCommandSelfImp {
		public function SaveAfterCommandSelfImp() {
		}




		/**
		 * 方法功能：
		 * 编写作者：
		 * 创建日期：
		 * 更新日期：
		 */

		//销售线索
		public function onExcute_IFun62(cmdparam:CommandParam):void {
			//curButtonStatus	"onNew"
			var iid:int = cmdparam.param.value.iid;
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var myValue:Object = crmeap.getValue();
			if (iid != 0 && cmdparam.optType == "onNew") {
				var ifuncregedit:int = myValue.ifuncregedit;
				var mysql:String = "update sa_clue set istatus = 1 where iid = " + iid;
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
				}, mysql);
				if (ifuncregedit == 46 && myValue.iinvoice) {
					var sql:String = "update oa_workdiary set ifuncregedit=62,iinvoice=" + iid + " where iid=" + myValue.iinvoice;
					AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
					}, sql);
					
				}
			}
			
		}
	//20141208 WX 新增耗材出库后更新累计发货字段
	public function onExcute_IFun167(cmdparam:CommandParam):void {
		var iinvoice:Object = cmdparam.param.value.iinvoice;
		var sublist:ArrayCollection=cmdparam.param.value.sc_rdrecords;
		var i:int;
		var iproduct:Object;
		var iinvoice:Object;
		for(i=0;i<sublist.length;i++){
			iproduct=sublist[i].iproduct;
			var upSql:String ="update SC_orders set frdquantity=(select sum(fquantity) from SC_rdrecords where iinvoice="+iinvoice+" and iproduct="+iproduct+ ") where iorder="+iinvoice+" and iproduct="+iproduct;
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql",null, upSql);
		}
		//SZC Add 20141226 回写应收账款
		modifyFpayables(cmdparam);
		
	}
		/**
		 * 商机
		 *修改人:王炫皓
		 * 修改时间 :20121128
		 * */
		public function onExcute_IFun80(cmdparam:CommandParam):void {
			var iid:int = cmdparam.param.value.iid;
			var invoice:int = cmdparam.param.value.iinvoice;
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var myValue:Object = crmeap.getValue();
			//winParam.hasOwnProperty("injectObj") 说明此商机是推式生单的。
			if (iid != 0 && invoice != 0) {
				var sql:String = "select iid from sc_order where ifuncregedit=80 and  iinvoice=" + iid;
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
					var ac:ArrayCollection = event.result as ArrayCollection;
					var sqls:String;
					if (ac && ac.length > 0) {
						sqls = " update sa_clue set istatus =  3  where iid =  " + invoice;
					} else {
						sqls = " update sa_clue set istatus =  2  where iid =  " + invoice;
					}
					AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, sqls);
				}, sql);
				
				
			}
			if (iid != 0 && cmdparam.optType == "onNew" && (crmeap.paramForm as FrameCore).winParam.hasOwnProperty("injectObj")) {
				var lr_ifuncregedit:int = (crmeap.paramForm as FrameCore).winParam.injectObj.lr_ifuncregedit;
				var lr_iinvoice:int = (crmeap.paramForm as FrameCore).winParam.injectObj.lr_iinvoice;
				if (lr_ifuncregedit == 46 && lr_iinvoice) {
					var sql:String = "update oa_workdiary set ifuncregedit=80,iinvoice=" + iid + " where iid=" + lr_iinvoice;
					AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
						(crmeap.paramForm as FrameCore).winParam.injectObj.lr_ifuncregedit = 0;
					}, sql);
					
				}
			}
		}
		
		/**
		 * 方法功能：服务工单保存后更新对应的申请单状态
		 * 编写作者：YJ
		 * 创建日期：2012-04-06
		 * 更新日期：
		 */
		public function onExcute_IFun150(cmdparam:CommandParam):void {
			try {
				var iinvoice:int = cmdparam.param.value.iinvoice;
				var ifuncregedit:int = cmdparam.param.value.ifuncregedit;
				
				if (ifuncregedit == 149) {
					var sbhc:SrBillHandleClass = new SrBillHandleClass();
					sbhc.iinvoice = Number(cmdparam.param.value.iinvoice);
					sbhc.istatus = 1;
					sbhc.onUpdateSrRequestStatus();
				}
				if( ifuncregedit == 153 && cmdparam.param.value.iresult == 377 &&  cmdparam.param.value.isolution == 369){
					var sql:String = "update sr_bill set istatus = 1 where iid = "+ cmdparam.param.value.iid ;
					AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql",null, sql);
				}
				
				if (cmdparam.param.value.iid && cmdparam.param.value.istatus != 4 && cmdparam.param.value.iresult == 375) {
					var pparam:Object = new Object();
					pparam.iid = cmdparam.param.value.iid;
					pparam.iclose = CRMmodel.userId;
					pparam.dclose = CRMtool.getFormatDateString();
					pparam.istatus = 4;
					AccessUtil.remoteCallJava("SrBillDest", "updateDataForClose", function (e:ResultEvent):void {
						var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
						var obj:Object = crmeap.getValue();
						obj.iclose = CRMmodel.userId;
						obj.dclose = CRMtool.getFormatDateString();
						obj.istatus = 4;
						obj.mainValue = obj;
						
						crmeap.setValue(obj, 1, 1);
					}, pparam);
				}
				
				/*				if(ifuncregedit==150){
				var sql:String ="update sr_bill set istatus=4 where iid="+iinvoice;
				AccessUtil.remoteCallJava("CommonalityDest","assemblyQuerySql",function(event:ResultEvent):void{
				},sql);
				}*/
				
				
				cmdparam.excuteNextCommand = true;
			} catch (err:Error) {
				cmdparam.excuteNextCommand = false;//终止操作
				CRMtool.tipAlert("更新服务申请单状态失败! 原因:" + err.message);
			}
		}
		
		
		/**
		 * 方法功能：客户档案保存时插入联系人子表后，也应向ab_invoiceuser权限表中插入联系人对应的负责人记录
		 * 编写作者：刘磊
		 * 创建日期：2012-04-12
		 * 更新日期：2012-04-12
		 * 修改人：王炫皓
		 * 修改时间：20121127
		 */
		public function onExcute_IFun44(cmdparam:CommandParam):void {
			try {
				var param:Object = new Object();
				var icustomer = cmdparam.param.value.iid;
				param.icustomer = cmdparam.param.value.iid;
				param.iperson = CRMmodel.userId;
				param.idepartment = CRMmodel.hrperson.idepartment;
				AccessUtil.remoteCallJava("ab_invoiceuserViewDest", "pr_invoiceuser_custperson", function (event:ResultEvent):void {
					invoiceusercallBack(cmdparam, event)
				}, param, null, false);
				
				if (cmdparam.optType == "onNew") {
					var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
					var obj:Object = crmeap.getValue();
					
					var ifuncregedit:int = cmdparam.param.value.ifuncregedit;
					var imrcustomer:int = cmdparam.param.value.imrcustomer;
					if (obj.iid != null && obj.iinvoice != null) {
						//，ccustomer="+obj.cname+"  SZC ADD  回写线索中的客商名称
						var sqls:String = " update sa_clue set icustomer =  " + obj.iid + ",ccustomer='"+obj.cname+"'  where iid =  " + obj.iinvoice;
						AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
							
						}, sqls);
					}
					if (imrcustomer && imrcustomer != 0) {
						var sql:String = "update oa_workdiary set icustomer = " + icustomer + ",iifuncregedit=46 where imrcustomer = " + imrcustomer + " " +
							"update ab_invoiceuser set iinvoices = " + icustomer + ",iinvoice = " + icustomer + ",ifuncregedit=44 where ifuncregedit=176 and iinvoice = " + imrcustomer + " " +
							"update sa_clue set icustomer = " + icustomer + " where imrcustomer = " + imrcustomer + " " +
							"delete mr_customer where iid = " + imrcustomer;
						AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
							
						}, sql);
					}
				}
				
				cmdparam.excuteNextCommand = true;
			}
			catch (err:Error) {
				cmdparam.excuteNextCommand = false;//终止操作
				CRMtool.tipAlert("客商人员资料权限表插入失败! 原因:" + err.message);
			}
			
			function invoiceusercallBack(cmdparam:CommandParam, e:ResultEvent):void {
				if (e.result.toString() == "sucess") {
					var icustomer:String = cmdparam.param.value.iid;
					var sql:String = "update cs_custperson set ";
					
					if (cmdparam.optType == "onNew") {
						sql += "imaker=" + CRMmodel.userId + ",dmaker=getdate()";
					}
					else if (cmdparam.optType == "onEdit") {
						sql += "imodify=" + CRMmodel.userId + ",dmodify=getdate()";
					}
					sql += " where icustomer=" + icustomer;
					AccessUtil.remoteCallJava("CommonalityDest", "updateSql", function (event:ResultEvent):void {
						updateCustpersonBack(cmdparam, event)
					}, sql);
					/*cmdparam.excuteNextCommand = true;*/
				}
				else {
					cmdparam.excuteNextCommand = false;//终止操作
					CRMtool.tipAlert("客商人员资料权限表插入失败!");
				}
			}
		}
		
		private function updateCustpersonBack(cmdparam:CommandParam, event:ResultEvent):void {
			if (event.result.toString() == "sucess") {
				cmdparam.excuteNextCommand = true;
			}
			else {
				cmdparam.excuteNextCommand = false;//终止操作
				CRMtool.tipAlert("客商人员修改失败！");
			}
		}
		
		/**
		 * 方法功能：密码加密(职员档案)
		 * 编写作者：YJ
		 * 创建日期：2012-5-8
		 * 更新日期：
		 */
		public function onExcute_IFun13(cmdparam:CommandParam):void {
			//var params:Object = {};
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var obj:Object = crmeap.getValue();
			
			if (cmdparam.optType == "onNew") {
				var objparam:Object = {};
				
				objparam.iid = obj.iid;
				objparam.resetFlag = true;
				
				var param:Object = new Object();
				param.userId= obj.iid;
				param.cmobile1= obj.cmobile1;
				param.cname= obj.cname;
				param.cemail= obj.cemail;
				var ac:ArrayCollection=new ArrayCollection();
				ac.addItem(param);
				var params:Object = new Object();
				params.ac=ac;
				AccessUtil.remoteCallJava("hrPersonDest", "modityResetPwd", null, objparam);
				AccessUtil.remoteCallJava("LotCommunicate", "uploadPerson", function (event:ResultEvent):void {
					
				},params,"多方通话用户上传中....");
			}
			if(obj.blogin ==1){//判断是否能登陆手机
				//能登陆手机后将人员ID和obj.clogin拼装并加密
				var objparam:Object = {};
				var clogin:String="";
				clogin=obj.iid+""+1;
				objparam.clogin=clogin;
				AccessUtil.remoteCallJava("hrPersonDest", "insertClogin", function (event:ResultEvent):void {
				var ac:Object=event.result as Object;
					var cloginpwd:String=ac.pwd+"";
				   var upSql:String="update hr_person set clogin='"+cloginpwd+"' where iid="+obj.iid;
				   AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
					   
				   }, upSql);
				}, objparam);
			}else{
				var upSql1:String="update hr_person set clogin=null where iid="+obj.iid;
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
					
				}, upSql1);
			}
			
			cmdparam.excuteNextCommand = true;
			
		}
		
		//实施日志
		public function onExcute_IFun220(cmdparam:CommandParam):void {
			
			
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var obj:Object = crmeap.getValue();
			var objparam:Object = {};
			
			objparam.iproject = obj.iproject;
			objparam.resetFlag = true;
			
			AccessUtil.remoteCallJava("projectDest", "updateSrProjectFfact", function (evt:ResultEvent):void {
				
				//
				
			}, objparam);
			
			cmdparam.excuteNextCommand = true;
			
		}
		
		//新购合同保存时，更改客户的销售状态为系统选项的公共设置里的设置值
		public function onExcute_IFun162(cmdparam:CommandParam):void {
			var iid:int = cmdparam.param.value.iid;
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var myValue:Object = crmeap.getValue();
			var isalesstatus:int = -1;
			var fpayables:Number;//应收账款
			var sqlStr:String = "select cvalue from as_options where iid=91";
			if (myValue.iinvoice && myValue.iinvoice > 0) {
				writeBack(myValue.iinvoice);
			}
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
				var eventAC:ArrayCollection = event.result as ArrayCollection;
				if (eventAC.length > 0) {
					if (eventAC[0].cvalue != "" && eventAC[0].cvalue != null) {
						isalesstatus = eventAC[0].cvalue;
						
					}
					if (isalesstatus > -1) {
						var sql:String = "update CS_customer set isalesstatus= " + isalesstatus + " where iid=" + myValue.icustomer;
						AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
						}, sql);
					}
				}
			}, sqlStr);
		
			//SZC Add 20141226 如果新购合同中的税额，合同费用,成本为null时,更新合同利润  回写应收账款
			modifyFpayables(cmdparam);
			//修改合同fsumpercent
			modifyFsumpercent(cmdparam);
			
			onUpdateFcost(cmdparam);
            //LC add 2017年7月26日 九江二开，纸质合同领用后，新增新购合同时，合同领用中的合同状态反写为返回状态
            onmodify497(cmdparam);
		
		}

        public function onmodify497(cmdparam:CommandParam):void {
            var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
            var myValue:Object = crmeap.getValue();
            var upsql:String="update lc_useorder set istatus = 2 where iid="+myValue.iid;
            AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, upsql, null, false);
        }

		public function modifyForderprofit(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var myValue:Object = crmeap.getValue();
			var upsql:String="update sc_order set forderprofit ="+myValue.fsum+" where iid="+myValue.iid;
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, upsql, null, false); 
		
		}
		
		//SZC Add 20141226 回写应收账款
		public function modifyFpayables(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var myValue:Object = crmeap.getValue();
			var fpayables:Number;//应收账款
			//SZC Add 20141205如果新购合同中的税额，合同费用,成本为null时,更新合同利润
			if ( myValue.ftax==null && myValue.ffee==null &&  myValue.fcost==null && myValue.fpremiums==null) {
				modifyForderprofit(cmdparam);
			}
			//end
			if(myValue.frpsum!=null&&myValue.frpsum!=""){//判断累计回款是否为null
				fpayables=parseFloat(myValue.fsum)-parseFloat(myValue.frpsum);
			}else{
				fpayables=parseFloat(myValue.fsum);
			}
			var upSql:String="update sc_order set fpayables= "+fpayables+"  where iid= "+myValue.iid;
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql",null,upSql);
			//end
			
		}
		
		//升级合同保存时，更改客户的销售状态为系统选项的公共设置里的设置值
		//修改人:王炫皓
		//修改时间:20121128
		public function onExcute_IFun161(cmdparam:CommandParam):void {
			var iid:int = cmdparam.param.value.iid;
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var myValue:Object = crmeap.getValue();
			var isalesstatus:int = -1;
			var sqlStr:String = "select cvalue from as_options where iid=91";
			if (myValue.iinvoice && myValue.iinvoice > 0) {
				writeBack(myValue.iinvoice);
			}
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
				var eventAC:ArrayCollection = event.result as ArrayCollection;
				if (eventAC.length > 0) {
					if (eventAC[0].cvalue != "" && eventAC[0].cvalue != null) {
						isalesstatus = eventAC[0].cvalue;
					}
					if (isalesstatus > -1) {
						var sql:String = "update CS_customer set isalesstatus= " + isalesstatus + " where iid=" + myValue.icustomer;
						AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
						}, sql);
					}
				}
			}, sqlStr);
			//SZC Add 20141226 如果新购合同中的税额，合同费用,成本为null时,更新合同利润  回写应收账款
			modifyFpayables(cmdparam);
			//修改合同fsumpercent
			modifyFsumpercent(cmdparam);
            //LC add 2017年7月26日 九江二开，纸质合同领用后，新增新购合同时，合同领用中的合同状态反写为返回状态
            onmodify497(cmdparam);
		}
		
		//耗材合同
		public function onExcute_IFun157(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var myValue:Object = crmeap.getValue();
			//修改合同fsumpercent
			modifyFsumpercent(cmdparam);
			//SZC Add 20141226 如果新购合同中的税额，合同费用,成本为null时,更新合同利润  回写应收账款
			modifyFpayables(cmdparam);
		}
		
		//服务费合同
		public function onExcute_IFun159(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var myValue:Object = crmeap.getValue();
            /**
             * LQ 20160226 从商机到服务费合同签单后，线索状态未改变
             */
            if(myValue.iinvoice && myValue.iinvoice>0){
                writeBack(myValue.iinvoice);
            }
			//SZC Add 20141226 如果新购合同中的税额，合同费用,成本为null时,更新合同利润  回写应收账款
			modifyFpayables(cmdparam);
			
			//修改合同fsumpercent
			modifyFsumpercent(cmdparam);
			//SZC Add 20141120  修改服务收费合同费用，同时修改客商资产中的最近收费金额
			onModify159(cmdparam);
		}
		
		//租赁合同
		public function onExcute_IFun462(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var myValue:Object = crmeap.getValue();
			//SZC Add 20141226 如果新购合同中的税额，合同费用,成本为null时,更新合同利润  回写应收账款
			modifyFpayables(cmdparam);
			
			//修改合同fsumpercent
			modifyFsumpercent(cmdparam);
			//SZC Add 20141120  修改服务收费合同费用，同时修改客商资产中的最近收费金额
			onModify159(cmdparam);
		}
		
		//培训费合同
		public function onExcute_IFun160(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var myValue:Object = crmeap.getValue();
			//修改合同fsumpercent
			modifyFsumpercent(cmdparam);
			modifyFpayables(cmdparam);
		}
		
		/**
		 * 创建人:王炫皓
		 * 创建时间：20121128
		 * */
		public function onExcute_IFun210(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var myValue:Object = crmeap.getValue();
			if (myValue.iinvoice && myValue.iinvoice > 0) {
				writeBack(myValue.iinvoice);
			}
			//修改合同fsumpercent
			modifyFsumpercent(cmdparam);
			modifyFpayables(cmdparam);
		}
		  //实施合同
		public function onExcute_IFun459(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var myValue:Object = crmeap.getValue();
			if (myValue.iinvoice && myValue.iinvoice > 0) {
				writeBack(myValue.iinvoice);
			}
			//修改合同fsumpercent
			modifyFsumpercent(cmdparam);
			modifyFpayables(cmdparam);
		}
		
		
		//其他合同
		public function onExcute_IFun329(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var myValue:Object = crmeap.getValue();
			//修改合同fsumpercent
			modifyFsumpercent(cmdparam);
			modifyFpayables(cmdparam);
		}
		
		/**
		 * 合同回写线索状态
		 * 创建人:王炫皓
		 * 创建时间：20121118
		 * */
		public function writeBack(iinvoice:int):void {
			var s:String = "select iinvoice from sa_opportunity where iid =" + iinvoice;
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
				var obj:ArrayCollection = event.result as ArrayCollection;
				if (obj && obj.length > 0) {
					if (obj[0] || obj[0].iinvoice && obj[0].iinvoice > 0) {
						var sql:String = "select iid,ifuncregedit,iinvoice,itype,ccode,cname,ccustomer,icustomer,iifuncregedit from sa_clue where iid = " + obj[0].iinvoice;
						AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
							var saclue:ArrayCollection = event.result as ArrayCollection;
							if (saclue && saclue.length > 0 && saclue[0].iid) {
								var updatesql:String = "update sa_clue set istatus = 3  where iid = " + saclue[0].iid;
								AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
								}, updatesql);
							}
						}, sql)
					}
				}
			}, s);
			
		}
		
		/**
		 * 服务交接保存时自动更新对应实施单的结束时间为服务交接卡片上的交接时间
		 * 创建人：王炫皓
		 * 创建时间：20121207
		 * */
		public function onExcute_IFun286(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var myValue:Object = crmeap.getValue();
			if (myValue && myValue.iinvoice != null || myValue.iinvoice > 0) {
				var upSql:String = "update sr_project set istatus = 416,dfactend = '" + myValue.ddate + "'  where iid = " + myValue.iinvoice;
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
				}, upSql);
			}
		}

        /**
         * 活动人员保存后，将是否参会传入到市场活动中去自动获取实际参会家数和人数
         * 创建人：LC
         * 创建时间：20160302
         * */
        public function onExcute_IFun384(cmdparam:CommandParam):void {
            var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
            var myValue:Object = crmeap.getValue();
            if (myValue && myValue.iinvoice != null || myValue.iinvoice > 0) {
                var sql1:String = "(select COUNT(*) from ( select mr_markets.icustomer from mr_markets left join mr_market on mr_market.iid = mr_markets.iinvoice left join mr_marketsperson on mr_marketsperson.imarkets = mr_markets.iid where mr_marketsperson.bstatus = 1 and mr_markets.iinvoice = "+ myValue.iinvoice + " group by mr_markets.icustomer) a) ";
                var sql2:String = "(select COUNT(*) from mr_marketsperson left join mr_markets on mr_markets.iid = mr_marketsperson.imarkets left join mr_market on mr_market.iid = mr_markets.iinvoice where mr_marketsperson.bstatus = 1 and mr_market.iid = "+ myValue.iinvoice + ")";
                var upSql:String = "update mr_market set ifactcust = "+ sql1 + " ,ifactperson = "+ sql2 + " where iid = " + myValue.iinvoice;
                AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
                }, upSql);
            }
        }

		
		/**
		 * 通用费用保存后，修改对应合同的累计费用
		 * 创建人：lzx
		 * 创建时间：20121211
		 * */
		public function onExcute_IFun275(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var myValue:Object = crmeap.getValue();
			//SZC Add 20141209 如果合同中合同费用已经有值，合同费用累加
			if(myValue.iinvoice==null||myValue.iinvoice==""){
			  return;
			}
			if(myValue.ifuncregedit==380){
				var upSql:String = "update mr_market set factual =  (isnull(factual,0)+" + parseFloat(myValue.fsum)+ ")  where iid = " + myValue.iinvoice;
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
				}, upSql);
			}else{
			var ffee:Number;
			var strSql:String="select ffee from sc_order where iid="+ myValue.iinvoice;
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
				var arr:ArrayCollection=event.result as ArrayCollection;
				if(arr.length>0){
				   if(arr[0].ffee==null|| arr[0].ffee==""){
					   ffee=parseFloat(myValue.fsum);
				   }else{
				       ffee=parseFloat(arr[0].ffee)+parseFloat(myValue.fsum);
				   }
				   var upSql:String = "update sc_order set ffee = " + ffee+ "  where iid = " + myValue.iinvoice;
				   AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
				   }, upSql);
				}
			}, strSql);
			
			//end
			//SZC Add 20141119 从合同中减去合同费用得出合同利润和回款利润
			var sql:String="select forderprofit,fbackprofit from sc_order where iid="+ myValue.iinvoice;
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
				var eventAC:ArrayCollection = event.result as ArrayCollection;
				if(eventAC.length>0){
				  if(eventAC[0].forderprofit!=null && eventAC[0].forderprofit!=""){
				    var upSql:String="update sc_order set forderprofit="+(eventAC[0].forderprofit-myValue.fsum)+" where iid= "+myValue.iinvoice;
					AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, upSql);
				  }
				  if(eventAC[0].fbackprofit!=null && eventAC[0].fbackprofit!=""){
					  var upSql:String="update sc_order set fbackprofit="+(eventAC[0].fbackprofit-myValue.fsum)+" where iid= "+myValue.iinvoice;
					  AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, upSql);
				  }
				}
			}, sql);
			//end
			}
		}
		
		//客商计划
		/*public function onExcute_IFun35(cmdparam:CommandParam):void {
		var iid:int = cmdparam.param.value.iid;
		var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
		var myValue:Object = crmeap.getValue();
		var dmessage = myValue.dmessage;
		if (iid != 0 && dmessage) {
		var mysql:String = "select * from  as_communication where itype=12 and ifuncregedit=35 and iinvoice=" + iid;
		AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
		var ac:ArrayCollection = e.result as ArrayCollection;
		if (ac && ac.length > 0) {
		
		} else {
		var mysql:String = "insert into as_communication (itype,isperson,irperson,ifuncregedit,iinvoice) values(12," + myValue.imaker + "," + myValue.imaker + ",35," + iid + ")";
		AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, mysql, null, false);
		}
		}, mysql, null, false);
		}
		
		}*/
		
		//客商活动
		public function onExcute_IFun46(cmdparam:CommandParam):void {
			var iid:int = cmdparam.param.value.iid;
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var myValue:Object = crmeap.getValue();
			//var dmessage = myValue.dmessage;
			/*if (iid != 0 && dmessage) {
			var mysql:String = "select * from  as_communication where itype=13 and ifuncregedit=46 and iinvoice=" + iid;
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
			var ac:ArrayCollection = e.result as ArrayCollection;
			if (ac && ac.length > 0) {
			
			} else {
			var sql:String = "insert into as_communication (itype,isperson,irperson,ifuncregedit,iinvoice) values(13," + myValue.imaker + "," + myValue.imaker + ",46," + iid + ")";
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, sql, null, false);
			}
			}, mysql, null, false);
			}*/
			
			if (myValue.ioaplans > 0) {
				var sqlstr:String = "update oa_plans set csummary='" + myValue.cdetail + "'  where iid=" + myValue.ioaplans;
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, sqlstr, null, false);
			}
			//SZC   修改商机的项目当前阶段，同时生成一条进程推进记录
			if(myValue.ifuncregedit==80 && myValue.iprocess!="" && myValue.iprocess!=null){
			    var sql:String="select isnull(iphase,0) iphase  from sa_opportunity where iid="+myValue.iinvoice;
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
				   var ac:ArrayCollection=e.result as ArrayCollection;
				  if(myValue.iprocess>ac[0].iphase){
				      var upSql:String="update sa_opportunity set iphase="+myValue.iprocess+"  where iid="+myValue.iinvoice;
					  AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, upSql);
					  var dateStr:String=CRMtool.getFormatDateString("YYYY-MM-DD HH:NN:SS",null);
					  //插入一条进程推进
					  var obj:Object =new Object();
					  obj.ifuncregedit=myValue.ifuncregedit;
					  obj.iinvoice=myValue.iinvoice;
					  obj.icustomer=myValue.icustomer;
					  obj.iprocess=myValue.iprocess;
					  obj.ddate=dateStr;
					  obj.iifuncregedit=258;
					  obj.imaker=CRMmodel.userId;
					  obj.dmaker=dateStr;
					  AccessUtil.remoteCallJava("UtilViewDest", "setInvoiceprocess", null,obj);
				  }
				},sql);
			}
			
			//
		}
		
		public function onExcute_IFun145(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var ifuncregedit:String = crmeap.getValue().ifuncregedit + "";
			
			if (CRMtool.isStringNull(ifuncregedit) || ifuncregedit == "0")
				return;
			
			var sql:String = "update ac_vouchform set bMain=1 where ivouch=(select iid from ac_vouch where ifuncregedit=#ifuncregedit#)  " +
				" and ctable=(select ctable from ac_tablerelationship where  ifuncregedit=#ifuncregedit# and bMain=1)";
			while (sql.search("#ifuncregedit#") > -1) {
				sql = sql.replace("#ifuncregedit#", ifuncregedit);
			}
			
			
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, sql);
		}
		
		/**
		 * 合同保存后修改fsumpercent
		 * lzx
		 * */
		public function modifyFsumpercent(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var myValue:Object = crmeap.getValue();
			var iid:int = myValue.iid;
			var fsum:Number = myValue.fsum;
			var ftaxsum:Number = 0;
			var sql:String = "select ftaxsum from sc_orders where iorder=" + iid + " and  iproduct in (select iid from sc_product where isnull(bnosum,0)!=1)";
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
				var ac:ArrayCollection = e.result as ArrayCollection;
				if (ac && ac.length > 0) {
					for each(var obj:Object in ac) {
						ftaxsum += Number(obj.ftaxsum);
					}
				}
				if (fsum == 0) {
					return;
				}
				var fsumpercent:Number = ftaxsum / fsum;
				var sqlstr:String = "update sc_order set fsumpercent=" + fsumpercent + " where iid=" + iid;
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
					crmeap.queryPm(iid + "");
				}, sqlstr);
			}, sql);
		}
		
		//出库单保存完直接生成资产
		public function onExcute_IFun228(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var value:Object = crmeap.getValue();
			var sc_rdrecords:ArrayCollection = value.sc_rdrecords;
			var sc_rdrecordsbom:ArrayCollection = value.sc_rdrecordsbom;
			
			if (sc_rdrecords && sc_rdrecords.length <= 0) {
				CRMtool.showAlert("产品不存在，无法生成资产。");
				return;
			}
			
			if (value.iinvoice == null || value.iinvoice == 0) {
				CRMtool.showAlert("未选择相关合同，无法生成资产。");
				return;
			}
			
			//如果是升级合同 检查原来升级合同影响资产 如果加密狗出库与替换的相同 则资产状态应为 新购
			if (value.ifuncregedit == 161 && value.iinvoice > 0) {//升级合同
				for each(var item:Object in sc_rdrecords) {
					if (CRMtool.isStringNotNull(item.csn) && item.iproduct > 0) {
						var sql:String = "update cs_custproduct set istatus=1 where icontract=" + value.iinvoice + " and csn='" + StringUtil.trim(item.csn) + "' and iproduct=" + item.iproduct + " and istatus = 2";
						AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, sql, null, false);
					}
				}
			}
			
			for each(var obj:Object in sc_rdrecords) {
				obj.ifuncregedit = value.iifuncregedit;//当前单据功能内码
				obj.iinvoice = value.iid;
				obj.orderiid = value.iinvoice;
				obj.icustomer = value.icustomer;
				obj.iscstatus = 509;//赠送期限内
				obj.istatus = 1;//产品状态 新购
				obj.imaker = CRMmodel.userId;
				obj.dmaker = value.dmaker;
				var bomList:ArrayCollection = null;
				for each(var bomobj:Object in sc_rdrecordsbom) {
					if (obj.iproduct == bomobj.iproductp) {
						if (bomList == null) {
							bomList = new ArrayCollection();
							obj.bomList = bomList;
						}
						bomList.addItem(bomobj);
					}
				}
			}
			AccessUtil.remoteCallJava("customerDest", "addCsProduct", function (event:ResultEvent):void {
				if (event.result.toString() == "alreadyhave") {
					CRMtool.showAlert("此单据已经生成资产，无法再次生成。");
				} else if (event.result.toString() == "muchcsn") {
					CRMtool.showAlert("加密狗号已存在多次，无法生成资产，请检查。");
				}
				else if (event.result.toString() == "ok") {
					CRMtool.showAlert("生成资产成功！");
					crmeap.publicFlagObject["checkAlreadyhave" + value.iifuncregedit + ":" + value.iid] = true;
				} else {
					CRMtool.showAlert("生成失败，请联系管理员。");
				}
				
			}, sc_rdrecords);
		}
		
		//销售回款保存后自动核销
		public function onExcute_IFun163(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			//(crmeap.paramForm as FrameCore).onCheckSales();
			var myMainValue:Object = crmeap.getValue();
		/*	if (myMainValue.hasOwnProperty("icustomer") && myMainValue.hasOwnProperty("fmoney") && myMainValue.hasOwnProperty("iid")) {
				var irpinvoice:int = myMainValue.iid;
				var iifuncregedit:int = myMainValue.iifuncregedit;
				var icustomer:int = myMainValue.icustomer;
				var fmoney:Number = parseFloat(myMainValue.fmoney);
				var fclosemoney:Number = parseFloat(myMainValue.fclosemoney);
				var sc_ctrpclosetable:ArrayCollection = myMainValue.sc_ctrpclose;//核销子表
				
				if (fclosemoney == fmoney) {
					//CRMtool.showAlert("禁止核销。原因：回款金额分配完毕.");
					return;
				}
				
				if (icustomer != 0) {
					var checkSalesTitleWindow:CheckSalesTitleWindow = new CheckSalesTitleWindow();
					checkSalesTitleWindow.init(icustomer, fmoney, irpinvoice, iifuncregedit, sc_ctrpclosetable, crmeap);
					CRMtool.openView(checkSalesTitleWindow);
				}
			} else {
				CRMtool.showAlert("缺少必要参数，请重新打开此卡片再试。");
			}*/
			//20141206SZC 把回款利润写进合同
			if(myMainValue.istatus==4 || myMainValue.istatus==5){
			var sql:String="select fcost,ffee,ftax,fpremiums from sc_order where iid=(select iorder from SC_ctrpclose where irpinvoice="+myMainValue.iid+")";
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
				var arr:ArrayCollection = e.result as ArrayCollection;
				var fbackprofit:Number=0;
				if(arr.length>0){
				  if(arr[0].fcost!=null&&arr[0].fcost!=""){
					  fbackprofit=fbackprofit-parseFloat(arr[0].fcost)
				  }
				  if(arr[0].ffee!=null&&arr[0].ffee!=""){
					  fbackprofit=fbackprofit-parseFloat(arr[0].ffee)
				  }
				  if(arr[0].ftax!=null&&arr[0].ftax!=""){
					  fbackprofit=fbackprofit-parseFloat(arr[0].ftax)
				  }
				  if(arr[0].fpremiums!=null&&arr[0].fpremiums!=""){
					  fbackprofit=fbackprofit-parseFloat(arr[0].fpremiums)
				  }
				}
				var str:String = "update sc_order set fbackprofit="+fbackprofit+" where iid= (select iorder from SC_ctrpclose where irpinvoice="+myMainValue.iid+")";
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, str);
			}, sql);
			}
		   //end
		}
		
		
		//开发日志 a
		public function onExcute_IFun369(cmdparam:CommandParam):void {
			
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var obj:Object = crmeap.getValue();
			var objparam:Object = {};
			
			objparam.iproject = obj.iproject;
			objparam.resetFlag = true;
			
			AccessUtil.remoteCallJava("projectDest", "updateSrProjectFfact", null, objparam);
			
			cmdparam.excuteNextCommand = true;
		}
		
		/**
		 * 培训回访保存 结算相关单据的 平均分数 并回写培训管理卡片
		 * 创建人:王炫皓
		 * 创建时间:20130720
		 * @param cmdparam
		 */
		public function onExcute_IFun198(cmdparam:CommandParam):void {
			
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var mainValue:Object = crmeap.getValue();
			//相关单据
			var iinovice:int = mainValue.iinvoice;
			//查询是同一个相关单据的数据
			var sql:String = "select iid,fscore from sr_feedback where iinvoice = " + iinovice;
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
				var arr:ArrayCollection = e.result as ArrayCollection;
				var score:Number = 0;
				for each(var feedback:Object in arr) {
					score += CRMtool.getNumber(feedback.fscore);
				}
				var avg = score / arr.length;
				var str:String = "update sr_train set iaverage = " + avg + " where iid = " + iinovice;
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, str);
			}, sql);
		}
		
		//功能建模
		public function onExcute_IFun372(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var value:Object = crmeap.getValue();
			var iid:int = value.iid;
			
			if (crmeap.publicFlagObject.is372Change)
				AccessUtil.remoteCallJava("as_dataauthViewDest", "update_initdata", null, iid, null, false);//初始化权限
		}
		
		/**
		 * 赠品出库
		 * 作者：施则成
		 * 日期：2015-01-15
		 */
		public function onExcute_IFun427(cmdparam:CommandParam):void {
			
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var myValue:Object = crmeap.getValue();
			var upSql:String="update sc_rdrecord set istatus=2 where iifuncregedit =428 and iid="+myValue.iinvoice;
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null,upSql);
			//SZC Add 20141209 如果合同中合同费用已经有值，合同费用累加
			var fpremiums:Number;
			var strSql:String="select fpremiums from sc_order where iid=(select iinvoice from sc_rdrecord where iifuncregedit=428 and iid="+ myValue.iinvoice+")";
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
				var arr:ArrayCollection=event.result as ArrayCollection;
				if(arr.length>0){
					if(arr[0].fpremiums==null|| arr[0].fpremiums==""){
						fpremiums=parseFloat(myValue.fsum);
					}else{
						fpremiums=parseFloat(arr[0].fpremiums)+parseFloat(myValue.fsum);
					}
					var upSql:String = "update sc_order set fpremiums = " + fpremiums+ "  where iid =(select iinvoice from sc_rdrecord where iifuncregedit=428 and iid="+ myValue.iinvoice+")";
					AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
					}, upSql);
				}
			}, strSql);
			
			//end
			var sql:String="select forderprofit, fbackprofit from sc_order where iid=(select iinvoice from sc_rdrecord where iifuncregedit=428 and iid="+ myValue.iinvoice+")";
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
				var eventAC:ArrayCollection = event.result as ArrayCollection;
				if(eventAC.length>0){
					if(eventAC[0].forderprofit!=null && eventAC[0].forderprofit!=""){
						var upSql:String="update sc_order set forderprofit="+(eventAC[0].forderprofit-myValue.fsum)+" where iid= (select iinvoice from sc_rdrecord where iifuncregedit=428 and iid="+ myValue.iinvoice+")";
						AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, upSql);
					}
					if(eventAC[0].fbackprofit!=null && eventAC[0].fbackprofit!=""){
						var upSql:String="update sc_order set fbackprofit="+(eventAC[0].fbackprofit-myValue.fsum)+" where iid= (select iinvoice from sc_rdrecord where iifuncregedit=428 and iid="+ myValue.iinvoice+")";
						AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, upSql);
					}
				}
			}, sql);
		
		}
		
		
		/**
		 * 批量保存发票，插入发票子表信息
		 * 作者：杨政伟
		 * 日期：2014-3-26
		 */
		public function onExcute_IFun394(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var iid:int = crmeap.getValue().iid;
			var sql:String = "delete tr_invoices where itype = 0 and itrrule =  "+ iid +
				";insert into tr_invoices(itrinvoice,itype,imaker,dmaker,cmemo,iperson,itrrule) select iid,istatus,imaker,dmaker,cmemo,iperson,iinvoice from tr_invoice where iinvoice = " + iid;
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, sql);
		}
		/**
		 * 保存发票，插入发票子表信息
		 * 作者：杨政伟
		 * 日期：2014-3-26
		 */
		public function onExcute_IFun391(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var mainValue:Object = crmeap.getValue();
			var iid:int = mainValue.iid;
			if(cmdparam.optType == "onNew"){
				ServiceTool.addInvoices(iid,mainValue,crmeap);
			}
		}
		
		
		/**
		 * 收费单保存后，更新发票状态
		 * 作者：李宁
		 * 日期：2014-03-28
		 */
		public function onExcute_IFun390(cmdparam:CommandParam):void {
			
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var mainValue:Object = crmeap.getValue();
			
			var iid:int = mainValue.iinvoice;
			var iperson:int = mainValue.iperson;
			var icustomer:int = mainValue.icustomer;
			var imaker:int = mainValue.imaker;
			var dmaker:String = mainValue.dmaker;
			var iid_charge:int = mainValue.iid;
			
			//发票主表状态变为2待核销  并插入一条发票轨迹记录
			var sql:String = "";
			sql += "update tr_invoice set istatus = 2 where iid= "+ iid +" and istatus=1;";
			sql += "insert into tr_invoices"
				+" select tr_invoice.iinvoice,tr_invoice.iid,2,tr_invoice.iperson,"+icustomer+","+imaker+",getdate(),cmemo "
				+" from tr_invoice where iid = "+ iid;
			
			
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, sql, null, false);
			
		}
		
		/**
		 * 服务回访保存后，更新客户最后一次回访日期
		 * 作者：李宁
		 * 日期：2014-04-02
		 * -------添加功能-------
		 * 方法功能：服务回访保存时，判断，如果是呼叫中心生成单据，则更新其状态记录，同时写入制单人制单时间
		 * 编写作者：杨政伟
		 * 创建日期：2014-07-29
		 */
		public function onExcute_IFun154(cmdparam:CommandParam):void {
			
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var mainValue:Object = crmeap.getValue();
			
			var iid:int = mainValue.icustomer;
			var ddate:String = mainValue.ddate;
			
			
			//更新客商资料客户最后一次回访日期
			var sql:String = "update cs_customer set dlastfeedbackdate = '"+ddate+"' where iid= "+ iid;
			
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, sql, null, false);
			
			//----------回写呼叫中心--------
			if(cmdparam.optType == "onNew") {
				var vi_ifuncregedit:int = cmdparam.param.value.vi_ifuncregedit;
				var vi_iid:int = cmdparam.param.value.vi_iid;
				
				if (vi_ifuncregedit && vi_ifuncregedit == 153 && vi_iid) {
					var pparam:Object = new Object();
					pparam.cciid = vi_iid;
					pparam.isolution = 4;//处理方式：服务回访
					pparam.imaker = CRMmodel.userId;
					pparam.dmaker = CRMtool.getFormatDateString();
					AccessUtil.remoteCallJava("CallCenterDest", "updatesolution", null, pparam, null, false);
				}
			}
			
		}
		
		
		//产品入库后判断是否更新合同成本
		public function onExcute_IFun231(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var mainValue:Object = crmeap.getValue();
			var iinvoice:int = mainValue.iinvoice;
			var fsum:Number = mainValue.fsum;
			var istest:int = CRMmodel.IsRebackToContCost;
			
			if(iinvoice == 0) {
				return;
			}
			if(istest == 1) {
				if(cmdparam.optType == "onNew"){
				/*
				 * var sql:String ="update sc_order set fcost = a.fsum from (select iinvoice,SUM(fsum) fsum from sc_rdrecord group by iinvoice) a "+
				"where sc_order.iid = a.iinvoice  and sc_order.iid = " + iinvoice;
				*/
				/*var sql:String ="update sc_order set fcost = a.fsum from (select iinvoice,iifuncregedit,SUM(fsum) fsum from sc_rdrecord group by iinvoice,iifuncregedit) a "+
					"where sc_order.iid = a.iinvoice  and a.iifuncregedit=231  and sc_order.iid = " + iinvoice;
				
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, sql, null, false);*/
				var strSql1:String="select iid,iproduct,fquantity from sc_orders where iorder="+iinvoice;
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
					var asc:ArrayCollection=e.result  as ArrayCollection;
					var ac:ArrayCollection=mainValue.sc_rdrecords as ArrayCollection;
					if(asc.length==0){
						return;
					}
					for(var j:int=0;j<asc.length;j++){
						for(var i:int=0;i<ac.length;i++){
							if(asc[j].iproduct==ac[i].iproduct){
								var fcost:Number=ac[i].fprice*asc[j].fquantity;
							  var upSql1:String="update sc_orders set fcostprice="+ac[i].fprice+",fcost="+fcost+"  where iid="+asc[j].iid;
							  AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null,upSql1, null, false);
							}
						}
					}
					var sql2:String="select fsum,forderprofit,fbackprofit from sc_order where iid="+iinvoice;
					AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
 						var aclist:ArrayCollection=e.result as  ArrayCollection;
						var obj:Object=new Object();
						obj.asc=asc;
						obj.ac=ac;
						obj.aclist=aclist;
						obj.iinvoice=iinvoice;
						obj.optType="onNew";
						AccessUtil.remoteCallJava("UtilViewDest", "updateOrderFsum", null,obj);
					},sql2);
					
					var sql:String ="update sc_order set fcost = a.fsum from (select sum(fcost)fsum from sc_orders where iorder="+iinvoice+") a "+
					" where  sc_order.iid = " + iinvoice;
					AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, sql, null, false);
				}, strSql1);
				}
				/*//20141206 SZC 先做新购合同在做产品入库，往合同中回写成本，计算合同利润
				var strSql:String="select fsum,forderprofit,fbackprofit from sc_order where iid="+iinvoice;
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(e:ResultEvent):void{
					var arr:ArrayCollection= e.result as ArrayCollection;
					if(arr.length>0){
						if(arr[0].forderprofit!=null && arr[0].forderprofit!=""){
						var upSql:String="update sc_order set forderprofit="+(parseFloat(arr[0].forderprofit)-fsum)+" where iid="+iinvoice;
						AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, upSql, null, false);
						}else{
						var upSql:String="update sc_order set forderprofit="+(parseFloat(arr[0].fsum)-fsum)+" where iid="+iinvoice;
							AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, upSql, null, false);
						}
						if(arr[0].fbackprofit!=null && arr[0].fbackprofit!=""){//如果回款利润不为null,利润减去成本
							var upSql:String="update sc_order set fbackprofit="+(parseFloat(arr[0].fbackprofit)-fsum)+" where iid="+iinvoice;
							AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, upSql, null, false);
						}
					}
				}, strSql, null, false);
				//end*/
			}
			
		
			
		}
		
		
		/**
		 * 物料归还回写物料借用表体归还数量
		 * lzx
		 * */
		/*public function onExcute_IFun350(cmdparam:CommandParam):void {
		var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
		var myValue:Object = crmeap.getValue();
		var params:ArrayCollection = new ArrayCollection();
		var param:Object = new Object();
		for each(var item:Object in myValue.sc_rdrecords) {
		param.iid = myValue.iid;
		param.fquantity = item.fquantity;
		param.iproduct = item.iproduct;
		param.csn = item.csn;
		params.addItem(param);
		}
		AccessUtil.remoteCallJava("UtilViewDest", "updateRdrecords",null, params);
		}*/
		
		/**
		 * 		YJ Add 20141023 更新新购合同中的成本字段信息(根据加密狗号)
		 **/
		/*private function onUpdateFcost(cmdparam:CommandParam):void{
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var mainValue:Object = crmeap.getValue();
			var iid:int = mainValue.iid;
			//var sql:String = "";
			var obj:Object = new Object();
			var counter:int = 0;//计数器
			var arr_orders:ArrayCollection = mainValue.sc_orders;
			obj.optType="onNew";
			//遍历子表数据,校验加密狗号是否填写
			for(var i:int=0;i<arr_orders.length;i++){
				obj = arr_orders[i];
				if(StringUtil.trim(obj.csn + "") != "") counter++;
			}
			
			if(counter == 0) return;
			
			/*sql = "select sum(A.fsum) fsum from sc_rdrecord A left join sc_rdrecords B on A.iid=B.irdrecord "+
				"where A.iifuncregedit=231 and B.csn in (select csn from sc_orders where iorder=" + iid + ")";
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
				var eventAC:ArrayCollection = e.result as ArrayCollection;
				if (eventAC.length == 0) return;
			
				if (eventAC[0].fsum != null && eventAC[0].fsum != "") {
					sql = "update sc_order set fcost="+ eventAC[0].fsum +" where iid=" + iid;
					AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, sql, null, false); 
					//SZC Add 20141119如果新购合同中的税额，合同费用为null时,更新合同利润
					if(mainValue.ftax==null && mainValue.ffee==null && mainValue.fpremiums==null){
						sql="update sc_order set forderprofit ="+(mainValue.fsum-eventAC[0].fsum)+" where iid="+iid;
						AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, sql, null, false); 
					}
				}
				//end
			}, sql);*/
			/*var csnSql:String="select csn from sc_rdrecords where csn is not null";
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
				var csnAc:ArrayCollection= e.result as ArrayCollection;
				var flag:Boolean=false;
				if (csnAc.length == 0) return;
				
				for(var j:int=0;j<arr_orders.length;j++){
					for(var h:int=0;h<csnAc.length;h++){
						if(arr_orders[j].csn==csnAc[h].csn){
							flag=true;
						}
					}
						if(flag){
						var upsql:String="update sc_orders set fcostprice=a.fprice ,fcost=(a.fprice*"+arr_orders[j].fquantity+")  " +
						" from(select s.fprice  from sc_rdrecords s LEFT join sc_rdrecord sc on sc.iid=s.irdrecord where sc.iifuncregedit=231 and s.csn='"+arr_orders[j].csn+"')a  " +
						" where iid="+arr_orders[j].iid;
						AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
						}, upsql, null, false);
						}
				}
					if(flag){
							var ac:ArrayCollection =null;
							var sql:String="select s.iid,s.ffee,s.fpremiums,s.ftax,isnull(s.forderprofit,0) forderprofit from sc_order s  where s.iid="+iid;
							AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
								ac = e.result as ArrayCollection;
								//end
							}, sql);
							var strSql:String="select * from sc_orders where iorder="+iid;
							AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {	
								var asc:ArrayCollection = e.result as ArrayCollection;
								obj.ac=ac;
								obj.asc=asc;
								AccessUtil.remoteCallJava("UtilViewDest", "updateOrderFcostForCsn", function (e:ResultEvent):void {
									var mValue:Object=new Object();
									mainValue.sc_orders=asc;
									mainValue.fcost=e.result.fcost;
									mainValue.forderprofit=e.result.forderprofit;
									mValue.sc_orders=asc;
									mValue.sc_orderrpplan=mainValue.sc_orderrpplan;
									mValue.sc_orderapportion=mainValue.sc_orderapportion;
									mValue.sc_ordersbom=mainValue.sc_ordersbom;
									mValue.mainValue=mainValue;
									crmeap.setValue(mValue, 1, 1);
								},obj);
							}, strSql);
					
					}
			}, csnSql, null, false);
		
		
		}*/
		private function onUpdateFcost(cmdparam:CommandParam):void{
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var mainValue:Object = crmeap.getValue();
			var iid:int = mainValue.iid;
			var obj:Object = new Object();
			var counter:int = 0;//计数器
			var arr_orders:ArrayCollection = mainValue.sc_orders;
			var fcostOld:Number=0;
			//遍历子表数据,校验加密狗号是否填写
			for(var i:int=0;i<arr_orders.length;i++){
				obj = arr_orders[i];
				fcostOld+=arr_orders[i].fcostprice*arr_orders[i].fquantity;
				if(StringUtil.trim(obj.csn + "") != "") counter++;
			}
			obj.fcostOld=fcostOld;
			obj.optType=cmdparam.optType;
			if(counter == 0) return;
			var csnSql:String="select csn from sc_rdrecords where csn is not null";
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
				var csnAc:ArrayCollection= e.result as ArrayCollection;
				var flag:Boolean=false;
				if (csnAc.length == 0) return;
				
				for(var j:int=0;j<arr_orders.length;j++){
					for(var h:int=0;h<csnAc.length;h++){
						if(arr_orders[j].csn==csnAc[h].csn){
							flag=true;
						}
					}
					if(flag){
						var upsql:String="update sc_orders set fcostprice=a.fprice ,fcost=(a.fprice*"+arr_orders[j].fquantity+")  " +
						" from(select s.fprice  from sc_rdrecords s LEFT join sc_rdrecord sc on sc.iid=s.irdrecord where sc.iifuncregedit=231 and s.csn='"+arr_orders[j].csn+"')a  " +
						" where iid="+arr_orders[j].iid;
						AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
						}, upsql, null, false);
					}
				}
				if(flag){
					var ac:ArrayCollection =null;
					var sql:String="select s.iid,s.ffee,s.fpremiums,s.ftax,isnull(s.forderprofit,0) forderprofit from sc_order s  where s.iid="+iid;
					AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
						ac = e.result as ArrayCollection;
						//end
					}, sql);
					var strSql:String="select * from sc_orders where iorder="+iid;
					AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {	
						var asc:ArrayCollection = e.result as ArrayCollection;
						obj.ac=ac;
						obj.asc=asc;
						AccessUtil.remoteCallJava("UtilViewDest", "updateOrderFcostForCsn", function (e:ResultEvent):void {
							var mValue:Object=new Object();
							mainValue.sc_orders=asc;
							mainValue.fcost=e.result.fcost;
							mainValue.forderprofit=e.result.forderprofit;
							mValue.sc_orders=asc;
							mValue.sc_orderrpplan=mainValue.sc_orderrpplan;
							mValue.sc_orderapportion=mainValue.sc_orderapportion;
							mValue.sc_ordersbom=mainValue.sc_ordersbom;
							mValue.mainValue=mainValue;
							crmeap.setValue(mValue, 1, 1);
						},obj);
					}, strSql);
					
				}
			}, csnSql, null, false);
			
			
		}
		
		/**
		 * 项目计划保存后修改项目需求的状态
		 * 作者：SZC
		 * 日期：2015-02-27
		 */
		public function onExcute_IFun446(cmdparam:CommandParam):void {
		var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
		var obj:Object = crmeap.getValue();
		AccessUtil.remoteCallJava("CommonalityDest", "updateStatus", null, {iinvoice: obj.iinvoice, ifuncregedit: 445, istatus: 3, iperson: CRMmodel.userId}, null, false);
		}
		/**
		 * 项目计划保存后修改项目需求的状态
		 * 作者：SZC
		 * 日期：2015-02-28
		 */
		public function onExcute_IFun456(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var obj:Object = crmeap.getValue();
			if(obj.istatus!=null || obj.istatus!=""){
			    if(obj.istatus==9){
					//回写测试结果和状态到任务
					var sql4:String="update sr_projecttask set  ctestresult="+"'"+obj.cresult+"'"+" where iid= "+obj.iinvoice+";";
					AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null,sql4);
				    AccessUtil.remoteCallJava("CommonalityDest", "updateStatus", null, {iinvoice: obj.iinvoice, ifuncregedit: 452, istatus: 9, iperson: CRMmodel.userId}, null, false);
					//回写需求分析状态
					var sql5:String="update sr_projectjobs set istate=9 where iid=(select iinvoice from sr_projectTask where iid=(select iinvoice from sr_projectTest where iid="+obj.iid+"))";
					AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null,sql5);
					//查询出由计划生成任务后，所有任务的状态
					var sql2:String="select istatus from sr_projectTask where iinvoice in (select iid from sr_projectjobs where iprojectjob=(select iprojectjob from sr_projectjobs where iid=(select iinvoice from sr_projectTask"+ 
						" where iid=(select iinvoice from sr_projecttest where iid="+obj.iid+"))));";
					AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(event:ResultEvent):void{
						var ac:ArrayCollection = event.result as ArrayCollection;
						if(ac.length==0)
							return;
						for(var i:int=0; i<ac.length; i++){
							if(ac[i].istatus!=9)
								return;
						}
						//修改需求提交状态为需求
						var sql3:String="select iinvoice from sr_projectjob where iid=(select iprojectjob from sr_projectjobs where iid=(select iinvoice from sr_projectTask  "+
						" where iid=(select iinvoice from sr_projecttest where iid="+obj.iid+")));";
						AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(event:ResultEvent):void{
							var ac:ArrayCollection=event.result as ArrayCollection;
							AccessUtil.remoteCallJava("CommonalityDest", "updateStatus", null, {iinvoice: ac[0].iinvoice, ifuncregedit: 445, istatus: 6, iperson: CRMmodel.userId}, null, false);
						},sql3);
					},sql2);
					//END
					//测试保存后修改任务的实际结束时间
					if(obj.drelend!=null && obj.drelend!=""){
						var cdate:String=obj.drelend+"";
						var sql7:String ="update sr_projecttask set drelend="+"'"+cdate+"'"+" where  iid= "+obj.iinvoice+";";
						AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql",null,sql7);
						//修改需求分析的实际开始时间
						var sql8:String ="update sr_projectjobs set drelend="+"'"+cdate+"'"+"  where iid=(select iinvoice from sr_projectTask where iid=(select iinvoice from sr_projectTest where iid="+obj.iid+"))";
						AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql",null,sql8);
					}
				}
				if(obj.istatus==10){
					var sql4:String="update sr_projecttask set ctestresult="+"'"+obj.cresult+"'"+" where iid= "+obj.iinvoice+";";
					AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null,sql4);
						AccessUtil.remoteCallJava("CommonalityDest", "updateStatus", null, {iinvoice: obj.iinvoice, ifuncregedit: 452, istatus: 10, iperson: CRMmodel.userId}, null, false);
					
					//回写需求分析状态
					var sql5:String="update sr_projectjobs set istate=10 where iid=(select iinvoice from sr_projectTask where iid=(select iinvoice from sr_projectTest where iid="+obj.iid+"))";
					AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null,sql5);
				}
				
			}
			
		}
		
		
		//SZC Add 20141120  修改服务收费合同费用，同时修改客商资产中的最近收费金额
		public function onModify159(cmdparam:CommandParam):void
		{
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var myValue:Object = crmeap.getValue();
			var sql:String ="select fservicecharge from cs_custproduct  where iid=(select c.icustproduct from sc_orders2 c where iorder="+myValue.iid+")";
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
				var eventAC:ArrayCollection = event.result as ArrayCollection;
				if (eventAC.length > 0) {
					if(eventAC[0].fservicecharge!=null&&eventAC[0].fservicecharge!=""){
						if(parseInt(eventAC[0].fservicecharge)!=myValue.fsum){
							var upSql:String = "update cs_custproduct set fservicecharge= " + myValue.fsum + " where iid=(select c.icustproduct from sc_orders2 c where iorder="+myValue.iid+")";
							AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
							}, upSql);
						}
					}
				}
			}, sql);
		}
		
	}
}