package yssoft.frameui.formopt {

import flash.events.Event;

import mx.core.Container;

import yssoft.frameui.FrameCore;
import yssoft.impls.ICommand;
import yssoft.models.CRMmodel;
import yssoft.tools.CRMtool;

public class InitBeforeCommand extends BaseCommand {
    public var _context:FrameCore;

    public function InitBeforeCommand(context:Container, optType:String = "", param:* = null, nextCommand:ICommand = null, excuteNextCommand:Boolean = false) {
        this._context = context as FrameCore;
        super(context, optType, param, nextCommand, excuteNextCommand);
    }

    override public function onExcute():void {
        _context.openWin();
        //初始化权限
        _context.auth = new OperDataAuth();
        _context.auth.addEventListener("onGet_FunoperauthSucess", onoperauthbackdo);
        loadauth();
    }

    //加载操作权限返回处理
    private function onoperauthbackdo(result:Event):void {
        //---------------加载数据权限 begin---------------//
        var params2:Object = new Object();
        params2.ifuncregedit = _context.formIfunIid;
        params2.iperson = CRMmodel.userId;
        _context.auth.addEventListener("onGet_FundataauthSucess", ondataauthbackdo);
        _context.auth.get_fundataauth(params2);
        //---------------加载数据权限 end---------------//
    }

    //加载数据权限返回处理
    private function ondataauthbackdo(result:Event):void {
        //--------------权限控制 刘磊 begin--------------//
        if (_context.curButtonStatus != "onGiveUp") {
            var warning:String = _context.auth.reuturnwarning(_context.auth.getOperidByName(_context.curButtonStatus));
            if (warning != null) {
                CRMtool.showAlert(warning);
                _context.curButtonStatus = "onGiveUp";
                _context.preButtonStatus = "onGiveUp";
            }
        }
        //--------------权限控制 刘磊 end--------------//
        //按钮互斥
        _context.setAllButtonsEnabled(_context.curButtonStatus);
        this.onNext();
    }

    //加载权限
    private function loadauth():void {
        //---------------加载操作权限 begin---------------//
        var params1:Object = new Object();
        params1.ifuncregedit = _context.formIfunIid;
        params1.iperson = CRMmodel.userId;
        _context.auth.get_funoperauth(params1);
        //---------------加载操作权限 end---------------//
    }


}
}