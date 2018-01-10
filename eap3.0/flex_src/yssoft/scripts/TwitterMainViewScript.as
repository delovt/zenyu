/**
 * 模块说明：论坛类型管理
 * 创建人：Huzq
 * 创建日期：2012-02-24
 * 修改人：
 * 修改日期：
 *
 */
import flash.events.TimerEvent;
import flash.utils.Timer;
import flash.utils.describeType;
import flash.xml.XMLDocument;
import flash.xml.XMLNode;

import mx.collections.ArrayCollection;
import mx.collections.XMLListCollection;
import mx.containers.HBox;
import mx.controls.Alert;
import mx.controls.TextInput;
import mx.events.ItemClickEvent;
import mx.events.ListEvent;
import mx.rpc.events.ResultEvent;
import mx.rpc.xml.SimpleXMLEncoder;
import mx.utils.StringUtil;

import yssoft.evts.EventDispatcherFactory;
import yssoft.evts.TwitterEvent;
import yssoft.models.CRMmodel;
import yssoft.models.ConstsModel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.views.twitter.TwitterIssueView;
import yssoft.views.twitter.TwitterMainView;
import yssoft.views.twitter.TwitterParentView;
import yssoft.vos.TwitterTypeVo;

public var iid:int;
[Bindable]protected var arr_types:ArrayCollection = new ArrayCollection();
[Bindable]protected var arr_hot:ArrayCollection = new ArrayCollection();
[Bindable]protected var arr_cream:ArrayCollection = new ArrayCollection();
[Bindable]protected var instanceInfo:XML=null;
[Bindable]protected var properties:XMLList=null;
[Bindable]public var operType:String;
[Bindable]protected var treeCompsXml:XML;
[Bindable]protected var twitterTypeVo:TwitterTypeVo = new TwitterTypeVo();

[Bindable]
public var obj:Object = new Object();

[Bindable]
public var statObj:Object = new Object();

[Bindable]
protected var arr_menubar:ArrayCollection = new ArrayCollection(
	[{label:"增加",name:"onNew"},
		{label:"修改",name:"onEdit"},
		{label:"删除",name:"onDelete"},
		{label:"保存",name:"onSave"},
		{label:"放弃",name:"onGiveUp"}]
);

protected function ini():void{
	obj = ( (this.owner as HBox).owner as TwitterParentView) .stateObject;
	
	EventDispatcherFactory.getEventDispatcher().addEventListener(
		TwitterEvent.onMainViewRender2ListClick, onMainViewRender2ListClick);

    refresh();

	EventDispatcherFactory.getEventDispatcher().addEventListener(
		TwitterEvent.onMainViewRefresh, refreshData);	
	var time:Timer = new Timer(6000);
	time.start();
	time.addEventListener(TimerEvent.TIMER,function():void{
		refresh();
	});
	
	
}

public function refreshData( evt:TwitterEvent ):void{
	refresh();
}

public function refresh():void{
	AccessUtil.remoteCallJava("TwitterDest","getStatForMainView",onGetStatForMainViewBack, int(CRMmodel.userId),null,false );
	AccessUtil.remoteCallJava("TwitterDest","getAllTwitterList",onGetTypeListBack,null ,null,false );
	AccessUtil.remoteCallJava("TwitterDest","getHotList",onGetHotListBack,null ,null,false );
	AccessUtil.remoteCallJava("TwitterDest","geCreamList",onGetCreamListBack,null,null,false  );
}

private function onGetStatForMainViewBack(evt:ResultEvent):void{
	if( evt.result!= null )
	{
		statObj = evt.result as Object;
	}
}


private function onGetHotListBack(evt:ResultEvent):void{
	if( evt.result!= null )
	{
		arr_hot = evt.result as ArrayCollection;
	}
}


private function onGetCreamListBack(evt:ResultEvent):void{
	if( evt.result!= null )
	{
		arr_cream = evt.result as ArrayCollection;
	}
}


private function onMainViewRender2ListClick(evt:TwitterEvent):void{
	
}

private function onGetTypeListBack(evt:ResultEvent):void{
	if( evt.result!= null )
	{
		arr_types = evt.result as ArrayCollection;
	}
	else
	{
		
	}
}



public function btn_menubar_itemClickHandler(event:ItemClickEvent):void
{
	
}

protected function tree_itemClickHandler(event:ListEvent):void
{
	
}

protected function btn_issue_click():void
{
	//--------------权限控制 刘磊 begin--------------//
//	var warning:String=(this.owner as HBox).owner["auth"].reuturnwarning("02");
//	if (warning!=null){	CRMtool.showAlert(warning);return;}
	//--------------权限控制 刘磊 end--------------//
	var twitterIssueView:TwitterIssueView = new TwitterIssueView();
	
	CRMtool.openView(twitterIssueView);
}


protected function btn_refresh_click():void
{
	refresh();
}



//窗体初始化
public function onWindowInit():void
{
}
//窗体打开
public function onWindowOpen():void
{
//	refresh();
	//	ini();
	//	onGiveUp();
	//	this.ifuncregedit.te = "";
	//	CRMtool.toolButtonsEnabled(this.btn_menubar,"onGiveUp");
	
}
//窗体关闭,完成窗体的清理工作
public function onWindowClose():void
{
	Alert.show("----close---------");
}

