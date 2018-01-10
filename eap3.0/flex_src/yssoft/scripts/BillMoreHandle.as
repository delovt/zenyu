/*
模块名称：更多操作
模块功能：业务单据中更多操作按钮对应的操作脚本

创建者：        YJ
创建日期：   2011-10-24
修改者：
修改日期：

*/

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.media.Sound;
import flash.net.URLLoader;
import flash.net.URLRequest;

import flashx.textLayout.formats.Float;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.DataGrid;
import mx.controls.List;
import mx.controls.Menu;
import mx.controls.PopUpButton;
import mx.core.IFlexDisplayObject;
import mx.core.ScrollPolicy;
import mx.events.FlexEvent;
import mx.events.MenuEvent;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.utils.ObjectUtil;
import mx.utils.StringUtil;

import spark.components.DropDownList;
import spark.events.DropDownEvent;
import spark.events.IndexChangeEvent;

import yssoft.business.AcNumberHandleClass;
import yssoft.comps.frame.module.CrmEapDataGrid;
import yssoft.comps.frame.module.CrmEapRadianVbox;
import yssoft.comps.frame.module.CrmEapTextInput;
import yssoft.frameui.ShareRateInvoiceprocessWindow;
import yssoft.models.CRMmodel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.tools.DateUtil;
import yssoft.tools.InvoicesMoreHandle;
import yssoft.tools.ServiceTool;
import yssoft.views.billMoreViews.CloseSrBillTitleWindow;
import yssoft.views.billMoreViews.TrainApplyActionTitleWindow;
import yssoft.views.billMoreViews.UpdateBillTitleWindow;
import yssoft.views.billMoreViews.UpdateCaruseWindow;
import yssoft.views.billMoreViews.UpdateOpportunityTitleWindow;
import yssoft.views.billMoreViews.UpdateSrProjectsTitleWindow;
import yssoft.views.billMoreViews.UpdateSupportFeedbackTitleWindow;
import yssoft.views.billMoreViews.UpdateSupportTitleWindow;
import yssoft.views.billMoreViews.sale.CheckSalesTitleWindow;
import yssoft.views.billMoreViews.sale.ReCheckSalesTitleWindow;
import yssoft.views.callcenter.Mp3PlayerPro;
import yssoft.views.moreHandleViews.MoreHandleTW;
import yssoft.views.moreHandleViews.view_cmnemonic;
import yssoft.views.moreHandleViews.view_customer;
import yssoft.views.moreHandleViews.view_oaleave;
import yssoft.views.moreHandleViews.view_oatravel;
import yssoft.views.moreHandleViews.view_prconfirm;
import yssoft.views.notice.NoticePush;
import yssoft.views.notice.SendQuestion;
import yssoft.views.plan.BookLink;

/**
 *  YJ Add 以下是窗体的实例对象，声明一下就可以
 **/


private var viewoaleave:view_oaleave = null;//请假
private var viewoatravel:view_oatravel = null;//业务出差

//End

[Bindable]
public var windowName:String = "";//记录弹出窗体的全路径 "yssoft.views.moreHandleViews.view_oatravel"

[Bindable]
public var ccode:String = "";//权限编码

[Bindable]
public var imh:InvoicesMoreHandle = new InvoicesMoreHandle();

public var myMenu:Menu;
[Bindable]
public var arr_MoreMenu:ArrayCollection = new ArrayCollection();

[Bindable]
public var view_customWindow:view_customer = null;

[Bindable]
public var view_pronfirm:view_prconfirm = null;

[Bindable]
public var view_cmm:view_cmnemonic = null;


/**
 *      YJ Add 2011-10-25
 *      初始化更多操作菜单之前的操作
 *      依据单据注册内码获取权限设置中对应的相关信息(内码、注册内码、编码、标题、方法名、窗体路径)
 * */
public function iniMoreMenuBefore():void {
	
	//if(this.operauthArr == null) return;//如果操作权限为空直接返回
	if (this.formIfunIid == 0) return;//注册内码为零为无效数据，直接返回
	
	//AccessUtil.remoteCallJava("AuthcontentDest", "getListByIfuncregedit", onGetDataListBack, this.formIfunIid);
	
}

private function onGetDataListBack(evt:ResultEvent):void {
	
	arr_MoreMenu = evt.result as ArrayCollection;
	
	if (arr_MoreMenu.length == 0) return;
	
	//  iniMoreMenu();
	iniMoreMenu2();
	
}


//初始化更多操作中的菜单项  YJ Note 2012-04-25 暂不删除
public function iniMoreMenu2():void {
	
	try {
		this.hb_morehandle.removeAllChildren();
		var ppb:PopUpButton = new PopUpButton();
		myMenu = new Menu();
		
		myMenu.dataProvider = this.arr_MoreMenu;
		myMenu.variableRowHeight = true;
		myMenu.addEventListener(MenuEvent.CHANGE, menu_change);
		
		ppb.addEventListener(MouseEvent.ROLL_OUT, function (event:MouseEvent):void {
			if (event.stageX < myMenu.x || event.stageY < myMenu.y)
				ppb.close();
		});
		myMenu.addEventListener(MouseEvent.ROLL_OUT, function (event:MouseEvent):void {
			if (event.stageX < myMenu.x || event.stageX > myMenu.x + ppb.width || event.stageY < myMenu.y - ppb.height || event.stageY > myMenu.y + myMenu.height)
				ppb.close();
		});
		
		
		ppb.label = "更多";
		ppb.openAlways = true;
		ppb.height = 25;
		ppb.width = 60;
		ppb.popUp = myMenu;
		ppb.popUp.width = ppb.width + 40;
		ppb.focusEnabled = false;
		ppb.styleName = "popupbuttonskin1";
		
		this.hb_morehandle.addChild(ppb);
		this.hb_morehandle.visible = true;
		
	} catch (err:Error) {
		trace(err.getStackTrace());
	}
}

private function iniMoreMenu():void {
	
	this.hb_morehandle.removeAllChildren();
	var ddl:DropDownList = new DropDownList();
	
	ddl.prompt = "更多操作";
	ddl.selectedIndex = -1;
	ddl.dataProvider = this.arr_MoreMenu;
	ddl.height = 25;
	ddl.width = 100;
	ddl.labelField = "label";
	
	
	//  ddl.addEventListener(DropDownEvent.OPEN,dropDownListOpen);
	ddl.addEventListener(IndexChangeEvent.CHANGE, indexChange);
	
	this.hb_morehandle.addChild(ddl);
	this.hb_morehandle.visible = true;
	
}

//设置滚动条隐藏
private function dropDownListOpen(evt:DropDownEvent):void {
	
	(evt.target as DropDownList).scroller.setStyle("horizontalScrollPolicy", ScrollPolicy.OFF);
	(evt.target as DropDownList).scroller.setStyle("verticalScrollPolicy", ScrollPolicy.OFF);
	
}

//菜单改变事件
private function indexChange(evt:IndexChangeEvent):void {
	
	//单据增加或修改状态下不允许操作
	if (this.curButtonStatus == "onNew" || this.curButtonStatus == "onEdit") {
		CRMtool.tipAlert("单据只有在浏览状态下才可以使用该功能！");
		return;
	}
	
	if (this.currid == 0) {
		CRMtool.tipAlert("当前单据不能为空值，操作无效！");
		return;
	}
	
	var acptddl:DropDownList = evt.target as DropDownList;
	var selectObj:Object = acptddl.selectedItem;
	
	this.ccode = selectObj.ccode;
	this.windowName = selectObj.cform;//窗体路径赋值
	
	//加入权限
	var warning:String = this.auth.reuturnwarning(ccode);
	if (warning != null) {
		CRMtool.showAlert(warning);
		return;
	}
	
	try {
		if (selectObj.cfunction == null) return;
		
		this[selectObj.cfunction].call();//调用方法
		
	}
	catch (e:Error) {
		CRMtool.tipAlert("请配置相关参数");
	}
}

//菜单改变事件
private function menu_change(evt:MenuEvent):void {
	
	//单据增加或修改状态下不允许操作
	if (this.curButtonStatus == "onNew" || this.curButtonStatus == "onEdit") {
		CRMtool.tipAlert("单据只有在浏览状态下才可以使用该功能！");
		return;
	}
	if (this.currid == 0) {
		CRMtool.tipAlert("当前单据不能为空值，操作无效！");
		return;
	}
	this.ccode = evt.item.ccode;//权限编码
	this.windowName = evt.item.cform;//窗体路径赋值
	
	//加入权限
	var warning:String = this.auth.reuturnwarning(ccode);
	if (warning != null) {
		CRMtool.showAlert(warning);
		return;
	}
	
	try {
		var cfunction:String = evt.item.cfunction;
		if (CRMtool.isStringNull(cfunction))
			return;
		
		//lr 修改，功能按钮支持传参，目前只支持一个参数，可以是字符串，目前针对功能是公共功能，推式生单 eapPushForm
		if (cfunction.indexOf(",") > -1) {
			var param:String = cfunction.substr(cfunction.indexOf(",") + 1);
			this[cfunction.substr(0, cfunction.indexOf(","))].call(this, param);//调用方法
		} else {
			this[cfunction].call();//调用方法
		}
		
	}
	catch (e:Error) {
		CRMtool.tipAlert("请配置相关参数");
	}
}

//选择菜单时权限判断
private function onIsHandle():Boolean {
	
	this.auth.reuturnwarning(ccode);
	return false;
}

private function onPopupForm():void {
	if (this.currid == 0) {
		CRMtool.tipAlert("当前单据不能为空值，操作无效！");
		return;
	}
	var titlewindow:Object = {};
	
	if (windowName == "") return;
	
	titlewindow = CRMtool.createObjectByClassName(windowName);
	titlewindow.owner = this;
	
	PopUpManager.addPopUp(titlewindow as IFlexDisplayObject, this, true);
	PopUpManager.centerPopUp(titlewindow as IFlexDisplayObject);
	
}

//lr 公共推式生单  param是单据关系配置 主键   iid是当前单据主键
private function eapPushForm(param:String):void {
	var mainValue:Object = crmeap.getValue();	
	
	if(param == '157' || param == '142') {
		var istatus:int = mainValue.istatus;
		if(istatus == 416) {
			CRMtool.showAlert("订单已关闭，不能进行此操作！");
			return;
		}
	}





	
	var iid = mainValue.iid;
	var irelationship = param;
	AccessUtil.remoteCallJava("UtilViewDest", "getPushFormData", getPushFormDataBack, {iid: iid, irelationship: irelationship});
}

//公共求和方法
private function onSum(tableArr:ArrayCollection, pfield:String, field:String):Object {
	
	
	var sum:Number = 0;
	//传出参数
	var outparam:String = "";
	
	//汇总
	for (var i:int = 0; i < tableArr.length; i++) {
		var item:Object = tableArr.getItemAt(i);
		var tsum:Number = item[pfield];
		sum += tsum;
	}
	outparam = pfield.substr(pfield.indexOf(".") + 1, pfield.length) + "=" + sum;
	return outparam;
}

private function constraintFormula(cresfunction:String, cresmessage:String, result:Object):void {
	var mainValue:Object = crmeap.getValue();
	//先解析约束公式，找出字段名称
	var objInfo:Object = ObjectUtil.getClassInfo(mainValue);
	var fieldName:Array = objInfo["properties"] as Array;
	for each(var q:QName in fieldName) {
		if (mainValue[q.localName] is ArrayCollection) {
			var childValueArr:ArrayCollection = mainValue[q.localName] as ArrayCollection;
			var childobjInfo:Object = ObjectUtil.getClassInfo(childValueArr.getItemAt(0));
			var childfieldName:Array = childobjInfo["properties"] as Array;
			for each(var qchild:QName in childfieldName) {
				//求和
				if (cresfunction.indexOf("getcolsum(@" + q.localName + "." + qchild.localName + "@)") != -1) {
					cresfunction = crmeap.StringReplaceAll(cresfunction,
						"getcolsum(@" + q.localName + "." + qchild.localName + "@)",
						onGetColValue(childValueArr, qchild.localName, "onGetColValue").toString());
				}
					//求平均
				else if (cresfunction.indexOf("getcolavg(@" + q.localName + "." + qchild.localName + "@)") != -1) {
					cresfunction = crmeap.StringReplaceAll(cresfunction,
						"getcolavg(@" + q.localName + "." + qchild.localName + "@)",
						onGetColValue(childValueArr, qchild.localName, "getcolavg").toString());
				}
					//求最大值
				else if (cresfunction.indexOf("getcolmax(@" + q.localName + "." + qchild.localName + "@)") != -1) {
					cresfunction = crmeap.StringReplaceAll(cresfunction,
						"getcolmax(@" + q.localName + "." + qchild.localName + "@)",
						onGetColValue(childValueArr, qchild.localName, "getcolmax").toString());
				}
					//求最小值
				else if (cresfunction.indexOf("getcolmin(@" + q.localName + "." + qchild.localName + "@)") != -1) {
					cresfunction = crmeap.StringReplaceAll(cresfunction,
						"getcolmin(@" + q.localName + "." + qchild.localName + "@)",
						onGetColValue(childValueArr, qchild.localName, "getcolmin").toString());
				}
			}
		}
		else {
			if (cresfunction.indexOf("@" + q.localName + "@") != -1) {
				cresfunction = crmeap.StringReplaceAll(cresfunction, "@" + q.localName + "@", mainValue[q.localName]);
			}
		}
	}
	var sql:String = "select case when " + cresfunction + " then 1 else 0 end as value";
	AccessUtil.remoteCallJava("hrPersonDest", "verificationSql", function (evt:ResultEvent):void {
		var rArr:ArrayCollection = evt.result as ArrayCollection;
		if (rArr == null || rArr.length == 0) {
			return;
		}
		if (rArr.getItemAt(0).value == 0) {
			CRMtool.tipAlert(cresmessage);
		}
		else {
			var paramObj:Object = new Object();
			
			paramObj.isPush = true;//推式生单标记  在公共单据列表中 会检查此变量
			paramObj.ifuncregedit = crmeap.getValue().iifuncregedit;
			paramObj.iinvoice = crmeap.getValue().iid;
			
			
			var relationship:Object = result.relationship;
			var relationshipsList:ArrayCollection = result.relationshipsList;
			var tableMessage:ArrayCollection = result.tableMessage;
			
			for each(var table:Object in tableMessage) {
				if (table.bMain && (table.ctable2 == "null" || table.ctable2 == "")) {//主表
					for each(var ritem:Object in relationshipsList) {
						if (table.ctable == ritem.ctable2) {
							var formValue:Object = (ritem.formValue as ArrayCollection).getItemAt(0);
							paramObj[ritem.cfield2] = formValue[ritem.cfield];
							paramObj.ifunconsult = ritem.ctable;
						}
					}
				} else {
					for each(var ritem:Object in relationshipsList) {
						if (table.ctable == ritem.ctable2) {//代入数据 含有子表
							if (!paramObj.hasOwnProperty(table.ctable)) {//尚未注入此子表数据
								var childTable = new ArrayCollection();//最终要注入的数据集
								var childDataList:ArrayCollection = ritem.formValue;//为此子表提供的数据
								
								for each(var childItem:Object in childDataList) {
									var obj:Object = new Object();
									for each(var ritem3:Object in relationshipsList) {
										if (ritem3.ctable2 == table.ctable) {
											obj[ritem3.cfield2] = childItem[ritem3.cfield];
										}
									}
									obj.iinvoices = childItem.iid;
									childTable.addItem(obj);
								}
								paramObj[table.ctable] = childTable;
							}
						}
					}
				}
			}
			
			var param:Object = new Object();
			param.ifuncregedit = relationship.ifuncregedit;
			param.itemType = "onNew";
			param.operId = "onListNew";
			param.formTriggerType = "fromOther";
			param.injectObj = paramObj;
			var iid:ArrayCollection = new ArrayCollection();
			param.personArr = iid;
			
			CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param);
		}
	}, sql, null, false);
}


private function onGetColValue(tableList:ArrayCollection, cfield:String, cfunction:String):Number {
	var num:Number = 0;
	var cfieldNum:Number = 0;
	for (var i:int = 0; i < tableList.length; i++) {
		var tableObject:Object = tableList.getItemAt(i);
		if (CRMtool.isStringNotNull(tableObject[cfield])) {
			cfieldNum = tableObject[cfield] as Number;
		}
		else {
			cfieldNum = 0.0;
		}
		if (cfunction.indexOf("getcolsum") != -1
			|| cfunction.indexOf("getcolavg") != -1) {
			num += cfieldNum;
		} else if (cfunction.indexOf("getcolmax") != -1) {
			if (num == 0 || cfieldNum > num) {
				num = cfieldNum;
			}
		} else if (cfunction.indexOf("getcolmin") != -1) {
			if (num == 0 || cfieldNum < num) {
				num = cfieldNum;
			}
		}
	}
	return num;
}

private function checkCount(cresfunction:String, cresmessage:String, result:Object):void {
	var relationship:Object = result.relationship;
	var mainValue:Object = crmeap.getValue();
	var param:Object = new Object();
	param.ifuncregedit = mainValue.iifuncregedit;
	param.iinvoice = mainValue.iid;
	param.ifuncregedit2 = relationship.ifuncregedit;
	param.cfield = "bRepeatedly";
	AccessUtil.remoteCallJava("UtilViewDest", "isRepeatedly", function (evt:ResultEvent):void {
		var isfind:Boolean = evt.result as Boolean;
		if (isfind) {
			if (CRMtool.isStringNotNull(cresfunction)) {
				constraintFormula(cresfunction, cresmessage, result);
			}
			else {
				var paramObj:Object = new Object();
				
				paramObj.isPush = true;//推式生单标记  在公共单据列表中 会检查此变量
				paramObj.ifuncregedit = crmeap.getValue().iifuncregedit;
				paramObj.iinvoice = crmeap.getValue().iid;
				
				
				var relationship:Object = result.relationship;
				var relationshipsList:ArrayCollection = result.relationshipsList;
				var tableMessage:ArrayCollection = result.tableMessage;
				
				for each(var table:Object in tableMessage) {
					if (table.bMain && (table.ctable2 == "null" || table.ctable2 == "")) {//主表
						for each(var ritem:Object in relationshipsList) {
							if (table.ctable == ritem.ctable2) {
								var formValue:Object = (ritem.formValue as ArrayCollection).getItemAt(0);
								paramObj[ritem.cfield2] = formValue[ritem.cfield];
								paramObj.ifunconsult = ritem.ctable;
							}
						}
					} else {
						for each(var ritem:Object in relationshipsList) {
							if (table.ctable == ritem.ctable2) {//代入数据 含有子表
								if (!paramObj.hasOwnProperty(table.ctable)) {//尚未注入此子表数据
									var childTable = new ArrayCollection();//最终要注入的数据集
									var childDataList:ArrayCollection = ritem.formValue;//为此子表提供的数据
									
									for each(var childItem:Object in childDataList) {
										var obj:Object = new Object();
										for each(var ritem3:Object in relationshipsList) {
											if (ritem3.ctable2 == table.ctable) {
												obj[ritem3.cfield2] = childItem[ritem3.cfield];
											}
										}
										obj.iinvoices = childItem.iid;
										childTable.addItem(obj);
									}
									paramObj[table.ctable] = childTable;
								}
							}
						}
					}
				}
				
				var param:Object = new Object();
				param.ifuncregedit = relationship.ifuncregedit;
				param.itemType = "onNew";
				param.operId = "onListNew";
				param.formTriggerType = "fromOther";
				param.injectObj = paramObj;
				var iid:ArrayCollection = new ArrayCollection();
				param.personArr = iid;
				
				CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param);
			}
		}
		else {
			CRMtool.tipAlert("该单据只能被引用过一次，不能在生成下游单据。");
		}
	}, param, null, false);
}


private function getPushFormDataBack(e:ResultEvent):void {
	var result:Object = e.result;
	if (CRMtool.isStringNotNull(result.errorStr)) {
		CRMtool.showAlert(result.errorStr);
		return;
	}
	var relationship:Object = result.relationship;
	/****************** update by zhong_jing 为了解决限定推单的次数 begin  *************************/
	var cresfunction:String = relationship.cresfunction;
	var cresmessage:String = relationship.cresmessage;
	var bRepeatedly:String = relationship.bRepeatedly;
	if (bRepeatedly == null || bRepeatedly == "0" || bRepeatedly == "false") {
		checkCount(cresfunction, cresmessage, result);
	}
	else if (CRMtool.isStringNotNull(cresfunction)) {
		constraintFormula(cresfunction, cresmessage, result);
	}
	/****************** update by zhong_jing 为了解决限定推单的次数 end  *************************/
	else {
		var paramObj:Object = new Object();
		
		paramObj.isPush = true;//推式生单标记  在公共单据列表中 会检查此变量
		paramObj.ifuncregedit = crmeap.getValue().iifuncregedit;
		paramObj.iinvoice = crmeap.getValue().iid;
		
		
		var relationship:Object = result.relationship;
		var relationshipsList:ArrayCollection = result.relationshipsList;
		var tableMessage:ArrayCollection = result.tableMessage;
		
		for each(var table:Object in tableMessage) {
			if (table.bMain && (table.ctable2 == "null" || table.ctable2 == "")) {//主表
				for each(var ritem:Object in relationshipsList) {
					if (table.ctable == ritem.ctable2) {
						var formValue:Object = (ritem.formValue as ArrayCollection).getItemAt(0);
						paramObj[ritem.cfield2] = formValue[ritem.cfield];
						paramObj.ifunconsult = ritem.ctable;
					}
				}
			} else {
				for each(var ritem:Object in relationshipsList) {
					if (table.ctable == ritem.ctable2) {//代入数据 含有子表
						if (!paramObj.hasOwnProperty(table.ctable)) {//尚未注入此子表数据
							var childTable = new ArrayCollection();//最终要注入的数据集
							var childDataList:ArrayCollection = ritem.formValue;//为此子表提供的数据
							
							for each(var childItem:Object in childDataList) {
								var obj:Object = new Object();
								for each(var ritem3:Object in relationshipsList) {
									if (ritem3.ctable2 == table.ctable) {
										obj[ritem3.cfield2] = childItem[ritem3.cfield];
									}
								}
								obj.iinvoices = childItem.iid;
								childTable.addItem(obj);
							}
							paramObj[table.ctable] = childTable;
						}
					}
				}
			}
		}
		
		var param:Object = new Object();
		param.ifuncregedit = relationship.ifuncregedit;
		param.itemType = "onNew";
		param.operId = "onListNew";
		param.formTriggerType = "fromOther";
		param.injectObj = paramObj;
		var iid:ArrayCollection = new ArrayCollection();
		param.personArr = iid;
		
		CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param);
	}
}

/**
 * 密码重置  SDY
 */
private function passwordReset():void {
	CRMtool.tipAlert("确定要重置当前用户密码吗 ？", null, "AFFIRM", this, "updatepwd");
}

public function updatepwd():void {
	var params:Object = {};
	params.iid = this.currid;
	params.resetFlag = true;
	AccessUtil.remoteCallJava("hrPersonDest", "modityResetPwd", call_fun_result_1, params);
}
//修改密码回调
private function call_fun_result_1(e:ResultEvent):void {
	if (e.result == "success") {
		CRMtool.tipAlert("密码重置成功！");
		PopUpManager.removePopUp(this);
	}
	else {
		CRMtool.tipAlert("密码重置异常！");
	}
}

/*
*销售回款，卡片，取消审核
*/
private function onUnapproved():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	if(myMainValue.istatus==2){
	var sql:String="update sc_rpinvoice set istatus=1 where iid="+myMainValue.iid;
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql",null ,sql);
	var obj:Object=new Object();
	myMainValue.istatus=1;
	obj.mainValue=myMainValue;
	crmeap.setValue(obj,1,1);
	CRMtool.showAlert("取消审核成功！");
	}else{
		CRMtool.showAlert("单据状态不是审核状态！");
		return;
	}
}

/*
*销售回款，卡片，审核
*/
private function onCheck():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	var obj:CrmEapRadianVbox=this.crmeap;
	if(myMainValue.istatus==2 || myMainValue.istatus==5 || myMainValue.istatus==4){
		CRMtool.showAlert("单据已审核，或者已经核销完毕！");
		return;
	}
	
	     	CRMtool.tipAlert1("是否审核?",null,"AFFIRM",function():void{
			      var sql:String="update sc_rpinvoice set istatus=2 where iid="+myMainValue.iid;
			      AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql",null ,sql);
				  
				  var obj1:Object=new Object();
				  myMainValue.istatus=2;
				  obj1.mainValue=myMainValue;
				  crmeap.setValue(obj1,1,1);
	     	});
}

/*
*销售回款，卡片，核销
*/

private function onCheckSales():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	if(myMainValue.istatus==1 ){
		CRMtool.showAlert("单据审核后才能核销！");
		return;
	}
	if(myMainValue.istatus==4 || myMainValue.istatus==5){
		CRMtool.showAlert("单据已经核销！");
		return;
	}
	if (myMainValue.hasOwnProperty("icustomer") && myMainValue.hasOwnProperty("fmoney") && myMainValue.hasOwnProperty("iid")) {
		var irpinvoice:int = myMainValue.iid;
		var iifuncregedit:int = myMainValue.iifuncregedit;
		var icustomer:int = myMainValue.icustomer;
		var fmoney:Number = parseFloat(myMainValue.fmoney);
		var fclosemoney:Number = parseFloat(myMainValue.fclosemoney);
		var sc_ctrpclosetable:ArrayCollection = myMainValue.sc_ctrpclose;//核销子表
		
		if (fclosemoney == fmoney) {
			CRMtool.showAlert("禁止核销。原因：回款金额分配完毕.");
			return;
		}
		
		if (icustomer != 0) {
			var checkSalesTitleWindow:CheckSalesTitleWindow = new CheckSalesTitleWindow();
			checkSalesTitleWindow.init(icustomer, fmoney, irpinvoice, iifuncregedit, sc_ctrpclosetable, this.crmeap);
			CRMtool.openView(checkSalesTitleWindow);
		}
	} else {
		CRMtool.showAlert("缺少必要参数，请重新打开此卡片再试。");
	}
	
}

/*
*销售回款，卡片，取消核销
*/

private function onReCheckSales():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	if(myMainValue.istatus==1 || myMainValue.istatus==2){
		CRMtool.showAlert("该单据未完成核销操作，不能取消核销！");
		return;
	}
	if (myMainValue.hasOwnProperty("sc_ctrpclose")) {
		var irpinvoice:int = myMainValue.iid;
		var sc_ctrpclosetable:ArrayCollection = myMainValue.sc_ctrpclose;//当前子表
		if (sc_ctrpclosetable.length > 0) {
			var reCheckSalesTitleWindow:ReCheckSalesTitleWindow = new ReCheckSalesTitleWindow();
			reCheckSalesTitleWindow.init(sc_ctrpclosetable, irpinvoice, this.crmeap);
			CRMtool.openView(reCheckSalesTitleWindow);
		}
		else {
			CRMtool.showAlert("此回款单没有已核销记录。");
		}
	}
}


//由服务请求单生成服务派工单 YJ Add 2012-04-05  
//lr modify  先验证，在生单
//wxh modify 20130110
private function onCreateSrBillByRequest():void {
	
	var value:Object = this.crmeap.getValue() as Object;
	
	var iid:int = value.iid;
	var istatus:int = value.istatus;
	
	
	var sql:String = "select istatus from sr_request where iid = " + iid;
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
		var list:ArrayCollection = event.result as ArrayCollection;
		if (list && list.length > 0) {
			var istatus:int = list[0].istatus;
			if(istatus == 3){
				CRMtool.showAlert("服务申请已关闭，不能进行该操作！");
				return;
			}
			else {
				//wxh add
				var sql:String = "select*from aa_data where iclass = 70 and iid = " + value.isolution;
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (result:ResultEvent):void {
					AcNumberHandleClass.ccode = result.result[0].cabbreviation;
				}, sql)
				//查询对应的服务工单是否存在
				AccessUtil.remoteCallJava("CallCenterDest", "getSrbilloniinvoice", onCreateSrBillByRequestBack, {ccfunid: value.iifuncregedit, ccid: value.iid});
			}
		}
	}, sql);
	
	
}

private function onCreateSrBillByRequestBack(event:ResultEvent):void {
	if (event.result) {
		var srbillAc:ArrayCollection = event.result as ArrayCollection;
		if (srbillAc.length == 0) {
			var param:Object = {};//总体需要传入参数
			var srbillParam:Object = {};//服务派工单所需对象
			var srrequestObj:Object = {};//承载服务请求单中的对象
			
			//获取服务请求单中的全部数据
			srrequestObj = this.crmeap.getValue();
			if (null == srrequestObj) return;
			
			if (srrequestObj.istatus == 1) {
				CRMtool.tipAlert("当前服务申请单已经派单,无法再生成服务派工单!请重新选择!");
				return;
			}
			
			if (srrequestObj.icustproduct == null)
				srrequestObj.icustproduct = 0;
			
			var sql:String = "select csn from cs_custproduct where iid=" + srrequestObj.icustproduct;
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
				var eventAC:ArrayCollection = event.result as ArrayCollection;
				
				if (eventAC && eventAC.length > 0) {
					srbillParam.cproductno = eventAC[0].csn as String;
				}
				
				//服务派工单所需要的参数
				srbillParam.ifuncregedit = "149";//相关单据类型
				srbillParam.iinvoice = srrequestObj.iid;//相关单据内码(当前服务请求单内码)
				srbillParam.isolution = srrequestObj.isolution;//处理方式
				srbillParam.icustomer = srrequestObj.icustomer;//客户ID
				srbillParam.icustperson = srrequestObj.icustperson;//联系人ID
				srbillParam.ctel = srrequestObj.ctel;//联系电话
				srbillParam.caddress = srrequestObj.caddress;//客户地址
				srbillParam.daskprocess = srrequestObj.daskprocess;//预约时间
				srbillParam.cdetail = srrequestObj.cdetail;//详细情况
				srbillParam.icustproduct = srrequestObj.icustproduct;//服务产品
				srbillParam.imaker = CRMmodel.userId;//制单人
				srbillParam.istatus = 1;
				srbillParam.iengineer = srrequestObj.iengineer;
				srbillParam.dsend= srrequestObj.dsend;//服务到期日
				srbillParam.cdescription = srrequestObj.cdetail; //问题描述     服务申请的工单描述 
				
				//查询客户档案中的部门(update by zhong_jing )
				var sql2:String ="select iservicesdepart from cs_customer where iid="+srrequestObj.icustomer;
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
					//服务部门
					var idepartmentArr:ArrayCollection = event.result as ArrayCollection;
					var idepartment:int = idepartmentArr.getItemAt(0).iservicesdepart;
					srbillParam.idepartment= idepartment;
					
					//打开服务工单所需参数(页面创建参数)
					param.ifuncregedit = "150";
					param.ctable = "sr_bill";
					param.itemType = "onNew";
					param.operId = "onListNew";
					param.formTriggerType = "fromOther";
					param.srbillObj = srbillParam;
					var iid:ArrayCollection = new ArrayCollection();
					param.personArr = iid;
					
					CRMtool.removeChildFromViewStack();
					CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "服务工单", "");
				}, sql2);
				
			}, sql);
			
		} else {
			CRMtool.showAlert("已经生成服务工单，不允许再次生成。");
		}
	}
}

//add by zhong_jing
private function openWorkdiary():void {
	var param:Object = new Object();
	param.ifuncregedit = "46";
	param.ctable = "oa_workdiary";
	param.itemType = "onNew";
	param.operId = "onListNew";
	param.formTriggerType = "fromOther";
	var paramObj:Object = new Object();
	paramObj.icustomer = this.crmeap.getValue().iid;
	param.injectObj = paramObj;
	var iid:ArrayCollection = new ArrayCollection();
	param.personArr = iid;
	
	CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "工作日志", "");
}


private function openWorkdiaryPage():void {
	var param:Object = new Object();
	param.ifuncregedit = "46";
	param.ctable = "oa_workdiary";
	param.itemType = "onNew";
	param.operId = "onListNew";
	param.formTriggerType = "fromOther";
	var paramObj:Object = new Object();
	paramObj.icustomer = this.crmeap.getValue().icustomer;
	paramObj.icustperson = this.crmeap.getValue().icustperson;
	paramObj.ifuncregedit = this.crmeap.getValue().iifuncregedit;//相关单据
	paramObj.iinvoice = this.crmeap.getValue().iid;//单价代码
	param.injectObj = paramObj;
	var iid:ArrayCollection = new ArrayCollection();
	param.personArr = iid;
	
	CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "工作日志", "");
}

//服务申请单，撤销生成服务工单
private function onBackCreateSrBillByRequest():void {
	var value:Object = this.crmeap.getValue() as Object;
	
	var iid:int = value.iid;
	var istatus:int = value.istatus;
	
	
	var sql:String = "select istatus from sr_request where iid = " + iid;
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
		var list:ArrayCollection = event.result as ArrayCollection;
		if (list && list.length > 0) {
			var istatus:int = list[0].istatus;
			if(istatus == 3){
				CRMtool.showAlert("服务申请已关闭，不能进行该操作！");
				return;
			}
			else {
				//查询对应的服务工单是否存在
				AccessUtil.remoteCallJava("CallCenterDest", "getSrbilloniinvoice", onBackCreateSrBillByRequestBack, {ccfunid: value.iifuncregedit, ccid: value.iid});
			}
		}
	}, sql);
	
}

private function onBackCreateSrBillByRequestBack(event:ResultEvent):void {
	if (event.result) {
		var value:Object = this.crmeap.getValue() as Object;
		var srbillAc:ArrayCollection = event.result as ArrayCollection;
		if (srbillAc.length == 0) {
			CRMtool.showAlert("未找到相应的服务工单。");
		} else {
			for each(var obj:Object in srbillAc) {
				if (obj.istatus == 1) {
					var param:Object = new Object();
					param.iid = obj.iid;
					AccessUtil.remoteCallJava("CallCenterDest", "deleteService", function (event:ResultEvent):void {
						var ret:String = event.result as String;
						if (ret == "撤销成功") {
							CRMtool.showAlert("撤销成功");
							crmeap.publicFlagObject["checkAlreadyhave" + value.iifuncregedit + ":" + value.iid] = false;
						} else {
							CRMtool.showAlert("撤销失败");
							crmeap.publicFlagObject["checkAlreadyhave" + value.iifuncregedit + ":" + value.iid] = true;
						}
					}, param, "正在撤销...");
				} else {
					CRMtool.showAlert("对应的服务工单已有服务记录，不允许撤销。");
				}
			}
		}
	}
}

private function onCreateSrBillBySrBill():void {
	
	var param:Object = {};//总体需要传入参数
	var srbillParam:Object = {};//服务派工单所需对象
	var srbillObj:Object = {};//承载服务请求单中的对象
	
	//获取服务请求单中的全部数据
	srbillObj = this.crmeap.getValue();
	if (null == srbillObj) return;
	
	if (srbillObj.istatus == 1) {
		CRMtool.tipAlert("当前服务工单没有服务记录,无法再生成服务派工单。");
		return;
	}
	if (srbillObj.iresult != 376 && srbillObj.iresult != 377) {
		CRMtool.tipAlert("解决状态不允许生成服务派工单。");
		return;
	}
	
	//服务派工单所需要的参数
	srbillParam.ifuncregedit = "150";//相关单据类型
	srbillParam.iinvoice = srbillObj.iid;//相关单据内码(当前服务请求单内码)
	if (srbillObj.isolution == 370)
		srbillParam.isolution = srbillObj.isolution;//处理方式
	else
		srbillParam.isolution = Number(srbillObj.isolution) + 1;
	srbillParam.icustomer = srbillObj.icustomer;//客户ID
	srbillParam.icustperson = srbillObj.icustperson;//联系人ID
	srbillParam.ctel = srbillObj.ctel;//联系电话
	srbillParam.caddress = srbillObj.caddress;//客户地址
	
	srbillParam.cdetail = srbillObj.cdetail;//详细情况
	srbillParam.icustproduct = srbillObj.icustproduct;//服务产品
	srbillParam.cproductno = srbillObj.cproductno;//加密狗号
	srbillParam.cservices = srbillObj.cservices;//服务项目
	srbillParam.cdetail = srbillObj.cdetail;//故障现象
	
	srbillParam.istatus = 1;
	
	//打开服务工单所需参数(页面创建参数)
	param.ifuncregedit = "150";
	param.ctable = "sr_bill";
	param.itemType = "onNew";
	param.operId = "onListNew";
	param.formTriggerType = "fromOther";
	param.srbillObj = srbillParam;
	var iid:ArrayCollection = new ArrayCollection();
	param.personArr = iid;
	
	CRMtool.removeChildFromViewStack();
	CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "服务工单", "");
}

//由服务派工单生成服务回访 YJ Add 2012-04-06
public function onCreateSrFeedBackByBill():void {
	
	var myMainValue:Object = this.crmeap.getValue() as Object;
	if (myMainValue.istatus == 0) {
		CRMtool.tipAlert("工单已作废，此操作不允许。");
		return;
	}
	if (crmeap.publicFlagObject["checkAlreadyhave" + myMainValue.iifuncregedit + ":" + myMainValue.iid]) {
		CRMtool.tipAlert("已回访，不能再次生成。");
		return;
	}
	
	var param:Object = {};//总体需要传入参数
	var srfeedbackParam:Object = {};//服务回访所需对象
	var srbillObj:Object = {};//承载服务派工单中的对象
	
	//获取服务派工单中的全部数据
	srbillObj = this.crmeap.getValue();
	if (null == srbillObj) return;
	
	/*    if (srbillObj.istatus == 1) {
	CRMtool.tipAlert("没有服务记录，不允许回访。");
	return;
	}*/
	
	//服务回访单据所需要的参数
	srfeedbackParam.ifuncregedit = "150";//相关单据类型
	srfeedbackParam.ifunconsult = 205;
	srfeedbackParam.iinvoice = srbillObj.iid;//相关单据内码(当前服务派工单内码)
	srfeedbackParam.iproperty = 1;//单据属性
	srfeedbackParam.icustomer = srbillObj.icustomer;//客户ID
	srfeedbackParam.icustperson = srbillObj.icustperson;//联系人ID
	srfeedbackParam.ctel = srbillObj.ctel;//联系电话
	srfeedbackParam.iperson = srbillObj.iengineer;//被回访人员
	srfeedbackParam.imaker = CRMmodel.userId;//制单人
	
	srfeedbackParam.iresult =srbillObj.iresult;//工单解决情况 
	
	//打开服务回访单据界面所需参数(页面创建参数)
	param.ifuncregedit = "154";
	param.ctable = "sr_feedback";
	param.itemType = "onNew";
	param.operId = "onListNew";
	param.formTriggerType = "fromOther";
	param.injectObj = srfeedbackParam;
	var iid:ArrayCollection = new ArrayCollection();
	param.personArr = iid;
	
	
	CRMtool.removeChildFromViewStack();
	CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "服务回访", "");
	
}

//由销售线索生成销售商机 by lr 
public function onCreateOpportunityByClue():void {
	
	var param:Object = {};   //CRMtool.openMenuItemFormOther 传参
	var opportunityObj:Object = {};   //销售商机 数据封装对象
	var clueObj:Object = {};       //来源单据引用
	
	clueObj = this.crmeap.getValue() as Object;
	if (null == clueObj) return;
	//验证客户是否已经存在
	//SZC
	if(clueObj.icustomer==null||clueObj.icustomer==""){
		CRMtool.tipAlert("当前客户不存在，无法生成商机，请先生成客户档案！");
		return;
	}
	//end
	var sql:String = "select * from cs_customer where iid = '"+clueObj.icustomer+"'";//客户内码
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
		var ac:ArrayCollection = event.result as ArrayCollection;
		if(ac == null || ac.length == 0){
			CRMtool.tipAlert("当前客户不存在，无法生成商机，请先生成客户档案！");

			return;
		}else{
			var remoteParam:Object = new Object();
			var icustomer:int = ac[0].iid;
			remoteParam.tablename = "sa_opportunity";
			remoteParam.ifuncregedit = 62;
			remoteParam.iinvoice = clueObj.iid;
			
			AccessUtil.remoteCallJava("PublicCheckiinvoiceDest", "isHave", function (e:ResultEvent):void {
				if (e.result as Boolean) {
					CRMtool.tipAlert("当前销售线索已经生成商机单据,无法再生成。");
				} else {
					//服务回访单据所需要的参数
					opportunityObj.ifuncregedit = "62";//相关单据类型
					opportunityObj.iinvoice = clueObj.iid;//相关单据内码
					opportunityObj.icustomer = icustomer;//客户ID
					
					var icustpersonSql:String = "";
					if(clueObj.icustperson){//相关联系人不为空
						icustpersonSql = "select iid from CS_custperson where iid = "+clueObj.icustperson;
					}else if(clueObj.icustperson == null && clueObj.ccustperson){//相关联系人为空，联系人员不为空
						icustpersonSql = "select iid from CS_custperson where icustomer = "+ icustomer +" and cname = '"+ clueObj.ccustperson +"'";
					}else{//都为空
						icustpersonSql = "select '' iid";
					}
					AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
						var ac:ArrayCollection = event.result as ArrayCollection;
						if(ac){
							opportunityObj.icustperson = ac[0].iid;//联系人iid
							//打开服务回访单据界面所需参数(页面创建参数)
							param.ifuncregedit = "80";
							param.ctable = "sa_opportunity";
							param.itemType = "onNew";
							param.operId = "onListNew";
							param.formTriggerType = "fromOther";
							param.opportunityObj = opportunityObj;
							var iid:ArrayCollection = new ArrayCollection();
							param.personArr = iid;
							
							CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "销售商机", "");
						}
					},icustpersonSql);
				}
				
			}, remoteParam);
		}
	},sql);
	
	/*if(srbillObj.istatus == 4)
	{CRMtool.tipAlert("当前服务派工单已经生成回访单据,无法再生成!请重新选择!");return;}
	else if(srbillObj.istatus != 3)
	{CRMtool.tipAlert("未交单，请交单后再试!");return;}*/
	
	
}

//由销售线索生成客户档案 YJ Add 2012-04-06
public function onCreateCsCustomerByClue():void {
	
	var param:Object = {};//总体需要传入参数
	var cscustomerParam:Object = {};//服务回访所需对象
	var saclueObj:Object = {};//承载服务派工单中的对象
	var custpersonObj:Object = {};//承载客商联系人参数
	
	//获取销售线索单中的全部数据
	
	saclueObj = this.crmeap.getValue();
	if (null == saclueObj) return;
	
	var remoteParam:Object = new Object();
	remoteParam.tablename = "cs_customer";
	remoteParam.ifuncregedit = 62;
	remoteParam.iinvoice = saclueObj.iid;
	
	if (saclueObj.icustomer && saclueObj.icustomer > 0) {
		CRMtool.tipAlert("客户已存在,无法再生成.");
		return;
	}
	
	var sql:String = "select * from cs_customer where cname = '"+saclueObj.ccustomer+"'";//客户名称
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
		var ac:ArrayCollection = event.result as ArrayCollection;
		if(ac == null || ac.length == 0){
			cscustomerParam.ifuncregedit = "62";//相关单据类型
			cscustomerParam.iinvoice = saclueObj.iid;//相关单据内码(当前销售线索内码)
			cscustomerParam.iproperty = 0;//单据属性
			cscustomerParam.cname = saclueObj.ccustomer;//客户名称
			var tasql:String="select * from AC_vouchform where ivouch=(select iid from AC_vouch where ifuncregedit=44) and cobjectname like '%istatus%'";
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
				var ta:ArrayCollection = event.result as ArrayCollection;
				if(ta.length>0){
					if(ta[0].cnewdefaultfix==1){
						cscustomerParam.istatus =1;
					}else{
						cscustomerParam.istatus =0;
					}
					
				}
				
			},tasql) //根据业务字典里面的客商状态的默认值给客商状态赋值
			//cscustomerParam.istatus =0;//状态(未审核)
			cscustomerParam.imaker = CRMmodel.userId;//制单人
			cscustomerParam.imrcustomer = saclueObj.imrcustomer;
			
			//客商联系人
			custpersonObj.cname = saclueObj.ccustperson;//联系人姓名
			custpersonObj.cpost = saclueObj.ccustpersonpost;//联系人职务
			custpersonObj.cmobile1 = saclueObj.ccustpersonmobile;//联系人手机
			custpersonObj.ctel = saclueObj.ccustpersontel;//联系人电话
			
			custpersonObj.isex = 0;
			custpersonObj.bkeycontect = 1;
			custpersonObj.istate = 326;
			custpersonObj.ctitle = "";
			custpersonObj.cdepartment = saclueObj.ccustpersonpost;
			custpersonObj.cmobile2 = "";
			custpersonObj.cemail = "";
			custpersonObj.cqqmsn = "";
			
			//打开客户档案界面所需参数(页面创建参数)
			param.ifuncregedit = "44";
			param.ctable = "cs_customer";
			param.itemType = "onNew";
			param.operId = "onListNew";
			param.formTriggerType = "fromOther";
			param.injectObj = cscustomerParam;
			var iid:ArrayCollection = new ArrayCollection();
			param.personArr = iid;
			
			var custpersonArr:ArrayCollection = new ArrayCollection();
			custpersonArr.addItem(custpersonObj);//添加联系人档案
			cscustomerParam.cs_custperson = custpersonArr;
			
			CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "客商档案", "");
		}else{
			CRMtool.tipAlert("当前客户已生成客户档案,无法再生成.");
		}
	},sql);
	
	/*    AccessUtil.remoteCallJava("PublicCheckiinvoiceDest", "isHave", function (e:ResultEvent):void {
	if (e.result as Boolean) {
	
	} else {
	
	
	}
	}, remoteParam);*/
	
	//  if(saclueObj.istatus == 4)
	//      {CRMtool.tipAlert("当前服务派工单已经生成回访单据,无法再生成!请重新选择!");return;}
	//  else if(saclueObj.istatus != 3)
	//      {CRMtool.tipAlert("未交单，请交单后再试!");return;}   
	
}

/**
 * 打开知识管理页面
 * */
public function openKnowledge():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	var paramObj:Object = new Object();
	var param:Object = new Object();
	param.ifuncregedit = "266";
	param.ctable = "sr_knowledge";
	param.itemType = "onNew";
	param.operId = "onListNew";
	param.formTriggerType = "fromOther";
	paramObj.icustomer=myMainValue.icustomer;
	paramObj.ifuncregedit=myMainValue.iifuncregedit;
	paramObj.iinvoice=myMainValue.iid;
	param.injectObj = paramObj;
	var iid:ArrayCollection = new ArrayCollection();
	param.personArr = iid;
	
	CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "加载中 ...", "");
	
}

//终止服务请求
public function onStopSrRequest():void {
	
	var param:Object = {};
	param = this.crmeap.getValue();
	if (null == param || !param.hasOwnProperty("iid")) return;
	
	AccessUtil.remoteCallJava("Sr_RequestDest", "onStopSrRequest", onStopSrRequestBack, param.iid);
}
private function onStopSrRequestBack(evt:ResultEvent):void {
	var rstr:String = evt.result + "";
	if (rstr == "suc")
		CRMtool.tipAlert("终止服务成功!");
	else
		CRMtool.tipAlert("终止服务失败!");
}

/*
* 服务工单，服务记录
*/
public function onUpdateBill():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	if (myMainValue.istatus == 0) {
		CRMtool.tipAlert("工单已作废，此操作不允许。");
		return;
	}
	
	if (myMainValue && myMainValue.hasOwnProperty("istatus") && myMainValue.istatus && myMainValue.istatus > 2) {
		CRMtool.showAlert("此服务工单已交单，不允许产生服务记录。");
		return;
	}
	
	if (myMainValue.irecord > 0) {
		if (myMainValue.iengineer != CRMmodel.userId && myMainValue.irecord != CRMmodel.userId) {
			CRMtool.showAlert("您不是本单据的服务人员，不允许执行此操作。");
			return;
		}
	}
	
	if (myMainValue && myMainValue.hasOwnProperty("iid")) {
		var iid:int = myMainValue.iid;
		
		var updateBillTitleWindow:UpdateBillTitleWindow = new UpdateBillTitleWindow();
		updateBillTitleWindow.myinit(iid, crmeap);
		
	}
}

/*
* 服务工单，服务记录撤销
*/
public function onCancelUpdateBill():void {
	var valueObj:Object = crmeap.getValue();
	if (valueObj.istatus == 0) {
		CRMtool.tipAlert("工单已作废，此操作不允许。");
		return;
	}
	if (valueObj.istatus != 2) {
		CRMtool.tipAlert("此服务工单当前状态没有服务记录，不允许撤销！");
		return;
	}
	//valueObj.cdescription = null;
	//valueObj.cprocess = null;
	valueObj.dengineer = null;
	valueObj.cfeedback = null;
	valueObj.ffee = null;
	valueObj.cmemo = null;
	valueObj.istatus = 1;
	valueObj.irecord = null;
	valueObj.drecord = null;
	valueObj.iresult = null;
	valueObj.ifeedback = null;
	
	AccessUtil.remoteCallJava("SrBillDest", "updateDataForStatus2", function ():void {
		
		
		var obj:Object = new Object();
		obj.mainValue = valueObj;
		crmeap.setValue(obj, 1, 1);
		crmeap.oldvouchFormValue = obj;
	}, valueObj);
	CRMtool.tipAlert("撤销记录成功！");
}

public function onSubmitSrBillManager():void {
	
	var myMainValue:Object = this.crmeap.getValue() as Object;
	if (myMainValue.istatus == 0) {
		CRMtool.tipAlert("工单已作废，此操作不允许。");
		return;
	}
	if (myMainValue && myMainValue.hasOwnProperty("istatus") && myMainValue.istatus && myMainValue.istatus != 2) {
		CRMtool.showAlert("此服务工单当前非服务记录状态，不允许交单！");
		
	} else {
		//CRMtool.tipAlert("确认交单？", null, "AFFIRM", this, "onSubmitSrBillManagerYes");
		CRMtool.tipAlert1("确认交单？", null, "AFFIRM",function ():void {
			onSubmitSrBillManagerYes();
		});
		
	}
}

/*
* 针对服务工单，交单功能
*/
public function onSubmitSrBillManagerYes():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	if (myMainValue.istatus == 0) {
		CRMtool.tipAlert("工单已作废，此操作不允许。");
		return;
	}
	if (myMainValue && myMainValue.hasOwnProperty("iid")) {
		
		myMainValue.imanager = CRMmodel.userId.toString();
		myMainValue.dmanager = CRMtool.getFormatDateString("YYYY-MM-DD HH:NN:SS", new Date());
		
		if (myMainValue.iresult == 375) {
			myMainValue.istatus = 4;
			myMainValue.iclose = myMainValue.imanager;
			myMainValue.dclose = myMainValue.dmanager;
		} else {
			myMainValue.istatus = 3;
		}
		
		AccessUtil.remoteCallJava("SrBillDest", "onUpdateSrBillStatus", function ():void {
			CRMtool.tipAlert("交单成功！");
			var obj:Object = new Object();
			obj.mainValue = myMainValue;
			crmeap.setValue(obj, 1, 1);
		}, myMainValue);
		
	}
}

/*
* 针对服务工单，撤销交单功能
*/
public function onCancelSubmitSrBillManager():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	if (myMainValue.istatus == 0) {
		CRMtool.tipAlert("工单已作废，此操作不允许。");
		return;
	}
	if (myMainValue.istatus != 3) {
		CRMtool.tipAlert("此服务工单当前状态非交单，不允许撤销！");
		return;
	}
	
	if (crmeap.publicFlagObject["checkAlreadyhave" + myMainValue.iifuncregedit + ":" + myMainValue.iid]) {
		CRMtool.tipAlert("已回访，无法撤销。");
		return;
	}
	
	if (myMainValue && myMainValue.hasOwnProperty("iid")) {
		myMainValue.istatus = 2;
		myMainValue.imanager = null;
		myMainValue.dmanager = null;
		
		AccessUtil.remoteCallJava("SrBillDest", "onUpdateSrBillStatus", function ():void {
			
			CRMtool.tipAlert("撤销交单成功！");
			var obj:Object = new Object();
			obj.mainValue = myMainValue;
			crmeap.setValue(obj, 1, 1);
			crmeap.oldvouchFormValue = obj;
		}, myMainValue);
		
	}
}

/*
* 针对服务工单，关闭功能
*/
public function onSubmitSrBillClose():void {
	
	var myMainValue:Object = this.crmeap.getValue() as Object;
	if (myMainValue.istatus == 0) {
		CRMtool.tipAlert("工单已作废，此操作不允许。");
		return;
	}
	if (myMainValue && myMainValue.hasOwnProperty("istatus") && myMainValue.istatus && myMainValue.istatus != 3) {
		CRMtool.tipAlert("此服务工单当前状态非交单，不允许关闭！");
	} else {
		//CRMtool.tipAlert("确认关闭？",null,"AFFIRM",this,"onSubmitSrBillCloseYes");
		var iid:int = myMainValue.iid;
		//打开关闭服务窗口，输入关闭内容再关闭
		new CloseSrBillTitleWindow().myinit(iid, crmeap);
	}
}

/*
* 针对服务工单，关闭功能
*/
public function onSubmitSrBillCloseYes():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	if (myMainValue.istatus == 0) {
		CRMtool.tipAlert("工单已作废，此操作不允许。");
		return;
	}
	if (myMainValue && myMainValue.hasOwnProperty("iid")) {
		var iid:int = myMainValue.iid;
		
		myMainValue.istatus = 4;
		myMainValue.iclose = CRMmodel.userId.toString();
		myMainValue.dclose = CRMtool.getFormatDateString("YYYY-MM-DD HH:NN:SS", new Date());
		
		AccessUtil.remoteCallJava("SrBillDest", "onUpdateSrBillStatus", function ():void {
			CRMtool.tipAlert("关闭成功！");
			var obj:Object = new Object();
			obj.mainValue = myMainValue;
			crmeap.setValue(obj, 1, 1);
		}, myMainValue);
	}
}


/*
* 针对服务工单，打开功能
*/
public function onSubmitSrBillOpen():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	
	if (myMainValue.istatus == 0) {
		CRMtool.tipAlert("工单已作废，此操作不允许。");
		return;
	}
	
	if (myMainValue.istatus != 4) {
		CRMtool.tipAlert("此服务工单当前状态非关闭，不允许打开！");
		return;
	}
	if (myMainValue && myMainValue.hasOwnProperty("iid")) {
		var iid:int = myMainValue.iid;
		
		myMainValue.istatus = 3;
		myMainValue.iclose = null;
		myMainValue.dclose = null;
		
		AccessUtil.remoteCallJava("SrBillDest", "onUpdateSrBillStatus", function ():void {
			CRMtool.tipAlert("打开成功！");
			var obj:Object = new Object();
			obj.mainValue = myMainValue;
			crmeap.setValue(obj, 1, 1);
		}, myMainValue);
	}
}

private function setBillInvalid():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	
	//YJ Edit 20140423 服务工单更改为派单状态的单据可以作废。
	if (myMainValue.istatus != 1) {
		CRMtool.tipAlert("只有派单状态的工单能执行此操作！");
		return;
	}
	if (myMainValue && myMainValue.hasOwnProperty("iid")) {
		var iid:int = myMainValue.iid;
		
		myMainValue.istatus = 0;
		myMainValue.iclose = null;
		myMainValue.dclose = null;
		var obj:Object = new Object();
		obj.mainValue = myMainValue;
		crmeap.setValue(obj, 1, 1);
		
		CRMtool.tipAlert("工单作废成功！");
		
		var sql:String = "update sr_bill set istatus=0 where iid=" + iid;
		AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, sql);
	}
}

private function setBillValid():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	
	if (myMainValue.istatus != 0) {
		CRMtool.tipAlert("只有作废状态的工单能执行此操作！");
		return;
	}
	if (myMainValue && myMainValue.hasOwnProperty("iid")) {
		var iid:int = myMainValue.iid;
		
		myMainValue.istatus = 2;
		myMainValue.iclose = null;
		myMainValue.dclose = null;
		var obj:Object = new Object();
		obj.mainValue = myMainValue;
		crmeap.setValue(obj, 1, 1);
		
		CRMtool.tipAlert("撤作废成功！");
		var sql:String = "update sr_bill set istatus=2 where iid=" + iid;
		AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, sql);
	}
}

//产品出库单，生产客商资产
public function onGenerateCsProduct():void {
	var value:Object = this.crmeap.getValue() as Object;
	var sc_rdrecords:ArrayCollection = value.sc_rdrecords;
	var sc_rdrecordsbom:ArrayCollection = value.sc_rdrecordsbom;
	
	if (sc_rdrecords && sc_rdrecords.length <= 0) {
		CRMtool.showAlert("产品不存在，无法生成资产。");
		return;
	}
	
	if (value.iinvoice == null || value.iinvoice == 0) {
		CRMtool.showAlert("未选择相关合同，无法生成资产。");
		return;
	}
	
	//如果是升级合同 检查原来升级合同影响资产 如果加密狗出库与替换的相同 则资产状态应为 新购
	if (value.ifuncregedit == 161 && value.iinvoice > 0) {//升级合同
		for each(var item:Object in sc_rdrecords) {
			if (CRMtool.isStringNotNull(item.csn) && item.iproduct > 0) {
				var sql:String = "update cs_custproduct set istatus=1 where icontract=" + value.iinvoice + " and csn='" + StringUtil.trim(item.csn) + "' and iproduct=" + item.iproduct + " and istatus = 2";
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, sql, null, false);
			}
		}
	}
	
	for each(var obj:Object in sc_rdrecords) {
		obj.ifuncregedit = value.iifuncregedit;//当前单据功能内码
		obj.iinvoice = value.iid;
		obj.orderiid = value.iinvoice;
		obj.icustomer = value.icustomer;
		obj.iscstatus = 509;//赠送期限内
		obj.istatus = 1;//产品状态 新购
		obj.imaker = CRMmodel.userId;
		obj.dmaker = value.dmaker;
		var bomList:ArrayCollection = null;
		for each(var bomobj:Object in sc_rdrecordsbom) {
			if (obj.iproduct == bomobj.iproductp) {
				if (bomList == null) {
					bomList = new ArrayCollection();
					obj.bomList = bomList;
				}
				bomList.addItem(bomobj);
			}
		}
	}
	AccessUtil.remoteCallJava("customerDest", "addCsProduct", function (event:ResultEvent):void {
		if (event.result.toString() == "alreadyhave") {
			CRMtool.showAlert("此单据已经生成资产，无法再次生成。");
		} else if (event.result.toString() == "muchcsn") {
			CRMtool.showAlert("加密狗号已存在多次，无法生成资产，请检查。");
		}
		else if (event.result.toString() == "ok") {
			CRMtool.showAlert("生成资产成功！");
			crmeap.publicFlagObject["checkAlreadyhave" + value.iifuncregedit + ":" + value.iid] = true;
		} else {
			CRMtool.showAlert("生成失败，请联系管理员。");
		}
		
	}, sc_rdrecords);
}


//产品出库单，撤销生产客商资产
public function onBackGenerateCsProduct():void {
	var value:Object = crmeap.getValue() as Object;
	var sc_rdrecords:ArrayCollection = value.sc_rdrecords;
	var sc_rdrecordsbom:ArrayCollection = value.sc_rdrecordsbom;
	
	if (sc_rdrecords && sc_rdrecords.length <= 0) {
		CRMtool.showAlert("产品不存在，无法撤销资产。");
		return;
	}
	
	for each(var obj:Object in sc_rdrecords) {
		obj.ifuncregedit = value.iifuncregedit;//当前单据功能内码
		obj.iinvoice = value.iid;
		var bomList:ArrayCollection = null;
		for each(var bomobj:Object in sc_rdrecordsbom) {
			if (obj.iproduct == bomobj.iproductp) {
				if (bomList == null) {
					bomList = new ArrayCollection();
					obj.bomList = bomList;
				}
				bomList.addItem(bomobj);
			}
		}
	}
	
	AccessUtil.remoteCallJava("customerDest", "delCsProduct", function (event:ResultEvent):void {
		var value:Object = crmeap.getValue() as Object;
		if (event.result.toString() == "nohave") {
			CRMtool.showAlert("未生成客户资产，无法执行撤销操作。");
		} else if (event.result.toString() == "ok") {
			CRMtool.showAlert("撤销生成资产成功！");
			crmeap.publicFlagObject["checkAlreadyhave" + value.iifuncregedit + ":" + value.iid] = false;
		} else {
			CRMtool.showAlert("撤销失败，请联系管理员。");
			crmeap.publicFlagObject["checkAlreadyhave" + value.iifuncregedit + ":" + value.iid] = true;
		}
	}, sc_rdrecords);
}


public function submitChangeSrproject():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	var istatus:int = myMainValue.istatus;
	
	if(istatus == 416) {
		CRMtool.showAlert("订单已关闭，不能进行此操作！");
		return;
	}
	
	var param:Object = {};//总体需要传入参数
	var srproject:Object = {};
	
	srproject.ifuncregedit = "202";//相关单据类型
	srproject.iinvoice = myMainValue.iid;//相关单据内码(当前服务派工单内码)
	
	srproject.ioperson = myMainValue.iperson;
	srproject.iperson = myMainValue.iperson;
	srproject.dobegin = myMainValue.dplanbegin;
	srproject.dbegin = myMainValue.dplanbegin;
	srproject.doend = myMainValue.dplanend;
	srproject.dend = myMainValue.dplanend;
	srproject.foworkday = myMainValue.fplan;
	srproject.fworkday = myMainValue.fplan;
	
	param.ifuncregedit = "259";
	param.ctable = "sr_projectchange";
	param.itemType = "onNew";
	param.operId = "onListNew";
	param.formTriggerType = "fromOther";
	param.srproject = srproject;
	var iid:ArrayCollection = new ArrayCollection();
	param.personArr = iid;
	
	//CRMtool.removeChildFromViewStack();
	CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "新建实施变更", "");
}

public function executionChangeSrproject():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	if (myMainValue.istate == 574) {
		var srproject:Object = {};
		srproject.iid = myMainValue.iinvoice;
		srproject.iperson = myMainValue.iperson;
		srproject.dplanbegin = myMainValue.dbegin;
		srproject.dplanend = myMainValue.dend;
		srproject.fplan = myMainValue.fworkday;
		
		srproject.sr_projectchange_iid = myMainValue.iid;
		srproject.istate = 575;
		AccessUtil.remoteCallJava("SrBillDest", "updateSrProject", function (event:ResultEvent):void {
			if (event.result as Boolean) {
				CRMtool.showAlert("提交成功");
				//myMainValue.istate=575;
				//crmeap.setValue(myMainValue,1,1);
				CRMtool.removeChildFromViewStack();
			} else {
				CRMtool.showAlert("提交失败。");
			}
			
		}, srproject);
	} else {
		CRMtool.showAlert("已提交，请勿再次提交。");
	}
	
	
}

private function updateDutyState2():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	var dutys:ArrayCollection = new ArrayCollection();
	var oa_dutys:ArrayCollection = myMainValue.oa_dutys as ArrayCollection;
	if (oa_dutys) {
		for each(var obj:Object in oa_dutys) {
			if (obj.irole == 602 || obj.irole == 603) {
				dutys.addItem(obj);
			}
		}
	}
	if (myMainValue.iid) {
		if (myMainValue.istate == 2) {
			CRMtool.showAlert("已经是生效状态，无须再次生效。");
			return;
		}
		
		AccessUtil.remoteCallJava("OADest", "updateDutyState", function (event:ResultEvent):void {
			if (event.result as Boolean) {
				myMainValue.istate = 2;
				crmeap.setValue(crmeap.fzsj(myMainValue), 1, 1);
				CRMtool.showAlert("单据生效成功。");
			} else {
				CRMtool.showAlert("单据生效失败。");
			}
		}, {iid: myMainValue.iid, dutys: dutys});
	}
}

private function openRequestPage():void {
	var resultObj:Object = this.crmeap.getValue();
	var param:Object = new Object();
	param.ifuncregedit = "149";
	param.ctable = "sr_request";
	param.itemType = "onNew";
	param.operId = "onListNew";
	param.formTriggerType = "fromOther";
	var paramObj:Object = new Object();
	
	paramObj.icustomer = resultObj.icustomer;//客商
	paramObj.icustperson = resultObj.icustperson;//联系人
	paramObj.iinvoice = resultObj.iid; //相关单据内码
	paramObj.ifuncregedit = resultObj.iifuncregedit;//相关功能注册
	
	if (resultObj.icustomer == null)
		resultObj.icustomer = 0;
	
	var sql:String = "select cofficeaddress from cs_customer where iid=" + resultObj.icustomer;
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
		if (event.result && (event.result as ArrayCollection).length > 0) {
			var obj:Object = (event.result as ArrayCollection).getItemAt(0);
			if (obj)
				paramObj.caddress = obj.cofficeaddress;
			
			
			param.hotlineParam = paramObj;
			var iid:ArrayCollection = new ArrayCollection();
			param.personArr = iid;
			
			CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "服务申请", "");
			
		}
	}, sql);
}

private function openTrainrequestPage():void {
	var resultObj:Object = this.crmeap.getValue();
	var param:Object = new Object();
	param.ifuncregedit = "194";
	param.ctable = "sr_trainrequest";
	param.itemType = "onNew";
	param.operId = "onListNew";
	param.formTriggerType = "fromOther";
	var paramObj:Object = new Object();
	
	paramObj.icustomer = resultObj.icustomer;//客商
	paramObj.iinvoice = resultObj.iid; //相关单据内码
	paramObj.ifuncregedit = resultObj.iifuncregedit;//相关功能注册
	paramObj.iperson = resultObj.iperson;//销售人员
	paramObj.idepartment = resultObj.idepartment;//销售部门
	
	param.hotlineParam = paramObj;
	var iid:ArrayCollection = new ArrayCollection();
	param.personArr = iid;
	
	CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "培训申请", "");
}

private function openHandoverPage():void {
	
	var resultObj:Object = this.crmeap.getValue();
	var param:Object = new Object();
	param.ifuncregedit = "200";
	param.ctable = "sr_handover";
	param.itemType = "onNew";
	param.operId = "onListNew";
	param.formTriggerType = "fromOther";
	var paramObj:Object = new Object();
	
	paramObj.icustomer = resultObj.icustomer;//客商
	paramObj.iinvoice = resultObj.iid; //相关单据内码
	paramObj.ifuncregedit = resultObj.iifuncregedit;//相关功能注册
	paramObj.iperson = resultObj.iperson;//销售人员
	paramObj.idepartment = resultObj.idepartment;//销售部门
	
	param.hotlineParam = paramObj;
	var iid:ArrayCollection = new ArrayCollection();
	param.personArr = iid;
	
	CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "实施交接", "");
}

private function openSRHandoverPage():void {
	var resultObj:Object = this.crmeap.getValue();
	var param:Object = new Object();
	param.ifuncregedit = "206";
	param.ctable = "sr_handover";
	param.itemType = "onNew";
	param.operId = "onListNew";
	param.formTriggerType = "fromOther";
	var paramObj:Object = new Object();
	
	paramObj.icustomer = resultObj.icustomer;//客商
	paramObj.iinvoice = resultObj.iid; //相关单据内码
	paramObj.ifuncregedit = resultObj.iifuncregedit;//相关功能注册
	paramObj.iperson = resultObj.iperson;//销售人员
	paramObj.idepartment = resultObj.idepartment;//销售部门
	
	param.hotlineParam = paramObj;
	var iid:ArrayCollection = new ArrayCollection();
	param.personArr = iid;
	
	CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "开发交接", "");
}


//add by WTF  新建培训注册-->申请生单

private function applyAction():void {
	var trainWindow:TrainApplyActionTitleWindow = new TrainApplyActionTitleWindow();
	trainWindow.height = 500;
	trainWindow.width = 650;
	trainWindow.crmeap = crmeap;
	if (crmeap.getValue().iid == null || crmeap.getValue().iid == 0) return;
	CRMtool.openView(trainWindow);
}


//更新实施日志，签到签退  lr
private function updateSrProjects():void {
	var mainValue:Object = this.crmeap.getValue() as Object;
	if (CRMtool.isStringNotNull(mainValue.dbegin) && CRMtool.isStringNotNull(mainValue.dend)) {
		CRMtool.showAlert("签到、签退记录已存在，不需要再次报岗。");
		return;
	}
	mainValue.ddate = mainValue.ddate;
	if (mainValue.iproject) {
		AccessUtil.remoteCallJava("CallCenterDest", "getCallcenterForProjects", function (event:ResultEvent):void {
			var cclist:ArrayCollection = event.result as ArrayCollection;
			if (cclist && cclist.length > 0) {
				var updateSrProjectsTW:UpdateSrProjectsTitleWindow = new UpdateSrProjectsTitleWindow();
				updateSrProjectsTW.dataList = cclist;
				CRMtool.openView(updateSrProjectsTW);
				updateSrProjectsTW.crmeap = crmeap;
			} else {
				CRMtool.showAlert("无可用记录");
			}
			
		}, mainValue);
	}
	
}

//add by WTF 服务管理-->实施管理-->新增实施管理-->更多操作-->实施日志

private function srProjectLog():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	var istatus:int = myMainValue.istatus;
	
	if(istatus == 416) {
		CRMtool.showAlert("订单已关闭，不能进行此操作！");
		return;
	}
	
	var param:Object = {};//总体需要传入参数
	var injectObj:Object = {};
	
	injectObj.ifuncregedit = "202";//相关单据类型
	injectObj.iproject = myMainValue.iid;//相关单据内码(当前服务派工单内码)
	injectObj.icustomer = myMainValue.icustomer;
	
	
	param.ifuncregedit = "220";
	param.ctable = "sr_projects";
	param.itemType = "onNew";
	param.operId = "onListNew";
	param.formTriggerType = "fromOther";
	param.injectObj = injectObj;
	var iid:ArrayCollection = new ArrayCollection();
	param.personArr = iid;
	
	//CRMtool.removeChildFromViewStack();
	CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "新建实施日志", "");
}

//销售商机,生成升级合同
private function opportunityToOrder161():void {
	opportunityToOrder(161);
}
//销售商机,生成新增合同
private function opportunityToOrder162():void {
	opportunityToOrder(162);
}

//销售商机,生成开发合同
private function opportunityToOrder210():void {
	opportunityToOrder(210);
}

//销售商机,生成服务费合同
private function opportunityToOrder159():void {
	opportunityToOrder(159);
}

//耗材合同
private function opportunityToOrder157():void {
	opportunityToOrder(157);
}
//wxh add
private function pushOrder(myMainValue:Object, ifuncregedit:int):void {
	var param:Object = {};//总体需要传入参数
	var injectObj:Object = {};
	
	injectObj.ifuncregedit = "80";//相关单据类型
	injectObj.iinvoice = myMainValue.iid;
	injectObj.cname = myMainValue.cname;
	injectObj.icustomer = myMainValue.icustomer;
	injectObj.idepartment = myMainValue.idepartment;
	injectObj.iperson = myMainValue.iperson;
	injectObj.icustperson = myMainValue.icustperson;
	
	
	param.ifuncregedit = ifuncregedit;
	param.ctable = "sc_order";
	param.itemType = "onNew";
	param.operId = "onListNew";
	param.formTriggerType = "fromOther";
	param.injectObj = injectObj;
	var iid:ArrayCollection = new ArrayCollection();
	param.personArr = iid;
	
	//CRMtool.removeChildFromViewStack();
	CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "加载中…", "");
}
//wxh update 20130315
private function opportunityToOrder(ifuncregedit:int):void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	if (myMainValue.istatus == 341) {
		CRMtool.showAlert("已经生单，不允许再次生成。");
		return;
	}
    var sql1:String="select  isjstatus  from sa_opportunity    where iid  ="+myMainValue.iid;
    AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
        var ac:ArrayCollection = event.result as ArrayCollection;
        if (ac != null || ac.length > 0) {
            if ( ac[0].isjstatus != '1') {
                CRMtool.showAlert("单据不是审核状态，请审核后再操作！");
                return;
            }
        }

	if (ifuncregedit != 162 && ifuncregedit != 161) {
		pushOrder(myMainValue, ifuncregedit);
	} else {
		//判断当前要生成的合同需不需要  客户状态为审核
		var sql:String = "select cconsultcondition from dbo.Ac_consultConfiguration where  idatadictionary in ( select iid from dbo.AC_datadictionary where ifuncregedit = " + ifuncregedit + " and  cfield = 'icustomer' and ctable ='sc_order')";
		AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
			var arr:ArrayCollection = event.result as ArrayCollection;
			if (arr && arr.length > 0 && arr[0].cconsultcondition != "") {
				//判断这个客户有没有审核 1=审核
				var sqls:String = "select istatus from cs_customer where iid = " + myMainValue.icustomer;
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
					var istatuss:ArrayCollection = event.result as ArrayCollection;
					if (istatuss && istatuss.length > 0) {
						if (istatuss[0].istatus == 1) {
							pushOrder(myMainValue, ifuncregedit);
						} else {
							CRMtool.showAlert("客户未审核，不允许执此操作！");
						}
					} else {
						CRMtool.showAlert("客商档案中无此客户！");
					}
				}, sqls);
			} else {
				pushOrder(myMainValue, ifuncregedit);
			}
		}, sql);
	}
}, sql1);
}

//商机升迁
public function openInvoiceProcess():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	
	if (myMainValue.istatus == 341) {
		CRMtool.showAlert("已经生单，不允许再次生成。");
		return;
	}
	
	var param:Object = {};//总体需要传入参数
	var injectObj:Object = {};
	
	injectObj.ifuncregedit = "80";//相关单据类型
	injectObj.iinvoice = myMainValue.iid;
	injectObj.icustomer = myMainValue.icustomer;
	injectObj.ifunconsult = 200;
	param.ifuncregedit = 258;
	param.ctable = "ab_invoiceprocess";
	param.itemType = "onNew";
	param.operId = "onListNew";
	param.formTriggerType = "fromOther";
	param.injectObj = injectObj;
	var iid:ArrayCollection = new ArrayCollection();
	param.personArr = iid;
	
	//CRMtool.removeChildFromViewStack();
	CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "加载中…", "");
}


//实施管理 升迁
public function openInvoiceProcess202():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	var istatus:int = myMainValue.istatus;
	
	if(istatus == 416) {
		CRMtool.showAlert("订单已关闭，不允许此操作。");
		return;
	}
	var param:Object = {};//总体需要传入参数
	var injectObj:Object = {};
	
	injectObj.ifuncregedit = "202";//相关单据类型
	injectObj.iinvoice = myMainValue.iid;
	injectObj.iifuncregedit = 298;
	injectObj.iprocess = myMainValue.iphase;
	injectObj.ifunconsult = 242;
	injectObj.icustomer = myMainValue.icustomer;
	param.ifuncregedit = 258;
	param.ctable = "ab_invoiceprocess";
	param.itemType = "onNew";
	param.operId = "onListNew";
	param.formTriggerType = "fromOther";
	param.injectObj = injectObj;
	var iid:ArrayCollection = new ArrayCollection();
	param.personArr = iid;
	
	//CRMtool.removeChildFromViewStack();
	CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "加载中…", "");
}


//商机暂停
private function opportunityIstatus343():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	var istatus:int = myMainValue.istatus;
    var sql:String="select ccode from aa_data  where iid =(select istatus from sa_opportunity where iid ="+myMainValue.iid+")";
    AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
        var ac:ArrayCollection = event.result as ArrayCollection;
        if (ac != null || ac.length > 0) {
            if (istatus == 340 || ac[0].ccode == '5') {
                updateOpportunityIstatus(343);
            } else {
                CRMtool.showAlert("非“待审核”或“已审核”状态，不允许此操作。");
            }
        }
    },sql);

}


//商机废单
private function opportunityIstatus344():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	var istatus:int = myMainValue.istatus;

    var sql:String="select ccode from aa_data  where iid =(select istatus from sa_opportunity where iid ="+myMainValue.iid+")";
    AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
        var ac:ArrayCollection = event.result as ArrayCollection;
        if (ac != null || ac.length > 0) {
            if (istatus == 340 || ac[0].ccode == '5') {
                updateOpportunityIstatus(344);
            } else {
                CRMtool.showAlert("非“待审核”或“已审核”状态，不允许此操作。");
            }
        }
    },sql);
}
/*//查看该单据是否是审核确认状态
private function isNotMakeSureState(istatus):String{
    var sql:String="select ccode from aa_data where iclass=62 and  iid="+istatus;
    AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):Boolean {
        var ac:ArrayCollection = event.result as ArrayCollection;
        if (ac == null || ac.length == 0) {
            if (ac[0].ccode == '5') {
                return "true";
            }
            else {
                return "false";
            }

        }


    },sql);
    return "false";
}*/


//商机启动
private function opportunityIstatus340():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	var istatus:int = myMainValue.istatus;

	if (istatus == 343 || istatus == 344) {
		updateOpportunityIstatus(340);
	} else {
		CRMtool.showAlert("非“业务暂停”、“业务终止”状态，不允许此操作。");
	}
}

private function updateOpportunityIstatus(istatus:int):void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	var iid:int = myMainValue.iid;
	if (iid != 0) {
		var sql:String = "update sa_opportunity set istatus=" + istatus + " where iid=" + iid;
		AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
			myMainValue.istatus = istatus;
			var obj:Object = new Object();
			obj.mainValue = myMainValue;
			crmeap.setValue(obj, 1, 1);
		}, sql);
	}
}

//商机失败
private function opportunityIstatus342():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	var iid:int = myMainValue.iid;
	var istatus:int = myMainValue.istatus;
	
	if (istatus == 340) {
		new UpdateOpportunityTitleWindow().myinit(iid, crmeap);
    } else {
		CRMtool.showAlert("非“待审核”状态，不允许此操作。");
	}
}


private function handover2project():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	
	var param:Object = {};//总体需要传入参数
	var injectObj:Object = {};
	
	injectObj.ifuncregedit = "200";//相关单据类型
	injectObj.iinvoice = myMainValue.iid;//相关单据内码
	
	injectObj.icustomer = myMainValue.icustomer;
	injectObj.isaledepartment = myMainValue.idepartment;
	injectObj.isaleperson = myMainValue.iperson;
	injectObj.cmemo = myMainValue.cmemo;
	injectObj.cdetail = myMainValue.cdetail;
	injectObj.itype = myMainValue.itype;
	
	
	param.ifuncregedit = "202";
	param.ctable = "sr_project";
	param.itemType = "onNew";
	param.operId = "onListNew";
	param.formTriggerType = "fromOther";
	param.injectObj = injectObj;
	var iid:ArrayCollection = new ArrayCollection();
	param.personArr = iid;
	
	CRMtool.removeChildFromViewStack();
	CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "新增实施管理", "");
}
//wtf add
private function handover2service():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	
	var sql:String = "select iid from sr_handover where ifuncregedit=220 and iinvoice=" + myMainValue.iid;
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
		var ac:ArrayCollection = event.result as ArrayCollection;
		if (ac && ac.length > 0) {
			CRMtool.showAlert("此单据已生成服务交接，无法再次生成。");
		} else {
			var param:Object = {};//总体需要传入参数
			var injectObj:Object = {};
			
			injectObj.ifuncregedit = "202";//相关单据类型
			injectObj.iinvoice = myMainValue.iid;//相关单据内码
			
			injectObj.icustomer = myMainValue.icustomer;
			injectObj.idepartment = myMainValue.isaledepartment;
			injectObj.iperson = myMainValue.isaleperson;
			injectObj.cmemo = myMainValue.cmemo;
			injectObj.cdetail = myMainValue.cdetail;
			injectObj.icustperson = myMainValue.icustperson;
			injectObj.ctel = myMainValue.ctel;
			
			param.ifuncregedit = "286";
			param.ctable = "sr_handover";
			param.itemType = "onNew";
			param.operId = "onListNew";
			param.formTriggerType = "fromOther";
			param.injectObj = injectObj;
			var iid:ArrayCollection = new ArrayCollection();
			param.personArr = iid;
			
			//CRMtool.removeChildFromViewStack();
			CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "新增服务交接", "");
		}
		
	}, sql);
}
//工作计划 生成 工作日志
private function openworkdiary():void {
	var param:Object = new Object();
	param.ifuncregedit = "46";
	param.ctable = "oa_workdiary";
	param.itemType = "onNew";
	param.operId = "onListNew";
	param.formTriggerType = "fromOther";
	var paramObj:Object = new Object();

    /*
     * lq add 2016/3/7
     * 将计划主题和内容带到活动页
     * */
    paramObj.cdetail=this.crmeap.getValue().cdetail;
    paramObj.cname=this.crmeap.getValue().cname;

	paramObj.icustomer = this.crmeap.getValue().icustomer;
	paramObj.iplans = this.crmeap.getValue().iid;
	paramObj.ifuncregedit = 35;
	
	param.injectObj = paramObj;
	var iid:ArrayCollection = new ArrayCollection();
	param.personArr = iid;
	
	CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "工作日志", "");
}

//取消计划
private function cancelWorkplan():void {
	var myValue:Object = crmeap.getValue();
	if (myValue) {
		var iid:int = myValue.iid;
		if (iid && iid > 0) {
			var sql:String = "update oa_workplan set istatus=621,bnomessage=1 where iid=" + iid;
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
				CRMtool.showAlert("取消成功。");
				CRMtool.removeChildFromViewStack();
			}, sql);
		}
	}
}

//黄页，生成 客户
private function mr2cs():void {
	if (!crmeap)
		return;

	var mainValue:Object = crmeap.getValue();
    var sql:String="select istatus from mr_customer where iid="+mainValue.iid;
    AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(event:ResultEvent):void {
        var ac:ArrayCollection = event.result as ArrayCollection;
        //只有审核确认的状态 和之前的老数据可以生成客商（老数据可以不用审核）
        if (ac[0].istatus == 2 || ac[0].istatus == null) {
            var param:Object = new Object();
            param.operId = "onListNew";
            param.outifuncregedit = "44";
            param.ifuncregedit = "44";
            var iid:ArrayCollection = new ArrayCollection();
            param.personArr = iid;
            param.itemType = "onNew";
            param.formTriggerType = "fromOther";
            param.ctable = "cs_customer";

            var cs_custperson:ArrayCollection = new ArrayCollection;

            if (CRMtool.isStringNotNull(mainValue.cperson)) {
                cs_custperson.addItem({cname: mainValue.cperson, cdepartment: "", cpost: mainValue.cpost,
                    isex: "", bkeycontect: 1,
                    istate: 326, ctitle: "", ctel: mainValue.ctel, cmobile1: mainValue.cmobile, cmobile2: "",
                    cemail: ""
                });
            }

            if (CRMtool.isStringNotNull(mainValue.ccharge)) {
                cs_custperson.addItem({cname: mainValue.ccharge, cdepartment: "", cpost: "",
                    isex: "", bkeycontect: 0,
                    istate: 326, ctitle: "", ctel: "", cmobile1: "", cmobile2: "",
                    cemail: ""
                });
            }

            var injectObj:Object = new Object();

            injectObj.ifuncregedit = 176;//相关单据类型
            injectObj.imrcustomer = mainValue.iid;

            injectObj.cname = mainValue.cname;
            injectObj.cofficeaddress = mainValue.caddress;
            injectObj.cofficezipcode = mainValue.czipcode;
            injectObj.cmemo = mainValue.cmemo;
            injectObj.iaddress = mainValue.iaddress;

            injectObj.cs_custperson = cs_custperson;

            param.injectObj = injectObj;
            CRMtool.removeChildFromViewStack();
            var sql:String="update ab_invoiceuser set ifuncregedit=46 where iinvoice in (select iid from OA_workdiary where imrcustomer="+mainValue.iid+") and ifuncregedit =289";
            AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql",null, sql); //解决黄页活动变成客商活动后没有负责人的问题
            CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param);
        }
        else{
            CRMtool.showAlert("单据只有通过审核才可以生成客商档案！");
        }
    },sql);

	
}

//市场活动生成线索
private function oa_workiary2sa_clue():void {
	if (!crmeap)
		return;
	
	var mainValue:Object = crmeap.getValue();
	
	var param:Object = new Object();
	param.operId = "onListNew";
	param.outifuncregedit = "62";
	param.ifuncregedit = "62";
	var iid:ArrayCollection = new ArrayCollection();
	param.personArr = iid;
	param.itemType = "onNew";
	param.formTriggerType = "fromOther";
	param.ctable = "sa_clue";
	
	var injectObj:Object = new Object();
	
	injectObj.ifuncregedit = 289;//相关单据类型
	
	injectObj.imrcustomer = mainValue.imrcustomer;
	for each(var ct:CrmEapTextInput in crmeap.textInputList) {
		if (ct.crmName == "ui_oa_workdiary_imrcustomer")
			injectObj.ccustomer = ct.text;
	}
	
	injectObj.cname = mainValue.cname;
	injectObj.ccustperson = mainValue.ccustperson;
	injectObj.ccustpersonmobile = mainValue.cmobile;
	injectObj.ccustpersontel = mainValue.ctel;
	injectObj.cdetail = mainValue.cdetail;
	
	param.injectObj = injectObj;
	CRMtool.removeChildFromViewStack();
	CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param);
}

//客商活动生成线索
private function cs_oa_workiary2sa_clue():void {
	if (!crmeap)
		return;
	
	var mainValue:Object = crmeap.getValue();
	
	var param:Object = new Object();
	param.operId = "onListNew";
	param.outifuncregedit = "62";
	param.ifuncregedit = "62";
	var iid:ArrayCollection = new ArrayCollection();
	param.personArr = iid;
	param.itemType = "onNew";
	param.formTriggerType = "fromOther";
	param.ctable = "sa_clue";
	
	var injectObj:Object = new Object();
	
	injectObj.ifuncregedit = 46;//相关单据类型
	injectObj.iinvoice = mainValue.iid;
	
	injectObj.cname = mainValue.cname;
	injectObj.icustperson = mainValue.icustperson;
	injectObj.icustomer = mainValue.icustomer;
	injectObj.cdetail = mainValue.cdetail;
	
	for each(var ct:CrmEapTextInput in crmeap.textInputList) {
		if (ct.crmName == "UI_OA_workdiary_icustomer")
			injectObj.ccustomer = ct.text;
	}
	
	param.injectObj = injectObj;
	CRMtool.removeChildFromViewStack();
	CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param);
}

//客户推送 客户报告
private function cs_customer2rp_283():void {
	if (!crmeap)
		return;
	
	var mainValue:Object = crmeap.getValue();
	var param:Object = new Object();
	var injectObj:Object = new Object();
	
	param.outifuncregedit = "283";
	param.ifuncregedit = "283";
	
	injectObj.icustomer = mainValue.iid;
	injectObj.icustomer_NAME = mainValue.cname;
	//injectObj.bdate = "2012-02-02";
	injectObj.isAutoSearch = true;
	
	param.injectObj = injectObj;
	CRMtool.openMenuItemFormOther("yssoft.comps.frame.PrintVbox", param);
}

//客户推送 客户应收账款明细
private function cs_customer2rp_247():void {
	if (!crmeap)
		return;
	
	var mainValue:Object = crmeap.getValue();
	var param:Object = new Object();
	var injectObj:Object = new Object();
	
	param.outifuncregedit = "247";
	param.ifuncregedit = "247";
	
	injectObj.icustomer = mainValue.iid;
	injectObj.icustomer_NAME = mainValue.cname;
	injectObj.isAutoSearch = true;
	
	param.injectObj = injectObj;
	CRMtool.openMenuItemFormOther("yssoft.comps.frame.StatementsVBox", param, "应收明细");
}

//商机卡片生成支持申请
private function sa_opportunity2sa_presupport():void {
	if (!crmeap)
		return;
	
	var mainValue:Object = crmeap.getValue();
	
	var param:Object = new Object();
	param.operId = "onListNew";
	param.outifuncregedit = "147";
	param.ifuncregedit = "147";
	var iid:ArrayCollection = new ArrayCollection();
	param.personArr = iid;
	param.itemType = "onNew";
	param.formTriggerType = "fromOther";
	param.ctable = "sa_opportunity";
	
	var injectObj:Object = new Object();
	
	injectObj.ifuncregedit = 80;//相关单据类型
	injectObj.iinvoice = mainValue.iid;
	
	injectObj.icustomer = mainValue.icustomer;
	injectObj.iperson = mainValue.iperson;
	injectObj.idepartment = mainValue.idepartment;
	//injectObj.ccustnow = mainValue.iphase;
	switch (mainValue.iphase) {
		case "4":
			injectObj.ccustnow = "意向";
			break;
		case "5":
			injectObj.ccustnow = "认可";
			break;
		case "6":
			injectObj.ccustnow = "谈判";
			break;
		case "7":
			injectObj.ccustnow = "成交";
			break;
		case "8":
			injectObj.ccustnow = "项目规划";
			break;
		case "9":
			injectObj.ccustnow = "蓝图设计";
			break;
		case "10":
			injectObj.ccustnow = "系统建设";
			break;
		case "11":
			injectObj.ccustnow = "切换准备";
			break;
		case "12":
			injectObj.ccustnow = "上线支持";
			break;
		case "13":
			injectObj.ccustnow = "立项";
			break;
	}
	//injectObj.ffee = mainValue.fforecast;
	//injectObj.fresult = mainValue.ffact;
	
	param.injectObj = injectObj;
	CRMtool.removeChildFromViewStack();
	CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param);
}


//客商活动生成商机
private function cs_oa_workiary2opportunity():void {
	if (!crmeap)
		return;
	
	var mainValue:Object = crmeap.getValue();
	
	var param:Object = new Object();
	param.operId = "onListNew";
	param.outifuncregedit = "80";
	param.ifuncregedit = "80";
	var iid:ArrayCollection = new ArrayCollection();
	param.personArr = iid;
	param.itemType = "onNew";
	param.formTriggerType = "fromOther";
	param.ctable = "sa_opportunity";
	
	var injectObj:Object = new Object();
	
	injectObj.ifuncregedit = mainValue.iifuncregedit;//相关单据类型
	injectObj.iinvoice = mainValue.iid;
	
	injectObj.cname = mainValue.cname;
	injectObj.icustperson = mainValue.icustperson;
	injectObj.icustomer = mainValue.icustomer;
	injectObj.cdetail = mainValue.cdetail;
	
	param.injectObj = injectObj;
	CRMtool.removeChildFromViewStack();
	CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param);
}

/*
* 新增支持申请，支持汇报
*/
public function onSupportReport():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	if (myMainValue && myMainValue.iengineer && myMainValue.iengineer != "" && myMainValue.iengineer != CRMmodel.userId) {
		CRMtool.showAlert("您不是本单据的服务人员，不允许执行此操作。");
	}
	else if (myMainValue && myMainValue.hasOwnProperty("istatus") && myMainValue.istatus && myMainValue.istatus > 2) {
		CRMtool.showAlert("此支持申请已交单，不允许产生支持记录。");
	}
	else if (myMainValue && myMainValue.hasOwnProperty("iid")) {
		var iid:int = myMainValue.iid;
		
		var updateSupportTitleWindow:UpdateSupportTitleWindow = new UpdateSupportTitleWindow();
		updateSupportTitleWindow.myinit(iid, crmeap);
		
	}
}

/*
* 新增支持申请，支持反馈
*/
public function onSupportFeedback():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	if (myMainValue && myMainValue.iengineer && myMainValue.iengineer != "" && myMainValue.iengineer != CRMmodel.userId) {
		CRMtool.showAlert("您不是本单据的服务人员，不允许执行此操作。");
	}
	else if (myMainValue && myMainValue.hasOwnProperty("istatus") && myMainValue.istatus && myMainValue.istatus > 2) {
		CRMtool.showAlert("此支持申请已交单，不允许产生支持记录。");
	}
	else if (myMainValue && myMainValue.hasOwnProperty("iid")) {
		var iid:int = myMainValue.iid;
		
		var updateSupportFeedbackTitleWindow:UpdateSupportFeedbackTitleWindow = new UpdateSupportFeedbackTitleWindow();
		updateSupportFeedbackTitleWindow.myinit(iid, crmeap);
		
	}
}

//add by lzx  工作日志生成工作计划
private function openWorkplan():void {
	var param:Object = new Object();
	param.ifuncregedit = "35";
	param.ctable = "oa_workplan";
	param.itemType = "onNew";
	param.operId = "onListNew";
	param.formTriggerType = "fromOther";
	var paramObj:Object = new Object();
	paramObj.icustomer = this.crmeap.getValue().icustomer;    //客户
	paramObj.dmessage = this.crmeap.getValue().dmessage;//提醒时间
	paramObj.bnomessage = this.crmeap.getValue().bnomessage;//逾期不提醒
	paramObj.dbegin = this.crmeap.getValue().dbegin;//开始时间
	paramObj.dend = this.crmeap.getValue().dend;//结束时间
	param.injectObj = paramObj;
	var iid:ArrayCollection = new ArrayCollection();
	param.personArr = iid;
	CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "工作计划", "");
}
/**
 * 审批执行
 * 增加日期: 2012-10-24
 * 创建人: 王炫皓
 * */
public function examineExecute():void {
	//获取表单对象 
	var obj:Object = crmeap.getValue();
	if (obj.istatus != "416" && obj.istatus != "415" && obj.istatus != "414") {
		var sql:String = "update sr_project set istatus  = 414";
		//更改需要字段
		obj.istatus = "414";
		//判断实际开始时间是否为null或空字符
		if (obj.dfactbegin == null || obj.dfactbegin == " ") {
			obj.dfactbegin = new Date();
			sql = sql + ",  dfactbegin = getdate() ";
		}
		sql = sql + " where iid = " + obj.iid;
		//调用后台方法
		AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:Event):void {
			CRMtool.showAlert("审批成功！");
		}, sql);
		var objj:Object = new Object();
		objj.mainValue = obj;
		//关联子表
		//objj.aa_data = obj.aa_data;
		crmeap.setValue(objj, 1, 1);
	} else {
		CRMtool.showAlert("项目已审批！");
	}
}

/**
 * 项目暂停
 * 增加日期: 2012-10-24
 * 创建人: 王炫皓
 * */
public function projectSuspend():void {
	var project:Object = crmeap.getValue();
	/*
	*判断项目状态是否审批
	*/
	if (project.istatus == "414") {
		project.istatus = "415";
		var sql:String = "update sr_project set  istatus = 415 where iid = " + project.iid;
		AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, sql);
		var obj:Object = new Object();
		obj.mainValue = project;
		crmeap.setValue(obj, 1, 1);
	} else {
		CRMtool.showAlert("项目状态为审批才能使用此项操作！");
	}
}
/**
 * 项目关闭
 * 增加日期: 2012-10-24
 * 创建人: 王炫皓
 * */
public function projectClose():void {
	var project:Object = crmeap.getValue();
	/*
	*判断项目状态是否审批
	*/
	if (project.istatus == "414") {
		project.istatus = "416";
		
		project.dfactend = CRMtool.getFormatDateString("YYYY-MM-DD HH:NN:SS", new Date());
		//实际结束时间dfactend
		var sql:String = "update sr_project set  istatus = 416 , dfactend = '#nowDate#'  where iid = " + project.iid;
		AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
			project.mainValue = project;
			crmeap.setValue(project, 1, 1);
		}, sql);
	} else {
		CRMtool.showAlert("当前项目不是审批状态，不能使用此项操作！");
	}
}

/**
 * 项目打开
 * 增加日期: 2012-10-24
 * 创建人: 王炫皓
 * */
public function projectOpen():void {
	var project:Object = crmeap.getValue();
	if (project.istatus == "415" || project.istatus == '416') {
		project.istatus = "414";
		project.dfactend = null;
		var sql:String = "update sr_project set  istatus = 414 ,dfactend = null  where iid = " + project.iid;
		AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, sql);
		var obj:Object = new Object();
		obj.mainValue = project;
		crmeap.setValue(obj, 1, 1);
	} else {
		CRMtool.showAlert("项目已打开");
	}
}
/**
 * 撤销审批
 * 增加日期：2012-10-25
 * 创建人:王炫皓
 * */
public function revokeApproval():void {
	var pj:Object = crmeap.getValue();
	//单据状态为审批 才能撤销审批
	if (pj.istatus == "414") {
		pj.istatus = 413;
		var sql:String = "update sr_project set  istatus = 413  where iid =" + pj.iid;
		AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, sql);
		pj.mainValue = pj;
		crmeap.setValue(pj, 1, 1);
	} else {
		CRMtool.showAlert("此状态不能进行撤销审批操作！");
		return;
	}
}
/**
 * 开发管理 （开发交接更多按钮打开新增开发管理按钮）
 * 作者:王炫皓
 * 创建时间:2012-10-31
 * */
public function openSRProjectAddwoindow():void {
	
	
	var develop:Object = crmeap.getValue();     //获取当前单据
	var param:Object = {};      //需要传入的参数
	var injectobj:Object = {};     //相关单据信息
	
	injectobj.ifuncregedit = "206";      //当前单据类型
	injectobj.iinvoice = develop.iid;  //相关单据内码
	injectobj.icustomer = develop.icustomer; //开发客户
	injectobj.cdetail = develop.cdetail; // 内容
	injectobj.idepartment = develop.idepartment; //业务部门
	injectobj.iperson = develop.iperson;// 业务人员
	injectobj.itype = develop.itype;
	
	param.ifuncregedit = "208";
	param.ctable = "sr_project";
	param.itemType = "onNew";
	param.operId = "onListNew";
	param.formTriggerType = "fromOther";
	param.injectObj = injectobj;
	var iid:ArrayCollection = new ArrayCollection();
	param.personArr = iid;
	
	//CRMtool.removeChildFromViewStack();
	CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "新增实施管理", "");
}
/**
 * 开发管理卡片（进程推进）
 * 创建人:王炫皓
 * 创建时间:2012-11-01
 * */
public function openInvoiceProcess208():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	
	
	var param:Object = {};//总体需要传入参数
	var injectObj:Object = {};
	
	injectObj.ifuncregedit = "208";//相关单据类型
	injectObj.iinvoice = myMainValue.iid;
	//injectObj.iifuncregedit = 298;
	injectObj.iprocess = myMainValue.iphase;
	injectObj.icustomer = myMainValue.icustomer;
	param.ifuncregedit = 258;
	param.ctable = "ab_invoiceprocess";
	param.itemType = "onNew";
	param.operId = "onListNew";
	param.formTriggerType = "fromOther";
	param.injectObj = injectObj;
	var iid:ArrayCollection = new ArrayCollection();
	param.personArr = iid;
	
	//CRMtool.removeChildFromViewStack();
	CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "加载中…", "");
}
/**
 * 开发管理卡片（功能按钮实施变更）
 * 创建人:王炫皓
 * 创建时间:2012-11-1
 * */
public function submitChangeSrproject208():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	var istatus:int = myMainValue.istatus;
	
	if(istatus == 416) {
		CRMtool.showAlert("订单已关闭，不能进行此操作！");
		return;
	}
	
	var param:Object = {};//总体需要传入参数
	var srproject:Object = {};
	
	srproject.ifuncregedit = "208";//相关单据类型
	srproject.iinvoice = myMainValue.iid;//相关单据内码(当前服务派工单内码)
	
	srproject.ioperson = myMainValue.iperson;
	srproject.iperson = myMainValue.iperson;
	srproject.dobegin = myMainValue.dplanbegin;
	srproject.dbegin = myMainValue.dplanbegin;
	srproject.doend = myMainValue.dplanend;
	srproject.dend = myMainValue.dplanend;
	srproject.foworkday = myMainValue.fplan;
	srproject.fworkday = myMainValue.fplan;
	
	param.ifuncregedit = "364";
	param.ctable = "sr_projectchange";
	param.itemType = "onNew";
	param.operId = "onListNew";
	param.formTriggerType = "fromOther";
	param.injectObj = srproject;
	var iid:ArrayCollection = new ArrayCollection();
	param.personArr = iid;
	
	//CRMtool.removeChildFromViewStack();
	CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "新建开发变更", "");
}

/**
 * 新建实施日志 更多操作下 打开实施回访
 * */
public function openFeedBackWindow():void {
	var log:Object = crmeap.getValue();     //获取当前单据
	
	var param:Object = {};      //需要传入的参数
	var injectobj:Object = {};  //相关单据信息
	
	injectobj.ifuncregedit = "220";    //相关单据类型
	injectobj.icustperson = log.icustperson;
	injectobj.iperson = log.iperson;// 业务人员
	injectobj.iinvoice = log.iid;  //相关单据
	//回访时间
	injectobj.ddate = new Date();
	
	injectobj.ifunconsult = 251;
	
	//获取项目信息
	var sql:String = "select icustomer,ctel from sr_project where iid = ( select iproject from sr_projects where iproject = " + log.iproject + " and ddate= '" + log.ddate + "')";
	var object:Object = null;
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (result:ResultEvent):void {
		//回访客商
		injectobj.icustomer = result.result[0].icustomer;
		//联系电话
		injectobj.ctel = result.result[0].ctel;
		param.ifuncregedit = "204";
		param.ctable = "sr_feedback";
		param.itemType = "onNew";
		param.operId = "onListNew";
		param.formTriggerType = "fromOther";
		param.injectObj = injectobj;
		var iid:ArrayCollection = new ArrayCollection();
		param.personArr = iid;
		CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "新增实施回访", "");
	}, sql);
}
/**
 * 通过各种合同的浏览状态的更多功能中打开业绩分摊界面
 * 增加日期：2012-10-18
 * 创建者：XZQWJ
 * */

public function openCTShareRatePage():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	var iid:String = myMainValue.iid;
	var sharerateView:ShareRateInvoiceprocessWindow = new ShareRateInvoiceprocessWindow();
	var obj_winParm:Object = new Object();
	obj_winParm.ifuncregedit = 319;
	obj_winParm.ctable = "sc_orderapportion";
	obj_winParm.outifuncregedit = 0;
	obj_winParm.arrList = myMainValue;
	obj_winParm.sc_orderapportion = new ArrayCollection(CRMtool.ObjectCopy(myMainValue.sc_orderapportion.toArray()));
	sharerateView.winParam = obj_winParm;
	sharerateView.outCrmEap = this.crmeap;
	//sharerateView.outCrmEap.tableMessage=myMainValue.sc_orderapportion;
	var obj:Object = new Object();
	obj.ifuncregedit = myMainValue.iifuncregedit;
	obj.iinvoice = iid;
	sharerateView.paramObj = obj;
	sharerateView.width = 800;
	sharerateView.height = 450;
	CRMtool.openView(sharerateView);
}

//add by lzx新建客商管理更多操作，新建商机
private function openOpportunity():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	
	var paramObj:Object = new Object();
	paramObj.icustomer = myMainValue.iid;
	
	var param:Object = new Object();
	param.ifuncregedit = "80";
	param.ctable = "sa_opportunity";
	param.itemType = "onNew";
	param.operId = "onListNew";
	param.formTriggerType = "fromOther";
	
	param.injectObj = paramObj;
	var iid:ArrayCollection = new ArrayCollection();
	param.personArr = iid;
	
	CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "加载中 ...", "");
}

private function service2workdiary():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	
	var paramObj:Object = new Object();
	paramObj.icustomer = myMainValue.icustomer;
	//  paramObj.itype =  "503";
	//  paramObj.istyle = "427";
	paramObj.icustperson = myMainValue.icustperson;
	paramObj.iinvoice = myMainValue.iid;
	paramObj.ifuncregedit = myMainValue.iifuncregedit;
	
	var param:Object = new Object();
	param.ifuncregedit = "46";
	param.ctable = "oa_workdiary";
	param.itemType = "onNew";
	param.operId = "onListNew";
	param.formTriggerType = "fromOther";
	
	param.injectObj = paramObj;
	var iid:ArrayCollection = new ArrayCollection();
	param.personArr = iid;
	
	CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "加载中 ...", "");
}

private function implement2workdiary():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	
	var paramObj:Object = new Object();
	paramObj.icustomer = myMainValue.icustomer;
	//  paramObj.itype =  "503";
	//  paramObj.istyle = "427";
	paramObj.icustperson = myMainValue.icustperson;
	paramObj.iinvoice = myMainValue.iid;
	paramObj.ifuncregedit = myMainValue.iifuncregedit;
	
	var param:Object = new Object();
	param.ifuncregedit = "46";
	param.ctable = "oa_workdiary";
	param.itemType = "onNew";
	param.operId = "onListNew";
	param.formTriggerType = "fromOther";
	
	param.injectObj = paramObj;
	var iid:ArrayCollection = new ArrayCollection();
	param.personArr = iid;
	
	CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "加载中 ...", "");
}
/**
 * 新建销售线索更多操作下
 * 更改单据状态
 * 0、线索失效 1
 * */
public function changeSaclueIstatusInvalid():void {
	var mainValue:Object = crmeap.getValue();
	if (mainValue.istatus == 1) {
		changeSaclue(mainValue,crmeap);
	}
}
public function changeSaclue( mainValue:Object, crmeap:CrmEapRadianVbox = null):void{
	var more:MoreHandleTW = new MoreHandleTW();
	more.formIfunIid = 414;
	more.width = 400;
	more.height = 200;
	more.title = "线索失效";
	
	var obj:Object = new Object();
	obj.closecause = mainValue.closecause;
	more.injectObj = obj;
	more.addEventListener("onSubmit", function (e:Event):void {
		var newObj:Object = more.crmeap.getValue();
		mainValue.closecause = newObj.closecause;
		
		var sql:String = "update sa_clue set istatus = 0,closecause = '" + newObj.closecause + "' where iid = " + mainValue.iid;
		AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
			mainValue.istatus = 0;
			mainValue.mainValue = mainValue;
			crmeap.setValue(mainValue, 1, 1);
			CRMtool.showAlert("操作成功。");
		}, sql, null, false);
	})
	more.open();
}


/**
 * 新建销售线索更多操作下
 * 更改单据状态
 * 2、线索生效
 * */
public function changeSaclueIstatusValid():void {
	var saclueObjects:Object = crmeap.getValue();
	if (saclueObjects.istatus == 0 || saclueObjects.istatus == null || saclueObjects.istatus == "") {
		var sql:String = "update sa_clue set  istatus = 1  where iid =" + saclueObjects.iid;
		saclueObjects.istatus = 1;
		AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, sql);
		var obj:Object = new Object;
		obj.mainValue = saclueObjects;
		crmeap.setValue(obj, 1, 1);
		
	}
	
}

/**
 * 合同生成通用费用
 * */
public function openExpense():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	
	var paramObj:Object = new Object();
	//  paramObj.icustomer=myMainValue.icustomer;
	//  paramObj.icustperson = myMainValue.icustperson;
	paramObj.iinvoice = myMainValue.iid;
	paramObj.ifuncregedit = myMainValue.iifuncregedit;
	
	var param:Object = new Object();
	param.ifuncregedit = "275";
	param.ctable = "oa_expense";
	param.itemType = "onNew";
	param.operId = "onListNew";
	param.formTriggerType = "fromOther";
	
	param.injectObj = paramObj;
	var iid:ArrayCollection = new ArrayCollection();
	param.personArr = iid;
	
	CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "加载中 ...", "");
	
}


/**
 * 赠品申请生成赠品出库
 * */
public function openPremiums():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	if(myMainValue.istatus==0){
		CRMtool.showAlert("单据未审核！");
		return;
	}
	var sql:String="select istatus  from sc_rdrecord where iifuncregedit=428 and iid="+myMainValue.iid;
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (result:ResultEvent):void {
		var res:ArrayCollection = result.result as ArrayCollection;
		if(res.length>0 || res!=null ){
			if(res[0].istatus==2){
		     	CRMtool.showAlert("该赠品已经出库，不能再次出库！");
		        return;
			}else{
				var paramObj:Object = new Object();
				paramObj.icustomer=myMainValue.icustomer;
				paramObj.idepartment=myMainValue.idepartment;
				paramObj.iinvoice=myMainValue.iid;
				paramObj.iperson=myMainValue.iperson;
				paramObj.fsum=myMainValue.fsum;
				var ac:ArrayCollection=myMainValue.sc_rdrecords;
				for each (var item:Object in ac){
					delete item.iid;
					delete item.irdrecord;
				}
				paramObj.sc_rdrecords=ac;
				var param:Object = new Object();
				param.ifuncregedit = "427";
				param.ctable = "sc_rdrecord";
				param.itemType = "onNew";
				param.operId = "onListNew";
				param.formTriggerType = "fromOther";
				
				param.injectObj = paramObj;
				var iid:ArrayCollection = new ArrayCollection();
				param.personArr = iid;
				
				CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "加载中 ...", "");
			}
		}
	},sql);
	
	
}

/**
 * 耗材合同生成耗材出库
 * */
public function openConsumable():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	
	var paramObj:Object = new Object();
	paramObj.icustomer = myMainValue.icustomer;
	paramObj.idepartment = myMainValue.idepartment;
	paramObj.iperson = myMainValue.iperson;
	paramObj.iinvoice = myMainValue.iid;
	paramObj.idelivery = myMainValue.idelivery;
	paramObj.ifuncregedit = myMainValue.iifuncregedit;
	paramObj.ifunconsult = 158;
	paramObj.fsum = myMainValue.fsum;
	
	var sql:String = "select fsum,frdsum,istatus from SC_order where iid = " + paramObj.iinvoice;
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (result:ResultEvent):void {
		var res:ArrayCollection = result.result as ArrayCollection;
		if(res.length>0){
			if(res[0].istatus!=1){
				CRMtool.showAlert("耗材合同未审核或者已经关闭！");
				return;
			}
			if(res[0].fsum == res[0].frdsum ||res[0].fsum < res[0].frdsum){
				CRMtool.showAlert("耗材已出库！");//根据合同中的累计发货判断耗材是否已经出库
				return;
			}else{
				var sc_rdrecords:ArrayCollection = new ArrayCollection(CRMtool.ObjectCopy(myMainValue.sc_orders.toArray()));
				var sc_rdrecord:ArrayCollection = new ArrayCollection();
				for each(var item:Object in sc_rdrecords) {
					item.fprice = item.ftaxprice;
					item.fsum = item.ftaxsum;
                    item.fstaxprice=item.fcostprice;
                    item.fstaxsum=item.fcost;
					item.iinvoice = paramObj.iinvoice;
					sc_rdrecord.addItem(pushBeltLinkedData(item));
				}
				paramObj.sc_rdrecords = sc_rdrecord;
				
				var param:Object = new Object();
				param.ifuncregedit = "167";
				param.ctable = "sc_order";
				param.itemType = "onNew";
				param.operId = "onListNew";
				param.formTriggerType = "fromOther";
				
				param.injectObj = paramObj;
				var iid:ArrayCollection = new ArrayCollection();
				param.personArr = iid;
				
				CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "加载中 ...", "");
				
			}
		}
	},sql);
		
		
	
		}
/**
 * 服务费合同推出销售发票
 * 创建人：王炫皓
 * 创建时间：201212225
 * */
public function orderPushSalesInvoice():void {
	//获取当前页面信息
	var order:Object = crmeap.getValue();
	var sql:String = "select*from sc_spinvoice where iinvoice = " + order.iid;
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (result:ResultEvent):void {
		var res:ArrayCollection = result.result as ArrayCollection;
		if (res && res.length > 0) {
			CRMtool.showAlert("单据已生成！");
		} else {
			//需要传入的参数
			var paramObj:Object = new Object();
			paramObj.icustomer = order.icustomer;
			paramObj.idepartment = order.idepartment;
			paramObj.iperson = order.iperson;
			paramObj.iinvoice = order.iid;
			paramObj.ifuncregedit = order.iifuncregedit;
			paramObj.ifunconsult = 160;
			var sc_spinvoices:ArrayCollection = new ArrayCollection;
			var sum:String = "0";
			for each (var sc_order:Object in order.sc_orders) {
				//计算合计金额
				sum = this.parseFloat(sum) + this.parseFloat(sc_order.ftaxsum);
				sc_spinvoices.addItem(pushBeltLinkedData(sc_order));
			}
			paramObj.sc_spinvoices = sc_spinvoices;
			paramObj.fsum = sum.toString();
			var param:Object = new Object();
			param.ifuncregedit = "165";
			param.ctable = "sc_spinvoice";
			param.itemType = "onNew";
			param.operId = "onListNew";
			param.formTriggerType = "fromOther";
			
			param.injectObj = paramObj;
			var iid:ArrayCollection = new ArrayCollection();
			param.personArr = iid;
			CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "加载中 ...", "");
		}
	}, sql);
	
}
/**
 * 耗材出库推出销售发票
 * 带出对应合同的信息，合同生成发表则给出提示不用在生成
 * 创建人：王炫皓
 * 创建时间：20121225
 * */
public function warehousingPushSalesInvoice():void {
	//获取当前页面信息
	var supplies:Object = crmeap.getValue();
	var sql:String = "select*from sc_spinvoice where iinvoice = " + supplies.iinvoice;
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (result:ResultEvent):void {
		var res:Object = result.result;
		if (res && res.length > 0) {
			CRMtool.showAlert("单据已生成！");
			return;
		} else {
			//需要传入的参数
			var paramObj:Object = new Object();
			paramObj.icustomer = supplies.icustomer;
			paramObj.idepartment = supplies.idepartment;
			paramObj.iperson = supplies.iperson;
			paramObj.iinvoice = supplies.iinvoice;
			paramObj.ifuncregedit = supplies.ifuncregedit;
			paramObj.ifunconsult = 158;
			var sr:ArrayCollection = new ArrayCollection;
			var sc_rdrecords:ArrayCollection = new ArrayCollection(CRMtool.ObjectCopy(supplies.sc_rdrecords.toArray()));
			var sum:String = "0";
			for each(var item:Object in sc_rdrecords) {
				item.ftaxprice = item.fprice;
				item.ftaxsum = item.fsum;
				
				sum = this.parseFloat(sum) + this.parseFloat(item.ftaxsum);
				sr.addItem(pushBeltLinkedData(item));
			}
			paramObj.sc_spinvoices = sr;
			paramObj.fsum = sum.toString();
			var param:Object = new Object();
			param.ifuncregedit = "165";
			param.ctable = "sc_spinvoice";
			param.itemType = "onNew";
			param.operId = "onListNew";
			param.formTriggerType = "fromOther";
			
			param.injectObj = paramObj;
			var iid:ArrayCollection = new ArrayCollection();
			param.personArr = iid;
			CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "加载中 ...", "");
		}
	}, sql);
}
/**
 * 重新封装单据内子表
 * @param :obj 子表
 * @return :封装后的对象
 * 创建人:王炫皓
 * 创建时间20130105
 * */
private function pushBeltLinkedData(obj:Object):Object {
	/*
	*从新封装子表对象
	*/
	var objInfo:Object = ObjectUtil.getClassInfo(obj);
            var fieldName:Array = objInfo["properties"] as Array;
            var newObj:Object = new Object();
            for each (var q:QName in fieldName) {
                if (q.localName != "iid") {
                    newObj[q.localName] = obj[q.localName];
		}
	}
	return newObj;
}


/*测试表单*/
public function formCopy():void{
	crmeap.formDataCopy();
}


private function setPersonLeave():void {
	//lr 离职清空人员对应角色信息
	var obj:Object = crmeap.getValue();
	if (obj.bjobstatus != 1) {
		CRMtool.showAlert("已经是离职人员，操作无效。");
	} else {
		CRMtool.tipAlert1("确认对该人员执行离职操作？此操作将收回其被赋予的角色和相应权限，并且此操作不可逆。", null, "AFFIRM", function ():void {
			var sqlStr:String = "delete as_roleuser where iperson=" + obj.iid +
			" delete ab_invoiceuser where iperson=" + obj.iid + " " +
			" update hr_person set bjobstatus=0,busestatus=0 where iid=" + obj.iid;
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
				CRMtool.showAlert("操作成功。");
				obj.bjobstatus = 0;
				obj.busestatus = 0;
				obj.mainValue = obj;
				crmeap.setValue(obj, 1, 1);
			}, sqlStr, null, false);
		})
	}
}

//add by zhongjing
private function delDutyState():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	var dutys:ArrayCollection = new ArrayCollection();
	var oa_dutys:ArrayCollection = myMainValue.oa_dutys as ArrayCollection;
	if (oa_dutys) {
		for each(var obj:Object in oa_dutys) {
			if (obj.irole == 602 || obj.irole == 603) {
				dutys.addItem(obj);
			}
		}
	}
	if (myMainValue.iid) {
		AccessUtil.remoteCallJava("OADest", "deleteDutyState", function (event:ResultEvent):void {
			var istate:int = event.result as int;
			if (istate == 1) {
				myMainValue.istate = 3;
				crmeap.setValue(crmeap.fzsj(myMainValue), 1, 1);
				CRMtool.showAlert("单据失效成功。");
			} else if (istate == 0) {
				CRMtool.showAlert("单据失效失败。");
			}
			else {
				CRMtool.showAlert("单据未执行生效操作，无需执行失效操作。");
			}
			
		}, {iid: myMainValue.iid, dutys: dutys});
	}
	
}

//客户推送 客户关系
private function cs_customer2cr_356():void {
	if (!crmeap)
		return;
	
	var mainValue:Object = crmeap.getValue();
	var param:Object = new Object();
	var injectObj:Object = new Object();
	
	param.outifuncregedit = "356";
	param.ifuncregedit = "356";
	
	injectObj.icustomer = mainValue.iid;
	injectObj.icustomer_NAME = mainValue.cname;
	
	param.injectObj = injectObj;
	CRMtool.openMenuItemFormOther("yssoft.comps.frame.CustomerRelationship", param, "客商组织");
}
/**
 * 培训管理推培训回访（选中培训卡片中的 任意 参与人员 生成 培训回访）
 * 创建人：王炫皓
 * 创建时间:20130720
 */
private function push_196_198():void {
	//获取页面元素
	var mainValue:Object = crmeap.getValue();
	//获取培训管理子表
	var gridList:ArrayCollection = crmeap.gridList;
	var sr_trains:CrmEapDataGrid;
	for each (var g:CrmEapDataGrid in gridList) {
		sr_trains = g;
	}
	var tranin:Object = null;
	if (sr_trains != null)
		tranin = sr_trains.selectedItem;
	if (tranin == null) {
		CRMtool.showAlert("为选择参训人员，不允许回访!");
		return;
	}
	var paramObj:Object = new Object();
	paramObj.icustomer = tranin.icustomer;
	paramObj.icustperson = tranin.icustperson;
	paramObj.iinvoice = mainValue.iid;
	paramObj.ifuncregedit = mainValue.iifuncregedit;
	paramObj.iperson = mainValue.iperson;
	
	var param:Object = new Object();
	param.ifuncregedit = "198";
	param.ctable = "sr_feedback";
	param.itemType = "onNew";
	param.operId = "onListNew";
	param.formTriggerType = "fromOther";
	
	param.injectObj = paramObj;
	var iid:ArrayCollection = new ArrayCollection();
	param.personArr = iid;
	
	CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "加载中 ...", "");
}

private function setCustomerLogoutTrue():void {
	var mainValue:Object = crmeap.getValue();
	var iid:int = mainValue.iid;
	if (iid > 0) {
		var sql:String = "update cs_customer set blogout=1 where iid=" + iid;
		AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, sql);
		var obj:Object = new Object;
		mainValue.blogout = 1;
		obj.mainValue = mainValue;
		crmeap.setValue(obj, 1, 1);
		CRMtool.showAlert("注销成功。");
	}
}

private function setCustomerLogoutFalse():void {
	var mainValue:Object = crmeap.getValue();
	var iid:int = mainValue.iid;
	if (iid > 0) {
		var sql:String = "update cs_customer set blogout=0 where iid=" + iid;
		AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, sql);
		var obj:Object = new Object;
		mainValue.blogout = 0;
		obj.mainValue = mainValue;
		crmeap.setValue(obj, 1, 1);
		CRMtool.showAlert("启用成功。");
	}
}

//培训申请失效
private function setTrainrequestInvalid():void {
	var mainValue:Object = crmeap.getValue();
	var iid:int = mainValue.iid;
	
	if (mainValue.istatus == 3) {
		CRMtool.showAlert("单据已是终止状态，无需再次终止。");
		return;
	}
	
	if (iid > 0) {
		
		var sql1:String = "select iid from  sr_trainrequests where iid in (select iinvoices from sr_trains) and itrainrequest=" + iid;
		AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
			var ac:ArrayCollection = e.result as ArrayCollection;
			if (ac.length > 0) {
				CRMtool.showAlert("此培训申请中，已有记录参与培训注册，无法执行此操作。");
				return;
			} else {
				var sql:String = "update sr_trainrequest set istatus=3 where iid=" + iid;
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, sql);
				CRMtool.showAlert("终止成功。");
				
				mainValue.istatus = 3;
				mainValue.mainValue = mainValue;
				crmeap.setValue(mainValue, 1, 1);
			}
		}, sql1);
	}
}

//培训申请生效
private function setTrainrequestValid():void {
	var mainValue:Object = crmeap.getValue();
	var iid:int = mainValue.iid;
	if (mainValue.istatus != 3) {
		CRMtool.showAlert("单据已不是终止状态，无需撤销终止。");
		return;
	}
	if (iid > 0) {
		var sql:String = "update sr_trainrequest set istatus=0 where iid=" + iid;
		AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, sql);
		CRMtool.showAlert("撤销终止成功。");
		
		mainValue.istatus = 0;
		mainValue.mainValue = mainValue;
		crmeap.setValue(mainValue, 1, 1);
	}
}

//预录入发票
public function onPredictSave():Boolean{
	var mainValue:Object = this.crmeap.getValue();
	var invoice_stcode:String = mainValue.cinvoice_stcode;//发票开始编号
	var contract_stcode:String = mainValue.ccontract_stcode;//合同开始编号
	var invoice_stNum:String = mainValue.iinvoice_stnum;//发票顺序开始数
	var invoice_ednum:String = mainValue.iinvoice_ednum;//发票顺序结束数
	var contract_stnum:String = mainValue.icontract_stnum;//合同顺序开始数
	var contract_ednum:String = mainValue.icontract_ednum;//合同顺序结束数
	var invoice_cmemo:String = mainValue.cmemo;//备注
	var invoice_imaker:int = mainValue.imaker;//制单人
	var invoice_dmaker:String = mainValue.dmaker;//制单日期
	var regEx:RegExp = /^\d+$/;
	
	if(!( regEx.test(invoice_stNum)) || !( regEx.test(invoice_ednum)) || !( regEx.test(contract_stnum)) || !(regEx.test(contract_ednum))){
		CRMtool.showAlert("输入格式非法！");
		return false;
	}else{
		if((Number(invoice_ednum) - Number(invoice_stNum) < 0) || (Number(contract_ednum) - Number(contract_stnum) < 0)){
			CRMtool.showAlert("开始数不能大于结束数！");
			return false;
		}if((Number(invoice_ednum) - Number(invoice_stNum)) != (Number(contract_ednum) - Number(contract_stnum))){
			CRMtool.showAlert("发票数目和合同数目不匹配！");
			return false;
		}else{
			var count:int = Number(invoice_ednum) - Number(invoice_stNum) + 1;//循环次数
			var arr:ArrayCollection = new ArrayCollection();
			for(var i=0;i<count;i++){
				var invoice_ccode = invoice_stcode + (Number(invoice_stNum) + i);
				var contract_ccode = contract_stcode + (Number(contract_stnum) + i);
				var paramObj:Object = new Object();
				paramObj.ccode = invoice_ccode;
				paramObj.ccontcode = contract_ccode;
				paramObj.istatus = 0;
				paramObj.istatus_Name = '未使用';
				paramObj.cmemo = invoice_cmemo;
				paramObj.imaker = invoice_imaker;
				paramObj.dmaker = invoice_dmaker;
				paramObj.ifuncregedit = mainValue.iifuncregedit;
				paramObj.iifuncregedit =  391;
				arr.addItem(paramObj);
			}
			mainValue.tr_invoice = arr;
			mainValue.mainValue = mainValue;
			crmeap.setValue(mainValue, 1, 1);
			
		}
	}
	return true;
}
//发票领用
private function allotInvoice():void {
	var mainValue:Object = crmeap.getValue();
	
	var iid:int = mainValue.iid;
	if (!(iid > 0))
		return;
	
	ServiceTool.allotInvoice(moreLabel, iid, mainValue, crmeap);
}



//收费单合同日期更改   by ln
private function modifycontdate():void {
	var mainValue:Object = crmeap.getValue();
	
	var iid:int = mainValue.iid;
	var icustomer:int = mainValue.icustomer;
	if (!(iid>0))
		return;
	
	ServiceTool.modifycontdate(moreLabel,iid, mainValue, crmeap);
}



//发票退领
private function returnInvoice():void{
	var mainValue:Object = crmeap.getValue();
	var iid:int = mainValue.iid;
	if (!(iid > 0))
		return;
	
	var sql:String = "select istatus from tr_invoice where iid = " + iid;
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
		var list:ArrayCollection = event.result as ArrayCollection;
		if (list && list.length > 0) {
			var istatus:int = list[0].istatus;
			if (istatus == 1) {
				var sql:String = "update tr_invoice set iperson = null,istatus = 0 where iid = " + iid;
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
					mainValue.iperson = "";
					mainValue.istatus = 0;
					mainValue.mainValue = mainValue;
					crmeap.setValue(mainValue, 1, 1);
				}, sql, null, false);
				
			} else {
				CRMtool.showAlert("发票非领用状态，不允许退领！");
				return;
			}
		} else {
			CRMtool.showAlert("数据有误，请检查！");
		}
	}, sql);
}
//发票作废、遗失
private function cancelInvoice():void{
	var mainValue:Object = crmeap.getValue();
	var iid:int = mainValue.iid;
	if (!(iid > 0))
		return;
	
	var sql:String = "select istatus from tr_invoice where iid = " + iid;
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
		var list:ArrayCollection = event.result as ArrayCollection;
		if (list && list.length > 0) {
			var istatus:int = list[0].istatus;
			if (istatus == 0 || istatus == 1) {
				var newStatus:int = 4;//发票作废
				if(moreLabel == "发票遗失"){
					newStatus = 5;//发票遗失
				}
				var sql:String = "update tr_invoice set istatus = "+ newStatus +" where iid = " + iid;
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
					mainValue.istatus = newStatus;
					mainValue.mainValue = mainValue;
					crmeap.setValue(mainValue, 1, 1);
				}, sql, null, false);
				
			} else {
				CRMtool.showAlert("发票非未使用或领用状态，不允许作废或遗失！");
				return;
			}
		} else {
			CRMtool.showAlert("数据有误，请检查！");
		}
	}, sql);
}
//收费单审核
public function verifyCont():void{
	var mainValue:Object = crmeap.getValue();
	var iid:int = mainValue.iid;
	if (!(iid > 0))
		return;
	
	var sql:String = "select istatus,ibustype from tr_charge where iid = " + iid;
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
		var list:ArrayCollection = event.result as ArrayCollection;
		if (list && list.length > 0) {
			var istatus:int = list[0].istatus;
			if (istatus == 0) {
				var ibustype:int = list[0].ibustype;
				var newStatus:int = 2;//已审核
				if(ibustype == 2){//收费方式为转账未到
					newStatus = 1;//转账未到
				}
				var sql:String = "update tr_charge set istatus = "+ newStatus +",iverify = " + CRMmodel.userId + ",dverify = getdate() where iid = " + iid +";";
				if(newStatus == 2){
					sql += "update tr_invoice set istatus = 3 where iid= (select iinvoice from tr_charge where iid = " + iid + ") and istatus = 2;" +
					"insert into tr_invoices select a.iinvoice,a.iid,3,a.iperson,b.icustomer,b.iverify,b.dverify,a.cmemo from tr_invoice a,tr_charge b where a.iid = b.iinvoice and b.iid = " + iid +
					";update CS_customer set " +
					"dscontdate = (case when isnull(t.dmscontdate,'')='' then (case when t.dscontdate>cs_customer.dscontdate then t.dscontdate else cs_customer.dscontdate end) "+
					"else (case when t.dmscontdate>cs_customer.dscontdate then t.dmscontdate else cs_customer.dscontdate end) end), "+
					"decontdate = (case when isnull(t.dmecontdate,'')='' then (case when t.decontdate>cs_customer.decontdate then t.decontdate else cs_customer.decontdate end) "+ 
					"else (case when t.dmecontdate>cs_customer.decontdate then t.dmecontdate else cs_customer.decontdate end) end) " +
					"from tr_charge t where t.icustomer = CS_customer.iid and t.istatus = 2 and t.iid = " +iid;
				}
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
					mainValue.istatus = newStatus;
					mainValue.mainValue = mainValue;
					crmeap.setValue(mainValue, 1, 1);
					CRMtool.showAlert("操作成功");
					
				}, sql, null, false);
			} else {
				CRMtool.showAlert("收费单已审核，无需再次审核！");
				return;
			}
		} else {
			CRMtool.showAlert("数据有误，请检查！");
		}
	}, sql);
}
//收费单汇票已到
public function accountCont():void{
	var mainValue:Object = crmeap.getValue();
	var iid:int = mainValue.iid;
	if (!(iid > 0))
		return;
	
	var sql:String = "select istatus from tr_charge where iid = " + iid;
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
		var list:ArrayCollection = event.result as ArrayCollection;
		if (list && list.length > 0) {
			var istatus:int = list[0].istatus;
			if (istatus == 1) {
				var sql:String = "update tr_charge set istatus = 2,ibustype = (case when ibustype = 2 then 3 else ibustype end ) where iid = " + iid +
				";update tr_invoice set istatus = 3 where iid= (select iinvoice from tr_charge where iid = " + iid + ") and istatus = 2;" +
				"insert into tr_invoices select a.iinvoice,a.iid,3,a.iperson,b.icustomer,b.iverify,b.dverify,a.cmemo from tr_invoice a,tr_charge b where a.iid = b.iinvoice and b.iid = " + iid +
				";update CS_customer set dscontdate = (case when t.dmscontdate is null then t.dscontdate else t.dmscontdate end),decontdate = (case when t.dmecontdate is null then t.decontdate else t.dmecontdate end) " +
				"from tr_charge t where t.icustomer = CS_customer.iid and t.istatus = 2 and t.iid = " +iid;
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
					CRMtool.showAlert("操作成功");
				}, sql, null, false);
			} else {
				CRMtool.showAlert("收费单非转账未到状态，不能进行操作！");
				return;
			}
		} else {
			CRMtool.showAlert("数据有误，请检查！");
		}
	}, sql);
}
//收费单退审
public function returnCont():void{
	var mainValue:Object = crmeap.getValue();
	var iid:int = mainValue.iid;
	if (!(iid > 0))
		return;
	
	var sql:String = "select istatus,ibustype from tr_charge where iid = " + iid;
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
		var list:ArrayCollection = event.result as ArrayCollection;
		if (list && list.length > 0) {
			var istatus:int = list[0].istatus;//收费单状态
			var ibustype:int = list[0].ibustype;//收费单收款方式
			if ((istatus == 2 && ibustype != 2) || (istatus == 1 && ibustype == 2)) {
				var sql:String = "update tr_charge set istatus = 0 where iid = " + iid +
				";update cs_customer set dscontdate = a.dscontdate,decontdate = a.decontdate from "+
				"(select max(iid) iid,case when dmscontdate is null then dscontdate else dmscontdate end dscontdate, "+ 
				"case when dmecontdate is null then decontdate else dmecontdate end decontdate,icustomer "+
				"from tr_charge where istatus > 1 and iid <> " + iid +
				"group by dscontdate,decontdate,dmscontdate,dmecontdate,icustomer) a "+ 
				"where cs_customer.iid = a.icustomer "+
				";update tr_invoice set istatus = 2 where iid= (select iinvoice from tr_charge where iid = " + iid + ") and istatus = 3;" +
				"insert into tr_invoices select a.iinvoice,a.iid,2,a.iperson,b.icustomer,b.iverify,b.dverify,isnull(a.cmemo,'')+'(被退审)' from tr_invoice a,tr_charge b where a.iid = b.iinvoice and b.iid = "+iid;
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
					mainValue.istatus = 0;
					mainValue.mainValue = mainValue;
					crmeap.setValue(mainValue, 1, 1);
					CRMtool.showAlert("操作成功");
				}, sql, null, false);
			}else if(istatus == 2 && ibustype == 2){
				CRMtool.showAlert("汇款已到，不能退审！");
				return;
			}else if(istatus == 3){
				CRMtool.showAlert("已生成交割单，不能退审！");
				return;
			}else {
				CRMtool.showAlert("收费单未审核，不能退审！");
				return;
			}
		} else {
			CRMtool.showAlert("数据有误，请检查！");
		}
	}, sql);
}

//收费单生成交割单
public function toNewDelivery():void{
	var mainValue:Object = crmeap.getValue();
	var iid:int = mainValue.iid;
	var icus:int = mainValue.icustomer;//客商内码
	var iecstatus:int = mainValue.iecstatus;//收费后状态
	if (!(iid > 0))
		return;
	
	var sql:String = "select istatus from tr_charge where iid = " + iid;
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
		var list:ArrayCollection = event.result as ArrayCollection;
		if (list && list.length > 0) {
			var istatus:int = list[0].istatus;
			if (istatus == 2) {
				var sql:String = "update tr_charge set istatus = 3,ddelivery = getdate(),cdelivery = convert(varchar(10),getdate(),112)+'"+iid+"' " +
				"where iid = " + iid+";"+
				"update cs_customer set iskstatus="+iecstatus+" where iid="+icus;
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
					CRMtool.showAlert("操作成功");
				}, sql, null, false);
			}else if(istatus == 3){
				CRMtool.showAlert("已生成交割单，无需再次生成！");
				return;
			}else if(istatus == 1){
				CRMtool.showAlert("转账未到，不能生成交割单！");
				return;
			}else {
				CRMtool.showAlert("收费单未审核，不能生成交割单！");
				return;
			}
		} else {
			CRMtool.showAlert("数据有误，请检查！");
		}
	}, sql);
}

//更新收费合同服务到期日期    by ln 2014-04-17
public function updateServerDate():void {
	var mainValue:Object = crmeap.getValue();
	//修改合同fsumpercent
	
	var iid:int = mainValue.iid;
	var dsbegin:String = mainValue.dsbegin;
	var dsend:String = mainValue.dsend;
	var icustproduct:int = mainValue.sc_orders2[0].icustproduct;
	
	
	var sql:String = "select istatus from sc_order where iid = " + iid;
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
		var list:ArrayCollection = event.result as ArrayCollection;
		if (list && list.length > 0) {
			var istatus:int = list[0].istatus;
			if (istatus == 1) {
				//SZC Add 20141119  更新服务收费合同服务日期
                //tb Edit
                var sql:String ="";
                for each(var item:Object in mainValue.sc_orders2){
                    sql+="update cs_custproduct set dsbegin = '"+ dsbegin + "' ,dsend =  '"+ dsend +"'  where iid = " + item.icustproduct+";";
                }


				//end
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
					CRMtool.showAlert("操作成功");
				}, sql, null, false);
			}else if(istatus == 0){
				CRMtool.showAlert("未审核服务收费单据，不能更新服务日期！");
				return;
			}else if(istatus == 2){
				CRMtool.showAlert("服务收费单据已关闭，不能更改服务日期！");
				return;
			}else {
				CRMtool.showAlert("收费单据状态错误！");
				return;
			}
		} else {
			CRMtool.showAlert("数据有误，请检查！");
		}
	}, sql);
	
	
}

//服务申请关闭
public function closeService():void {
	var mainValue:Object = crmeap.getValue();
	
	var iid:int = mainValue.iid;
	var istatus:int = mainValue.istatus;
	
	
	var sql:String = "select istatus from sr_request where iid = " + iid;
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
		var list:ArrayCollection = event.result as ArrayCollection;
		if (list && list.length > 0) {
			var istatus:int = list[0].istatus;
			if (istatus == 0) {
				var sql:String = "update sr_request set istatus = 3 where iid = " + iid;
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
					CRMtool.showAlert("操作成功");
				}, sql, null, false);
			}else if(istatus == 1){
				CRMtool.showAlert("服务申请已经派单不可关闭");
				return;
			}else if(istatus == 2){
				CRMtool.showAlert("服务申请已终止不能关闭！");
				return;
			}else {
				CRMtool.showAlert("服务申请已关闭不用再次关闭！");
				return;
			}
		} else {
			CRMtool.showAlert("数据有误，请检查！");
		}
	}, sql);
	
	
}
//服务申请开启
public function openService():void {
	var mainValue:Object = crmeap.getValue();
	
	var iid:int = mainValue.iid;
	var istatus:int = mainValue.istatus;
	
	
	var sql:String = "select istatus from sr_request where iid = " + iid;
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
		var list:ArrayCollection = event.result as ArrayCollection;
		if (list && list.length > 0) {
			var istatus:int = list[0].istatus;
			if (istatus == 3) {
				var sql:String = "update sr_request set istatus = 0 where iid = " + iid;
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
					CRMtool.showAlert("操作成功");
				}, sql, null, false);
			}else if(istatus == 1){
				CRMtool.showAlert("服务申请已经派单不能恢复申请");
				return;
			}else if(istatus == 2){
				CRMtool.showAlert("服务申请已终止不能恢复申请！");
				return;
			}else {
				CRMtool.showAlert("服务申请是新建状态不能恢复申请！");
				return;
			}
		} else {
			CRMtool.showAlert("数据有误，请检查！");
		}
	}, sql);
	
	
}
//顺延活动
private function modifyDiaryDate():void{
	var mainValue:Object = this.crmeap.getValue();
	var more:MoreHandleTW = new MoreHandleTW();
	more.formIfunIid = 420;
	more.width = 800;
	more.height = 400;
	more.title = "顺延活动提醒";
	
	var obj:Object = new Object();
	obj.dmessage = mainValue.dmessage;
	obj.cmessage = mainValue.cmessage;
	
	//YJ Edit 20140924 获取下次活动方式的名称
	var strsql:String = "select cname from aa_data where iid="+mainValue.inexstyle;
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
		
		var arr:ArrayCollection = e.result as ArrayCollection;
		obj.inexstyle = arr.length>0 ? e.result[0].cname+"" : "";
		more.injectObj = obj;
		
		more.addEventListener("onSubmit", function (e:Event):void {
			more.isBreakSubmit = true;//弹出窗口不关闭
			var newObj:Object = more.crmeap.getValue();
			if(CRMtool.isStringNull(newObj.dmessage) || CRMtool.isStringNull(newObj.cmessage)){
				CRMtool.showAlert("活动时间或主题不能为空！");
				return;
			}
			if(newObj.dmessage < obj.dmessage){
				CRMtool.showAlert("顺延时间不能小于过去时间！");
				return;
			}
			more.isBreakSubmit = false;//窗口关闭
			var sql:String = "update oa_workdiary set dmessage = '" + newObj.dmessage + "'," +
			"cmessage = '"+ newObj.cmessage +"',inexstyle="+newObj.inexstyle+" where iid = " + mainValue.iid;
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
				mainValue.dmessage = newObj.dmessage;
				mainValue.cmessage = newObj.cmessage;
				mainValue.inexstyle = newObj.inexstyle;
				mainValue.mainValue = mainValue;
				crmeap.setValue(mainValue, 1, 1);
				CRMtool.showAlert("操作成功。");
				var msgSql:String = "update as_communication set isread = 1 where  ifuncregedit = 46 and isperson = "+ CRMmodel.userId +" and iinvoice = "+ mainValue.iid;//将原先的消息提醒变成已读
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, msgSql, null, false);
			}, sql, null, false);
		})
		
		more.open();
		
	},strsql , null, false);
	
}
//取消活动
private function cancelDiary():void{
	var mainValue:Object = this.crmeap.getValue();
	CRMtool.tipAlert1("确定要取消活动吗?",null,"AFFIRM",function():void{
		var sql:String = "update oa_workdiary set dmessage = null,cmessage = null,inexstyle=null " +
		"where iid = " + mainValue.iid;
		AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
			mainValue.dmessage = "";
			mainValue.cmessage = "";
			mainValue.inexstyle = "";
			mainValue.mainValue = mainValue;
			crmeap.setValue(mainValue, 1, 1);
			CRMtool.showAlert("取消成功！");
			var msgSql:String = "update as_communication set isread = 1 where  ifuncregedit = 46 and isperson = "+ CRMmodel.userId +" and iinvoice = "+ mainValue.iid;//将原先的消息提醒变成已读
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, msgSql, null, false);
			onNext();
		}, sql, null, false);
	});
}

private function  onRestorre():void{
	var mainValue:Object = this.crmeap.getValue();
	var param:Object = new Object();
	
	var sql:String="select istatus from sc_transfer where iid="+mainValue.iid;
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(e:ResultEvent):void{
		var ac:ArrayCollection=e.result as ArrayCollection;
		if(ac[0].istatus==2){
			AccessUtil.remoteCallJava("CommonalityDest", "updateStatus", function(e:ResultEvent):void{
				CRMtool.showAlert("恢复撤销成功！");
				//删除子表子表
				var sSqls:String="select iid from sc_rdrecordsbom where irdrecords in(select iid from sc_rdrecords where irdrecord in(select iid from sc_rdrecord where iinvoice="+mainValue.iid+" and ifuncregedit =477))";
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(e:ResultEvent):void{
					var asc:ArrayCollection=e.result as ArrayCollection;
					if(asc.length==0){
					  return;
					}
					for(var i:int=0;i<asc.length;i++){
						var dSqls1:String="delete  sc_rdrecordsbom where iid="+asc[i].iid;
						AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null,dSqls1);
					}
				},sSqls);
				//删除子表
				var sSql:String="select iid from sc_rdrecords where irdrecord in(select iid from sc_rdrecord where iinvoice="+mainValue.iid+" and ifuncregedit =477)";
				AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(e:ResultEvent):void{
					var ascs:ArrayCollection=e.result as ArrayCollection;
					if(ascs.length==0){
						return;
					}
					for(var j:int=0;j<ascs.length;j++){
						var dSqls2:String="delete  sc_rdrecords where iid="+ascs[j].iid;
						AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null,dSqls2);
					}
					//删除主表
					var dSql:String="delete  sc_rdrecord where  ifuncregedit =477 and  iinvoice="+mainValue.iid;
					AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null,dSql);
				},sSql);
			
			}, {iinvoice: mainValue.iid, ifuncregedit: 477, istatus: 1, iperson: CRMmodel.userId}, null, false);
		}else{
			CRMtool.showAlert("单据已恢复撤销，不能重新恢复撤销！");
		} 
	},sql);
}

private function  onVerifyTransfer():void{
	var mainValue:Object = this.crmeap.getValue();
	var param:Object = new Object();
	
	var sql:String="select istatus from sc_transfer where iid="+mainValue.iid;
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(e:ResultEvent):void{
		var ac:ArrayCollection=e.result as ArrayCollection;
		if(ac[0].istatus==1){
			AccessUtil.remoteCallJava("CommonalityDest", "updateStatus", function(e:ResultEvent):void{
				CRMtool.showAlert("审核确认成功！");
				AccessUtil.remoteCallJava("UtilViewDest", "setRdrecord", null,mainValue);
				AccessUtil.remoteCallJava("UtilViewDest", "setRdrecordOut", null,mainValue);
			}, {iinvoice: mainValue.iid, ifuncregedit: 477, istatus: 2, iperson: CRMmodel.userId}, null, false);
		}else{
			CRMtool.showAlert("单据已审核，不能重新审核！");
			return;
		}
	},sql);
}
//资产续签合同
private function renewalContract():void{
	var mainValue:Object = this.crmeap.getValue();
	var param:Object = new Object();
	param.ifuncregedit = "159";
	param.ctable = "sc_order";
	param.itemType = "onNew";
	param.operId = "onListNew";
	param.formTriggerType = "fromOther";
	
	var obj:Object = new Object();
	obj.icustomer = mainValue.icustomer;//经销商
	//obj.dsbegin = mainValue.dsend;//起始日期
	//SZC 2014-12-19 服务费合同起始日期比客商资产中服务到期日多一天
	var sql:String="select dateadd(dd,1,'"+mainValue.dsend+" ') dsbengin";
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(e:ResultEvent):void{
		obj.dsbegin =DateUtil.formateDate((e.result as ArrayCollection)[0].dsbengin,"YYYY-MM-DD");//起始日期
		var dsendSql:String = "select dateadd(day,-1,dateadd(year,1,'"+obj.dsbegin+" ')) dsend";
		AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(event:ResultEvent):void{
			obj.dsend = (event.result as ArrayCollection)[0].dsend;//结束日期
			obj.mainValue = obj;
			param.injectObj = obj;
			param.personArr = new ArrayCollection();
			
			CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "加载中 ...", "");
		}, dsendSql, null, false);
	},sql);
	//end
	/*var dsendSql:String = "select dateadd(day,-1,dateadd(year,1,'"+mainValue.dsend+" ')) dsend";
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(event:ResultEvent):void{
		obj.dsend = (event.result as ArrayCollection)[0].dsend;//结束日期
		obj.mainValue = obj;
		param.injectObj = obj;
		param.personArr = new ArrayCollection();
		
		CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "加载中 ...", "");
	}, dsendSql, null, false);*/
}
//服务工单生成线索
private function billToClue():void{
	if (!this.crmeap)
		return;
	var mainValue:Object = this.crmeap.getValue();
	
	var injectObj:Object = new Object();
	injectObj.ifuncregedit = 150;//相关单据类型
	injectObj.iinvoice = mainValue.iid;//服务工单对应的相关单据内码
	injectObj.cdetail = mainValue.cdescription;//线索内容
	injectObj.iisource = 1341;//线索来源（服务工单）
	injectObj.icustomer = mainValue.icustomer;//相关客商
	injectObj.icustperson = mainValue.icustperson;//联系人IID
	
	for each(var ct:CrmEapTextInput in this.crmeap.textInputList) {
		if (ct.crmName == "UI_SR_BILL_ICUSTOMER"){
			injectObj.ccustomer = ct.text;//客户名称
		}
		if(ct.crmName == "UI_SR_BILL_ICUSTPERSON"){
			injectObj.ccustperson = ct.text;//联系人
		}
	}
	injectObj.ccustpersonmobile = mainValue.ctel;//联系手机
	
	var param:Object = new Object();
	var iid:ArrayCollection = new ArrayCollection();
	param.personArr = iid;
	param.ifuncregedit = "62";
	param.ctable = "sa_clue";
	param.itemType = "onNew";
	param.operId = "onListNew";
	param.formTriggerType = "fromOther";
	param.injectObj = injectObj;
	
	CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param,"加载中 ...", "");
}

//实施客户交接到服务时由服务部经理接管后指定服务人员自动回写至客户档案
private function refreshCustomerPerson():void{
    var mainValue:Object = this.crmeap.getValue();
    var sql:String="update cs_customer set iserviceperson="+mainValue.iengineer+" where iid="+mainValue.icustomer;
    AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(event:ResultEvent):void{
        CRMtool.showAlert("客商档案服务人员变更成功！");
    },sql);

}

//隐式推单  计划推任务
private function setPersonTask():void{
    var mainValue:Object = this.crmeap.getValue();
	var sql:String="select  *  from sr_projectjob where iid="+mainValue.iid;
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(event:ResultEvent):void{
		var ac:ArrayCollection=event.result as ArrayCollection;
		if(ac[0].istatus==7){
			CRMtool.showAlert("任务已经分配成功，不能重新分配！");
			return;
		}else{
			AccessUtil.remoteCallJava("UtilViewDest", "setPersonTask", function(event:ResultEvent):void{
                var task:ArrayCollection=new ArrayCollection();
                task=mainValue.sr_projectjobs;
                for each (var item:Object in task){
                    var sqljob:String="select iid from sr_projectTask where iinvoice ="+item.iid
                    AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(event:ResultEvent):void {
                        var ac:ArrayCollection = event.result as ArrayCollection;
                        AccessUtil.remoteCallJava("CommonalityDest", "updateStatus", null, {iinvoice: ac[0].iid, ifuncregedit: 452, istatus: 1, iperson: CRMmodel.userId}, null, false);
                    },sqljob);
                }

				CRMtool.showAlert("任务分配成功！");
			},mainValue);
            //更新需求分析状态
			AccessUtil.remoteCallJava("CommonalityDest", "updateStatus", null, {iinvoice: ac[0].iid, ifuncregedit: 446, istatus: 7, iperson: CRMmodel.userId}, null, false);
			var sql1:String="update sr_projectjobs set istate=11 where iprojectjob= "+mainValue.iid+";";
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null,sql1);
		}
	},sql);


}

//需求暂缓
private function pullOffNeed():void{
    var mainValue:Object = this.crmeap.getValue();
    var sql1:String="select istatus from sr_projectneed where iid= "+mainValue.iid+";";
    AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(event:ResultEvent):void{
        var list:ArrayCollection = event.result as ArrayCollection;
        if (list && list.length > 0) {
            var istatus:int = list[0].istatus;
            if (istatus == 3){
                CRMtool.showAlert("该需求已生成下游单据，不允许执行该操作！");
                return;
            }
            else{
                var sql:String="update sr_projectneed set istatus=4 where iid= "+mainValue.iid+";";
                AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(event:ResultEvent):void{
                    CRMtool.showAlert("需求暂缓成功！");
					var obj:Object=new Object();
					mainValue.istatus=4;
					obj.mainValue=mainValue;
					crmeap.setValue(obj,1,1);
                },sql);
            }
        }
    },sql1);


}

//需求作废
private function cancelNeed():void{
    var mainValue:Object = this.crmeap.getValue();
    var sql1:String="select istatus from sr_projectneed where iid= "+mainValue.iid+";";
    AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(event:ResultEvent):void{
        var list:ArrayCollection = event.result as ArrayCollection;
        if (list && list.length > 0) {
            var istatus:int = list[0].istatus;
            if (istatus == 3){
                CRMtool.showAlert("该需求已生成计划，不允许执行该操作！");
                return;
            }
            else{
                var sql:String="update sr_projectneed set istatus=5 where iid= "+mainValue.iid+";";
                AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(event:ResultEvent):void{
                    CRMtool.showAlert("需求作废成功！");
					//CRMtool.showAlert("需求暂缓成功！");
					var obj:Object=new Object();
					mainValue.istatus=5;
					obj.mainValue=mainValue;
					crmeap.setValue(obj,1,1);
                },sql);
            }
        }


    },sql1);

}

//需求恢复
private function cancelPullOff():void{
    var mainValue:Object = this.crmeap.getValue();
    var sql1:String="select istatus from sr_projectneed where iid= "+mainValue.iid+";";
    AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(event:ResultEvent):void{
        var list:ArrayCollection = event.result as ArrayCollection;
        if (list && list.length > 0) {
            var istatus:int = list[0].istatus;
            if (istatus == 4 || istatus == 5 ){
                var sql:String="update sr_projectneed set istatus=1 where iid= "+mainValue.iid+";";
                AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(event:ResultEvent):void{
                    CRMtool.showAlert("需求已恢复为单据提交状态！");
					var obj:Object=new Object();
					mainValue.istatus=1;
					obj.mainValue=mainValue;
					crmeap.setValue(obj,1,1);
                },sql);
            }
            else{
                CRMtool.showAlert("当前需求状态，不允许执行该操作！");
                return;
                }
        }
    },sql1);
}

//任务领取
private function pullTaskGet():void{
	var mainValue:Object = this.crmeap.getValue();
	if(mainValue.istatus==1||mainValue.istatus==10){
        AccessUtil.remoteCallJava("CommonalityDest", "updateStatus", null, {iinvoice: mainValue.iid, ifuncregedit: 452, istatus: 8, iperson: CRMmodel.userId}, null, false);
		//var sql1:String="update sr_projecttask set istatus=8 where iid= "+mainValue.iid+";";
		//AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql",null,sql1);
        var cdate:String=CRMtool.formatDateWithHNS()+"";
        mainValue.drelbegin=cdate;
        mainValue.mainValue = mainValue;
        crmeap.setValue(mainValue, 1, 1);
		CRMtool.showAlert("任务领取成功！");
		//修改实际开始时间

		var sql:String ="update sr_projecttask set drelbegin="+"'"+cdate+"'"+" where iid= "+mainValue.iid+";";
		AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql",null,sql);
		//修改需求分析的实际开始时间
		var sql1:String ="update sr_projectjobs set istate=8, drelbegin="+"'"+cdate+"'"+"  where iid=(select iinvoice from sr_projectTask where iid="+mainValue.iid+")";
		AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql",null,sql1);
	}else{
		CRMtool.showAlert("当前状态不允许领取！");
		return;
	}
	
}

/**
 * 开发管理推模块
 * */
public function openProjectmodule():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	var paramObj:Object = new Object();
	paramObj.iproject = myMainValue.iid;
	var param:Object = new Object();
	param.ifuncregedit = "442";
	param.ctable = "sr_projectmodule";
	param.itemType = "onNew";
	param.operId = "onListNew";
	param.formTriggerType = "fromOther";
	param.injectObj = paramObj;
	var iid:ArrayCollection = new ArrayCollection();
	param.personArr = iid;
	CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "加载中 ...", "");
}
/**
 * 开发管理推需求
 * */
public function openProjectneed():void {
	var myMainValue:Object = this.crmeap.getValue() as Object;
	var paramObj:Object = new Object();
	paramObj.iproject = myMainValue.iid;
	var param:Object = new Object();
	param.ifuncregedit = "445";
	param.ctable = "sr_projectneed";
	param.itemType = "onNew";
	param.operId = "onListNew";
	param.formTriggerType = "fromOther";
	param.injectObj = paramObj;
	var iid:ArrayCollection = new ArrayCollection();
	param.personArr = iid;
	CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "加载中 ...", "");
	
}

public function sendnaire():void {
    if(this.formIstatus != 1) {
        CRMtool.showAlert("该单据不能再次发送！");
        return;
    }
    var formValue:Object = crmeap.getValue();
    var notice:SendQuestion = new SendQuestion();
    notice.width = 800;
    notice.height = 500;
    notice.title = "发布范围";
    notice.framecore = FrameCore(crmeap.paramForm);
    notice.currid = formValue.iid;
    CRMtool.openView(notice,true,null,false);

    notice.addEventListener("onSubmit",function(event:Event):void {
        var np:NoticePush = notice.noticePushView;
        var obj:Object = new Object;
        obj.itype = np.itype;
        np.iifuncregedit = 468;
        obj.iid = formValue.iid;
        var list:ArrayCollection = np.selectedAc;
        for each(var item:Object in list) {

            item.inotice = formValue.iid;
        }
        obj.selectedAc = list;

        AccessUtil.remoteCallJava("OADest", "addQuestionNodes", function (event:ResultEvent):void {
            if (event.result as Boolean) {
                CRMtool.showAlert("问卷已成功发送。");
                AccessUtil.remoteCallJava("CommonalityDest", "updateStatus", function () {
                    var sql = "update oa_inquiry set dbegin=getdate() where iid = " + formValue.iid;
                    //更新问题表行号
                    sql += ";update oa_inquirys set ino = a.q_RowNum from (  "+
                        "select iid,row_number()over(order by iid )as q_RowNum from oa_inquirys where iinquiry = "+ formValue.iid +")a "+
                        "where  oa_inquirys.iid = a.iid ";
                    //更新答案表行号
                    sql += "update oa_inquiryss set ino = a.a_RowNum from ( "+
                        "select oss.iid,row_number()over(order by oss.iid )as a_RowNum  from oa_inquiryss oss "+
                        "left join oa_inquirys os on oss.iinquirys = os.iid "+
                        "where os.iinquiry = "+ formValue.iid +")a "+
                        "where  oa_inquiryss.iid = a.iid ";
                    AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
                        var value:Object = crmeap.getValue();
                        value.istatus = 27;
                        value.mainValue = value;
                        formIstatus = 27;
                        crmeap.setValue(value, 1, 1);
                        np.getAlreadyPush();
                    }, sql);
                }, {iinvoice: formValue.iid, ifuncregedit: 461, istatus: 12, iperson: CRMmodel.userId}, null, false);
            } else {
                CRMtool.showAlert("问卷发送失败。");
            }
        }, obj);
    });
}

public function getResult():void {
    var formValue:Object = crmeap.getValue();
    var param:Object = new Object();
    param.ccontent = "返回调查";
    param.iid = formValue.iid;
    param.ifuncregedit = "761";
    param.injectObj = param;

    CRMtool.openMenuItemFormOther("yssoft.views.QuestionNaire", param, "调查问卷");
}

//修改用车申请单
public function OnUpdateCaruse():void{
	var myMainValue:Object = this.crmeap.getValue() as Object;
	var sql1:String="select istatus from oa_caruse where iid= "+myMainValue.iid+";";
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(event:ResultEvent):void{
		var list:ArrayCollection = event.result as ArrayCollection;
		if (list && list.length > 0) {
			var istatus:int = list[0].istatus;
			if (istatus == 1){
				CRMtool.showAlert("单据未审核，不允许执行该操作！");
				return;
			}
			else{
				if (myMainValue && myMainValue.hasOwnProperty("iid")) {
					var iid:int = myMainValue.iid;
					var updateCaruseWindow:UpdateCaruseWindow = new UpdateCaruseWindow();
					updateCaruseWindow.myinit(iid, crmeap);
				}
			}
		}
	},sql1);
	
}


public function getRecord():void {
    var mainValue:Object = crmeap.getValue();
    if(mainValue.ifuncregedit != 153 && mainValue.ifuncregedit != 453) {
        CRMtool.showAlert("非热线沟通来源的服务订单！");
        return;
    }
    var sql:String = "select iid,crouteline,convert(varchar(20),dbegin,120)dbegin,case ISNULL(ccallintel,'') when '' then ccallouttel else ccallintel end callphone "+
    "from cc_callcenter where iid = "+ mainValue.iinvoice;
    AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(event:ResultEvent):void{
        var list:ArrayCollection = event.result as ArrayCollection;
        var item:Object = list[0];

        var cc:Mp3PlayerPro = new Mp3PlayerPro();
        var dbegin:String = StringUtil.trim(item.dbegin);
        var callphone:String = StringUtil.trim(item.callphone);
        var curr_date:String = StringUtil.trim(dbegin.substr(0, 10));
        var sfm:String = StringUtil.trim(dbegin.substr(11).replace(":", "").replace(":", ""));
        var crouteline:String = item.crouteline;
        crouteline = crouteline.replace("线路", "line");
        var filePath:String = "PhoneRecord/" + curr_date + "/" + crouteline + "/" + callphone + "_" + sfm + ".mp3";
        //var filePath:String = "2.mp3";

        var url:URLRequest = new URLRequest(filePath);
        var loader:URLLoader = new URLLoader();

        loader.addEventListener(Event.COMPLETE, function (e:Event):void {
            cc.snd = new Sound(url);
            cc.panTitle = (item.ccsname != null ? item.ccsname : '') + " " + dbegin + " 通话记录";
            CRMtool.openView(cc);
        });
        loader.addEventListener(IOErrorEvent.IO_ERROR, function (e:IOErrorEvent):void {
            CRMtool.showAlert("文件不存在或者已经转移,请重试。");
        });
        loader.load(url);
    },sql);

}

//问卷撤销处理
private function takeback():void {
    var obj:Object = crmeap.getValue();
    if (this.formIstatus != 13) {
        CRMtool.showAlert("非订单关闭状态不允许撤销！")
        return;
    }
    updateStatus("-1");
}
//活动人员新建客商
private function newcustomer():void {
	var param:Object = new Object();
	param.ifuncregedit = "44";
	param.ctable = "cs_customer";
	param.itemType = "onNew";
	param.operId = "onListNew";
	param.formTriggerType = "fromOther";
	var iid:ArrayCollection = new ArrayCollection();
	param.personArr = iid;
	
	var custpersonArr:ArrayCollection = new ArrayCollection();
	
	CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "客商档案", "");
}

/**
 * 活动人员新建客商人员
 * LC  ADD   20160302
 */

private function newcustperson():void {
    var param:Object = new Object();
    param.ifuncregedit = "45";
    param.ctable = "cs_custperson";
    param.itemType = "onNew";
    param.operId = "onListNew";
    param.formTriggerType = "fromOther";
    var iid:ArrayCollection = new ArrayCollection();
    param.personArr = iid;

    //var custpersonArr:ArrayCollection = new ArrayCollection();

    CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "客商人员", "");
}

private function toOrder162():void {
    var myMainValue:Object = this.crmeap.getValue() as Object;
    var param:Object = {};//总体需要传入参数
    var injectObj:Object = {};

    injectObj.ifuncregedit = "497";
    injectObj.iinvoice = myMainValue.iid;
    injectObj.ddate = myMainValue.dordertime;
    injectObj.ctitle = myMainValue.cname;
    injectObj.icustomer = myMainValue.icustomer;
    injectObj.ccustaddress = myMainValue.ccustaddress;
    injectObj.cmobile1 = myMainValue.ccusttel;

    param.ifuncregedit = 162;
    param.ctable = "sc_order";
    param.itemType = "onNew";
    param.operId = "onListNew";
    param.formTriggerType = "fromOther";
    param.injectObj = injectObj;
    var iid:ArrayCollection = new ArrayCollection();
    param.personArr = iid;

    CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "加载中…", "");
}

private function toOrder161():void {
    var myMainValue:Object = this.crmeap.getValue() as Object;
    var param:Object = {};//总体需要传入参数
    var injectObj:Object = {};

    injectObj.ifuncregedit = "497";
    injectObj.iinvoice = myMainValue.iid;
    injectObj.ddate = myMainValue.dordertime;
    injectObj.ctitle = myMainValue.cname;
    injectObj.icustomer = myMainValue.icustomer;
    injectObj.ccustaddress = myMainValue.ccustaddress;
    injectObj.cmobile1 = myMainValue.ccusttel;

    param.ifuncregedit = 161;
    param.ctable = "sc_order";
    param.itemType = "onNew";
    param.operId = "onListNew";
    param.formTriggerType = "fromOther";
    param.injectObj = injectObj;
    var iid:ArrayCollection = new ArrayCollection();
    param.personArr = iid;

    CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "加载中…", "");
}

