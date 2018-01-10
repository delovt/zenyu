package yssoft.comps {
import flash.events.Event;
import flash.events.FocusEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;

import mx.events.FlexEvent;

import spark.components.TextInput;

import yssoft.vos.AbInvoiceatmVo;

[Style(name="icon", inherit="no", type="Object")]
[Style(name="radius", inherit="true", type="Number")]


[Event(name="search", type="flash.events.Event")]
[Event(name="basicSearch", type="flash.events.Event")]
[Event(name="localSearch", type="flash.events.Event")]

public class CrmNewTextInput extends TextInput {
    [Embed(source="/yssoft/assets/images/search2.png")]
    private const defaultIcon:Class;

    private var _iShowIcon:Boolean = true;
    private var _iTxtText:String;
    private var _iData:Object;


    public function CrmNewTextInput() {
        super();
        this.setStyle("icon", defaultIcon);
        this.setStyle("radius", 3);
        this.setStyle("borderAlpha", 0.5);
        this.setStyle("skinClass", CrmNewTextInputSkin);
        /*			this.setStyle("contentBackgroundColor",0x43A6DA);*/
        this.addEventListener(MouseEvent.CLICK, clickFun);
        this.addEventListener(FocusEvent.FOCUS_OUT, restoreColor);
        //this.addEventListener(FlexEvent.ENTER,onEnter);
        this.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
    }

    private function clickFun(e:Event):void {
        setStyle("contentBackgroundColor", 0xFFffff);
    }

    private function restoreColor(e:Event):void {
        this.setStyle("contentBackgroundColor", 0xffffff);
    }


    private function onEnter(event:FlexEvent):void {
        this.dispatchEvent(new Event("search"));
    }

    private function onKeyDown(event:KeyboardEvent):void {
        if (event.keyCode == 13) {//说明是回车按下
            if (event.ctrlKey) {
                this.dispatchEvent(new Event("basicSearch"));
            } else if (event.shiftKey) {
                this.dispatchEvent(new Event("localSearch"));
            } else {
                this.dispatchEvent(new Event("search"));
            }
        }
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