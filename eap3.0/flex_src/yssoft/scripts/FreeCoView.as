import flash.display.Bitmap;
import flash.display.Loader;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.LinkButton;
import mx.events.FlexEvent;
import mx.events.ItemClickEvent;
import mx.rpc.events.ResultEvent;
import mx.utils.ObjectUtil;

import yssoft.comps.frame.module.CrmEapComboBox;
import yssoft.comps.frame.module.CrmEapTextInput;
import yssoft.models.CRMmodel;
import yssoft.models.ConstsModel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.views.workflow.CoPaintView;
import yssoft.vos.OAinvoiceVo;
import yssoft.vos.WfNodeVo;

/**
 * @author：zmm
 * 日期：2011-8-12
 * 功能 自由协同
 * 修改记录：
 */
//窗体参数
[Bindable]
public var winParam:Object;
[Bindable]
public var wfDrawType:String="new"; // 协同的绘制方式
[Bindable]
public var oaiid:int; //协同 iid
[Bindable]
public var optType:String=""; //协同 节点的处理模式

[Bindable]
public var oAinvoiceVo:OAinvoiceVo=new OAinvoiceVo();

[Bindable]
public var cdetailEnabled:Boolean = true;
//当前处理节点
[Bindable]
public var handleNode:WfNodeVo;

[Bindable]
public var drawbtEnabled:Boolean = true;
//互斥
private var fc:Object;
//窗体初始化
public function onWindowInit():void{
	//添加
    this.cdetailEnabled = true;
	this.createCrmEapTextInput();
	isEdit();
	fc=new Object();
	fc.newOpt="0,0,0,1,1,1";
	fc.openOpt="0,0,1,1,1,0";
	fc.dfOpt="1,1,1,1,1,0";
	fc.addOpt="0,0,0,1,1,1";
	fc.editOpt="0,0,0,1,1,1";
	fc.fqOpt="1,1,1,1,1,0";
	
	this.csubject.setFocus();
	oAinvoiceVo=new OAinvoiceVo();
	this.launchinfo.text=CRMmodel.hrperson.cname;
	flag=false;
	//Alert.show(""+winParam);
	if(winParam && winParam.hasOwnProperty("oaiid")){
		oaiid=winParam.oaiid;
		wfDrawType=winParam.wfDrawType;
		optType=winParam.optType;
		if(wfDrawType=="open"){
			
			//YJ Modify 2012-05-02  
			this.currentState = "draw";//触发工作流界面，为了初始化工作流相关属性
			this.currentState="desciption";
			
			//根据单据信息中 对应的登录人 消息的阅读状态
			editFreeDjMsgReaded(oaiid);
			
			//设置组件不可编辑
			isEdit(false);
			//getWorkFlow(oaiid,optType);
			getWorkFlowAndHandleNode(oaiid); // 获取协同信息与 处理节点
			
			//消息回复 这些都是 发起人是自己
			if(optType==ConstsModel.XTGL_OPT_DFSX || optType==ConstsModel.XTGL_OPT_GZSX || optType==ConstsModel.XTGL_OPT_YFSX || optType==ConstsModel.XTGL_OPT_YBSX){
				//显示 回复的
				this.replyView.getMessages(oaiid,optType);
				// 只是显示 回复信息
				this.replyView.optbar.visible=false;
				this.replyView.cmessage.visible=false;
				this.replyView.optbar.includeInLayout=false;
				this.replyView.cmessage.includeInLayout=false;
				this.replyView.hide.visible=false;
			}else{
				this.replyView.getMessagesHide(oaiid,optType);
				this.replyView.optbar.visible=true;
				this.replyView.cmessage.visible=true;
				this.replyView.optbar.includeInLayout=true;
				this.replyView.cmessage.includeInLayout=true;
			}
			
			// 
			
			// 后期添加 附件，关联等
			this.coAttachment.isImmediate=true;
			this.coAttachment.getCoFileList(oaiid);
			this.coAttachment.optType=optType;
			
			
			// 只有 待发事项  显示 buttonbar
			if(optType==ConstsModel.XTGL_OPT_DFSX){
				this.optbb.visible=true;
				this.optbb.includeInLayout=true;
				this.optlb.visible=false;
				this.optlb.includeInLayout=false;
				
				//转发 按钮
				this.zfbt.visible=false;
				this.zfbt.includeInLayout=false;
//				this.workflow = new CoPaintView();
			}else{
				this.optbb.visible=false;
				this.optbb.includeInLayout=false;
				this.optlb.visible=true;
				this.optlb.includeInLayout=true;
				this.optlb.text=this.label;
				
				this.zfbt.visible=true;
				this.zfbt.includeInLayout=true;
			}
		}
	}
	
	if(wfDrawType==null || wfDrawType=="" || wfDrawType=="new"){
		//Alert.show(""+ObjectUtil.toString(winParam));
		//电话热线 打开后
		if(winParam !=null && !(winParam is String)){
			//Alert.show(""+ObjectUtil.toString(winParam));
			if(winParam.hasOwnProperty("cdetail")){
				oAinvoiceVo.cdetail=winParam.cdetail;
				oAinvoiceVo.csubject="呼叫热线关联协同";
				oAinvoiceVo.icustomer=winParam.icustomer;
				oAinvoiceVo.customername=winParam.dwname;
			}
			/*var consult1:CrmEapTextInput=subHBox.getChildByName("UI_C1") as CrmEapTextInput;
			
			if(consult1!=null&&consult1.text!=null&&consult1.text!=null&&consult1.text!=""){
				var dwiid:String = consult1.consultList.getItemAt(0)[consult1.singleType.cconsultbkfld];
				var args:Array = new Array();
				args[0] = dwiid;
				this.callLater(setCZValue,args);
				//setCZValue(dwiid);
			}*/
			if(winParam.icustomer!=null&&winParam.icustomer!='0'){
				//this.callLater(setCZValue,winParam.icustomer);
				
				var c:CrmEapTextInput=subHBox.getChildByName("UI_C1") as CrmEapTextInput;
				if(c)
				{
					c.text=winParam.icustomer;
					c.onDataChange();
				}
			}
			
			
		}
		
		// 新建 不显示 右侧的 回复 和 上传 窗体
		//this.ac.visible=false;
		//this.ac.includeInLayout=false
		// 不显示 回复窗口
		this.replyView.visible=false;
		this.replyView.includeInLayout=false;
		this.replyView.enabled=false;
		this.replyView.hide.visible=false;
		//this.ac.removeChildAt(0);
		
		this.coAttachment.isImmediate=false;
		// 初始化 互斥 
		onFC();
	}else{
		this.replyView.visible=true;
		this.replyView.includeInLayout=true;
		this.replyView.enabled=true;
	}
	
	if(optType==ConstsModel.XTGL_OPT_DFSX){
		isEdit();
		this.onFC("df");
	}

	if(wfDrawType==null || wfDrawType=="" || wfDrawType=="new" || optType==ConstsModel.XTGL_OPT_DFSX){ // 只有新建与待发的时候显示 toolbar
		this.cdetail.toolbar.visible=true;
		this.cdetail.toolbar.includeInLayout=true;
	}else{
		this.cdetail.toolbar.visible=false;
		this.cdetail.toolbar.includeInLayout=false;
	}
	
}

//窗体打开
public function onWindowOpen():void{
	clearWindow();
	onWindowInit();
}

//清除 页面信息
public function clearWindow():void{
	onNew();
	this.replyView.clearInit();
	this.coAttachment.clearInit();
	if(this.workflow){
		this.workflow.mainDraw.clearAllNodes("clear");
	}
	// 删除 参照
/*	if(this.subHBox.getChildByName("UI_C1")){
		this.subHBox.removeChild(this.subHBox.getChildByName("UI_C1"));
	}*/
}

//设置 页面中得组件的是否可编辑

private function isEdit(bool:Boolean=true):void{
	this.csubject.editable=bool;
	//this.icustomer.editable=bool;
	this.dfinished.editable=bool;
	this.dfinished.enabled=bool;
	//this.launchinfo.editable=bool;
	//this.launchinfo.enabled=false;
	this.cdetail.textArea.editable=bool;
	//this.cdetail.enabled=bool;
	
	var c:CrmEapTextInput=subHBox.getChildByName("UI_C1") as CrmEapTextInput;
	if(c!=null)
	{
		c.editable = bool;
	}
	
}

// 视图状态 切换
private var flag:Boolean=false;

private function hdividedbox1_stateChangeCompleteHandler(event:FlexEvent):void{
	if(!flag){
		flag=true;
		if(this.currentState=="draw"){
			if(wfDrawType=="" || wfDrawType=="new"){
				this.workflow.mainDraw.wfDrawType="new";
				this.workflow.mainDraw.createNewWorkFlow();
			}else if(wfDrawType=="open"){
				this.workflow.mainDraw.wfDrawType="open";
				this.workflow.mainDraw.workFlowEntrance(optType,oaiid,this.handleNode);
				
				if(optType != ConstsModel.XTGL_OPT_DFSX){
					this.workflow.showOrHideLeft();
				}
			}
		}
	}
}

//窗体关闭,完成窗体的清理工作
public function onWindowClose():void{
	//mx.controls.Alert.show("---工作流close---");
}
private var workflowOpt:String="";
private function  optbb_itemClickHandler(event:ItemClickEvent):void
{
	workflowOpt=event.item.opt;
	
	switch(workflowOpt){
		case "onNew":onNew();onButtonFC("add");break;
		//case "onEdit":onEdit();onButtonFC("edit");break;
		case "onEdit":onButtonFC("edit");break;
		case "onDelete":onDelete();break;
		case "onSend":onSend();break;
		case "onPause":onPause();break;
		case "onGiveup":onGiveup();onButtonFC("fq");break;
	}
}
private function setoAinvoiceVo():OAinvoiceVo{
	if(oAinvoiceVo==null){
		oAinvoiceVo=new OAinvoiceVo();
	}
	this.oAinvoiceVo.cdetail=this.cdetail.htmlText;
	this.oAinvoiceVo.csubject=this.csubject.text;
	this.oAinvoiceVo.csendnew=this.csendnew.htmlText;
	
	this.oAinvoiceVo.icustomer=getCZValue();
	//this.oAinvoiceVo.icustomer=((this.icustomer.cconsultbkfld && this.icustomer.cconsultbkfld.length !=0 )?this.icustomer.cconsultbkfld[0]:0);//parseInt(this.icustomer.text);
	this.oAinvoiceVo.imaker=CRMmodel.userId;
	this.oAinvoiceVo.dfinished=dfinished.text==""?null:dfinished.text;
	return oAinvoiceVo;
}

private var nodes:ArrayCollection; // 记录所有节点信息
// 日期格式验证
private var datereg:RegExp=/(([0-9]{3}[1-9]|[0-9]{2}[1-9][0-9]{1}|[0-9]{1}[1-9][0-9]{2}|[1-9][0-9]{3})-(((0[13578]|1[02])-(0[1-9]|[12][0-9]|3[01]))|((0[469]|11)-(0[1-9]|[12][0-9]|30))|(02-(0[1-9]|[1][0-9]|2[0-8]))))|((([0-9]{2})(0[48]|[2468][048]|[13579][26])|((0[48]|[2468][048]|[3579][26])00))-02-29)/;
private function checkParam():Boolean{
	
	if(this.workflow){
		nodes=this.workflow.mainDraw.xml2ArrayCollection();
	}
	
	if(wfDrawType != "open"){ //open 是不检查
		
		if(this.workflow == null){
			CRMtool.tipAlert("未创建工作流，不予操作！");
			return false;
		}
		
		//nodes=this.workflow.mainDraw.xml2ArrayCollection();
		if(nodes && nodes.length<=1){//只有发起人节点时，不予操作
			CRMtool.tipAlert("未创建工作流，不予操作！");
			return false;
		}
	}
	// 相关主题
	if( CRMtool.isStringNull(csubject.text) ){
		CRMtool.tipAlert("协助主题，不能为空!",this.csubject);
		return false;
	}
	// 完成时间格式
	if( CRMtool.isStringNotNull(this.dfinished.text)  && !datereg.test(this.dfinished.text)){
		CRMtool.tipAlert("完成时间，格式为[YYYY-MM-DD]！",this.dfinished);
		return false;
	}
	onFC(this.oldfc);
	return true;
}
private function onNew():void{
	this.wfDrawType="new";
	this.oAinvoiceVo=new OAinvoiceVo();
	setCZValue("");
	//清空数据
	//onWindowInit();
	if(this.workflow){
		this.workflow.mainDraw.clearAllNodes();
	}
	this.currentState="desciption";
	this.descbt.selected=true;
    this.cdetailEnabled = true;
}
// 暂存 就是 原样保存 节点信息，节点的 istatus 为0  （0待发送、1已发送、2未进入、3待处理、4暂存待办、5已处理）
private function onPause():void{
	if(wfDrawType==null || wfDrawType=="" || wfDrawType=="new"){
		this.onPause1();
	}else if(wfDrawType=="open"){ // 修改
		if(this.workflow==null){// 绘制窗口没有打开，直接保存
			AccessUtil.remoteCallJava("WorkFlowDest","updateOAinvoice",editCallBack,this.setoAinvoiceVo(),"正在保存协同数据...");
		}else{//打开 绘制窗口后，发送保存
			this.onEdit();
		}
	}
}

private function onPause1():void{
	if(!checkParam()){
		return;
	}
	setoAinvoiceVo();
	nodes.addItem(oAinvoiceVo);
	AccessUtil.remoteCallJava("WorkFlowDest","insertOAinvoice",wf_callBack,{"nodes":nodes,"iperson":CRMmodel.userId},"正在保存协同数据...");
}

private function onDelete():void{
	if( oaiid ==0 ){
		return;
	}
	CRMtool.tipAlert1("确认删除协同吗?",null,"AFFIRM",onDelete1);
}

private function onDelete1():void{
	AccessUtil.remoteCallJava("WorkFlowDest","deleteWorkFlow",deleteCallBack,{"ioainvoice":oaiid},"正在删除协同数据...");
}

private function deleteCallBack(event:ResultEvent):void{
	if(event.result){
		//CRMtool.tipAlert("保存成功！");
		// 关闭窗体
		CRMtool.removeChildFromViewStack();
	}else{
		CRMtool.tipAlert("协同删除失败！");
	}
}
// 发送时，起始节点的（层级一）istatus 为 1 已发送，层级二 istatus 为 3 待处理，其他层级的为0待发送

private function onSend():void{
	if(wfDrawType==null || wfDrawType=="" || wfDrawType=="new"){
		this.onSend1();
	}else if(wfDrawType=="open"){ // 修改
		if(this.workflow==null){// 绘制窗口没有打开，直接保存
			zjEditWorkFlow();
		}else{//打开 绘制窗口后，发送保存
			this.onEdit();
		}
	}
}
private function zjEditWorkFlow():void{
	if(!checkParam()){
		return;
	}
	var param:Object={};
		param.oAinvoiceVo=setoAinvoiceVo();
		param.ioainvoice=oaiid;
		param.ifuncregedit=10;
		param.iperson = CRMmodel.userId;
	AccessUtil.remoteCallJava("WorkFlowDest","zjEditWorkFlow",wf_callBack,param,"正在保存协同数据...");
}
private function onSend1():void{
	if(!checkParam()){
		return;
	}
	setoAinvoiceVo();
	// 进行处理
	for each(var item:WfNodeVo in nodes){
		if(item.inodelevel==1){
			item.istatus=1;
		}
		
		if(item.inodelevel==2){
			item.istatus=3;
		}
	}
	nodes.addItem(oAinvoiceVo);
	
	AccessUtil.remoteCallJava("WorkFlowDest","insertOAinvoice",wf_callBack,{"nodes":nodes,"iperson":CRMmodel.userId},"正在保存协同数据...");
}
// 还原 修改前的 工作流
private function restoreWorkFlow():void{
	if(this.workflow == null){
		//CRMtool.tipAlert("未曾打开工作流，不予操作！");
		return;
	}
	this.workflow.mainDraw.restoreWorkFlow();
}
//放弃onGiveup, 两种情况 1 新建时 onNew(), 2 修改时，还原
private function onGiveup():void{
	if(wfDrawType=="new"){
		this.onNew();
        this.cdetailEnabled = false;
	}else if(wfDrawType=="open"){ // 修改
		this.oAinvoiceVo=oAinvoiceVo;
		restoreWorkFlow();
	}
}
// 修改 只对暂存的
private function onEdit():void{
	
/*	Alert.show("workflowOpt:["+workflowOpt+"],打开模式opt:["+this.optType+"]");
	return ;*/
	
	if(!checkParam()){
		return;
	}
	setoAinvoiceVo();
	
	if(this.workflow==null){// 没有打开绘制窗体,只保存 协同的描述信息
		AccessUtil.remoteCallJava("WorkFlowDest","updateOAinvoice",editCallBack,this.setoAinvoiceVo(),"正在保存协同数据...");
		return;
	}
	
	var params:Object=this.workflow.mainDraw.editWFNodes();
	 	params.ioainvoice=this.oAinvoiceVo.iid; // 协同的iid
		params.oAinvoiceVo=this.oAinvoiceVo;
		params.iperson = CRMmodel.userId;
		
		if(wfDrawType=="open"){ // 修改并发送
			var editNodesac:ArrayCollection=params.newNodes as ArrayCollection; 		// 修改
			var newNodesac:ArrayCollection=params.editNodes as ArrayCollection; 		// 新增
				for each(var item:WfNodeVo in editNodesac){
					if(item.inodelevel==1){
						if(this.workflowOpt=="onSend"){
							item.istatus=1;
						}
						if(this.workflowOpt=="onPause"){
							item.istatus=0;
						}
					}
					
					if(item.inodelevel==2){
						if(this.workflowOpt=="onSend"){
							item.istatus=3;
						}
						if(this.workflowOpt=="onPause"){
							item.istatus=2;
						}
					}
				}
				
				for each(var item:WfNodeVo in newNodesac){
					if(item.inodelevel==1){
						if(this.workflowOpt=="onSend"){
							item.istatus=1;
						}
						if(this.workflowOpt=="onPause"){
							item.istatus=0;
						}
					}
					
					if(item.inodelevel==2){
						if(this.workflowOpt=="onSend"){
							item.istatus=3;
						}
						if(this.workflowOpt=="onPause"){
							item.istatus=2;
						}
					}
				}
		}
		
	AccessUtil.remoteCallJava("WorkFlowDest","editWorkFlow",editCallBack,params,"正在保存协同数据...");
}
private function editCallBack(event:ResultEvent):void{
	//Alert.show("修改返回:"+(event.result as String));
	if(event.result){
		CRMtool.removeChildFromViewStack(); 
		//CRMtool.tipAlert("处理成功！");
		this.uploadFiles(this.oaiid);
	}else{
		CRMtool.tipAlert("处理失败！");
	}
}

private function wf_callBack(event:ResultEvent):void{
	if(event.result){
		//CRMtool.tipAlert("保存成功！");
		// 关闭窗体
		if(wfDrawType !="open"){
			this.oaiid=event.result as int;
			uploadFiles(this.oaiid);
		}
		//Alert.show("保存后的oaiid["+this.oaiid+"]");
		CRMtool.removeChildFromViewStack(); 
	}else{
		CRMtool.tipAlert("保存失败！");
	}
	//mx.controls.Alert.show(""+event.result);
}
// 根据 协同的 iid 来获取协同的信息
public function getWorkFlow(iid:int):void{
	AccessUtil.remoteCallJava("WorkFlowDest","getWorkFlow",workFlowCallBack,iid,"正在获取协同信息...");
}

public function getWorkFlowAndHandleNode(iid:int):void{
	var param:Object={};
	param.optType=this.optType;
	param.ioainvoice=iid;
	param.iperson=CRMmodel.userId;
	AccessUtil.remoteCallJava("WorkFlowDest","getWorkFlowAndHandleNode",workFlowCallBack,param,"正在获取协同信息...");
}
//
private function workFlowCallBack(event:ResultEvent):void{//replyView
	if(event.result){
		
		this.oAinvoiceVo=event.result.oa as OAinvoiceVo;
		this.oaiid=this.oAinvoiceVo.iid;
		this.handleNode=event.result.handleNode as WfNodeVo;
		
		this.setCZValue(this.oAinvoiceVo.icustomer+"");
		
		if(this.handleNode==null){
			
		}
		
		if(this.oAinvoiceVo.isendnew ==0){ //判断 协同是不是有 其他协同转发而来
			this.zfvbox.visible=false;
			this.zfvbox.includeInLayout=false;
		}else{
			this.zfvbox.visible=true;
			this.zfvbox.includeInLayout=true;
			
			this.isEdit(false);
			if(optType==ConstsModel.XTGL_OPT_DFSX){
				this.dfinished.editable=true;
				this.csendnew.editable=true;
			}else{
				this.csendnew.editable=false;
			}
			
			this.cdetail.textArea.editable=false;
			this.cdetail.toolbar.visible=false;
			this.cdetail.toolbar.includeInLayout=false;
			
		}
		
		if(this.oAinvoiceVo.imaker!=CRMmodel.userId){ // 判断 协同的创建者是不是和当前的登陆者是同一个人
			// 不是同一个要获取该创建者的 头像
			loadUserHeaderIcon();
		}
	}
}

/**
 *  加载用户的头像
 */
private function loadUserHeaderIcon():void{
	headericon.source=CRMtool.getUserHeaderIconById(oAinvoiceVo.imaker);
	var param:Object={};
	param.fileName=""+oAinvoiceVo.imaker;
	param.fileType="jpg";
	param.downType="0";
	AccessUtil.remoteCallJava("FileDest","downFile",loadHeaderIconCallBack,param,"图片下载中...",false);
}
private function loadHeaderIconCallBack(event:ResultEvent):void{
	if(event.result){
		var ba:ByteArray=event.result as ByteArray;
		var loader:Loader = new Loader();
		try{
		loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(event:Event):void{
			var sourceBMP:Bitmap = event.currentTarget.loader.content as Bitmap;
			if(sourceBMP == null ){
				headericon.source=ConstsModel.wf_inodetype_0;
				return;
			}
			CRMtool.addUserHeaderIcon(oAinvoiceVo.imaker,sourceBMP);
			headericon.source=sourceBMP;
		});
		loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,function(event:Event):void{
			headericon.source=ConstsModel.wf_inodetype_0;
		});
		loader.loadBytes(ba);
		}catch(e:Error){}
	}else{
		headericon.source=ConstsModel.wf_inodetype_0;
	}
}

/**
 *  回车调转 
 */
private var iids:Array=["csubject","dfinished","launchinfo"];
private function enterHandler(event:Event):void{
	var id:String=event.currentTarget.id;
	var index:int=iids.indexOf(id);
	var iidlen:int=iids.length-1;
	this.setFocus()
	if(index >= 0 && index < iidlen){
		(this[iids[index+1]]).setFocus();
	}else{
		(this[iids[0]]).setFocus();
	}
}

/**
 * 按钮互斥
 */



private function onFC(type:String="new"):void{
	onButtonFC(type);
}
private var oldfc:String="";//前一个fc
private var newfc:String="";//当前fc
private function onButtonFC(type:String="new"):void{

	if(oldfc==""){
		oldfc=type;
		newfc=type;
	}else{
		oldfc=newfc;
		newfc=type;
	}

    if(oldfc == "new" || oldfc == "add") {
        fc.fqOpt="1,0,0,0,0,0";
    }else {
        fc.fqOpt="1,1,1,1,1,0";
    }
    if(type == "new" || type == "add" || type == "edit") {
        drawbtEnabled = true;
    }else {
        drawbtEnabled = false;
    }
	var tp:Array=(fc[type+"Opt"] as String).split(",");
		for(var i:int=0;i<tp.length;i++){
			(this.optbb.getChildAt(i) as Button).enabled=(tp[i]=="0"?false:true);
		}
}

/*
 *  上传附件
 */
public function uploadFiles(oaiid:int=0):void{
	if(oaiid==0){
		return;
	}
	this.coAttachment.ifuncregedit=10;
	this.coAttachment.iid=oaiid;
	this.coAttachment.uploadHandler();
}


//----------转发协同
private function zfbtHandler():void{
	var param:Object=new Object();
	param.oaiid=this.oaiid; // 转发协同的 来源
	param.wfDrawType="new";
	param.optType="zfnew";
	param.oAinvoiceVo=oAinvoiceVo;
	//CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore",param,"新建销售线索","");
	CRMtool.openMenuItemFormOther("yssoft.views.workflow.ZFFreeCoView",param,"[转发自由协同]",this.oaiid+":zfnew");
}

// 
private function editFreeDjMsgReaded(iinvoice:int):void{
	if(iinvoice==0){
		return;
	}
	var param:Object={};
	param.ifunid=10;
	param.iinvoice=iinvoice;
	param.ipersonid=CRMmodel.userId;
	AccessUtil.remoteCallJava("WorkFlowDest","editdjmsgreaded",null,param,null,false);
}
[Bindable]
private var _consultObj:Object = {};//参照所需

public function set consultObj(value:Object):void{
	this._consultObj = value;
}

// 添加参照 ，动态
private function createCrmEapTextInput():void{
	var obj:Object=new Object();
	obj.cobjectname="UI_C1";
	obj.ifuncregedit="45";
	obj.cfield="icustomer";
	AccessUtil.remoteCallJava("CommonalityDest","queryFun",requestCallBack,obj);
}

private var eapTI:CrmEapTextInput;
private function requestCallBack(event:ResultEvent):void
{
	var obj:Object = event.result as Object;
	//obj.consultSql = "select iid,ccode,cname from cs_customer";
	//obj.cconsultipvf="ccode";
	if(eapTI == null){
		eapTI = new CrmEapTextInput();  
		//eapTI.singleType.cconsultipvf = "ccode";
		eapTI.addEventListener("initialization",function(event:Event):void
		{
			eapTI.onDataChange();
		});
	}
	eapTI.percentWidth=100;
	eapTI.singleType = obj;
	subHBox.addChild(eapTI);
	
	if(winParam&&winParam.hasOwnProperty("icustomer")&&winParam.icustomer!=null&&winParam.icustomer!='0'){
		eapTI.text=winParam.icustomer;
		eapTI.onDataChange();
	}

	if(winParam && winParam.hasOwnProperty("wfDrawType")&&winParam.wfDrawType=="open")
	{
		eapTI.editable = false;
	}

}

// 获取参照返回的数值
private function getCZValue():int{
	var c:CrmEapTextInput=subHBox.getChildByName("UI_C1") as CrmEapTextInput;
	if(c.consultList!=null&&c.consultList.length>0)
	{
		return parseInt(c.consultList.getItemAt(0)[c.singleType.cconsultbkfld]);
	}
	return 0;
}
// 设置 参照 
private function setCZValue(txt:String):void{
	var c:CrmEapTextInput=subHBox.getChildByName("UI_C1") as CrmEapTextInput;
	if(c)
	{
		c.text=txt;
		c.onDataChange();
	}
}

protected function vbox1_updateCompleteHandler(event:FlexEvent):void
{
	// TODO Auto-generated method stub
	CRMtool.setTabIndex(mainVbox);
}

