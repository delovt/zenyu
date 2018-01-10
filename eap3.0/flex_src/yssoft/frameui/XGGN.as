import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.containers.VBox;
import mx.controls.Alert;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;

import yssoft.frameui.FrameCore;
import yssoft.frameui.formopt.OperDataAuth;
import yssoft.models.CRMmodel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.vos.ListclmVo;
import yssoft.vos.ListsetVo;

[Bindable]
private var resultArr:ArrayCollection = new ArrayCollection();

//相关关联功能
public function XGGNHandler():void {
    resultArr.removeAll();
    parentForm = this.owner;
    var paramObj:Object = new Object();
    paramObj.iid = ifuniid;
    paramObj.buse = 1;
    CRMtool.getFcrelation(paramObj, function (_obj) {
        getFunCallBackHandler(_obj);
    });
}

private function getFunCallBackHandler(resultAll:Object):void {
    this.resultArr = CRMtool.copyArrayCollection(resultAll.resultList as ArrayCollection);
    refresh();
    (parentForm as FrameCore).dispatchEvent(new Event("SideComplete"));
}

private function createItem():void {
    relateFun.listDatas.removeAll();
    for each(var item:Object in resultArr) {
        var obj:Object = {};
        obj.mainLabel = item.cname + (item.addcname == null ? "" : item.addcname);
        obj.buse = item.buse;
        obj.cfcrlcondit = item.cfcrlcondit;
        obj.cfcrlfield = item.cfcrlfield;
        obj.ifcrelation = item.ifcrelation;
        obj.ifuncregedit = item.ifuncregedit;
        obj.outifuncregedit = item.outifuncregedit;
        obj.iid = item.iid;
        obj.ino = item.ino;
        obj.iopen = item.iopen;
        obj.cname = item.cname;
        obj.csql = item.csql;
        obj.relatedSql = item.relatedSql;

        relateFun.listDatas.addItem(obj);
    }
}


/////////////////////////////////////////////////////////////////////////
protected function refresh():void {
    for each(var item:Object in resultArr) {
        getListSet(item);
    }
}

private function getRelatedSql(item:Object):String {
    var cfcrlcondit:String = item.cfcrlcondit;
    var cfcrlfield:String = item.cfcrlfield;
    var csql:String = item.csql;
    var sql:String = "";
    var itemObj:Object = parentForm.crmeap.getValue();

    //update by zhong_jing 如果关联字段为空时，会报错
    if (CRMtool.isStringNotNull(cfcrlfield)) {
        var cfcrlfieldArr:Array = cfcrlfield.split("|");
        if (CRMtool.isStringNotNull(cfcrlfield)) {
            for (var i:int = 0; i < cfcrlfieldArr.length; i++) {
                var singcfcrlfield:String = cfcrlfieldArr[i];
                var singcfcrlfieldArr:Array = singcfcrlfield.split(",");
                sql += " and " + singcfcrlfieldArr[1] + "=" + itemObj[singcfcrlfieldArr[0]];
            }
        }
    }


//************ 开始：XZQWJ 修改日期：2012-12-12  功能：	大余2表的单据联查****************************************************
    //		if(null!=item.cfcrlcondit&&""!=item.cfcrlcondit)
    if (CRMtool.isStringNotNull(cfcrlcondit)) {
        var cfcrlconditArr:Array = cfcrlcondit.toString().split("|");
        var singcfcrlconditArr:Array = cfcrlconditArr[0].toString().split(",");
        if (singcfcrlconditArr.length == 0) {
            sql += " " + item.cfcrlcondit;
        } else {
            for (var ii:int = 0; ii < cfcrlconditArr.length; ii++) {
                var singcondit:String = cfcrlconditArr[ii];
                var singconditArr:Array = singcondit.split(",");
                var l:int = singconditArr.length;
                sql += " and " + singconditArr[l - 1] + " in ( ";
                var index:int = 0;
                var str:String = "";
                for (var j:int = l - 2; j > 0; j -= 2) {
                    str += ")";
                    sql += " select " + singconditArr[j] + " from " + singconditArr[j - 1].toString().split(".")[0] + " where " + singconditArr[j - 1] + " in ( ";
                }
                sql += itemObj[StringUtil.trim(singconditArr[0])] + " )" + str;

//					sql+=" and "+singconditArr[3]+" in ( select "+singconditArr[2]+" from "+singconditArr[1].toString().split(".")[0]+" where "+singconditArr[1]+" in ( "+itemObj[singconditArr[0]]+" ) ) ";
            }
        }
    }
//***********结束**********************************************************************************************8

    if (CRMtool.isStringNotNull(csql)) {
        sql = csql.replace("@iid@", curiid);
        while (sql.indexOf("@iid@") > -1)
            sql = sql.replace("@iid@", curiid);
    }

    return sql;
}


private function getListSet(item:Object):void {

    var ifuncregedit:int = item.ifuncregedit;
    var outifuncregedit:int = item.outifuncregedit

    var acListclmVo:ListclmVo = new ListclmVo();

    acListclmVo.ilist = ifuncregedit;
    acListclmVo.iperson = CRMmodel.userId;

    var relatedSql:String = getRelatedSql(item);
    item.relatedSql = relatedSql;
    CRMtool.getListset(acListclmVo, function (_obj) {
        var acListsetVo:ListsetVo = _obj.acListsetVo as ListsetVo;
        //加载完毕列表sql之后，加载权限。
        getAuth(ifuncregedit, outifuncregedit, acListsetVo.ctable, relatedSql, acListsetVo.csql1);
    });
}

private function getAuth(ifuncregedit:int, outifuncregedit:int, ctable:String, relatedSql:String, csql1:String):void {
    var box:VBox = new VBox();
    var auth:OperDataAuth = new OperDataAuth();
    //****注操作权限功能注册内码分开，数据权限功能注册内码以单据为准****//
    //---------------加载操作权限 刘磊 20111014 begin---------------//
    var params:Object = new Object();
    params.ifuncregedit = ifuncregedit;
    params.iperson = CRMmodel.userId;
    auth.get_funoperauth(params);
    //---------------加载操作权限 刘磊 20111014 end---------------//

    //---------------加载数据权限 刘磊 20111015 begin---------------//
    auth.addEventListener("onGet_FundataauthSucess", function (evt:Event):void {
        var authSql:String = auth.getdataauthcondition("01", outifuncregedit, CRMmodel.userId, CRMmodel.hrperson.idepartment, ctable, 1);
        if (ifuncregedit == 282) {//此处写死，如果是合同中心，必走一下权限sql  lr
            authSql = " and sc_order.icustomer in (select iinvoice from ab_invoiceuser where ifuncregedit=44)";
            //authSql=" and sc_order.icustomer in (select iinvoice from ab_invoiceuser where ifuncregedit=44  and icustomer in (select iinvoice from ab_invoiceuser where ifuncregedit=44 and  iperson="+CRMmodel.userId+" and irole=1))"
        }

        var sql:String = "select count(iid) as count from (" + csql1 + ")" + ctable + " where 1=1 " + authSql + relatedSql;
        AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
            var eventAC:ArrayCollection = event.result as ArrayCollection;
            for each(var item:Object in resultArr) {
                if (item.ifuncregedit == ifuncregedit) {
                    if (eventAC[0].count == 0 || (eventAC[0].count + "") == "0") {
                        item.addcname = "";
                    } else {
                        item.addcname = " [" + eventAC[0].count + "]";
                    }
                }
                resultArr.refresh();
            }
            createItem();
        }, sql, "正在获取相关功能数据");
    });
    var params2:Object = new Object();
    params2.ifuncregedit = outifuncregedit;
    params2.iperson = CRMmodel.userId;
    auth.get_fundataauth(params2);
    //---------------加载数据权限 刘磊 20111015 end---------------//
}