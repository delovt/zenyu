package yssoft.comps.frame.module {
import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.collections.ArrayList;
import mx.containers.HBox;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;

import spark.components.ComboBox;

import yssoft.comps.ConsultList;
import yssoft.comps.ConsultTree;
import yssoft.comps.ConsultTreeList;
import yssoft.interfaces.IAllCrmInput;
import yssoft.skins.CrmComboBoxSkin;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;

[Event(name="initialization", type="flash.events.Event")]
[Event(name="valueChange", type="flash.events.Event")]
[Event(name="numberEvent", type="flash.events.Event")]
public class CrmEapComboBox extends ComboBox implements IAllCrmInput {
    public var parentForm:Object;

    //CrmEapRadianVbox
    public var paramForm:CrmEapRadianVbox;

    //所有信息
    [Bindable]
    private var _singleType:Object = new Object();

    /*[Bindable]*/
    public function set singleType(value:Object):void {
        this._singleType = value;
        if (null != this._singleType.cobjectname) {
            this.name = this._singleType.cobjectname;
        }

        var cconsultconfld:String = _singleType.cconsultconfld;
        if (Boolean(this._singleType.bread)) {
            enabled = false;
        }
        else {
            //焦点离开事件
            this.addEventListener(Event.CHANGE, onChange);
        }
        if (CRMtool.isStringNotNull(cconsultconfld) && null != conditionSqlFunction) {
            //查询条件
            var conditionSql:String = this.conditionSqlFunction(_singleType.cconsultconfld);
            singleType.cconsultconfSql = conditionSql;
        }
        if(_singleType.value==null)
            delete _singleType.value;
        AccessUtil.remoteCallJava("CommonalityDest", "consultInit", consultInitBack, _singleType, null, false);
        this.invalidateDisplayList();
    }

    public function get singleType():Object {
        return this._singleType;
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

    public var text:String = "";

    public function CrmEapComboBox() {
        super();
        parentForm = this.owner;
        //调用CrmComboBoxSkin皮肤
        this.setStyle("skinClass", CrmComboBoxSkin);
    }

    private function consultInitBack(event:ResultEvent):void {
        var result:Object = event.result;
        if (result.hasOwnProperty("consultList")) {
            this._consultList = event.result.consultList as ArrayCollection;

            //获得下拉框的值
            this.dataProvider = this._consultList;

            this.labelField = _singleType.cconsultswfld;

            if (CRMtool.isStringNotNull(this._singleType.cnewdefault) && this._singleType.curButtonStatus == "onNew") {
                text = CRMtool.defaultValue(this._singleType.cnewdefault);
            }
            else if (CRMtool.isStringNotNull(this._singleType.ceditdefault) && this._singleType.curButtonStatus == "onEdit") {
                text = CRMtool.defaultValue(this._singleType.ceditdefault);
            }

            for (var i:int = 0; i < this._consultList.length; i++) {
                var obj:Object = this._consultList.getItemAt(i);
                if (obj[_singleType.cconsultbkfld] == text) {
                    selectedIndex = i;
                    break;
                }
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

    //YJ Add 单据编码
    private function onGetBillNumberHandle():void {

        //单据编码
        if (this._singleType.bprefix == "true" || Boolean(this._singleType.bprefix)) {

            if (null != this._consultList && this._consultList.length > 0) {
                //YJ Modify 2012-04-12 加入单据编码
                if (parentForm is SingleVouch) {
                    var crmEap:CrmEapRadianVbox = this.parent.parent.parent.parent.parent as CrmEapRadianVbox;

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

    private function onChange(event:Event):void {
        this.dispatchEvent(new Event("valueChange"));
        //单据编码
        if ((this._singleType.bprefix == "true" || Boolean(this._singleType.bprefix))) {

            //YJ Add
            onGetBillNumberHandle();
            this.paramForm.onGetNumber();
        }
        cfieldRelationship();
    }

    private function cfieldRelationship():void {
        if (null == this.paramForm) {
            return;
        }
        var ctable:String = this._singleType.ctable;
        var objArr:ArrayCollection = new ArrayCollection();
        valueObj = paramForm.getValue();

        var fieldObj:Object = new Object();
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
                    var newRelationshipMap = this.relationshipList.getItemAt(i);

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
                }
                else {
                    if (null != _consultList) {
                        var tableList:ArrayCollection = valueObj[_singleType.ctable] as ArrayCollection;
                        if (tableList != null) {
                            for (var j:int = 0; j < cfieldRelationshipList.length; j++) {
                                var cfieldRelationship:Object = cfieldRelationshipList.getItemAt(j);
                                var ctable2:String = cfieldRelationship.ctable2;
                                if (ctable2.toLocaleUpperCase() == ctable.toLocaleUpperCase()) {
                                    tableList.getItemAt(tableList.getItemIndex(dataObj))[String(cfieldRelationship.cfield2)] = _consultList.getItemAt(this.selectedIndex)[String(cfieldRelationship.cfield)];
                                    if (int(cfieldRelationship.iconsult) > 0) {
                                        tableList.getItemAt(tableList.getItemIndex(dataObj))[cfieldRelationship.cfield2 + "_Name"] = _consultList.getItemAt(this.selectedIndex)[cfieldRelationship.cconsultswfld];
                                    }
                                }
                            }
                            tableList.getItemAt(tableList.getItemIndex(dataObj)).iinvoices = _consultList.getItemAt(this.selectedIndex).iid;
                            tableList.getItemAt(tableList.getItemIndex(dataObj)).ifuncregedits = this._singleType.consultifuncregedit;
                        }
                    }
                    paramForm.setValue(paramForm.fzsj(valueObj), 1, 1);
                }
            }
        }
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
                var sql:String = "select * from (" + consultSql.replace("@childsql", conditionSql).
                        replace("@condition", String(triggerbodyObj.Cconsultcondition).replace("`", "'")) + ") "
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
            openConsultWindow(subCfunctionObj);
        }

    }

    //打开参照窗体
    private function openConsultWindow(consultObj:Object):void {
        var itype:int = int(consultObj.itype);
        var conditionSql:String = "";
        var cconsultconfld:String = consultObj.cconsultconfld;
        if (null != conditionSqlFunction && null != cconsultconfld && "" != StringUtil.trim(cconsultconfld)) {
            //查询条件
            conditionSql = this.conditionSqlFunction(consultObj.cconsultconfld);
        }
        this.text = "";

        switch (itype) {
            case 0:
            {
                new ConsultTree(getSelectTreeRows, int(consultObj.iconsult), Boolean(consultObj.bconsultendbk));
                break;
            }
            case 1:
            {
                new ConsultList(getSelectListRows, int(consultObj.iconsult), Boolean(consultObj.bconsultmtbk),
                        conditionSql, consultObj.cconsultcondition);
                break;
            }
            default:
            {
                new ConsultTreeList(getSelectListRows, int(consultObj.iconsult),
                        Boolean(consultObj.bconsultmtbk), conditionSql, consultObj.cconsultcondition);
                break;
            }
        }
    }

    //树参照
    private function getSelectTreeRows(tree:XML):void {

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

    }

    //打开表格参照
    private function getSelectListRows(list:ArrayCollection):void {

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
            count++;
            openBodyWindow();
            paramForm.setValue(paramForm.fzsj(valueObj), 1, 1);
        }
        else {
            count = 0;
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
        if (_consultList == null)
            return;
        for (var i:int = 0; i < this._consultList.length; i++) {
            var obj:Object = this._consultList.getItemAt(i);
            if (obj[_singleType.cconsultbkfld] == value) {
                selectedIndex = i;
                break;
            }
        }
    }

    public function get cvalue():String {
        if (selectedItem == null)
            return "";

        return this.selectedItem[_singleType.cconsultbkfld];
    }
}
}