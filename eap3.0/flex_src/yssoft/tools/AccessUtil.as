/**
 * 作者:朱毛毛
 * 日期:2010年12月03日
 * 功能:数据访问类
 */
package yssoft.tools {
import flash.display.DisplayObject;
import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.net.URLRequest;

import mx.controls.Alert;
import mx.rpc.AbstractOperation;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.remoting.RemoteObject;

import yssoft.models.CRMmodel;

public class AccessUtil {

    /**
     * 远程调用请求统计
     * @auth 朱毛毛
     * @date 2011年08月01日
     *
     */
    [Bindable]
    public static var remoteArray:Array = new Array();

    /**
     * 远程调用
     *
     * @auth 朱毛毛
     * @date 2010年4月15日
     * @param dest        :远程调用目的名称
     * @param method    :调用方法
     * @param param        :方法参数
     * @param callback    :回调函数
     * @param info        :过渡窗口中显示的文字
     * @param isload    :是否显示过渡效果
     * @param p            :弹出窗口宿主
     */
    public static function remoteCallJava(dest:String, method:String, callback:Function = null, param:Object = null, info:String = null, isload:Boolean = true, p:DisplayObject = null, errorCallBack:Function = null):void {

        //与服务器连接不正常，就不再执行远程调用。
        if (!CRMmodel.connOK)
            return;

        if (method == null)
            return;


        var ro:RemoteObject = new RemoteObject(dest);
        var aopt:AbstractOperation = ro.getOperation(method);

        if (isload) {//是否显示过渡窗口，

            LoginTool.showLoadingView(info, p, true);
            aopt.addEventListener(ResultEvent.RESULT, ro_result, false, 0, true);
            ro.showBusyCursor = true;
        } else {
            ro.showBusyCursor = false;
        }

        if (callback != null) {//回调函数不为null，添加回调函数

            aopt.addEventListener(ResultEvent.RESULT, callback);

        }
        if (errorCallBack == null) {
            aopt.addEventListener(FaultEvent.FAULT, function (fault:FaultEvent):void {
                LoginTool.hideLoadingView();
                //lr add ll与admin账号可以看到错误。
                var userId:int = CRMmodel.userId;
                var cname:String = CRMmodel.hrperson.cname;
                if (cname == "admin" || CRMmodel.isCrmProgramMode) {
                    LoginTool.showAlert(fault.message.toString(), null, "ERROR");
                } else {
                    //LoginTool.showAlert(fault.message.toString(),null,"ERROR");
                    LoginTool.showAlert("程序遇异常情况，执行中可能出现了问题，请联系系统管理员。", null, "ERROR");
                }
            }, false, 0, true);
        } else {
            aopt.addEventListener(FaultEvent.FAULT, errorCallBack);
        }
        if (param == null) {
            aopt.send();
        } else {
            aopt.send(param);
        }
        remoteArray.push({'dest': dest, 'method': method});
        if (ro) {
            ro = null;
            method = null;
            param = null;
            aopt = null;
        }
    }

    //关闭过度窗口
    private static function ro_result(result:ResultEvent):void {
        LoginTool.hideLoadingView();
    }


    /*		//请求出错提示
     private static function ro_fault(fault:FaultEvent):void{
     LoginTool.hideLoadingView();
     if(fault.fault.faultCode=="Channel.Call.Failed"||fault.fault.faultCode=="Client.Error.MessageSend")
     trace(fault.message.toString());
     else
     LoginTool.showAlert(fault.message.toString(),null,"ERROR");
     }*/

    /**
     * 函数名：loadFile
     * 作者：zmm
     * 日期：2011-08-14
     * 功能：下载文件
     * param: remotePath  文件路径 注:相对web根目录upload的写法 "./upload/"
     * param: fileName    文件名称(带扩展名)
     * param：callBack    下载完成后的 回调函数（至少要一个 event 类型的参数）
     * 返回值: 如果存在 就返回用户头像的引用， 不存在 就返回null
     * 修改记录：无
     */
    public static function loadFile(remotePath:String, fileName:String = "", callBack:Function = null):Loader {
        var loader:Loader = new Loader();

        loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, lf_ioerror);
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, callBack);
        loader.load(new URLRequest(remotePath + fileName));
        return loader;

    }

    private static function lf_ioerror(event:IOErrorEvent):void {

    }
}
}