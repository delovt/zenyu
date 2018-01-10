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
import mx.rpc.events.ResultEvent;

import yssoft.business.SrBillHandleClass;
import yssoft.comps.frame.module.CrmEapRadianVbox;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.vos.CommandParam;

public class DeleteAfterCommandSelfImp {
    public function DeleteAfterCommandSelfImp() {
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
     * 方法功能：服务工单删除后更新服务请求单状态
     * 编写作者：YJ
     * 创建日期：2012-04-06
     * 更新日期：
     */
    public function onExcute_IFun150(cmdparam:CommandParam):void {
        try {
            var iid:int = cmdparam.param.value.iid;
            var ifuncregedit:int = cmdparam.param.value.ifuncregedit;
            var iinvoice:int = cmdparam.param.value.iinvoice;

            if (iid != 0) {
                if (ifuncregedit == 153 && iinvoice > 0) {
                    AccessUtil.remoteCallJava("CallCenterDest", "updateCallcenterIsolution", null, {ccid: iinvoice, isolution: 0});
                }
                if (ifuncregedit == 149 && iinvoice > 0) {
                    var sbhc:SrBillHandleClass = new SrBillHandleClass();
                    sbhc.iinvoice = Number(cmdparam.param.value.iinvoice);
                    sbhc.istatus = 0;
                    sbhc.onUpdateSrRequestStatus();
                }
            }
        } catch (err:Error) {
            cmdparam.excuteNextCommand = false;//终止操作
            CRMtool.tipAlert("更新服务申请单状态失败! 原因:" + err.message);
        }
    }

    /**
     * 方法功能：客户档案删除联系人子表后，同时删除ab_invoiceuser权限表中对应的负责人记录
     * 编写作者：刘磊
     * 创建日期：2012-04-12
     * 更新日期：2012-04-12
     */
    public function onExcute_IFun44(cmdparam:CommandParam):void {
        try {
            var CS_custperson:ArrayCollection = cmdparam.param.value.CS_custperson as ArrayCollection;
            var delsql:String = "";
            if (CS_custperson != null && CS_custperson.length > 0) {
                for each (var item:Object in CS_custperson) {
                    delsql = delsql + "delete from ab_invoiceuser where ifuncregedit=" + item.iifuncregedit + " and iinvoice=" + item.iid + ";";
                }
                AccessUtil.remoteCallJava("hrPersonDest", "updateSql", null, delsql, null, false);
            }
            else {
                cmdparam.excuteNextCommand = true;
            }
        }
        catch (err:Error) {
            cmdparam.excuteNextCommand = false;//终止操作
            CRMtool.tipAlert("客商人员资料权限表删除失败! 原因:" + err.message);
        }
    }

    /**
     * 对应单据： 产品新购
     * lr add
     **/
    public function onExcute_IFun162(cmdparam:CommandParam):void {
        orderDeleteUpdateOpportunity(cmdparam);
        onExcute_DelCTShareRate(cmdparam);
        cmdparam.excuteNextCommand = true;

    }

    /**
     * 对应单据： 产品升级
     * lr add
     **/
    public function onExcute_IFun161(cmdparam:CommandParam):void {
        orderDeleteUpdateOpportunity(cmdparam);
        onExcute_DelCTShareRate(cmdparam);
        cmdparam.excuteNextCommand = true;
    }

    /**
     * 对应单据： 开发合同
     * lr add
     **/
    public function onExcute_IFun210(cmdparam:CommandParam):void {
        orderDeleteUpdateOpportunity(cmdparam);
        onExcute_DelCTShareRate(cmdparam);
        cmdparam.excuteNextCommand = true;
    }
    
	//实施合同
	public function onExcute_IFun459(cmdparam:CommandParam):void {
		orderDeleteUpdateOpportunity(cmdparam);
		onExcute_DelCTShareRate(cmdparam);
		cmdparam.excuteNextCommand = true;
	}

    /**
     * 对应单据： 服务费合同
     * lr add
     **/
    public function onExcute_IFun159(cmdparam:CommandParam):void {
        orderDeleteUpdateOpportunity(cmdparam);
        onExcute_DelCTShareRate(cmdparam);
        cmdparam.excuteNextCommand = true;
    }
	/**
	 * 对应单据：租赁合同
	 **/
	public function onExcute_IFun462(cmdparam:CommandParam):void {
		orderDeleteUpdateOpportunity(cmdparam);
		onExcute_DelCTShareRate(cmdparam);
		cmdparam.excuteNextCommand = true;
	}


    private function orderDeleteUpdateOpportunity(cmdparam:CommandParam):void {
        var iid:int = cmdparam.param.value.iid;
        var ifuncregedit:int = cmdparam.param.value.ifuncregedit;
        var iinvoice:int = cmdparam.param.value.iinvoice;
        if (iid != 0) {
            if (ifuncregedit == 80 && iinvoice > 0) {
                var sql:String = "update sa_opportunity set istatus=340,dfact=null,ffact=" + 0 + " where iid=" + iinvoice;
                AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
                }, sql);
            }
        }
    }

    /**
     * 对应单据： 日志
     * lr add
     **/
    public function onExcute_IFun46(cmdparam:CommandParam):void {
        var iid:int = cmdparam.param.value.iid;
        var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
        var iplans:int = cmdparam.param.value.iplans;
        var ifuncregedit:int = cmdparam.param.value.ifuncregedit;
        if (iid != 0) {
            if (iplans > 0) {
                var sql:String = "update oa_workplan set istatus=620,cfeedback='' where iid=" + iplans;
                AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
                }, sql);
            }

            var mysql:String = "delete as_communication where itype=13 and ifuncregedit=46 and iinvoice=" + iid;
            AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, mysql, null, false);
        }
        cmdparam.excuteNextCommand = true;

    }

    //培训合同
    public function onExcute_IFun160(cmdparam:CommandParam):void {
        onExcute_DelCTShareRate(cmdparam);
        cmdparam.excuteNextCommand = true;
    }

    //耗材合同
    public function onExcute_IFun157(cmdparam:CommandParam):void {
        onExcute_DelCTShareRate(cmdparam);
        cmdparam.excuteNextCommand = true;
    }

    /**
     * 功能：删除合同时，同时删除业绩分摊表中对应的信息
     * 作者:XZQWJ
     * 创建时间:2012-10-20
     * */
    public function onExcute_DelCTShareRate(cmdparam:CommandParam):void {
        var iid:int = cmdparam.param.value.iid;
        var sql:String = "delete sc_orderapportion where iorder=" + iid + " delete sc_orderapportions where iorder=" + iid;
        AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
        }, sql);
    }

    //客商计划
    public function onExcute_IFun35(cmdparam:CommandParam):void {
        var iid:int = cmdparam.param.value.iid;
        if (iid != 0) {
            var mysql:String = "delete as_communication where itype=12 and ifuncregedit=35 and iinvoice=" + iid;
            AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, mysql, null, false);
        }

    }
	
	/**
	 * 方法功能：收费单删除后，更新发票状态，插入发票轨迹
	 * 编写作者：李宁
	 * 创建日期：2014-04-01
	 */
	public function onExcute_IFun390(cmdparam:CommandParam):void {
		var mainValue:Object = cmdparam.param.value;
		
		var iid:int = mainValue.iinvoice;
		var iperson:int = mainValue.iperson;
		var icustomer:int = mainValue.icustomer;
		var imaker:int = mainValue.imaker;
		var dmaker:String = mainValue.dmaker;
		
		//发票主表状态变为2待核销  并插入一条发票轨迹记录
		var sql:String = "update tr_invoice set istatus = 1 where iid= "+ iid +" and istatus=2;";
		sql += "insert into tr_invoices"
			+" select tr_invoice.iinvoice,tr_invoice.iid,1,tr_invoice.iperson,"+icustomer+","+imaker+",getdate(),isnull(cmemo,'')+'（收费单已删除）' "
			+" from tr_invoice where iid = "+ iid;
		
		
		AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, sql, null, false);
		
	}
	
	/**
	 * 方法功能：服务回访单删除后，还原最后一次服务日期
	 * 编写作者：李宁
	 * 创建日期：2014-04-02
	 */
	public function onExcute_IFun154(cmdparam:CommandParam):void {
		var mainValue:Object = cmdparam.param.value;
		
		var icustomer:int = mainValue.icustomer;
		//获取删除后最后一次服务回访日期
		var sql:String = "select * from (select convert(varchar(10),MAX(ddate),23) ddate from SR_feedback where icustomer = "+ icustomer +")a where isnull(a.ddate,'')<>'' ";
		AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
			
			var list:ArrayCollection = event.result as ArrayCollection;
			if (list && list.length > 0) {
				var ddate:String = String(list[0].ddate);
				
				var sqlupdate:String = "update cs_customer set dlastfeedbackdate = '"+ ddate +"' where iid= "+ icustomer;
				
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, sqlupdate, null, false);
			}
			
		}, sql);
		
	}
	
	
    /**
     * 批量录入删除发票子表信息
     * 创建人：杨政伟
     * 创建时间：2014-04-011
     */
    public function onExcute_IFun394(cmdparam:CommandParam):void{
        var mainValue:Object = cmdparam.param.value;
        var iid:int = mainValue.iid;
        var sql:String = "delete tr_invoices where itrrule = " + iid;
        AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, sql, null, false);
    }
	public function onExcute_IFun231(cmdparam:CommandParam):void{
	//	var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
//		var mainValue:Object = crmeap.getValue();
		var mainValue:Object = cmdparam.param.mainValue;
		if(mainValue.iinvoice==0)
			return;
		//20150317
			var strSql1:String="select iid,iproduct,fquantity from sc_orders where iorder="+mainValue.iinvoice;
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
							var upSql1:String="update sc_orders set fcostprice=(fcostprice-"+ac[i].fprice+"),fcost=(fcost-"+fcost+")  where iid="+asc[j].iid;
							AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null,upSql1, null, false);
						}
					}
				}
				var sql2:String="select fsum,forderprofit,fbackprofit,fcost from sc_order where iid="+mainValue.iinvoice;
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
					var aclist:ArrayCollection=e.result as  ArrayCollection;
					var obj:Object=new Object();
					obj.asc=asc;
					obj.ac=ac;
					obj.aclist=aclist;
					obj.iinvoice=mainValue.iinvoice;
					obj.optType="onDelete";
					AccessUtil.remoteCallJava("UtilViewDest", "updateOrderFsum", null,obj);
				},sql2);
			}, strSql1);
			//
		
	}
	
	//实施日志
	/**
	 * 实施日志删除时更新实施管理中的实际天数
	 * 创建人：李宁
	 * 创建时间：2014-04-016
	 */
	/*public function onExcute_IFun220(cmdparam:CommandParam):void {
		
		
		var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
		var obj:Object = crmeap.getValue();
		var objparam:Object = {};
		objparam.iproject = obj.iproject;
		objparam.resetFlag = true;
		
		AccessUtil.remoteCallJava("projectDest", "updateSrProjectFfact", function (evt:ResultEvent):void {
			
		}, objparam);
		
		cmdparam.excuteNextCommand = true;
		
	}*/

}

}
