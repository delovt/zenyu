package yssoft.comps.frame.module {
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.ClassFactory;
import mx.events.DragEvent;
import mx.events.ListEvent;
import mx.utils.ObjectUtil;

import yssoft.comps.dataGridRenderer.ItemRendererCheckBox;
import yssoft.comps.frame.module.Basic.BasicMxDataGrid;
import yssoft.frameui.FrameCore;
import yssoft.frameui.formopt.FormOpt;
import yssoft.renders.DGComboBox;
import yssoft.renders.DGConsultTextInput;
import yssoft.renders.DGConsultTextInputHide;
import yssoft.renders.DGRadioButtonGroup;
import yssoft.tools.CRMtool;

public class CrmEapDataGrid extends BasicMxDataGrid {
    //所有信息
    private var _singleType:Object = new Object();

    //表名
    private var _ctableName:String;

    private var _getValue:Function;

    public var isInsert:Boolean = false;

    public var lastAddOrInsertItem:Object;

    public function set getValue(value:Function):void {
        this._getValue = value;
    }

    public function get getValue():Function {
        return this._getValue;
    }

    //结果集
    private var _setValue:Function;

    public function set setValue(value:Function):void {
        this._setValue = value;
    }

    public function get setValue():Function {
        return this._setValue;
    }

    public function set ctableName(value:String):void {
        this._ctableName = value;
    }

    public function get ctableName():String {
        return this._ctableName;
    }

//***********开始***********XZQWJ 2013-01-06***********************************************************************
    //存放子表所有的数据，如果，不关联时等同于_tableList;当关联时all_tableList数据>=_tableList的数据
    private var _all_tableList:ArrayCollection = new ArrayCollection();

    public function set all_tableList(value:ArrayCollection):void {
        this._all_tableList = value;
    }

    public function get all_tableList():ArrayCollection {
        if (_all_tableList == null)
            return this.dataProvider as ArrayCollection;

        return this._all_tableList;
    }

    private var _foreignKey:String;

    public function set foreignKey(value:String):void {
        this._foreignKey = value;
    }

    public function get foreignKey():String {
        return this._foreignKey;
    }


//		关联显示时对应dg的母表名称
    private var _child_tablelist:Object = new Object();

    public function set child_tablelist(value:Object):void {
        this._child_tablelist = value;
    }

    public function get child_tablelist():Object {
        return this._child_tablelist;
    }

//************结束******************************************************************************************************		
    //数据
    [Bindable]
    private var _tableList:ArrayCollection = new ArrayCollection();

    public function set tableList(value:ArrayCollection):void {
        this._tableList = value;
        this.dataProvider = value;
    }

    public var isHasIno:Boolean = false;

    override public function set dataProvider(value:Object):void {
        super.dataProvider = value;
        //doIno();
    }

    /*public function doIno():void {
     if (isHasIno && dataProvider != null) {
     var sort:Sort = new Sort();
     //按照优先序号升序排序
     sort.fields = [new SortField("ino")];
     dataProvider.sort = sort;
     dataProvider.refresh();
     }
     }*/

    public function get tableList():ArrayCollection {
        return this._tableList;
    }

    public function set singleType(value:Object):void {
        this._singleType = value;
    }

    public function get singleType():Object {
        return this._singleType;
    }


    public var paramForm:CrmEapRadianVbox;

    public var subTableAssignment:Function;

    private var datefields:Array = new Array();

    public var constraintFormula:Function;

    public function CrmEapDataGrid() {
        super();
        isRecordEdit = true;
        this.percentHeight = 100;
        this.percentWidth = 100;
        this.doubleClickEnabled = true;
        this.isAllowMulti = true;
        this.dataProvider = _tableList;
        this.addEventListener(ListEvent.ITEM_DOUBLE_CLICK, onDoubleClick);
    }

    public function InitColumns():void {
        //super.InitColumns();
        paramForm = this.owner as CrmEapRadianVbox;
        if (paramForm.paramForm is FrameCore) {
            sortableColumns = false;
        }
        var taleChildArr:ArrayCollection = _singleType.taleChild as ArrayCollection;
        for each(var taleChild:Object in taleChildArr) {
            if (taleChild.cfield == "ino") {
                isHasIno = true;
            }

            if (taleChild.bshow == "true" || Boolean(taleChild.bshow)) {
                var coulmn:DataGridColumn = new DataGridColumn();
                if (taleChild.iwidth == null || taleChild.iwidth == "" || taleChild.iwidth == "0") {
                    coulmn.width = 100;
                }
                else {
                    coulmn.width = int(taleChild.iwidth);
                }
                /*if(taleChild.bshow=="false"||!Boolean(taleChild.bshow))
                 {
                 coulmn.visible=false;
                 }
                 */
                if (int(taleChild.iconsult) > 0) {
                    var cfield:String = taleChild.cfield + "_Name";
                    coulmn.headerText = taleChild.ccaption;
                    coulmn.dataField = cfield;

                    //lr add 如果是公共推式生单  动态创建一列 用来实现参照翻译
                    if ((paramForm.paramForm is FrameCore)) {
                        var coulmn1:DataGridColumn = new DataGridColumn();
                        coulmn1.dataField = taleChild.cfield;
                        coulmn1.visible = true;
                        coulmn1.minWidth = 0;
                        coulmn1.width = 0;

                        var tnp_cfield:ClassFactory;
                        tnp_cfield = new ClassFactory(DGConsultTextInputHide);

                        tnp_cfield.properties = {singleType: taleChild, paramForm: paramForm, subTableAssignment: subTableAssignment, constraintFormula: this.constraintFormula};
                        coulmn1.itemRenderer = tnp_cfield;
                        coulmn1.editable = false;
                        coulmn1.headerText = "";
                        coulmn1.resizable = false;

                        this.columns = this.columns.concat(coulmn1);
                        if (this.lockedColumnCount > 0)
                            this.lockedColumnCount++;
                    }
                }
                else {
                    coulmn.dataField = taleChild.cfield;
                    coulmn.headerText = taleChild.ccaption;
                }
                switch (taleChild.objecttype) {
                    case "TextInput":
                    {
                        var tnp_cfield:ClassFactory = new ClassFactory(DGConsultTextInput);
                        if (taleChild.ctype == "datetime") {
                            datefields.push(taleChild.cfield);
                            if (taleChild.idatetype == 0)
                                coulmn.labelFunction = CRMtool.labelFunctionFormatDateWithHNS;

                        }
                        coulmn.itemEditor = tnp_cfield;
                        tnp_cfield.properties = {singleType: taleChild, subTableAssignment: subTableAssignment, paramForm: paramForm, constraintFormula: this.constraintFormula};
                        coulmn.editorDataField = "data_iconsult";
                        break;
                    }
                    case "ComboBox":
                    {
                        var com_cfield:ClassFactory = new ClassFactory(DGComboBox);
                        coulmn.itemEditor = com_cfield;
                        com_cfield.properties = {singleType: taleChild, subTableAssignment: subTableAssignment, paramForm: paramForm};
                        coulmn.editorDataField = "data_iconsult";
                        break;
                    }
                    case "CheckBox":
                    {
                        var cb_cfield:ClassFactory = new ClassFactory(ItemRendererCheckBox);
                        cb_cfield.properties = {singleType: taleChild, subTableAssignment: subTableAssignment};
                        coulmn.itemRenderer = cb_cfield;
                        coulmn.editable = false;
                        break;
                    }
                    case "RadioButtonGroup":
                    {
                        var rb_cfield:ClassFactory = new ClassFactory(DGRadioButtonGroup);
                        coulmn.editorDataField = "data_iconsult";
                        rb_cfield.properties = {singleType: taleChild, subTableAssignment: subTableAssignment, paramForm: paramForm};
                        coulmn.itemEditor = rb_cfield;
                        /*coulmn.editable=false;*/
                        break;
                    }
                }
                //coulmn.itemRenderer = new ClassFactory(DataGridItemLabel);
                this.columns = this.columns.concat(coulmn);

            }
        }
    }


    public function addNewItem(isInsert:Boolean = false):void {
        this.editable = true;
        this.isInsert = isInsert;
        setThis();
        FormOpt.addDataGridRowOpt(this, this.paramForm.curButtonStatus, this._singleType);
        doCalFunction();
    }

    public function deleteItem(event:MouseEvent):void {
        setThis();
        FormOpt.deleteDataGridRowOpt(this, this.paramForm.curButtonStatus, this._singleType);
        doCalFunction();
    }

    public function removeAll(event:MouseEvent):void {
        setThis();
        FormOpt.deleteAllDataGridRowOpt(this, "", this._singleType);
        doCalFunction();
    }

    private function setThis():void {
        if (paramForm.paramForm != null && paramForm.paramForm.hasOwnProperty("triggerCrmEapControl"))
            this.paramForm.paramForm.triggerCrmEapControl = this;
    }

    public function doCalFunction():void {
        subTableAssignment(null, singleType.ctable, null, null, true, this, execFunctionBack);
    }

    //计算公式完成后，刷新数据
    public function execFunctionBack():void {
        callLater(function ():void {
            invalidateList();
        })
    }

    public function onRowChange():void {

        if (this.paramForm.paramForm is FrameCore) {
            (this.paramForm.paramForm as FrameCore).triggerCrmEapControl = this;

            var tableMessage:ArrayCollection = this.paramForm.paramForm.crmeap.tableMessage;//表之间关系
            var currDGridName:String = this.ctableName;//当前表面
            var childDGridName:String = "";
            var primaryKey:String = "";//子表主键
            var foreignKey:String = "";//子表外键及母表主键
            var foreignKey_value:Object = "";
            var l:int = tableMessage.length;
            for (var i:int = 0; i < l; i++) {
                if (!tableMessage.getItemAt(i).bMain && tableMessage.getItemAt(i).ctable2 == currDGridName) {
                    childDGridName = tableMessage.getItemAt(i).ctable as String;
                    primaryKey = tableMessage.getItemAt(i).primaryKey;
                    foreignKey = tableMessage.getItemAt(i).foreignKey;
                    foreignKey_value = this.selectedItem[primaryKey];
                    for each(var dg:CrmEapDataGrid in this.paramForm.gridList) {
                        if (dg.ctableName == childDGridName) {
                            if (dg) {
                                dg.all_tableList = dg.tableList;
                                if (dg.all_tableList == null || dg.all_tableList.length == 0) {
                                    dg.all_tableList = dg.dataProvider as ArrayCollection;

                                } else {
                                    var tempTableList:ArrayCollection = ObjectUtil.copy(dg.dataProvider) as ArrayCollection;
                                    var tempkey_value:String = "";
                                    if (tempTableList.length > 0) {
                                        tempkey_value = tempTableList.getItemAt(0)[foreignKey];
                                    }

                                    var ll:int = dg.all_tableList.length;
                                    for (var j:int = ll - 1; j >= 0; j--) {
                                        if (dg.all_tableList.getItemAt(j)[foreignKey] == tempkey_value) {
                                            dg.all_tableList.removeItemAt(j);
                                        }
                                    }
                                    for (var jj:int = 0; jj < tempTableList.length; jj++) {
                                        if (tempTableList.getItemAt(jj)[foreignKey] == tempkey_value) {
                                            dg.all_tableList.addItem(tempTableList.getItemAt(jj));
                                        }
                                    }
                                }

                                var o:Object = new Object();
                                o.tableName = childDGridName;
                                o.tableList = dg.all_tableList;
                                this.child_tablelist = o;

                                var temp_all_tableList:ArrayCollection = new ArrayCollection();
//									temp_all_tableList = ObjectUtil.copy(this.all_tableList) as ArrayCollection;
                                temp_all_tableList = dg.all_tableList;
                                dg.all_tableList = temp_all_tableList;
                                dg.tableList = temp_all_tableList;
                                var tableList:ArrayCollection = new ArrayCollection();
                                var len:int = dg.all_tableList.length;
                                for (var ii:int = 0; ii < len; ii++) {
                                    if (dg.all_tableList.getItemAt(ii)[foreignKey] == foreignKey_value) {
                                        tableList.addItem(dg.all_tableList.getItemAt(ii));
                                    }
                                }
                                dg.dataProvider = tableList;
                            } else {
                                dg.dataProvider = new ArrayCollection();
                            }
                            break;
                        }
                    }
                    break;
                }
            }
        }
    }

    public function onDoubleClick(event:ListEvent):void {
        setThis();
        if (this.dataProvider.length > 0)
            FormOpt.dclickDataGridRowOpt(this, this.paramForm.curButtonStatus, this._singleType);
    }

    private var _index:int = -1;//子表的子表时，需要用到的第一子表临时内码

    public function get index():int {
        _index--;
        return _index;
    }

    public function clearLastItem():void {
        if (dataProvider != null) {
            var index:int = (dataProvider as ArrayCollection).getItemIndex(lastAddOrInsertItem);
            if (index > -1)
                (dataProvider as ArrayCollection).removeItemAt(index);
        }
        if (tableList != null) {
            var index:int = (tableList as ArrayCollection).getItemIndex(lastAddOrInsertItem);
            if (index > -1)
                (tableList as ArrayCollection).removeItemAt(index);
        }
    }

    public function setLastItem(obj:Object):void {
        if (dataProvider != null) {
            var index:int = (dataProvider as ArrayCollection).getItemIndex(lastAddOrInsertItem);
            if (index > -1)
                (dataProvider as ArrayCollection).setItemAt(obj, index);
        }
        if (tableList != null) {
            var index:int = (tableList as ArrayCollection).getItemIndex(lastAddOrInsertItem);
            if (index > -1)
                (tableList as ArrayCollection).setItemAt(obj, index);
        }
    }

    override protected function dragEnterHandler(event:DragEvent):void {
        if (event.currentTarget == event.dragInitiator)
            super.dragEnterHandler(event);
    }

    public function setDragable(enabled:Boolean):void {
        var isMove:Boolean = false;
        if ((this.paramForm.curButtonStatus == "onNew" || this.paramForm.curButtonStatus == "onEdit") && isHasIno && enabled) {
            isMove = true;
        }

        this.dragEnabled = isMove;
        this.dropEnabled = isMove;
        this.dragMoveEnabled = isMove;
    }
}
}