package yssoft.comps.frame.module {
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.ui.Keyboard;

import mx.collections.ArrayCollection;
import mx.collections.ArrayList;
import mx.containers.HBox;
import mx.controls.DateField;
import mx.controls.LinkButton;
import mx.controls.TextInput;
import mx.events.CalendarLayoutChangeEvent;
import mx.formatters.DateFormatter;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;

import spark.components.NumericStepper;

import yssoft.comps.ConsultList;
import yssoft.comps.ConsultTree;
import yssoft.comps.ConsultTreeList;
import yssoft.comps.frame.module.Basic.BasicNumericStepper;
import yssoft.frameui.formopt.OperDataAuth;
import yssoft.interfaces.IAllCrmInput;
import yssoft.models.CRMmodel;
import yssoft.scripts.selfoptimp.ConsultRelated;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.tools.DateUtil;

/********************************************
 * 1、参照需要做以下操作：
 *   1）、根据参照编码查询参照的详细信息
 *   2）、根据存入数据库字段，进行翻译参照。
 *   3）、打开参照，并返回参照信息。
 *   4）、输入验证字段，并返回参照信息。
 * 2、参照要注意以下几个地方：
 *   1）、根据参照查询字段，进行赛选参照。
 *   2）、根据参照固定条件字段，进行赛选参照
 *   3）、根据参照时候返回表体参照，来弹出另一个参照。
 *         （1）、一种情况是打开参照。
 *      (2)、一种是不打开参照
 *      4）、参照返回多个值，根据参照的赋值条件，进行参照赋值。
 * 3、参照事件采取的是回车事件。
 *
 ********************************************/
[Event(name="initialization", type="flash.events.Event")]
[Event(name="complete", type="flash.events.Event")]
[Event(name="valueChange", type="flash.events.Event")]
[Event(name="numberEvent", type="flash.events.Event")]
[Event(name="yesConsultList", type="flash.events.Event")]
[Event(name="noConsultList", type="flash.events.Event")]

public class CrmEapTextInput extends TextInput implements IAllCrmInput {
    //linkButton图标
    [Embed(source="/yssoft/assets/images/search.png")]
    private const _defaultIcon:Class;

    [Embed(source="/yssoft/assets/images/popDataTime.png")]
    private const _dateTimedefaultIcon:Class;

    public var parentForm:Object;
    public var search:String = "";

    //CrmEapRadianVbox
    public var paramForm:CrmEapRadianVbox;
    private var me:CrmEapTextInput;
    //所有信息
    [Bindable]
    private var _singleType:Object = new Object();

    /*[Bindable]*/
    public function set singleType(value:Object):void {
        this._singleType = value;
        this.invalidateDisplayList();
    }

    public function get singleType():Object {
        return this._singleType;
    }

    //判断原来的文本框中的值发生改变
    private var _oldText:String = "";

    public function set oldText(value:String):void {
        this._oldText = value;
    }

    public function get oldText():String {
        return this._oldText;
    }

    //参照查询结果
    private var _consultList:ArrayCollection = new ArrayCollection();

    public function set consultList(value:ArrayCollection):void {
        this._consultList = value;
    }

    public function get consultList():ArrayCollection {
        return this._consultList;
    }


    //表头触发表体参照信息
    private var _consultList2:ArrayCollection = new ArrayCollection();

    public function set consultList2(value:ArrayCollection):void {
        this._consultList2 = value;
    }

    public function get consultList2():ArrayCollection {
        return this._consultList2;
    }

    private var _isBody:Boolean = false;


    //弹出时间窗口
    private var _crmDateChooser:DateField;

    //时间格式化
    private var _crmdateform:DateFormatter;


    public var _cconsultbkfldTypeList:ArrayCollection;

    private var _typeList:ArrayCollection;

    //获得参照查询条件
    public var conditionSqlFunction:Function;

    private var relationshipList:ArrayList;


    public var count:int = 0;

    //传入表体公式
    public var subCfunctionObjArr:ArrayCollection = new ArrayCollection();

    public var triggerbodyconsult:ArrayCollection = new ArrayCollection();

    private var isFirst:Boolean = true;

    private var valueObj:Object;

    public var dataObj:Object;
    public var crmName:String; //lr add
    public var consultRelated:ConsultRelated = new ConsultRelated();//参照注入类
    public function CrmEapTextInput() {
        me = this;
        //数据源改变事件
        this.styleName = "contentTextInput";
        this.restrict = "^'";

        this.addEventListener("yesConsultList", function (e:Event):void {
            consultRelated.doConsultAfter(_consultList, _singleType, me, paramForm);
        });

        this.addEventListener("noConsultList", function (e:Event):void {
            consultRelated.doConsultAfter(_consultList, _singleType, me, paramForm, false);
        });
    }

    var crmDateFai:DateField;

    public var consultAuth:OperDataAuth;
    public var consultAuthSql:String = "";

    /****************************************************
     *
     * 使用标准MXML标签向组件添加元素
     * 1、如果存在参照，则查询出参照信息,sql。验证字段信息
     * 2、如果文本框有值，并参照需要验证，并且存在参照，则把初始化信息查询出来。
     * 3、如果存在表头触发表体信息，则查询出表头触发表体参照的信息，sql
     * 4、如果存在表头触发表体信息，文本框有值，表头触发表体参照不需要弹出窗口，并是新增状态。
     *
     ****************************************************/
    override protected function createChildren():void {
        super.createChildren();

        parentForm = this.owner;

        if (this._singleType == "" || this._singleType == null) {
            this._singleType = parentForm.singleType;
        }
        if (null != this._singleType.cobjectname) {
            this.name = this._singleType.cobjectname;
        }

        if (_singleType.cifuncregedit > 0 && CRMtool.getBoolean(_singleType.bdataauth)) {
            consultAuth = new OperDataAuth();
            consultAuth.addEventListener("onGet_FundataauthSucess", function (e:Event):void {
                if(paramForm){
                    var ifuncregedit:int = paramForm.formIfunIid;
                    if ((ifuncregedit == 46 || ifuncregedit == 149 || ifuncregedit == 194 || ifuncregedit == 62 || ifuncregedit == 45)
                            && (cfield == "icustomer" || cfield == "icustperson")) {
                        consultAuthSql = "";
                    } else {
                        consultAuthSql = consultAuth.getdataauthcondition("01", _singleType.cifuncregedit, CRMmodel.userId, CRMmodel.hrperson.idepartment);
                    }
                }
            });
            consultAuth.get_fundataauth({ifuncregedit: _singleType.cifuncregedit});
        }

        if (int(_singleType.iconsult) > 0 || (null != _singleType.cconsultfunction && "" != _singleType.cconsultfunction)) {
            if (null != _singleType.cconsultfunction && "" != _singleType.cconsultfunction) {
                resolveFormula();
            }
            this.addChild(createLinkButton(this._defaultIcon));
        }
        else {
            var ctype:String = this._singleType.ctype;
            switch (ctype) {
                case "int":
                {
                    this.restrict = "0-9\\-";
                    break;
                }
                case "float":
                {
                    this.restrict = "0-9.\\-";
                    break;
                }
                case "datetime":
                {
                    this.enabled = false;
                    var idatetype:int = int(this._singleType.idatetype);
                    switch (idatetype) {
                        case 0:
                        {
                            this.enabled = false;
                            crmDateFai = new DateField();
                            crmDateFai.yearNavigationEnabled = true;
                            crmDateFai.name = "crmDateField";
                            crmDateFai.percentWidth = 100;
                            crmDateFai.dayNames = ['日', '一', '二', '三', '四', '五', '六'];
                            crmDateFai.monthNames = ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'];
                            crmDateFai.formatString = "YYYY-MM-DD";
                            crmDateFai.restrict = "0-9\\-";
                            crmDateFai.setStyle("borderStyle", "none");
                            crmDateFai.focusEnabled = true;//表体日期不获得焦点，获取不到值
                            this.addChild(crmDateFai);
                            break;
                        }
                        case 1:
                        {
                            this.minWidth = 200;
                            var childHbox:HBox = new HBox();
                            childHbox.name = "childHbox";
                            childHbox.percentWidth = 20;
                            childHbox.horizontalScrollPolicy = "off";
                            this.addChild(childHbox);
                            childHbox.setStyle("verticalAlign", "middle");
                            childHbox.setStyle("horizontalAlign", "right");
                            crmDateFai = new DateField();
                            crmDateFai.yearNavigationEnabled = true;
                            crmDateFai.percentWidth = 100;
                            crmDateFai.dayNames = ['日', '一', '二', '三', '四', '五', '六'];
                            crmDateFai.monthNames = ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'];
                            crmDateFai.restrict = "0-9\\-";
                            crmDateFai.formatString = "YYYY-MM-DD";
                            crmDateFai.setStyle("borderStyle", "none");
                            crmDateFai.name = "crmDateField";
                            crmDateFai.editable = true;
                            crmDateFai.focusEnabled = true;
                            childHbox.addChild(crmDateFai);
                            childHbox.addChild(createTime());
                            this.addChild(childHbox);
                            break;
                        }
                        case 2:
                        {
                            this.setStyle("verticalAlign", "middle");
                            this.setStyle("horizontalAlign", "left");
                            this.minWidth = 130;
                            this.addChild(createTime());
                            break;
                        }
                    }
                    break;
                }
            }
        }


        /* if (CRMtool.isStringNotNull(this._singleType.cnewdefault) && this._singleType.curButtonStatus == "onNew") {
         this.text = CRMtool.defaultValue(this._singleType.cnewdefault);
         }
         else*/
        if (CRMtool.isStringNotNull(this._singleType.ceditdefault) && this._singleType.curButtonStatus == "onEdit") {
            this.text = CRMtool.defaultValue(this._singleType.ceditdefault);
        }

        this.doubleClickEnabled = true;
        this.addEventListener(MouseEvent.DOUBLE_CLICK, onDoubleClick);

        if (Boolean(this._singleType.bread)) {
            this.editable = false;
        }
        else {
            //焦点离开事件
            this.addEventListener(FocusEvent.FOCUS_OUT, onFocusOut);
            this.addEventListener(FocusEvent.FOCUS_IN, function (event:FocusEvent):void {
                CRMtool.setIME();
            });

            //lr add 回车时间支持参照翻译
            this.addEventListener(KeyboardEvent.KEY_DOWN, function (event:KeyboardEvent):void {
                if (event.keyCode == Keyboard.ENTER) {
                    //onFocusOutHandle();
                }
            });
        }
        _singleType.value = this.text;

        var cconsultconfld:String = _singleType.cconsultconfld;
        if (CRMtool.isStringNotNull(cconsultconfld) && null != conditionSqlFunction) {
            //查询条件
            var conditionSql:String = this.conditionSqlFunction(_singleType.cconsultconfld);
            singleType.cconsultconfSql = conditionSql;
        }
        if (int(_singleType.iconsult) > 0 || (_singleType.cconsultfunction != null && "" != _singleType.cconsultfunction)) {
            //查询参照信息
            AccessUtil.remoteCallJava("CommonalityDest", "consultInit", consultInitBack, _singleType, null, false);
        }

        if (this.numChildren > 1) {
            var lbr_search:LinkButton;
            if (this.getChildAt(this.numChildren - 1) is LinkButton) {
                lbr_search = this.getChildAt(this.numChildren - 1) as LinkButton;
            }
            else if (this.getChildAt(this.numChildren - 1) is HBox) {
                var hbx:HBox = this.getChildAt(this.numChildren - 1) as HBox;
                lbr_search = hbx.getChildByName("lbr_search") as LinkButton;
            }

            if (null != lbr_search) {
                //打开窗口
                lbr_search.focusEnabled = false;
                lbr_search.addEventListener(MouseEvent.CLICK, openWindow);
            }
        }

        this.dispatchEvent(new Event("complete"));
    }

    private function onDoubleClick(event:MouseEvent):void {
        if (paramForm && (paramForm is CrmEapRadianVbox) && int(_singleType.iconsult) > 0
                && consultList && consultList.length > 0
                && singleType.cconsultbkfld == "iid" && consultList[0].iid > 0
                && editable == false) {

            if (_singleType.consultifuncregedit > 0)
                CRMtool.isHasAuth(_singleType.consultifuncregedit, consultList[0].iid);
            else if ((_singleType.cconsultfunction + "").search("iconsult=@ifunconsult@|consultSql=dbo.getSql(@ifunconsult@)") > -1) {
                var sql:String = "select ifuncregedit from ac_consultset where iid=" + int(_singleType.iconsult);
                AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
                    var ac:ArrayCollection = event.result as ArrayCollection;
                    if (ac && ac.length > 0) {
                        var ifuncregedit = ac[0].ifuncregedit;
                        if (ifuncregedit > 0)
                            CRMtool.isHasAuth(ifuncregedit, consultList[0].iid);
                    }
                }, sql);
            }
        }
    }


    private function consultInitBack(event:ResultEvent):void {
        var result:Object = event.result;
        if (result.hasOwnProperty("consultList")) {
            this._consultList = event.result.consultList as ArrayCollection;

            if (null != this._consultList && this._consultList.length > 0) {
                this.text = this._consultList.getItemAt(0)[this._singleType.cconsultswfld];
                //旧文本框的值
                this._oldText = this._consultList.getItemAt(0)[this._singleType.cconsultswfld];

            }

            if (this._singleType.bprefix == "true" || Boolean(this._singleType.bprefix)) {
                //YJ Add
                onGetBillNumberHandle();
            }
        }

        if (result.hasOwnProperty("cconsultbkfldTypeList")) {
            _cconsultbkfldTypeList = event.result.cconsultbkfldTypeList as ArrayCollection;
        }

        if (result.hasOwnProperty("typeList")) {
            this._typeList = event.result.typeList as ArrayCollection;
        }
        if (result.hasOwnProperty("newRelationshipList")) {
            relationshipList = event.result.newRelationshipList as ArrayList;
        }

        if (result.hasOwnProperty("triggerbodyconsult")) {
            triggerbodyconsult = result.triggerbodyconsult as ArrayCollection;
        }
        //初始化完成
        this.dispatchEvent(new Event("initialization"));

    }

    //计算linkButton的位置，始终放在最后位置。
    override protected function updateDisplayList(uw:Number, uh:Number):void {
        super.updateDisplayList(uw, uh);
        if (this.numChildren > 1) {
            if (this.getChildAt(numChildren - 1) is HBox) {
                var childHbox:HBox = (HBox)(this.getChildAt(numChildren - 1));
                if (null != childHbox) {
                    childHbox.setActualSize(this.width, this.height);
                    childHbox.x = uw - childHbox.width - 2;
                    childHbox.y = (uh - childHbox.height) / 2;
                }
            }
            else if (this.getChildAt(numChildren - 1) is LinkButton) {
                var lbr_search:LinkButton = (LinkButton)(this.getChildAt(numChildren - 1));
                if (null != lbr_search) {
                    lbr_search.setActualSize(16, 16);
                    lbr_search.x = uw - lbr_search.width - 2;
                    lbr_search.y = (uh - lbr_search.height) / 2;
                }
            }
            else if (this.getChildAt(numChildren - 1) is DateField) {
                var crmDateField:DateField = (DateField)(this.getChildAt(numChildren - 1));
                crmDateField.setActualSize(this.width, this.height);
                crmDateField.x = uw - crmDateField.width - 2;
                crmDateField.y = (uh - crmDateField.height) / 2;
            }
        }
    }

    private function createLinkButton(icon:Class):LinkButton {
        var lbr_search:LinkButton = new LinkButton();
        lbr_search.name = "lbr_search";
        //图标
        lbr_search.setStyle("icon", icon);
        lbr_search.width = 16;
        lbr_search.height = 16;

        //lr add
        lbr_search.visible = this.editable;
        return lbr_search;
    }

    private function onChange(event:CalendarLayoutChangeEvent):void {
        var dt:Date = new Date();
        var stmp:String = _crmdateform.format(event.newDate).substr(0, 11) + _crmdateform.format(dt).substr(11);
        this.text = _crmdateform.format(event.newDate);
        PopUpManager.removePopUp(this._crmDateChooser);
    }

    private function openWindow(event:MouseEvent):void {
        if (null != this._singleType.cconsultfunction && "" != StringUtil.trim(String(this._singleType.cconsultfunction))) {
            subTableAssignment();
        }else {
            consultRelated.doConsultBefore(_singleType, this, paramForm, _fun);
            function _fun():void {
                var consultObj:Object = new Object();
                consultObj.iconsult = me._singleType.iconsult;
                consultObj.bconsultendbk = me._singleType.bconsultendbk;
                consultObj.bconsultmtbk = me._singleType.bconsultmtbk;
                consultObj.cconsultconfSql = "";
                consultObj.cconsultcondition = me._singleType.cconsultcondition;
                consultObj.cconsultconfld = me._singleType.cconsultconfld;
                consultObj.cconsultedit = _singleType.cconsultedit;
                consultObj.itype = me._singleType.itype;
                _isBody = false;
                openConsultWindow(consultObj);

            }
        }
    }

    //是否是表里的渲染器
    public var isItemEditor:Boolean = false;
    //打开参照窗体
    private function openConsultWindow(consultObj:Object):void {
        if (isItemEditor)
            editable = false;

        var itype:int = int(consultObj.itype);
        var conditionSql:String = "";
        var cconsultconfld:String = consultObj.cconsultconfld;
        if (null != conditionSqlFunction && null != cconsultconfld && "" != StringUtil.trim(cconsultconfld)) {
            //查询条件
            conditionSql = this.conditionSqlFunction(consultObj.cconsultconfld);
        }
        search = "";
        if (this.text) {
            search = this.text;
        }
        //this.text = "";

        switch (itype) {
            case 0:
            {
                new ConsultTree(getSelectTreeRows, int(consultObj.iconsult), Boolean(consultObj.bconsultendbk), search, consultObj.cconsultedit);
                break;
            }
            case 1:
            {
                new ConsultList(getSelectListRows, int(consultObj.iconsult), Boolean(consultObj.bconsultmtbk), conditionSql, consultObj.cconsultcondition, search, consultObj.cconsultedit);
                break;
            }
            default:
            {
                new ConsultTreeList(getSelectListRows, int(consultObj.iconsult),
                        Boolean(consultObj.bconsultmtbk), conditionSql, consultObj.cconsultcondition, search, consultObj.cconsultedit);
                break;
            }
        }
    }

    //树参照
    //修改人：王炫皓
    //修改时间：20121206
    private function getSelectTreeRows(tree:XML):void {
        if (!_isBody) {
            //获得参照选中数据集
            this._consultList.removeAll();

            //获得结果集
            this._consultList.addItem(CRMtool.xmlToObject(tree));

            //YJ Add 单据编码
            if (this._singleType.bprefix == "true" || Boolean(this._singleType.bprefix)) {
                onGetBillNumberHandle();
                this.paramForm.onGetNumber();

            }
            var cconsultswfld:String = this._singleType.cconsultswfld as String;
            text = tree.attribute(StringUtil.trim(this._singleType.cconsultswfld));
            this._oldText = tree.attribute(StringUtil.trim(cconsultswfld));
            me.dispatchEvent(new Event("yesConsultList"));
            this.dispatchEvent(new Event("valueChange"));
            cfieldRelationship();
            isFirst = true;
        }
        else {
            //先找到参照表名
            var subCfunctionObj:Object = this.triggerbodyconsult.getItemAt(count);
            var ctable:String = subCfunctionObj.cassignmenttable;

            var tableList:ArrayCollection = valueObj[_singleType.ctable] as ArrayCollection;
            if (tableList == null) {
                tableList = new ArrayCollection();
            }
            switch (subCfunctionObj.iRemoveBody) {
                //全部清空
                case 0:
                {
                    tableList.removeAll();
                    tableList.addAll(zhuanhuan(_consultList, ctable));
                    break;
                }
                case 1:
                {
                    //删除所有表头触发参照
                    for (var i:int = tableList.length - 1; i >= 0; i--) {
                        var oldObj:Object = tableList.getItemAt(i);
                        if (oldObj.ifuncregedit != null) {
                            tableList.removeItemAt(i);
                        }
                    }
                    tableList.addAll(zhuanhuan(_consultList, ctable));
                    break;
                }
                case 2:
                {
                    tableList.addAll(zhuanhuan(_consultList, ctable));
                    break;
                }
            }

            valueObj[ctable] = tableList;

            if (count < this.triggerbodyconsult.length) {
                count++;
                bodyCoult();
                paramForm.setValue(paramForm.fzsj(valueObj), 1, 1);
            }
            else {
                count = 0;
            }

            // lr add
            paramForm.setValue(paramForm.fzsj(valueObj), 1, 1);
            this.dispatchEvent(new Event("yesConsultList"));
        }

    }

    //打开表格参照
    private function getSelectListRows(list:ArrayCollection):void {
        if (!_isBody) {
            this._consultList.removeAll();
            this._consultList = list;

            //YJ Add 单据编码
            if (this._singleType.bprefix == "true" || Boolean(this._singleType.bprefix)) {
                onGetBillNumberHandle();
                this.paramForm.onGetNumber();

            }


            var cconsultswfld:String = me._singleType.cconsultswfld as String;
            if (list.length == 0 || list[0] == null) {
                list.removeAll();
                text = "";
                me._oldText = "";
                me.dispatchEvent(new Event("noConsultList"));
            } else {
                text = list.getItemAt(0)[StringUtil.trim(cconsultswfld)];
                me._oldText = list.getItemAt(0)[StringUtil.trim(cconsultswfld)];
                this.dispatchEvent(new Event("yesConsultList"));
            }

            isFirst = true;
            cfieldRelationship();
            me.dispatchEvent(new Event("valueChange"));
        }
        else {
            this.text = this._oldText;
            //先找到参照表名
            var subCfunctionObj:Object = this.triggerbodyconsult.getItemAt(count);
            var ctable:String = subCfunctionObj.cassignmenttable;

            var tableList:ArrayCollection = valueObj[ctable] as ArrayCollection;

            if (tableList == null) {
                tableList = new ArrayCollection();
            }
            switch (subCfunctionObj.iRemoveBody) {
                //全部清空
                case 0:
                {
                    tableList.removeAll();
                    tableList.addAll(zhuanhuan(list, ctable));
                    break;
                }
                case 1:
                {
                    //删除所有表头触发参照
                    for (var i:int = tableList.length - 1; i >= 0; i--) {
                        var oldObj:Object = tableList.getItemAt(i);
                        if (oldObj.ifuncregedit != null) {
                            tableList.removeItemAt(i);
                        }
                    }
                    tableList.addAll(zhuanhuan(list, ctable));
                    break;
                }
                case 2:
                {
                    tableList.addAll(zhuanhuan(list, ctable));
                    break;
                }
            }

            valueObj[ctable] = tableList;

            if (count < this.triggerbodyconsult.length - 1) {
                this.text = this._oldText;
                count++;
                openBodyWindow();
                paramForm.setValue(paramForm.fzsj(valueObj), 1, 1);
            }
            else {
                count = 0;
            }

            // lr add
            paramForm.setValue(paramForm.fzsj(valueObj), 1, 1);
            me.dispatchEvent(new Event("yesConsultList"));
        }

    }

    private function createTime():HBox {
        var timeHbox:HBox = new HBox();
        //小时
        var hour:BasicNumericStepper = new BasicNumericStepper();
        hour.height = 20;
        hour.maximum = 24;
        hour.focusEnabled = false;
        timeHbox.addChild(hour);

        //分钟
        var minute:BasicNumericStepper = new BasicNumericStepper();
        minute.height = 20;
        minute.maximum = 59;
        minute.focusEnabled = false;
        timeHbox.addChild(minute);

        //秒
        var second:BasicNumericStepper = new BasicNumericStepper();
        second.height = 20;
        second.maximum = 59;
        second.focusEnabled = false;
        timeHbox.addChild(second);

        return timeHbox;
    }

    override public function set editable(value:Boolean):void {
        var _value:Boolean = value;
        if (this.paramForm != null) {
            //YJ Modify 2012-04-25 新增只读
            if (this.paramForm.curButtonStatus == "onNew" && Boolean(this._singleType.bread)) {
                value = false;
            }
            //YJ Modify 2012-04-25 修改只读
            if (this.paramForm.curButtonStatus == "onEdit" && Boolean(this._singleType.beditread)) {
                value = false;
            }

            //金税收费单  如果是税控收费字段的editable不被初始化   by ln  2014-03-27
            if (this._singleType.cobjectname == 'ui_tr_charge_frevenue') {
                value = _value;
            }


        }

        super.editable = value;
        if ((null != _singleType.iconsult && int(_singleType.iconsult) > 0) || (null != _singleType.cconsultfunction && "" != _singleType.cconsultfunction)) {
            if (this.getChildByName("lbr_search")) {
                //lzx 修改，定位不准numChildren不确定
                //if (this.getChildAt(numChildren - 1) is LinkButton) {
                //var lbr_search:LinkButton = (LinkButton)(this.getChildAt(numChildren - 1));
                var lbr_search:LinkButton = (LinkButton)(this.getChildByName("lbr_search"));
                lbr_search.visible = value;
            }

            if (paramForm && (paramForm is CrmEapRadianVbox)) {
                this.setStyle("color", "0x018ccf");
                this.toolTip = null;
            }

            if (!value) {
                if (paramForm && (paramForm is CrmEapRadianVbox) && consultList && consultList.length > 0
                        && singleType.cconsultbkfld == "iid" && consultList[0].iid > 0
                        && ( _singleType.consultifuncregedit > 0
                                || (_singleType.cconsultfunction + "").search("iconsult=@ifunconsult@|consultSql=dbo.getSql(@ifunconsult@)") > -1)) {

                    this.setStyle("color", "0xff8100");
                    this.toolTip = "双击浏览详细信息";
                }
            }

        }
        else {
            var ctype:String = this._singleType.ctype;
            if ("datetime" == ctype) {
                var idatetype:int = int(this._singleType.idatetype);
                var crmdate:DateField;
                switch (idatetype) {
                    case 0:
                    {
                        crmdate = this.getChildByName("crmDateField") as DateField;
                        if (value) {
                            crmdate.editable = value;
                            crmdate.enabled = value;
                        }
                        else {
                            crmdate.enabled = value;
                        }
                        break;
                    }
                    case 1:
                    {
                        var hbox:HBox = this.getChildByName("childHbox") as HBox;
                        hbox.enabled = value;
                        break;
                    }
                    case 2:
                    {
                        var hbox:HBox = this.getChildAt(this.numChildren - 1) as HBox;
                        hbox.enabled = value;
                        break;
                    }
                }
            }
        }
    }

    override public function set text(value:String):void {
        var ctype:String = this._singleType.ctype;

        var cre:String = this._singleType.cregularfunction as String;

        if ("null" == value || CRMtool.isStringNull(value)) {
            super.text = "";
            return;
        }
        if (CRMtool.isStringNotNull(StringUtil.trim(text)) && CRMtool.isStringNotNull(cre)
                && (!validatorReg(cre) )) {
            CRMtool.showAlert(this._singleType.cregularmessage);
            setFocus();
            return;
        }

        if (null == this._singleType.iconsult && int(this._singleType.iconsult) == 0) {
            //格式化事件
            switch (ctype) {
                case "datetime":
                {
                    var crmdate:DateField;
                    var idatetype:int = int(this._singleType.idatetype);
                    if (idatetype == 0) {
                        crmdate = this.getChildByName("crmDateField") as DateField;
                    }
                    else if (idatetype == 1) {
                        var hbox:HBox = this.getChildByName("childHbox") as HBox;
                        crmdate = hbox.getChildByName("crmDateField") as DateField;
                    }
                    if (value.indexOf("服务器当前日期") != -1 || value.indexOf("服务器当前时间") != -1) {
                        if (value.indexOf("0") != -1) {
                            crmdate.text = StringUtil.trim(value.substr(0, value.indexOf("0")));
                        }
                        else {
                            crmdate.text = value;
                            if (int(this._singleType.idatetype) == 2 || int(this._singleType.idatetype) == 1) {
                                var childHbox:HBox = (HBox)(this.getChildAt(numChildren - 1));
                                var childHbox1:HBox = (HBox)(childHbox.getChildAt(1));
                                var hour:NumericStepper = childHbox1.getChildAt(0) as NumericStepper;
                                var minute:NumericStepper = childHbox1.getChildAt(1) as NumericStepper;
                                var second:NumericStepper = childHbox1.getChildAt(2) as NumericStepper;

                                hour.value = 0;
                                minute.value = 0;
                                second.value = 0;
                            }
                        }
                    }
                    else {
                        //时间格式化
                        _crmdateform = new DateFormatter();
                        _crmdateform.formatString = "YYYY-MM-DD JJ:NN:SS";
                        var valueStr:String = _crmdateform.format(value);

                        if (valueStr.substr(0, 4) == "1900")//lr add 无效数据不显示
                            return;

                        if (CRMtool.isStringNotNull(StringUtil.trim(valueStr))) {
                            if (this.getChildAt(this.numChildren - 1) is HBox) {
                                var childHbox:HBox = (HBox)(this.getChildAt(numChildren - 1));

                                if (null != childHbox) {
                                    var childHbox1:HBox = (HBox)(childHbox.getChildAt(1));
                                    if (int(this._singleType.idatetype) == 2 || int(this._singleType.idatetype) == 1) {
                                        var dateArr:Array = valueStr.substr(11).split(":");

                                        var hour:NumericStepper = childHbox1.getChildAt(0) as NumericStepper;
                                        if (null != hour) {
                                            hour.value = int(dateArr[0]);
                                        }

                                        var minute:NumericStepper = childHbox1.getChildAt(1) as NumericStepper;
                                        if (null != minute) {
                                            minute.value = int(dateArr[1]);
                                        }

                                        var second:NumericStepper = childHbox1.getChildAt(2) as NumericStepper;
                                        if (null != second) {
                                            second.value = int(dateArr[2]);
                                        }

                                        if (int(this._singleType.idatetype) == 1) {
                                            crmdate.text = valueStr.substr(0, 11);
                                        }
                                    }
                                }
                            }
                            else {

                                crmdate.text = _crmdateform.format(valueStr).substr(0, 11);
                            }
                        }
                        else if (CRMtool.isStringNotNull(StringUtil.trim(valueStr))) {
                            crmdate.text = _crmdateform.format(StringUtil.trim(valueStr)).substr(0, 11);
                        }
                    }
                    break;
                }
                case "nvarchar":
                {
                    if (CRMtool.isStringNotNull(value) && this._singleType.ilength) {
                        var length:int = CRMtool.getStrActualLen(value);
                        var str:String = "输入超长，不能超过" + int(this._singleType.ilength) + "字节";
                        if (int(this._singleType.ilength) < length || text == str) {
                            super.text = "输入超长，不能超过" + this._singleType.ilength + "字节";
                            this.setStyle("color", "red");
                            setFocus();
                        }
                        else {
                            super.text = value;
                        }
                    }
                    else {
                        super.text = value;
                    }
                    break;
                }
                case "float":
                {
                    var idecimal:int = this._singleType.idecimal == null ? 2 : this._singleType.idecimal;
                    if (StringUtil.trim(value) != "0" && CRMtool.isStringNotNull(StringUtil.trim(value)) && !validatorFloat(Number(StringUtil.trim(value)).toFixed(idecimal))) {
                        super.text = "浮点类型格式不正确";
                        this.setStyle("color", "red");
                        setFocus();
                    }
                    else {
                        super.text = Number(StringUtil.trim(value)).toFixed(int(this._singleType.idecimal));
                    }
                    break;
                }
                default:
                {
                    super.text = value;
                    break;
                }
            }
        }
        else {
            super.text = value;
        }

        this.editable = this.editable;
    }

    override public function get text():String {
        var ctype:String = this._singleType.ctype;
        var value:String = "";
        var idatetype:int = int(this._singleType.idatetype);
        var crmdate:DateField;
        if (ctype == "datetime") {
            if (idatetype == 0) {
                crmdate = this.getChildByName("crmDateField") as DateField;
                if (CRMtool.isStringNotNull(crmdate.text)) {
                    value = crmdate.text;
                }
                else {
                    value = null;
                }
            }
            else {
                var hbox:HBox = this.getChildByName("childHbox") as HBox;
                if (idatetype == 1) {
                    crmdate = hbox.getChildByName("crmDateField") as DateField;
                    if (CRMtool.isStringNotNull(crmdate.text)) {
                        value = StringUtil.trim(crmdate.text);
                    }
                    else {
                        value = null;
                    }
                }
                if (CRMtool.isStringNotNull(value)) {
                    var timer:HBox = hbox.getChildAt(hbox.numChildren - 1) as HBox;
                    var hour:NumericStepper = timer.getChildAt(0) as NumericStepper;
                    var minute:NumericStepper = timer.getChildAt(1) as NumericStepper;
                    var second:NumericStepper = timer.getChildAt(2) as NumericStepper;
                    value += " " + (hour.value.toString().length == 1 ? "0" + hour.value.toString() : hour.value.toString()) + ":";
                    value += (minute.value.toString().length == 1 ? "0" + minute.value.toString() : minute.value.toString()) + ":";
                    value += (second.value.toString().length == 1 ? "0" + second.value.toString() : second.value.toString());
                }
            }
            return value;
        }
        if (CRMtool.isStringNull(super.text)) {
            value = null;
        }
        else {
            value = super.text;
        }
        return value;
    }

    //小数判断
    private function validatorFloat(value:String):Boolean {
        var regEx:RegExp = /^[-+]?[0-9]*\.?[0-9]+$/;
        return regEx.test(StringUtil.trim(value));
    }

    //时间验证
    private function validatorDate(value:String):Boolean {
        var regEx:RegExp = /^((((1[6-9]|[2-9]\d)\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\d|3[01]))|(((1[6-9]|[2-9]\d)\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\d|30))|(((1[6-9]|[2-9]\d)\d{2})-0?2-(0?[1-9]|1\d|2[0-8]))|(((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29-)) (20|21|22|23|[0-1]?\d):[0-5]?\d:[0-5]?\d$/;
        return regEx.test(StringUtil.trim(value));
    }

    //正则表达式判断
    private function validatorReg(regExStr:String):Boolean {
        var regEx:RegExp = new RegExp(regExStr, "g");
        return regEx.test(StringUtil.trim(text));
    }

    private function onFocusOut(event:FocusEvent):void {
        onFocusOutHandle();
    }

    private function onFocusOutHandle():void {
        //lr add 如果不可编辑就让 focusout不起作用，避免不必要的问题。
        if (!this.editable)
            return;
        var swapString:String = this.text;
        if (CRMtool.isStringNotNull(this.text)) {

            var isFind:Boolean = false;
            isFirst = true;
            //不为参照时执行
            if ((null == this._singleType.iconsult || int(this._singleType.iconsult) == 0) && (null == _singleType.cconsultfunction || "" == _singleType.cconsultfunction)) {
                isFind = true;

                //格式化事件
                switch (this._singleType.ctype) {
                    case "datetime":
                    {
                        var crmdate:DateField;
                        var idatetype:int = int(this._singleType.idatetype);
                        if (idatetype == 0) {
                            crmdate = this.getChildByName("crmDateField") as DateField;
                        }
                        else if (idatetype == 1) {
                            var hbox:HBox = this.getChildByName("childHbox") as HBox;
                            crmdate = hbox.getChildByName("crmDateField") as DateField;
                        }
                        if (crmdate.text != "服务器当前日期" && crmdate.text != "服务器当前时间") {
                            var isOK:Boolean = true;
                            if (crmdate.text.indexOf("-") == -1) {
                                isOK = false;
                            }
                            else {
                                var results:Array = crmdate.text.split('-');
                                //校验分为3段
                                if (results.length != 3) {
                                    isOK = false;
                                }
                                else {
                                    //校验年月日为有效数值
                                    if (Number(results[0]) == 0 || Number(results[1]) == 0 || Number(results[2]) == 0 || Number(results[1]) > 12 || Number(results[2]) > 31) {
                                        isOK = false;
                                    }
                                }

                                var reg:RegExp = /([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8])))/;

                                if (DateUtil.isLeapYear(Number(results[0]))) {
                                    reg = /([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-9])))/;
                                }


                                var dateStr:String = this.text;
                                if (!( reg.test(dateStr) || dateStr == "")) {
                                    isOK = false;
                                }
//								var reg:RegExp = /([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8])))/;
//								//var reg:RegExp = /^(((([0-9]{2}(([2468][048])|([02468][48])|([13579][26])))|((([02468][048])|([13579][26]))(00)))(-)(2|02)(-)(([0]?[1-9])|([1-2][0-9])))|((([0-9]{2}([02468][1235679])|([13579][01345789]))|((([02468][1235679])|([13579][01345789]))(00)))(-)(2|02)(-)(([0]?[1-9])|([1][0-9])|([2][0-8])))|(([0-9]{4})(-)(((([0]?(1|3|5|7|8))|(10|12))(-)(([0]?[1-9])|([1-2][0-9])|30|31))|(((([0]?(4|6|9))|11))(-)(([0]?[1-9])|([1-2][0-9])|30)))))/;
//								var dateStr:String = this.text;
//                                if (!( reg.test(dateStr) || dateStr == "")) {
//                                    isOK = false;
//                                }
//
//                                var results:Array = crmdate.text.split('-');
//                                //校验分为3段
//                                if (results.length != 3) {
//                                    isOK = false;
//                                }
//                                else {
//                                    //校验年月日为有效数值
//                                    if (Number(results[0]) == 0 || Number(results[1]) == 0 || Number(results[2]) == 0 || Number(results[1]) > 12 || Number(results[2]) > 31) {
//                                        isOK = false;
//                                    }
//                                }
                            }
                            if (!isOK) {
                                toolTip = "日期格式不正确";
                                //crmdate.text = null;
                                setFocus();
                            }
                            else {
                                toolTip = null;
                            }
                        }
                        break;
                    }
                    case "nvarchar":
                    {
                        if (CRMtool.isStringNotNull(this.text) && this._singleType.ilength) {
                            var length:int = CRMtool.getStrActualLen(this.text);
                            if (int(this._singleType.ilength) < length) {
                                // lr  modify
                                toolTip = "输入超长，不能超过" + this._singleType.ilength + "字符";
                                CRMtool.showAlert(toolTip);
                                //text=null;
                                setFocus();
                            }
                            else {
                                toolTip = null;
                            }
                        }
                        break;
                    }
                    case "float":
                    {
                        var idecimal:int = this._singleType.idecimal == null ? 2 : this._singleType.idecimal;
                        if (StringUtil.trim(this.text) != "0" && CRMtool.isStringNotNull(StringUtil.trim(this.text)) && !validatorFloat(Number(StringUtil.trim(this.text)).toFixed(idecimal))) {
                            toolTip = "浮点类型格式不正确";
                            text = null;
                            setFocus();
                        }
                        else {
                            toolTip = null;
                        }
                        break;
                    }
                }

                if ((this._singleType.cfunction != null && this._singleType.cfunction != "") || (this._singleType.cresfunction != null && this._singleType.cresfunction != "") || !this._singleType.hasOwnProperty("cfunction")) {
                    this.dispatchEvent(new Event("valueChange"));
                }

                var cre:String = this._singleType.cregularfunction as String;


                if (CRMtool.isStringNotNull(StringUtil.trim(text)) && CRMtool.isStringNotNull(cre)
                        && (!validatorReg(cre))) {
                    CRMtool.showAlert(this._singleType.cregularmessage);
                    setFocus();
                    return;
                }
            }
            else if ((int(this._singleType.iconsult) > 0 || (null != _singleType.cconsultfunction && "" != _singleType.cconsultfunction))) {
                if (this._singleType.bconsultcheck == "false" || !Boolean(this._singleType.bconsultcheck)) {
                    isFind = true;
                }
				//20150723 lhl  焦点离开，参照不自动翻译 修改 把|| 改成 &&
                else if (this._oldText == this.text && (_consultList.length > 0 && this._oldText == this._consultList.getItemAt(0)[this._singleType.cconsultswfld])) {
                    isFind = true;
                }
                else {
                    if (null != this._consultList && this._consultList.length > 0) {
                        var cconsultswfldValue:String = StringUtil.trim(this.consultList.getItemAt(0)[this._singleType.cconsultswfld]);
                        var cconsultbkfldValue:String = StringUtil.trim(this.consultList.getItemAt(0)[this._singleType.cconsultbkfld]);


                        if (this.text == cconsultswfldValue || this.text == cconsultbkfldValue) {
                            this.text = this.consultList.getItemAt(0)[this._singleType.cconsultswfld];
                            isFind = true;
                        }
                        else {
                            for (var i:int = 0; i < this._typeList.length; i++) {
                                if (this.text == this.consultList.getItemAt(0)[this._typeList.getItemAt(i).cfield]) {
                                    isFind = true;
                                    break;
                                }
                            }
                            if (isFind) {
                                this.text = this.consultList.getItemAt(0)[this._singleType.cconsultswfld];
                            }
                        }
                    }
                }
            }
            else if (this._oldText == this.text) {
                isFind = true;
            }
            else if ((null == this._singleType.iconsult || int(this._singleType.iconsult) == 0) && (this._singleType.bconsultcheck == "false" || !Boolean(this._singleType.bconsultcheck))) {
                isFind = true;
            }
            if (!isFind) {
                consultRelated.doConsultBefore(_singleType, this, paramForm, _fun);
                function _fun():void {
                    var obj:Object = new Object();
                    obj.type = "1";
                    obj.value = me.text;
                    obj.typeList = me._typeList;
                    obj.cconsultcondition = me._singleType.cconsultcondition;
                    obj.cconsulttable = me._singleType.cconsulttable;
                    var cconsultconfld:String = _singleType.cconsultconfld;
                    var consultSql:String = _singleType.consultSql;
                    var cconsultedit:String = _singleType.cconsultedit;

                    if (CRMtool.isStringNull(cconsultedit))
                        cconsultedit = "";

                    consultSql = consultSql.replace("@cconsultedit", cconsultedit);
                    consultSql = CRMtool.replaceSystemValues(consultSql);

                    if (CRMtool.isStringNotNull(cconsultconfld)) {
                        //查询条件
                        var conditionSql:String = me.conditionSqlFunction(_singleType.cconsultconfld);
                        obj.consultSql = consultSql.replace("@childsql", conditionSql);
                    }
                    else {
                        obj.consultSql = consultSql;
                    }
                    //wxh modify 特殊写参照支持，回车翻译
                   /* if (paramForm == null || paramForm.formIfunIid == 439   )
                        AccessUtil.remoteCallJava("CommonalityDest", "queryconsult", onFoucsBack, obj);
                    else
                        AccessUtil.remoteCallJava("CommonalityDest", "queryconsult", onFoucsBack, obj, "", null);*/
					if(paramForm!=null){//lhl 20150723热线沟通参照多次触发查询问题
					if (paramForm.formIfunIid == 439)
					AccessUtil.remoteCallJava("CommonalityDest", "queryconsult", onFoucsBack, obj);
					else
					AccessUtil.remoteCallJava("CommonalityDest", "queryconsult", onFoucsBack, obj, "", null);
					}  
                }
            }
        }
        else {
            cleanAll();
            this._consultList.removeAll();
            this._oldText = "";
            this.dispatchEvent(new Event("valueChange"));
            this.dispatchEvent(new Event("noConsultList"));
        }
    }


    //删除所有信息
    private function cleanAll():void {
        if (!paramForm)
            return;
        var obj:Object = paramForm.getValue();
        if ((obj.ifuncregedit == 0 || obj.ifuncregedit == "" || obj.ifuncregedit == null) && this.relationshipList != null) {
            obj.ifunconsult = 0;
            paramForm.setValue(paramForm.fzsj(obj), 1, 1);
        }
    }

    private function onFoucsBack(event:ResultEvent):void {
        this._consultList = event.result.consultList as ArrayCollection;


        //单据编码
        if ((this._singleType.bprefix == "true" || Boolean(this._singleType.bprefix))) {

            //YJ Add
            onGetBillNumberHandle();
            this.paramForm.onGetNumber();

        }


        if (this._consultList.length == 0) {
            this.text = "";
            this._oldText = "";
            this._consultList.removeAll();
            this.dispatchEvent(new Event("noConsultList"));
            this.dispatchEvent(new Event("valueChange"));
        }
        else if (this._consultList.length == 1) {
            var cconsultswfld:String = this._singleType.cconsultswfld as String;
            this.text = this._consultList.getItemAt(0)[StringUtil.trim(cconsultswfld)];
            this._oldText = this._consultList.getItemAt(0)[StringUtil.trim(cconsultswfld)];
            cfieldRelationship();
            this.dispatchEvent(new Event("yesConsultList"));
            this.dispatchEvent(new Event("ERf"));
            this.dispatchEvent(new Event("valueChange"));
        }
        else {
            this._consultList.removeAll();
            var consultObj:Object = new Object();
            consultObj.iconsult = this._singleType.iconsult;
            consultObj.bconsultendbk = this._singleType.bconsultendbk;
            consultObj.bconsultmtbk = this._singleType.bconsultmtbk;
            consultObj.cconsultconfSql = "";
            consultObj.cconsultcondition = this._singleType.cconsultcondition;
            consultObj.cconsultconfld = this._singleType.cconsultconfld;
            consultObj.cconsultedit = this._singleType.cconsultedit;
            consultObj.itype = this._singleType.itype;
            /*	search="";
             if (this.text)
             {
             search=this.text;
             }
             this.text="";*/
            /*consultObj.search=search;*/
            _isBody = false;
            openConsultWindow(consultObj);
        }

        //保证拉式生单的 参照能够自动翻译
        if (paramForm) {
            paramForm.refAllGrid();
        }

    }
    //业务字典参照翻译
    public function onDataChange():void {
        if (null != this._singleType.iconsult && int(this._singleType.iconsult)
                && CRMtool.isStringNotNull(this.text) && this.text != "-1"
                && this._cconsultbkfldTypeList != null && this._cconsultbkfldTypeList.length > 0) {
            if (this._cconsultbkfldTypeList.getItemAt(0).type == "int" && !validatorReg("^[0-9]*$")) {
                return;
            }
            if (this._oldText == this.text) {
                return;
            }
            var obj:Object = new Object();
            obj.type = "0";
            obj.value = this.text;
            obj.typeList = this._cconsultbkfldTypeList;
            obj.cconsultcondition = this._singleType.cconsultcondition;
            obj.cconsulttable = this._singleType.cconsulttable;

            if ((this._singleType.cconsultfunction + "").search("iconsult=@ifunconsult@|consultSql=dbo.getSql(@ifunconsult@)") > -1) {//说明是拉式生单，特殊参照，替换掉任何条件  by lr
                obj.cconsultcondition = "";
            }

            var cconsultconfld:String = _singleType.cconsultconfld;
            var consultSql:String = _singleType.consultSql;

            consultSql = consultSql.replace("@cconsultedit", "");

            if (CRMtool.isStringNotNull(cconsultconfld)&& null != conditionSqlFunction) {
                //查询条件
                var conditionSql:String = this.conditionSqlFunction(_singleType.cconsultconfld);
                obj.consultSql = consultSql.replace("@childsql", conditionSql);
            }
            else {
                obj.consultSql = consultSql;
            }
            AccessUtil.remoteCallJava("CommonalityDest", "queryconsult", onDataChangeBack, obj, null, false);
        }
    }
    //表单关系参照翻译
    public function onDataChange2(dataObj:Object):void {
        var iifuncregedit:int = dataObj.mainValue.iifuncregedit;
        var ifuncregedit:int = dataObj.mainValue.ifuncregedit;
        var ifunconsult:int = dataObj.mainValue.ifunconsult;
		var iid:String = dataObj.mainValue.iinvoice+"";//参照翻译对应的内码值
        //业务字典计算公式
        var sql:String = "select @ifunconsult@ iconsult,dbo.getSql(@ifunconsult@) consultSql, "+
                "dbo.getTable(@ifuncregedit@) cconsulttable,dbo.getItype(@ifunconsult@) itype, "+
                "dbo.getCconsultbkfld(@iifuncregedit@,@ifuncregedit@) cconsultbkfld, "+
                "dbo.getCconsultswfld(@iifuncregedit@,@ifuncregedit@) cconsultswfld, "+
                "dbo.getCconsultipvf(@iifuncregedit@,@ifuncregedit@) cconsultipvf, "+
                "dbo.getCconsultconfld(@iifuncregedit@,@ifuncregedit@) cconsultconfld, "+
                "dbo.getCconsultcondition(@iifuncregedit@,@ifuncregedit@) cconsultcondition ";

        sql = sql.split("@iifuncregedit@").join(iifuncregedit);
        sql = sql.split("@ifuncregedit@").join(ifuncregedit);
        sql = sql.split("@ifunconsult@").join(ifunconsult);

        AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
            var ac:ArrayCollection = event.result as ArrayCollection;
            if(ac && ac.length > 0 && ac[0].consultSql){
                var obj:Object = new Object();
                obj.type = 0;
				
				if(text != iid) text = iid;
                obj.value = text;
				
                obj.typeList = new ArrayCollection([{cfield:"iid",type:"int"}]);
                obj.cconsultcondition = "";//参照条件（特殊参照，替换掉任何条件）
                obj.cconsulttable = ac[0].cconsulttable;//参照表名
                _singleType.cconsultswfld = ac[0].cconsultswfld;//参照返回显示字段
                _singleType.cconsultbkfld = ac[0].cconsultbkfld;//参照返回存入字段
				_singleType.iconsult = ac[0].iconsult;
				
                var cconsultconfld:String = ac[0].cconsultconfld;//参照查询根据字段
                var consultSql:String = ac[0].consultSql;//参照sql

                consultSql = consultSql.replace("@cconsultedit", "");

                if (CRMtool.isStringNotNull(cconsultconfld)) {
                    //查询条件
                    var conditionSql:String = this.conditionSqlFunction(ac[0].cconsultconfld);
                    obj.consultSql = consultSql.replace("@childsql", conditionSql);
                }
                else {
                    obj.consultSql = consultSql;
                }
                AccessUtil.remoteCallJava("CommonalityDest", "queryconsult", onDataChangeBack, obj, null, false);
            }
        },sql);
    }

    private function onDataChangeBack(event:ResultEvent):void {
        this._consultList = event.result.consultList as ArrayCollection;
        if (this._consultList.length == 0) {
            this.text = "";
            this._oldText = "";
            this._consultList.removeAll();

            //lr add
            this.dispatchEvent(new Event("noConsultList"));
            this.dispatchEvent(new Event("valueChange"));
        }
        else if (this._consultList.length == 1) {
            var cconsultswfld:String = this._singleType.cconsultswfld as String;
            this.text = this._consultList.getItemAt(0)[StringUtil.trim(cconsultswfld)];
            this._oldText = this._consultList.getItemAt(0)[StringUtil.trim(cconsultswfld)];

            //lr add
            this.dispatchEvent(new Event("yesConsultList"));
            this.dispatchEvent(new Event("ERf"));
            this.dispatchEvent(new Event("valueChange"));

            //单据编码
            if ((this._singleType.bprefix == "true" || Boolean(this._singleType.bprefix))) {

                //YJ Add
                onGetBillNumberHandle();
                this.paramForm.onGetNumber();

            }
        }

    }

    private function cfieldRelationship():void {
        if (null == me.paramForm) {
            return;
        }
        if (!isFirst) {
            return;
        }

        isFirst = false;
        var ctable:String = me._singleType.ctable;
        var objArr:ArrayCollection = new ArrayCollection();
        valueObj = paramForm.getValue();

        var fieldObj:Object = new Object();
        if (me.relationshipList != null) {
            var relationshipMap:Object = null;
            var cfieldRelationshipList:ArrayCollection = null;
            if (me.relationshipList.length == 1) {
                var newRelationshipMap = me.relationshipList.getItemAt(0);
                //拉式升单
                if (newRelationshipMap.relationshipMap.bpull == "1"
                        || Boolean(newRelationshipMap.relationshipMap.bpull)
                        || newRelationshipMap.relationshipMap.bpull == "true") {
                    //拉式升单，并且相关单据功能注册码相同
                    if (newRelationshipMap.relationshipMap.ifuncregedit2 == valueObj.ifuncregedit) {
                        relationshipMap = newRelationshipMap.relationshipMap;
                        cfieldRelationshipList = newRelationshipMap.cfieldRelationshipList as ArrayCollection;
                    }
                }
                //普通参照赋值
                else {
                    relationshipMap = newRelationshipMap.relationshipMap;
                    cfieldRelationshipList = newRelationshipMap.cfieldRelationshipList as ArrayCollection;
                }
            }
            else {
                //如果不止一条记录，则只能为拉式升单
                for (var i:int = 0; i < relationshipList.length; i++) {
                    var newRelationshipMap = me.relationshipList.getItemAt(i);

                    if (newRelationshipMap.relationshipMap.ifuncregedit2 == valueObj.ifuncregedit) {
                        relationshipMap = newRelationshipMap.relationshipMap;
                        cfieldRelationshipList = newRelationshipMap.cfieldRelationshipList as ArrayCollection;
                        break;
                    }

                }
            }

            if (null != cfieldRelationshipList) {
                if (Boolean(_singleType.bmain) || _singleType.bmain == "true") {
                    //表头赋值
                    for (var i:int = 0; i < cfieldRelationshipList.length; i++) {
                        var obj:Object = cfieldRelationshipList.getItemAt(i);
                        var ctable2:String = obj.ctable2;
                        if (ctable2.toLocaleUpperCase() == ctable.toLocaleUpperCase()) {
                            var consultValue:Object = _consultList.getItemAt(0);
                            valueObj[obj.cfield2] = consultValue[obj.cfield];
                        }
                    }

                    paramForm.setValue(paramForm.fzsj(valueObj), 1, 1);
                    //表头触发表体参照
                    if (null != triggerbodyconsult && triggerbodyconsult.length > 0) {
                        bodyCoult();
                    }
                } else {
                    if (null != _consultList) {
                        var tableList:ArrayCollection = valueObj[_singleType.ctable] as ArrayCollection;
                        if (tableList != null) {
                            for (var j:int = 0; j < cfieldRelationshipList.length; j++) {
                                var cfieldRelationship:Object = cfieldRelationshipList.getItemAt(j);
                                var ctable2:String = cfieldRelationship.ctable2;
                                if (ctable2.toLocaleUpperCase() == ctable.toLocaleUpperCase()) {
                                    if (null != dataObj) {
                                        tableList.getItemAt(tableList.getItemIndex(dataObj))[String(cfieldRelationship.cfield2)] = _consultList.getItemAt(0)[String(cfieldRelationship.cfield)];
                                    }
                                    else {
                                        tableList.getItemAt(0)[String(cfieldRelationship.cfield2)] = _consultList.getItemAt(0)[String(cfieldRelationship.cfield)];
                                    }
                                    if (int(cfieldRelationship.iconsult) > 0) {
                                        if (null != dataObj) {
                                            tableList.getItemAt(tableList.getItemIndex(dataObj))[cfieldRelationship.cfield2 + "_Name"] = _consultList.getItemAt(0)[cfieldRelationship.cconsultswfld];
                                        }
                                        else {
                                            tableList.getItemAt(0)[cfieldRelationship.cfield2 + "_Name"] = _consultList.getItemAt(0)[cfieldRelationship.cconsultswfld];
                                        }
                                    }
                                }
                            }
                            if (null != dataObj) {
                                tableList.getItemAt(tableList.getItemIndex(dataObj)).iinvoices = _consultList.getItemAt(0).iid;
                                tableList.getItemAt(tableList.getItemIndex(dataObj)).ifuncregedits = me._singleType.consultifuncregedit;
                            }
                            else {
                                tableList.getItemAt(0).iinvoices = _consultList.getItemAt(0).iid;
                                tableList.getItemAt(0).ifuncregedits = me._singleType.consultifuncregedit;
                            }
                        }
                        //重新封要插入装记录
                        for (var i:int = 1; i < me._consultList.length; i++) {
                            var _consultObj:Object = _consultList.getItemAt(i);
                            var value:Object = tableList.getItemAt(i);
                            for (var j:int = 0; j < cfieldRelationshipList.length; j++) {
                                var cfieldRelationship:Object = cfieldRelationshipList.getItemAt(j);
                                var ctable2:String = cfieldRelationship.ctable2;
                                if (ctable2.toLocaleUpperCase() == ctable.toLocaleUpperCase()) {
                                    value[cfieldRelationship.cfield2] = _consultObj[cfieldRelationship.cfield];
                                    if (int(cfieldRelationship.iconsult) > 0) {
                                        value[cfieldRelationship.cfield2 + "_Name"] = _consultObj[cfieldRelationship.cconsultswfld];
                                    }
                                }
                            }
                            value.iinvoices = _consultObj.iid;
                            value.ifuncregedits = me._singleType.consultifuncregedit;
                            if (relationshipMap.bpull == "true" || Boolean(relationshipMap.bpull)) {
                                value.ifuncregedit = valueObj.ifuncregedit;
                                value.iinvoice = valueObj.iinvoice;
                            }
//                            tableList.addItem(value); wxh modify 这句话造成参照多选多增N行空行

                        }
                    }
                    paramForm.setValue(paramForm.fzsj(valueObj), 1, 1);
                }
            }
        }
    }


    public function clean():void {
        this._consultList.removeAll();
        this._consultList2.removeAll();
        var crmdate:DateField;
        var idatetype:int = int(this._singleType.idatetype);
        if (idatetype == 0) {
            crmdate = this.getChildByName("crmDateField") as DateField;
        }
        else if (idatetype == 1) {
            var hbox:HBox = this.getChildByName("childHbox") as HBox;
            if (hbox != null) {
                crmdate = hbox.getChildByName("crmDateField") as DateField;
            }

        }
        if (null != crmdate) {
            crmdate.text = "";
        }
        if (this.getChildAt(this.numChildren - 1) is HBox) {
            var childHbox:HBox = (HBox)(this.getChildAt(numChildren - 1));

            if (null != childHbox) {
                var childHbox1:HBox = (HBox)(childHbox.getChildAt(1));
                if (int(this._singleType.idatetype) == 2 || int(this._singleType.idatetype) == 1) {
                    var hour:NumericStepper = childHbox1.getChildAt(0) as NumericStepper;
                    if (null != hour) {
                        hour.value = 0;
                    }

                    var minute:NumericStepper = childHbox1.getChildAt(1) as NumericStepper;
                    if (null != minute) {
                        minute.value = 0;
                    }

                    var second:NumericStepper = childHbox1.getChildAt(2) as NumericStepper;
                    if (null != second) {
                        second.value = 0;
                    }

                }
            }
        }
    }

    private function empty(event:Event):void {
        if (CRMtool.isStringNull(this.text)) {
            clean();
        }
    }


    //YJ Add 单据编码
    private function onGetBillNumberHandle():void {

        //单据编码
        if (this._singleType.bprefix == "true" || Boolean(this._singleType.bprefix)) {

            if (null != this._consultList && this._consultList.length > 0) {
                //YJ Modify 2012-04-12 加入单据编码
                if (parentForm is SingleVouch) {
                    var crmEap:CrmEapRadianVbox = this.paramForm as CrmEapRadianVbox;

                    if (crmEap != null && crmEap.curButtonStatus != "onGiveUp") {
                        //YJ Add 2012-04-24 单据编码所需参数赋值
                        onSetBillNumberParam(this._consultList.getItemAt(0));
                        //							if(this.paramForm.numFlag == 1){
                        crmEap.numbercount++;
                        //							}
                        //							if(!this.paramForm.hasEventListener("numberEvent")){
                        this.paramForm.dispatchEvent(new Event("numberEvent"));
                        //							}
                    }
                }
            }

        }

    }


    //YJ Add 2012-04-24
    private function onSetBillNumberParam(params:Object):void {

        var curField:String = this.singleType.cfield + "";//当前字段
        var curValue:String = "";//字段对应的值
        var crmEap:CrmEapRadianVbox = this.paramForm as CrmEapRadianVbox;

        if (crmEap == null) return;
        if (params.hasOwnProperty("cabbreviation")) curValue = params.cabbreviation;

        var billnumberObj:Object = {};
        billnumberObj.curField = curField;//字段名称
        billnumberObj.curValue = curValue;//字段值

        crmEap.billnumberArr.addItem(billnumberObj);

    }


    //初始化参照公式
    private function resolveFormula():void {
        var cconsultfunction:String = this._singleType.cconsultfunction;
        if (CRMtool.isStringNull(StringUtil.trim(cconsultfunction))) {
            return;
        }
        var cconsultfunctions:Array = StringUtil.trim(cconsultfunction).split("|");
        var crmEap:CrmEapRadianVbox = this.paramForm as CrmEapRadianVbox;
        for (var i:int = 0; i < cconsultfunctions.length; i++) {
            var cconsultfunctionStr:String = cconsultfunctions[i];
            var cconsultfunctionStrs:Array = cconsultfunctionStr.split("=");
            var cfunctionObj:Object = new Object();
            cfunctionObj.cfield = cconsultfunctionStrs[0];
            var cfunctionstr:String = cconsultfunctionStrs[1];
            cfunctionObj.cfunction = cfunctionstr;
            var cfields:ArrayCollection = new ArrayCollection();
            for (var j:int = 0; j < crmEap.vouchFormArr.length; j++) {
                var datadictionaryObj:Object = crmEap.vouchFormArr.getItemAt(j);
                if (datadictionaryObj.childMap is ArrayCollection) {
                    var childList:ArrayCollection = datadictionaryObj.childMap as ArrayCollection;
                    for each(var item:Object in childList) {
                        var cfieldStr:String = item.cfield;

                        if (cfunctionstr.indexOf("@" + cfieldStr + "@") != -1) {
                            var cfieldObj:Object = new Object();
                            cfieldObj.cfield = cfieldStr;
                            cfieldObj.ctable = "";
                            cfieldObj.ctype = item.ctype;
                            switch (item.ctype) {
                                case "int":
                                {
                                    cfieldObj.value = 0;
                                    break;
                                }
                                case "nvarchar":
                                {
                                    cfieldObj.value = "";
                                    break;
                                }
                                case "float":
                                {
                                    cfieldObj.idecimal = item.idecimal;
                                    cfieldObj.value = Number("0").toFixed(int(item.idecimal));
                                    break;
                                }
                                case "datetime":
                                {
                                    cfieldObj.value = "";
                                    break;
                                }
                                case "bit":
                                {
                                    cfieldObj.value = 0;
                                    break;
                                }
                                default:
                                {
                                    break;
                                }
                            }
                            if (null != cfieldObj) {
                                cfields.addItem(cfieldObj);
                            }
                        }
                    }
                }
            }
            cfunctionObj.cfields = cfields;
            subCfunctionObjArr.addItem(cfunctionObj);
        }
    }

    //打开参照，获得要打开的参照
    public function subTableAssignment():void {
        count = 0;
        if (null == this.paramForm) {
            return;
        }

        var obj:Object = paramForm.getValue();

        if (obj.ifunconsult == null || obj.ifunconsult == "" || obj.ifunconsult == 0) {
            return;
        }

        //不用判断，绝对是拉式升单
        if (this.relationshipList != null) {
            var relationshipMap:Object = null;
            var cfieldRelationshipList:ArrayCollection = null;
            if (this.relationshipList.length == 1) {
                var newRelationshipMap = this.relationshipList.getItemAt(0);
                //拉式升单
                if (newRelationshipMap.relationshipMap.bpull == "1"
                        || Boolean(newRelationshipMap.relationshipMap.bpull)
                        || newRelationshipMap.relationshipMap.bpull == "true") {
                    //拉式升单，并且相关单据功能注册码相同
                    if (newRelationshipMap.relationshipMap.ifuncregedit2 == obj.ifuncregedit) {
                        relationshipMap = newRelationshipMap.relationshipMap;
                        cfieldRelationshipList = newRelationshipMap.cfieldRelationshipList as ArrayCollection;
                    }
                }
            }
            else {
                //如果不止一条记录，则只能为拉式升单
                for (var i:int = 0; i < relationshipList.length; i++) {
                    var newRelationshipMap = this.relationshipList.getItemAt(i);

                    if (newRelationshipMap.relationshipMap.ifuncregedit2 == obj.ifuncregedit) {
                        relationshipMap = newRelationshipMap.relationshipMap;
                        cfieldRelationshipList = newRelationshipMap.cfieldRelationshipList as ArrayCollection;
                        break;
                    }

                }
            }

            var sql:String = "";
            var newcfunction:String = null;
            var crmEap:CrmEapRadianVbox = this.paramForm as CrmEapRadianVbox;
            var obj:Object = crmEap.getValue();
            for (var i:int = 0; i < this.subCfunctionObjArr.length; i++) {
                newcfunction = null;
                var cfunctionObj:Object = subCfunctionObjArr.getItemAt(i);
                var cfunction:String = cfunctionObj.cfunction;
                var cfields:ArrayCollection = cfunctionObj.cfields as ArrayCollection;
                var cfield:String = cfunctionObj.cfield;
                if (cfields.length > 0) {
                    for (var j:int = 0; j < cfields.length; j++) {
                        var cfieldObj:Object = cfields.getItemAt(j);
                        var value:String = "";
                        switch (cfieldObj.ctype) {
                            case "int":
                            {
                                if (cfieldObj.value != null && cfieldObj.value != "") {
                                    value = cfieldObj.value;
                                }
                                else {
                                    if (obj[cfieldObj.cfield] != null) {
                                        value = obj[cfieldObj.cfield];
                                    }
                                    else {
                                        value = "0";
                                    }

                                }
                                break;
                            }
                            case "nvarchar":
                            {
                                if (cfieldObj.value != "") {
                                    value = "'" + cfieldObj.value + "'";
                                }
                                else {
                                    if (obj[cfieldObj.cfield] != null) {
                                        value = "'" + obj[cfieldObj.cfield] + "'";
                                    }
                                    else {
                                        value = "";
                                    }
                                }
                                break;
                            }
                            case "float":
                            {
                                if (cfieldObj.value != Number("0").toFixed(int(cfieldObj.idecimal))) {
                                    value = cfieldObj.value;
                                }
                                else {
                                    if (obj[cfieldObj.cfield] != null) {
                                        value = Number(obj[cfieldObj.cfield]).toFixed(int(cfieldObj.idecimal));
                                    }
                                    else {
                                        value = Number("0").toFixed(int(cfieldObj.idecimal));
                                    }
                                }
                                break;
                            }
                            case "datetime":
                            {
                                if (cfieldObj.value != "") {
                                    value = "'" + cfieldObj.value + "'";
                                }
                                else {
                                    value = "";
                                }
                                break;
                            }
                            default:
                            {
                                break;
                            }
                        }
                        if (newcfunction == null) {
                            newcfunction = cfunction.replace("@" + cfieldObj.cfield + "@", value) + " " + cfield;
                        }
                        else {
                            newcfunction = newcfunction.replace("@" + cfieldObj.cfield + "@", value);
                        }
                    }
                }
                else {
                    newcfunction = cfunction;
                }
                if (newcfunction != null) {
                    if (sql != "") {
                        sql += ","
                    }
                    sql += newcfunction;
                }
            }

            var pzsql:String = "select " + sql;
            //调用后台方法
            AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (evt:ResultEvent):void {
                var rArr:ArrayCollection = evt.result as ArrayCollection;
                var rObj:Object = rArr.getItemAt(0);
                if (rArr == null || rArr.length == 0) {
                    return;
                }
                else {
                    _singleType.iconsult = rObj.iconsult;
                    _singleType.consultSql = rObj.consultSql;
                    _singleType.cconsulttable = rObj.cconsulttable;
                    _singleType.itype = rObj.itype;
                    _singleType.cconsultbkfld = rObj.cconsultbkfld;
                    _singleType.cconsultswfld = rObj.cconsultswfld;
                    _singleType.cconsultipvf = rObj.cconsultipvf;
                    _singleType.cconsultconfld = rObj.cconsultconfld;
                    _singleType.cconsultcondition = rObj.cconsultcondition;
                }

                //获得参照类型
                var typeobj:Object = new Object();
                typeobj.cconsultbkfld = rObj.cconsultbkfld;
                typeobj.cconsultipvf = rObj.cconsultipvf;
                typeobj.iconsult = rObj.iconsult;
                AccessUtil.remoteCallJava("CommonalityDest", "getTepeList", function (evt:ResultEvent):void {

                    var result:Object = evt.result;
                    _typeList = new ArrayCollection();
                    var tyList:ArrayCollection = result.typeList as ArrayCollection;
                    _typeList.addAll(tyList);
                    _cconsultbkfldTypeList = new ArrayCollection();

                    var cconsultArr:ArrayCollection = result.cconsultbkfldTypeList as ArrayCollection;
                    _cconsultbkfldTypeList.addAll(cconsultArr);

                    var consultObj:Object = new Object();
                    consultObj.iconsult = _singleType.iconsult;
                    consultObj.consultSql = _singleType.consultSql;
                    consultObj.cconsulttable = _singleType.cconsulttable;
                    consultObj.itype = _singleType.itype;
                    consultObj.cconsultbkfld = _singleType.cconsultbkfld;
                    consultObj.cconsultswfld = _singleType.cconsultswfld;
                    consultObj.cconsultipvf = _singleType.cconsultipvf;
                    consultObj.cconsultconfld = _singleType.cconsultconfld;
                    consultObj.cconsultcondition = _singleType.cconsultcondition;
                    search = "";
                    if (text) {
                        search = text;
                    }
                    text = "";
                    consultObj.search = search;
                    _isBody = false;
                    openConsultWindow(consultObj);
                }, typeobj, null, false);
            }, pzsql, null, false);
        }
    }


    //打开表头触发表体窗口
    private function openBodyWindow():void {
        //打开参照窗口
        var subCfunctionObj:Object = this.triggerbodyconsult.getItemAt(count);
        var obj:Object = paramForm.getValue();
        if (this.relationshipList != null) {
            var relationshipMap:Object = null;
            var cfieldRelationshipList:ArrayCollection = null;
            if (this.relationshipList.length == 1) {
                var newRelationshipMap = this.relationshipList.getItemAt(0);
                //拉式升单
                if (newRelationshipMap.relationshipMap.bpull == "1"
                        || Boolean(newRelationshipMap.relationshipMap.bpull)
                        || newRelationshipMap.relationshipMap.bpull == "true") {
                    //拉式升单，并且相关单据功能注册码相同
                    if (newRelationshipMap.relationshipMap.ifuncregedit2 == obj.ifuncregedit) {
                        relationshipMap = newRelationshipMap.relationshipMap;
                        cfieldRelationshipList = newRelationshipMap.cfieldRelationshipList as ArrayCollection;
                    }
                }
                //普通参照赋值
                else {
                    relationshipMap = newRelationshipMap.relationshipMap;
                    cfieldRelationshipList = newRelationshipMap.cfieldRelationshipList as ArrayCollection;
                }
            }
            else {
                //如果不止一条记录，则只能为拉式升单
                for (var i:int = 0; i < relationshipList.length; i++) {
                    var newRelationshipMap = this.relationshipList.getItemAt(i);

                    if (newRelationshipMap.relationshipMap.ifuncregedit2 == obj.ifuncregedit) {
                        relationshipMap = newRelationshipMap.relationshipMap;
                        cfieldRelationshipList = newRelationshipMap.cfieldRelationshipList as ArrayCollection;
                        break;
                    }

                }
            }

            if (subCfunctionObj.consultifuncregedit != valueObj.ifuncregedit
                    && (relationshipMap != null && (relationshipMap.bpull == "true" || Boolean(relationshipMap.bpull)))) {
                if (count < triggerbodyconsult.length - 1) {
                    count++;
                    openBodyWindow();
                    return;
                }
                else {
                    return;
                }
            }

            //先解析sql
            var cconsultconfld:String = subCfunctionObj.cconsultconfld;
            subCfunctionObj.cconsultconfSql = conditionSqlFunction(cconsultconfld);
            subCfunctionObj.search = "";
            _isBody = true;
            openConsultWindow(subCfunctionObj);
        }

    }

    //转换选择记录
    private function zhuanhuan(list:ArrayCollection, ctable:String):ArrayCollection {
        var tableList:ArrayCollection = new ArrayCollection();

        var relationshipMap:Object = null;
        var cfieldRelationshipList:ArrayCollection = null;
        var obj:Object = paramForm.getValue();
        if (this.relationshipList.length == 1) {
            var newRelationshipMap = this.relationshipList.getItemAt(0);
            //拉式升单
            if (newRelationshipMap.relationshipMap.bpull == "1"
                    || Boolean(newRelationshipMap.relationshipMap.bpull)
                    || newRelationshipMap.relationshipMap.bpull == "true") {
                //拉式升单，并且相关单据功能注册码相同
                if (newRelationshipMap.relationshipMap.ifuncregedit2 == obj.ifuncregedit) {
                    relationshipMap = newRelationshipMap.relationshipMap;
                    cfieldRelationshipList = newRelationshipMap.cfieldRelationshipList as ArrayCollection;
                }
            }
            //普通参照赋值
            else {
                relationshipMap = newRelationshipMap.relationshipMap;
                cfieldRelationshipList = newRelationshipMap.cfieldRelationshipList as ArrayCollection;
            }
        }
        else {
            //如果不止一条记录，则只能为拉式升单
            for (var i:int = 0; i < relationshipList.length; i++) {
                var newRelationshipMap = this.relationshipList.getItemAt(i);
                if (newRelationshipMap.relationshipMap.ifuncregedit2 == obj.ifuncregedit) {
                    relationshipMap = newRelationshipMap.relationshipMap;
                    cfieldRelationshipList = newRelationshipMap.cfieldRelationshipList as ArrayCollection;
                    break;
                }

            }
        }

        for (var i:int = 0; i < list.length; i++) {
            var _consultObj:Object = list.getItemAt(i);
            var value:Object = new Object();
            for (var j:int = 0; j < paramForm.numChildren; j++) {
                var child:SingleVbox = paramForm.getChildAt(j) as SingleVbox;
                var crmEapVBox:CrmEapVBox = child.getChildAt(child.numChildren - 1) as CrmEapVBox;
                for (var k:int = 0; k < crmEapVBox.numChildren; k++) {
                    if (crmEapVBox.getChildAt(k) is HBox) {
                        var hBox:HBox = crmEapVBox.getChildAt(k) as HBox;
                        for (var l:int = 0; l < hBox.numChildren; l++) {
                            if (hBox.getChildAt(l) is SingleVbox) {
                                var singleVbox:SingleVbox = hBox.getChildAt(l) as SingleVbox;
                                if (singleVbox.singleType.objecttype == "DataGrid" && singleVbox.singleType.ctable == ctable) {
                                    var ui:CrmEapDataGrid = singleVbox.getChildByName(singleVbox.singleType.cobjectname) as CrmEapDataGrid;
                                    var taleChildArr:ArrayCollection = ui.singleType.taleChild as ArrayCollection;
                                    for each(var taleChild:Object in taleChildArr) {
                                        var cfield:String = taleChild.cfield;
                                        if (taleChild.bread == "false" || !Boolean(taleChild.bread)) {
                                            value[cfield + "_enabled"] = "1";
                                        }
                                        if (this.paramForm.curButtonStatus == "onNew" && (null != taleChild.cnewdefault && "" != taleChild.cnewdefault)) {
                                            var cnewdefault:String = taleChild.cnewdefault;
                                            value[cfield] = CRMtool.defaultValue(cnewdefault);
                                            if (null != taleChild && taleChild.iconsult > 0) {
                                                var sql:String = taleChild.consultSql;
                                                sql += " and " + taleChild.cconsultbkfld + "='" + value[cfield] + "'";
                                                //调用后台方法
                                                AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (evt:ResultEvent):void {
                                                    var rArr:ArrayCollection = evt.result as ArrayCollection;
                                                    var newCfield:String = cfield + "_Name";
                                                    if (rArr == null || rArr.length == 0) {
                                                        value[cfield] = null;
                                                        value[newCfield] = null;
                                                    }
                                                    else {
                                                        value[newCfield] = rArr.getItemAt(0)[taleChild.cconsultswfld];
                                                    }
                                                }, sql, null, false);
                                            }
                                        }
                                        else if (this.paramForm.curButtonStatus == "onEdit" && (null != taleChild.ceditdefault && "" != taleChild.ceditdefault)) {
                                            var ceditdefault:String = taleChild.ceditdefault;
                                            value[cfield] = CRMtool.defaultValue(ceditdefault);
                                            if (null != taleChild && taleChild.iconsult > 0) {
                                                var sql:String = taleChild.consultSql;
                                                sql += " and " + taleChild.cconsultbkfld + "='" + value[cfield] + "'";
                                                //调用后台方法
                                                AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (evt:ResultEvent):void {
                                                    var rArr:ArrayCollection = evt.result as ArrayCollection;
                                                    var newCfield:String = cfield + "_Name";
                                                    if (rArr == null || rArr.length == 0) {
                                                        value[cfield] = null;
                                                        value[newCfield] = null;
                                                    }
                                                    else {
                                                        value[newCfield] = rArr.getItemAt(0)[taleChild.cconsultswfld];
                                                    }
                                                }, sql, null, false);
                                            }
                                        }
                                        else if (this.paramForm.curButtonStatus == "onEdit" && (null != taleChild.ceditdedefaultfix && "" != taleChild.ceditdedefaultfix)) {
                                            var ceditdefault:String = taleChild.ceditdedefaultfix;
                                            value[cfield] = CRMtool.defaultValue(ceditdefault);
                                            if (null != taleChild && taleChild.iconsult > 0) {
                                                var sql:String = taleChild.consultSql;
                                                sql += " and " + taleChild.cconsultbkfld + "='" + value[cfield] + "'";
                                                //调用后台方法
                                                AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (evt:ResultEvent):void {
                                                    var rArr:ArrayCollection = evt.result as ArrayCollection;
                                                    var newCfield:String = cfield + "_Name";
                                                    if (rArr == null || rArr.length == 0) {
                                                        value[cfield] = null;
                                                        value[newCfield] = null;
                                                    }
                                                    else {
                                                        value[newCfield] = rArr.getItemAt(0)[taleChild.cconsultswfld];
                                                    }
                                                }, sql, null, false);
                                            }
                                        }
                                        else {
                                            value[cfield] = "";
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }


            for (var j:int = 0; j < cfieldRelationshipList.length; j++) {
                var cfieldRelationship:Object = cfieldRelationshipList.getItemAt(j);
                var ctable2:String = cfieldRelationship.ctable2;
                if (ctable2.toLocaleUpperCase() == ctable.toLocaleUpperCase()) {
                    if (_consultObj.iid == cfieldRelationship.iinvoices) {
                        continue;
                    }
                    value[cfieldRelationship.cfield2] = _consultObj[cfieldRelationship.cfield];
                    if (int(cfieldRelationship.iconsult) > 0) {
                        value[cfieldRelationship.cfield2 + "_Name"] = _consultObj[cfieldRelationship.cconsultswfld];
                    }
                }
            }
            value.iinvoices = _consultObj.iid;
            value.ifuncregedits = this._singleType.consultifuncregedit;
            if (relationshipMap.bpull == "true" || Boolean(relationshipMap.bpull)) {
                value.ifuncregedit = valueObj.ifuncregedit;
                value.iinvoice = valueObj.iinvoice;
            }
            tableList.addItem(value);
        }
        return tableList;
    }


    private function bodyCoult():void {
        if (count < triggerbodyconsult.length) {
            var triggerbodyObj:Object = triggerbodyconsult.getItemAt(count);

            var relationshipMap:Object = null;
            var cfieldRelationshipList:ArrayCollection = null;
            var obj:Object = paramForm.getValue();
            if (this.relationshipList.length == 1) {
                var newRelationshipMap = this.relationshipList.getItemAt(0);
                //拉式升单
                if (newRelationshipMap.relationshipMap.bpull == "1"
                        || Boolean(newRelationshipMap.relationshipMap.bpull)
                        || newRelationshipMap.relationshipMap.bpull == "true") {
                    //拉式升单，并且相关单据功能注册码相同
                    if (newRelationshipMap.relationshipMap.ifuncregedit2 == obj.ifuncregedit) {
                        relationshipMap = newRelationshipMap.relationshipMap;
                        cfieldRelationshipList = newRelationshipMap.cfieldRelationshipList as ArrayCollection;
                    }
                }
                //普通参照赋值
                else {
                    relationshipMap = newRelationshipMap.relationshipMap;
                    cfieldRelationshipList = newRelationshipMap.cfieldRelationshipList as ArrayCollection;
                }
            }
            else {
                //如果不止一条记录，则只能为拉式升单
                for (var i:int = 0; i < relationshipList.length; i++) {
                    var newRelationshipMap = this.relationshipList.getItemAt(i);

                    if (newRelationshipMap.relationshipMap.ifuncregedit2 == obj.ifuncregedit) {
                        relationshipMap = newRelationshipMap.relationshipMap;
                        cfieldRelationshipList = newRelationshipMap.cfieldRelationshipList as ArrayCollection;
                        break;
                    }

                }
            }
            if (triggerbodyObj.consultifuncregedit != valueObj.ifuncregedit
                    && (relationshipMap != null && (relationshipMap.bpull == "true" || Boolean(relationshipMap.bpull)))) {
                count++;
                bodyCoult();
                return;
            }

            //判断是否弹出参照窗口(需要弹出表体参照窗口)
            if (triggerbodyObj.btouchrefshow == "true" || Boolean(triggerbodyObj.btouchrefshow)) {
                openBodyWindow();
            }
            else {
                //查询所有参照信息
                var consultSql:String = triggerbodyObj.consultSql;
                //先解析sql
                var cconsultconfld:String = triggerbodyObj.cconsultconfld;
                triggerbodyObj.cconsultconfSql = conditionSqlFunction(cconsultconfld);
                var ctable:String = triggerbodyObj.cassignmenttable;
                var tableList:ArrayCollection = valueObj[ctable] as ArrayCollection;
                var conditionSql:String = "";
                if (null != conditionSqlFunction && null != cconsultconfld && "" != StringUtil.trim(cconsultconfld)) {
                    //查询条件
                    conditionSql = this.conditionSqlFunction(cconsultconfld);
                }
                var regE:RegExp = new RegExp("\`", "g");
                var sql:String = "select * from (" + consultSql.replace("@childsql", conditionSql).
                        replace("@condition", String(triggerbodyObj.Cconsultcondition).replace(regE, "'")).replace(regE, "'") + ") "
                        + ctable;
                AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (evt:ResultEvent):void {
                    var rArr:ArrayCollection = evt.result as ArrayCollection;

                    switch (triggerbodyObj.iRemoveBody) {
                        //全部清空
                        case 0:
                        {
                            tableList.removeAll();
                            tableList.addAll(zhuanhuan(rArr, ctable));
                            break;
                        }
                        case 1:
                        {
                            //删除所有表头触发参照
                            for (var i:int = tableList.length - 1; i >= 0; i--) {
                                var oldObj:Object = tableList.getItemAt(i);
                                if (oldObj.ifuncregedit != null) {
                                    tableList.removeItemAt(i);
                                }
                            }
                            tableList.addAll(zhuanhuan(rArr, ctable));
                            break;
                        }
                        case 2:
                        {
                            tableList.addAll(zhuanhuan(rArr, ctable));
                            break;
                        }
                    }
                    valueObj[ctable] = tableList;
                    if (count == triggerbodyconsult.length - 1) {
                        paramForm.setValue(paramForm.fzsj(valueObj), 1, 1);
                    }
                    else {
                        count++;
                        bodyCoult();
                    }
                }, sql, null, false);
            }
        }
    }

    public var _ctable:String;
    public var _cfield:String;

    public function set ctable(value:String) {
        _ctable = value;
    }

    public function get ctable():String {
        return _ctable;
    }

    public function set cfield(value:String) {
        _cfield = value;
    }

    public function get cfield():String {
        return _cfield;
    }

    public function set cvalue(value:String) {
        this.text = value;
    }

    public function get cvalue():String {
        return this.text;
    }
}
}