/**
 * @auth zmm
 * @date 2011-07-28
 * @destination crm单列类，统一控制各种资源
 *
 */
package yssoft.models {
import flash.net.Socket;

import mx.collections.ArrayCollection;
import mx.containers.ViewStack;
import mx.controls.LinkBar;
import mx.core.Application;

import spark.components.Application;

import yssoft.comps.CRMLinkBar;

import yssoft.errors.CRMerror;
import yssoft.views.LoadingView;
import yssoft.views.MainView;
import yssoft.vos.HrPersonVo;

[Bindable]
public class CRMmodel {
    private static var instance:CRMmodel;
    public static var basicFormGroupHeight:int = 33.4;
    public static var tableRelation:ArrayCollection;
    public static var mainView:MainView = null;
    public static var alertShadowMargin:int = 6;
    public static var statusList:ArrayCollection;
    [Bindable]
    public static var basicColorArray:Array = [0xe1e1e1, 0xdadada];
    public static var listSelectionColor:uint = 0xfff3c1;
    public static var listRollOverColor:uint = 0xd3e9ff;

    //缓存数据
    public static var dataAuthList:ArrayCollection = new ArrayCollection();
    public static var operAuthList:ArrayCollection = new ArrayCollection();
    public static var formUIList:ArrayCollection =  new ArrayCollection();
    public static var listSetList:ArrayCollection = new ArrayCollection();
    public static var billMoreButtonList:ArrayCollection = new ArrayCollection();
    public static var fcrelationList:ArrayCollection = new ArrayCollection();
    public static var authcontentList:ArrayCollection = new ArrayCollection();
    public static var mainSearchTextInput;

    public function CRMmodel() {
        if (instance != null) {
            throw new CRMerror("单列模式，不能被多次创建。");
        }
        CRMmodel.instance = this;
    }

    public static function getInstance():CRMmodel {
        if (instance == null) {
            instance = new CRMmodel();
        }

        return instance;
    }
	
	//是否回写合同成本
	[Bindable]
	public static var IsRebackToContCost:int = 0;
	
    //当前的索引号
    public static var screenIndex:int = 0;

    public static var authorizedUsersNum:int = 0;

    //当前登录用户id
    public static var userId:int = 0;

    //加密狗
    public static var rpwd:String = "r1985";
    //在线消息 窗口是否已经显示
    public static var isShowMsg:Boolean = false;
    // 是否已经锁屏了
    public static var isLocked:Boolean = false;
    // 加密锁提示窗口 是不是 已经显示
    public static var isKeyWindow:Boolean = false;

    //缓存接受的消息
    public static var hcMsgItems:ArrayCollection = new ArrayCollection();
    //创建的消息窗体
    public static var MsgItemAc:ArrayCollection = new ArrayCollection();
    //待办事项的个数
    [Bindable]
    public static var dbsx_count:int = 0;


    //当前登录人的直接领导 lr  add
    [Bindable]
    public static var isuper:int = 0;


    //lr add 与服务器连接是否正常。
    public static var connOK:Boolean = true;
    //lr add flex主页
    public static var indexApp:spark.components.Application = null;

    //系统用户列表
    public static var personlist:ArrayCollection;
    public static var personslist:ArrayCollection;

    //系统部门列表
    public static var departmentlist:ArrayCollection;

    public static var funcregeditList:ArrayCollection;

    //计划使用，查询年份上下偏移量
    public static var maxYear:int = new Date().fullYear + 5;
    public static var minYear:int = new Date().fullYear - 5;

    //在线人数
    [Bindable]
    public static var online_count:int = 0;

    //系统消息
    [Bindable]
    public static var msg_count:int = 0;

    //tomcat的URL路径
    public static var tomcatURLStr:String = "";

    //计划数量
    [Bindable]
    public static var jhtx_count:int = 0;

    //是否注销
    public static var isLogout:Boolean = false;
    //当前登录用户的引用
    [Bindable]
    public static var hrperson:HrPersonVo = new HrPersonVo();

    //最后一次登录时间地点
    public static var lasttime:String = "";
    public static var lastaddress:String = "";

    //当前已启用人员总数
    public static var personCount:int = 0;

    //当前登录用户头像的引用
    [Bindable]
    public static var headerIcon:Object = ConstsModel.wf_inodetype_0;
    //当前登录用户的权限菜单引用
    public static var authMenu:XML = new XML();

    //当前登录用户的权限菜单引用list
    public static var authMenuList:ArrayCollection;

    //系统配置list lradd
    public static var optionAc:ArrayCollection;


    //viewstact 引用
    [Bindable]
    public static var mainViewStack:ViewStack;
    // linkbar 引用
    [Bindable]
    public static var crmLinkBar:CRMLinkBar;


    // 过渡窗口的引用
    public static var loadingView:LoadingView = new LoadingView();
    //菜单图标 集合

    public static var menuArray:ArrayCollection = new ArrayCollection([
        {label: "菜单图标1", value: "1", cls: ConstsModel.png_menu1},
        {label: "菜单图标2", value: "2", cls: ConstsModel.png_menu2},
        {label: "菜单图标3", value: "3", cls: ConstsModel.png_menu3},
        {label: "菜单图标4", value: "4", cls: ConstsModel.png_menu4}
    ]);


    //crm 所有打开 的窗口的 集合 array
    public static var CRMLayoutManagers:Array = new Array();

    // 工作流绘制过程中，缓存 已经下载的 用户头像,格式为 (userid:1,headericon:class)
    public static var CRMUserHeaderManagers:Array = new Array();

    public static var roleXml:XML = <node>
        <node iid="2" cname="部门主管" cmemo="发起人员部门主管"/>
        <node iid="3" cname="分管主管" cmemo="发起人员分管主管"/>
        <node iid="4" cname="分管领导" cmemo="发起人员分管领导"/>
        <node iid="1" cname="发起人员" cmemo="发起人"/>
        <node iid="5" cname="全部人员" cmemo="全部人员"/>
    </node>;
    /*
     *wxh add
     *工程模式：在全局所搜中输入对应的命令可以查看系统错误
     */
    public static var isCrmProgramMode:Boolean = true;
    public static const programModeKeyword:String = "*#06#";

    public static var cc_allowcount:int = 0; //呼叫中心许可数

    public static var icallline:int = 0; //热线线路

    public static var modelSocket:Socket = null;     //与呼叫中心服务连接

    public static var bcallout:Boolean = false;     //外呼是否弹屏

    public static var bisCloseOut:Boolean = false; //热线处理后是否关闭弹出卡片

    public static var ilayout:int = 0;   //坐席排列布局

    public static var imobilecount:int = 0;  //手机端许可数
	
}


}