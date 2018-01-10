/**
 * 模块说明：论坛类型管理
 * 创建人：Huzq
 * 创建日期：2012-02-24
 * 修改人：
 * 修改日期：
 *
 */
import flash.utils.describeType;
import flash.xml.XMLDocument;
import flash.xml.XMLNode;

import mx.collections.ArrayCollection;
import mx.collections.XMLListCollection;
import mx.controls.Alert;
import mx.controls.TextInput;
import mx.events.ItemClickEvent;
import mx.events.ListEvent;
import mx.formatters.DateFormatter;
import mx.rpc.events.ResultEvent;
import mx.rpc.xml.SimpleXMLEncoder;
import mx.utils.StringUtil;

import yssoft.evts.EventDispatcherFactory;
import yssoft.evts.TwitterEvent;
import yssoft.models.CRMmodel;
import yssoft.models.ConstsModel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.tools.DateUtil;
import yssoft.views.twitter.PersonMultiSelectingView;
import yssoft.views.twitter.TwitterTypeView;
import yssoft.vos.TwitterTypeVo;

public var iid:int;
[Bindable]protected var arr_types:ArrayCollection = new ArrayCollection();
[Bindable]protected var instanceInfo:XML=null;
[Bindable]protected var properties:XMLList=null;
[Bindable]public var operType:String;
[Bindable]protected var treeCompsXml:XML;
[Bindable]protected var twitterTypeVo:TwitterTypeVo = new TwitterTypeVo();

protected var dateFormatter:DateFormatter = new DateFormatter();
private var dateFormatterString:String = "YYYY-MM-DD JJ:NN:SS";

[Bindable]
protected var arr_menubar:ArrayCollection = new ArrayCollection(
	[{label:"增加",name:"onNew"},
		{label:"修改",name:"onEdit"},
		{label:"删除",name:"onDelete"},
		{label:"保存",name:"onSave"},
		{label:"放弃",name:"onGiveUp"}]
);

protected function ini():void{
	
	EventDispatcherFactory.getEventDispatcher().addEventListener( TwitterEvent.onTypeViewPersonSelected, onTypeViewPersonSelectedBack );
	
	AccessUtil.remoteCallJava("TwitterTypeDest","getAllTwitterTypeList",onGetTypeListBack );
}

private function onTypeViewPersonSelectedBack(evt:TwitterEvent):void{
	if( evt.obj )
	{
		this.iperson.text = evt.obj.name;
		this.iperson.iData = evt.obj.code;
	}
}

private function onGetTypeListBack(evt:ResultEvent):void{
	
	//菜单赋值 
	if(evt.result.treexml != null)
		this.tree.treeCompsXml = new XML(evt.result.treexml as String);
	
	
	//统一设置页面是否可以编辑
	CRMtool.containerChildsEnabled(this.container,false);
	
	//获取页面元素
	instanceInfo = describeType(this);
	
	//回车替代TAB键
	CRMtool.setTabIndex(this.container);
	
	//获取页面中所有TextInput元素的集合
	properties = instanceInfo..accessor.(@type=="mx.controls::TextInput");//不灵活，考虑单一
	
}



public function btn_menubar_itemClickHandler(event:ItemClickEvent):void
{
	var enabled:Boolean;
	var node:Object=this.tree.selectedItem;
	
	switch(event.item.name)
	{
		case "onNew":
			enabled = true;
			operType=event.item.name;
			onNew();
			break;
		case "onEdit":		{
			if(!onEdit())return;
			
			if (node==null)
			{
				CRMtool.showAlert(ConstsModel.MENU_CHOOSE);
				return;
			}
			else
			{				
				enabled=true;operType=event.item.name;
				/*onClearAll(operType,0);*/
				break;
			}
		}
		case "onDelete":{
			operType=event.item.name;
			if (node==null)
			{
				CRMtool.showAlert(ConstsModel.MENU_CHOOSE);
				return;
			}
			else
			{
				var ccode:String = String(node.@ccode);
				if(this.tree.isExistsChild(ccode,ConstsModel.MENU_ROMEVE_PID))
				{
					return;
				}
				removeTreeXml(this.tree.selectedItem,operType);
			}
			break;
		}
		case "onSave":
			enabled=false;
			if (onBeforeSave())
			{
				onSave();
			}
			else
			{
				return;
			}
			break;			
		case "onGiveUp":	{enabled=false;operType=event.item.name;onGiveUp();break;}
		default:
			break;
	}
	
	//调用按钮互斥
	CRMtool.toolButtonsEnabled(this.btn_menubar,event.item.name)
	//调用统一设置BorderContainer容器内控件enabled属性
	CRMtool.containerChildsEnabled(this.container,enabled);
}

protected function tree_itemClickHandler(event:ListEvent):void
{
	setValue();
	setTwitterTypeVo();
}

private function onNew():void{	
	onClearAll(this.operType,0);
	this.iperson.text = "";
	this.imaker.text = CRMmodel.hrperson.cname;
	this.dmaker.text = DateUtil.formateDate(new Date());
}

private function onClearAll(operType:String,flag:int):void{
	//清除控件值
	if(operType != "onEdit"){
		for each(var propertyInfo:XML in properties){
			var propertyName:String =propertyInfo.@name;
			TextInput(this[propertyName]).text="";
		}
	}
	
	
	if(operType == "onNew" || operType == "onEdit")this.ccode.setFocus();
	
}

private function onEdit():Boolean{
	if(this.tree.selectedItem == null){CRMtool.showAlert(ConstsModel.MENU_CHOOSE); return false;}
	return true;
}

private function onGiveUp():void{	
	
	onClearAll(operType,1);
	setValue();
	
}

private function onBeforeSave():Boolean{
	var t_arr:ArrayCollection = new ArrayCollection();
	
	//新增时检查编码是否重复
	if(operType=="onNew")
	{
		if(this.tree.isExistsCcode(this.ccode.text,ConstsModel.MENU_CCODE_WARNMSG))
		{
			return false;
		}
	}
	//编辑时校验
	if(operType=="onEdit")
	{
		if(!this.tree.selectedItem)
		{
			CRMtool.tipAlert(ConstsModel.MENU_CHOOSE);
			return false;
		}
		if(this.tree.selectedItem.@ccode!=this.ccode.text){
			if(this.tree.isExistsCcode(this.ccode.text,ConstsModel.MENU_CCODE_WARNMSG))
			{
				return false;
			}
		}
	}
	
	if(!this.tree.isExistsParent(this.ccode.text,ConstsModel.MENU_PID_WARNMSG))
	{
		return false;
	}
	
	setTwitterTypeVo();
	
	return true;
}

private function onSave():void{
	switch(operType)
	{			
		case "onNew":{	AccessUtil.remoteCallJava("TwitterTypeDest","addTwitterType",onFuncrededitBack,twitterTypeVo);break;}
		case "onEdit":{AccessUtil.remoteCallJava("TwitterTypeDest","updateTwitterType",onFuncrededitBack,twitterTypeVo);break;}
		default:break;
	}
}

private function onFuncrededitBack(evt:ResultEvent):void{
	
	if( evt.result.toString()!="failed")
	{
		var result:String = evt.result as String;
		
		if(this.operType =="onNew")
		{
			twitterTypeVo.iid=int(Number(result));
			CRMtool.tipAlert(ConstsModel.MENU_ADD_SUCCESS);
		}
		else if(this.operType=="onDelete")
		{
			CRMtool.tipAlert(ConstsModel.MENU_REMOVE);
		}
		else if(this.operType=="onEdit")
		{
			update_initdata();
			CRMtool.tipAlert(ConstsModel.MENU_UPDATE_SUCCESS);
		}
		
		this.updateTreeItem();
		onAfterSave();
	}
	else
	{
		CRMtool.tipAlert(ConstsModel.MENU_FAIL);
	}
}

public function updateTreeItem():void
{
	switch(operType)
	{
		case "onNew":
			this.tree.AddTreeNode(twitterTypeVo);
			break;
		case "onEdit":
			var curxml:XML = this.tree.selectedItem as XML;
			this.tree.EditTreeNode(twitterTypeVo);			
			setValue();
			break;
		case "onDelete":
			this.tree.DeleteTreeNode();
			break;
		default:
			break;
	}
}

public function update_initdata():void
{
	
}

private function onAfterSave():void{
	
	//清除样式
	onClearAll(operType,1);
}

public function removeTreeXml(node:Object,operType:String):void
{
	iid =int(Number(node.@iid));
	CRMtool.tipAlert(ConstsModel.MENU_DETERMINE_HEAD+node.@ccname+ConstsModel.TWITTER_DETERMINE_TAIL,null,"AFFIRM",this,"onDeleteTree");
}

public function onDeleteTree():void
{
	AccessUtil.remoteCallJava("TwitterTypeDest","deleteTwitterType",onFuncrededitBack,iid,ConstsModel.MENU_REMOVE_INFO);
}

public function setValue():void{
	if( this.tree.selectedItem != null)
	{
		this.ccode.text		=	this.tree.selectedItem.@ccode;
		this.cname.text		=	this.tree.selectedItem.@cname;
		this.ihot.text	    =	String( this.tree.selectedItem.@ihot );
		this.iperson.text 	= 	this.tree.selectedItem.@personName;
		this.cmemo.text 	= 	this.tree.selectedItem.@cmemo;
		//this.imaker.text 	= 	this.tree.selectedItem.@smaker;
		this.dmaker.text 	= 	this.tree.selectedItem.@dmaker;
		var sqlStr:String = "select hp.cname imaker  from oa_twitterclass ot left join hr_person hp on hp.iid = ot.imaker " +
			"where ot.iid = " + this.tree.selectedItem.@iid;
		AccessUtil.remoteCallJava("CommonalityDest","assemblyQuerySql",function(event:ResultEvent):void {
			var eventAC:ArrayCollection =event.result as ArrayCollection;
			if(eventAC.length>0) {
				imaker.text  = eventAC[0].imaker;	
			}
		},sqlStr);
	}
}


public function setTwitterTypeVo():void{

	if(this.operType=="onEdit")
	{
		twitterTypeVo.iid =  this.tree.selectedItem.@iid;
	}
	twitterTypeVo.ipid = this.tree.getIpid(this.ccode.text);
	twitterTypeVo.ccode = this.ccode.text;
	twitterTypeVo.cname = this.cname.text;
	twitterTypeVo.ihot = int(this.ihot.text);
	twitterTypeVo.person = String(this.iperson.iData);
	twitterTypeVo.personName = this.iperson.text;
	twitterTypeVo.cmemo = this.cmemo.text;
	if(this.operType=="onNew")
	{
		twitterTypeVo.imaker = CRMmodel.userId;
		twitterTypeVo.dmaker = this.dmaker.text;
	}
}

protected function iperson_searchHandler():void
{
	var personMultiSelectingView:PersonMultiSelectingView = new PersonMultiSelectingView();
	
	CRMtool.openView(personMultiSelectingView);
	
}


//窗体初始化
public function onWindowInit():void
{
	
}
//窗体打开
public function onWindowOpen():void
{
//	ini();
//	onGiveUp();
//	this.ifuncregedit.te = "";
//	CRMtool.toolButtonsEnabled(this.btn_menubar,"onGiveUp");
	
}
//窗体关闭,完成窗体的清理工作
public function onWindowClose():void
{
	
}

