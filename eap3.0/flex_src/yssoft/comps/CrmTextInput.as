package yssoft.comps {
import flash.events.Event;

import mx.events.FlexEvent;

import spark.components.TextInput;

import yssoft.skins.CrmTextInputSkin;
import yssoft.vos.AbInvoiceatmVo;

[Style(name="icon", inherit="no", type="Object")]
[Style(name="radius", inherit="true", type="Number")]


[Event(name="search", type="flash.events.Event")]

public class CrmTextInput extends TextInput {
    [Embed(source="/yssoft/assets/images/search.png")]
    private const defaultIcon:Class;

    private var _iShowIcon:Boolean = true;
    private var _iTxtText:String;
    private var _iData:Object;


    public function CrmTextInput() {
        super();
        this.setStyle("icon", defaultIcon);
        this.setStyle("radius", 3);
        this.setStyle("skinClass", CrmTextInputSkin);
        this.addEventListener(FlexEvent.ENTER, onEnter);
        this.restrict="^'";
    }

    /*		protected override function measure():void{
     super.measure();
     this.setStyle("icon", defaultIcon);
     this.setStyle("radius",3);
     this.setStyle("skinClass",CrmTextInputSkin);
     }*/

    private function onEnter(event:FlexEvent):void {
        this.dispatchEvent(new Event("search"));
    }

    public function get iTxtText():String {
        return _iTxtText;
    }

    public function set iTxtText(value:String):void {
        _iTxtText = value;
    }

    public function get iData():Object {
        return _iData;
    }

    public function set iData(value:Object):void {
        _iData = value;
    }

    public function get iShowIcon():Boolean {
        return _iShowIcon;
    }

    public function set iShowIcon(value:Boolean):void {
        _iShowIcon = value;
    }

    public function onSearchHandler():void {
        this.dispatchEvent(new Event("search"));
    }
}
}