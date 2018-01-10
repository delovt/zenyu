import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.events.FlexEvent;
import mx.events.MenuEvent;
import mx.rpc.events.ResultEvent;

import yssoft.frameui.FrameCore;
import yssoft.models.CRMmodel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.views.workfform.EndorseWindow;
import yssoft.vos.WfMessageVo;
import yssoft.vos.WfNodeVo;
import mx.events.ItemClickEvent;

private var timegap:Number=10000; // 连续两次发送的时间间隔，单位毫秒
private var curtime:Number=0;	   // 上一次的发送时间
private var newTime:Number=0;	   //  最近一次的发送时间
private var wfmessageVo:WfMessageVo=new WfMessageVo();

public var relats:ArrayCollection=new ArrayCollection();
public var handleNode:WfNodeVo;

[Bindable]
private var bb_opt_items:ArrayCollection=new ArrayCollection([
	{label:"加签",name:"jq"		},
	{label:"回退",name:"ht"	},
	{label:"暂存",name:"zcdb"		}
]);
[Bindable]
public var XTHFitems:ArrayCollection = new ArrayCollection();
public var isNew:Boolean=false;
// 获取协同的当前节点 
protected function XTHFHandler():void
{
	if(isNew == false){
		replayGetFormWorkFlow(ifuniid,curiid);
	}
	this.cmessage.setFocus();
	entrance(this.ifuniid,this.wfiid,this.curiid);
	
}
public function getXTHFitems():Boolean{
	if(XTHFitems.length>0){
		return true;
	}
	return false;
}
//public var oaiid:int; // 当前协同工作路iid
public function replayGetFormWorkFlow(ifuncregedit:int=0,iinvoice:int=0):void{
	if(ifuncregedit==0 || iinvoice==0){
		return;
	}
	var params:Object={};
	params.ifuncregedit=ifuncregedit;
	params.iperson=CRMmodel.userId;
	params.iinvoice=iinvoice;
	this.ifuncregedit=ifuncregedit;

	
	AccessUtil.remoteCallJava("WorkFlowDest","replayGetFormWorkFlow",gfwfCallBack,params,null,false);
}


//lr add 当前节点信息 是否主表  iid
private var meNode:Object;

private function gfwfCallBack(event:ResultEvent):void{
	if(event.result){
		this.handleNode=event.result.handlerNode as WfNodeVo;
		this.relats=event.result.nodeentry as ArrayCollection;
        var me:Object = event.result.me;
        if(meNode == null){
            meNode = me;
            AccessUtil.remoteCallJava("WorkFlowDest","insertWfTime",null,{isNode:meNode.isNode, iid:meNode.iid,itype:2});
        }



        (parentForm as FrameCore).cexecsqlBack =  CRMtool.replaceReadXMLMarkValues(this.handleNode.cexecsql);
		//this.iinvoice=this.handleNode.ioainvoice;
		isShowOpt(true);
	}else{
		isShowOpt(false);
	}
}


//设置 是否显示
private function isShowOpt(bool:Boolean=false):void{
	this.optHandlerBar.visible=bool;
	this.optHandlerBar.includeInLayout=bool;
}

private function getMsgCallBack(event:ResultEvent):void{
	XTHFitems=event.result as ArrayCollection;
}



private function endorsebt_clickHandler():void{
	//Alert.show("当前处理节点"+mx.utils.ObjectUtil.toString(this.handleNode));
	if(iinvoice == 0){
		CRMtool.tipAlert("获取不到协同工作流信息");
		return;
	}
	
	if(this.handleNode != null && this.handleNode.istatus !=5){
		var jq:EndorseWindow=new EndorseWindow();
		jq.ifuniid=ifuncregedit;
		jq.iinvoice=iinvoice;
		jq.owner=this.owner;
		jq.ioaiid=this.handleNode.ioainvoice;
		CRMtool.openView(jq,false);
	}else{
		CRMtool.tipAlert("当前节点不可加签");
	}
}

private function returnbt_clickHandler():void{
	if(iinvoice == 0){
		CRMtool.tipAlert("获取不到协同工作流信息");
		return;
	}
	if(this.handleNode==null){
		CRMtool.tipAlert("当前节点不可回退");
		return;
	}
	
	CRMtool.tipAlert1("您确定要回退此节点？",null,"AFFIRM",function():void{
		onReturnHandler();
	});
}

private function onReturnHandler():void{
	var level:int=this.handleNode.inodelevel;
	
	if(level <=1){ // 排除不可回退的
		return;
	}
	var params:Object={};
	//var msgvo:Object=this.getParam();
	//msgvo.iresult=6;
	//params.msgvo=msgvo;
	params.ioainvoice=this.handleNode.ioainvoice;
	params.istatus=0;
	params.inodelevel=this.handleNode.inodelevel;
	
	params.ifuncregedit=ifuncregedit;
	params.pinodeid=this.handleNode.ipnodeid; // 父节点的iid
	params.iperson = CRMmodel.userId;
    params.iinvoice = iinvoice;
    params.iistatus = (this.owner as FrameCore).formIstatus;
    if ((this.owner as FrameCore).formIstatus > 0)
        params.iistatus = 0 - CRMtool.getNumber((this.owner as FrameCore).formIstatus);
    //lr add  工作流注入
    //Alert.show("回退触发注入，sql="+this.handleNode.cexecsql);

    params.cexecsql =getCexecsql("回退");
	
	if(level==2){
		params.pistatus=3;
		AccessUtil.remoteCallJava("WorkFlowDest","return2level",onReturnCallBack,params,"正在回退，请稍等...");
	}else{
		params.pistatus=3;
		params.pinodelevel=this.handleNode.inodelevel-1;
		//params.pinodeid=this.handleNode.ipnodeid;
		AccessUtil.remoteCallJava("WorkFlowDest","returnOtheLevel",onReturnCallBack,params,"正在回退，请稍等...");
	}

    AccessUtil.remoteCallJava("WorkFlowDest","insertWfTime",null,{isNode:meNode.isNode, iid:meNode.iid,itype:5});
}

private function onReturnCallBack(event:ResultEvent):void{
	if(event.result && (event.result as String)=="suc"){
		CRMtool.tipAlert("回退成功");
		submit_clickHandler("only",4); // 回退成功后，提交处理意见
		if(this.owner is FrameCore){
			if((this.owner as FrameCore).workflow){
				(this.owner as FrameCore).workflow.getFormWorkFlow(ifuncregedit,iinvoice);
			} 
			(this.owner as FrameCore).getWordFlowDetail(ifuncregedit,iinvoice);
		}
        (this.owner as FrameCore).dispatchEvent(new Event("cardValueChange"));
	}else{
		CRMtool.tipAlert("回退失败");
	}
}

protected function menu1_itemClickHandler(event:MenuEvent):void
{
	if(event.item.opt=="jq"){
		endorsebt_clickHandler();
	}else if(event.item.opt=="ht"){
		returnbt_clickHandler();
	}else if(event.item.opt=="zcdb"){
		onzcdb();
	}
}

private function bb_clickHandler(event:ItemClickEvent):void {
	if(event.label=="加签"){
		endorsebt_clickHandler();
	}else if(event.label=="回退"){
		returnbt_clickHandler();
	}else if(event.label=="暂存"){
		onzcdb();
	}
}

//暂存待办
private function onzcdb():void{
	if(this.handleNode == null){
		CRMtool.tipAlert("获取不到协同工作流信息");
		return;
	}
	var params:Object={};
	var msgvo:Object=this.getParam();
	msgvo.iresult=3;
	params.msgvo=msgvo;
	params.ifuncregedit=ifuncregedit;
	params.ioainvoice=this.handleNode.ioainvoice;
	params.inodeid=handleNode.inodeid;
	params.iperson=CRMmodel.userId;

    params.cexecsql =getCexecsql("暂存");

    //lr add  工作流注入
    //Alert.show("暂存触发注入，sql="+this.handleNode.cexecsql);
	AccessUtil.remoteCallJava("WorkFlowDest","ywZcdbHandler",XTcallBack,params,null,false);
    AccessUtil.remoteCallJava("WorkFlowDest","insertWfTime",null,{isNode:meNode.isNode, iid:meNode.iid,itype:3});
}

protected function vbox1_showHandler(event:FlexEvent):void
{
	// TODO Auto-generated method stub
	this.cmessage.setFocus();
}

// 统一入口
public function entrance(ifuniid:int,wfiid:int,curiid:int):void{
	//Alert.show("ifuniid["+ifuniid+"],wfiid["+wfiid+"],curiid["+curiid+"]");
	this.clearParam();
	getMessages(wfiid);
	replayGetFormWorkFlow(ifuniid,curiid);
}

// 获取 消息列表
public function getMessages(oaid:int,opt:String=""):void{
	//ioainvoice=oaid;
	//optType=opt;
	var param:Object={};
	param.ioainvoice=oaid;
	param.iperson=CRMmodel.userId;
	AccessUtil.remoteCallJava("WorkFlowDest","getMessages",getMsgCallBack,param,null,false);
	//在获取消息的同时 ，获取当前处理节点
	//replayGetFormWorkFlow(this.);
}


public function checkParam():Boolean{
	if(wfmessageVo==null){
		return false;
	}
	/* 		if(CRMtool.isStringNull(this.cmessage.text)){
	CRMtool.tipAlert("请输入处理意见!",this.cmessage);
	return false;
	} */
	return true;
}
public function getParam():Object{
	wfmessageVo.bdiary=this.bdiary.selected?1:0;
	wfmessageVo.bhide=this.bhide.selected?1:0;
	wfmessageVo.iresult=0;// 0已阅、1同意、2不同意、3暂存待办、4退回、5 已审
	wfmessageVo.cmessage=this.cmessage.text;
	wfmessageVo.iperson=CRMmodel.userId;
	if(this.handleNode){
		wfmessageVo.ioainvoice=this.handleNode.ioainvoice;
		if(this.handleNode.inodemode == 1){ // 审批
			wfmessageVo.iresult=5
		}
	}
	//wfmessageVo.ioainvoice=this.handleNode.ioainvoice;
	return wfmessageVo;
}

public function submit_clickHandler(type:String="only",msgtype:int=0):void{
	this.newTime=(new Date()).getTime();
	// 时间验证
	if(this.curtime+this.timegap > this.newTime){
		//Alert.show("发送信息过于频繁,请稍后在发送...");
		return;
	}else{
		this.curtime=this.newTime;
	} 
	
	/* if(!checkParam()){
	return;
	} */
	////* 参数：ifuncregedit ,iinvoice--单据的iid,cnodeid(节点iid),other,节点操作类型 opt,perosn personid
	var params:Object={};
	params.msgvo=this.getParam();
	if(msgtype==4){
		params.msgvo.iresult=4
	}
	params.ifuncregedit=ifuncregedit;
	params.iinvoice=iinvoice;
	
	if(type=="only"){//只发送信息
		//params.iresult=3; // 暂存待办
		AccessUtil.remoteCallJava("WorkFlowDest","onlySendReplay",XTcallBack,params,null,false);
		return;
	}
	
	if(this.handleNode == null){
		CRMtool.tipAlert("无法获取当前节点信息");
		return;
	}
	
	params.inodeid=this.handleNode.inodeid;
	params.cnodeid=this.handleNode.inodeid
	//params.cnodeid="node131668251170377";
	params.opt=this.handleNode.source;
	//params.opt="wf_nodes"
	if(this.handleNode.inodemode == 1 ){ // 审批
		params.iresult=5; // 已审
	}
	params.iperson=CRMmodel.userId;
	params.other="cmessage="+this.cmessage.text+"@@cresult="+wfmessageVo.iresult+"@@hand=测试hand";

    //lr add  工作流注入
    //Alert.show("处理触发注入，sql="+this.handleNode.cexecsql);

    params.cexecsql =getCexecsql("处理");
    if (this.handleNode.iistatus > 0)
        params.iistatus = this.handleNode.iistatus;
    else
        params.iistatus = 0;
        //if(type=="only"){//只发送信息
	//AccessUtil.remoteCallJava("WorkFlowDest","onlySendReplay",callBack,params,null,false);
	//}else{//发送信息 并进行流程推进
	AccessUtil.remoteCallJava("WorkFlowDest","co_enterHandler",XTcallBack,params,"正在保存协同回复信息...");
	//}

    AccessUtil.remoteCallJava("WorkFlowDest","insertWfTime",null,{isNode:meNode.isNode, iid:meNode.iid,itype:4});
}

private function getCexecsql(wftype:String):String{
    var cexecsql:String = CRMtool.replaceReadXMLMarkValues(this.handleNode.cexecsql);
    cexecsql = CRMtool.replaceWFtypeValues(cexecsql,wftype);

    return CRMtool.replaceCrmeapAndSystemValues(cexecsql,parentForm.crmeap);
}

public function XTcallBack(event:ResultEvent):void{
	//Alert.show("["+(event.result as String)+"]");
	this.cmessage.text="";
	if(event.result){
		if(isNaN(event.result as int)){
			CRMtool.tipAlert(event.result as String);
			return;
		}
		wfmessageVo.iid=event.result as int;
		wfmessageVo.dprocess=CRMtool.getFormatDateString("YY-MM-DD HH:NN");
		wfmessageVo.fdate=CRMtool.getFormatDateString("YY-MM-DD HH:NN");
		wfmessageVo.cname=CRMmodel.hrperson.cname;
		/* 					if(wfmessageVo.iresult==3){
		wfmessageVo.resultname="暂存待办";
		}else{
		wfmessageVo.resultname="已阅";
		} */
		if(wfmessageVo.iresult==0){
			if(this.handleNode.inodemode == 0){
				wfmessageVo.resultname="已阅";
			}else{
				wfmessageVo.resultname="已审";
			}
		}else if(wfmessageVo.iresult==3){
			wfmessageVo.resultname="暂存待办";
		}else if(wfmessageVo.iresult==5){
			wfmessageVo.resultname="已审";
		}else if(wfmessageVo.iresult==4){
			wfmessageVo.resultname="退回";
		}
		
		XTHFitems.addItemAt(wfmessageVo,0);
		//CRMtool.tipAlert("信息发送成功!");
		
		// 处理 发送成功后的 界面显示
		cmessage.visible=false;
		hide.visible=false;
		cmessage.includeInLayout=false;
		//optbar.enabled=false;
		optHandlerBar.visible=false;
		optHandlerBar.includeInLayout=false; 
		
		if(wfmessageVo.iresult==3){
			return;
		}
		if(this.owner is FrameCore){
			if((this.owner as FrameCore).workflow){
				(this.owner as FrameCore).workflow.getFormWorkFlow(ifuncregedit,iinvoice);
			} 
			(this.owner as FrameCore).getWordFlowDetail(ifuncregedit,iinvoice);
            if (this.handleNode.iistatus > 0)
                (this.owner as FrameCore).getStatus();
		}
	}else{
		CRMtool.tipAlert("信息发送失败,请重发!");
	}
    (this.owner as FrameCore).dispatchEvent(new Event("cardValueChange"));
	AccessUtil.remoteCallJava("As_optionsDest","getOptionsByCclass",judgeCloseHandler,{cclass:"public"},null,false);	
}
private function judgeCloseHandler(evt:ResultEvent):void{
	var basicSetResult:Object = evt.result;
	var basicSetArr:ArrayCollection = basicSetResult.mainOptions;
	var flag:Boolean = basicSetArr[0].cvalue==1?true:false;
	if(flag){
		CRMtool.removeChildFromViewStack();
	}
}