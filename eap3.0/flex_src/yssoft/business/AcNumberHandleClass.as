package yssoft.business {
import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.formatters.DateFormatter;
import mx.rpc.events.ResultEvent;

import yssoft.comps.frame.module.CrmEapRadianVbox;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;

/**
 *
 *    单据编码业务操作
 *  包含以下功能点：
 *    1、自动生成单据编码
 *
 *    创建人：    YJ
 *  创建时间:    2012-04-07
 *
 * */

public class AcNumberHandleClass {
    public function AcNumberHandleClass() {
    }

    private var _bnumer:int;//是否参与单据编码管理

    public function set bnumber(value:int):void {

        this._bnumer = value;

    }

    public function get bnumber():int {

        return this._bnumer;

    }

    public static var ccode:String;

    private var _nfields:ArrayCollection;//参与单据编码管理的字段

    public function set nfields(value:ArrayCollection):void {

        this._nfields = value;

    }

    public function get nfields():ArrayCollection {

        return this._nfields;

    }

    private var _afields:ArrayCollection;//需要赋值的字段

    public function set afields(value:ArrayCollection):void {

        this._afields = value;

    }

    public function get afields():ArrayCollection {

        return this._afields;

    }

    private var _ifuncregedit:int;//功能注册码

    public function set ifuncregedit(value:int):void {

        this._ifuncregedit = value;

    }

    public function get ifuncregedit():int {

        return this._ifuncregedit;

    }

    private var _ctable:String;//表名

    public function set ctable(value:String):void {

        this._ctable = value;

    }

    public function get ctable():String {

        return this._ctable;

    }

    private var _billnumber:String;//单据编码

    public function set billnumber(value:String):void {

        this._billnumber = value;

    }

    public function get billnumber():String {

        return this._billnumber;

    }

    private var _crmEapRadianVbox:CrmEapRadianVbox;//单据框架

    public function set crmEapRadianVbox(value:CrmEapRadianVbox):void {

        this._crmEapRadianVbox = value;

    }

    private var _isSave:Boolean = false;//是否保存单据编码(单据编码2种状态：1--只显示不保存，2--显示保存)

    public function set isSave(value:Boolean):void {

        this._isSave = value;

    }

    /*
     获取单据编码
     */
    public function onGetBillNumber():void {

        if (this._bnumer == 0) return;//不参与单据编码管理

        var obj:Object = {};
        obj.iid = this._ifuncregedit;
        obj.ctable = this._ctable;
        var daf:DateFormatter = new DateFormatter();
        daf.formatString = "YYYYMMDD";
        obj.cusdate = daf.format(new Date());


        obj.frontlist = this._nfields;

        if (_isSave) {

            onExecNumber("saveNumber", obj);

        } else {

            onExecNumber("showNumber", obj);

        }


    }

    //与后台交互，执行单据编码操作
    public function onExecNumber(methodname:String, param:Object):void {

        AccessUtil.remoteCallJava("NumberSetDest", methodname, function (event:ResultEvent):void {

            /*	this._billnumber = event.result.number+"";

             //单据赋值
             _crmEapRadianVbox.setSingValue("ccode",this._billnumber,1,1);*/

            onExecNumberBack(event, methodname);

//				if(methodname == "saveNumber"){
//					_crmEapRadianVbox.onClear();
//				}

        }, param);

    }

    private function onExecNumberBack(event:ResultEvent, methodname:String):void {
        this._billnumber = event.result.number + "";

        //wxh add 控制服务申请 生成 服务工单 带出流水号    特殊针对
//			for each(var item:Object in _nfields){
//				if(_ifuncregedit==150&&item.cfield=="isolution"){
//					if(CRMtool.isStringNull(item.fieldvalue)&&ccode != null){
//						this._billnumber = ccode+this._billnumber;
//					}
//				}  

        /*if(CRMtool.isStringNull(item.fieldvalue))
         return;*/
//			}
        //单据赋值

        _crmEapRadianVbox.setSingValue("ccode", this._billnumber, 1, 1);

        if (methodname == "saveNumber") {
            _crmEapRadianVbox.isUnique();
        }
    }
}
}