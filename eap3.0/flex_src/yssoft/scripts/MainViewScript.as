import flash.display.Bitmap;
import flash.display.DisplayObject;
import flash.display.Loader;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.external.ExternalInterface;
import flash.net.URLRequest;
import flash.net.navigateToURL;
import flash.utils.ByteArray;
import flash.utils.Timer;

import mx.collections.ArrayCollection;
import mx.collections.Sort;
import mx.collections.XMLListCollection;
import mx.containers.HBox;
import mx.controls.Alert;
import mx.controls.Button;
import mx.controls.LinkButton;
import mx.controls.List;
import mx.controls.Text;
import mx.core.mx_internal;
import mx.events.FlexEvent;
import mx.events.ListEvent;
import mx.managers.PopUpManager;
import mx.messaging.events.MessageEvent;
import mx.messaging.events.MessageFaultEvent;
import mx.rpc.events.FaultEvent;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;

import spark.collections.SortField;
import spark.components.BorderContainer;
import spark.primitives.Rect;

import yssoft.comps.CrmDotLine;
import yssoft.comps.KeyWindow;
import yssoft.comps.LockWindow;
import yssoft.comps.Square;
import yssoft.comps.TabsManager;
import yssoft.comps.frame.FrameworkVBoxView;
import yssoft.comps.frame.module.CrmEapLinkButton;
import yssoft.evts.NavEvent;
import yssoft.frameui.FrameCore;
import yssoft.frameui.menu.MenuItem;
import yssoft.interfaces.IMainViewStackSearch;
import yssoft.models.CRMmodel;
import yssoft.models.ConstsModel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.tools.StringTool;
import yssoft.views.HomeViewPro;
import yssoft.views.callcenter.CallCenterCore;
import yssoft.views.cstyle.ChangeStyleWindow;
import yssoft.views.msg.FastReply;
import yssoft.views.msg.MsgEvent;
import yssoft.views.msg.PersonMsgView;
import yssoft.views.msg.QunFaMsgWindow;
import yssoft.vos.HrPersonVo;

[Embed(source="/yssoft/assets/images/dest.png")]
private const defaultIcon:Class;

[Embed(source="/yssoft/assets/images/homeicon.png")]
private const homeicon:Class;

/**
 * 脚本控制
 * @auth: zmm
 * @date: 2011-08-04
 */
// 主窗体 加载 完成
//private function mainViewCCHandler():void {
//    CRMmodel.mainView = this;
//
//    CRMmodel.mainSearchTextInput = newTextInput;
//
//    this.setFocus();
//    CRMtool.addExt();
//    getAuthMenus();
//    this.stage.addEventListener(MouseEvent.CLICK, onStageClick);
//    //this.stage.addEventListener(Event.DEACTIVATE,onStageClick);
//    loadUserHeaderIcon();
//    CRMmodel.mainViewStack = this.mainViewStack;
//    CRMmodel.crmLinkBar = this.crmLinkBar;
//
//    //this.welcomeTxt.htmlText="<b>欢迎您<br/><font color='#4F9CD4' >"+CRMmodel.hrperson.cname+"</font></b>";
//
//    // 对js 开放 flex onLogoutHandler 方法
//    ExternalInterface.addCallback("logout", logoffLog);
//
//    //获取在线人数
//    try {
//        onLineUserTimer();
//    } catch (e:Error) {
//    }
//
//    // 订阅消息
//    this.msgCenter.subscribe();
//    //长时间不操作显示
//    this.systemManager.addEventListener(FlexEvent.IDLE, userIdle);
//
//    //检测加密锁
//    checkKey();
//
//
//}
// 注销后 再次进入被执行,要完成一些清理工作
//public function logoutEnter():void {
//    mainViewCCHandler();
//}

//获取用户权限菜单 根据用户id
//菜单数据
private var authMenu:XML;

// 当前用户
private var hrperson:HrPersonVo;
//固定距离
[Bindable]
public var fixwidth:int = 45;
//一级菜单显示列表
[Bindable]
private var xmlListCollection:XMLListCollection = new XMLListCollection();
public function getAuthMenus():void {
    hrperson = CRMmodel.hrperson as HrPersonVo;
    authMenu = CRMmodel.authMenu;

    navbb.dataXml = authMenu;

    if (navbb.width > this.menubar.width)
        this.menubar.width = navbb.width + fixwidth;

    //xmlListCollection=new XMLListCollection(authMenu.child("node"));

    //Alert.show(""+CRMmodel.authMenu.toString());
    // 设置 登录用户的 基本信息
    // 格式 13775889510   增宇软件   朱毛毛 产品项目部   开发人员
    /*	this.personinfotxt.label= StringTool.isNull("徐州增宇软件公司")*/
    this.personinfotxt_user.label = StringTool.isNull(hrperson.cname)
        //+" "+StringTool.isNull(hrperson.postcname)
            + " [ " + StringTool.isNull(hrperson.departcname) + " ]"
    //+" "+StringTool.isNull(hrperson.ijob1cname)
}


// navbb itemover事件
//创建浮动窗口
private var floatArray:Array = [];		//记录浮动窗口的数组
private var preIndex:int = 0; 			//上次打开的 浮动窗口 的索引
private var itemVGap:int = 3; 			//垂直间隔、
private var itemHGap:int = 2;			//水平间隔
private var itemHeight:int = 22;			//高度
private var itemWidth:int = 150;			//宽度
private var rows:int = 16; 				//一栏 的个数
private var xml:XML;					//当前选中的 数据集 集合
private var subCount:int;				//获取子类的 个数
private var floatbc:BorderContainer;	//浮动窗口
private var yjlinegap:int = 2;			//一级菜单 与 旗下的 水平线的 间隔
private var menuOffSetX:int = 0;			//浮动窗口的 水平 偏移
private var menuOffSetY:int = -3;			//浮动窗口 与 菜单 之间的间隔


// 移开菜单区域时，隐藏
private function onMenuRollOut(event:MouseEvent):void {
    this.callLater(onStartTimer);
}
private var _starttimer:Timer;
private function onStartTimer():void {
    if (_starttimer == null) {
        _starttimer = new Timer(800);
        _starttimer.addEventListener(TimerEvent.TIMER, onHide);
    }
    _starttimer.stop();
    _starttimer.start();
}

private function onHide(event:TimerEvent):void {
    if (floatbc == null || isBool) {
        return;
    }
    floatbc.visible = false;
    (this.navbb.getChildAt(parseInt(floatbc.name)) as LinkButton).styleName = "menu_noskin";
    (event.currentTarget as Timer).stop();
}

protected function navbbItemRollOver(event:NavEvent):void {
    if (_starttimer) {
        _starttimer.stop();
    }
    //Alert.show("--"+event.childIndex+"--");
    //this.navbb.selectedIndex=event.itemIndex;

    if (event.type == NavEvent.OUTCHANGE) {
        (this.navbb.getChildAt(event.childIndex) as LinkButton).styleName = "menu_noskin";
    } else {
        (this.navbb.getChildAt(event.childIndex) as LinkButton).styleName = "menu_hasskin";
    }

    if (floatArray[preIndex] is BorderContainer) {//关闭上一个打开的 浮动的窗口
        (floatArray[preIndex] as BorderContainer).visible = false;
    }
    //(floatArray[preIndex] as BorderContainer)
    //menulist
    preIndex = event.itemIndex;
    if (floatArray[event.itemIndex] is BorderContainer) {
        floatbc = (floatArray[event.itemIndex] as BorderContainer);
        floatbc.x = menubar.x + wt(event.itemIndex) - floatbc.width;
        floatbc.y = menubar.y + menubar.height + menuOffSetY - 2;
        floatbc.visible = true;
        return;
    }

    floatbc = new BorderContainer();
    floatbc.styleName = "menulist";
    floatbc.name = "" + event.childIndex;
    floatbc.addEventListener(MouseEvent.ROLL_OUT, hideFloatbc);
    floatbc.addEventListener(MouseEvent.ROLL_OVER, onRollOverBC);

    this.addElement(floatbc);
    floatArray[event.itemIndex] = floatbc;
    xml = authMenu.children()[event.itemIndex] as XML;
    subCount = xml.children().length();

    var linkbt:MenuItem;
    var curgs:int = 0;
    var yllb:Text;
    for (var i:int = 0; i < subCount; i++) {// 遍历一级节点

        //一级菜单 隐藏
        var item:XML = (xml.children()[i] as XML);

        if (String(item.@bshow) == "false") { // 一级菜单 bshow=0 为不显示
            continue;
        }

        //Alert.show("bshow["+String(item.@bshow)+"]");
        //如果子组件的个数为0 ，也不显示
        var curItemChildrenNum:int = (xml.children()[i] as XML).children().length();

        yllb = new Text();
        yllb.x = parseInt("" + curgs / rows) * (itemHGap + itemWidth) - 1;
        yllb.y = (curgs - (parseInt("" + curgs / rows)) * rows) * (itemVGap + itemHeight);
        yllb.width = itemWidth;
        yllb.height = itemHeight;
        // 一级菜单 不显示图标，即使该菜单 设置了图标
        //linkbt.setStyle("icon",ConstsModel["png_menu"+(xml.children()[i] as XML).@iimage]);
        //var item:XML=(xml.children()[i] as XML);
        yllb.text = item.@cname;
        yllb.styleName = "yjmenu";
        yllb.setStyle("textIndent", headerlinegap);
        yllb.data = xml.children()[i];
        yllb.addEventListener(MouseEvent.CLICK, yjMenuClick);
        floatbc.addElement(yllb);

        //绘制 水平线
        drawHLine(floatbc, yllb.x, yllb.y + yllb.height + yjlinegap);
        curgs++;

        for (var j:int = 0; j < curItemChildrenNum; j++) { // 遍历二级节点
            var subitem:XML = (xml.children()[i] as XML).children()[j] as XML;

            if (String(subitem.@bshow) == "false") {
                continue;
            }

            var linkHbox:HBox = new HBox();


            linkbt = new MenuItem();
            linkbt.percentWidth = 100;
            linkHbox.x = parseInt("" + curgs / rows) * (itemHGap + itemWidth) + 1;
            linkHbox.y = (curgs - (parseInt("" + curgs / rows)) * rows) * (itemVGap + itemHeight);
            linkHbox.width = itemWidth - 2;    //宽度
            linkbt.height = itemHeight;

            linkbt.styleName = "menuLinkButton";
            //linkbt.setStyle("icon", ConstsModel["png_menu" + subitem.@iimage]);
            linkbt.label = subitem.@cname
            linkbt.useHandCursor = false;
            linkbt.data = subitem;
            linkbt.enabled = CRMmodel.userId == 1;
            linkHbox.addChild(linkbt);

            if (String(subitem.@iszc) == "no") { // 没有设定权限的
                linkbt.enabled = true;
            } else {
                if (String(subitem.@buse) == "1" && String(subitem.@hasauth) == "yes") {
                    linkbt.enabled = true;
                }
            }


            linkbt.addEventListener(MouseEvent.CLICK, ejMenuClick);

            if (subitem.@irfuncregedit != null && subitem.@irfuncregedit != "") {

                //lr add 对应节点 01 权限 buse 为1 才能显示此按钮，具体请查看视图 vi_authbase
                if (String(subitem.@rbuse) == "true" || CRMmodel.userId == 1) {
                    linkbt.plusTip = subitem.@crname + "";
                    linkbt.plusData = subitem;
                }

                if (CRMmodel.userId != 1 && String(subitem.@riszc) == "yes") {//启用权限
                    if (String(subitem.@rhasauth) != "yes") {
                        linkbt.plusData = null;
                    }
                }

                linkbt.addEventListener("plusButtonClick", rLinkBtClink);
            }

            floatbc.addElement(linkHbox);
            curgs++;
        }
    }
    //设置浮动窗口高度和宽度
    if (parseInt("" + curgs / rows) > 0) {
        floatbc.height = rows * (itemVGap + itemHeight);
        if (curgs % rows == 0) {//正好为整数倍时，不再加1
            floatbc.width = parseInt("" + curgs / rows) * (itemHGap + itemWidth);
        } else {
            floatbc.width = (parseInt("" + curgs / rows) + 1) * (itemHGap + itemWidth);
        }
    } else {
        floatbc.height = curgs * (itemVGap + itemHeight);
        floatbc.width = itemHGap + itemWidth;
    }
    // 绘制 垂直 线
    var colsum:int = floatbc.width / itemWidth;
    if (colsum > 1) {
        for (var colindex:int = 1; colindex <= (colsum - 1); colindex++) {
            drawVLine(floatbc, colindex * itemWidth);
        }
    }
    //event.localToGlobal();
    floatbc.x = menubar.x + wt(event.itemIndex) - floatbc.width;
    floatbc.y = menubar.y + menubar.height + menuOffSetY - 2;
    //CRMtool.showAlert("floatbc.x:"+floatbc.x+",menubar.x:"+menubar.x+",wt:"+wt(event.itemIndex)+"floatbc.width:"+floatbc.width);
}

private function rLinkBtClink(event:Event):void {
    var crmeapLink:MenuItem = event.currentTarget as MenuItem;
    var param:Object = {};
    param.ifuncregedit = crmeapLink.plusData.@irfuncregedit + "";
    param.ctable = crmeapLink.plusData.@rctable;
    param.itemType = "onNew";
    param.operId = "onListNew";
    param.formTriggerType = "fromOther";
    var iid:ArrayCollection = new ArrayCollection();
    param.personArr = iid;
    CRMtool.openMenuItemFormOther(crmeapLink.plusData.@rcprogram + "", param, crmeapLink.plusData.@crname + "", "");

}

//微调距离
private function wt(index:int):int {
    var clen:int = navbb.numChildren;
    var allwidth:int = fixwidth;
    for (var i:int = 0; i < clen; i++) {
        if (i <= index * 2) {
            allwidth += navbb.getChildAt(i).width;
        }
    }
    /*if(index !=0){
     allwidth +=(index-1)*0.5;
     }*/
    return allwidth + 11;
}
private var isBool:Boolean = false;
private function onRollOverBC(event:MouseEvent):void {
    isBool = true;
    //Alert.show("----");
}
// 鼠标移开 关闭菜单浮动窗口
private function hideFloatbc(event:MouseEvent):void {
    (event.currentTarget as BorderContainer).visible = false;
    (this.navbb.getChildAt(parseInt((event.currentTarget as BorderContainer).name)) as LinkButton).styleName = "menu_noskin";
    isBool = false
}
// 画线 水平线
private var headerlinegap:int = 8; // 线头 间隔
private var taillinegap:int = 13;   // 线尾 间隔
private function drawHLine(bc:BorderContainer, x:int, y:int):void {
    var hrule:CrmDotLine = new CrmDotLine();
    hrule.height = 1;
    hrule.width = itemWidth - taillinegap;
    hrule.y = y - yjlinegap;
    hrule.x = x + headerlinegap;
    bc.addElement(hrule);
}
// 画 垂直线 
private var vlingap:int = 10;
private function drawVLine(bc:BorderContainer, x:int):void {
    var vrule:CrmDotLine = new CrmDotLine();
    vrule.direction = "v";
    vrule.width = 1;
    vrule.y = vlingap;
    vrule.height = bc.height - 2 * vlingap;
    vrule.x = x //- itemHGap;
    bc.addElement(vrule);
}


//一级菜单点击效果
private function yjMenuClick(event:MouseEvent):void {
    //Alert.show(""+this.navbb.width);
    //var cas:Canvas=new Canvas();
    //cas.label=

}
//二级菜单点击效果
private function ejMenuClick(event:MouseEvent):void {
    var nodeXml:XML = event.currentTarget.data as XML;
    /*Alert.show(nodeXml.toXMLString());*/
    CRMtool.openMenuItem(nodeXml, nodeXml.@cparameter);
}


// 点击 其他部位() 关闭 浮动窗口
private function onStageClick(event:Event):void {
    //if(event.currentTarget is Stage){
    if (floatArray[preIndex] is BorderContainer) {  //关闭上一个打开的 浮动的窗口
        (floatArray[preIndex] as BorderContainer).visible = false;
        //this.navbb.selectedIndex=-1;
    }
    //}
}
//防止 点击 navbb时 关闭浮动窗口
private function navbb_clickHandler(event:MouseEvent):void {
    event.stopPropagation();
}

// 注销 ， 设置， 帮助 功能实现
private function baseLinkButtonHandler(event:MouseEvent):void {
    this["on" + (event.currentTarget as LinkButton).name + "Handler"]();
}
//换肤
private function onChangeSkinHandler():void {
    //Alert.show("---换肤---");
    //ChangeSkinUtil.changeSkin("yssoft/styles/CRMstyle1.swf");
    CRMtool.openView(new ChangeStyleWindow());
}
//注销
private function onLogoutHandler():void {
    CRMtool.showAlert("您确定要注销系统吗?", null, "AFFIRM", this, "jumpeToIndex");
}
//在线用户
private function onZXYHHandler():void {
    if (CRMmodel.isShowMsg) {
        return;
    }
    var personMsg:PersonMsgView = new PersonMsgView();
    personMsg.owner = this;
    CRMtool.openView(personMsg);
    CRMmodel.isShowMsg = true;
}
//信息中心
private function onXXZXHandler():void {
    CRMtool.openMenuItemFormOther("yssoft.views.workflow.CoManager", "dbsx", "协同管理", "");
}


public function jumpeToIndexWithOutRemote():void {
    callLater(navigateToURL, [new URLRequest("index.jsp"), "_self"]);
}


// 跳转
public function jumpeToIndex():void {
    AccessUtil.remoteCallJava("UserDest", "onUserLogout", function (e:ResultEvent):void {
        var status = String(e.result);
        if (status == "suc") {
            //logoffLog();
            CRMtool.clearExt();
            //var ibrowser:IBrowserManager=BrowserManager.getInstance()
            //var url:String=ibrowser.url;
            //Alert.show(""+url);
            callLater(navigateToURL, [new URLRequest("index.jsp"), "_self"]);
        }
    }, CRMmodel.userId);

}

// 添加退出日志
public function logoffLog():void {
    AccessUtil.remoteCallJava("UserDest", "logoff", null, CRMmodel.userId, null, false);
}
public function jsfunction():void {
    logoffLog();
}
private function logoffCallBack():void {

}
// 从 mainViewStack 中删除 组件 ,index 是子组件的 索引号
private function linkBarCallBack(index:int):void {
    if (index < 0 || index > this.mainViewStack.numChildren - 1) {
        return;
    }
    //Alert.show("---callback---"+index);
    //如果有子组件中 有自定的 清理函数就执行
    var child:Object = this.mainViewStack.getChildAt(index);
    /*	if(child && child.hasOwnProperty("onWindowClose")){
     child["onWindowClose"]();
     }
     this.mainViewStack.removeChildAt(index);
     if(index-1>0){
     this.mainViewStack.selectedIndex=index-1;
     }*/

    if (child is FrameCore) {
        //编辑状态
        //var editstate:Boolean=(item=="onNew" || item=="onEdit");
        var editstate:Boolean = ((child as FrameCore).curButtonStatus == "onNew" || (child as FrameCore).curButtonStatus == "onEdit");
        if (editstate) {
            CRMtool.tipAlert1("当前单据[" + (this.crmLinkBar.getChildAt(index) as Button).label + "]正处在编辑状态，您确定关闭该窗口？", null, "AFFIRM", function ():void {
                closeMainViewStack(child, index);
            });
        } else {
            closeMainViewStack(child, index);
        }
    } else {
        closeMainViewStack(child, index);
    }

}

private function closeMainViewStack(child:Object, index:int):void {
    if (child && child.hasOwnProperty("onWindowClose")) {
        child["onWindowClose"]();
    }
    this.mainViewStack.removeChildAt(index);
    //lr modify
    if (index > 0) {
        this.mainViewStack.selectedIndex = index - 1;
    }
}


/**
 *  加载用户的头像
 */
private function loadUserHeaderIcon():void {
    var param:Object = {};
    param.fileName = "" + CRMmodel.userId;
    param.fileType = "jpg";
    param.downType = "0";
    AccessUtil.remoteCallJava("FileDest", "downFile", loadHeaderIconCallBack, param, "图片下载中...", false);
}
private function loadHeaderIconCallBack(event:ResultEvent):void {
    if (event.result) {
        try {
            var ba:ByteArray = event.result as ByteArray;
            var loader:Loader = new Loader();
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE, function (event:Event):void {
                var sourceBMP:Bitmap = event.currentTarget.loader.content as Bitmap;
                sourceBMP.width = 34;
                sourceBMP.height = 34;
                CRMtool.addUserHeaderIcon(CRMmodel.userId, sourceBMP);
                CRMmodel.headerIcon = sourceBMP;
            });
            loader.loadBytes(ba);
        } catch (e:Error) {
            Alert.show("---获取头像出错---");
        }
    }
}

/**
 *  打开用户信息修改页面
 */
private function openUserDataEditView():void {
    CRMtool.openMenuItemFormOther("yssoft.views.person.PersonDataEditView", null, "个人信息设置", "000");
}

/**
 * 页签管理
 */
private var tabs:TabsManager;
private function onTabsCreateComplete():void {
    if (tabs == null) {
        tabs = new TabsManager();
        tabs.viewStack = this.mainViewStack;
//        tabs.owner = this.tabsmg;
        tabs.linkbar = this.crmLinkBar;
    }
    tabs.items = ergodic();
//    this.tabsmg.popUp = tabs;
}


private function onTabsChange():void {
    if (tabs == null) {
        return;
    }
    tabs.items = ergodic();
}

private function ergodic():ArrayCollection {
    var tp:ArrayCollection = new ArrayCollection();
    var index:int = this.crmLinkBar.selectedIndex;
    for each(var child:Object in this.crmLinkBar.getChildren()) {
        if (child is Button) {
            var item:Object = {};
            item.label = child.label;
            item.name = child.name;
            if (crmLinkBar.getChildIndex(child as DisplayObject) == index) {
                item.checked = "0";
            } else {
                item.checked = "1";
            }

            tp.addItem(item);
        }
    }

    return tp;
}


/**
 * 获取在线人数
 */

private var _timer:Timer;
private var _delaytimer:Number = 10000; // 单位毫秒  lr
private function onLineUserTimer():void {
    if (!_timer) {
        _timer = new Timer(0);
    }
    _timer.stop();
    if (_timer.hasEventListener(TimerEvent.TIMER) == false) {
        _timer.addEventListener(TimerEvent.TIMER, onLineUser);
    }
    _timer.start();
}
private function onLineUser(event:TimerEvent = null):void {
    _timer.stop();
    var str:String = CRMmodel.userId + "";
    AccessUtil.remoteCallJava("UserDest", "onLineUserParseXML", onLineCallBack, str, null, false, null, onLineError);

    checkDiaryAndPlan(CRMmodel.userId, "oa_workdiary");//客商活动
    checkDiaryAndPlan(CRMmodel.userId, "oa_workplan");//客商计划
    if (event) {
        (event.currentTarget as Timer).delay = _delaytimer;
    }
}
//检查是否有到期提醒的客商活动和客商计划
private function checkDiaryAndPlan(iperson:int, ctable:String):void {
    var checkSql:String = "select iid,iifuncregedit  from " + ctable + " where imaker=" + iperson + " and CONVERT(varchar(100),dmessage,0) = CONVERT(varchar(100),SYSDATETIME(),0)";
    AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
        var ac:ArrayCollection = e.result as ArrayCollection;

        if (ac && ac.length > 0) {
            for each(var obj:Object in ac) {
                var itype:int = 13;//客商活动 iifuncregedit = 46
                if (obj.iifuncregedit == 35) {
                    itype = 12;//客商计划 iifuncregedit = 35
                }
                sendMsg(itype, obj.iifuncregedit, obj.iid, iperson);//发送消息
            }
        }
    }, checkSql, null, false);
}
//发送消息（消息框提醒）
private function sendMsg(itype:int, ifuncregedit:int, iid:int, iperson:int):void {
    var mysql:String = "select * from  as_communication where isread = 0 and itype=" + itype + " and ifuncregedit=" + ifuncregedit + " and iinvoice=" + iid;
    AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
        var ac:ArrayCollection = e.result as ArrayCollection;
        if (ac && ac.length > 0) {

        } else {
            var mysql:String = "insert into as_communication (itype,isperson,irperson,ifuncregedit,iinvoice) values(" + itype + "," + iperson + "," + iperson + "," + ifuncregedit + "," + iid + ")";
            AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, mysql, null, false);
        }
    }, mysql, null, false);
}
//获取数据 出错 
private function onLineError(fault:FaultEvent):void {

    if (fault.fault.faultCode == "Channel.Call.Failed" || fault.fault.faultCode == "Client.Error.MessageSend") {
        showNetError();
    }
    /*	if(!_timer){
     return;
     }
     _timer.stop();
     _timer.start();*/
}

private function showNetError():void {
    connCount++;

    if (true) {
        if (CRMmodel.connOK) {
            if (CRMmodel.indexApp)
                CRMmodel.indexApp.currentState = "errorState";

            CRMtool.tipAlert("⊙﹏⊙  服务器连接失效,请检查网络是否正常。", null, "OK", this, "closeApp");
        }
        CRMmodel.connOK = false;
    }
}


public function closeApp():void {
    navigateToURL(new URLRequest('javascript:window.opener=null;window.close()'), '_self')
}

private var connCount = 0;

private var _onlineUserXml:XML;
private function onLineCallBack(event:ResultEvent):void {
    connCount = 0;
    _timer.stop();
    _timer.start();

    if (event.result) {
        _onlineUserXml = new XML(event.result.user_xml);
        //this.zxyhlkbt.floatTxt=""+_onlineUserXml.children().length();
        //this.zxyhlkbt.toolTip="在线人数["+this.zxyhlkbt.floatTxt+"]"
        //this.xxzxbt.floatTxt = ""+event.result.dbsx_sum; //待办事项总数
        //this.xxzxbt.toolTip="待办事项["+event.result.dbsx_sum+"]";

        //lr add

        if (CRMmodel.dbsx_count != (event.result.dbsx_sum as int)) {
            CRMmodel.dbsx_count = event.result.dbsx_sum;

            //刷新 桌面信息
            var hv:HomeViewPro = mainViewStack.getChildAt(0) as HomeViewPro;
            if (hv)
                hv.refSubHome();

            //查询系统消息
            floatMsgWindow.getMsgItems();

        }

        if (CRMmodel.jhtx_count != (event.result.jhtx_sum as int)) {
            CRMmodel.jhtx_count = event.result.jhtx_sum;
        }

        if (CRMmodel.online_count != _onlineUserXml.children().length()) {
            CRMmodel.online_count = _onlineUserXml.children().length();
            this.dispatchEvent(new Event("onlineCountChange"));
        }

    }
}


/**
 *  消息处理
 */
private function msgCenterHandler(event:MessageEvent):void {
    if (event.message == null) {
        return;
    }
    var headers:Object = event.message.headers;
    var itype:int = headers["itype"]; // 消息的类型 0 个人消息 1 公告消息
    var irperson:int = headers["irperson"] // 接受者
    var isperson:int = headers["isperson"] // 接受者
    var msgBody:Object = event.message.body;


    if (itype == 3 && isperson != CRMmodel.userId) { // 系统消息
        var qf:QunFaMsgWindow = new QunFaMsgWindow();
        qf.currentState = "js";
        CRMtool.openView(qf);
        qf.title = "系统消息[" + msgBody.dsend + "]";
        qf.jsmsg.htmlText = msgBody.cdetail;
        return;
    }

    // 筛选 自己的消息并显示
    if (itype == 1 || (itype == 0 && irperson == CRMmodel.userId)) {
        var msgEvent:MsgEvent = new MsgEvent(MsgEvent.NEW_MSG, msgBody, false, true);
        this.stage.dispatchEvent(msgEvent);
        if (!CRMmodel.isShowMsg) {//消息窗体没有打开时，显示快速提示窗口
            showFastReply("" + itype, msgBody);
        }
    }

    if (CRMmodel.isLocked) { // 锁屏时，不是显示 弹出消息，锁屏窗口始终现实在top front
        if (lockWindow) {
            PopUpManager.bringToFront(lockWindow);
        }
    }
}
//private var fastReply:FastReply=null;
private function showFastReply(msgType:String, msgBody:Object):void {
    //if(fastReply == null){
    var fastReply:FastReply = new FastReply();
    //}
    fastReply.msgBody = msgBody;
    CRMtool.openView(fastReply);
}

private function msgCenterFault(event:MessageFaultEvent):void {
    showNetError();
}


/**
 *
 * 初始化首页显示
 */
private function initHBoxHomePage():void {
    if (CRMmodel.hrperson.ihfuncregedit != null && CRMmodel.hrperson.ihfuncregedit != "0" && CRMmodel.hrperson.ihfuncregedit != "" && CRMmodel.hrperson.ihfuncregedit != "null") {
        AccessUtil.remoteCallJava("FuncregeditDest", "getSingleFuncregeditByID", call_fun_homePage, CRMmodel.hrperson.ihfuncregedit);
    }
    else {
        var homeview:HomeViewPro = new HomeViewPro();
        homeview.percentHeight = 100;
        homeview.percentWidth = 100;
        homeview.label = "我的桌面";
        this.mainViewStack.addChild(homeview);
    }
}

private function call_fun_homePage(e:ResultEvent):void {
    if (e.result == null) {
        return;
    }
    var obj:Object = e.result.funcregeditMap;
    var params:Object = {};
    params.itemType = "onNew";
    params.operId = "onListDouble";
    params.ifuncregedit = obj.iid;

    if ((obj.cprogram + "").indexOf("FrameworkVBoxView") != -1) {
        params = obj.cparameter;
        CRMtool.openMenuItemFormOther(obj.cprogram, params, "我的桌面", "");
    }
    else {
        CRMtool.openMenuItemFormOther(obj.cprogram, params, "我的桌面", "");
    }
}


// 长时间不操作，显示窗口
private var lockWindow:LockWindow = null;
private function userIdle(event:FlexEvent):void {
    var locktime:int = 0;
    if (CRMmodel.hrperson.idscreenlock <= 0) {
        locktime = 10;
    } else {
        locktime = CRMmodel.hrperson.idscreenlock;
    }
    //Alert.show("locktime["+locktime+"]");
    if (event.currentTarget.mx_internal::idleCounter == locktime * 600) {     //5分钟是3000（1分钟是600）
        //进行登录超时处理!
        if (!CRMmodel.isLocked) { // 防止多次打开 这个窗口
            CRMmodel.isLocked = true;
            if (lockWindow == null) {
                lockWindow = new LockWindow();
            }

            try {
                lockWindow.userpwd.text = "";
            } catch (e:Error) {
                return;
            }
            CRMtool.openView(lockWindow);
            //lockWindow.username.setFocus();
            lockWindow.userpwd.setFocus();
        }
    }
}

//显示或隐藏 浮动窗口
[Embed(source="/yssoft/assets/images/radio_up.png")]
private var downpng:Class;
private function showFloatMsgHandler():void {

    if (this.floatMsgWindow.visible == false) {
        this.floatMsgWindow.getMsgItems(true);
        this.floatMsgWindow.visible = true;
    }
}

// 快捷键 打开 锁屏窗口

private function fastOpenLockedWindow(event:KeyboardEvent):void {
    //Alert.show(""+event.keyCode);
    if (event.shiftKey && event.ctrlKey && event.keyCode == 77) { // shift + ctrl +  (M)
        if (!CRMmodel.isLocked) { // 防止多次打开 这个窗口
            CRMmodel.isLocked = true;
            if (lockWindow == null) {
                lockWindow = new LockWindow();
            }
            CRMtool.openView(lockWindow);
            lockWindow.userpwd.setFocus();
        }
    }
}

//检测加密狗 

private function checkKey():void {
    if (CRMmodel.hrperson.busbkey) { //当前登录账号 是否绑定了 加密锁
        startCheckKey();
    }
}
private function startCheckKey():void {
    var _keytime:Timer = new Timer(5000);
    _keytime.addEventListener(TimerEvent.TIMER, onKeyTimer);
    _keytime.stop();
    _keytime.start();
}
private var keyWindow:KeyWindow = null;
private function onKeyTimer(event:TimerEvent):void {
    var ret:String = CRMtool.calljs("checkUSBDog");
    if (ret == "false" || ret.indexOf("错误") > -1) {
        openKeyWindow();
    } else {
        var dog_id:String = ret.split("|")[0] as String;
        var softname:String = ret.split("|")[1] as String;
        var cusbkey:String = CRMmodel.hrperson.cusbkey as String;

        if (softname.indexOf("eap") == -1 || dog_id.toLocaleUpperCase() != cusbkey.toLocaleUpperCase()) {
            openKeyWindow();
        } else {
            closeKeyWindow();
        }
//        if (ret.toLowerCase() == String(CRMmodel.hrperson.keyid + ":" + CRMmodel.userId).toLowerCase()) {
//            closeKeyWindow();
//        } else {
//            openKeyWindow();
//        }

    }
}

// 
private function openKeyWindow():void {
    if (CRMmodel.isKeyWindow == false) {
        CRMmodel.isKeyWindow = true;
        if (keyWindow == null) {
            keyWindow = new KeyWindow();
            keyWindow.owner = this;
            CRMtool.openView(keyWindow);
        }
    }
}
//

private function closeKeyWindow():void {
    if (keyWindow) {
        keyWindow.myclose();
        keyWindow = null;
    }
}

private var xzgap:int = 85; //修正间隔
private var oldclbwidth:int = 0; //在出现左右导航条是，记录其宽度
//  修正 linkbar 中条目多 移出的 bug
private function lb_datachange(type:String):void {
    var index:int = crmLinkBar.selectedIndex;
    var itemNum:int = this.crmLinkBar.numChildren; // 子节点个数
    var clbwidth:int = crmLinkBar.width;//组件的宽度
    var clbcwidth:int = crmlinkbarcontent.width; //容器的宽度
    var clbleft:int = 0;	//左移 偏移量

    if (clbwidth + 72 > clbcwidth) {
        if (type == "add") {//新增
            this.linkbarnav.visible = true;
            this.crmLinkBar.left = -(clbwidth + 72 - clbcwidth) - 20;
            oldclbwidth = clbwidth;
        } else {//删除
            var left:Number = this.crmLinkBar.left + Math.abs(oldclbwidth - this.crmLinkBar.width);
            if (left < 0) {
                oldclbwidth = clbwidth;
                this.crmLinkBar.left = left;
            } else {
                linkbardefault(type);
            }
        }
    } else {
        linkbardefault(type);
    }
}

private function linkbardefault(type:String):void {
    linkbarnav.visible = false;
    crmLinkBar.left = 0;
    oldclbwidth = 0;
}
//左右导航条

private function rightNav():void {
    var index:int = this.crmLinkBar.selectedIndex;
    var itemNum:int = this.crmLinkBar.numChildren; // 子节点个数
    var clbcwidth:int = crmlinkbarcontent.width; //容器的宽度
    var clbwidth:int = crmLinkBar.width;//组件的宽度
    if (this.linkbarnav.visible) {// 出现左右导航条
        if (index < itemNum - 1) {
            /*            if (clbwidth+72 > clbcwidth) {
             this.crmLinkBar.left = Number(this.crmLinkBar.left) - crmLinkBar.getChildAt(itemNum-1).width; // 后期修改  --------->>>> 最后一个组件的长度 来设定的
             }*/
            selectLVchild(index + 1);
        }
    }

}

private function leftNav():void {
    var index:int = this.crmLinkBar.selectedIndex;
    var itemNum:int = this.crmLinkBar.numChildren; // 子节点个数

    if (this.linkbarnav.visible) {// 出现左右导航条
        if (index - 1 > 0) {

            /*            if (this.crmLinkBar.left < 0) {
             var left:Number = Number(this.crmLinkBar.left) + crmLinkBar.getChildAt(itemNum-1).width -20;
             if(left<0)
             this.crmLinkBar.left = left;
             else
             this.crmLinkBar.left = 0;
             }*/
            selectLVchild(index - 1);
        }
    }
}


private function selectLVchild(index:int = 0):void {
    this.crmLinkBar.selectedIndex = index;
    calculateLinkBarUI(index);

    this.mainViewStack.selectedIndex = index;
}

private function calculateLinkBarUI(index:int = 0) {
    var button:Button = this.crmLinkBar.getChildAt(index) as Button;

    if (button.x + crmLinkBar.left < 0) {
        crmLinkBar.left = 0;
    } else if (button.x + button.width + crmLinkBar.x > crmlinkbarcontent.width) {
        crmLinkBar.left = -(button.x + button.width - crmlinkbarcontent.width);
    }
}

//lr add  穿透搜索
protected function _newTextInput_searchHandler(event:Event):void {
    var callhot:Object = mainViewStack.selectedChild as Object;
    var selectBox:IMainViewStackSearch = mainViewStack.selectedChild as IMainViewStackSearch;
    if (selectBox) {
        selectBox.searchFromMain(StringUtil.trim(newTextInput.text));
    }else if(callhot.hasOwnProperty("callNum")){
        selectBox = new CallCenterCore() as IMainViewStackSearch;//{yssoft.views.callcenter::CallCenterCore};
        selectBox.searchFromMain(StringUtil.trim(newTextInput.text));
    }else {
        basicSearchHandler();
    }

}

//全局搜索
protected function basicSearchHandler():void {
    if (CRMtool.isStringNotNull(this.newTextInput.text)) {
        content.visible = true;
        this.content.width = 300;
        this.content.height = mainViewStack.height - 5;
        this.content.x = (newTextInput.x) + newTextInput.width - this.content.width;
        this.content.y = (newTextInput.y + newTextInput.height) + 54;
        var params:Object = new Object();
        params.iperson = CRMmodel.userId;
        params.ccondit = StringUtil.trim(this.newTextInput.text);
        AccessUtil.remoteCallJava("hrPersonDest", "applictionSearch", searchResult, params);
    }
}

//本地datagrid搜索
protected function localSearchHandler():void {
    if (mainViewStack.getChildAt(mainViewStack.selectedIndex) is FrameworkVBoxView) {//列表
        this.content.visible = false;
        var mainViewStackItem:FrameworkVBoxView = mainViewStack.getChildAt(mainViewStack.selectedIndex) as FrameworkVBoxView;

        mainViewStackItem.tnp_bjobstatus.text = StringUtil.trim(this.newTextInput.text);
        mainViewStackItem.localSearchDataGrid();
    }
}

[Bindable]
private var arrSearch:ArrayCollection = null;
private function searchResult(e:ResultEvent):void {
    arrSearch = e.result as ArrayCollection;
    //排序以便分类
    var sort:Sort = new Sort();
    sort.fields = [new SortField("ctype")];
    arrSearch.sort = sort;
    arrSearch.refresh();

    var arr:Array = new Array(4);
    for (var i:int = 0; i < arr.length; i++) {
        arr[i] = new Array();
    }
    var countNum:int = 0;//记录总共有多少类
    this.content.removeAllElements();
    if (arrSearch.length > 0) {
        arr[0].push(arrSearch[0]);
        for (var i:int = 1; i < arrSearch.length; i++) {
            if (arrSearch[i].ctype == arrSearch[i - 1].ctype) {
                arr[countNum].push(arrSearch[i]);
            } else {
                countNum++;
                arr[countNum].push(arrSearch[i]);
            }
        }
        this.content.removeAllElements();
        //存放linkbutton
        var arrlbn:ArrayCollection = new ArrayCollection();
        //存放list
        var arrlist:ArrayCollection = new ArrayCollection();
        for (var i:int = 0; i <= countNum; i++) {
            arrlbn.addItemAt(new LinkButton(), i);
            arrlbn[i].label = arr[i][0].ctype + "(" + arr[i].length + ")";
            arrlbn[i].id = "lbn" + i;
            arrlbn[i].setStyle("fontSize", 13);
            arrlbn[i].setStyle("fontWeight", "bold");

            var arrC:ArrayCollection = new ArrayCollection(arr[i]);
            arrlist.addItemAt(new List(), i);
            arrlist[i].id = "list" + i;
            arrlist[i].dataProvider = arrC;
            arrlist[i].labelField = "cname";
            arrlist[i].verticalScrollPolicy = "off";
            arrlist[i].horizontalScrollPolicy = "off";
            arrlist[i].rowCount = arrC.length;
            arrlist[i].setStyle("borderVisible", false);
            arrlist[i].setStyle("paddingLeft", 20);
            //arrlist[i].itemRenderer = new ClassFactory(mx.controls.Label);

            (arrlbn[i] as LinkButton).addEventListener(MouseEvent.CLICK, function (event:MouseEvent):void {
                var param:Object = event.currentTarget;
                var index:int = int(Number((param.id).substring(param.id.length - 1, param.id.length)));
                var childIndex:int = 0;
                if (content.contains(arrlist[index])) {
                    childIndex = content.getChildIndex(arrlist[index]);
                } else {
                    childIndex = content.getChildIndex(arrlbn[index]) + 1;
                }
                if (content.contains(arrlist[index])) {
                    content.removeChildAt(childIndex);
                } else {
                    content.addElementAt(arrlist[index], childIndex);
                }
            });

            (arrlist[i] as List).addEventListener(ListEvent.ITEM_CLICK, function (event:ListEvent):void {
                var param:Object = event.currentTarget.selectedItem;
                var ifuncregedit = param.ifuncregedit;
                var sql:String = "select * from as_funcregedit where iid=" + ifuncregedit;
                var iid:ArrayCollection = new ArrayCollection();
                iid.addItem({iid: param.iinvoice});

                AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
                    var ac:ArrayCollection = event.result as ArrayCollection;
                    if (ac && ac.length > 0) {
                        var param:Object = ac[0];
                        param.operId = "onListDouble";
                        param.formTriggerType = "fromList";
                        param.outifuncregedit = ifuncregedit;
                        param.ifuncregedit = ifuncregedit;
                        param.personArr = iid;
                        param.itemType = "onBrowse";

                        CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param);
                        content.height = 0;
                        content.width = 0;
                        content.visible = false;
                    }
                }, sql, null, false);
            });

            this.content.addElement(arrlbn[i]);
            this.content.addElement(arrlist[i]);
        }
    }
}


protected function newTextInput_mouseDownHandler(e:MouseEvent):void {
    if (e.currentTarget.id != newTextInput || e.currentTarget.id != content) {
        this.content.visible = false;
    }
}

public function dglist1_itemClickHandler(event:Event):void {
    var param:Object = arrSearch.getItemAt((event as ListEvent).rowIndex);

    param.operId = "onListDouble";
    param.formTriggerType = "fromList";
    param.outifuncregedit = param.ifuncregedit;
    param.ifuncregedit = param.ifuncregedit;
    var iid:ArrayCollection = new ArrayCollection();
    iid.addItem({iid: param.iinvoice});
    param.personArr = iid;

    param.itemType = "onBrowse";
    CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, param.cname, param.ifuncregedit + "" + param.iinvoice);
    this.content.height = 0;
    this.content.width = 0;
    this.content.visible = false;

}


protected function appliction_clickSearch(event:Event):void {
    if (this.content.visible) {
        var qd_x:Number = this.newTextInput.x;
        var wh_x:Number = this.newTextInput.x + this.newTextInput.width;

        var qd_y:Number = this.newTextInput.y;
        var wh_y:Number = this.newTextInput.y + this.newTextInput.height + this.content.height;

        var x:Number = (event as MouseEvent).stageX;
        var y:Number = (event as MouseEvent).stageY;

        var ctnt_qd_x:Number = this.content.x;
        var ctnt_wh_x:Number = this.content.x + this.content.width;

        var ctnt_qd_y:Number = this.content.y;
        var ctnt_wh_y:Number = this.content.y + this.content.height;
//		if(event.target.parent.id == "content"){
//			x += (this.content.width - this.newTextInput.width);
//		}else{
//			x = (event as MouseEvent).stageX;
//		}

        if (x > qd_x && x < wh_x && qd_y < y && wh_y > y) {
            return;
        } else {
            //鼠标点在content内，不关闭content
            if (x > ctnt_qd_x && x < ctnt_wh_x && ctnt_qd_y < y && ctnt_wh_y > y) {
                return;
            } else {
                this.content.height = 0;
                this.content.width = 0;
                this.content.visible = false;
            }
        }
    }
}

