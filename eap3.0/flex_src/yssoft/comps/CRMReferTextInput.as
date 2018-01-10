package yssoft.comps {
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.system.Capabilities;
import flash.system.IME;

import mx.collections.ArrayCollection;
import mx.collections.XMLListCollection;
import mx.containers.Form;
import mx.controls.Alert;
import mx.controls.Image;
import mx.controls.Label;
import mx.controls.LinkButton;
import mx.controls.TextInput;
import mx.controls.Tree;
import mx.events.FlexEvent;
import mx.events.FlexMouseEvent;
import mx.rpc.events.ResultEvent;
import mx.utils.ObjectUtil;

import org.osmf.layout.HorizontalAlign;

import spark.layouts.VerticalLayout;

import yssoft.evts.onItemDoubleClick;
import yssoft.skins.CrmTextInputSkin;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.views.consultsets.ConsultsetSet;

/**
 *
 　　* 函数名：CRMReferTextInput
 　　* 作者：钟晶
 　　* 日期：2011-08-27
 　　* 功能： 参照查询文本框
 　　* 参数：
 　　* 返回值：
 　　* 修改记录：
 *
 　　*/
[Event(name="onItemDoubleClick", type="flash.events.Event")]
[Event(name="onClick", type="flash.events.Event")]
[Event(name="onChangeDoubleEvent", type="flash.events.Event")]
[Event(name="cleanClick", type="flash.events.Event")]
public class CRMReferTextInput extends TextInput {
    [Embed(source="/yssoft/assets/images/search.png")]
    private const _defaultIcon:Class;

    [Embed(source="/yssoft/assets/images/numberTe.png")]
    private const _numberdefaultIcon:Class;

    [Embed(source="/yssoft/assets/images/popDataTime.png")]
    private const _dateTimedefaultIcon:Class;

    //数据字典编号
    private var _iid:int;

    private var _te:String = null;

    private var _isEndit:Boolean;

    //编码前缀
    private var _cabbreviation:String;

    private var parentForm:Object;
    //传入参照sql
    private var _referSql:String = null;

    private var _fun:Function;

    //参照传参
    private var tj:String = "";

    //YJ Add
    public var consultFun:Function;//参照方法

    public function set fun(value:Function):void {
        _fun = value;
    }

    public function set referSql(value:String):void {
        this._referSql = value;
    }

    [Bindable]
    public var selectedIID:String;  //选中的IID
    [Bindable]
    public var selectIIDArr:ArrayCollection;

    private var _cfield:String;

    private var isFirst:Boolean = false;


    private var _ifFir:Boolean = false;

    private var _item:String;

    public function set item(value:String):void {
        _item = value;
    }

    //返回所有参照值
    private var _allList:ArrayCollection;

    public function get  allList():ArrayCollection {
        return this._allList;
    }

    public function set allList(value:ArrayCollection):void {
        this._allList = value;
    }

    public function set cfield(value:String):void {
        this._cfield = value;
    }

    public function set cabbreviation(value:String):void {
        _cabbreviation = value;
    }

    public function get cabbreviation():String {
        return this._cabbreviation;
    }


    public function set isEndit(value:Boolean):void {
        this._isEndit = value;
        this.lbr_search.enabled = _isEndit;
    }

    //参照返回存入字段
    private var _cconsultbkfld:ArrayCollection = new ArrayCollection();

    public function get cconsultbkfld():ArrayCollection {
        return this._cconsultbkfld;
    }

    public function set cconsultbkfld(value:ArrayCollection):void {
        this._cconsultbkfld = value;
    }

    public function set te(value:String):void {
        _te = value;
        if (_te || _te == "")
            initText();
    }


    //数据字典记录
    [Bindable]
    private var _datadictionaryObj:Object = new Object();

    public function CRMReferTextInput() {
        this.addEventListener(FocusEvent.FOCUS_OUT, enter);
        /*this.addEventListener(FlexEvent.CREATION_COMPLETE,enter);*/
    }

    override public function set editable(value:Boolean):void {
        super.editable = value;
        if (this.lbr_search) {
            this.lbr_search.visible = value;
        }
    }


    private function getDatadictionary(event:ResultEvent):void {
        if (event.result) {
            var _datadictionaryArr:ArrayCollection = event.result as ArrayCollection;
            if (_datadictionaryArr.length > 0) {
                _datadictionaryObj = _datadictionaryArr.getItemAt(0);

                if (_datadictionaryObj != null) {
                    if (_datadictionaryObj.iconsult > 0 && _datadictionaryObj.bread == false) {
                        this.lbr_search.visible = this.editable;
                    }
                    else {
                        this.lbr_search.visible = false;
                    }
                    /*switch(_datadictionaryObj.idatatype)
                     {
                     case 1:
                     {
                     if(_datadictionaryObj.iconsult==0)
                     {
                     this.restrict="[0-9]";
                     }

                     break;
                     }
                     case 2:
                     {
                     if(_datadictionaryObj.iconsult==0)
                     {
                     this.restrict="[0-9]\.";
                     }
                     break;
                     }
                     case 3:
                     {
                     this.lbr_search.setStyle("icon",_dateTimedefaultIcon);
                     break;
                     }
                     default:
                     {
                     break;
                     }
                     }*/
                    initText();
                }
            }
            else {
                /*CRMtool.tipAlert("您输入的数据字典编号不存在！！");*/
                this.lbr_search.visible = false;
            }
        }
    }

    public function set iid(value:int):void {
        this._iid = value;
        var paramObject:Object = new Object();
        paramObject.iid = this._iid;
        /*AccessUtil.remoteCallJava("DatadictionaryDest","getCrmRefer",getDatadictionary,paramObject,null,false);*/
    }


    public function get iid():int {
        return this._iid;
    }

    //声明一个linkButton
    private var lbr_search:LinkButton;

    /**
     *
     * 作者： 钟晶
     * 日期：2011-08-27
     * 功能：嵌入一个LinkButton
     * 修改记录：
     *
     */
    override protected function createChildren():void {
        this.parentForm = this.owner;
        //继承TextInput
        super.createChildren();
        //声明一个LinkButton
        lbr_search = new LinkButton();
        //嵌入图片
        lbr_search.setStyle("icon", _defaultIcon);
        //设置宽度和高度
        lbr_search.width = 16;
        lbr_search.height = 16;
        /*	lbr_search.alpha =0;*/
        //lbr_search.setStyle("paddingRight",lbr_search.width+10);

        //this.addEventListener(FlexEvent.CREATION_COMPLETE,getWidth);
        /*			lbr_search.addEventListener(MouseEvent.MOUSE_OUT,tnp_button_mouseOutHandler);
         lbr_search.addEventListener(MouseEvent.MOUSE_OVER,tnp_button_mouseOverHandler);
         this.addEventListener(MouseEvent.MOUSE_OVER,tnp_text_mouseOverHandler);
         this.addEventListener(MouseEvent.MOUSE_OUT,tnp_text_mouseOutHandler);*/
        //加入LinkButton
        addChild(lbr_search);
        this.addEventListener(Event.CHANGE, onChange);
        //出发点击事件
        lbr_search.addEventListener(MouseEvent.CLICK, openReferWin);

        this.addEventListener(FocusEvent.FOCUS_IN, InHandler);
    }

    private function InHandler(e:Event):void {
        IME.enabled = true
    }


    private function onChange(event:Event):void {
        _ifFir = false;
        /*if(this.text.length>9)
         {
         CRMtool.tipAlert1("您输入的字段超长...");
         return;
         }*/

        if (CRMtool.isStringNull(this.text)) {
            this.te = "";
            this._cconsultbkfld = new ArrayCollection();
            this._allList = new ArrayCollection();
            this.dispatchEvent(new Event("cleanClick"));
        }
    }

    private function getWidth(event:FlexEvent):void {
        var nWidth:int = this.width;
        var nHeight:int = this.height;
        lbr_search.x = nWidth - lbr_search.width;
        lbr_search.y = (nHeight - lbr_search.height) / 2;
    }

    //
    override protected function updateDisplayList(uw:Number, uh:Number):void {
        super.updateDisplayList(uw, uh);
        if (lbr_search) {
            lbr_search.setActualSize(16, 16);
            lbr_search.x = uw - lbr_search.width - 2;
            lbr_search.y = (uh - lbr_search.height) / 2;
        }
    }

    /**
     *
     * 作者： 钟晶
     * 日期：2011-08-27
     * 功能：点击LinkButton触发事件
     * 修改记录：
     *
     */
    private function openReferWin(event:MouseEvent):void {
        if (_datadictionaryObj.iconsult > 0) {
            isFirst = false;
            _ifFir = true;
            if (_datadictionaryObj.itype == 0) {
                new ConsultTree(getSelectTreeRows, _datadictionaryObj.iconsult, _datadictionaryObj.bconsultendbk);
            }
            else if (_datadictionaryObj.itype == 1) {
                new ConsultList(getSelectListRows, _datadictionaryObj.iconsult, _datadictionaryObj.bconsultmtbk, getSql().sql, this._datadictionaryObj.cconsultcondition);
            }
            else {
                new ConsultTreeList(getSelectListRows, _datadictionaryObj.iconsult, _datadictionaryObj.bconsultmtbk, getSql().sql, this._datadictionaryObj.cconsultcondition);
            }
        }
    }

    private function getSql(flag:String = "1"):Object {
        var paramObj:Object = new Object();
        var sql:String = "";
        var _paramObj:Object = null;
        if (this._fun != null) {
            _paramObj = this._fun();
        }
        var tableName:String = "";
        if (_datadictionaryObj.cconsultconfld != null && _datadictionaryObj.cconsultconfld != "") {
            var cconsultconfld:String = _datadictionaryObj.cconsultconfld;
            var cconsultconfldArr:Array = cconsultconfld.split("|");
            for (var i:int = 0; i < cconsultconfldArr.length; i++) {
                var cconsultconfldStr:String = cconsultconfldArr[i];
                var cconsultconfldStrArr:Array = cconsultconfldStr.split(",");

                //判断是否是直接弹出形式 update by zhong_jing
                var cconsultconfldStrAssignment:String = cconsultconfldStrArr[0];
                var cconsultconfldStr1:String = cconsultconfldStrArr[1];

                if (flag == "1") {
                    if (cconsultconfldStr1.indexOf(".") != -1) {
                        continue;
                    }
                }
                else {
                    if (cconsultconfldStr1.indexOf(".") == -1) {
                        continue;
                    }
                    var cconsultconfldStr1Arr:Array = cconsultconfldStr1.split(".");
                    tableName = cconsultconfldStr1Arr[0];
                }

                if (_paramObj == null || !_paramObj.hasOwnProperty(cconsultconfldStrArr[0])) {
                    sql += " and 1=2";
                }
                else {
                    sql += " and " + cconsultconfldStr1Arr[1] + "=" + _paramObj[cconsultconfldStrArr[0]];
                }
            }
        }

        if (flag == "1") {
            if (null != _referSql) {
                sql += _referSql;
            }
            if (CRMtool.isStringNotNull(this.text) && tj != "") {
                sql += "and (" + tj + ")";
            }
            paramObj.sql = sql;
            tj = "";
        }
        else {
            if (tableName == "") {
                paramObj = null;
            }
            else {
                paramObj.sql = sql;
                paramObj.tableName = tableName;
            }
        }
        return paramObj;
    }


    private function changetSelectTreeRows(tree:XML):void {
        if (tree != null) {
            getSelectTreeRows(tree);
        }
        else {
            this.text = "";
            this.dispatchEvent(new Event("cleanClick"));
        }
    }

    private function getSelectTreeRows(tree:XML):void {
        //获得参照选中数据集
        var selectTree:XML = tree;
        this._cconsultbkfld.removeAll();
        if (tree != null) {
            var obj:Object = new Object();
            obj.cfield = this._cfield;
            if (this._datadictionaryObj.bprefix == "1") {
                this._cabbreviation = null;
                this._cabbreviation = selectTree.attribute("cabbreviation");

                obj.isFirst = false;
                obj.cabbreviation = selectTree.attribute("cabbreviation").toString();
                /*if(this._cabbreviation ==null)
                 {
                 parentForm.dd("null");
                 }
                 else
                 {
                 parentForm.dd(this._cabbreviation);
                 }*/
            }

            var czSql:Object = getSql("2");
            if (czSql != null) {
                var iconsult2:int = int(_datadictionaryObj.iconsult2);
                consultFun(iconsult2, czSql.sql, czSql.tableName, _datadictionaryObj.cselsetvalues2, _datadictionaryObj.btouchrefshow);
            }

            /********************* add by zhong_jing 扔出参照选择的所有记录 **********************/
            isF = true;
            isFirst = true;
            var objInfo:Object = ObjectUtil.getClassInfo(tree);
            var fieldName:Array = objInfo["properties"] as Array;
            if (this._datadictionaryObj.cselsetvalues != null && this._datadictionaryObj.cselsetvalues != "") {
                var paramobj:Object = new Object();
                _allList = new ArrayCollection();
                for each(var q:QName in fieldName) {
                    var cfieldName:String = q.localName.replace("@", "");
                    var str:String = tree.attribute(cfieldName).toString();
                    paramobj[cfieldName] = str;
                }
                _allList.addItem(paramobj);
                obj.allList = this._allList;
            }
            this.dispatchEvent(new onItemDoubleClick("onChangeDoubleEvent", obj));
            /********************************************************************************/
            this._cconsultbkfld.removeAll();
            var cconsultbkfld:String = selectTree.attribute(_datadictionaryObj.cconsultbkfld).toString();
            this._cconsultbkfld.addItem(cconsultbkfld);
            this.text = selectTree.attribute(_datadictionaryObj.cconsultswfld);
            selectedIID = this._cconsultbkfld[0]; //sdy  add
            this.dispatchEvent(new Event("onClick"));
        }
    }

    private function changetSelectListRows(list:ArrayCollection):void {
        if (list != null) {
            getSelectListRows(list);
        }
        else {
            this.text = "";
            this.dispatchEvent(new Event("cleanClick"));
        }
    }

    private function getSelectListRows(list:ArrayCollection):void {
        var str:String = "";
        this._cconsultbkfld.removeAll();
        if (list != null) {
            for (var i:int = 0; i < list.length; i++) {
                var obj:Object = list.getItemAt(i);
                if (i > 0) {
                    str += ",";
                }
                str += obj[_datadictionaryObj.cconsultswfld];
                this._cconsultbkfld.addItem(obj[_datadictionaryObj.cconsultbkfld]);
                selectedIID = this._cconsultbkfld.getItemAt(0).toString();  //sdy  add
            }
            this.text = str;


            var czSql:Object = getSql("2");
            if (czSql != null) {
                if (czSql.hasOwnProperty("sql") && czSql.sql != null && czSql.sql != "") //ll add
                {
                    var iconsult2:int = int(_datadictionaryObj.iconsult2);
                    consultFun(iconsult2, czSql.sql, czSql.tableName, _datadictionaryObj.cselsetvalues2, _datadictionaryObj.btouchrefshow);
                }
            }

            /********************* add by zhong_jing 扔出参照选择的所有记录 **********************/
            isF = true;
            isFirst = true;
            var pramobj:Object = new Object();
            pramobj.cfield = this._cfield;
            if (this._datadictionaryObj.bprefix == "1" && this._datadictionaryObj.bconsultmtbk == "1") {
                this._cabbreviation = null;
                this._cabbreviation = list.getItemAt(0).attribute("cabbreviation");

                pramobj.isFirst = false;
                pramobj.cabbreviation = list.getItemAt(0).attribute("cabbreviation");
            }
            if (this._datadictionaryObj.cselsetvalues != null && this._datadictionaryObj.cselsetvalues != "") {
                this._allList = new ArrayCollection();
                this._allList = list;
                pramobj.allList = this._allList;
            }
            this.dispatchEvent(new onItemDoubleClick("onChangeDoubleEvent", pramobj));
            /********************************************************************************/
            this.dispatchEvent(new Event("onClick"));


        }
    }


    private function enter(event:Event):void {
        if (!_ifFir && CRMtool.isStringNotNull(this.text) && (this._item == "onNew" || this._item == "onEdit")) {
            getV();
        }
    }

    private var isF:Boolean = false;

    private function initText():void {
        var sql:String = "";
        isF = false;
        isFirst = false;
        if (_datadictionaryObj != null && _datadictionaryObj.iconsult > 0) {
            switch (_datadictionaryObj.itype) {
                case 0:
                {
                    sql = _datadictionaryObj.ctreesql;

                    break;
                }
                case 1:
                {
                    sql = _datadictionaryObj.cgridsql;
                    //zmm 取消 201112091849
                    sql = sql.replace("@childsql", getSql().sql);
                    break;
                }
                case 2:
                {
                    sql = _datadictionaryObj.cgridsql;
                    /*	var myPattern:RegExp = /\@join/g;*/
                    sql = sql.replace("@join", "");
                    //zmm 取消 201112091849
                    sql = sql.replace("@childsql", getSql().sql);
                    break;
                }
            }

            if (sql != "") {
                sql = sql.replace("@condition", "");
                if (_datadictionaryObj.cconsultipvf != null && _datadictionaryObj.cconsultipvf != "") {
                    var value:String = "";
                    if (_te != null && _te != "" && _te != "0") {
                        value = _te;
                    }
                    else {
                        return;
                    }
                    var str:String = _datadictionaryObj.cconsultipvf;
                    var strArr:Array = str.split(",");
                    if (sql.lastIndexOf("where") == -1) {
                        sql += " where (";
                    }
                    else {
                        sql += " and (";
                    }
                    sql += _datadictionaryObj.cconsulttable + "." + _datadictionaryObj.cconsultbkfld + "='" + value + "'";
                    sql += ")";
                    AccessUtil.remoteCallJava("DatadictionaryDest", "getValue", getTextValueBack, sql, null, false);
                }
            }
        }
    }


    private function getV():void {
        var sql:String = "";
        /*isF=false;*/
        if (_datadictionaryObj != null && _datadictionaryObj.iconsult > 0) {
            switch (_datadictionaryObj.itype) {
                case 0:
                {
                    sql = _datadictionaryObj.ctreesql;

                    break;
                }
                case 1:
                {
                    sql = _datadictionaryObj.cgridsql;
                    sql = sql.replace("@childsql", getSql().sql);
                    break;
                }
                case 2:
                {
                    sql = _datadictionaryObj.cgridsql;
                    sql = sql.replace("@join", "");
                    sql = sql.replace("@childsql", getSql().sql);
                    break;
                }
            }

            if (sql != "") {
                sql = sql.replace("@condition", "");
                if (_datadictionaryObj.cconsultipvf != null && _datadictionaryObj.cconsultipvf != "") {
                    var value:String = "";
                    if (this.text != "") {
                        value = this.text;
                    }
                    else {
                        return;
                    }
                    var str:String = _datadictionaryObj.cconsultipvf;
                    var strArr:Array = str.split(",");
                    if (sql.lastIndexOf("where") == -1) {
                        sql += " where (";
                    }
                    else {
                        sql += " and (";
                    }

                    tj = "";
                    for (var i:int = 0; i < strArr.length; i++) {

                        if (strArr[i] == _datadictionaryObj.cconsultbkfld) {
                            var regx:RegExp = new RegExp("^[0-9]");
                            var isFand:Boolean = regx.test(value);
                            if (isFand) {
                                if (i > 0 && tj != "") {
                                    tj += " or ";
                                }
                                tj += _datadictionaryObj.cconsulttable + "." + strArr[i] + " like '%" + value + "%'";
                            }
                        }
                        else {
                            if (i > 0 && tj != "") {
                                tj += " or ";
                            }
                            tj += _datadictionaryObj.cconsulttable + "." + strArr[i] + " like '%" + value + "%'";
                        }

                    }
                    if (tj == "") {
                        return;
                    }
                    else {
                        sql += tj;
                    }
                    sql += ")";

                    AccessUtil.remoteCallJava("DatadictionaryDest", "getValue", getValueBack, sql, null, false);
                }
            }
        }
    }

    private function getTextValueBack(event:ResultEvent):void {
        var valueArr:ArrayCollection = event.result as ArrayCollection;
        if (valueArr.length == 1) {
            this.text = valueArr.getItemAt(0)[_datadictionaryObj.cconsultswfld];
            this._cconsultbkfld = new ArrayCollection();
            _cconsultbkfld.addItem(valueArr.getItemAt(0)[_datadictionaryObj.cconsultbkfld]);
            if (!isF) {
                isF = true;
                if (!isFirst) {
                    var obj:Object = new Object();
                    obj.cfield = this._cfield;
                    if (valueArr.getItemAt(0).hasOwnProperty("cabbreviation")) {
                        obj.cabbreviation = valueArr.getItemAt(0).cabbreviation;
                        obj.isFirst = isFirst;

                    }
                    isFirst = true;
                    this.dispatchEvent(new onItemDoubleClick("onItemDoubleClick", obj));
                }
            }
        }
        this.focusEnabled = false;
    }

    private function getValueBack(event:ResultEvent):void {
        var valueArr:ArrayCollection = event.result as ArrayCollection;
        if (valueArr.length == 1) {
            this.text = valueArr.getItemAt(0)[_datadictionaryObj.cconsultswfld];
            this._cconsultbkfld = new ArrayCollection();
            _cconsultbkfld.addItem(valueArr.getItemAt(0)[_datadictionaryObj.cconsultbkfld]);
            if (!isF) {
                isF = true;
                if (!isFirst) {
                    isFirst = true;
                    var obj:Object = new Object();
                    obj.cfield = this._cfield;
                    if (valueArr.getItemAt(0).hasOwnProperty("cabbreviation")) {
                        obj.cabbreviation = valueArr.getItemAt(0).cabbreviation;
                        obj.isFirst = isFirst;

                    }
                    if (this._datadictionaryObj.cselsetvalues != null && this._datadictionaryObj.cselsetvalues != "") {
                        this._allList = new ArrayCollection();
                        this._allList = valueArr;
                        obj.allList = this._allList;
                    }
                    this.dispatchEvent(new onItemDoubleClick("onItemDoubleClick", obj));
                }
            }

            var czSql:Object = getSql("2");
            if (czSql != null) {
                var iconsult2:int = int(_datadictionaryObj.iconsult2);
                consultFun(iconsult2, czSql.sql, czSql.tableName, _datadictionaryObj.cselsetvalues2, _datadictionaryObj.btouchrefshow);
            }
        }
        else if (valueArr.length == 0) {
            isF = false;
            isFirst = false;
            if (CRMtool.isStringNull(this._te) && this._te == "0" && CRMtool.isStringNull(this.text)) {
                this.text = "";
            }
            else {
                if (_datadictionaryObj.cprogram == null || _datadictionaryObj.cprogram == "") {
                    this.text = "";
                }
                else {
                    var itemObj:Object = new Object();
                    itemObj.outifuncregedit = _datadictionaryObj.ifuncregedit;
                    itemObj.title = _datadictionaryObj.funcname;
                    itemObj.operId = "onListNew";
                    itemObj.getV = getV;
                    CRMtool.openMenuItemFormOther(_datadictionaryObj.cprogram, itemObj, _datadictionaryObj.funcname, "onListNew");
                }
            }
            this.dispatchEvent(new Event("cleanClick"));
        }
        else {
            if (_datadictionaryObj.iconsult > 0) {
                _ifFir = true;
                if (_datadictionaryObj.itype == 0) {
                    new ConsultTree(changetSelectTreeRows, _datadictionaryObj.iconsult, _datadictionaryObj.bconsultendbk);
                }
                else if (_datadictionaryObj.itype == 1) {
                    new ConsultList(changetSelectListRows, _datadictionaryObj.iconsult, _datadictionaryObj.bconsultmtbk, getSql().sql, this._datadictionaryObj.cconsultcondition);
                }
                else {
                    new ConsultTreeList(changetSelectListRows, _datadictionaryObj.iconsult, _datadictionaryObj.bconsultmtbk, getSql().sql, this._datadictionaryObj.cconsultcondition);
                }
            }
        }
        this.focusEnabled = false;
        isFirst = true;
    }


    //是否显示图标按钮
    [Bindable]
    public var _visibleIcon:Boolean = false;
    public function get visibleIcon():Boolean {
        return _visibleIcon;
    }

    public function set visibleIcon(value:Boolean):void {
        _visibleIcon = value;
        if (_datadictionaryObj.iconsult > 0) {
            this.lbr_search.visible = value;
        }
        /*this.useHandCursor=_visibleIcon;
         this.buttonMode=_visibleIcon;*/
    }

    protected function tnp_button_mouseOutHandler(event:MouseEvent):void {
        if (this.visibleIcon == true) {
            this.lbr_search.alpha = 0;
        }
    }

    protected function tnp_button_mouseOverHandler(event:MouseEvent):void {
        if (this.visibleIcon == true) {
            this.lbr_search.alpha = 1;
        }
    }

    protected function tnp_text_mouseOverHandler(event:MouseEvent):void {
        if (this.visibleIcon == true) {
            this.lbr_search.alpha = 1;
        }
    }

    protected function tnp_text_mouseOutHandler(event:MouseEvent):void {
        if (this.visibleIcon == true) {
            this.lbr_search.alpha = 0;
        }
    }

}
}