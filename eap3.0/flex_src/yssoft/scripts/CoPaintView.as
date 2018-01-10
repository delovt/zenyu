import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.geom.Point;

import mx.controls.Alert;
import mx.controls.List;
import mx.controls.Tree;
import mx.core.IUIComponent;
import mx.core.UIComponent;
import mx.events.DragEvent;
import mx.events.FlexEvent;
import mx.events.ItemClickEvent;
import mx.events.ListEvent;
import mx.events.ScrollEvent;
import mx.events.ScrollEventDirection;
import mx.managers.DragManager;
import mx.rpc.events.ResultEvent;

import yssoft.comps.NodeElement;
import yssoft.models.CRMmodel;
import yssoft.models.ConstsModel;
import yssoft.renders.CrmAccordionHeader;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;

/**
 * @author：zmm
 * 日期：2011-8-12
 * 功能 工作流 绘制
 * 修改记录：
 */
[Bindable]
public var winParam:Object=new Object(); // 打开窗口时，传递的 参数

//测试数据

private var roleXml:XML=new XML();

[Bindable]private var curPerXml:XMLList;

[Bindable]
private var treeXml:XML=new XML(); // 树数据
[Bindable]
private var personXml:XML=new XML(); // 人员数据

private var nullXml:XML=new XML(); // 用于清空

// 初始化，部门，等数据
public function initData():void{
	roleXml=CRMmodel.roleXml;
	iNodeType_itemClickHandler();
}
// 按钮组的 点击事件
private function iNodeType_itemClickHandler():void{
	var nodeType:String=this.iNodeType.selection.name;
	// 清空 personXml
	personXml=nullXml;
	//清空提示
	this.ttinfo.text="";
	
	if(nodeType){
		if(nodeType=="2"){ // 角色特殊处理
			treeXml=roleXml;
		}else{
			if(this.iNodeType.selection.hasOwnProperty("data") && this.iNodeType.selection.data is XML){
				treeXml=this.iNodeType.selection.data as XML;
			}else{
				getNodeTypeDetail(nodeType);
			}
		}
	}else{
		CRMtool.tipAlert("请选择部门、岗位、职位、角色其中之一，再操作!");
	}
	
}

// 根据nodetype来获取对应的详细信息
private function getNodeTypeDetail(nodeType:String="1"):void{
	AccessUtil.remoteCallJava("WorkFlowDest","getNodeTypeDetail",nodetTypeCallBack,nodeType,null,false);
}
private function nodetTypeCallBack(event:ResultEvent):void{
	treeXml=new XML(event.result);
	this.iNodeType.selection.data=treeXml;
	
	selfDepartment(this.iNodeType.selection.name,""+CRMmodel.hrperson.idepartment,CRMmodel.hrperson.departcname);
}
// personnList labelfunction
private function personnListLF(item:Object):String{
	if(item.hasOwnProperty("@cmemo") && item.@cmemo ){
		return item.@cmemo;
	}else{
		return item.@cname;
	}
}
// 点击 组织树，获取组织对应的人员数据
private function nodeTypeTreeItemClick(event:ListEvent=null):void{
	var nodeType:String=this.iNodeType.selection.name;
	var nodeValue:String=(nodeTypeTree.selectedItem as XML).@iid;
	var cname:String=(nodeTypeTree.selectedItem as XML).@cname;
	// 显示提示信息
/*	this.ttinfo.text="";
		
	if(nodeType || nodeValue){
		if(nodeType=="2" && nodeValue=="1"){
			personXml=new XML("<root><node iid='"+CRMmodel.userId+"' cname='"+CRMmodel.hrperson.cname+"' /></root>");
		}else{
			var param:Object={"nodeType":nodeType,"nodeValue":nodeValue};
			getPersons(param);
		}
		this.ttinfo.text=(nodeTypeTree.selectedItem as XML).@cname+"("+personXml.children().length()+")";
	}else{
		CRMtool.tipAlert("数据不合法，不予查询");
	}*/
	selfDepartment(nodeType,nodeValue,cname);
}

// 初始化，本部分的人员信息
private function selfDepartment(nodeType:String,nodeValue:String,cname:String):void{
	// 显示提示信息
	this.ttinfo.text="";
	if(nodeType || nodeValue){
		if(nodeType=="2" && nodeValue=="1"){
			personXml=new XML("<root><node iid='"+CRMmodel.userId+"' cname='"+CRMmodel.hrperson.cname+"' /></root>");
			this.ttinfo.text=cname+"("+personXml.children().length()+")";
		}else{
			var param:Object={"nodeType":nodeType,"nodeValue":nodeValue};
			getPersons(param);
		}
	}else{
		CRMtool.tipAlert("数据不合法，不予查询");
	}
}

//获取组织对应的人员数据
private function getPersons(param:Object):void{
	param.iperson = CRMmodel.userId;
	AccessUtil.remoteCallJava("WorkFlowDest","getPersons",personCallBack,param,null,false);
}
private function personCallBack(event:ResultEvent):void{
	if(event.result){
		personXml=new XML(event.result);
		this.ttinfo.text=(nodeTypeTree.selectedItem?(nodeTypeTree.selectedItem as XML).@cname:CRMmodel.hrperson.departcname)+"("+personXml.children().length()+")"
	}
}

// 不显示 左侧 窗体
public function showOrHideLeft(bool:Boolean=false):void{
	this.leftPart1.visible=bool;
	this.leftPart1.includeInLayout=bool;
	//this.leftPart2.visible=bool;
	//this.leftPart2.includeInLayout=bool;
}




