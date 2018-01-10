package yssoft.frameui.formopt {
import flash.events.Event;
import flash.events.EventDispatcher;

import mx.collections.ArrayCollection;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;

import yssoft.evts.onItemDoubleClick;
import yssoft.models.CRMmodel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;

public class OperDataAuth extends EventDispatcher {
    //容器变量  lr modify  已改为自己抛出事件
    //public var container:Container;

    //除无权限外的数据权限提示的操作权限id
    public var noEditOperid:String;
    public var noDelOperid:String;

    //工作流权限提示的操作权限id
    public var noFlowEditOperid:String;
    public var noFlowDelOperid:String;

    //当前操作权限id
    public var curoperid1:String;
    public var curoperid2:String;

    //当前页面相关注册内码
    [Bindable]
    public var outifuncregedit:int;

    //角色操作权限
    [Bindable]
    public var operauthArr:ArrayCollection;
    //人员操作权限
    [Bindable]
    public var operauthPersonArr:ArrayCollection;

    //角色数据权限
    [Bindable]
    public var dataauthArr:ArrayCollection;
    //人员数据权限
    [Bindable]
    public var dataauthPersonArr:ArrayCollection;

    //相关表信息
    [Bindable]
    public var delinfoArr:ArrayCollection;

    //允许批量删除的单据内码
    [Bindable]
    public var allowdelArr:ArrayCollection;

    private var authReturnFlag:Boolean = false;

    /**
     * 模块说明：获得当前页面相关注册内码
     * 创建人：刘磊
     * 创建日期：2011-10-14
     * 修改人：
     * 修改日期：
     *
     */
    public function get_ifuncregedit(iid:int):void {
        AccessUtil.remoteCallJava("funauthViewDest", "get_ifuncregedit", get_ifuncregeditCallBack, iid, null, false);
    }

    public function get_ifuncregeditCallBack(evt:ResultEvent):void {
        outifuncregedit = Number(evt.result.toString());
        //			container.dispatchEvent(new Event("onGet_ifuncregeditSucess"));
        this.dispatchEvent(new Event("onGet_ifuncregeditSucess"));
        authReturnFlag = true;
    }

    /**
     * 模块说明：当前操作operid是否具有权限，无权限返回提示信息，有权限返回null
     * 创建人：刘磊
     * 创建日期：2011-10-14
     * 修改人：
     * 修改日期：
     *
     */
    public function reuturnwarning(operid:String):String {

        var warning:String = null;
        if (CRMmodel.userId == 1)
            return warning;

        var find:Boolean = false;
        var flag:Boolean = false;//用于先判断角色权限里有没有，如果有不查询人员权限
        for each (var item:Object in operauthArr) {
            if (item.operid == operid) {
                if (String(item.benable) != "1") {
                    flag = true;
                    //warning = "您无" + item.ccaption + "的操作权限！";
                }
                find = true;
                break;
            }
        }
        if(flag){
            for each (var item:Object in operauthPersonArr) {
                if (item.operid == operid) {
                    if (String(item.benable) != "1") {
                        warning = "您无" + item.ccaption + "的操作权限！";
                    }
                    find = true;
                    break;
                }
            }
        }

        if (warning != null) {
            return warning;
        }
        if (find == false) {
            return warning;
        }
        if (warning == null && (operid == "01" || operid == "03" || operid == "04")) {
            warning = returndataauthwarning(operid, item.ccaption);
        }
        if (warning != null) {
            return warning;
        }
		
		/*	YJ Edit 20140915 
			问题：数据权限组织修改权限为负责人时，不起作用，依然可以修改单据
			方案：将下面1和2进行了代码位置的调换
		*/
		//1
		if (operid == noEditOperid || operid == noDelOperid) {
			warning = "您无" + item.ccaption + "的数据权限！";
			return warning;
		}
		//2
        if (operid == noFlowEditOperid || operid == noFlowDelOperid) {
            warning = "hasWorkFlow";
            return warning;
        }

        return warning;
    }

    /**
     * 模块说明：是否具有数据权限
     * 创建人：刘磊
     * 创建日期：2011-10-15
     * 修改人：
     * 修改日期：
     *
     */
    public function returndataauthwarning(operid:String, caption:String):String {
        var warning:String = null;
        var num:int;
        switch (operid) {
            case "01":
            {
                num = 2;
                break;
            }
            case "03":
            {
                num = 3;
                break;
            }
            case "04":
            {
                num = 4;
                break;
            }
        }
        if (dataauthArr) {
            if (dataauthArr.length > 0 && String(dataauthArr[0].dataauth).substr(num - 1, 1) == "1") {
                warning = "您无" + caption + "数据权限！";
            }
        }
        return warning;
    }

    /**
     * 模块说明：最终传入注册表、用户变量后获得的完整数据权限
     * 创建人：刘磊
     * 创建日期：2011-10-14
     * 修改人：
     * 修改日期：
     *
     */
    private var iperson;
    private var idepartment;
    private var ifuncregedit:int;

    public function get_fundataauth(params:Object):void {
        if (!params.hasOwnProperty("idepartment"))
            params.idepartment = CRMmodel.hrperson.idepartment;
        if (!params.hasOwnProperty("iperson"))
            params.iperson = CRMmodel.userId;

        this.iperson = params.iperson;
        this.idepartment = params.idepartment;
        this.ifuncregedit = params.ifuncregedit;

        var isIn:Boolean = false;
        for each(var item:Object in CRMmodel.dataAuthList) {
            if (item.iperson == params.iperson && item.idepartment == params.idepartment && item.ifuncregedit == params.ifuncregedit) {
                isIn = true;
                dataauthArr = item.dataauthArr;
                this.dispatchEvent(new Event("onGet_FundataauthSucess"));
                break;
            }
        }

        if (isIn == false) {
            AccessUtil.remoteCallJava("funauthViewDest", "get_fundataauth", get_fundataauthCallBack, params, null, false);
        }

       /* AccessUtil.remoteCallJava("funauthViewDest", "get_fundataauths", function (e:ResultEvent):void {
            dataauthPersonArr = e.result as ArrayCollection;
            CRMmodel.dataAuthList.addItem({iperson: iperson, idepartment: idepartment,ifuncregedit: ifuncregedit, dataauthArr: dataauthPersonArr});
            dispatchEvent(new Event("onGet_FundataauthSucess"));
        }, params, null, false);*/

    }

    private function get_fundataauthCallBack(evt:ResultEvent):void {
        dataauthArr = evt.result as ArrayCollection;
        CRMmodel.dataAuthList.addItem({iperson: iperson, idepartment: idepartment,ifuncregedit: ifuncregedit, dataauthArr: dataauthArr});
        this.dispatchEvent(new Event("onGet_FundataauthSucess"));
    }

    /**
     * 模块说明：最终传入注册表、用户变量后获得的完整操作权限
     * 创建人：刘磊
     * 创建日期：2011-10-14
     * 修改人：
     * 修改日期：
     *
     */
    public function get_funoperauth(params:Object):void {
        var isIn:Boolean = false;
        for each(var item:Object in CRMmodel.operAuthList) {
            if (item.iperson == params.iperson && item.ifuncregedit == params.ifuncregedit) {
                isIn = true;
                operauthArr = item.operauthArr;
                dispatchEvent(new Event("onGet_FunoperauthSucess"));
                break;
            }
        }

        if (isIn == false) {
            AccessUtil.remoteCallJava("funauthViewDest", "get_funoperauth", function (e:ResultEvent):void {
                operauthArr = e.result as ArrayCollection;
                CRMmodel.operAuthList.addItem({iperson: params.iperson, ifuncregedit: params.ifuncregedit, operauthArr: operauthArr});
                AccessUtil.remoteCallJava("funauthViewDest", "get_funoperauthPerson", function (e:ResultEvent):void {
                    operauthPersonArr = e.result as ArrayCollection;
                    CRMmodel.operAuthList.addItem({iperson: params.iperson, ifuncregedit: params.ifuncregedit, operauthArr: operauthPersonArr});
                    dispatchEvent(new Event("onGet_FunoperauthSucess"));
                }, params, null, false);
            }, params, null, false);
        }

    }

    /**
     * 模块说明：返回当前单据是否具有修改或删除数据权限提示集合
     * 创建人：刘磊
     * 创建日期：2011-10-15
     * 修改人：
     * 修改日期：
     *
     */
        //修改数据权限控制
    public function loadeditwarning(ifuncregedit:int, iperson:int, idepartment:int, iid:int):void {
        noEditOperid = "";
        geteditwarning("03", ifuncregedit, iperson, idepartment, iid);
    }

    public function geteditwarning(operid:String, ifuncregedit:int, iperson:int, idepartment:int, iid:int):void {
        curoperid1 = operid;
        var sql:String = "select count(iinvoice) ct from ab_invoiceuser";
        var condition:String = getdataauthcondition(operid, ifuncregedit, iperson, idepartment, "", 0);
        if (null == condition || condition == "") {
            condition = "and 1=1";
        }
        sql = sql + " where 1=1 " + condition + " and iinvoice=" + iid;
        AccessUtil.remoteCallJava("funauthViewDest", "get_sqldata", editwarningCallBack, sql, null, false);
    }

    public function editwarningCallBack(evt:ResultEvent):void {
        var resultArr:ArrayCollection = evt.result as ArrayCollection;
        if (null != resultArr && resultArr.length > 0 && evt.result[0].ct == 0) {
            noEditOperid = curoperid1;
        }
    }

    //删除数据权限控制
    public function loaddelwarning(ifuncregedit:int, iperson:int, idepartment:int, iid:int):void {
        noDelOperid = "";
        getdelwarning("04", ifuncregedit, iperson, idepartment, iid);
    }

    public function getdelwarning(operid:String, ifuncregedit:int, iperson:int, idepartment:int, iid:int):void {
        curoperid2 = operid;
        var sql:String = "select count(iinvoice) ct from ab_invoiceuser";
        var condition:String = getdataauthcondition(operid, ifuncregedit, iperson, idepartment, "", 0);
        if (null == condition || condition == "") {
            condition = "and 1=1";
            return;
        }
        sql = sql + " where 1=1 " + condition + " and iinvoice=" + iid;
        AccessUtil.remoteCallJava("funauthViewDest", "get_sqldata", delwarningCallBack, sql, null, false);
    }

    public function delwarningCallBack(evt:ResultEvent):void {
        var resultArr:ArrayCollection = evt.result as ArrayCollection;

        if (resultArr != null && resultArr.length > 0 && evt.result[0].ct == 0) {
            noDelOperid = curoperid2;
        }
    }

    /**
     * 模块说明：删除前获得关联表信息
     * 创建人：刘磊
     * 创建日期：2011-10-19
     * 修改人：
     * 修改日期：
     *
     */
    public function get_beforedelinfo(ifuncregedit:int, iid:int):void {
        var sql:String = "exec buse " + ifuncregedit + "," + iid;
        AccessUtil.remoteCallJava("funauthViewDest", "get_sqldata", function (evt:ResultEvent):void {
            get_beforedelinfoCallBack(evt, iid)
        }, sql);
    }

    private function get_beforedelinfoCallBack(evt:ResultEvent, iid:int):void {
        delinfoArr = evt.result as ArrayCollection;
        //			container.dispatchEvent(new onItemDoubleClick("onGet_beforedelinfoSucess",iid));
        this.dispatchEvent(new onItemDoubleClick("onGet_beforedelinfoSucess", iid));
    }

    /**

     *  * 模块说明：根据按钮name获得operid 01：浏览 02：增加 03：修改 04：删除
     * 创建人：刘磊
     * 创建日期：2011-10-14
     * 修改人：
     * 修改日期：
     *
     */
    public function getOperidByName(name:String):String {
        var operid:String;
        switch (name) {
            case "onBrowse":
            {
                operid = "01";
                break;
            }

            case "onQuery":
            {
                operid = "01";
                break;
            }

            case "onNew":
            {
                operid = "02";
                break;
            }

            case "onEdit":
            {
                operid = "03";
                break;
            }
            case "onDelete":
            {
                operid = "04";
                break;
            }
            case "onPrint":
            {
                operid = "05";
                break;
            }
            case "onExcelExport":
            {
                operid = "06";
                break;
            }
            case "onCusMerge":
            {
                operid = "60";
                break;
            }
            case "onSubmit":
            {
                operid = "07";
                break;
            }
            case "onRevocation":
            {
                operid = "08";
                break;
            }
        }
        return operid;
    }

    /**
     * 模块说明：获得组织数据权限条件
     * 创建人：刘磊
     * 创建日期：2012-11-27
     * 修改人：
     * 修改日期：
     * bcusdataauth: true 为获得客商的组织权限 false 为获得当前单据的组织权限
     * tablename:真正请求权限功能的表名
     */
    public function getorgauthcondition(authid:int, ifuncregedit:int, iperson:int, idepartment:int, addtablename:String, itype:int, bcusdataauth:Boolean = false, tablename:String = ""):String {
        var condition:String = "";
        //itype 0:获得修改、删除数据权限条件 1:获得浏览数据权限条件
        switch (authid) {
            case 1://无权限
            {
                condition = "1=2";
                break;
            }
            case 2://负责人权限
            {
                switch (itype) {
                    case 0:
                    {
                        condition = " and ifuncregedit=" + ifuncregedit + " and  iperson=" + iperson + " and irole=1";
                        break;
                    }
                    case 1:
                    {
                        if (bcusdataauth) {
                            condition = "and " + tablename + "icustomer in (select iinvoice from ab_invoiceuser where ifuncregedit=" + ifuncregedit + " and  iperson=" + iperson + " and irole=1)";
                        }
                        else {
                            condition = " and " + addtablename + "iid in (select iinvoice from ab_invoiceuser where ifuncregedit=" + ifuncregedit + " and  iperson=" + iperson + " and irole=1)";
                        }
                        break;
                    }
                    case 2:
                    {
                        condition = " and iid=" + idepartment;
                        break;
                    }
                    case 3:
                    {
                        condition = " and hr_person.iid=" + iperson;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                break;
            }
            case 3://相关人权限
            {
                switch (itype) {
                    case 0:
                    {
                        condition = " and ifuncregedit=" + ifuncregedit + " and iperson=" + iperson;
                        break;
                    }
                    case 1:
                    {
                        if (bcusdataauth) {
                            condition = "and " + tablename + "icustomer in (select iinvoice from ab_invoiceuser where ifuncregedit=" + ifuncregedit + " and iperson=" + iperson + ")";
                        }
                        else {
                            condition = " and " + addtablename + "iid in (select iinvoice from ab_invoiceuser where ifuncregedit=" + ifuncregedit + " and iperson=" + iperson + ")";
                        }
                        break;
                    }
                    case 2:
                    {
                        condition = " and iid=" + idepartment;
                        break;
                    }
                    case 3:
                    {
                        condition = " and hr_person.iid=" + iperson;
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                break;
            }
            case 4://本部门权限
            {
                switch (itype) {
                    case 0:
                    {
                        condition = " and ifuncregedit=" + ifuncregedit + " and idepartment in (select idepartment from hr_person where iid=" + iperson + " union select idepartment from hr_persons where iperson=" + iperson + " and isnull(bend,0)=0)";
                        break;
                    }
                    case 1:
                    {
                        if (bcusdataauth) {
                            condition = "and " + tablename + "icustomer in (select iinvoice from ab_invoiceuser where ifuncregedit=" + ifuncregedit + " and idepartment in (select idepartment from hr_person where iid=" + iperson + " union select idepartment from hr_persons where iperson=" + iperson + " and isnull(bend,0)=0))";
                            break;
                        }
                        else {
                            condition = " and " + addtablename + "iid in (select iinvoice from ab_invoiceuser where ifuncregedit=" + ifuncregedit + " and idepartment in (select idepartment from hr_person where iid=" + iperson + " union select idepartment from hr_persons where iperson=" + iperson + " and isnull(bend,0)=0))";
                            break;
                        }
                        break;
                    }
                    case 2:
                    {
                        condition = " and iid=" + idepartment;
                        break;
                    }
                }
                break;
            }
            case 5://本部门及下级部门权限
            {
                switch (itype) {
                    case 0:
                    {
                        condition = " and ifuncregedit=" + ifuncregedit + " and idepartment in (select iid from hr_department where  " + getPersonDepartmentCcodeListString(iperson) + ")";
                        break;
                    }
                    case 1:
                    {
                        if (bcusdataauth) {
                            condition = "and " + tablename + "icustomer in (select iinvoice from ab_invoiceuser  where ifuncregedit=" + ifuncregedit + " and idepartment in (select iid from hr_department where " + getPersonDepartmentCcodeListString(iperson) + "))";
                        }
                        else {
                            condition = " and " + addtablename + "iid in (select iinvoice from ab_invoiceuser  where ifuncregedit=" + ifuncregedit + " and idepartment in (select iid from hr_department where " + getPersonDepartmentCcodeListString(iperson) + "))";
                        }
                        break;
                    }
                    case 2:
                    {
                        condition = " and where " + getPersonDepartmentCcodeListString(iperson);
                        break;
                    }
                }
                break;
            }
            case 6://全部权限
            {
                condition = "";
                break;
            }

        }
        return condition;
    }

    /**
     * 模块说明：获得数据权限条件字符串
     * 创建人：刘磊
     * 创建日期：2011-10-15
     * 修改人：
     * 修改日期：
     *
     */
    public function getdataauthcondition(operid:String, ifuncregedit:int, iperson:int, idepartment:int, tablename:String = "", itype:int = 1):String {
        //SQL语句中必须有iid单据内码字段，客商权限必须有icustomer字段
        var condition:String = "";
        var num:int;
        var addtablename:String = (tablename == "" ? "" : tablename + ".");//添加查询主表名.
        if (dataauthArr == null || dataauthArr.length == 0) {
            return condition
        }//如果没有设置数据权限则不控制

        if (dataauthArr[0].sortid == 2) {//lr 如果第一行记录读到的不是自己单据的权限而是客户权限，说明本单据没启用权限。
            return condition;
        }

        switch (operid) {
            case "01":
            {
                num = 2;
                break;
            }
            case "03":
            {
                num = 3;
                break;
            }
            case "04":
            {
                num = 4;
                break;
            }
        }

        if (dataauthArr.length > 0) {
            var authid:int = Number(String(dataauthArr[0].dataauth).substr(num - 1, 1));
            //是否启用组织权限
            var borgauth:Boolean = (Number(String(dataauthArr[0].dataauth).substr(0, 1)) == 1);
            //是否启用客商查询权限
            var bcusauth:Boolean = (Number(String(dataauthArr[0].dataauth).substr(4, 1)) == 1);
            //组织权限与客商权限与/或关系
            var band:Boolean = (Number(String(dataauthArr[0].dataauth).substr(5, 1)) == 1);
            //客商查询权限条件
            var ccuscondition:String = "select iinvoice from ab_invoiceuser where ifuncregedit=44 ";
            if (bcusauth && dataauthArr.length > 1) {
                if (Number(String(dataauthArr[1].dataauth).substr(0, 1)) == 1)	//客商档案启用组织权限时需加入条件
                {
                    var cusauthid:int = Number(String(dataauthArr[1].dataauth).substr(num - 1, 1));
                    var cusifuncregedit:int = Number(String(dataauthArr[1].iid));
                    var cusaddtablename:String = String(dataauthArr[1].ctable) + ".";
                    var cusaddcondition:String = getorgauthcondition(cusauthid, cusifuncregedit, iperson, idepartment, cusaddtablename, itype, true, addtablename);
                    ccuscondition = ccuscondition + cusaddcondition;
                }
            }
            //启用组织权限控制
            if (borgauth) {
                condition = getorgauthcondition(authid, ifuncregedit, iperson, idepartment, addtablename, itype, false);
            }
        }

        if (itype == 1)//查询数据权限
        {
            //如果仅启用客商查询权限
            if ((!borgauth) && (bcusauth)) {
                if (band) {
                    condition = " and " + addtablename + "icustomer in (" + ccuscondition + ")";
                }
                else {
                    condition = " or " + addtablename + "icustomer in (" + ccuscondition + ")";
                }
            }
            //如果启用组织与客商查询权限
            if (borgauth && bcusauth) {
                if (band) {
                    condition = condition + " and " + addtablename + "icustomer in (" + ccuscondition + ")";
                }
                else {
                    condition = condition + " or " + addtablename + "icustomer in (" + ccuscondition + ")";
                }
            }
        }
        return "and ( 1=1 " + condition + ") ";
    }

    //批量删除时，获得有删除数据权限的单据内码
    public function getdelbatch(operid:String, ifuncregedit:int, iperson:int, idepartment:int, arriid:Array):void {
        curoperid2 = operid;
        var warning:String = null;
        var sql:String = "select iinvoice from ab_invoiceuser";
        var condition:String = getdataauthcondition(operid, ifuncregedit, iperson, idepartment, "", 0);
        if (null == condition || condition == "") {
            condition = "1=1";
        }
        var instr:String = "";
        for (var i:int = 0; i < arriid.length; i++) {
            if (i == arriid.length - 1) {
                instr += arriid[i].toString();
            }
            else {
                instr += arriid[i].toString() + ",";
            }
        }
        sql = sql + " where " + condition + " and iinvoice in (" + instr + ") group by iinvoice having count(iinvoice)>0";
        AccessUtil.remoteCallJava("funauthViewDest", "get_sqldata", delbatchCallBack, sql, null, false);
    }

    private function delbatchCallBack(evt:ResultEvent):void {
        allowdelArr = evt.result as ArrayCollection;
        if (allowdelArr != null && allowdelArr.length > 0) {
            //				container.dispatchEvent(new Event("onGet_getdelbatchSucess"));
            this.dispatchEvent(new Event("onGet_getdelbatchSucess"));
        }
    }

    //工作流修改权限控制
    public function loadfloweditwarning(ifuncregedit:int, iid:int):void {
        noFlowEditOperid = "";
        var params:Object = new Object();
        params.ifuncregedit = ifuncregedit;
        params.iinvoice = iid;
        AccessUtil.remoteCallJava("funauthViewDest", "get_editinvoice", floweditwarningCallBack, params, null, false);
    }

    private function floweditwarningCallBack(evt:ResultEvent):void {
        if (Number(evt.result) > 0) {
            noFlowEditOperid = "03";
        }
    }

    //工作流删除权限控制
    public function loadflowdelwarning(ifuncregedit:int, iid:int):void {
        noFlowDelOperid = "";
        var params:Object = new Object();
        params.ifuncregedit = ifuncregedit;
        params.iinvoice = iid;
        AccessUtil.remoteCallJava("funauthViewDest", "get_delinvoice", flowdelwarningCallBack, params, null, false);
    }

    private function flowdelwarningCallBack(evt:ResultEvent):void {
        if (Number(evt.result) > 0) {
            noFlowDelOperid = "04";
        }
    }

    /**
     * 模块说明：所有单据插入公共单据负责人员
     * 创建人：刘磊
     * 创建日期：2011-10-13
     * 修改人：
     * 修改日期：
     *
     */
    public function InsertAB_invoiceuser(vo_ab_invoiceuser:Object):void {
        vo_ab_invoiceuser.iperson = CRMmodel.userId;
        AccessUtil.remoteCallJava("ab_invoiceuserViewDest", "add_ab_invoiceuser", InsertAB_invoiceusercallBack, vo_ab_invoiceuser, null, false);
    }

    private function InsertAB_invoiceusercallBack(evt:ResultEvent):void {
        if (evt.result.toString() == "fail") {
            CRMtool.showAlert("负责人员插入失败！");
        }
    }

    /**
     * 模块说明：删除相关表记录
     * 创建人：刘磊
     * 创建日期：2011-11-03
     * 修改人：
     * 修改日期：
     *
     */
    public function pr_execdellinktable(iid:int, ifuncregedit:int):void {
        var params:Object = new Object();
        params.iinvoice = iid.toString();
        params.ifuncregedit = ifuncregedit.toString();
        AccessUtil.remoteCallJava("ab_invoiceuserViewDest", "pr_execdellinktable", pr_execdellinktablecallBack, params, null, false);
    }

    private function pr_execdellinktablecallBack(evt:ResultEvent):void {
        if (evt.result.toString() == "fail") {
            //失败处理
        }
    }

    private function getPersonDepartmentCcodeListString(iperson:int):String {
        var ac:ArrayCollection = CRMtool.getPersonDepartmentList(iperson);
        var s:String = "";
        for each(var item:Object in ac) {
            for each(var ditem:Object in CRMmodel.departmentlist) {
                if (item.idepartment == ditem.iid)
                    s = s + " or ccode like '" + ditem.ccode + "%' "
            }
        }
        s = StringUtil.trim(s);
        if (s.indexOf("or") == 0)
            s = s.substr(2);

        return s;
    }
}
}