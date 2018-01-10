
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.net.FileReference;
import flash.net.URLRequest;
import flash.net.URLVariables;

import mx.collections.ArrayCollection;
import mx.rpc.events.ResultEvent;

import yssoft.comps.UploadFileWin;
import yssoft.frameui.side.MyEvent;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.views.preview.PreviewFile;

[Bindable]
private var fileItems:ArrayCollection=new ArrayCollection();
public var isImmediate:Boolean=true;// 是否立即上传文件
public function uploadFile():void{
	if(ifuncregedit <=0 || curiid <=0){
		//CRMtool.tipAlert("单据信息不全不能添加附件");
		isImmediate=false;
		//return;
	}
	
	var uploadFileWin:UploadFileWin=new UploadFileWin();
	
	uploadFileWin.ifuncregedit=ifuncregedit;
	
	//uploadFileWin.iinvoices=ifuncregedit; //
	uploadFileWin.isImmediate=isImmediate;
	uploadFileWin.callBack=callBackHandler;
	uploadFileWin.iinvoice=wfiid;
	uploadFileWin.iinvoices=curiid;
	
	
	CRMtool.openView(uploadFileWin);
}

public function callBackHandler(ac:ArrayCollection,flag:String='0'):void{
	//getCoFileList(iid);
	
//	for each (var item:Object in ac ){
//		items.addItem({"cname":item.cname,"enable":flag});
//	}
	getCoFileList(wfiid,curiid);
}

public function getCoFileList(iid1:int=0,iinvoices1:int=0):void{
	//this.clearParam();
	if(ifuncregedit ==0 ){
		return;
	}
	if(iid1 == 0 && iinvoices1 == 0){
		attachment.listDatas.removeAll();
		attachment.title="表单附件";
		return;
	}
	//业务协同 -- 原来的 iid 表单关联的 协同iid
	//AccessUtil.remoteCallJava("WorkFlowDest","selectFile",fileListCallBack,{"ifunid":11,"iinvoice":iid,"iinvoices":ifuncregedit},null,false);
	AccessUtil.remoteCallJava("WorkFlowDest","selectFile",fileListCallBack,{"ifunid":ifuncregedit,"iinvoice":iid1,"iinvoices":iinvoices1},null,false);
}
private function fileListCallBack(event:ResultEvent):void{
	this.fileItems=event.result as ArrayCollection;
	viewFileItems(fileItems);
}

public function viewFileItems(fileItems:ArrayCollection):void{
	attachment.listDatas.removeAll();
/*	attachment.panelContainer.useHandCursor=true;
	attachment.panelContainer.buttonMode=true;*/
	for each(var item:Object in fileItems){
		var obj:Object={};
		obj.mainLabel=item.cname;
		obj.cdataauth = item.cdataauth;
		obj.cextname = item.cextname;
		obj.cname = item.cname;
		obj.csysname = item.csysname;
		obj.dupload = item.dupload;
		obj.fdata = item.fdata;
		obj.ifuncregedit = item.ifuncregedit;
		obj.iid = item.iid;
		obj.iinvoice = item.iinvoice;
		obj.iinvoices = item.iinvoices;
		obj.iperson = item.iperson;
		obj.pcname = item.pcname;
		obj.size = item.size;
		
		attachment.listDatas.addItem(obj);
		
	}
	
	//兼听从渲染器发出的事件
	this.addEventListener("attachment_see",attachment_see_handler,true);
	this.addEventListener("attachment_download",attachment_download_handler,true);
	this.addEventListener("attachment_del",attachment_del_handler,true);
}

//下载文件
private function attachment_download_handler(evt:MyEvent):void{
	onDownFile(evt.data);
}

//删除文件
private function attachment_del_handler(evt:MyEvent):void{
	deleteFile(evt.data);
}

//查看文件
private function attachment_see_handler(evt:MyEvent):void{
	previewFile(evt.data);
}
//下载文件
private var downFile:FileReference;
public function onDownFile(param:Object):void{
	downFile = new FileReference();
	
	var item:Object = param;
	
	if(item==null || item.iid==null || item.iid==""){
		return;
	}
	
	//var url:URLRequest=new URLRequest("/downfile/")
	var url:URLRequest=new URLRequest("./downfile/")
	var urlparam:URLVariables=new URLVariables();
	urlparam.fileName=item.csysname+"."+item.cextname;
	urlparam.isDelete="1";
	urlparam.type="1";
	urlparam.iid=item.iid;
	url.data=urlparam;
	downFile.addEventListener(IOErrorEvent.IO_ERROR,onFileIoError);
	downFile.addEventListener(Event.COMPLETE,onFileComplete);
	//downFile.addEventListener(ProgressEvent.PROGRESS,onProgress);
	downFile.addEventListener(Event.SELECT,onSelect);
	downFile.download(url,String(item.cname).replace("|",""));
}
private function onSelect(e:Event):void{
	CRMtool.showLoadingView("开始下载文件...");
}
private function onProgress(event:ProgressEvent):void{
	
}
private function onFileIoError(event:IOErrorEvent):void{
	CRMtool.tipAlert("文件不存在!");
	CRMtool.hideLoadingView();
}
private function onFileComplete(event:Event):void{
	CRMtool.hideLoadingView();
	CRMtool.tipAlert("文件下载成功!");
	//this.items.removeItemAt(this.fileList.selectedIndex);
}

public function deleteFile1(param:Object):void{
	var item:Object=param;
	

	
	/* 				if(item==null || item.iid==null || item.iid==""){
	this.items.removeItemAt(fileList.selectedIndex);
	return;
	} */
	var param:Object={};
	param.iid=item.iid;
	param.fileName=item.csysname+"."+item.cextname;
	param.deleteType="1";
	AccessUtil.remoteCallJava("WorkFlowDest","wfDeleteFile",deleteFileCallBack,param,null,false);
}
private function deleteFileCallBack(event:ResultEvent):void{
	if(event.result){
		if((event.result as String)=="suc"){
			CRMtool.tipAlert("删除文件成功!");
			
		}
	}else{
		CRMtool.tipAlert("删除文件失败!");
	}
	getCoFileList(wfiid,curiid);
}
public function deleteFile(param:Object):void{
	
	CRMtool.tipAlert1("确认删除文件?",null,"AFFIRM",function():void{
		deleteFile1(param);
	});
}

//预览文件
public function previewFile(param:Object):void{
	
	var selectItem:Object=param;
	
	if(selectItem==null){
		CRMtool.showAlert("被选择的文件信息错误，请重试");
		return;
	}
	if(selectItem.hasOwnProperty("csysname")==false || selectItem.csysname==null || selectItem.csysname==""){
		CRMtool.showAlert("刚上传的文件不予预览");
		return;
	}
	var ectname:String=String(selectItem.cextname).toLowerCase();
	if(ectname=="png" || ectname=="jpg" || ectname=="bmp"){
		swfViewer(selectItem.csysname+"."+selectItem.cextname,false);
		return;
	}
	var param:Object={};
	param.filename=selectItem.csysname;
	param.extname=selectItem.cextname;
	AccessUtil.remoteCallJava("PreFile","transFileToSwf",previewFileCallBack,param,"预览文件转化中...");
}
private function previewFileCallBack(event:ResultEvent):void{
	if(event.result){
		var ret:Object=event.result;
		if(ret.hasOwnProperty("error")){
			CRMtool.showAlert(""+ret.error);
		}else{
		//	callLater(swfViewer,[ret.suc])
			swfViewer(ret.suc);
		}
	}
}

private function swfViewer(swfpath:String=null,iswf:Boolean=true):void{
	if(swfpath==null || swfpath==""){
		CRMtool.showAlert("预览文件路径不存在");
		return;
	}
	
	var preFile:PreviewFile=new PreviewFile();
	preFile.swfFilePath=swfpath;
	preFile.iswf=iswf;
	CRMtool.openView(preFile);
	preFile.swfViewer();
}
