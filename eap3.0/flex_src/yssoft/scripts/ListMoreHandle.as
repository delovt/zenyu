/*
	模块名称：更多操作
	模块功能：列表单据中更多操作按钮对应的操作脚本

	创建者：		YJ	
	创建日期：	2011-12-21
	修改者：
	修改日期：

*/

import flash.events.Event;
import flash.net.URLRequest;
import flash.net.navigateToURL;

import mx.collections.ArrayCollection;
import mx.controls.Menu;
import mx.controls.PopUpButton;
import mx.core.IFlexDisplayObject;
import mx.events.MenuEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;

import yssoft.comps.frame.FrameworkVBoxView;
import yssoft.comps.titlewindow.FrameListSetColorTitleWindow;
import yssoft.frameui.importData.CrmImportDataView;
import yssoft.models.CRMmodel;
import yssoft.models.ConstsModel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.tools.ServiceTool;
import yssoft.views.Communication;
import yssoft.views.billMoreViews.InsertMrMarketsTitleWindow;
import yssoft.views.billMoreViews.InsertOaWorkPlanTitleWindow;
import yssoft.views.billMoreViews.InsertServiceRequestTitleWindow;
import yssoft.views.billMoreViews.UpdateSrBillFintegralWindow;
import yssoft.views.consultsets.ConsultsetSet;
import yssoft.views.listMoreViews.AllocationPersonTitleWindow;
import yssoft.views.listMoreViews.AssignCustomerTitleWindow;
import yssoft.views.listMoreViews.ExpenseSubmtTitleWindow;
import yssoft.views.moreHandleViews.view_batchaccredit;
import yssoft.views.moreHandleViews.view_customermerge;
import yssoft.views.moreHandleViews.view_custproductmerge;
import yssoft.views.moreHandleViews.view_datacorrect;
import yssoft.views.moreHandleViews.view_heatset;
import yssoft.views.moreHandleViews.view_sendmessage;
import yssoft.vos.ListclmVo;

[Bindable]
public var windowName:String = "";//记录弹出窗体的全路径 "yssoft.views.moreHandleViews.view_oatravel"

[Bindable]
public var ccode:String = "";//权限编码

public var myMenu:Menu;

[Bindable] public var arr_MoreMenu:ArrayCollection = new ArrayCollection();

private function iniListMoreMenuBefore():void{
	/*********添加进一步验证hasOwnProperty *******/
	if(this.itemObj == null || this.itemObj.hasOwnProperty("ifuncregedit") ==false || this.itemObj.ifuncregedit == 0) return;//注册内码为零为无效数据，直接返回
	AccessUtil.remoteCallJava("AuthcontentDest","getListByIfuncregedit",onGetDataListBack,this.itemObj.ifuncregedit);
	
}

private function onGetDataListBack(evt:ResultEvent):void{
	
	arr_MoreMenu = evt.result as ArrayCollection;
	
	if(arr_MoreMenu.length == 0) return;
	
	iniListMoreMenu();                  
	
}

//初始化更多操作中的菜单项
public function iniListMoreMenu():void{
	
	this.hb_morehandle.removeAllChildren();
	var ppb:PopUpButton = new PopUpButton();
    //ppb.d
	myMenu = new Menu();
	
	myMenu.dataProvider = this.arr_MoreMenu;
	myMenu.variableRowHeight = true;
	myMenu.addEventListener(MenuEvent.CHANGE,menu_change);


    ppb.addEventListener(MouseEvent.ROLL_OUT, function(event:MouseEvent):void{
        if(event.stageX<myMenu.x||event.stageY<myMenu.y)
            ppb.close();
    });
    myMenu.addEventListener(MouseEvent.ROLL_OUT, function(event:MouseEvent):void{
        if(event.stageX<myMenu.x||event.stageX>myMenu.x+ppb.width||event.stageY<myMenu.y-ppb.height||event.stageY>myMenu.y+myMenu.height)
            ppb.close();
    });

	ppb.label = "更多";
	ppb.openAlways = true;
	ppb.height = 25;
	ppb.width = 60;
	ppb.popUp = myMenu;
	ppb.popUp.width = ppb.width+40;
	
	ppb.styleName = "popupbuttonskin1";
	
	this.hb_morehandle.addChild(ppb);
	this.hb_morehandle.visible = true;
}
//更多操作当前选中按钮的名称
private var moreLabel:String;
//菜单改变事件
private function menu_change(evt:MenuEvent):void{
	
	//单据增加或修改状态下不允许操作
//	if(this.item == "onNew" || this.item == "onEdit"){CRMtool.tipAlert("单据只有在浏览状态下才可以使用该功能！");return;}
	this.ccode = evt.item.ccode;//权限编码
	this.windowName = evt.item.cform;//窗体路径赋值
	
	//加入权限
	var warning:String=this.auth.reuturnwarning(ccode);
	if (warning!=null){CRMtool.showAlert(warning);return;}
	
	try{
		if(evt.item.cfunction == null) return;
        moreLabel = evt.item.label;
		this[evt.item.cfunction].call();//调用方法
	}
	catch(e:Error){
		CRMtool.tipAlert("请配置相关参数");
	}
}

//弹出窗体的公共调用方法
private function onPopupForm():void{
	var titlewindow:Object = {};
	
	if(windowName == "") return;
	
	titlewindow = CRMtool.createObjectByClassName(windowName);
	titlewindow.owner = this;
	
	PopUpManager.addPopUp(titlewindow as IFlexDisplayObject, this,true);
	PopUpManager.centerPopUp(titlewindow as IFlexDisplayObject);
	
}

/*************************YJ Add 以下是方法实现****************************************/

//列表数据删除
private function onDelete():void{
	
	this.newdelinfoArr = new ArrayCollection();
	this.items= new ArrayCollection();
	this.items=this.dgrd_person.getSelectRows();
	//--------------批量删除数据权限控制 刘磊20111219 begin--------------//
	var arriid:Array=new Array();
	for(var i:int=0;i<this.items.length;i++)
	{
		var obj:Object = this.items.getItemAt(i);
		arriid.push(obj.iid);
	}
	this.auth.getdelbatch("04",this.itemObj.outifuncregedit,CRMmodel.userId,CRMmodel.hrperson.idepartment,arriid);
	auth.addEventListener("onGet_getdelbatchSucess",function(evt:Event):void
	{
		var find:Boolean=true;
		for(var i:int=0;i<items.length;i++)
		{
			var paramObj:Object = items.getItemAt(i);
			var item:Boolean=false;
			for (var j:int = 0; j<auth.allowdelArr.length; j++) 
			{
				if (int(paramObj.iid)==int(auth.allowdelArr.getItemAt(j).iinvoice))
				{
					item=true;
					break;
				}
			}
			if (!item)
			{
				CRMtool.tipAlert("禁止删除操作：【序号："+paramObj.sort_id+"】这个单据无删除数据权限！");
				find=false;
				break;
			}
		}
		if (find)
		{
			delbatch();
		}
	})
}

//列表设置
private function onSetup():void{
	var ass:ConsultsetSet = new ConsultsetSet();
	ass.iid=int(itemObj.ifuncregedit);
	ass.isShow = true;
	ass.isShowList =1;
	ass.width=700;
	ass.height = 500;
	ass.owner = this;
	CRMtool.openView(ass);
}

//Excel数据导出
private function onExcelExport():void{
	var dgrdArr:ArrayCollection = new ArrayCollection();
	dgrdArr = dgrd_person.getSelectRows();
	
	if(dgrdArr.length ==0){CRMtool.tipAlert("请选择要导出的记录！！");return;}
	
	var objvalue:Object = {};
	var title:String = "管理档案";
	var columnArr:ArrayCollection=new ArrayCollection();//记录字段名称和标题的记录集
	objvalue.arr = dgrdArr;//数据集
	
	if(this.itemObj.title != null)
		title = itemObj.title;
	objvalue.title = title;//标题
	
	objvalue.flag = 0;//是否显示序号
	
	for each(var acli:ListclmVo in acListclmVos){
		
		if(acli.bshow == true)
			columnArr.addItem({"cfld":acli.cfield,"cfldcaption":acli.ccaption,"width":acli.icolwidth,"ifieldtype":acli.ifieldtype});//获取列数据集
		
	}
	
	objvalue.fieldsList=columnArr;
	
	AccessUtil.remoteCallJava("ExcelHadleDest","writeExcel",onWriteExcelBack,objvalue);//调用后台的导出方法
}
//YJ Add 数据导出后的操作
private function onWriteExcelBack(evt:ResultEvent):void{
	var filename:String = "";			
	if(evt.result.hasOwnProperty("filename")){
		filename = evt.result.filename as String;
	}
	var requestUrl:String = "/"+ConstsModel.publishAppName+"/excelExportServlet?fn="+filename;
	var request:URLRequest = new URLRequest(requestUrl);
	navigateToURL(request, "_blank");
}

//客商合并
private function onCusMerge():void{

    var ac:ArrayCollection = this.dgrd_person.getSelectRows();
	
	if(ac.length==0) {CRMtool.tipAlert("请选择要合并的客商！！");return;}
	
	var cusmerge:view_customermerge = new view_customermerge();
	cusmerge.cusArr = ac;
	CRMtool.openView(cusmerge);
}

//资产合并
private function onProductMerge():void{

    var ac:ArrayCollection = this.dgrd_person.getSelectRows();
	
	if(ac.length==0) {CRMtool.tipAlert("请选择要合并的资产！！");return;}

    var c_cname:String = ac[0].c_cname;//客商名称
    for each(var a in ac){
        if(a.c_cname != c_cname){
            CRMtool.showAlert("必须相同客户才能合并资产！");
            return;
        }
    }

    var cusmerge:view_custproductmerge = new view_custproductmerge();
	cusmerge.cusArr = ac;
	CRMtool.openView(cusmerge);
}

// 单据批量提交
private function onPatchCoopHandler():void{
	this.patchCoopHandler();
}

//费用报销生单
private function onExpenseSubmit():void{
	var iperson:int = CRMmodel.userId;
	if(iperson!=0){
		AccessUtil.remoteCallJava("OADest","getExpenseNeedList",function(event:ResultEvent):void{
			if(event.result&&(event.result as ArrayCollection).length>0){
				new ExpenseSubmtTitleWindow().init(event.result as ArrayCollection);
			}else{
				CRMtool.showAlert("当前没有可供报销的数据！");
			}			
		},iperson);
	}
	
}


//客商分配
public function onCusAssign():void{
	
	var ac:ArrayCollection = new ArrayCollection();
	ac = this.dgrd_person.getSelectRows();
	if(ac.length == 0){CRMtool.tipAlert("请选择需要分配的客商！");return;}
	
	var assignCusTitleWindow:AssignCustomerTitleWindow = new AssignCustomerTitleWindow();
	
	assignCusTitleWindow.setAc(ac);
	CRMtool.openView(assignCusTitleWindow);
	
	
}

//分配人员
public function onAllocationPerson():void{
	
	var ac:ArrayCollection = new ArrayCollection();
	ac = this.dgrd_person.getSelectRows();
	if(ac.length == 0){CRMtool.tipAlert("请选择需要分配的工单！");return;}
	
	var allocationPerson:AllocationPersonTitleWindow = new AllocationPersonTitleWindow();
	
	allocationPerson.myinit(ac);
}

//黄页客户导入

private function onExportByYPC():void{
	var crmImportDataView:CrmImportDataView = new CrmImportDataView();
	crmImportDataView.myinit(this);
	CRMtool.openView(crmImportDataView);
}

/*
	公共列表--更多操作--批量授权
*/
private function onBatchAccredit():void
{
	var ac:ArrayCollection = new ArrayCollection();
	ac = this.dgrd_person.getSelectRows();
	if(ac.length == 0){CRMtool.tipAlert("请选择需要批量授权的记录！");return;}
	
	var batchAccreditTitleWindow:view_batchaccredit = new view_batchaccredit();
	var objparam:Object = {};
	
	objparam.ifuncregedit = this.itemObj.outifuncregedit;
	objparam.datalist = ac;
	
	AccessUtil.remoteCallJava("BatchAccreditDest","queryConsult",function(evt:ResultEvent):void{
		
		var robj:Object = evt.result;
		batchAccreditTitleWindow.consultObj 	= robj.consultobj;//参照
		batchAccreditTitleWindow.dgColumnsArr 	= acListclmVos;//列表头集合
		batchAccreditTitleWindow.dgDataSet 		= robj.datalist;//数据集合
		batchAccreditTitleWindow.ifuncregedit 	= objparam.ifuncregedit;//单据注册码
		CRMtool.openView(batchAccreditTitleWindow);
		
	},objparam);
}

/*
	公共列表--更多操作--热度设置
*/
private function onHeatSet():void
{
	var ac:ArrayCollection = new ArrayCollection();
	ac = this.dgrd_person.getSelectRows();
	if(ac.length == 0){CRMtool.tipAlert("请选择需要热度设置的记录！");return;}
	
	AccessUtil.remoteCallJava("BatchAccreditDest","onGetHeatList",function(evt:ResultEvent):void{
		
		var heatArr:ArrayCollection = evt.result as ArrayCollection;
		if(heatArr.length == 0) {CRMtool.tipAlert("请先设置热度级别！");return;}
		
		var heatsetTitleWindow:view_heatset = new view_heatset();
		heatsetTitleWindow.dgColumnsArr = acListclmVos;//列表头集合
		heatsetTitleWindow.dgDataSet = ac;
		heatsetTitleWindow.heatDataSetArr = heatArr;
		
		CRMtool.openView(heatsetTitleWindow);
		
		
	},null);
	
}

//YJ Add 2012-05-28  将数据显示到Word中，简单的数据写入
private function onWordExport():void{
	
	var dgrdArr:ArrayCollection = new ArrayCollection();
	dgrdArr = this.dgrd_person.getSelectRows();
	
	if(dgrdArr.length ==0){CRMtool.tipAlert("请选择要导出的记录！！");return;}
	
	var objvalue:Object = {};
	var title:String = "WORD文档";
	var columnArr:ArrayCollection=new ArrayCollection();//记录字段名称和标题的记录集
	objvalue.arr = dgrdArr;//数据集
	
	if(this.itemObj.title != null)
		title = this.itemObj.title;
	objvalue.title = title;//标题
	
	objvalue.flag = 0;//是否显示序号
	
	for each(var acli:ListclmVo in this.acListclmVos){
		
		if(acli.bshow == true)
			columnArr.addItem({"cfld":acli.cfield,"cfldcaption":acli.ccaption,"width":acli.icolwidth,"ifieldtype":acli.ifieldtype});//获取列数据集
		
	}
	
	objvalue.fieldsList=columnArr;
	
	AccessUtil.remoteCallJava("WordHandleDest","onWriteWord",onWriteExcelBack,objvalue);//调用后台的导出方法
	
}

//wtf add
private function onRefreshState():void{
	AccessUtil.remoteCallJava("ForListHandleDest","onRefreshState",onRefreshStateHandler);
}
private function onRefreshStateHandler(evt:ResultEvent):void{
	CRMtool.showAlert(evt.result+"");
	pageInitBack(this.querySql);
}


/**
 * 	YJ Add 20120822
 * 	数据批改功能
 */
protected function onDataCorrect():void{
	
	var ac:ArrayCollection = new ArrayCollection();
	ac = this.dgrd_person.getSelectRows();
	if(ac.length == 0){CRMtool.tipAlert("请选择需要数据批改的记录！");return;}
	
	var dataCorrectTitleWindow:view_datacorrect = new view_datacorrect();
	var objparam:Object = {};
	
	objparam.ifuncregedit = this.itemObj.outifuncregedit;

    //如果是合同中心，则启用 新购合同的 数据批改
    if(itemObj.ifuncregedit == 282)
        objparam.ifuncregedit = 162;

	objparam.ctable = this.itemObj.ctable;
	
	AccessUtil.remoteCallJava("DataCorrectDest","onGetControlsPropertys",function(evt:ResultEvent):void{
		
		var arr:ArrayCollection = evt.result as ArrayCollection;
		
		if(arr == null || arr.length == 0)
		{
			CRMtool.tipAlert("请配置数据批改信息！");
			return;
		}
		
		dataCorrectTitleWindow.dgDataSet 		= ac;
		dataCorrectTitleWindow.dgColumnsArr 	= acListclmVos;
		dataCorrectTitleWindow.controlsArr 		= arr;
		dataCorrectTitleWindow.ctable 			= objparam.ctable;
		CRMtool.openView(dataCorrectTitleWindow);
		
	},objparam)
		
	
}


/**
 * 	SZC Add 
 * 	提成批改功能
 */
protected function onDataDeduct():void{
	
	var ac:ArrayCollection = new ArrayCollection();
	ac = this.dgrd_person.getSelectRows();
	if(ac.length == 0){CRMtool.tipAlert("请选择需要数据批改的记录！");return;}
	for each(var item:Object in ac){
	  var sql:String="update sc_ctrpclose set istatus=0 where iid="+item.iid;
	  AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql",null ,sql);
	}
}
/**
 * 	SZC Add 
 * 	取消提成批改功能
 */
protected function onDataDeductESC():void{
	
	var ac:ArrayCollection = new ArrayCollection();
	ac = this.dgrd_person.getSelectRows();
	if(ac.length == 0){CRMtool.tipAlert("请选择需要数据批改的记录！");return;}
	for each(var item:Object in ac){
		var sql:String="update sc_ctrpclose set istatus=1 where iid="+item.iid;
		AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql",null ,sql);
	}
}
/**
 * 	LZX Add 20121106
 * 	短信发送功能
 */
protected function sendMessage():void{
	
	var ac:ArrayCollection = new ArrayCollection();
	ac = this.dgrd_person.getSelectRows();
//	if(ac.length == 0){CRMtool.tipAlert("请选择需要发送短信的职员！");return;}
	var arr:ArrayCollection = new ArrayCollection(CRMtool.ObjectCopy(ac.toArray())); 
	var abSmsVos:ArrayCollection = new ArrayCollection();
	
	var view_sendmessageWindow:view_sendmessage = new view_sendmessage();
	
	abSmsVos.removeAll();
	for each(var item:Object in arr) {
		item.iid = -1;
		item.ifuncregedit = this.itemObj.ifuncregedit;
		item.imaker = CRMmodel.userId;
		item.dmaker = new Date();
		item.cmobile = item.cmobile1;
		item.ctitle = item.cpstname;
		item.cpsnname = item.cname;
		item.istate = 0;
		abSmsVos.addItem(item);
	}
	if(this.itemObj.ifuncregedit == 32) {
		view_sendmessageWindow.dgDataSet = abSmsVos;
		view_sendmessageWindow.ifuncregedit = itemObj.ifuncregedit;
		AccessUtil.remoteCallJava("SendMessageDest","getLicense",function(evt:ResultEvent):void{
			var result:String = evt.result as String;
			if(result == "1") {
				CRMtool.tipAlert("您没有开通短信功能，请联系客服！");
				return;
			}else {
				CRMtool.openView(view_sendmessageWindow);
			}
		},null);
	}else if(this.itemObj.ifuncregedit == 93) {
		for each(var itemo:Object in abSmsVos) {
			itemo.ccusname = itemo.cscname;
			itemo.ctitle = itemo.cpost;
		}
		view_sendmessageWindow.dgDataSet = abSmsVos;
		view_sendmessageWindow.ifuncregedit = itemObj.ifuncregedit;
		AccessUtil.remoteCallJava("SendMessageDest","getLicense",function(evt:ResultEvent):void{
			var result:String = evt.result as String;
			if(result == "1") {
				CRMtool.tipAlert("您没有开通短信功能，请联系客服！");
				return;
			}else {
				CRMtool.openView(view_sendmessageWindow);
			}
		},null);
	}else if(this.itemObj.ifuncregedit == 179) {
		for each(var itemob:Object in abSmsVos) {
			itemob.ccusname = itemob.cname_UI6476;//列名比较别扭，是列表配置里的列名
			itemob.cpsnname = itemob.cperson_UI6479;
			itemob.cmobile = itemob.cmobile_UI6480;
			itemob.ctitle = itemob.ccharge;
		}
		view_sendmessageWindow.dgDataSet = abSmsVos;
		view_sendmessageWindow.ifuncregedit = itemObj.ifuncregedit;
		AccessUtil.remoteCallJava("SendMessageDest","getLicense",function(evt:ResultEvent):void{
			var result:String = evt.result as String;
			if(result == "1") {
				CRMtool.tipAlert("您没有开通短信功能，请联系客服！");
				return;
			}else {
				CRMtool.openView(view_sendmessageWindow);
			}
		},null);
	}
	
}

var me:FrameworkVBoxView = this as FrameworkVBoxView;

//lr 设置公共列表过滤颜色
private function setListColor():void{
    var colorSet:FrameListSetColorTitleWindow = new FrameListSetColorTitleWindow();
    if(me.acListclmVos){
        var showFieldList:ArrayCollection = new ArrayCollection();
        for each(var item:ListclmVo in me.acListclmVos){
            if(item.bshow)
                showFieldList.addItem(item);
        }
        if(showFieldList.length>0){
            colorSet.fieldList = showFieldList;
            colorSet.ifuncregedit = me.itemObj.ifuncregedit;
            colorSet.addEventListener("onClose",function(event:Event):void{
                me.dispatchEvent(new Event("colorSetChange"));
            });
            CRMtool.openView(colorSet);
        }
    }
}
//发票批量分配
private function bathAllotInvoice():void{
    var ac:ArrayCollection = this.dgrd_person.getSelectRows();
    if (ac.length == 0) {
        CRMtool.showAlert("请先选择数据。");
        return;
    }
    ServiceTool.bathAllotInvoice(moreLabel,ac);

}

//发票批量退领
private function bathReturnInvoice():void{
    var ac:ArrayCollection = this.dgrd_person.getSelectRows();
    if (ac.length == 0) {
        CRMtool.showAlert("请先选择数据。");
        return;
    }
    AccessUtil.remoteCallJava("InvoiceManager", "bathReturnInvoice", onExecImportBack, {billsList:ac,tableName:"tr_invoice",checkStatus:1},null,true);
}

//发票批量作废、遗失
private function bathCancelInvoice():void{
    var ac:ArrayCollection = this.dgrd_person.getSelectRows();
    if (ac.length == 0) {
        CRMtool.showAlert("请先选择数据。");
        return;
    }
    var newStatus:int = 4;//批量作废
    if(moreLabel == "批量遗失"){
        newStatus = 5;//批量遗失
    }
    AccessUtil.remoteCallJava("InvoiceManager", "bathCancelInvoice", onExecImportBack, {billsList:ac,tableName:"tr_invoice",newStatus:newStatus},null,true);
}
//批量审核收费单
private function bathVerifyCont():void{
    var ac:ArrayCollection = this.dgrd_person.getSelectRows();
    if (ac.length == 0) {
        CRMtool.showAlert("请先选择数据。");
        return;
    }
    var checkStatus:int = 0;
    var newStatus:int = 2;//批量审核
    if(moreLabel == "汇票已到"){
        checkStatus = 1;
        newStatus = 1;
    }
    if(moreLabel == "批量退审"){
        checkStatus = 2;
        newStatus = 0;
    }
    AccessUtil.remoteCallJava("ChargeManager", "bathVerifyCont", onExecImportBack, {billsList:ac,tableName:"tr_charge",checkStatus:checkStatus,newStatus:newStatus,operate:moreLabel,userId:CRMmodel.userId},null,true);
}
//批量生成交割单
private function bathToNewDelivery():void{
    var ac:ArrayCollection = this.dgrd_person.getSelectRows();
    if (ac.length == 0) {
        CRMtool.showAlert("请先选择数据。");
        return;
    }

    AccessUtil.remoteCallJava("ChargeManager", "bathToNewDelivery", onExecImportBack, {billsList:ac,tableName:"tr_charge",checkStatus:2,newStatus:3,operate:moreLabel,userId:CRMmodel.userId},null,true);
}

//代收费单生成收费单    
private function makeCharge():void{
    var ac:ArrayCollection = this.dgrd_person.getSelectRows();
    if (ac.length == 0) {
        CRMtool.showAlert("请先选择数据。");
        return;
    } else if (ac.length > 1) {
        CRMtool.showAlert("请逐条生成收费单。");
        return;
    } else {
        //CRMtool.showAlert(ac.length+"生成收费单");
        ServiceTool.createCharge(ac);

    }
}


//代回访记录生成回访单
//private function createFeedBack():void{
//	var ac:ArrayCollection = this.dgrd_person.getSelectRows();
//	if (ac.length == 0) {
//		CRMtool.showAlert("请先选择数据。");
//		return;
//	} else if (ac.length > 1) {
//		CRMtool.showAlert("请逐条生成回访单。");
//		return;
//	} else {
//		ServiceTool.createFeedBack(ac);
//		
//	}
//}

//反馈信息
private static function onExecImportBack(e:ResultEvent):void {
    var result:String = e.result + "";
    CRMtool.tipAlert(result+"");
}

//客商活动
private function toWorkdiary():void{
	var ac:ArrayCollection = this.dgrd_person.getSelectRows();
	if (ac.length == 0) {
		CRMtool.showAlert("请先选择数据。");
		return;
	} else if (ac.length > 1) {
		CRMtool.showAlert("请逐条生成收费单。");
		return;
	} else {
		//CRMtool.showAlert(ac.length+"生成收费单");
		ServiceTool.createWorkdiary(ac);
		
	}
}
//修改积分
public function updateBillFintegral():void{
	
	var ac:ArrayCollection = new ArrayCollection();
	ac = this.dgrd_person.getSelectRows();
	if(ac.length == 0){CRMtool.tipAlert("请选择需要修改的工单！");return;}
	
	var updateSrBillFintegralWindow:UpdateSrBillFintegralWindow = new UpdateSrBillFintegralWindow();
	
	updateSrBillFintegralWindow.myinit(ac);
}
//批量插入客商计划
public function insertOaWorkplan():void{
	
	var ac:ArrayCollection = new ArrayCollection();
	ac = this.dgrd_person.getSelectRows();
	if(ac.length == 0){CRMtool.tipAlert("请选择相应的客商！");return;}
	
	
	var iid:String="";
	for(var i:int=0;i<ac.length;i++){
		iid+=ac[i].iid+",";
	}
	var sql:String="select cc.ccode,cc.cname custcname,a3.cname  iindustry,a2.cname isalesstatus,a1.cname ivaluelevel,cc.iid "+
		"  from CS_customer cc "+
		" left join (select iid,ipid,ccode,cname,cabbreviation from aa_data where iclass=15)a1 on a1.iid=cc.ivaluelevel"+
		" left join (select iid,ipid,ccode,cname,cabbreviation from aa_data where iclass=16)a2 on a2.iid=cc.isalesstatus"+
		" left join (select iid,ipid,ccode,cname,cabbreviation from aa_data where iclass=10)a3 on a3.iid=cc.iindustry"+
		"  where cc.iid in("+iid.substring(0,iid.length-1)+")";
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
		var asc:ArrayCollection =event.result as  ArrayCollection;
		var insertOaWorkPlanTitleWindow:InsertOaWorkPlanTitleWindow = new InsertOaWorkPlanTitleWindow();
		var obj:Object=new Object();
		obj.asc=asc;
		insertOaWorkPlanTitleWindow.myinit(obj);
		
	}, sql);
}
//插入活动人员
public function insertMarkets():void{
	
	var ac:ArrayCollection = new ArrayCollection();
	ac = this.dgrd_person.getSelectRows();
	if(ac.length == 0){CRMtool.tipAlert("请选择相应的客商！");return;}
	var iid:String="";
	for(var i:int=0;i<ac.length;i++){
		iid+=ac[i].iid+",";
	}
	var sql:String="select cc.ccode,cc.cname custcname,a3.cname  iindustry,a2.cname isalesstatus,a1.cname ivaluelevel,cp.cname personname,"+
                           " cp.cpost,cp.cdepartment,cc.cmobile1,cp.ctel,cp.cqqmsn,cp.cemail,cp.icustomer,cp.iid cpiid from cs_custperson cp"+
                           " left join CS_customer cc on cc.iid=cp.icustomer"+
                           " left join (select iid,ipid,ccode,cname,cabbreviation from aa_data where iclass=15)a1 on a1.iid=cc.ivaluelevel"+
                           " left join (select iid,ipid,ccode,cname,cabbreviation from aa_data where iclass=16)a2 on a2.iid=cc.isalesstatus"+
                           " left join (select iid,ipid,ccode,cname,cabbreviation from aa_data where iclass=10)a3 on a3.iid=cc.iindustry"+
                           "  where cp.icustomer in("+iid.substring(0,iid.length-1)+")";
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
		var asc:ArrayCollection =event.result as  ArrayCollection;
		var insertMrMarketsTitleWindow:InsertMrMarketsTitleWindow = new InsertMrMarketsTitleWindow();
		var obj:Object=new Object();
		obj.asc=asc;
		obj.ac=ac.length;
		insertMrMarketsTitleWindow.myinit(obj);
		
	}, sql);	
}
//插入服务申请
public function insertRequest():void{
	
	var ac:ArrayCollection = new ArrayCollection();
	ac = this.dgrd_person.getSelectRows();
	if(ac.length == 0){CRMtool.tipAlert("请选择相应的客商！");return;}
	var iid:String="";
	for(var i:int=0;i<ac.length;i++){
		iid+=ac[i].iid+",";
	}
	var sql:String="select cp.iid,cc.ccode,cc.cname custcname,cc.cofficeaddress,cp.cname personname,"+
		" cp.cpost,cp.cdepartment,cc.cmobile1,cp.ctel,cp.icustomer from cs_custperson cp"+
		" left join CS_customer cc on cc.iid=cp.icustomer"+
		"  where cp.icustomer in("+iid.substring(0,iid.length-1)+")";
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
		var asc:ArrayCollection =event.result as  ArrayCollection;
		var insertServiceRequestTitleWindow:InsertServiceRequestTitleWindow = new InsertServiceRequestTitleWindow();
		var obj:Object=new Object();
		obj.asc=asc;
		obj.ac=ac.length;
		insertServiceRequestTitleWindow.myinit(obj);
		
	}, sql);
}

//多方通话用户上传
public  function uploadPerson():void {
	 var ac:Object = this.dgrd_person.dataProvider
	 var param:Object = new Object();
	param.ac=ac;
	AccessUtil.remoteCallJava("LotCommunicate", "uploadPerson", function (event:ResultEvent):void {
	//CRMtool.tipAlert("一共上传了 "+event.result.result+" 位职员！");
	}, param,"多方通话用户上传中....");
}

//多方会议
/*
public function communication():void {
    var comm:Communication = new Communication();
    comm.width = 800;
    comm.height = 500;
    CRMtool.openView(comm,true,null,false);

    comm.addEventListener("onSubmit",function(event:Event):void {
        if(comm.personlist.length == 0) {
            CRMtool.showAlert("请选择联系人员！");
            return;
        }
        var param:Object = new Object();
        param.user = CRMmodel.hrperson;
        param.personlist = comm.personlist;

        AccessUtil.remoteCallJava("LotCommunicate", "communicate", function (event:ResultEvent):void {
            CRMtool.showAlert("多方会议通话中....");
        }, param,"多方会议通话中....");
    });

}
*/