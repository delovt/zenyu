package yssoft.frameui.formopt {
import flash.events.Event;

import mx.core.Container;

import yssoft.comps.frame.module.CrmEapRadianVbox;
import yssoft.frameui.FrameCore;
import yssoft.impls.ICommand;
import yssoft.tools.CRMtool;

public class InitingCommand extends BaseCommand {
    //传递的参数
    private var _context:FrameCore;

    public function InitingCommand(context:Container, optType:String = "", param:* = null, nextCommand:ICommand = null, excuteNextCommand:Boolean = false) {
        _context = context as FrameCore;
        super(context, optType, param, nextCommand, excuteNextCommand);
    }

    override public function onExcute():void {

        try {
            var crmeap:CrmEapRadianVbox = new CrmEapRadianVbox();
            crmeap.percentWidth = 100;
            crmeap.name = "myCanva";
            crmeap.curButtonStatus = _context.curButtonStatus;
            crmeap.formIfunIid = _context.formIfunIid;
            crmeap.owner = _context;
            crmeap.setStyle("paddingLeft", "10");
            crmeap.setStyle("paddingRight", "10");
            crmeap.addEventListener("queryComplete",function(e:Event):void{
                if(_context is FrameCore)
                    _context.queryComplete();
            });
            if (_context.formStatus == "browser" || _context.formStatus == "edit") {
                if (_context.curFormIndex == -1) {
                    _context.curFormIndex = 1;
                }
                crmeap.currid = int(_context.formIidList.getItemAt(_context.curFormIndex - 1).iid);
                _context.currid = crmeap.currid;
            }
            crmeap.addEventListener("complete", complete);

            crmeap.queryVouchForm();
            _context.formShowArea.addChild(crmeap);
            _context.getWordFlowDetail(_context.formIfunIid, _context.currid, 0);
            _context.crmeap = crmeap;
        }
        catch (e:Error) {
            CRMtool.showAlert("窗体初始化异常！原因：" + e.toString());
        }
    }

    private function complete(event:Event):void {
        _context.crmeap = event.currentTarget as CrmEapRadianVbox;
        var crmeap:CrmEapRadianVbox = event.currentTarget as CrmEapRadianVbox;

        if (crmeap.vouchFormValue != null) {
            _context._vouchFormValue.addItem(crmeap.vouchFormValue);
        }
        if (_context.formStatus == "edit" || _context.formStatus == "new") {
            _context.setOtherButtons(false);
            if (_context.formStatus == "edit") {
                _context.onEdit();
                crmeap.queryPm(crmeap.currid + "", _do);
                //crmeap.setValue(crmeap.vouchFormValue);
            } else {
                _context.onNew();
                _do();
            }
        } else {
            crmeap.queryPm(crmeap.currid + "", _do);
            //crmeap.setValue(crmeap.vouchFormValue);
            _context.setOtherButtons(true);
        }
        function _do() {
            crmeap["isFirst"] = false;
            onNext();
        }
    }
}
}