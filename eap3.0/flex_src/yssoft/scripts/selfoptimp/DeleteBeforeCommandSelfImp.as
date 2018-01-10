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
	import mx.rpc.events.ResultEvent;
	
	import yssoft.comps.frame.module.CrmEapRadianVbox;
	import yssoft.frameui.FrameCore;
	import yssoft.frameui.formopt.selfopt.DeleteCommandSelf;
	import yssoft.tools.AccessUtil;
	import yssoft.tools.CRMtool;
	import yssoft.vos.CommandParam;
	
	public class DeleteBeforeCommandSelfImp {
		public var deleteCommandSelf:DeleteCommandSelf;
		
		public function DeleteBeforeCommandSelfImp() {
		}
		
		/*public function onExcute_IFun162(cmdparam:CommandParam):void
		{
		}*/
		
		/**
		 * 方法功能：通用费用删除后更新合同中的合同费用，合同利润，回款利润
		 * 编写作者：SZC
		 * 创建日期：2014-12-19
		 * 更新日期：
		 */
		public function onExcute_IFun275(cmdparam:CommandParam):void
		{
			var mainValue:Object=cmdparam.param.value;
			var fsum:Number=0;
			var sql:String ="select fsum from oa_expense where  iid="+mainValue.iid;
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql",function(e:ResultEvent):void{
				var ac:ArrayCollection= e.result as ArrayCollection;
				if(ac.length>0){
					fsum=parseFloat(ac[0].fsum);
				}
			},sql);
			var strSql:String="select ffee,forderprofit,fbackprofit from sc_order where iid="+mainValue.iinvoice;
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(e:ResultEvent):void{
				var arr:ArrayCollection= e.result as ArrayCollection;
				if(arr.length>0){
					var upSql:String="update sc_order set ffee="+(parseFloat(arr[0].ffee)-fsum)+",forderprofit="+(parseFloat(arr[0].forderprofit)+fsum)+" where iid="+mainValue.iinvoice;
					AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, upSql, null, false);
					if(arr[0].fbackprofit!=null && arr[0].fbackprofit!=""){//如果回款利润不为null,利润加上成本
						var upSql:String="update sc_order set fbackprofit="+(parseFloat(arr[0].fbackprofit)+fsum)+" where iid="+mainValue.iinvoice;
						AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, upSql, null, false);
					}
				}
			}, strSql, null, false);
			
			deleteCommandSelf.onNext();
		}

		/**
		 * 方法功能：赠品出库删除后更新合同中的赠品费用，合同利润，回款利润
		 * 编写作者：施则成
		 * 创建日期：2015-01-15
		 * 更新日期：
		 */
		public function onExcute_IFun427(cmdparam:CommandParam):void
		{
			var mainValue:Object=cmdparam.param.value;
			var fsum:Number=0;
			var upSql:String="update sc_rdrecord set istatus=1 where iifuncregedit =428 and iid="+mainValue.iinvoice;
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null,upSql);
			var sql:String ="select fsum from sc_rdrecord where  iid="+mainValue.iid;
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql",function(e:ResultEvent):void{
				var ac:ArrayCollection= e.result as ArrayCollection;
				if(ac.length>0){
					fsum=parseFloat(ac[0].fsum);
				}
			},sql);
			var strSql:String="select fpremiums,forderprofit,fbackprofit from sc_order where iid=(select iinvoice from sc_rdrecord where iifuncregedit=428 and iid="+ mainValue.iinvoice+")";
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(e:ResultEvent):void{
				var arr:ArrayCollection= e.result as ArrayCollection;
				if(arr.length>0){
					var upSql:String="update sc_order set fpremiums="+(parseFloat(arr[0].fpremiums)-fsum)+",forderprofit="+(parseFloat(arr[0].forderprofit)+fsum)+" where iid=(select iinvoice from sc_rdrecord where iifuncregedit=428 and iid="+ mainValue.iinvoice+")";
					AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, upSql, null, false);
					if(arr[0].fbackprofit!=null && arr[0].fbackprofit!=""){//如果回款利润不为null,利润加上成本
						var upSql:String="update sc_order set fbackprofit="+(parseFloat(arr[0].fbackprofit)+fsum)+" where iid=(select iinvoice from sc_rdrecord where iifuncregedit=428 and iid="+ mainValue.iinvoice+")";
						AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, upSql, null, false);
					}
				}
			}, strSql, null, false);
			deleteCommandSelf.onNext();
		}
		
		/**
		 * 方法功能：服务申请单删除之前,分析是否已经派单
		 * 编写作者：YJ
		 * 创建日期：2012-04-06
		 * 更新日期：
		 */
		public function onExcute_IFun149(cmdparam:CommandParam):void {
			/*if(cmdparam.param.value.hasOwnProperty("istatus")==false || cmdparam.param.value.istatus == null) return;
			
			if(Number(cmdparam.param.value.istatus) == 1){
			
			CRMtool.tipAlert("当前单据已经被服务派工单引用,请先删除服务派工单!");
			cmdparam.excuteNextCommand = false;
			}
			if(cmdparam.param.value.hasOwnProperty("isolution") && cmdparam.param.value.isolution == 1){
			CRMtool.tipAlert("当前单据的处理方式为电话,无法删除当前服务请求单!");
			cmdparam.excuteNextCommand = false;
			}*/
			
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var value:Object = crmeap.getValue() as Object;
			
			if (crmeap.publicFlagObject["checkAlreadyhave" + value.iifuncregedit + ":" + value.iid]) {
				CRMtool.showAlert("当前单据已生单,不允许删除!");
				cmdparam.excuteNextCommand = false;
			} else {
				cmdparam.excuteNextCommand = true;
				
			}
			
			if (cmdparam.excuteNextCommand)
				deleteCommandSelf.onNext();
			
		}
		
		/**
		 * 方法功能：服务派工单修改之前,分析是否已经回访
		 * 编写作者：刘睿
		 * 创建日期：2012-04-23
		 * 更新日期：0614
		 */
		public function onExcute_IFun150(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var value:Object = crmeap.getValue() as Object;
			
			if (crmeap.publicFlagObject["checkAlreadyhave" + value.iifuncregedit + ":" + value.iid]) {
				(crmeap.paramForm as FrameCore).curButtonStatus = "onGiveUp";
				CRMtool.tipAlert("当前单据已经被服务回访单引用，不允许删除!");
				cmdparam.excuteNextCommand = false;
				return;
			}
			if (Number(value.istatus) > 1) {
				(crmeap.paramForm as FrameCore).curButtonStatus = "onGiveUp";
				CRMtool.tipAlert("当前单据已经填单，不允许删除!");
				cmdparam.excuteNextCommand = false;
				return;
			}
			
			cmdparam.excuteNextCommand = true;
			
			if (cmdparam.excuteNextCommand)
				deleteCommandSelf.onNext();
		}
		
		/**
		 * 方法功能:
		 * 编写作者：SZC
		 */
		public function onExcute_IFun428(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var value:Object = crmeap.getValue() as Object;	
			if(value.istatus==2){
				CRMtool.tipAlert("当前单据已经出库，不允许删除!");
				cmdparam.excuteNextCommand = false;
				return;
			}
			cmdparam.excuteNextCommand = true;
			if (cmdparam.excuteNextCommand)
			deleteCommandSelf.onNext();
		}
		
		
		/**
		 * 方法功能:
		 * 编写作者：lr
		 */
		public function onExcute_IFun163(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var sc_ctrpclose:ArrayCollection = cmdparam.param.value.sc_ctrpclose as ArrayCollection;
			if(crmeap.getValue().istatus==2 || crmeap.getValue().istatus==4 || crmeap.getValue().istatus==5){
				CRMtool.tipAlert("单据已审核，或者已经存在核销记录,不允许删除!");
				return;
			}
			if (sc_ctrpclose && sc_ctrpclose.length > 0) {
				
				CRMtool.tipAlert("存在已核销记录,不允许删除!");
				cmdparam.excuteNextCommand = false;
				return;
			}
			
			deleteCommandSelf.onNext();
		}
		
		/**
		 * 方法功能: 产品出库单 编辑前 校验是否生单。如果已生单，不允许修改。
		 * 编写作者：lr
		 * 删除出库单，子表信息随之修改
		 */
		public function onExcute_IFun228(cmdparam:CommandParam):void {
			
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var value:Object = crmeap.getValue() as Object;
			
			if (crmeap.publicFlagObject["checkAlreadyhave" + value.iifuncregedit + ":" + value.iid]) {
				CRMtool.showAlert("当前单据已生单,不允许删除!");
				cmdparam.excuteNextCommand = false;
			} else {
				cmdparam.excuteNextCommand = true;
			}
			
			if (cmdparam.excuteNextCommand)
				
				this.deleteStockOut(cmdparam);
			
		}
		//删除耗材出库单
		public function onExcute_IFun167(cmdparam:CommandParam):void {	
			this.deleteStockOut(cmdparam);
			
		}
		//删除出库单据的时候所执行的子表更新语句以及删除操作
		public function deleteStockOut(cmdparam:CommandParam):void {				
			var mainValue:Object = cmdparam.param.value;				
				  var sql:String="select frdquantity FROM SC_orders where iproduct in (SELECT iproduct FROM SC_rdrecords where irdrecord ="+mainValue.iid+") "
				  + " AND iorder ="+mainValue.iinvoice ;				  
				  AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
					  var ac:ArrayCollection = event.result as ArrayCollection;					  
					  if(ac!= null){	
						    var sqls:String="SELECT iproduct FROM SC_rdrecords where irdrecord ="+mainValue.iid ;
						    AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
							  var ac1:ArrayCollection = event.result as ArrayCollection;
							  var i:int;
							  var ipr:int;
							  for(i=0;i<ac1.length;i++){
							     ipr=ac1[i].iproduct;
								 if(ac[0].frdquantity!=0 && ac[0].frdquantity!=null){
									 var sql:String="update SC_orders set frdquantity ="
									 +"(select frdquantity FROM SC_orders where iproduct ="+ipr
									 + "AND iorder ="+mainValue.iinvoice+" )-"
									 + " (SELECT fquantity  FROM SC_rdrecords where irdrecord ="+mainValue.iid+" AND iinvoice ="+mainValue.iinvoice+" and iproduct="+ipr+") where iproduct="+ipr
									 + " AND iorder ="+mainValue.iinvoice;									 
									 AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, sql, null, false);
								 }		 
							  }
							  deleteCommandSelf.onNext();
						    }, sqls,null, false);					
					  }							  
				  }, sql,null, false);			
		}
		//新购
		public function onExcute_IFun162(cmdparam:CommandParam):void {
			this.checkAllow(cmdparam);
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var myValue:Object = crmeap.getValue();
			if (myValue.iinvoice && myValue.iinvoice > 0) {
				writeBack(myValue.ccode);
			}
		}
		
		//升级
		public function onExcute_IFun161(cmdparam:CommandParam):void {
			
			this.checkAllow(cmdparam);
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var myValue:Object = crmeap.getValue();
			if (myValue.iinvoice && myValue.iinvoice > 0) {
				writeBack(myValue.ccode);
			}
		}
		
		//耗材
		public function onExcute_IFun157(cmdparam:CommandParam):void {
			this.checkAllow(cmdparam);
		}
		
		//服务
		public function onExcute_IFun159(cmdparam:CommandParam):void {
			this.checkAllow(cmdparam);
		}
		//租赁
		public function onExcute_IFun462(cmdparam:CommandParam):void {
			this.checkAllow(cmdparam);
		}
		
		//培训
		public function onExcute_IFun160(cmdparam:CommandParam):void {
			this.checkAllow(cmdparam);
		}
		
		//开发
		public function onExcute_IFun210(cmdparam:CommandParam):void {
			this.checkAllow(cmdparam);
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var myValue:Object = crmeap.getValue();
			if (myValue.iinvoice && myValue.iinvoice > 0) {
				writeBack(myValue.ccode);
			}
		}
		
		//实施合同
		public function onExcute_IFun459(cmdparam:CommandParam):void {
			this.checkAllow(cmdparam);
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var myValue:Object = crmeap.getValue();
			if (myValue.iinvoice && myValue.iinvoice > 0) {
				writeBack(myValue.ccode);
			}
		}
		
		
		//lr  检查  已出库、已核销、已开票的合同 不允许删除
		private function checkAllow(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var value:Object = crmeap.getValue() as Object;
			var sc_orders:ArrayCollection = value.sc_orders as ArrayCollection;
			var sc_orders_frd:Number = 0;//产品表出库数量
			var sc_orders_fsp:Number = 0;//产品表开票数量
			
			var frpsum:Number = Number(value.frpsum);//累计回款金额   一定可用
			var frdsum:Number = Number(value.frdsum);//累计出库金额   暂时不用
			var fspsum:Number = Number(value.fspsum);//累计开票金额   要求可用
			
			for each (var item:Object in sc_orders) {
				sc_orders_frd = sc_orders_frd + Number(item.frdquantity);
				sc_orders_fsp = sc_orders_fsp + Number(item.fspquantity);
			}
			
			var str:String = "删除";
			if (frpsum && frpsum > 0) {
				CRMtool.showAlert("本合同已产生回款核销记录，不允许" + str + "。");
				(crmeap.paramForm as FrameCore).curButtonStatus = "onGiveUp";
				cmdparam.excuteNextCommand = false;
				return;
			}
			
			if ((fspsum && fspsum > 0) || sc_orders_fsp > 0) {
				CRMtool.showAlert("本合同已产生开票记录，不允许" + str + "。");
				(crmeap.paramForm as FrameCore).curButtonStatus = "onGiveUp";
				cmdparam.excuteNextCommand = false;
				return;
			}
			
			if ((frdsum && frdsum > 0) || sc_orders_frd > 0) {
				CRMtool.showAlert("本合同已产生出库记录，不允许" + str + "。");
				(crmeap.paramForm as FrameCore).curButtonStatus = "onGiveUp";
				cmdparam.excuteNextCommand = false;
				return;
			}
			
			//			onExcute_DelCTShareRate(cmdparam);
			cmdparam.excuteNextCommand = true;
			
			if (cmdparam.excuteNextCommand)
				deleteCommandSelf.onNext();
			
		}
		
		//实施变更
		public function onExcute_IFun259(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var myMainValue:Object = crmeap.getValue() as Object;
			if (myMainValue.istate == 575) {
				CRMtool.showAlert("已经提交变更，不允许删除。");
				(crmeap.paramForm as FrameCore).curButtonStatus = "onGiveUp";
				cmdparam.excuteNextCommand = false;
				return;
			}
			cmdparam.excuteNextCommand = true;
			
			if (cmdparam.excuteNextCommand)
				deleteCommandSelf.onNext();
		}
		
		/**
		 * 对应单据： 商机
		 * lr add
		 **/
		public function onExcute_IFun80(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var istatus:int = cmdparam.param.value.istatus;
			
			if (istatus == 341 || istatus == 342) {
				CRMtool.showAlert("成单或丢单状态，不允许删除。");
				(crmeap.paramForm as FrameCore).curButtonStatus = "onGiveUp";
				cmdparam.excuteNextCommand = false;
				return;
			}
			var checkSql:String = "select * from ab_invoiceprocess where ifuncregedit = 80 and iinvoice = " + cmdparam.param.value.iid;
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
				var ac:ArrayCollection = event.result as ArrayCollection;
				if(ac == null || ac.length == 0){
					if (cmdparam.param.value.iid > 0 && cmdparam.param.value.iinvoice > 0) {
						var sqls:String = " update sa_clue set istatus =  1  where iid =  " + cmdparam.param.value.iinvoice;
						AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
							
						}, sqls);
					}
					cmdparam.excuteNextCommand = true;
				}else{
					CRMtool.showAlert("单据关联相关进程，不允许删除。");
					cmdparam.excuteNextCommand = false;
					return;
				}
				if (cmdparam.excuteNextCommand)
					deleteCommandSelf.onNext();
				
			}, checkSql);
			
		}
		
		/**
		 * 对应单据： 客商资产
		 * lzx add
		 **/
		/*public function onExcute_IFun216(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			//ifuncregedit=228时不允许删除
			var ifuncregedit:int = cmdparam.param.value.ifuncregedit;
			var productboms:ArrayCollection = new ArrayCollection();
			if (cmdparam.param.value.cs_custproducts.length > 0) {
				productboms = cmdparam.param.value.cs_custproducts;
			}
			
			if(productboms.length==0){
				deleteCommandSelf.onNext();
				return;
			}
			
			var sql:String = "";
			var iids:String = "";
			for (var i:int = 0; i < productboms.length; i++) {
				if (productboms[i].iid) {
					iids += productboms[i].iid + ",";
				}
			}
			iids = iids.substr(0, iids.length - 1);
			sql = "cs_custproducts.iid in(" + iids + ")";
			
			*//*if (ifuncregedit == 228) {
				AccessUtil.remoteCallJava("GetCcodeDest", "getRdrecordCcode", function (e:ResultEvent):void {
					var res:ArrayCollection = e.result as ArrayCollection;
					var middle:String = "";
					for (var i:int = 0; i < res.length; i++) {
						middle += res[i].ccode.toString() + ",";
					}
					middle = middle.substr(0, middle.length - 1);
					CRMtool.showAlert("请撤销单据号为：" + middle + "的出库单后再进行删除操作！");
				}, sql);
				(crmeap.paramForm as FrameCore).curButtonStatus = "onGiveUp";
				cmdparam.excuteNextCommand = false;
				return;
			} else*//*
				deleteCommandSelf.onNext();
		}*/
		
		/**
		 * 合同回写线索状态
		 * 创建人:王炫皓
		 * 创建时间：20121118
		 * */
		public function writeBack(ccode:String):void {
			var sql:String = "select iid,ifuncregedit,iinvoice,itype,ccode,cname,ccustomer,icustomer,iifuncregedit from sa_clue where iid = (select iinvoice from sa_opportunity where iid =(select iinvoice from sc_order where ccode='" + ccode + "'))";
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
				var saclue:ArrayCollection = event.result as ArrayCollection;
				if (saclue && saclue.length > 0) {
					if (saclue[0].iid) {
						var updatesql:String = "update sa_clue set istatus = 2  where iid = " + saclue[0].iid;
						AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
						}, updatesql);
					}
				}
			}, sql);
		}
		
		/**
		 * 物料借用删除前判断归还数量是否大于0  >0 不能删除
		 * 创建人：王炫皓
		 * 创建时间：20130219
		 * */
		public function onExcute_IFun348(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var myMainValue:Object = crmeap.getValue() as Object;
			if (myMainValue.sc_rdrecords) {
				for each (var rdrecord:Object in myMainValue.sc_rdrecords) {
					if (Number(rdrecord.fwoquantity) > 0) {
						CRMtool.showAlert("已经产生归还不允许删除");
						return;
					}
				}
			}
			deleteCommandSelf.onNext();
		}
		
		//实施交接
		public function onExcute_IFun200(cmdparam:CommandParam):void {
			
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var value:Object = crmeap.getValue() as Object;
			
			if(value.iid>0){
				var sql:String = "select iid from sr_project where ifuncregedit = 200 and iinvoice="+value.iid;
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
					var ac:ArrayCollection = event.result as ArrayCollection;
					if(ac&&ac.length>0){
						CRMtool.showAlert("已经生成下游单据，不允许删除。");
					}else{
						deleteCommandSelf.onNext();
					}
				}, sql);
			}
			
			
			/*if (crmeap.publicFlagObject["checkAlreadyhave" + value.iifuncregedit + ":" + value.iid]) {
			CRMtool.showAlert("当前单据已生单,不允许删除!");
			cmdparam.excuteNextCommand = false;
			} else {
			cmdparam.excuteNextCommand = true;
			}
			
			if (cmdparam.excuteNextCommand)
			deleteCommandSelf.onNext();*/
			
		}
		
		/**
		 * 方法功能：收费单不是完工状态不允许删除单据
		 * 编写作者：李宁
		 * 创建日期：2014-04-01
		 */
		public function onExcute_IFun390(cmdparam:CommandParam):void
		{
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var myMainValue:Object =crmeap.getValue() as Object;
			var iid:int = myMainValue.iid;
			if (!(iid > 0))
				return;
			var sql:String = "select istatus from tr_charge where iid = " + iid;
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
				var list:ArrayCollection = event.result as ArrayCollection;
				if (list && list.length > 0) {
					var istatus:int = list[0].istatus;
					if (istatus > 1) {
						cmdparam.excuteNextCommand=false;
						CRMtool.showAlert("非完工状态下的收费单不允许删除操作！");
						return;
					}else {
						deleteCommandSelf.onNext();
					}
				} else {
					CRMtool.showAlert("数据有误，请检查！");
				}
			}, sql);
			
		}
		/**
		 * 发票不是未使用状态不允许删除单据
		 * 创建人：杨政伟
		 * 创建时间：2014-04-02
		 */
		public function onExcute_IFun391(cmdparam:CommandParam):void{
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var myMainValue:Object =crmeap.getValue() as Object;
			
			if(myMainValue.istatus > 0) {
				cmdparam.excuteNextCommand=false;
				CRMtool.showAlert("发票非未使用状态，不允许删除操作！");
				return;
			} else {
				deleteCommandSelf.onNext();
			}
			
		}
		/**
		 * 项目需求关联计划不能删除
		 * 创建人：SZC
		 * 创建时间：2015-02-27
		 */
		public function onExcute_IFun445(cmdparam:CommandParam):void{
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var myMainValue:Object =crmeap.getValue() as Object;
			var sql:String="select count(*) iinvoice  from sr_projectjob where iinvoice="+myMainValue.iid;
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
				var ac:ArrayCollection=event.result as ArrayCollection;
				if(ac[0].iinvoice==0 ){
					deleteCommandSelf.onNext();
				}else{
					CRMtool.tipAlert("该单据被项目计划引用，不允许删除操作！");
					return;
				}
			},sql);
		}
		/**
		 * 项目计划关联开发任务不能删除
		 * 创建人：SZC
		 * 创建时间：2015-02-27
		 */
		public function onExcute_IFun446(cmdparam:CommandParam):void{
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var myMainValue:Object =crmeap.getValue() as Object;
			var sql:String="select count(*) iinvoice  from sr_projecttask where iinvoice="+myMainValue.iid;
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
				var ac:ArrayCollection=event.result as ArrayCollection;
				if(ac[0].iinvoice==0 ){
					deleteCommandSelf.onNext();
				}else{
					CRMtool.tipAlert("该单据被开发任务引用，不允许删除操作！");
					return;
				}
			},sql);
		}
		/**
		 * 计划任务关联测试不能删除
		 * 创建人：SZC
		 * 创建时间：2015-02-27
		 */
		public function onExcute_IFun452(cmdparam:CommandParam):void{
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var myMainValue:Object =crmeap.getValue() as Object;
			var sql:String="select count(*) iinvoice from sr_projecttest where iinvoice="+myMainValue.iid;
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
				var ac:ArrayCollection=event.result as ArrayCollection;
				if(ac[0].iinvoice==0 ){
					deleteCommandSelf.onNext();
				}else{
					CRMtool.tipAlert("该单据被项目测试引用，不允许删除操作！");
					return;
				}
			},sql);
		}
		//实施日志
		/**
		 * 实施日期删除前保村iproject的值
		 * 创建人：李宁
		 * 创建时间：2014-04-016
		 */
		public function onExcute_IFun220(cmdparam:CommandParam):void {
			
			/*var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var obj:Object = crmeap.getValue();
			var iid:int = obj.iid;
			
			var sql:String = "select iproject from sr_projects where iid = "+ iid;
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
				var ac:ArrayCollection = event.result as ArrayCollection;
				if(ac&&ac.length>0){
					obj.publicFlagObject = ac[0].iproject;
				}		
				deleteCommandSelf.onNext();	
				
			}, sql);
			
			cmdparam.excuteNextCommand = true;*/
            var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
            var obj:Object = crmeap.getValue();
             var sql:String="update sr_project set ffact=ffact-"+parseFloat(obj.fworkday)+"  where iid="+obj.iproject;

            AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
                deleteCommandSelf.onNext();
            },sql);
                cmdparam.excuteNextCommand = true;
			
		}
		/**
		 * 方法功能:调拨单生成其他入库不允许删除
		 * 编写作者：SZC
		 */
		public function onExcute_IFun174(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var value:Object = crmeap.getValue() as Object;	
			if(value.ifuncregedit==477){
				CRMtool.tipAlert("当前单据是调拨单生成，不允许删除!");
				cmdparam.excuteNextCommand = false;
				return;
			}else{
		     	cmdparam.excuteNextCommand = true;
			}
			if(cmdparam.excuteNextCommand){
				deleteCommandSelf.onNext();
			}
		}
		
		/**
		 * 方法功能:调拨单生成其他出库不允许删除
		 * 编写作者：SZC
		 */
		public function onExcute_IFun175(cmdparam:CommandParam):void {
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var value:Object = crmeap.getValue() as Object;	
			if(value.ifuncregedit==477){
				CRMtool.tipAlert("当前单据是调拨单生成，不允许删除!");
				cmdparam.excuteNextCommand = false;
				return;
			}else{
				cmdparam.excuteNextCommand = true;
			}
			if(cmdparam.excuteNextCommand){
				deleteCommandSelf.onNext();
			}
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
					CRMtool.tipAlert("单据已审核，不允许删除!");
					cmdparam.excuteNextCommand = false;
					return;
				}else{
					cmdparam.excuteNextCommand = true;
					deleteCommandSelf.onNext();
				}
			},sql);
		}
		
		/**
		 * 入库的产品被新购合同或者升级合同引用就不能删除
		 * 创建人：施则成
		 * 创建时间：2014-04-016
		 */
		public function onExcute_IFun231(cmdparam:CommandParam):void{
			var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
			var mainValue:Object = crmeap.getValue();
			var iid:int = mainValue.iid;
			var rdrecord :ArrayCollection=mainValue.sc_rdrecords as ArrayCollection;
			for each(var eventAc:Object in rdrecord){
				var sql:String ="select COUNT(sc_orders.csn) csnCount1,COUNT(sc_rdrecords.csn) csnCount2 from sc_orders left join sc_rdrecords  on sc_orders.iorder=sc_rdrecords.iinvoice where sc_orders.csn= '"+eventAc.csn+"' or sc_rdrecords.csn='"+eventAc.csn+"'";
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
					var ac:ArrayCollection = event.result as ArrayCollection;
					if(ac.length>0){
						if(ac[0].csnCount1>0 || ac[0].csnCount2>0){
							CRMtool.showAlert("该单据被引用，不允许删除操作！");
							return;
						} else{
							cmdparam.param.mainValue = mainValue;
							deleteCommandSelf.onNext();
						}
					}else{
						cmdparam.param.mainValue = mainValue;
						deleteCommandSelf.onNext();
					}		
				}, sql);
			}
			if(rdrecord.length==0){
				deleteCommandSelf.onNext();
			}
			
		}
		
		
	}
}