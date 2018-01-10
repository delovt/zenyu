import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.rpc.events.ResultEvent;

import spark.components.Label;

import yssoft.comps.ConsultList;
import yssoft.comps.TreeCompsVbox;
import yssoft.frameui.side.LabelButton;
import yssoft.models.CRMmodel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;

private var bttype:String="";


private var labelButtonBasicColor:String  = "black";
private var labelButtonSelectedColor:String  = "#32a7e1";
private var labelButtonMultiSelectedAble:Boolean = false;

[Bindable]
private var labelButtonsList:ArrayCollection = new ArrayCollection();
[Bindable]
private var labelButtonsList1:ArrayCollection = new ArrayCollection();
private var ryOptType:String="";
private var ryParam:Object;
[Bindable]
private var XGRYData:Object = new Object();
[Bindable]
private var XGRYData1:Object = new Object();

private var XGRYforDel:ArrayCollection = new ArrayCollection();//将需要删除的人员信息放到这里
public function XGRYinit():void{
	XGRYclearParam();
	xgrySelectItems();
}
public function xgrySelectItems():void{
	XGRYforDel.removeAll();
	if(ifuniid<=0 || curiid <=0){
		//CRMtool.tipAlert("表单信息不全[相关人员]");
		return;
	}
	ryOptType="selete";
	ryParam={};
	ryParam.ifuncregedit=ifuniid;
	ryParam.iinvoice=curiid;
	AccessUtil.remoteCallJava("WorkFlowDest","XGRYSelectItems",XGRYcallBack,ryParam,"正在获取相关人员...");
}

public function XGRYclearParam():void{

	relatePer.listDatas.removeAll();


}
private function XGRYcallBack(event:ResultEvent):void{
	var XGRYList:ArrayCollection = event.result as ArrayCollection;

	if(ryOptType=="selete" && XGRYList!=null){
		labelButtonsList.removeAll();
		labelButtonsList1.removeAll();
		for (var j:int = 0; j < XGRYList.length; j++)
		{
			var label:String = XGRYList[j].pcname;
			var irole:int = XGRYList[j].irole;
			var obj:Object = new Object();
			obj.label=label;
			obj.buttonEventListener = XGClick;
			obj.iperson = XGRYList[j].iperson;
			obj.bselected = false;
			obj.irole = XGRYList[j].irole;
			if(irole==1){
				labelButtonsList.addItem(obj);
			}else if(irole==2){
				labelButtonsList1.addItem(obj);
			}

		}
		XGRYAllData.removeAll();
		XGRYAllData.addAll(labelButtonsList);
		XGRYAllData.addAll(labelButtonsList1);
		//XGRYData.labelButtonsList = labelButtonsList;
		//XGRYData.mainLabel = "负责人员：";
		relatePer.listDatas.removeAll();
		XGRYData.labelButtonsList = labelButtonsList;
		var paramArr:ArrayCollection = new ArrayCollection();
		for(var i:int=0;i<labelButtonsList.length;i++){
			paramArr.addItem(labelButtonsList[i]);
			if(((i+1)%3)==0|| i==labelButtonsList.length-1){
				relatePer.listDatas.addItem({mainLabel:"负责人员：",labelButtonsList:paramArr});
				paramArr = new ArrayCollection();
			}
		}

		paramArr.removeAll();
		for(var i:int=0;i<labelButtonsList1.length;i++){
			paramArr.addItem(labelButtonsList1[i]);

			if(((i+1)%3)==0|| i==labelButtonsList1.length-1){
				relatePer.listDatas.addItem({mainLabel:"相关人员：",labelButtonsList:paramArr});
				paramArr = new ArrayCollection();
			}

		}


		//XGRYData1.labelButtonsList = labelButtonsList1;
		//XGRYData1.mainLabel = "相关人员：";
		//relatePer.listDatas.addItem(XGRYData1);
	}else if(ryOptType=="delete" ){
		if((event.result as String)=="suc"){
			CRMtool.tipAlert("删除人员，成功");
			xgrySelectItems();
		}else{
			CRMtool.tipAlert(event.result as String);
		}
	}

}
private function XGClick(event:MouseEvent):void{
	var label:LabelButton = event.currentTarget as LabelButton;
	var item:Object = label.paramData;
	if(item.bselected){
		item.bselected = false;
		label.setStyle("color",labelButtonBasicColor);
		var i:int=0;
		for each(var obj:Object in XGRYforDel){
			if(obj.iperson==item.iperson){
				XGRYforDel.removeItemAt(i);
				return;
			}
			i++;
		}
	}else{
		item.bselected = true;
		label.setStyle("color",labelButtonSelectedColor);
		XGRYforDel.addItem(item);
	}


}
//private function setLabelButtonsListOtherSelected(label:LabelButton):void{
//	for each(var labelitem:LabelButton in labelButtonsList){
//		if(labelitem==label){
//			
//		}else{
//			labelitem.paramData.bselected = false;
//			labelitem.setStyle("color",labelButtonBasicColor);
//		}
//	}
//}
//private function lbfun(item:Object):String{
//	return item.@pcname
//}

private function addFZXGR(type:String):void{
	if(checkIsFzr() == false){
		CRMtool.tipAlert("非负责人员，不能添加");
		return;
	}
	if(ifuncregedit<=0 || iinvoice <=0){
		CRMtool.tipAlert("表单信息不全[相关人员]");
		return;
	}
	bttype=type;
	new ConsultList(addXGRYCallBack,11,false);
}

// 判断当前登录人，是不是，负责人
private function checkIsFzr():Boolean{
	var curId:int=CRMmodel.userId;
	var list:ArrayCollection = XGRYData.labelButtonsList;
	if(list==null || list.length==0){
        if(CRMmodel.userId==1)
            return true;
        else
            return false;
    }
	for(var i:int=0;i<list.length;i++){
		if(list[i].iperson==curId){
			return true;
		}
	}
	return false;
}

public function addXGRYCallBack(list:ArrayCollection):void{
	if(list && list.length==1){
		var item:Object=list.getItemAt(0);
		if(bttype=="fz"){
			xgryInsertItem(item.iid,item.cname,item.idepartment,item.dcname,"1");
		}else if(bttype=="xg"){
			xgryInsertItem(item.iid,item.cname,item.idepartment,item.dcname,"2");
		}
	}

}

private function xgryInsertItem(iperson:String,pcname:String,idepartment:String,dcname:String,irole:String):void{
	ryOptType="insert";
	param={};
	param.ifuncregedit=ifuniid;
	param.iinvoice=curiid;
	param.irole=irole;
	param.iperson=iperson;
	param.idepartment="";
	param.pcname=pcname;
	param.idepartment=idepartment;
	param.dcname=dcname;
	AccessUtil.remoteCallJava("WorkFlowDest","xgryInsertItem",insertXGRYCallBack,param,"正在添加相关人员...");
}
private function insertXGRYCallBack(evt:ResultEvent):void{
	XGRYinit();
}

private function XGRYdeleteItem():void{
	if(checkIsFzr() == false){
		CRMtool.tipAlert("非负责人员，不能删除！！");
		return;
	}
	if(XGRYforDel.length<=0){
		CRMtool.tipAlert("请点击选中需要移除的人员(可多选)，再进行操作！！");
		return;
	}
	CRMtool.tipAlert1("确认删除？",null,"AFFIRM",xgryDeleteItem1);
}

private function xgryDeleteItem1():void{
	ryOptType="delete";
	var param:ArrayCollection = new ArrayCollection();
	for each(var obj:Object in XGRYforDel){
		var paramInner:Object = {};
		paramInner.ifuncregedit=ifuniid;
		paramInner.iinvoice=curiid;
		paramInner.irole = obj.irole;
		paramInner.iperson = obj.iperson;
		param.addItem(paramInner);
	}
	AccessUtil.remoteCallJava("WorkFlowDest","xgryDeleteItem1",XGRYcallBack,param,"正在删除相关人员...");
	XGRYforDel.removeAll();
}