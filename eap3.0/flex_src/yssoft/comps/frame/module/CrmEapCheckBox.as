package yssoft.comps.frame.module {
import spark.components.CheckBox;

import yssoft.interfaces.IAllCrmInput;
import yssoft.tools.CRMtool;

public class CrmEapCheckBox extends CheckBox implements IAllCrmInput {
    public var parentForm:Object;

    //所有信息
    private var _singleType:Object = new Object();

    public function set singleType(value:Object):void {
        this._singleType = value;

        this.name = this._singleType.cobjectname;
        if (CRMtool.isStringNotNull(this._singleType.cnewdefault) && this._singleType.curButtonStatus == "onNew") {
            this.selected = (CRMtool.defaultValue(this._singleType.cnewdefault) == "1" ? true : false);
        }
        else if (CRMtool.isStringNotNull(this._singleType.ceditdefault) && this._singleType.curButtonStatus == "onEdit") {
            this.selected = (CRMtool.defaultValue(this._singleType.ceditdefault) == "1" ? true : false);
        }

        if (this._singleType.bread == true || this._singleType.bread == "true") {
            this.enabled = false;
        }
    }

    public function get singleType():Object {
        return this._singleType;
    }


    public function CrmEapCheckBox() {
        super();
        parentForm = this.owner;
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
        this.selected = CRMtool.isTrue(value);
    }

    public function get cvalue():String {
        return selected.toString();
    }
}
}