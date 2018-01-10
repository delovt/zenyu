/**
 * Created with IntelliJ IDEA.
 * User: yj
 * Date: 14-8-1
 * Time: 上午8:13
 * To change this template use File | Settings | File Templates.
 */

import flash.events.Event;

import mx.rpc.events.ResultEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.soap.WebService;

import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;


private var outNum:String = "";
public var callNum:String = "";


public function getCallNumber(phoneNum:String):void {
    AccessUtil.remoteCallJava("LocalNumber", "getOutNum", function (event:ResultEvent):void {
        outNum = String(event.result);
        dispatchEvent(Event(new EventGetCall("GetCall", outNum)));
    },{callnum:phoneNum},null,false);


}


