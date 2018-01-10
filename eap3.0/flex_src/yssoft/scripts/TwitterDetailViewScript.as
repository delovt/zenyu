/**
 * 模块说明：论坛详细页面
 * 创建人：Huzq
 * 创建日期：2012-03-06
 * 修改人：
 * 修改日期：
 *
 */
import flash.display.Bitmap;
import flash.display.Loader;
import flash.events.Event;
import flash.events.MouseEvent;
import flash.utils.ByteArray;
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
import mx.managers.PopUpManager;
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
import yssoft.views.twitter.TwitterDetailReplyView;
import yssoft.views.twitter.TwitterDetailView;
import yssoft.views.twitter.TwitterIssueView;
import yssoft.views.twitter.TwitterMainView;
import yssoft.views.twitter.TwitterParentView;
import yssoft.vos.TwitterReplyVo;
import yssoft.vos.TwitterTypeVo;


[Bindable]
public var obj:Object = new Object();

[Bindable]
var twitterReplyVo:TwitterReplyVo = new TwitterReplyVo();

[Bindable]
public var twitterReplyArr:ArrayCollection = new ArrayCollection();

[Bindable]
public var twitterObj:Object = new Object();

[Bindable]
public static var headerIcon:Object=ConstsModel.wf_inodetype_0;


protected function ini():void{
	
	obj = ( (this.owner as HBox).owner as TwitterParentView) .stateObject;
	
	
	EventDispatcherFactory.getEventDispatcher().addEventListener(
		TwitterEvent.onDetailViewRefresh, refresh);
	
	EventDispatcherFactory.getEventDispatcher().addEventListener(
		TwitterEvent.onDetailViewItemReply, replyByItemClick);
	
	EventDispatcherFactory.getEventDispatcher().addEventListener(
		TwitterEvent.onDetailViewItemQuote, quoteByItemClick);
	
	EventDispatcherFactory.getEventDispatcher().addEventListener(
		TwitterEvent.onDetailViewItemShield, shieldByItemClick);
	
	refreshAllData();
    this.leftMws.visible=true;
    this.leftMws.includeInLayout=true;
    //this.rightMes.width=100%;
    this.rightMes.visible=false;
    this.rightMes.includeInLayout=false;
	
}

public function pageCallBack(list:ArrayCollection,sql:String):void{
	var i:int=0;
	for each (var item:Object in list) 
	{
		item.sort_id=i+1;
		i++;
	}
	
	twitterReplyArr = list;
}

private function onGetTwitterBack( event:ResultEvent ):void
{
	if (event.result!=null)
	{
		twitterObj = event.result as Object;
		loadUserHeaderIcon( int(twitterObj.imaker) );
	}
}

/**
 * 根据用户iid 来获取头像
 */
private function loadUserHeaderIcon(iid:int):void{
	if(iid <=0 ){
		return;
	}
	/* 				if(CRMmodel.userId == iid){
	headerImage.source=CRMmodel.headerIcon;
	return;
	} */
	//headerIcon=ConstsModel.wf_inodetype_0;
	var param:Object={};
	param.fileName=""+iid;
	param.fileType="jpg";
	param.downType="0";
	AccessUtil.remoteCallJava("FileDest","downFile",loadHeaderIconCallBack,param,"图片下载中...",false);
}
private function loadHeaderIconCallBack(event:ResultEvent):void{
	if(event.result){
		try{
			var ba:ByteArray=event.result as ByteArray;
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(event:Event):void{
				var sourceBMP:Bitmap = event.currentTarget.loader.content as Bitmap;
				headerIcon=sourceBMP;
			});
			loader.loadBytes(ba);
		}catch(e:Error){
			Alert.show("---获取头像出错---");
		}
	}
}


protected function returnBack_clickHandler(event:MouseEvent):void
{
	EventDispatcherFactory.getEventDispatcher().dispatchEvent(new TwitterEvent(TwitterEvent.onDetailViewReturnClick) );
}

protected function reply_clickHandler(event:MouseEvent):void
{
	var twitterDetailReplyView:TwitterDetailReplyView = new TwitterDetailReplyView();
	
	CRMtool.openView(twitterDetailReplyView);
	
	twitterDetailReplyView.itwitter = obj.twitterIid;
}

protected function issue_clickHandler(event:MouseEvent):void
{
	var twitterIssueView:TwitterIssueView = new TwitterIssueView();
	
	CRMtool.openView(twitterIssueView);
}


protected function btn_reply_clickHandler(event:MouseEvent):void
{
/*	if( this.cdetail.htmlText == "" )
		return;
	
	twitterReplyVo.itwitter =  obj.twitterIid;
	twitterReplyVo.cdetail  =  this.cdetail.htmlText
	twitterReplyVo.bhide    =  false;
	twitterReplyVo.imaker   =  int( CRMmodel.hrperson.ccode );
	twitterReplyVo.dmaker   =  DateUtil.formateDate();
	
	
	AccessUtil.remoteCallJava("TwitterDest","reply",onReplyBack, twitterReplyVo);*/
}


private function onReplyBack( evt:ResultEvent ):void
{
	if( evt.result.toString()!="failed")
	{
		CRMtool.tipAlert(ConstsModel.TWITTER_REPLY_SUCCESS_INFO);
		/*this.cdetail.htmlText = "";*/
	}
	else
	{
		CRMtool.tipAlert(ConstsModel.TWITTER_REPLY_FAILED_INFO);
	}
}

protected function btn_reset_clickHandler(event:MouseEvent):void
{
/*	this.cdetail.htmlText = "";
	this.cdetail.textArea.setFocus();*/
}


public function refresh(event:TwitterEvent):void
{
//	AccessUtil.remoteCallJava("TwitterDest","getDetailViewOwner",onGetTwitterBack, obj.twitterIid );
//	AccessUtil.remoteCallJava("TwitterDest","get_TwitterReplyList",onGetReplyListBack, obj.twitterIid );
	refreshAllData();
}

protected function refreshData_clickHandler(event:MouseEvent):void
{
//	AccessUtil.remoteCallJava("TwitterDest","getDetailViewOwner",onGetTwitterBack, obj.twitterIid );
//	AccessUtil.remoteCallJava("TwitterDest","get_TwitterReplyList",onGetReplyListBack, obj.twitterIid );
	
	refreshAllData();
}

public function refreshAllData():void
{

	AccessUtil.remoteCallJava("TwitterDest","getDetailViewOwner",onGetTwitterBack, obj.twitterIid );
	//	AccessUtil.remoteCallJava("TwitterDest","get_TwitterReplyList",onGetReplyListBack, obj.twitterIid );

	var sql:String =
		"select distinct t.iid, t.itwitter, t.cdetail, t.bhide, t.imaker, t.dmaker,l.departcname, l.postcname, l.cname iname, " +
		" ( select count(*) from OA_twitterclasss i where i.itwitterclass = " + obj.itype + " and i.iperson= " + CRMmodel.userId + " ) as auth " +
		" from OA_twitters t , " +
		" ( select p.iid personiid, d.cname departcname,j1.cname ijob1cname,j2.cname ijob2cname,pt.cname postcname,r.iid roleiid,r.cname rolecname,r.buse rolebuse,p.* from hr_person p " +
		" left join hr_department d on p.idepartment=d.iid " +
		" left join hr_job j1 on p.ijob1 = j1.iid " +
		" left join hr_job j2 on p.ijob2 = j2.iid " +
		" left join hr_post pt on p.ipost = pt.iid " +
		" left join as_roleuser ru on p.iid=ru.iperson " +
		" left join as_role r on ru.irole=r.iid " +
		" where r.buse=1 ) l " +
		" where itwitter= " + obj.twitterIid  +
		" and  t.imaker = l.personiid " ;

	var paramObj:Object = new Object();
	paramObj.pagesize = 10;
	paramObj.curpage=1;
	paramObj.sqlid="get_persons_sql";
	paramObj.sql=sql;
	paramObj.orderSql=null;
	this.pageBar.initPageHandler(paramObj,function(list:ArrayCollection):void{pageCallBack(list,paramObj.sql)});

	
}


public function replyByItemClick(event:TwitterEvent):void
{
	var twitterDetailReplyView:TwitterDetailReplyView = new TwitterDetailReplyView();
	CRMtool.openView(twitterDetailReplyView);
	
	
	twitterDetailReplyView.cdetail.htmlText = "回复：" + event.obj.imaker + "\n";
	
	twitterDetailReplyView.iid = event.obj.iid;
	twitterDetailReplyView.itwitter = obj.twitterIid;
	
	
}

public function quoteByItemClick(event:TwitterEvent):void
{
	var twitterDetailReplyView:TwitterDetailReplyView = new TwitterDetailReplyView();
	
	CRMtool.openView(twitterDetailReplyView);
	
	twitterDetailReplyView.cdetail.htmlText = "引用：" + event.obj.imaker + "\n" + event.obj.cdetail
		+ "------------------------------------------------------------------------------------------------------------\n";
	twitterDetailReplyView.iid = event.obj.iid;
	twitterDetailReplyView.itwitter = obj.twitterIid;
}

public function shieldByItemClick(event:TwitterEvent):void
{
//	Alert.show("11111111111111111111111111111111111111");
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
private function setMes_clickHandler(event:MouseEvent):void {
    this.leftMws.visible=true;
    this.leftMws.includeInLayout=true;
    //this.rightMes.width=100%;
    this.rightMes.visible=false;
    this.rightMes.includeInLayout=false;
}
private function repMes_clickHandler(event:MouseEvent):void {
    this.leftMws.visible=false;
    this.leftMws.includeInLayout=false;
    //this.leftMes.width="100%";
    this.rightMes.visible=true;
    this.rightMes.includeInLayout=true;
}