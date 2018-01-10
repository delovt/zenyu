import flash.events.Event;
import flash.events.IEventDispatcher;
import flash.events.MouseEvent;
import flash.net.FileReference;
import flash.net.URLRequest;
import flash.utils.ByteArray;

import hlib.CloneUtil;

import mx.collections.ArrayCollection;
import mx.collections.ArrayList;
import mx.controls.Alert;
import mx.controls.RadioButtonGroup;
import mx.events.CloseEvent;
import mx.events.ItemClickEvent;
import mx.rpc.events.ResultEvent;
import mx.utils.ObjectUtil;

import spark.components.RadioButton;

import yssoft.comps.frame.module.CrmEapRadianVbox;
import yssoft.frameui.event.FormEvent;
import yssoft.frameui.formopt.FormOpt;
import yssoft.frameui.formopt.OperDataAuth;
import yssoft.models.CRMmodel;
import yssoft.models.ConstsModel;
import yssoft.scripts.StatusRelated;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;

/**
 * FrameCoreUI.as
 * 单据操作核心界面 处理脚本
 */

/***********************************变量定义区域***********************************/
// 工作流 相关信息 (请求工作流的信息，包括错误代码等)
private var workFlowDetail:Object;
// 工作流的描述信息
private var workFlowDesc:Object;
// 单据绑定的工作流模板描述信息
private var workFlowTempDesc:Object;

//工作流状态提示信息
[Bindable]
public var workFlowStatusDes:String = "无流程";//="没有绑定工作流";
[Bindable]
public var workFlowStatusImg:Class = ConstsModel.wlcpng;
//打印模板
[Bindable]
private var printTemplate:ArrayCollection = new ArrayCollection();

private var XGGNenable:Boolean = true;
// buttonbar 数据源

//刘睿  提交时注入sql
public var cexecsql:String;
//刘睿  撤销时注入sql
public var cexecsqlBack:String;

private var oldFormIfunIid:int = 0;
private var oldCurrid:int = 0;
private var oldwfiid:int = 0;
private var bb_opt_items:ArrayCollection = new ArrayCollection([
    {label:"增加", name:"onNew"        },
    {label:"修改", name:"onEdit"    },
    {label:"删除", name:"onDelete"    },
    {label:"保存", name:"onSave"    },
    {label:"放弃", name:"onGiveUp"    }
]);
private var bb_wf_items:ArrayCollection = new ArrayCollection([
    {label:"提交", name:"onSubmit"        },
    {label:"撤销", name:"onRevocation"    },
    {label:"打印", name:"onPrint"        }
]);

[Bindable]
[Embed(source="/yssoft/assets/images/top1.png")]
private var topIcon:Class;

[Bindable]
[Embed(source="/yssoft/assets/images/pre1.png")]
private var preIcon:Class;

[Bindable]
[Embed(source="/yssoft/assets/images/next1.png")]
private var nextIcon:Class;

[Bindable]
[Embed(source="/yssoft/assets/images/tail1.png")]
private var tailIcon:Class;



[Bindable]
private var bb_nav_items:ArrayCollection = new ArrayCollection([
    {icon:topIcon, name:"onTop"        },
    {icon:preIcon, name:"onPrior"    },
    {icon:nextIcon, name:"onNext"        },
    {icon:tailIcon, name:"onTail"        }
]);

// 按钮的当前状态,默认为 onNew 增加
[Bindable]
public var _curButtonStatus:String = "onNew";
// 按钮的上一状态，默认为 onNew 增加
public var preButtonStatus:String = "onNew";
//调用表单内部绘制界面及方法对象
public var crmeap:CrmEapRadianVbox;

/**
 *  单据状态, 新增 new ，编辑 edit ，浏览 browser, 默认为新增 new
 *     从菜单触发 状态为new，从其他触发与单据列表触发 可以设为new,edit,browser其中之一
 */
[Bindable]
public var formStatus:String = "new";
/**
 * 单据触发方式,从菜单触发 fromMenu,从单据列表触发 fromList,从其他界面触发 fromOther
 */
[Bindable]
public var formTriggerType:String = "fromMenu";
/**
 *  触发窗体的引用，主要是为了，处理当前单据的某些操作，回写 触发单据的信息
 *  默认为null，当触发方式为 fromList或fromOther 引用触发窗体
 */
[Bindable]
public var triggerForm:Object = null;

/**
 *  存放公共单据内码向外抛出事件的控件
 *
 */
[Bindable]
public var triggerCrmEapControl:Object = null;

// 单据功能注册码

[Bindable]
public var formIfunIid:int = 0;

//单据内码
[Bindable]
private var _currid:int = 0;

[Bindable]
public function get currid():int {
    return _currid;
}

public function set currid(value:int):void {
    initStatus();
    if (formIfunIid > 0 && value > 0 && _currid != value && CRMtool.getFuncregedit(formIfunIid).istatusset > 0) {
        //加载到一个单据
        getStatus(value, formIfunIid, winParam.ctable);
    }
    _currid = value;
    if(value>0){
        sideBox.enabled = true;
    }else{
        sideBox.enabled = false;
    }
}

//工作流内容`
public var wfiid:int = 0;
public var statusRelated:StatusRelated = new StatusRelated(); //状态注入类
//发起工作流后是否允许修改
public var resultbmodify:Boolean;

// 外界传递过来的 iid 集合
[Bindable]
public var formIidList:ArrayCollection = new ArrayCollection();

// 当前浏览单据的索引号，1 代表第一条
[Bindable]
public var curFormIndex:int = 1;
//个数
[Bindable]
public var formIidListCount:int = 1;

//菜单(列表)传参
[Bindable]
public var winParam:Object = new Object();

public var _vouchFormArr:ArrayList;


public var _vouchFormValue:ArrayCollection = new ArrayCollection();

//查询表头集合
private var mainSqlObj:Object;

//查询表体集合
private var childSql:ArrayCollection;
//权限类对象
public var auth:OperDataAuth;

//返回当前单据是否具有修改或删除数据权限提示集合
public function loadeditordelwarning():void {
    loadedflowwarning();
    auth.loadeditwarning(formIfunIid, CRMmodel.userId, CRMmodel.hrperson.idepartment, currid);
    auth.loaddelwarning(formIfunIid, CRMmodel.userId, CRMmodel.hrperson.idepartment, currid);
}

//重新加载工作流修改或删除权限
public function loadedflowwarning():void {
    auth.loadfloweditwarning(formIfunIid, currid);
    auth.loadflowdelwarning(formIfunIid, currid);
}

//设置按钮互斥
public function setAllButtonsEnabled(selectedName:String, length:int = 1):void {
    CRMtool.toolButtonsEnabled(this.bb_opt, selectedName, length);
    bb_wfEnabled = (this.bb_opt.getChildAt(2) as mx.controls.Button).enabled;
    //(bb_wf.getChildAt(2) as mx.controls.Button).enabled = (this.bb_opt.getChildAt(0) as mx.controls.Button).enabled;
    if((this.bb_opt.getChildAt(0) as mx.controls.Button).enabled&&currid>0)
        btn_print.toolTip=null;
    else
        btn_print.toolTip="单据未保存，将打印无数据模板。";

    if(!newButtonEnable)
        (this.bb_opt.getChildAt(0) as mx.controls.Button).enabled = newButtonEnable;

    if (!editButtonEnable)
        (this.bb_opt.getChildAt(1) as  mx.controls.Button).enabled = editButtonEnable;

    if (!delButtonEnable)
        (this.bb_opt.getChildAt(2) as  mx.controls.Button).enabled = delButtonEnable;
}

private var newButtonEnable:Boolean = true;
private var editButtonEnable:Boolean = true;
private var delButtonEnable:Boolean = true;
private var isGetNewButtonEnable:Boolean = false;

//lr 检查功能按钮  判断按钮是否启用  实现灰化
private function initButtonByAuth():void{
    if(isGetNewButtonEnable)
        return;

    if( formIfunIid>0){
        CRMtool.getAuthcontent(formIfunIid, function (_obj:Object):void {
            var ac:ArrayCollection = _obj.list as ArrayCollection;
            isGetNewButtonEnable = true;
            for each(var item:Object in ac) {
                if (item.ccode.indexOf(".02") + 3 == item.ccode.length) {
                    newButtonEnable = (CRMtool.getBoolean(item.buse));
                    (bb_opt.getChildAt(0) as mx.controls.Button).enabled = newButtonEnable;
                }
                if (item.ccode.indexOf(".03") + 3 == item.ccode.length) {
                    editButtonEnable = CRMtool.getBoolean(item.buse);
                    (bb_opt.getChildAt(1) as mx.controls.Button).enabled = editButtonEnable;
                }
                if (item.ccode.indexOf(".04") + 3 == item.ccode.length) {
                    delButtonEnable = (CRMtool.getBoolean(item.buse));
                    (bb_opt.getChildAt(2) as mx.controls.Button).enabled = delButtonEnable;
                }
            }
        });
    }
}

/***********************************具体功能实现区域*********************************/

/*******************实现接口的方法start**************************/

private var getRelatedObjectsViewFlag:Boolean = false;//加载过相关了。
//窗体初始化
public function onInit():void {
    me = this;
    bar.enabled = false;
    //crmeap setValue完毕触发 lr add 
    this.addEventListener("setValueComplete", setValueCompleteListener);

    this.addEventListener("SideComplete", sideCompleteListener);
    this.addEventListener("cardValueChange",function(e:Event):void{
        crmeap.queryPm(crmeap.currid+"");
        //crmeap.addEventListener("queryComplete", queryComplete);
    });
    this.addEventListener("yesStatus", function (e:Event):void {
        statusRelated.doStatusAfter(crmeap, winParam, formIstatus, formIfunIid);
    });


    FormOpt.initOpt(this);
    //判断相关功能 是否存在，更改raidobutton
    /*	this.leftPart.getRelatedObjectsView().addEventListener("noRelatedList",function():void{
     openRelated.enabled = false;
     });
     this.leftPart.getRelatedObjectsView().addEventListener("hasRelatedList",function():void{
     openRelated.enabled = true;
     if(openRelated.selected){
     myState = "openRelated";
     }
     getRelatedObjectsViewFlag = true;

     });*/
}

private var initFlag:Boolean = false;//单据加载完毕

public function sideCompleteListener(event:Event):void {
    if (operId == "onListEdit" && crmeap) {
        var value:Object = crmeap.getValue();
        if (value && value.iid > 0) {
            lastOptType = "onEdit"
            curButtonStatus = "onEdit";
            crmeap.curButtonStatus = "onEdit";
            onEdit();
            operId = "";
        }
    }
}

//单据加载之后,不管有无数据，一定会出发此事件，更新标题，相关功能数量。
public function setValueCompleteListener(event:Event):void {
    initTitle();
    initFlag = true;
    //openWin();
    if (this.currid == 0 && this.crmeap.currid == 0) {
        this.leftPart.getRelatedObjectsView().enabled = false;

    } else {
        //this.leftPart.getRelatedObjectsView().enabled = true;
        //this.leftPart.getRelatedObjectsView().refAddLable();
        if (this.myState == "formShow" || this.myState == "draw")
            this.leftPart.getRelatedObjectsView().onClick("init");
        else {
            this.leftPart.getRelatedObjectsView().onClick();
        }
    }

    this.resultbmodify = CRMtool.getFuncregedit(formIfunIid).bworkflowmodify;
    bar.enabled = true;

    //特殊列表打开单据 递归调用   lr add
    if (winParam && winParam.coreList) {
        var itemObj:Object = new Object();
        var coreList:ArrayCollection = winParam.coreList;


        if (coreList.length > 0) {
            var core:Object = coreList.getItemAt(0);

            itemObj.outifuncregedit = core.outifuncregedit;
            //itemObj.ifuncregedit =  core.outifuncregedit;

            itemObj.ctable = winParam.ctable;
            itemObj.itemType = winParam.itemType;
            itemObj.operId = winParam.operId;
            itemObj.formTriggerType = winParam.formTriggerType;

            itemObj.deleterefresh = winParam.deleterefresh;
            itemObj.operauthArr = winParam.operauthArr;
            itemObj.dataauthArr = winParam.dataauthArr;
            itemObj.formTriggerType = "fromList";

            itemObj.personArr = core.personArr;
            var type:String = core.type;
            var flagStr:String = core.flagStr;
            coreList.removeItemAt(0);
            itemObj.coreList = coreList;
            CRMtool.openMenuItemFormOther('yssoft.frameui.FrameCore', itemObj, "加载中...", type + core.outifuncregedit + flagStr);
        }
    }
}

//lr add 初始化 标题
public function initTitle():void {
    if (formIfunIid > 0) {
        var title:String = crmeap.vouch.cname;
        var crmLinkBarLable:String = crmeap.vouch.cname;

        var ccaptionfield:String = CRMtool.getFuncregedit(formIfunIid).ccaptionfield + "";

        if (CRMtool.isStringNotNull(ccaptionfield)) {
            var array:Array = ccaptionfield.split("|");
            var i:int = 0;
            for each(var s:String in array) {
                var addTitle:String = crmeap.getValue()[s];
                if (CRMtool.isStringNotNull(addTitle)) {
                    if (i > 0)
                        title = title + " - " + addTitle;
                    else {
                        title = title + " > " + addTitle;
                        crmLinkBarLable = addTitle;
                    }

                    i++;
                }
            }
        }

        CRMtool.setCrmLinkBarLable(this, crmLinkBarLable);
        this.lbl_title.label = title;
    }
}


//窗体初始化
public function onWindowInit():void {

}
//窗体打开，再次打开
public function onWindowOpen():void {
    if (crmeap)
        crmeap.isFirst = false;
    FormOpt.openOpt(this);
    this.curFormIndex = 1;
}


private var operId:String;
public function openWin():void {
    if (winParam == null) { // 添加
        return;
    }
    if (winParam.hasOwnProperty("formTriggerType")) {
        formTriggerType = winParam.formTriggerType;
        formIidList = winParam.personArr;
        formIidListCount = formIidList.length;
        operId = winParam.operId;
        switch (winParam.operId) {
            case "onListNew":
            {
                formStatus = "new";
                curButtonStatus = "onNew";
                break;
            }
            case "onListEdit":
            {
                formStatus = "browser";
                curButtonStatus = "onGiveUp";

                //formStatus="edit";
                //curButtonStatus="onEdit";
                break;
            }
            case "onListDouble":
            {
                formStatus = "browser";
                curButtonStatus = "onGiveUp";
                break;
            }
        }
    }
    if (winParam.hasOwnProperty("formTriggerType")) {
        formTriggerType = winParam.formTriggerType;
    }

    if (formTriggerType == "fromList") {
        formIfunIid = int(winParam.outifuncregedit);
    }
    else if (formTriggerType == "fromMenu") {
        winParam = CRMtool.getObject(winParam);
        formIfunIid = int(winParam.ifuncregedit);
    } else {
        formIfunIid = int(winParam.ifuncregedit);
    }

    initButtonByAuth();
}

public function set curButtonStatus(value:String):void {
    this._curButtonStatus = value;
    if (initFlag) {
        switch (value) {
            case "onGiveUp":
                if (this.currid != 0 || this.crmeap.currid != 0) {
                    this.leftPart.getRelatedObjectsView().enabled = true;
                    this.rbg.enabled = true;
                }
                break;
            case "onSubmit":
                break;
            case "onRevocation":
                break;
            case "onPrint":
                break;
            default:
                this.leftPart.getRelatedObjectsView().enabled = false;
                this.rbg.enabled = false;
        }
    }
}

public function get curButtonStatus():String {
    return this._curButtonStatus;
}


//窗体关闭,完成窗体的清理工作
public function onWindowClose():void {

}
/*******************实现接口的方法end**************************/

/*******************buttonbar itemclick 事件处理start**********/
public var lastOptType:String = "";
public var llastOptType:String = "";
private var doublecount:int=0;
private function bb_itemclick(event:ItemClickEvent):void {
    var type:String = event.item.name as String;
    //wtf add


    if (formStatus == "new") {
        lastOptType = "onNew";
    } else if (formStatus == "edit") {
        lastOptType = "onEdit";
    }
    formStatus = "other";
    //wtf over
    if (event.target != bb_nav) {
        lbl_title_clickHandler();
    }

    if (event.item.name == "onNavData") { // 不做处理
        return;
    }
    // 区分导航按钮组,不记录 该组按钮的状态

    // 判断当前按钮状态
    llastOptType = lastOptType;

    if(event.target == bb_opt){
        if (type != "onSave" && type != "onSubmit")
        {
            this.curButtonStatus = type; // 记录当前按钮状态
            crmeap.curButtonStatus = type; //YJ Modify 2012-04-25
        }
        lastOptType = type;
    }


    //执行按钮对应的 相关功能函数
    this[event.item.name]();
    //var f:FormOpt;
}

var oldCurFormIndex:int ;
// 增加
public function onNew():void {
    oldCurFormIndex = curFormIndex;
    this.formIidListCount++;
    this.curFormIndex=formIidListCount;
    crmeap.onNew();
    this.oldCurrid = currid;
    this.oldFormIfunIid = formIfunIid;
    this.oldwfiid = wfiid;
    this.wfiid = 0;
    this.currid = 0;
    //LC add 20160304
    if (workFlowStatusDes == "无流程")
    {
        this.setWfStatusDes("无流程");
    }else{
        this.setWfStatusDes("待提交");
    }

	//wtf add
    this.coreSide.refreshData(this.formIfunIid, this.currid, this.wfiid, true, false);

//	this.getWordFlowDetail(this.formIfunIid,this.currid,0);
}


// 修改
public var obj:Object = {};
public function onEdit():void {
    crmeap.onEdit();
}

// 删除
public function onDelete():void {
    crmeap.curButtonStatus = this.curButtonStatus;
    crmeap.currid = this.currid;

    if(wfiid > 0){
        if (CRMmodel.hrperson.cname != "admin") {
            CRMtool.showAlert("此单据已经绑定工作流，不能删除!");
            return;
        }else{
            CRMtool.tipAlert1("您是admin用户，此操作将先清空工作流信息，确定吗？", null, "AFFIRM", function ():void {
                AccessUtil.remoteCallJava("DeleteWorkFlow", "co_deleteWorkFlow", null, {ioainvoice:wfiid}, "正在撤销协同...");
                crmeap.onDelete();
                crmeap.addEventListener("success", success);
            });
        }
    }else{
        crmeap.onDelete();
        crmeap.addEventListener("success", success);
    }
}

private function onSaveCallBack():void {
    for (var i:int = 0; i < this._vouchFormValue.length; i++) {
        if (this._vouchFormValue.getItemAt(i).mainValue.iid == this.currid) {
            this._vouchFormValue.removeItemAt(i);
            break;
        }
    }

    for (var j:int = 0; j < this.formIidList.length; j++) {
        if (this.formIidList.getItemAt(j).iid == this.currid) {
            this.formIidList.removeItemAt(j);
            break;
        }
    }

    if (this.curFormIndex > 0 && formIidListCount > 0) {
        this.onPrior();
        setAllButtonsEnabled(this.curButtonStatus, formIidListCount);
    }
    else {
        /*this.onNext();*/
        setAllButtonsEnabled(this.curButtonStatus, formIidListCount);
//		crmeap.setValue();
        //wtf modify
        this.currid = 0;
        crmeap.setValue(null, 1);
        setOtherButtons(false);
    }
}

// 保存
private function onSave():void {

    //CRMtool.hideFocus();
    var arr:Array = bb_opt.getChildren();
    crmeap.refAllGrid();
    crmeap.onSave(0, arr);
    crmeap.addEventListener("success", success);

}

//设定侧边栏都可用
private function fail():void {
    var arr:Array = bb_opt.getChildren();
    arr[3].enabled = true;
}
private function success(event:Event):void {
    if (this.curButtonStatus == "onNew") {

        //formIidListCount=formIidListCount+1;
        if (curFormIndex == -1 || (curFormIndex == 1 && formIidListCount == 1) || _vouchFormValue.length == 0) {
            this.curFormIndex = 1;
        }

        //lr modify
        /*        else {
         this.curFormIndex = curFormIndex + 1;
         }
         if (curFormIndex > 0) {
         this._vouchFormValue.addItemAt(crmeap.vouchFormValue, this.curFormIndex - 1);
         }
         else {
         this._vouchFormValue.addItem(crmeap.vouchFormValue);
         }*/
        this._vouchFormValue.addItem(crmeap.vouchFormValue);
        this.setOtherButtons(true);
        this.currid = crmeap.currid;
        setAllButtonsEnabled("onGiveUp", formIidListCount);
        this.curButtonStatus = "onGiveUp";

        autoSubmit();
    }
    else if (this.curButtonStatus == "onEdit") {
        for (var i:int = 0; i < this._vouchFormValue.length; i++) {
            if (_vouchFormValue.getItemAt(i) && _vouchFormValue.getItemAt(i).mainValue && _vouchFormValue.getItemAt(i).mainValue.iid == crmeap.vouchFormValue.mainValue.iid) {
                var _vouchFormValueObj:Object = _vouchFormValue.getItemAt(i);
                this._vouchFormValue.removeItemAt(i);
                _vouchFormValue.addItemAt(crmeap.vouchFormValue, i);
                break;
            }
        }
        this.setOtherButtons(true);
        setAllButtonsEnabled("onGiveUp");
        this.curButtonStatus = "onGiveUp";

        autoSubmit();
    }
    else {
        if (curButtonStatus == "onDelete")
            CRMtool.tipAlert("删除成功...");

        formIidListCount --;
        //curFormIndex --;
        this.curButtonStatus = "onGiveUp";
        onSaveCallBack();
    }


    //wtf add
    this.getWordFlowDetail(this.formIfunIid, this.currid, 0);
}

private function autoSubmit():void {
    if (workFlowStatusDes == "待提交"){
        CRMtool.tipAlert("单据保存成功！  是否同时提交工作流？", null, "AFFIRM", this, "onSubmit");
    }
    else{
        CRMtool.tipAlert("保存成功...");
    }
}

// 放弃
private function onGiveUp():void {
    if (this._vouchFormValue == null) {
        this._vouchFormValue = new ArrayCollection();
    }
    setAllButtonsEnabled(this.curButtonStatus, _vouchFormValue.length);

    //YJ Modify 新增放弃,count-1;
    if (curButtonStatus == "onGiveUp" && currid == 0) {
        this.formIidListCount--;
        curFormIndex--;
        if (formIidListCount <= 0) {
            crmeap.setValue(null, 1);
        }

    }
    crmeap.curButtonStatus = "onGiveUp";

    var obj:Object = this.crmeap.oldvouchFormValue;
    CRMtool.containerChildsEnabled(crmeap, false);
    if (this._vouchFormValue != null && this._vouchFormValue.length > 0) {
        if (llastOptType == "onEdit") {
            if (this.curFormIndex == -1 || this.curFormIndex == 0) {
                this._vouchFormValue.removeItemAt(0);

                this._vouchFormValue.addItemAt(obj, 0);

            }
            else {
                var count:int = 0;
                if(obj.mainValue.iid>0){
                    for each(var objInner:Object in _vouchFormValue) {
                        if (objInner.mainValue.iid == obj.mainValue.iid) {
                            this._vouchFormValue.removeItemAt(count);
                            this._vouchFormValue.addItemAt(obj, count);
                            break;
                        }
                        count++;
                    }
                }

                //curFormIndex = count+1;
            }

            crmeap.setValue(this.crmeap.oldvouchFormValue, 1);
            /*this.oldCurrid = this.crmeap.oldvouchFormValue.mainValue.iid;*/
            crmeap.vouchFormValue = clone(this.crmeap.oldvouchFormValue);
            /*	crmeap.vouchFormValue.*/
        }
        if (llastOptType == "onNew" || llastOptType == "onSave") {
            if (this.curFormIndex == -1 || this.curFormIndex == 1) {
                if (formIidListCount > 0) {
                    reSetAll();
                } else {
                    crmeap.setValue(this._vouchFormValue.getItemAt(0), 1);
                }

            } else {

                var count:int = 0;
                for each(var objInner:Object in _vouchFormValue) {
                    if (objInner.mainValue && (objInner.mainValue.iid == obj.mainValue.iid)) {
                        this._vouchFormValue.removeItemAt(count);
                        this._vouchFormValue.addItemAt(obj, count);
                        break;
                    }
                    count++;
                }
                curFormIndex = oldCurFormIndex;
                crmeap.setValue(this.crmeap.oldvouchFormValue, 1);
                crmeap.vouchFormValue = clone(this.crmeap.oldvouchFormValue);
            }

        }
    } else if (llastOptType == "onNew") {
        if (this.curFormIndex == -1 || this.curFormIndex == 1) {
            if (formIidListCount > 0) {
                reSetAll();
            } else if (this._vouchFormValue.length != 0) {
                crmeap.setValue(this._vouchFormValue.getItemAt(0), 1);
            } else {
                crmeap.setValue(null, 1);
            }

        } else {

            var count:int = 0;
            for each(var objInner:Object in _vouchFormValue) {
                if (objInner.mainValue.iid == obj.mainValue.iid) {
                    this._vouchFormValue.removeItemAt(count);
                    this._vouchFormValue.addItemAt(obj, count);
                    break;
                }
                count++;
            }

            // lr modify
            curFormIndex = oldCurFormIndex;
            if (formIidListCount <= 0) {
                crmeap.setValue(null, 1);
                crmeap.vouchFormValue = null;
            }else{
                crmeap.setValue(this.crmeap.oldvouchFormValue, 1);
                crmeap.vouchFormValue = clone(this.crmeap.oldvouchFormValue);
            }

        }
    }

//	if(crmeap.oldvouchFormValue!=null){
//		crmeap.setValue(crmeap.oldvouchFormValue,1);
//	}
//	else
//	{
//		crmeap.setValue(null,1,1);
//	}
//	crmeap.vouchFormValue = clone(crmeap.oldvouchFormValue);

    if (oldCurrid != 0 && oldFormIfunIid != 0) {
        this.coreSide.refreshData(this.oldFormIfunIid, this.oldCurrid, this.oldwfiid);
        this.currid = oldCurrid;
        this.formIfunIid = oldFormIfunIid;
        this.wfiid = oldwfiid;
        oldCurrid = 0;
        oldwfiid = 0;
        oldFormIfunIid = 0;
    }

    //返回当前单据是否具有修改或删除数据权限提示集合
    loadeditordelwarning();

    this.setOtherButtons(true);
}

private function clone(source:Object):* {
    var myBA:ByteArray = new ByteArray();
    myBA.writeObject(source);
    myBA.position = 0;
    return(myBA.readObject());
}
// 工作流提交
public function onSubmit():void {
    if (this.currid <= 0 || this.currid > 0 && curButtonStatus == "onEdit") {
        CRMtool.showAlert("请先保存后，再提交工作流。");
    } else {
        crmeap.onSubmit();
        crmeap.addEventListener("success", success);
    }
}
// 工作流撤销
private function onRevocation():void {
    this.onRealyDelete();
}

// 模板打印
private function onPrint():void {
    //九江二开
    if(this.formIfunIid == 497){
        var sql:String = " select ilcstatus from lc_useorder where iid = " + this.currid;
        var curridnew:Number=this.currid;
        var formIfunIidnew:Number=this.formIfunIid;
        var printTplsnew:Object=new Object();
        printTplsnew=this.printTpls;
        AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(event:ResultEvent):void{
            var eventAC:ArrayCollection = event.result as ArrayCollection;
            if (eventAC.length > 0) {
                var ilcstatus:int = eventAC[0].ilcstatus;
                if(ilcstatus == 1){
                    crmeap.onPrint(printTplsnew, formIfunIidnew, curridnew);
                }else{
                    CRMtool.showAlert("单据未审核，不允许打印！");
                }
            }

        }, sql, null, false);

    }else{
        crmeap.onPrint(this.printTpls, this.formIfunIid, this.currid);
    }
}
// 导航 上
public function onPrior():void {
    if (curFormIndex > 1) {
        curFormIndex--;
    }
    setOtherButtons(true);
    reSetAll();
}

// 导航 下
public function onNext():void {
    if (curFormIndex < this.formIidListCount) {
        curFormIndex++;
    }
    setOtherButtons(true);
    reSetAll();
}

//导行  最上
public function onTop():void {
    curFormIndex = 1;
    setOtherButtons(true);
    reSetAll();
}

//导行  最下
public function onTail():void {
    curFormIndex = this.formIidListCount;
    setOtherButtons(true);
    reSetAll();
}

// 导航
private function onNavData():void {
}


private function reSetAll():void {
    var objup:Object = null;
    var personObj:Object = null;

    //先判断是否从列表传过来值
    if (this.formIidListCount > 0) {
        if (this.curFormIndex <= this._vouchFormValue.length || this.formIidListCount == this._vouchFormValue.length) {
            objup = this._vouchFormValue.getItemAt(this.curFormIndex - 1);

            //lr modify
            if(formIidList.length> this.curFormIndex - 1){
                personObj = formIidList.getItemAt(this.curFormIndex - 1);
            }else{
                personObj = objup.mainValue;
            }
        }
        else {
            for (var i:int = 0; i < this.formIidList.length; i++) {
                var iid:int = int(formIidList.getItemAt(i).iid);
                var isFind:Boolean = false;
                for (var j:int = 0; j < this._vouchFormValue.length; j++) {
                    var iidStr:int = int(this._vouchFormValue.getItemAt(j).mainValue.iid);
                    if (iid == iidStr) {
                        isFind = true;
                        break;
                    }
                }

                if (!isFind) {
                    personObj = formIidList.getItemAt(i);
                    break;
                }
            }
        }
    }
    else {
        objup = this._vouchFormValue.getItemAt(this.curFormIndex - 1);
    }

    /*	if(null!=objup)
     {
     this.currid = objup.mainValue.iid;
     this.crmeap.currid=objup.mainValue.iid;
     crmeap.setValue(objup,1);
     crmeap.vouchFormValue=objup;
     crmeap.oldvouchFormValue=ObjectUtil.clone(objup);
     }
     else
     {*/
    this.currid = personObj.iid;
    crmeap.currid = personObj.iid;
    crmeap.queryPm(personObj.iid);
//	}
    //返回当前单据是否具有修改或删除数据权限提示集合
    loadeditordelwarning();
    this.getWordFlowDetail(this.formIfunIid, this.currid, 0);
}

public function queryComplete():void {


    var isIn:Boolean = false;
    for each(var item:Object in _vouchFormValue){
        if(item.mainValue&&crmeap.vouchFormValue.mainValue&&(item.mainValue.iid==crmeap.vouchFormValue.mainValue.iid))
            isIn = true;
    }
    if(!isIn)
        this._vouchFormValue.addItem(CloneUtil.Clone(crmeap.vouchFormValue));

    crmeap.initSubTableAssignment();
    setAllButtonsEnabled(this.curButtonStatus, _vouchFormValue.length);
}


/*******************buttonbar itemclick 事件处理end**********/

/*******************单据呈现区与工作流呈现区切换start**********/
//后期在切换时，要注意工作流信息的获取
private function showAreaSwitch(event:ItemClickEvent):void {
    /*if((event.currentTarget as RadioButtonGroup).selection==openRelated&&this.leftPart.selectedChild != this.leftPart.getRelatedObjectsView()){
     this.leftPart.selectedChild = this.leftPart.getRelatedObjectsView();
     }

     if(getRelatedObjectsViewFlag&&(event.currentTarget as RadioButtonGroup).selection==openRelated)
     this.myState=(event.currentTarget as RadioButtonGroup).selection.id;
     else if((event.currentTarget as RadioButtonGroup).selection!=openRelated)
     this.myState=(event.currentTarget as RadioButtonGroup).selection.id;*/

    this.myState = (event.currentTarget as RadioButtonGroup).selection.id;
    //获取工作流节点信息
    if (this.myState == "draw") {
        this.workflow.getFormWorkFlow(this.formIfunIid, this.currid);
        isShowDeleteImg();
    }
}
/*******************单据呈现区与工作流呈现去切换 end**********/

// 当切换为工作流呈现区时
private function requestWorkFlowDetailInfo():void {
}


/*******************获取单据相关信息start**********/
/**
 * 请求单据的信息
 * 单据的描述信息，单据的组件信息（组件的参照，公式，组件的关联信息），对应iid集合的中的单据详信息,子表信息
 * 单据的对应的权限信息，单据关联的打印模板信息，获取绑定的工作流信息（当前工作的处理进度信息，单据是否已经生成工作流等信息）
 */
private function requestFormDetailInfo():void {
}

//非空验证

// 获取右侧，单据的附加信息
private function leftPartHandler():void {

}

// 验证



//上下翻页按钮互斥
public function setOtherButtons(enabled:Boolean):void {

    if (curFormIndex == 0 || curFormIndex == -1) curFormIndex = 1;//YJ Modify 2012-03-31

    //先判断是否有记录
    if (formIidListCount == 0) {
        this.bb_nav.enabled = false;
    }
    else {
        //if (curFormIndex == 1) {
            (this.bb_nav.getChildAt(1) as mx.controls.Button).enabled = false;
            (this.bb_nav.getChildAt(0) as mx.controls.Button).enabled = false;
        //}

        if(curFormIndex>1) {
            (this.bb_nav.getChildAt(1) as mx.controls.Button).enabled = enabled;
            (this.bb_nav.getChildAt(0) as mx.controls.Button).enabled = enabled;
        }

        //if (curFormIndex >= 1 && curFormIndex == formIidListCount) {
            (this.bb_nav.getChildAt(2) as mx.controls.Button).enabled = false;
            (this.bb_nav.getChildAt(3) as mx.controls.Button).enabled = false;
        //}
        if(curFormIndex<formIidListCount) {
            (this.bb_nav.getChildAt(2) as mx.controls.Button).enabled = enabled;
            (this.bb_nav.getChildAt(3) as mx.controls.Button).enabled = enabled;
        }


        //tx_pageNumber.text = curFormIndex + "/" + formIidListCount;
    }
}


// 工作流 以及 右侧 相关功能处理

// 设置工作流状态 信息
public function setWfStatusDes(info:String = ""):void {
    this.workFlowStatusDes = info;
    switch (this.workFlowStatusDes) {
        case "无流程":
        {
            //workFlowStatusImg=ConstsModel.wlcpng;
            this.draw.enabled = false;
            this.draw.toolTip = workFlowStatusDes;

            (bb_wf.getChildAt(0) as mx.controls.Button).enabled = false;
            (bb_wf.getChildAt(1) as mx.controls.Button).enabled = false;
            break;
        }
        case "待提交":
        {
            //workFlowStatusImg=ConstsModel.dtjpng;
            this.draw.enabled = true;
            this.draw.setStyle("color", "#ff8100");
            this.draw.toolTip = workFlowStatusDes;

            (bb_wf.getChildAt(0) as mx.controls.Button).enabled = currid>0;
            (bb_wf.getChildAt(1) as mx.controls.Button).enabled = false;
            break;
        }
        case "已提交":
        {
            //workFlowStatusImg=ConstsModel.jtjpng;
            this.draw.enabled = true;
            this.draw.setStyle("color", "#000");
            this.draw.toolTip = workFlowStatusDes;

            (bb_wf.getChildAt(0) as mx.controls.Button).enabled = false;
            (bb_wf.getChildAt(1) as mx.controls.Button).enabled = true;
            break;
        }
    }
}

// 获取工作流相关信息 ，打印模板，是否绑定工作路模板，
/**
 * ifuniid  功能注册码
 * djiid    单据内容
 * isflag    是否重新刷新 工作流模板与打印模板信息 0 刷新 1 不刷新
 */

public function getWordFlowDetail(ifuniid:int, djiid:int, isflag:int = 1, XGGNenable:Boolean = true):void {
    var warning:String = auth.reuturnwarning("01");
    if (CRMtool.isStringNotNull(warning)) {
        CRMtool.showAlert(warning);
        CRMtool.removeChildFromViewStack();
        return;
    }
    //Alert.show("功能注册码["+ifuniid+"],单据内码["+djiid+"]","提示");

    // 1 更具单据的功能注册码 验证单据是否绑定了 工作路模板
    // 2 如果绑定了模板 ---->> 再根据单据的内码 来判断是生成了工作流 以及获取单据功能注册码对应的 打印模板文件
    // 3 如果生成了工作流 则获取该工作流信息，以及判断该工作流当前处理节点 是否 与当前登录人时统一个人
    if (ifuniid <= 0) {
        Alert.show("无法获取单据功能注册码", "提示");
        return;
    }
    this.XGGNenable = XGGNenable;
    AccessUtil.remoteCallJava("WorkFlowDest", "wfCoreHandler", wfCallBack, {ifuniid:ifuniid, djiid:djiid, isflag:isflag}, null, false);
}

// 再返回数据时，注意清空 之前的数据

private function clearData():void {
    this.wfiid = 0;
    this.workFlowDesc = null;
    this.setWfStatusDes("");
    //this.resultbmodify = false;
}

private function wfCallBack(event:ResultEvent):void {
    clearData();
    //Alert.show(""+ObjectUtil.toString(event.result));
    var ret:Object = event.result;
    if (ret != null) {

        //获取工作流请求信息 包括 错误代码 比较信息的信息
        this.workFlowDetail = ret;

        //获取打印模板信息
        if (ret.hasOwnProperty("print")) {
            printTemplate = new ArrayCollection([
                {cname:""}
            ]);
            printTemplate.addAll(ret.print as ArrayCollection);
        }else{
            btn_print.enabled = false;
        }

        //设置默认打印模板
        for each (var item:Object in ret.print) {
            if (item.ifuncregedit == this.formIfunIid && item.bdefault == true) {
                this.printTpls.selectedItem = item;
            }
        }

        //获取工作流的描述信息
        if (ret.hasOwnProperty("wfinfo")) {
            this.workFlowDesc = ret.wfinfo;
            this.wfiid = this.workFlowDesc.iid;
            //this.setWfStatusDes("协同浏览["+this.wfiid+"]");

            this.setWfStatusDes("已提交");
        } else {
            //this.setWfStatusDes("没有工作流");
            this.setWfStatusDes("待提交");
        }

        if (ret.hasOwnProperty("retcode1")) {
            this.workFlowTempDesc = ret.retcode1;
            this.setWfStatusDes("无流程");
        }

        if(ret.hasOwnProperty("mp")){
            var invoset:Object = ret.mp;
            cexecsql = CRMtool.replaceReadXMLMarkValues(invoset.cexecsql);
            cexecsql = CRMtool.replaceWFtypeValues(cexecsql,"提交");
        }
    }
    //wtf add
    this.coreSide.refreshData(this.formIfunIid, this.currid, this.wfiid, XGGNenable);
    XGGNenable = true;
    //获取工作流节点信息HHHHHHH
    if (this.myState == "draw") {
        this.workflow.getFormWorkFlow(this.formIfunIid, this.currid);
        isShowDeleteImg();
    }
}

private function setResultbmodify(event:ResultEvent):void {
    var result:ArrayCollection = event.result as ArrayCollection;
    this.resultbmodify = result[0].bworkflowmodify;
    bar.enabled = true;
}

/**
 *  撤销工作流
 */
// 撤销
private function onRealyDelete():void {
    if (formIfunIid <= 0) {
        Alert.show("获取不到单据功能注册码", "提示");
        return;
    }
    if (currid <= 0) {
        Alert.show("获取不到单据内容", "提示")
        return;
    }
    if (wfiid <= 0) {
        Alert.show("获取不到工作流", "提示")
        return;
    }

    /*	if(coreSide.getXTHFitems()){
     Alert.show("已被处理，不能撤销！","提示");
     return;
     }*/
    CRMtool.tipAlert1("确定撤销协同吗?", null, "AFFIRM", function ():void {
        onDeleteFormWorkFlow();
    });
}

private function onDeleteFormWorkFlow():void {
    var cexecsqlBack2:String = CRMtool.replaceWFtypeValues(cexecsqlBack,"撤销");
    cexecsqlBack2 =  CRMtool.replaceCrmeapAndSystemValues(cexecsqlBack2,crmeap);
    AccessUtil.remoteCallJava("WorkFlowDest", "co_deleteWorkFlow", deleteCallBack, {ifuniid:this.formIfunIid, djid:this.currid, ioainvoice:this.wfiid, iperson:CRMmodel.userId,cexecsql:cexecsqlBack2}, "正在撤销协同...");
}
private function deleteCallBack(event:ResultEvent):void {
    var ret:String = event.result.result as String;
    if (ret == "suc") {
        this.wfiid = 0;
        Alert.show("撤销成功", "提示");
        this.setWfStatusDes("撤销成功");
        this.getWordFlowDetail(this.formIfunIid, this.currid, 0, false);
        //获取工作流节点信息
        if (this.myState == "draw") {
            this.workflow.getFormWorkFlow(this.formIfunIid, this.currid);
            isShowDeleteImg();
        }

        loadedflowwarning();

        var cexecsql:String =  event.result.cexecsql;
        if(CRMtool.isStringNotNull(cexecsql)){
            cexecsql = CRMtool.replaceReadXMLMarkValues(cexecsql);
            cexecsql = CRMtool.replaceWFtypeValues(cexecsql,"撤销");
            cexecsql =  CRMtool.replaceCrmeapAndSystemValues(cexecsql,crmeap);

            AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function(event:ResultEvent):void{
                dispatchEvent(new Event("cardValueChange"));
            }, cexecsql, null, false);
        }
    } else {
        Alert.show("撤销失败:" + ret, "提示");
    }
}

// 设置工作流中 删除图标的 是否显示
private function isShowDeleteImg(bool:Boolean = false):void {
    if (this.workflow&&this.workflow.wf_trash) {
        this.workflow.wf_trash.visible = bool;
    }
}




