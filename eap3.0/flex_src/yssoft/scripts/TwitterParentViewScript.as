/**
 * 模块说明：论坛root
 * 创建人：Huzq
 * 创建日期：2012-03-06
 * 修改人：
 * 修改日期：
 *
 */
import flash.events.Event;
import flash.utils.describeType;
import flash.xml.XMLDocument;
import flash.xml.XMLNode;

import mx.collections.ArrayCollection;
import mx.collections.XMLListCollection;
import mx.controls.Alert;
import mx.controls.TextInput;
import mx.events.ItemClickEvent;
import mx.events.ListEvent;
import mx.events.StateChangeEvent;
import mx.formatters.DateFormatter;
import mx.rpc.events.ResultEvent;
import mx.rpc.xml.SimpleXMLEncoder;
import mx.utils.StringUtil;

import yssoft.evts.EventDispatcherFactory;
import yssoft.evts.TwitterEvent;
import yssoft.frameui.formopt.OperDataAuth;
import yssoft.models.CRMmodel;
import yssoft.models.ConstsModel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.views.twitter.TwitterTypeView;
import yssoft.vos.TwitterVo;

[Bindable]
public var winParam:Object=new Object();

[Bindable]
public var stateObject:Object = new Object();

//权限类对象
public var auth:OperDataAuth;

protected function ini():void{
	//onWindowInit();
	EventDispatcherFactory.getEventDispatcher().addEventListener(
		TwitterEvent.onMainViewRender2ListClick, mainState_onMainViewRender2ListClickHandler);
	EventDispatcherFactory.getEventDispatcher().addEventListener(
		TwitterEvent.onMainViewHotItemClick, mainState_onMainViewHotItem2ListClickHandler);
	EventDispatcherFactory.getEventDispatcher().addEventListener(
		TwitterEvent.onMainViewCreamItemClick, mainState_onMainViewCreamItem2ListClickHandler);
	EventDispatcherFactory.getEventDispatcher().addEventListener(
		TwitterEvent.onListViewItemClick, listState_onListViewItemClickHandler);
	EventDispatcherFactory.getEventDispatcher().addEventListener(
		TwitterEvent.onListViewReturnClick, listState_onListViewReturnClickHandler);
	EventDispatcherFactory.getEventDispatcher().addEventListener(
		TwitterEvent.onDetailViewReturnClick, detailState_onDetailViewReturnClickHandler);
	//加载操作权限 
//	loadauth();
//	AccessUtil.remoteCallJava("TwitterTypeDest","getAllTwitterTypeList",onGetTypeListBack );
}

public function loadauth():void
{
	//---------------加载操作权限 begin---------------//
//	auth=new OperDataAuth(this);
//	var params1:Object=new Object();
//	var itemObj:Object = CRMtool.getObject(winParam);
//	params1.ifuncregedit=itemObj.ifuncregedit;
//	params1.iperson=CRMmodel.hrperson.iid;
//	auth.get_funoperauth(params1);
	//---------------加载操作权限 end---------------//
}



protected function currentStateChangingHandler(event:StateChangeEvent):void
{
}


protected function currentStateChangeHandler(event:StateChangeEvent):void
{
	//use to refresh listView 
	if( this.currentState == "listState" )
	{
		EventDispatcherFactory.getEventDispatcher().dispatchEvent(
			new TwitterEvent(TwitterEvent.onListViewRefresh) );
	}
	
	//use to refresh detailView 
	if( this.currentState == "detailState" )
	{
		EventDispatcherFactory.getEventDispatcher().dispatchEvent(
			new TwitterEvent(TwitterEvent.onDetailViewRefresh) );
	}
	
}

public function mainState_onMainViewHotItem2ListClickHandler(event:TwitterEvent = null):void
{
	if( event.obj.hasOwnProperty("twitterIid") )
	{
		this.stateObject.twitterIid = event.obj.twitterIid;
		this.stateObject.itype = event.obj.itype;
	}
	
	this.currentState="detailState";
}

public function mainState_onMainViewCreamItem2ListClickHandler(event:TwitterEvent = null):void
{
	if( event.obj.hasOwnProperty("twitterIid") )
	{
		this.stateObject.twitterIid = event.obj.twitterIid;
		this.stateObject.itype = event.obj.itype;
	}
	
	this.currentState="detailState";
}


public function mainState_onMainViewRender2ListClickHandler(event:TwitterEvent = null):void
{
	//点击类型标题
	if( event.obj.hasOwnProperty("ccode") )
	{
		this.stateObject.ccode = event.obj.ccode;
	}

	this.currentState="listState";
}

protected function listState_onListViewItemClickHandler(event:TwitterEvent = null):void
{
	//点列表标题
	if( event.obj.hasOwnProperty("twitterIid") )
	{
		this.stateObject.twitterIid = event.obj.twitterIid;
		this.stateObject.itype = event.obj.itype;
		
		AccessUtil.remoteCallJava("TwitterDest","addUpReadTwitter",null, this.stateObject.twitterIid);
	}

	this.currentState="detailState";
}

protected function listState_onListViewReturnClickHandler(event:TwitterEvent = null):void
{
	this.currentState="mainState";
}

protected function detailState_onDetailViewReturnClickHandler(event:TwitterEvent = null):void
{
	this.currentState="listState";
}

protected function detailState_onListViewItemClickHandler(event:TwitterEvent = null):void
{
	this.currentState="detailState";
}

//窗体初始化
public function onWindowInit():void
{
}
//窗体打开
public function onWindowOpen():void
{
	//加载操作权限 
//	loadauth();
	//this.currentState="mainState"
	//	ini();
	//	onGiveUp();
	//	this.ifuncregedit.te = "";
	//	CRMtool.toolButtonsEnabled(this.btn_menubar,"onGiveUp");
	
}
//窗体关闭,完成窗体的清理工作
public function onWindowClose():void
{
	this.currentState="mainState"
}
public function searchFromMain(s:String):void {
    if(s=="")
    s=" ";
    this.listState.searchFromMain(s);
}

