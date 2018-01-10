// ActionScript file
import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.rpc.events.ResultEvent;

import yssoft.models.CRMmodel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
[Bindable]
public var ifuncregedit:int=0;
[Bindable]
public var iinvoice:int=0;
[Bindable]
private var items:ArrayCollection=new ArrayCollection();

private var optType:String="";

public function ywzs_selete_items():void{
	this.clearParam();
	//CRMtool.tipAlert("表单信息ifuncregedit["+ifuncregedit+"],iinvoice["+iinvoice+"]");
	if(ifuncregedit<=0 || iinvoice <=0){
		//CRMtool.tipAlert("表单信息不全[业务注释]");
		return;
	}
	optType="selete";
	param={};
	param.ifuncregedit=ifuncregedit;
	param.iinvoice=iinvoice;
	AccessUtil.remoteCallJava("WorkFlowDest","ywzs_selete_items",callBack,param,"正在获取业务注释...");
}

public function ywzs_delete_item(imaker:int,iid:int=-1):void{
	optType="delete";
	param = {};
	param.iid = iid;
	selindex=iid;
	param.imaker = imaker;
	if(iid!=-1 && imaker==CRMmodel.userId){
		AccessUtil.remoteCallJava("WorkFlowDest","ywzs_delete_item",callBack,param,"正在删除业务注释...");
	}
}
private var param:Object;
private function ywzs_insert_item():void{
	if(ifuncregedit<=0 || iinvoice <=0){
		CRMtool.tipAlert("表单信息不全，不予提交");
		return;
	}
	
	if( ! CRMtool.isStringNotNull(this.cmemo.text)){
		CRMtool.tipAlert("内容不能为空",this.cmemo);
		return;
	}
	optType="insert";
	param={};
	param.ifuncregedit=ifuncregedit;
	param.iinvoice=iinvoice;
	param.cmemo=this.cmemo.text;
	param.imaker=CRMmodel.userId;
	AccessUtil.remoteCallJava("WorkFlowDest","ywzs_insert_item",callBack,param,"正在添加业务注释...");
}
private var selindex:int=-1;
//private function ywzs_delete_item(event:Event):void{
//	optType="delete";
//	var index:int=int(event.currentTarget.name);
//	var item:Object=items.getItemAt(index);
//	if(item && item.imaker == CRMmodel.userId){
//		//param={};
//		//param.iid=item.iid;
//		//param.imaker=item.imaker;
//		selindex=index;
//		//Alert.show("index["+index+"]");
//		AccessUtil.remoteCallJava("WorkFlowDest","ywzs_delete_item",callBack,item,"正在删除业务注释...");
//	}
//	
//}

private function callBack(event:ResultEvent):void{
	if(optType=="selete"){
		items=event.result as ArrayCollection;
		
	}else if(optType=="delete"){
		if(selindex != -1)
			ywzs_selete_items();
	}else if(optType=="insert"){
		param.iid=event.result;
		param.cname=CRMmodel.hrperson.cname;
		param.dmaker=CRMtool.getFormatDateString();
		items.addItemAt(param,0);
		this.cmemo.text="";
		
	}
	viewItems();
}
public function clearParam():void{
	items=new ArrayCollection();
	//SZC  解决选择几个是卡片一起浏览处理工作流，当处理完第一个，后面几个的文本框不显示的问题
	cmessage.visible=true;
	hide.visible=true;
	cmessage.includeInLayout=true;
	//end
	
}