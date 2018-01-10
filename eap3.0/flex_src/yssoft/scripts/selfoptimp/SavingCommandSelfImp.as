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
import yssoft.models.CRMmodel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.vos.CommandParam;

public class SavingCommandSelfImp {
    public function SavingCommandSelfImp() {
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
     * 对应单据： 产品升级
     * lr add
     **/
    public function onExcute_IFun161(cmdparam:CommandParam):void {
        var iid:int = cmdparam.param.value.iid;
        var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
        var myValue:Object = crmeap.getValue();
        if (iid != 0) {
            var sc_orders2:ArrayCollection = cmdparam.param.value.sc_orders2 as ArrayCollection;
            for each(var o:Object in sc_orders2) {
                o.iorder = iid;
            }
            AccessUtil.remoteCallJava("customerDest", "updateCsProduct", null, sc_orders2, null, false);
        }
        orderSaveUpdateOpportunity(cmdparam);
        cmdparam.excuteNextCommand = true;

    }

    /**
     * 对应单据： 产品新购
     * lr add
     **/
    public function onExcute_IFun162(cmdparam:CommandParam):void {
        orderSaveUpdateOpportunity(cmdparam);
        cmdparam.excuteNextCommand = true;

    }

    /**
     * 对应单据： 开发合同
     * lr add
     **/
    public function onExcute_IFun210(cmdparam:CommandParam):void {
        orderSaveUpdateOpportunity(cmdparam);
        cmdparam.excuteNextCommand = true;

    }
	//实施合同
	public function onExcute_IFun459(cmdparam:CommandParam):void {
		orderSaveUpdateOpportunity(cmdparam);
		cmdparam.excuteNextCommand = true;
		
	}

    private function orderSaveUpdateOpportunity(cmdparam:CommandParam):void {
        var iid:int = cmdparam.param.value.iid;
        var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
        var myValue:Object = crmeap.getValue();
        if (iid != 0 && cmdparam.optType == "onNew") {
            var ifuncregedit:int = myValue.ifuncregedit;
            if (ifuncregedit == 80 && myValue.iinvoice) {

                AccessUtil.remoteCallJava("customerDest", "orderSaveUpdateOpportunity", null, {dfact: myValue.ddate, ffact: myValue.fsum, iid: myValue.iinvoice, ddate: CRMtool.getNowDateHNS(), imaker: CRMmodel.userId}, null, false);
            }
//				onExcute_CTShareRate(cmdparam);
        }
		//修改合同后，更改销售商机的实际成交金额
		if (iid != 0 && cmdparam.optType == "onEdit") {
			var ifuncregedit:int = myValue.ifuncregedit;
			if (ifuncregedit == 80 && myValue.iinvoice) {
				
				AccessUtil.remoteCallJava("customerDest", "updateOrderSaveUpdateOpportunity", null, { ffact: myValue.fsum, iid: myValue.iinvoice,dfact: myValue.ddate}, null, false);
			}
		}
		//end
        onExcute_CTShareRate(cmdparam);

    }

    /**
     * 对应单据： 日志
     * lr add
     **/
    public function onExcute_IFun46(cmdparam:CommandParam):void {
        var iid:int = cmdparam.param.value.iid;
        var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;
        var myValue:Object = crmeap.getValue();
        if (iid != 0) {
            var iplans:int = myValue.iplans;
            if (iplans > 0) {
                var sql:String = "update oa_workplan set istatus=619 ,cfeedback='" + myValue.cname + "' where iid=" + iplans;
                AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
                }, sql);
            }
        }
        cmdparam.excuteNextCommand = true;

    }

    /**
     * 方法功能：客户联系人保存 如果是主联系人,则更新客户档案表 的主联系人字段为此表的
     * 编写作者：lr
     * 创建日期：2012-5-11
     * 更新日期：
     */
    public function onExcute_IFun45(cmdparam:CommandParam):void {
        var iid:int = cmdparam.param.value.iid;
        var icustomer:int = cmdparam.param.value.icustomer;
        var bkeycontect:int = cmdparam.param.value.bkeycontect;
        var cname:String = cmdparam.param.value.cname;

        if (icustomer > 0 && bkeycontect == 1) {//此表单是主联系人
            AccessUtil.remoteCallJava("customerDest", "updateCustMainPerson", null, {"iid": iid, "cname": cname, "icustomer": icustomer});
        }

        cmdparam.excuteNextCommand = true;
    }

    /**
     * 方法功能：服务工单保存时，判断，如果是呼叫中心生成单据，则更新其状态记录，同时写入制单人制单时间
     * 编写作者：lr
     * 创建日期：2012-6-4
     * 更新日期：
     */
    public function onExcute_IFun150(cmdparam:CommandParam):void {
        var iid:int = cmdparam.param.value.iid;
        var ifuncregedit:int = cmdparam.param.value.ifuncregedit;
        var iinvoice:int = cmdparam.param.value.iinvoice;
        var isolution:int = cmdparam.param.value.isolution;

        if (ifuncregedit && ifuncregedit == 153 && iinvoice) {
            if (isolution) {
                var pparam:Object = new Object();
                pparam.cciid = iinvoice;
                switch (isolution) {
                    case 368://"电话":
                    {
                        pparam.isolution = 1;
                        break;
                    }
                    case 369://"远程":
                    {
                        pparam.isolution = 2;
                        break;
                    }
                    case 370://"现场":
                    {
                        pparam.isolution = 3;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                pparam.imaker = CRMmodel.userId;
                pparam.dmaker = CRMtool.getFormatDateString();
                AccessUtil.remoteCallJava("CallCenterDest", "updatesolution", null, pparam, null, false);
            }
        }

        if (ifuncregedit && ifuncregedit == 150 && iinvoice) {
            var pparam:Object = new Object();
            pparam.iid = iinvoice;
            pparam.iclose = CRMmodel.userId;
            pparam.dclose = CRMtool.getFormatDateString();
            pparam.istatus = 4;
            AccessUtil.remoteCallJava("SrBillDest", "updateDataForClose", null, pparam);
        }

        cmdparam.excuteNextCommand = true;
    }


    public function onExcute_IFun62(cmdparam:CommandParam):void {
        var ifuncregedit:int = cmdparam.param.value.ifuncregedit;
        var iinvoice:int = cmdparam.param.value.iinvoice;

        if (ifuncregedit && ifuncregedit == 153 && iinvoice) {
            var pparam:Object = new Object();
            pparam.cciid = iinvoice;
            pparam.isolution = 6;

            pparam.imaker = CRMmodel.userId;
            pparam.dmaker = CRMtool.getFormatDateString();
            AccessUtil.remoteCallJava("CallCenterDest", "updatesolution", null, pparam, null, false);
        }
        cmdparam.excuteNextCommand = true;
    }

    /**
     * 方法功能：服务费合同保存时 更新相应客商资产的数据
     * 编写作者：lr
     * 创建日期：2012-5-11
     * 更新日期：
     */
    public function onExcute_IFun159(cmdparam:CommandParam):void {
        var iid:int = cmdparam.param.value.iid;

        var ddate:Object = cmdparam.param.value.ddate;//合同日期
        var dsend:Object = cmdparam.param.value.dsend;//截止日期

        var icustperson:int = cmdparam.param.value.icustperson//客户人员
        var iperson:int = cmdparam.param.value.iperson//销售人员

        var imaker:int = cmdparam.param.value.imaker;//制单人
        var dmaker:Object = cmdparam.param.value.dmaker;//制单时间
        var igroupservices:int=cmdparam.param.value.igroupservices;
		var dgroupend:Object=cmdparam.param.value.dgroupend;
        var sc_orders:ArrayCollection = cmdparam.param.value.sc_orders as ArrayCollection;//收费项目
        var sc_orders2:ArrayCollection = cmdparam.param.value.sc_orders2 as ArrayCollection;//对应客户资产

        var iproduct:int = 0;//收费产品中的第一条记录
        if (sc_orders && sc_orders.length > 0) {
            var obj:Object = sc_orders.getItemAt(0);
            iproduct = obj.iproduct;
        }

        var parm:Object = new Object();

        parm.iscstatus = 510; //服务收费状态
        parm.irefuse = 0; //超期未交费原因

        parm.ddate = ddate;
        parm.dsend = dsend;
        parm.icustperson = icustperson;
        parm.iperson = iperson;
        parm.iproduct = iproduct;
		parm.igroupservices=igroupservices;//集团服务类型
		parm.dgroupend=dgroupend;//集团服务截止时间
        parm.sc_orders2 = sc_orders2;
        if (iid != 0 && cmdparam.optType == "onNew") {
            if (sc_orders2 != null && sc_orders2.length > 0) {
                AccessUtil.remoteCallJava("customerDest", "updateCsProductWithOrder", null, parm, null, false);
            }
        }

        orderSaveUpdateOpportunity(cmdparam);
        cmdparam.excuteNextCommand = true;
    }

    /**
     * 功能：新增合同时，往订单业绩分配表中插入一条记录，计算比例为1
     * 作者:XZQWJ
     * 创建时间:2012-10-16
     *
     * */
    public function onExcute_CTShareRate(cmdparam:CommandParam):void {
        var iid:int = cmdparam.param.value.iid;
        var iperson:int = cmdparam.param.value.iperson//销售人员
        var idepartment:int = cmdparam.param.value.idepartment//销售人员
        var imaker:int = CRMmodel.userId;//当前登录人iid
        var curr:String = CRMtool.getNowDateHNS();
        var crmeap:CrmEapRadianVbox = cmdparam.context as CrmEapRadianVbox;

        if (cmdparam.optType == "onNew") {
            var iifuncregedit:int = cmdparam.param.value.iifuncregedit;
            if (iifuncregedit > 0) {
                var sql:String = "select * from sc_apportionsets ss left join sc_apportioncf sf on sf.iapportionset = ss.iapportionset " +
                        "where sf.iordertp = " + iifuncregedit;
                AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
                    var ac:ArrayCollection = event.result as ArrayCollection;
                    if (ac && ac.length > 0) {
                        var sql:String = "select idepartment from hr_person where iid = " + cmdparam.param.value.imaker;
                        AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
                            var iac:ArrayCollection = event.result as ArrayCollection;
                            if (iac && iac.length > 0) {
                                var imakerdepartment:int = iac[0].idepartment;

                                var insql:String = "";
                                for each(var item:Object in ac) {
                                    var iidepartment:int;
                                    var cdepartment:String = item.cdepartment;
                                    var iiperson:int;
                                    var cperson:String = item.cperson;
                                    if (CRMtool.isStringNotNull(cdepartment)) {
                                        switch (cdepartment) {
                                            case "idepartment":
                                                iidepartment = idepartment;
                                                break;
                                            case "myidepartment":
                                                iidepartment = CRMmodel.hrperson.idepartment;
                                                break;
                                            case "imakerdepartment":
                                                iidepartment = imakerdepartment;
                                                break;
                                        }
                                    }

                                    if (item.idepartment > 0) {
                                        iidepartment = item.idepartment;
                                    }

                                    if (CRMtool.isStringNotNull(cperson)) {
                                        switch (cperson) {
                                            case "iperson":
                                                iiperson = iperson;
                                                break;
                                            case "myiid":
                                                iiperson = CRMmodel.userId;
                                                break;
                                            case "imaker":
                                                iiperson = cmdparam.param.value.imaker;
                                                break;
                                        }
                                    }

                                    if (item.iperson > 0) {
                                        iiperson = item.iperson;
                                    }

                                    var crole:String;
                                    if (CRMtool.isStringNull(item.crole))
                                        crole = "";
                                    else
                                        crole = item.crole;

                                    var cdetail:String;
                                    if (CRMtool.isStringNull(item.cdetail))
                                        cdetail = "";
                                    else
                                        cdetail = item.cdetail;

                                    insql += "insert into sc_orderapportion(iorder,idepartment,iperson,crole,cdetail,fpercent,imaker,dmaker) values(" + iid + "," + iidepartment + "," + iiperson + ",'" + crole + "','" + cdetail + "'," + item.fpercent + "," + imaker + ",'" + curr + "')   ";

                                }

                                if (CRMtool.isStringNotNull(insql)) {
                                    AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
                                        crmeap.queryPm(iid + "");
                                        crmeap.addEventListener("queryComplete", myqueryPmBack);

                                        function myqueryPmBack():void {
                                            if (ac[0].bshow == 1) {//弹出业绩分摊
                                                (crmeap.paramForm as FrameCore).openCTShareRatePage();
                                            }
                                            crmeap.removeEventListener("queryComplete", myqueryPmBack);
                                        }

                                    }, insql, null, false);
                                }
                            }

                        }, sql, null, false);
                    } else {
                        var sql1:String = "insert into sc_orderapportion(iorder,idepartment,iperson,crole,cdetail,fpercent,imaker,dmaker) values(" + iid + "," + idepartment + "," + iperson + ",'','',1," + imaker + ",'" + curr + "')";
                        AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
                            crmeap.queryPm(iid + "");
                        }, sql1, null, false);
                    }
                }, sql, null, false);
            }


        } else if (cmdparam.optType == "onEdit") {
            //sql="update sc_orderapportion set idepartment="+idepartment+",iperson="+iperson+" where iorder="+iid;
        }


    }

    //耗材合同
    public function onExcute_IFun157(cmdparam:CommandParam):void {
        orderSaveUpdateOpportunity(cmdparam);
        cmdparam.excuteNextCommand = true;
    }

    //培训合同
    public function onExcute_IFun160(cmdparam:CommandParam):void {
        onExcute_CTShareRate(cmdparam);
        cmdparam.excuteNextCommand = true;
    }

    //其他合同
    public function onExcute_IFun330(cmdparam:CommandParam):void {
        onExcute_CTShareRate(cmdparam);
        cmdparam.excuteNextCommand = true;
    }
}
}