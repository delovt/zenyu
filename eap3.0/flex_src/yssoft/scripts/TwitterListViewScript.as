/**
 * 模块说明：论坛列表
 * 创建人：Huzq
 * 创建日期：2012-03-06
 * 修改人：
 * 修改日期：
 *
 */
import flash.events.Event;
import flash.events.EventDispatcher;
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
import flash.events.MouseEvent;
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
import yssoft.views.twitter.TwitterListView;
import yssoft.views.twitter.TwitterMainView;
import yssoft.views.twitter.TwitterParentView;
import yssoft.vos.TwitterTypeVo;

[Bindable]
public var obj:Object = new Object();

[Bindable]
public var listData:ArrayCollection= new ArrayCollection();

[Bindable]
public var typeList:ArrayCollection= new ArrayCollection();

public function initCombobox(init:Boolean):void
{
	if( init )
	{
		for(var i:int=0;i<typeList.length;i++){
			
			if( typeList[i].ccode == obj.ccode)
			{
				this.twitterType.selectedIndex = i;
			}
		}		
	}
}

protected function ini():void{
	
	
	obj = ( (this.owner as HBox).owner as TwitterParentView) .stateObject;
	
	EventDispatcherFactory.getEventDispatcher().addEventListener(
		TwitterEvent.onListViewRefresh, refresh );
	
	refreshTypeList(true);
}


protected function btn_return_click():void
{
	EventDispatcherFactory.getEventDispatcher().dispatchEvent(new TwitterEvent(TwitterEvent.onListViewReturnClick));
}

public function refresh(event:TwitterEvent):void
{
	refreshTypeList(true);
	
	refreshData();
}

public function refreshTypeList(init:Boolean):void{
	AccessUtil.remoteCallJava("TwitterDest","getAllTwitterTypeList",function (event:ResultEvent):void{
		onRefreshTypeList(event,init)
	} );
}

public function onRefreshTypeList(evt:ResultEvent, init:Boolean):void{
	if( evt.result )
	{
		typeList = evt.result as ArrayCollection;
		initCombobox(init);
		refreshData();
	}
}

protected function tnp_bjobstatus_clickHandler(event:MouseEvent):void
{
	refreshData();
}

protected function twitterType_changeHandler(event:ListEvent):void
{
	obj.ccode = this.twitterType.selectedItem.ccode;
}

private function getTypeQueryCondition():String
{
	var typeQueryCon:String = " ";
	if( this.twitterType.selectedIndex != 0 )
	{
		typeQueryCon = " and t.itype = " +  this.twitterType.selectedItem.ccode + " ";
	}
		
	return typeQueryCon;
}

private function getRadioButtonQueryCondition():String
{
	var radioQueryCon:String = " ";
	
	if( this.allRadio.selected )
	{
		radioQueryCon = " and t.istatus = 1 ";
	}
	if( this.creamRadio.selected )
	{
		radioQueryCon = " and t.bpopclassic = 1  and t.istatus = 1   ";
	}
	if( this.hotRadio.selected )
	{
		radioQueryCon = " and t.itype =  + u.ccode and t.ibrowse > u.ihot  and t.istatus = 1  ";
	}
	if( this.issuedRadio.selected )
	{
		radioQueryCon = " and t.imaker = " + CRMmodel.userId + " and t.istatus = 1 ";
	}
	if( this.notIssuedRadio.selected )
	{
		radioQueryCon = " and t.imaker = " + CRMmodel.userId + " and t.istatus = 0 ";
	}

	return radioQueryCon;
}

private function getTitleQueryCondition():String
{
	var titleQueryCon:String =  ""; 
	
	if( this.tnp_bjobstatus.text != "" )
	{
		titleQueryCon = " and t.cname like '%" + this.tnp_bjobstatus.text + "%' ";
	}
	
	return titleQueryCon;
}

private function getQueryCondition():String
{
	return getTypeQueryCondition() + getRadioButtonQueryCondition() ;
            //+ getTitleQueryCondition();
}

public function refreshData():void
{
	var paramObj:Object = new Object();
	
	var sql:String = "select distinct t.iid, t.cname, t.cdetail, t.itype, (select cname  from OA_twitterclass where   t.itype=ccode ) as typeName ," +
		" ( select count(*) from OA_twitterclasss i where i.itwitterclass = t.itype and i.iperson= " + CRMmodel.userId + " ) as auth, " +
		" t.bpopclassic, t.istatus, t.bhide," +
		" t.imaker,  ( select k.cname from hr_person k where t.imaker = k.iid ) as smaker, " +
		" t.dmaker, t.iread, t.ibrowse, t.iwriteback, t.dwriteback, t.irecommend, " +
		" l.departcname, l.postcname, l.cname iname " +
		" from OA_twitter t, OA_twitterclass u, " +
		" ( select p.iid personiid, d.cname departcname,j1.cname ijob1cname,j2.cname ijob2cname,pt.cname postcname,r.iid roleiid,r.cname rolecname,r.buse rolebuse,p.* from hr_person p " +
		" left join hr_department d on p.idepartment=d.iid " +
		" left join hr_job j1 on p.ijob1 = j1.iid " +
		" left join hr_job j2 on p.ijob2 = j2.iid " +
		" left join hr_post pt on p.ipost = pt.iid " +
		" left join as_roleuser ru on p.iid=ru.iperson " +
		" left join as_role r on ru.irole=r.iid " +
		" where r.buse=1 ) l " +
		" where 1=1 " +  getQueryCondition() +	" and  t.imaker = l.personiid " ;
	
	paramObj.pagesize = 10;
	paramObj.curpage=1;
	paramObj.sqlid="get_persons_sql";
	paramObj.sql=sql;
	paramObj.orderSql=null;
	this.pageBar.initPageHandler(paramObj,function(list:ArrayCollection):void{pageCallBack(list,paramObj.sql)});
}

public function pageCallBack(list:ArrayCollection,sql:String):void{
	var i:int=0;
	for each (var item:Object in list) 
	{
		item.sort_id=i+1;
		i++;
	}
	
	listData = list;
}

protected function btn_issue_click():void
{
	this.twitterType.selectedItem.value=1;
	
	var twitterIssueView:TwitterIssueView = new TwitterIssueView();
	
	CRMtool.openView(twitterIssueView);
}

//窗体初始化
public function onWindowInit():void
{

}
//窗体打开
public function onWindowOpen():void
{

}
//窗体关闭,完成窗体的清理工作
public function onWindowClose():void
{
	
}

public function searchFromMain(s:String):void {
    if (CRMtool.isStringNotNull(s)) {
        s = StringUtil.trim(s);

        while (s.indexOf('  ') > -1) {
            s = s.replace('  ', ' ');
        }
        while (s.indexOf(' ') > -1) {
            s = s.replace(' ', '%');
        }
        var sql:String = "select distinct t.iid, t.cname, t.cdetail, t.itype, (select cname  from OA_twitterclass where   t.itype=ccode ) as typeName ," +
                " ( select count(*) from OA_twitterclasss i where i.itwitterclass = t.itype and i.iperson= " + CRMmodel.userId + " ) as auth, " +
                " t.bpopclassic, t.istatus, t.bhide," +
                " t.imaker,  ( select k.cname from hr_person k where t.imaker = k.iid ) as smaker, " +
                " t.dmaker, t.iread, t.ibrowse, t.iwriteback, t.dwriteback, t.irecommend, " +
                " l.departcname, l.postcname, l.cname iname " +
                " from OA_twitter t, OA_twitterclass u, " +
                " ( select p.iid personiid, d.cname departcname,j1.cname ijob1cname,j2.cname ijob2cname,pt.cname postcname,r.iid roleiid,r.cname rolecname,r.buse rolebuse,p.* from hr_person p " +
                " left join hr_department d on p.idepartment=d.iid " +
                " left join hr_job j1 on p.ijob1 = j1.iid " +
                " left join hr_job j2 on p.ijob2 = j2.iid " +
                " left join hr_post pt on p.ipost = pt.iid " +
                " left join as_roleuser ru on p.iid=ru.iperson " +
                " left join as_role r on ru.irole=r.iid " +
                " where r.buse=1 ) l " +
                " where 1=1 " +  getQueryCondition() +	" and  t.imaker = l.personiid and (t.cname like '%" + s + "%' or t.cdetail like '%" + s + "%')" ;

        AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
            listData = event.result as ArrayCollection;
        }, sql);
    }
    else{
        var sql:String = "select distinct t.iid, t.cname, t.cdetail, t.itype, (select cname  from OA_twitterclass where   t.itype=ccode ) as typeName ," +
                " ( select count(*) from OA_twitterclasss i where i.itwitterclass = t.itype and i.iperson= " + CRMmodel.userId + " ) as auth, " +
                " t.bpopclassic, t.istatus, t.bhide," +
                " t.imaker,  ( select k.cname from hr_person k where t.imaker = k.iid ) as smaker, " +
                " t.dmaker, t.iread, t.ibrowse, t.iwriteback, t.dwriteback, t.irecommend, " +
                " l.departcname, l.postcname, l.cname iname " +
                " from OA_twitter t, OA_twitterclass u, " +
                " ( select p.iid personiid, d.cname departcname,j1.cname ijob1cname,j2.cname ijob2cname,pt.cname postcname,r.iid roleiid,r.cname rolecname,r.buse rolebuse,p.* from hr_person p " +
                " left join hr_department d on p.idepartment=d.iid " +
                " left join hr_job j1 on p.ijob1 = j1.iid " +
                " left join hr_job j2 on p.ijob2 = j2.iid " +
                " left join hr_post pt on p.ipost = pt.iid " +
                " left join as_roleuser ru on p.iid=ru.iperson " +
                " left join as_role r on ru.irole=r.iid " +
                " where r.buse=1 ) l " +
                " where 1=1 " +  getQueryCondition() +	" and  t.imaker = l.personiid " ;

        AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
            listData = event.result as ArrayCollection;
        }, sql);
    }
}
