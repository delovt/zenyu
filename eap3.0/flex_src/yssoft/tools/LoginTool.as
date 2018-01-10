package yssoft.tools {
import flash.display.DisplayObject;
import flash.display.Sprite;

import mx.controls.Alert;
import mx.core.FlexGlobals;
import mx.core.IFlexDisplayObject;
import mx.events.CloseEvent;
import mx.formatters.DateFormatter;
import mx.managers.PopUpManager;
import mx.utils.StringUtil;

import yssoft.models.CRMmodel;
import yssoft.views.LoadingView;

public class LoginTool {
    public function LoginTool() {
    }

    private static const ALERT_PROMPT:String = "提示";
    private static const ALERT_ERROR:String = "错误";
    private static const ALERT_AFFIRM:String = "确认";


    [Embed(source='/yssoft/styles/assets.swf', symbol='prompt_png')]
    public static var ALERT_PNG_PROMPT:Class;

    [Embed(source='/yssoft/styles/assets.swf', symbol='error_png')]
    public static var ALERT_PNG_ERROR:Class;

    [Embed(source='/yssoft/styles/assets.swf', symbol='affirm_png')]
    public static var ALERT_PNG_AFFIRM:Class;

    Alert.yesLabel = "确定";
    Alert.noLabel = "取消";

    /**
     * 统一系统 alert窗口
     *
     * @auth            zmm
     * @date            2011年08月01日
     * @param info         提示信息
     * @param type         提示类型
     * @param focus     销毁窗口后，焦点对象
     * @param p            函数执行对象
     * @param yesFun    确定按钮 执行函数(p 中public 函数)
     * @param noFun        取消按钮 执行函数(p 中public 函数)
     * @param c            弹出框 附属父窗体
     */
        //信息弹出窗口
    public static function showAlert(info:String, focus:Object = null, type:String = "PROMPT", p:Sprite = null, yesFun:String = null, noFun:String = null, c:Sprite = null):void {
        if (c == null) {
            c = FlexGlobals.topLevelApplication as Sprite;
        }
        var flag:uint = Alert.YES;
        if (type == "AFFIRM") {
            flag = Alert.YES | Alert.NO;
        }
        Alert.show(info, LoginTool["ALERT_" + type], flag, c, function (evt:CloseEvent):void {
            if (evt.detail == Alert.YES) {
                if (focus != null) {
                    focus.setFocus();
                }
                if (yesFun && p)p[yesFun]();
            } else {
                if (focus) {
                    focus.setFocus();
                }
                if (noFun && p)p[noFun]();
            }
        }, LoginTool["ALERT_PNG_" + type], Alert.YES);
    }

    public static function tipAlert(info:String, focus:Object = null, type:String = "PROMPT", yesFun:Function = null, noFun:Function = null, c:Sprite = null):void {
        if (c == null) {
            c = FlexGlobals.topLevelApplication as Sprite;
        }
        var flag:uint = Alert.YES;
        if (type == "AFFIRM") {
            flag = Alert.YES | Alert.NO;
        }
        Alert.show(info, LoginTool["ALERT_" + type], flag, c, function (evt:CloseEvent):void {
            if (evt.detail == Alert.YES) {
                if (focus != null) {
                    focus.setFocus();
                }
                if (yesFun) {
                    yesFun();
                }
            } else {
                if (focus) {
                    focus.setFocus();
                }
                if (noFun) {
                    noFun();
                }
            }
        }, LoginTool["ALERT_PNG_" + type], Alert.YES);
    }

    /**
     * 打开 指定窗口 （主要是针对PopUpManager）
     * @auth       zmm
     * @date       2011年08月01日
     * @param view 要打开窗口的引用
     * @param p    过渡窗口以p来居中
     * @param flag 是否为模式装填 true 模式 false 非模式
     * @return        void
     */
    public static function openView(view:IFlexDisplayObject, flag:Boolean = true, p:DisplayObject = null):void {
        if (view) {
            if (p == null) {
                p = FlexGlobals.topLevelApplication as DisplayObject;
            }
			hideLoadingView();
            PopUpManager.addPopUp(view, p, flag);
            PopUpManager.centerPopUp(view);
			PopUpManager.bringToFront(view);
        }
    }

    /**
     * 函数名：getFormatDateString
     * 作者：zmm
     * 日期：2011-08-22
     * 功能：按指定格式 获取时间
     * 参数: fs 格式字符串
     * 参数：date 日期
     * 返回值: 日期格式化 字符串
     * 修改记录：无
     */
    private static var df:DateFormatter = new DateFormatter();
    //YYYY-MM-DD HH:NN:SS
    public static function getFormatDateString(fs:String = "YYYY-MM-DD HH:NN:SS", date:Date = null):String {
        if (date == null) {
            date = new Date();
        }
        df.formatString = fs;
        return df.format(date);
    }

    /**
     * 检查指定字符串是否为空，或null
     * @auth    zmm
     * @date    2011年08月01日
     * @return  boolean
     */
    public static function stringIsNull(str:String):Boolean {
        if (str == null) {
            return false;
        }
        if (StringUtil.trim(str).length == 0) {
            return false;
        }
        return true;
    }

    /**
     * 隐藏 过渡窗口
     * @auth    zmm
     * @date    2011年08月01日
     * @return  void
     */
    public static function hideLoadingView():void {
        if (CRMmodel.loadingView) {
            PopUpManager.removePopUp(CRMmodel.loadingView);
            CRMmodel.loadingView.loadingText = "";
        }
    }

    /**
     * 打开过渡窗口
     * @auth       zmm
     * @date       2011年08月01日
     * @param text 过渡窗口显示信息
     * @param p    过渡窗口以p来居中
     * @return        void
     */
    public static function showLoadingView(text:String = null, p:DisplayObject = null,flag:Boolean=false):void {
        if (CRMmodel.loadingView == null) {
            CRMmodel.loadingView = new LoadingView();
			
			if (text) {
				CRMmodel.loadingView.loadingText = text;
			}
			
        }
		
        openView(CRMmodel.loadingView, flag);
       
    }


}
}