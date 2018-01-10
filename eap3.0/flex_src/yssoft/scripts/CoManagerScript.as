/**
 * @author：zmm
 * 日期：2011-8-24
 * 功能 协同管理
 * 修改记录：
 */

import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.containers.TitleWindow;
import mx.controls.Alert;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.events.ItemClickEvent;
import mx.events.ListEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;

import spark.primitives.Rect;

import yssoft.comps.PageBar;
import yssoft.models.CRMmodel;
import yssoft.models.ConstsModel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.views.sysmanage.AssemblyQueryclmView;
import yssoft.views.workflow.CoPaintView;
import yssoft.views.workflow.PaintView;

[Bindable]
private var _workFlowDatas:ArrayCollection=new ArrayCollection();

//操作类型
private var optType:String="dbsx";
[Bindable]
private var optName:String="待办事项";

[Bindable]
public var winParam:Object; // 窗体窗体的 参数

//窗体初始化
public function onWindowInit():void{
	this.pageBar.yixuan.width=0;
	this.pageBar.yixuan2.width=0;
	if(winParam){
		optType=winParam as String;
	}
	optType="dbsx";
	if(optType=="dbsx"){
		optName="待办事项";
	}else if(optType=="ybsx"){
		optName="已办事项";
	}else if(optType=="gzsx"){
		optName="跟踪未办";
	}else if(optType=="dfsx"){
		optName="待发事项";
	}else if(optType=="yfsx"){
		optName="已发已办";
	}
	
	switchHanlder(optType);
	this.lbTitle.text="我的协同 ["+optName+"]";
	
}
private function showOrHidecxbt(bool:Boolean=true):void{
	this.cxBt.visible=bool;
	this.scBt.visible=bool;
}
//窗体打开
public function onWindowOpen():void{
	onWindowInit();
}
//窗体关闭,完成窗体的清理工作
public function onWindowClose():void{

}

//序号
private function lbfun(item:Object,column:DataGridColumn):String{
	return ""+(_workFlowDatas.getItemIndex(item)+1);
}

//表体
private function csubjectLbFun(item:Object,column:DataGridColumn):String{
	if(item && item.hasOwnProperty("csubject")){
		if((item.csubject as String).length >=30){
			return (item.csubject as String).substr(0,30)+"...";
		}else{
			return item.csubject;
		}
	}else{
		return "";
	}
}

// linkbar 点击事件
private function linkbar_itemClickHandler(event:ItemClickEvent):void{
	_workFlowDatas=new ArrayCollection; // 清空数据
	optType=event.item.opt;
	optName=event.label;
	//this.lbTitle.text="我的协同 ["+optName+"]";
	switchHanlder(optType);
}

private function linkbar_ClickHandler(event:MouseEvent):void{
	_workFlowDatas=new ArrayCollection; // 清空数据
	optType=event.currentTarget.name;
	optName=event.currentTarget.label;
	
	//this.lbTitle.text="我的协同 ["+optName+"]";
	switchHanlder(optType);
}

private function switchHanlder(optType:String,scvalue:String=null):void{
	showOrHidecxbt(false);
	param.scvalue=scvalue;
	if(scvalue==null){
		this.fastsearch.text="";
	}
	switch(optType){
		case "ybsx":onybsx();this.cxBt.includeInLayout=false;this.scBt.includeInLayout=false;break;
		case "gzsx":ongzsx();showOrHidecxbt();this.cxBt.includeInLayout=true;this.scBt.includeInLayout=true;break;
		case "dfsx":ondfsx();this.cxBt.includeInLayout=false;this.scBt.includeInLayout=false;break;
		case "yfsx":onyfsx();this.cxBt.includeInLayout=false;this.scBt.includeInLayout=false;break;
		default:ondbsx();this.cxBt.includeInLayout=false;this.scBt.includeInLayout=false;
	}
}
protected var param:Object={};
private function ondbsx():void{
	param.pagesize=100;
	param.curpage=1;
	param.sqlid="get_persons_sql";
	var sql:String="select c.*,ab.imaker,dbo.getXTType(ab.ifuncregedit) 'xtname'," +
		"ab.ifuncregedit 'xtlx',convert(varchar,ab.dmaker,120) " +
		"dmaker,p.cname pcname,isnull(f.cname,'新建自由协同')  funname  from ("
		+" select iid,csubject,convert(varchar(10),dfinished,120) dfinished," +
		"istatus,ifuncregedit,iinvoice from oa_invoice where iid in ("
		+"select ioainvoice from wf_node where  inodetype=0 and inodevalue="+CRMmodel.userId+" and (istatus = 3)"+
		"union select ioainvoice from wf_nodes where iperson="+CRMmodel.userId+" and (istatus = 3 )"
		+")) c left join ab_invoiceproperty ab on c.iid=ab.iinvoice left join hr_person p on ab.imaker=p.iid "
		+"left join as_funcregedit f on f.iid=c.ifuncregedit where 1=1 ";
	
	if(CRMtool.isStringNotNull(this.fastsearch.text))
	{
		sql+=" and (p.cname like '%"+this.fastsearch.text+"%' or f.cname like '%"+this.fastsearch.text
			+"%' or csubject like '%"+this.fastsearch.text+"%' or ab.dmaker like '%"+this.fastsearch.text
			+"%' or dbo.getXTType(ab.ifuncregedit) like '%"+this.fastsearch.text+"%' )";
	}
	param.sql=sql;
	param.orderSql="order by iid desc";
	this.pageBar.initPageHandler(param,function(list:ArrayCollection):void{
		pageCallBack_New(list,sql)
	});
}

private function pageCallBack_New(list:ArrayCollection,sql:String):void{
	_workFlowDatas=list;
}


private function onybsx():void{
	param.pagesize=100;
	param.curpage=1;
	param.sqlid="get_persons_sql";
	var sql:String="select c.*,ab.imaker,dbo.getXTType(ab.ifuncregedit) 'xtname',ab.ifuncregedit" +
		" 'xtlx',convert(varchar,ab.dmaker,120) dmaker,p.cname pcname," +
		"isnull(f.cname,'新建自由协同')  funname from ("+
		"select iid,csubject,convert(varchar(10),dfinished,120) " +
		"dfinished,istatus,ifuncregedit,iinvoice from oa_invoice where iid in ("+
		"select ioainvoice from wf_node where  inodetype=0 and inodevalue="+CRMmodel.userId+
		" and istatus=5 union select ioainvoice from wf_nodes where iperson="+CRMmodel.userId
		+" and istatus=5)) c left join ab_invoiceproperty ab on c.iid=ab.iinvoice " +
		"left join hr_person p on ab.imaker=p.iid left join as_funcregedit f on f.iid=c.ifuncregedit where 1=1 ";
	if(CRMtool.isStringNotNull(this.fastsearch.text))
	{
		sql+=" and (p.cname like '%"+this.fastsearch.text+"%' or f.cname like '%"+this.fastsearch.text
			+"%' or csubject like '%"+this.fastsearch.text+"%' or ab.dmaker like '%"+this.fastsearch.text
			+"%' or dbo.getXTType(ab.ifuncregedit) like '%"+this.fastsearch.text+"%' )";
	}
	param.sql=sql;
	param.orderSql="order by iid desc";
	this.pageBar.initPageHandler(param,function(list:ArrayCollection):void{
		pageCallBack_New(list,sql)
	});
}
private function ongzsx():void{
	param.pagesize=100;
	param.curpage=1;
	param.sqlid="get_persons_sql";
	var sql:String="select b.*,dbo.getXTType(ab.ifuncregedit) 'xtname'," +
		"ab.ifuncregedit 'xtlx',ab.imaker,convert(varchar,ab.dmaker,120) dmaker" +
		",p.cname pcname,isnull(f.cname,'新建自由协同')  funname" +
		" from (select iid,csubject,convert(varchar(10),dfinished,120) dfinished" +
		",istatus,ifuncregedit,iinvoice   from oa_invoice where iid " +
		"in (select distinct(a.ioainvoice) from (select count(inodeid) nodenum," +
		"ioainvoice from wf_node where istatus=3 group by ioainvoice " +
		"union all select count(inodeid) nodenum,ioainvoice from wf_nodes " +
		"where istatus=3 group by ioainvoice) a  " +
		"where a.ioainvoice in " +
		"(select ioainvoice from wf_node where ipnodeid='startnode'" +
		" and inodevalue="+CRMmodel.userId+") group by a.ioainvoice having sum(nodenum)>0) ) " +
		"b left join ab_invoiceproperty ab on b.iid=ab.iinvoice left join " +
		"hr_person p on ab.imaker=p.iid left join as_funcregedit f on f.iid=b.ifuncregedit where 1=1";
	if(CRMtool.isStringNotNull(this.fastsearch.text))
	{
		sql+=" and (p.cname like '%"+this.fastsearch.text+"%' or f.cname like '%"+this.fastsearch.text
			+"%' or csubject like '%"+this.fastsearch.text+"%' or ab.dmaker like '%"+this.fastsearch.text
			+"%' or dbo.getXTType(ab.ifuncregedit) like '%"+this.fastsearch.text+"%' )";
	}
	param.sql=sql;
	param.orderSql="order by iid desc";
	this.pageBar.initPageHandler(param,function(list:ArrayCollection):void{
		pageCallBack_New(list,sql)
	});
}
private function ondfsx():void{
	param.pagesize=100;
	param.curpage=1;
	param.sqlid="get_persons_sql";
	var sql:String="select a.*,dbo.getXTType(ab.ifuncregedit) 'xtname',ab.ifuncregedit 'xtlx'," +
		"ab.imaker,convert(varchar,ab.dmaker,120) dmaker,p.cname pcname,isnull(f.cname,'新建自由协同')  " +
		"funname from (select iid,csubject,convert(varchar(10),dfinished,120) dfinished,istatus," +
		"ifuncregedit,iinvoice from oa_invoice where iid in (select ioainvoice from wf_node where " +
		"ipnodeid='startnode' and istatus=0 and inodevalue="+CRMmodel.userId+") ) a " +
		"left join ab_invoiceproperty ab on a.iid=ab.iinvoice " +
		"left join hr_person p on ab.imaker=p.iid left join as_funcregedit f on f.iid=a.ifuncregedit where 1=1 ";
	if(CRMtool.isStringNotNull(this.fastsearch.text))
	{
		sql+=" and (p.cname like '%"+this.fastsearch.text+"%' or f.cname like '%"+this.fastsearch.text
			+"%' or csubject like '%"+this.fastsearch.text+"%' or ab.dmaker like '%"+this.fastsearch.text
			+"%' or dbo.getXTType(ab.ifuncregedit) like '%"+this.fastsearch.text+"%' )";
	}
	param.sql=sql;
	param.orderSql="order by iid desc";
	this.pageBar.initPageHandler(param,function(list:ArrayCollection):void{
		pageCallBack_New(list,sql)
	});
}
private function onyfsx():void{
	param.pagesize=100;
	param.curpage=1;
	param.sqlid="get_persons_sql";
	var sql:String="select a.*,dbo.getXTType(ab.ifuncregedit) 'xtname'," +
		"ab.ifuncregedit 'xtlx',ab.imaker,convert(varchar,ab.dmaker,120) " +
		"dmaker,p.cname pcname,isnull(f.cname,'新建自由协同')  " +
		"funname from(select iid,csubject,convert(varchar(10),dfinished,120) " +
		"dfinished,istatus,ifuncregedit,iinvoice from oa_invoice " +
		"where iid in (select distinct(ioainvoice) from wf_node " +
		"where ipnodeid='startnode' and inodevalue="+CRMmodel.userId+" and " +
		"ioainvoice not in (select distinct (ioainvoice) " +
		"from wf_node where istatus != 5 and istatus !=1 ))) " +
		"a left join ab_invoiceproperty ab on a.iid=ab.iinvoice " +
		"left join hr_person p on ab.imaker=p.iid left join as_funcregedit f on f.iid=a.ifuncregedit where 1=1 ";
	if(CRMtool.isStringNotNull(this.fastsearch.text))
	{
		sql+=" and (p.cname like '%"+this.fastsearch.text+"%' or f.cname like '%"+this.fastsearch.text
			+"%' or csubject like '%"+this.fastsearch.text+"%' or ab.dmaker like '%"+this.fastsearch.text
			+"%' or dbo.getXTType(ab.ifuncregedit) like '%"+this.fastsearch.text+"%' )";
	}
	param.sql=sql;
	param.orderSql="order by iid desc";
	this.pageBar.initPageHandler(param,function(list:ArrayCollection):void{
		pageCallBack_New(list,sql)
	});
}
// 分页显示
public function pageHandler():void{
		param.pagesize=10;
		param.curpage=1;
		param.sqlid="wf.getWorfFlowsPage";
		param.personiid=CRMmodel.userId;
		this.pageBar.initPageHandler(param,pageCallBack);
}

[Bindable]
private var ybsx_sum:int=0;
[Bindable]
private var gzsx_sum:int=0;
[Bindable]
private var dfsx_sum:int=0;
[Bindable]
private var yfsx_sum:int=0;
[Bindable]
private var dbsx_sum:int=0;

public function pageCallBack(list:ArrayCollection):void{
	_workFlowDatas=list;
	if(optType==null){
		dbsx_sum=this.pageBar._allItemNum;
	}else{
		try{
			this[optType+"_sum"]=this.pageBar._allItemNum;
		}catch(e:Error){
			dbsx_sum=this.pageBar._allItemNum;
		}
	}
	//Alert.show(""+this[optType+"_sum"]);
}

//表格中的选中项
private var selectItem:Object;
// 点击表格
private function workFlowDg_itemHandler():void{
	selectItem=this.workFlowDg.selectedItem;
	var param:Object={};
	if(selectItem.xtlx=="10"){ // 自由协同
		param.oaiid=selectItem.iid;
		param.wfDrawType="open";
		if(optType==null){
			optType="dbsx";
		}
		param.optType=optType;
        AccessUtil.remoteCallJava("WorkFlowDest","getWorkFlow",function(event:ResultEvent):void{
            if(event.result) {
                CRMtool.openMenuItemFormOther("yssoft.views.workflow.FreeCoView",param,"["+optName.substr(0,2)+"]"+selectItem.csubject,selectItem.iid+":"+optType);
            }else {
                CRMtool.tipAlert("该工作流已删除或不存在！");
            }
        },selectItem.iid,"正在获取协同信息...");

	}else{//非自由协同打开
		param.operId="onListDouble";
		
		param.outifuncregedit=selectItem.ifuncregedit;
		param.ifuncregedit=selectItem.ifuncregedit;
		
		var iid:ArrayCollection=new ArrayCollection();
		iid.addItem({iid:selectItem.iinvoice});
		
		param.personArr=iid;
		
		param.itemType="onBrowse";
		
		param.formTriggerType="fromOther";

        CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore",param,"加载中 ...", "");

	}
}

// 新建
private function newBtClickHandler():void{
	CRMtool.openMenuItemFormOther("yssoft.views.workflow.FreeCoView",null,"创建协同","");
}
// 查找
public function onSearch():void{
	switchHanlder(optType,StringUtil.trim(this.fastsearch.text));
}
//撤销

private function revocationHandler():void{
	if(optType != "gzsx"){ // 必须是跟踪事项
		CRMtool.tipAlert("只有跟踪事项才能被撤销");
		return;
	}
	
	if(this.workFlowDg.selectedItem == null){
		CRMtool.tipAlert("请先选中，在处理!");
		return;
	}
	if(this.workFlowDg.selectedItem.xtlx != "10"){
		CRMtool.tipAlert("只有自由协同才能撤销");
		return;
	}
	CRMtool.tipAlert1("确定撤销协同 ["+this.workFlowDg.selectedItem.csubject+"]?",null,"AFFIRM",cxHandler);
}
private function cxHandler():void{
/*	if(optType != "gzsx"){ // 必须是跟踪事项
		return;
	}
	if(this.workFlowDg.selectedItem == null){
		CRMtool.tipAlert("请先选中，在处理!");
		return;
	}*/
	var iid:int=this.workFlowDg.selectedItem.iid;
	if(iid !=0 )
	AccessUtil.remoteCallJava("WorkFlowDest","revocationHandler",zxCallBack,iid,"协同撤销中...");
}
private function zxCallBack(event:ResultEvent):void{
	if(event.result){
		var ret:String=event.result as String;
		if(ret=="suc"){
			CRMtool.tipAlert("撤销成功!");
			var delSql:String="delete oa_invoice where iid="+this.workFlowDg.selectedItem.iid+"; delete as_communication where iinvoice="+this.workFlowDg.selectedItem.iid+";";
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
			}, delSql);
			
			_workFlowDatas.removeItemAt(this.workFlowDg.selectedIndex);
			return;
		}
		if(ret=="fail"){
			CRMtool.tipAlert("该协同已被处理，不可撤销！");
			return;
		}
	}
	CRMtool.tipAlert("撤销失败!");
}

// 协同类型的 名称显示

private function xtname(item:Object,column:DataGridColumn):String{
	if(item.funname==null || item.funname==""){
		return "自由协同";
	}
	return item.funname;
}
//打开高级查询窗口
private function openQueryWin():void {
	//居中显示
	var ass:AssemblyQueryclmView = new AssemblyQueryclmView();
	var ifuncregedit:int = 25;
	ass.ifuncregedit = ifuncregedit;
	ass.width = 700;
	ass.height = 500;
	ass.owner = this;
	CRMtool.openView(ass);
}
public function pageInitBack(sql:String):void {
	param.pagesize = 500;
	param.curpage = this.pageBar.curPageNum;
	param.sqlid="get_persons_sql";
	var sql2:String="";
	if(optType=="dbsx"){
	   sql2="select c.*,ab.imaker,dbo.getXTType(ab.ifuncregedit) 'xtname'," +
		"ab.ifuncregedit 'xtlx',convert(varchar,ab.dmaker,120) " +
		"dmaker,p.cname pcname,isnull(f.cname,'新建自由协同')  funname  from ("
		+" select iid,csubject,convert(varchar(10),dfinished,120) dfinished," +
		"istatus,ifuncregedit,iinvoice from oa_invoice where iid in ("
		+"select ioainvoice from wf_node where  inodetype=0 and inodevalue="+CRMmodel.userId+" and (istatus = 3)"+
		"union select ioainvoice from wf_nodes where iperson="+CRMmodel.userId+" and (istatus = 3 )"
		+")) c left join ab_invoiceproperty ab on c.iid=ab.iinvoice left join hr_person p on ab.imaker=p.iid "
		+"left join as_funcregedit f on f.iid=c.ifuncregedit where 1=1 ";
	}
	if(optType=="ybsx"){
		sql2="select c.*,ab.imaker,dbo.getXTType(ab.ifuncregedit) 'xtname',ab.ifuncregedit" +
			" 'xtlx',convert(varchar,ab.dmaker,120) dmaker,p.cname pcname," +
			"isnull(f.cname,'新建自由协同')  funname from ("+
			"select iid,csubject,convert(varchar(10),dfinished,120) " +
			"dfinished,istatus,ifuncregedit,iinvoice from oa_invoice where iid in ("+
			"select ioainvoice from wf_node where  inodetype=0 and inodevalue="+CRMmodel.userId+
			" and istatus=5 union select ioainvoice from wf_nodes where iperson="+CRMmodel.userId
			+" and istatus=5)) c left join ab_invoiceproperty ab on c.iid=ab.iinvoice " +
			"left join hr_person p on ab.imaker=p.iid left join as_funcregedit f on f.iid=c.ifuncregedit where 1=1 ";
	}
	if(optType=="gzsx"){
		sql2="select b.*,dbo.getXTType(ab.ifuncregedit) 'xtname'," +
			"ab.ifuncregedit 'xtlx',ab.imaker,convert(varchar,ab.dmaker,120) dmaker" +
			",p.cname pcname,isnull(f.cname,'新建自由协同')  funname" +
			" from (select iid,csubject,convert(varchar(10),dfinished,120) dfinished" +
			",istatus,ifuncregedit,iinvoice   from oa_invoice where iid " +
			"in (select distinct(a.ioainvoice) from (select count(inodeid) nodenum," +
			"ioainvoice from wf_node where istatus=3 group by ioainvoice " +
			"union all select count(inodeid) nodenum,ioainvoice from wf_nodes " +
			"where istatus=3 group by ioainvoice) a  " +
			"where a.ioainvoice in " +
			"(select ioainvoice from wf_node where ipnodeid='startnode'" +
			" and inodevalue="+CRMmodel.userId+") group by a.ioainvoice having sum(nodenum)>0) ) " +
			"b left join ab_invoiceproperty ab on b.iid=ab.iinvoice left join " +
			"hr_person p on ab.imaker=p.iid left join as_funcregedit f on f.iid=b.ifuncregedit where 1=1";
	}
	if(optType=="dfsx"){
		sql2="select a.*,dbo.getXTType(ab.ifuncregedit) 'xtname',ab.ifuncregedit 'xtlx'," +
			"ab.imaker,convert(varchar,ab.dmaker,120) dmaker,p.cname pcname,isnull(f.cname,'新建自由协同')  " +
			"funname from (select iid,csubject,convert(varchar(10),dfinished,120) dfinished,istatus," +
			"ifuncregedit,iinvoice from oa_invoice where iid in (select ioainvoice from wf_node where " +
			"ipnodeid='startnode' and istatus=0 and inodevalue="+CRMmodel.userId+") ) a " +
			"left join ab_invoiceproperty ab on a.iid=ab.iinvoice " +
			"left join hr_person p on ab.imaker=p.iid left join as_funcregedit f on f.iid=a.ifuncregedit where 1=1 ";
	}
	if(optType=="yfsx"){
		sql2="select a.*,dbo.getXTType(ab.ifuncregedit) 'xtname'," +
			"ab.ifuncregedit 'xtlx',ab.imaker,convert(varchar,ab.dmaker,120) " +
			"dmaker,p.cname pcname,isnull(f.cname,'新建自由协同')  " +
			"funname from(select iid,csubject,convert(varchar(10),dfinished,120) " +
			"dfinished,istatus,ifuncregedit,iinvoice from oa_invoice " +
			"where iid in (select distinct(ioainvoice) from wf_node " +
			"where ipnodeid='startnode' and inodevalue="+CRMmodel.userId+" and " +
			"ioainvoice not in (select distinct (ioainvoice) " +
			"from wf_node where istatus != 5 and istatus !=1 ))) " +
			"a left join ab_invoiceproperty ab on a.iid=ab.iinvoice " +
			"left join hr_person p on ab.imaker=p.iid left join as_funcregedit f on f.iid=a.ifuncregedit where 1=1 ";
	}
	if (sql.lastIndexOf("order") != -1) {
		var end:int = sql.lastIndexOf("order");
		var len:int = sql.length;
		param.sql = "select * from (" + sql2 + ") tmp where 1=1 " + sql.substring(0, end);
		param.orderSql = sql.substring(end, len);  
	}
	else {
		param.sql = sql2;
	}
	this.pageBar.initPageHandler(param, callBack);//分页
	
}
//回调
private function callBack(list:ArrayCollection):void {
	_workFlowDatas = list;//给列表赋值
}
//删除自由协同

private function delecteHandler():void{
	if(optType != "gzsx"){ // 必须是跟踪事项
		CRMtool.tipAlert("只有跟踪事项才能被删除");
		return;
	}
	
	if(this.workFlowDg.selectedItem == null){
		CRMtool.tipAlert("请先选中，在处理!");
		return;
	}
	if(this.workFlowDg.selectedItem.xtlx != "10"){
		CRMtool.tipAlert("只有自由协同才能删除");
		return;
	}
	CRMtool.tipAlert1("确定删除协同 ["+this.workFlowDg.selectedItem.csubject+"]?",null,"AFFIRM",scHandler);
}
private function scHandler():void{
	/*	if(optType != "gzsx"){ // 必须是跟踪事项
	return;
	}
	if(this.workFlowDg.selectedItem == null){
	CRMtool.tipAlert("请先选中，在处理!");
	return;
	}*/
	var iid:int=this.workFlowDg.selectedItem.iid;
	if(iid !=0 )
		var sql:String="select COUNT(*)num from wf_node where ioainvoice="+iid+"  and inodevalue="+CRMmodel.userId+" and ipnodeid='startnode'";
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
		var ac:ArrayCollection=event.result as ArrayCollection;
		if(ac[0].num==0){
			CRMtool.tipAlert("自由协同只有发起人才能删除！");
			return;
		}
		var delSql:String="exec pr_delwfinfo "+iid+" ;delete as_communication where iinvoice="+iid+";";
		AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
			CRMtool.tipAlert("自由协同删除成功！");
		}, delSql);
		
	}, sql);
	
}

