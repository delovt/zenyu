/**
 * Created with IntelliJ IDEA.
 * User: yj
 * Date: 14-7-28
 * Time: 下午4:33
 * To change this template use File | Settings | File Templates.
 */
package yssoft.scripts {

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.Socket;

import mx.rpc.events.ResultEvent;

import yssoft.models.CRMmodel;

import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.views.callcenter_new.SocketMsgEvent;
import flash.events.EventDispatcher;

public class CallCenterConnect extends EventDispatcher{

    //连接 呼叫中心 服务端
    public var cpSocket:Socket = null;

    //IP地址
    private var _cpsip:String;
    private var _cpsport:int;

    public function CallCenterConnect() {

        AccessUtil.remoteCallJava("CallCenterDest", "getCpsipAndPort", ongetCpsipAndPort, null, null, false);
    }

    private function ongetCpsipAndPort(evt:ResultEvent):void {

        _cpsip = evt.result.cpsip;
        _cpsport = evt.result.cpsport;

        connectsocket();
    }

    private function connectsocket():void {
        if (CRMmodel.modelSocket == null) {
            CRMmodel.modelSocket = new Socket();

        } else {
            removeListener(CRMmodel.modelSocket);
            closcSocket();
        }
        //Security.loadPolicyFile("xmlsocket://" + _cpsip + ":" + _cpsport + " /eap1.0/crossdomain.xml");
        CRMmodel.modelSocket.connect(_cpsip, _cpsport);
        addListener(CRMmodel.modelSocket);
        CRMmodel.modelSocket.flush();
    }

    //添加 相关事件
    private function addListener(cpSocket:Socket):void {
        if (!cpSocket) {
            return;
        }
        cpSocket.addEventListener(Event.CONNECT, connectHandler, false, 0, true);
        cpSocket.addEventListener(Event.CLOSE, closeHandler, false, 0, true);
        cpSocket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler, false, 0, true);
        cpSocket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, secuityErrorHandler, false, 0, true);
        cpSocket.addEventListener(ProgressEvent.SOCKET_DATA, socketData, false, 0, true);

    }

    //删除 相关事件
    private function removeListener(cpSocket:Socket):void {
        if (!cpSocket) {
            return;
        }
        cpSocket.removeEventListener(Event.CONNECT, connectHandler);
        cpSocket.removeEventListener(Event.CLOSE, closeHandler);
        cpSocket.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        cpSocket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, secuityErrorHandler);
        cpSocket.removeEventListener(ProgressEvent.SOCKET_DATA, socketData);
    }

    //关闭 socket
    public function closcSocket():void {
        if (CRMmodel.modelSocket != null) {
            CRMmodel.modelSocket.close();
            CRMmodel.modelSocket = null;
        }
    }

    //建立socket连接后，调用
    public function connectHandler(event:Event):void {
//         CRMtool.showAlert("成功");
        this.dispatchEvent(new Event("connOK"));
    }

    //服务器关闭 socket时，调用
    public function closeHandler(event:Event):void {

        //CRMtool.showAlert("关闭");
       CRMmodel.modelSocket = null;
       this.dispatchEvent(new Event("connclose"));
       // connectsocket();
    }

    //出现输入 输出错误时，调用
    public function ioErrorHandler(event:IOErrorEvent):void {
        //CRMtool.showAlert("异常");
        CRMmodel.modelSocket = null;
        this.dispatchEvent(new Event("connerror"));
    }

    //出现安全沙箱错误时，调用
    public function secuityErrorHandler(event:SecurityErrorEvent):void {
        //CRMtool.showAlert("沙箱");
        //this.dispatchEvent(new Event("connerror"));
        CRMmodel.modelSocket = null;
    }

    //获取 socket返回数据时，调用
    public function socketData(event:ProgressEvent):void {

        //this.dispatchEvent(new Event("conndata"));
    }


}
}
