/**
 * 模块说明：论坛发帖
 * 创建人：Huzq
 * 创建日期：2012-03-05
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
import mx.events.CloseEvent;
import mx.events.ItemClickEvent;
import mx.events.ListEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.rpc.xml.SimpleXMLEncoder;
import mx.utils.StringUtil;

import yssoft.models.CRMmodel;
import yssoft.models.ConstsModel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.tools.DateUtil;
import yssoft.views.twitter.TwitterIssueView;
import yssoft.vos.TwitterVo;


[Bindable]protected var twitterVo:TwitterVo = new TwitterVo();

[Bindable]
public var typeList:ArrayCollection= new ArrayCollection();


protected function initializeHandler():void
{
	refreshTypeList();
}

public function refreshTypeList():void{
	AccessUtil.remoteCallJava("TwitterDest","getTwitterTypeList",onRefreshTypeList);
}

public function onRefreshTypeList(evt:ResultEvent):void{
	if( evt.result )
	{
		typeList = evt.result as ArrayCollection;
	}
}

protected function crmwindow1_myCloseHandler(event:Event):void
{
	PopUpManager.removePopUp(this);
}


protected function btn_quit_clickHandler(event:Event):void
{
	PopUpManager.removePopUp(this);
}

protected function btn_save_clickHandler(event:Event):void
{
	if( !checkValue() )
		return;
	
	setTwitterTypeVo(true);
	twitterVo.type="暂存";
	twitterVo.userId = CRMmodel.userId;
	AccessUtil.remoteCallJava("TwitterDest","addTwitter",onTwitterSaveBack,twitterVo);
}

private function onTwitterSaveBack(evt:ResultEvent):void{
	
	if( evt.result.toString()!="failed")
	{
		PopUpManager.removePopUp(this);
		CRMtool.tipAlert(ConstsModel.TWITTER_SAVE_SUCCESS_INFO);
	}
	else
	{
		CRMtool.tipAlert(ConstsModel.TWITTER_SAVE_FAILED_INFO);
	}
}

protected function btn_issue_clickHandler(event:Event):void
{
	if( !checkValue() )
		return;
	
	setTwitterTypeVo(false);
	twitterVo.type="发布";
	twitterVo.userId = CRMmodel.userId;
	AccessUtil.remoteCallJava("TwitterDest","addTwitter",onTwitterIssueBack,twitterVo);
}

private function onTwitterIssueBack(evt:ResultEvent):void{
	
	if( evt.result.toString()!="failed")
	{
		PopUpManager.removePopUp(this);
		CRMtool.tipAlert(ConstsModel.TWITTER_ADD_SUCCESS_INFO);
	}
	else
	{
		CRMtool.tipAlert(ConstsModel.TWITTER_ADD_FAILED_INFO);
	}
}

private function checkValue():Boolean
{
	if( this.cname.text == "" )
	{
		CRMtool.tipAlert("请输入主题！");
		return false;
	}
	
	if( this.itype.text == "" )
	{
		CRMtool.tipAlert("请选择类型！");
		return false;
	}
	
	if( this.cdetail.htmlText == "" )
	{
		CRMtool.tipAlert("请输入详细内容！");
		return false;
	}
	
	return true;
}

public function setTwitterTypeVo(issue:Boolean):void{

	twitterVo.cname = this.cname.text;
	twitterVo.cdetail = this.cdetail.htmlText;
	twitterVo.itype = int( this.itype.selectedItem.ccode );
	twitterVo.bpopclassic = false;
	twitterVo.istatus = issue?0:1;
	twitterVo.bhide = false;
	twitterVo.imaker = int( CRMmodel.userId );
	twitterVo.dmaker = DateUtil.formateDate();
	twitterVo.iread = 0;
	twitterVo.ibrowse = 0;
	twitterVo.iwriteback = -1;
	twitterVo.dwriteback = null;
	twitterVo.irecommend = -1;

}