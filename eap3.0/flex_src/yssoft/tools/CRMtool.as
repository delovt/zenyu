/**
 * 作者:朱毛毛
 * 日期:2011年07月30日
 * 功能:系统工具类
 */
package yssoft.tools {
import flash.display.BitmapData;
import flash.display.DisplayObject;
import flash.display.Sprite;
import flash.events.Event;
import flash.events.KeyboardEvent;
import flash.external.ExternalInterface;
import flash.geom.Matrix;
import flash.geom.Rectangle;
import flash.net.URLRequest;
import flash.net.navigateToURL;
import flash.system.IME;
import flash.ui.Keyboard;
import flash.utils.ByteArray;
import flash.utils.Dictionary;
import flash.utils.getDefinitionByName;

import mx.collections.ArrayCollection;
import mx.collections.IList;
import mx.containers.Panel;
import mx.containers.ViewStack;
import mx.controls.*;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.core.Container;
import mx.core.FlexGlobals;
import mx.core.IFlexDisplayObject;
import mx.core.INavigatorContent;
import mx.core.UIComponent;
import mx.events.CloseEvent;
import mx.formatters.DateFormatter;
import mx.formatters.NumberBaseRoundType;
import mx.formatters.NumberFormatter;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;
import mx.utils.ObjectUtil;
import mx.utils.StringUtil;

import myreport.data.report.CaptionCellSetting;

import myreport.data.report.CaptionRowSetting;

import myreport.data.report.ReportSettings;
import myreport.data.report.TableCellSetting;
import myreport.data.report.TableColumnSetting;
import myreport.data.report.TableRowSetting;

import spark.components.ComboBox;

import yssoft.comps.CRMLinkBar;
import yssoft.comps.frame.module.CrmEapCheckBox;
import yssoft.comps.frame.module.CrmEapRadianVbox;
import yssoft.comps.myRichTextEditor.MyRichTextEditor;
import yssoft.frameui.formopt.OperDataAuth;
import yssoft.models.CRMmodel;
import yssoft.models.ConstsModel;
import yssoft.views.LoadingView;
import yssoft.views.printreport.PrintParam;
import yssoft.vos.ListsetVo;

public class CRMtool {
    private static const ALERT_PROMPT:String = "提示";
    private static const ALERT_ERROR:String = "错误";
    private static const ALERT_AFFIRM:String = "确认";

    public static var relation:Boolean = false;

    public static var listcolumHNS = false;
    [Embed(source='/yssoft/styles/assets.swf', symbol='prompt_png')]
    public static var ALERT_PNG_PROMPT:Class;

    [Embed(source='/yssoft/styles/assets.swf', symbol='error_png')]
    public static var ALERT_PNG_ERROR:Class;

    [Embed(source='/yssoft/styles/assets.swf', symbol='affirm_png')]
    public static var ALERT_PNG_AFFIRM:Class;

    Alert.yesLabel = "确定";
    Alert.noLabel = "取消";

    /**
     * 统一系统 alert窗口
     *
     * @auth            zmm
     * @date            2011年08月01日
     * @param info         提示信息
     * @param type         提示类型
     * @param focus     销毁窗口后，焦点对象
     * @param p            函数执行对象
     * @param yesFun    确定按钮 执行函数(p 中public 函数)
     * @param noFun        取消按钮 执行函数(p 中public 函数)
     * @param c            弹出框 附属父窗体
     */
        //信息弹出窗口
    public static function showAlert(info:String, focus:Object = null, type:String = "PROMPT", p:Sprite = null, yesFun:String = null, noFun:String = null, c:Sprite = null):void {
        if (c == null) {
            c = FlexGlobals.topLevelApplication as Sprite;
        }
        var flag:uint = Alert.YES;
        if (type == "AFFIRM") {
            flag = Alert.YES | Alert.NO;
        }
        Alert.show(info, CRMtool["ALERT_" + type], flag, c, function (evt:CloseEvent):void {
            if (evt.detail == Alert.YES) {
                if (focus != null) {
                    focus.setFocus();
                }
                if (yesFun && p)p[yesFun]();
            } else {
                if (focus) {
                    focus.setFocus();
                }
                if (noFun && p)p[noFun]();
            }
        }, CRMtool["ALERT_PNG_" + type], Alert.YES);
    }


    /**
     * 打开 指定窗口 （主要是针对PopUpManager）
     * @auth       zmm
     * @date       2011年08月01日
     * @param view 要打开窗口的引用
     * @param p    过渡窗口以p来居中
     * @param flag 是否为模式装填 true 模式 false 非模式
     * @return        void
     */
    public static function openView(view:IFlexDisplayObject, flag:Boolean = true, p:DisplayObject = null, ismodule:Boolean = false):void {
        if (view) {
            if (p == null) {
                if (ismodule) {
                    p = FlexGlobals.topLevelApplication.moduleInstance as DisplayObject;
                } else {
                    p = FlexGlobals.topLevelApplication as DisplayObject;
                }
            }
            PopUpManager.addPopUp(view, p, flag);
            PopUpManager.centerPopUp(view);
            //PopUpManager.bringToFront(view);

            //view.x=(FlexGlobals.topLevelApplication.stage.width-view.width)/2;
            //view.y=(FlexGlobals.topLevelApplication.stage.height-view.height)/2-20;

        }
    }

    /**
     * 关闭 指定窗口 （主要是针对PopUpManager）
     * @auth       zmm
     * @date       2011年08月01日
     * @param view 窗口的引用
     * @return        void
     */
    public static function closeView(view:IFlexDisplayObject):void {
        if (view) {
            PopUpManager.removePopUp(view);
        }
    }

    /**
     * 打开过渡窗口
     * @auth       zmm
     * @date       2011年08月01日
     * @param text 过渡窗口显示信息
     * @param p    过渡窗口以p来居中
     * @return        void
     */
    public static function showLoadingView(text:String = null, p:DisplayObject = null):void {
        if (CRMmodel.loadingView == null) {
            CRMmodel.loadingView = new LoadingView();
        }
        openView(CRMmodel.loadingView, false, p)
        if (text) {
            CRMmodel.loadingView.loadingText = text;
        }
    }

    /**
     * 隐藏 过渡窗口
     * @auth    zmm
     * @date    2011年08月01日
     * @return  void
     */
    public static function hideLoadingView():void {
        if (CRMmodel.loadingView) {
            PopUpManager.removePopUp(CRMmodel.loadingView);
            CRMmodel.loadingView.loadingText = "";
        }
    }

    /**
     * 检查指定字符串是否为空，或null
     * @auth    zmm
     * @date    2011年08月01日
     * @return  boolean
     */
    public static function stringIsNull(str:String):Boolean {
        if (str == null) {
            return false;
        }
        if (StringUtil.trim(str).length == 0) {
            return false;
        }
        return true;
    }

    /**
     * 检查指定字符串是否为空，或null
     * @auth    lr
     * @date    2012年05月31日
     * @return  boolean
     */
    public static function isStringNotNull(str:String):Boolean {
        if (str == null) {
            return false;
        }
        else if (StringUtil.trim(str).length == 0) {
            return false;
        } else if (StringUtil.trim(str) == "null" || StringUtil.trim(str) == "NULL") {
            return false;
        }
        else return true;
    }

    public static function isStringNull(str:String):Boolean {
        if (str == null) {
            return true;
        }
        else if (StringUtil.trim(str).length == 0) {
            return true;
        } else if (StringUtil.trim(str) == "null" || StringUtil.trim(str) == "NULL") {
            return true;
        }
        else return false;
    }

    /**
     * @param info     提示信息
     * @param type     提示类型
     * @param focus     销毁窗口后，焦点对象
     * @param p        函数执行对象
     * @param yesFun    确定按钮 执行函数(p 中public 函数)
     * @param noFun    取消按钮 执行函数(p 中public 函数)
     * @param c        弹出框 附属父窗体
     */
        //信息弹出窗口
    public static function tipAlert(info:String, focus:Object = null, type:String = "PROMPT", p:* = null, yesFun:String = null, noFun:String = null, c:Sprite = null):void {
        if (c == null) {
            c = FlexGlobals.topLevelApplication as Sprite;
        }
        var flag:uint = Alert.YES;
        if (type == "AFFIRM") {
            flag = Alert.YES | Alert.NO;
        } else if (type == "OK") {
            flag = Alert.YES;
        }
        Alert.show(info, CRMtool["ALERT_" + type], flag, c, function (evt:CloseEvent):void {
            if (evt.detail == Alert.YES) {
                if (focus != null) {
                    focus.setFocus();
                }
                if (yesFun && p)p[yesFun]();
            } else {
                if (focus) {
                    focus.setFocus();
                }
                if (noFun && p)p[noFun]();
            }
        }, CRMtool["ALERT_PNG_" + type], Alert.YES);
    }

    public static function tipAlert1(info:String, focus:Object = null, type:String = "PROMPT", yesFun:Function = null, noFun:Function = null, c:Sprite = null):void {
        if (c == null) {
            c = FlexGlobals.topLevelApplication as Sprite;
        }
        var flag:uint = Alert.YES;
        if (type == "AFFIRM") {
            flag = Alert.YES | Alert.NO;
        }
        Alert.show(info, CRMtool["ALERT_" + type], flag, c, function (evt:CloseEvent):void {
            if (evt.detail == Alert.YES) {
                if (focus != null) {
                    focus.setFocus();
                }
                if (yesFun) {
                    yesFun();
                }
            } else {
                if (focus) {
                    focus.setFocus();
                }
                if (noFun) {
                    noFun();
                }
            }
        }, CRMtool["ALERT_PNG_" + type], Alert.YES);
    }

    //*******************************************code by liu lei start*******************************************//
    /**
     *
     * 函数名：containerChildsEnabled
     * 作者：刘磊
     * 日期：2011-08-08
     * 功能：统一设置Container容器内控件enabled属性,仅支持mx和spark DataGrid控件
     * 参数：@container：容器,@enabled：属性值
     * 返回值：void
     * 修改记录：无
     */
    public static function containerChildsEnabled(container:Container, enabled:Boolean):void {
        for each (var arr:UIComponent in container.getChildren()) {
            if (arr is Container) {
                if (arr is MyRichTextEditor) {
                    //(arr as MyRichTextEditor).richEditableText.editable = enabled;
                    //(arr as MyRichTextEditor).toolbar.enabled = enabled;
                    (arr as MyRichTextEditor).richEditableTextEditable = enabled;
                    (arr as MyRichTextEditor).toolbarHBvisible = enabled;
                }
                else if (arr is RichTextEditor) {
                    (arr as RichTextEditor).textArea.editable = enabled;
                    (arr as RichTextEditor).toolbar.enabled = enabled;
                }
                else {
                    containerChildsEnabled(arr as Container, enabled);
                }
            }
            else {
                if (arr is TextInput) {
                    (arr as TextInput).editable = enabled;
                }
                else if (arr is CrmEapCheckBox) {
                    (arr as CrmEapCheckBox).enabled = enabled;
                }
                else {
                    if (arr is TextArea) {
                        (arr as TextArea).editable = enabled;
                    }
                    else {
                        if (arr is DataGrid) {
                            (arr as DataGrid).editable = enabled;
                        }
                        else {
                            if (arr is CrmEapCheckBox) {//修改人：XZQWJ 修改日期：2012-12-29 功能：对“是否关联”复选框进行处理
                                (arr as CrmEapCheckBox).enabled = true;
                            } else {
                                arr.enabled = enabled;
                            }
                        }
                    }
                }
            }
        }
    }

    /**
     *
     * getMaxMinAvg
     * 作者：刘磊
     * 日期：2011-12-18
     * 功能：返回数据集中最大值、最小值或平均值
     * 参数：itype—0：最小值,1：平均值，2：最大值；numbers：数值数组
     * 返回值：Object
     * 修改记录：无
     */
    public static function getMaxMinAvg(itype:int, numbers:Array):String {
        var resultnum:String = "";
        if (numbers.length > 0) {
            numbers.sort(Array.NUMERIC);
            switch (itype) {
                case 0:
                {
                    resultnum = numbers[0].toString();
                    break;
                }
                case 1:
                {
                    var r:int = 0
                    for (var i:int = 0; i < numbers.length; i++) {
                        r += numbers[i];
                    }
                    resultnum = (r / numbers.length).toString();
                    break;
                }
                case 2:
                {
                    resultnum = numbers[numbers.length - 1].toString();
                    break;
                }
            }
        }
        return resultnum;
    }

    /**
     *
     * 函数名：clearContainerChildsText
     * 作者：刘磊
     * 日期：2011-09-04
     * 功能：统一清空Container容器内控件text属性值
     * 参数：@container：容器
     * 返回值：void
     * 修改记录：无
     */
    public static function clearContainerChildsText(container:Container):void {
        for each (var arr:UIComponent in container.getChildren()) {
            if (arr is Container) {
                clearContainerChildsText(arr as Container);
            }
            else {
                if (arr is TextInput) {
                    (arr as TextInput).text = "";
                }
                else {
                    if (arr is TextArea) {
                        (arr as TextArea).text = "";
                    }
                    else {
                        if (arr is CheckBox) {
                            (arr as CheckBox).selected = false;
                        }
                        else {
                            if (arr is RadioButton) {
                                (arr as RadioButton).selected = false;
                                (arr as RadioButton).value = null;
                            }
                            else {
                                if (arr is DateField) {
                                    (arr as DateField).text = "";
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    /**
     *
     * 函数名：toolButtonsEnabled
     * 作者：刘磊
     * 日期：2011-08-17
     * 功能：按钮互斥(增加、删除、修改、保存、放弃、更新)
     * 工具栏dataProvider属性必须绑定以下变量
     *         [Bindable]
     *        private var lbrItem:ArrayCollection=new ArrayCollection([
     *        {label:"增加",name:"onNew"},
     *        {label:"删除",name:"onDelete"},
     *        {label:"修改",name:"onEdit"},
     *        {label:"保存",name:"onSave"},
     *        {label:"放弃",name:"onGiveUp"},
     *      {label:"更新",name:"onRefresh"}
     *        ]);
     * 参数：@toolbar：工具栏,@selectedName：点击按钮name,初始状态=null
     * 返回值：void
     * 修改记录：无
     */
    public static function toolButtonsEnabled(toolbar:ButtonBar, selectedName:String, length:int = 1):void {
        //按钮状态互斥
        if (selectedName != "onDelete") {
            var enabled:Boolean = (selectedName == "onSave" || selectedName == "onGiveUp" || selectedName == "onUpdate" || selectedName == null);
            for (var j:int = 0; j < toolbar.numChildren; j++) {
                var label:String = (toolbar.getChildAt(j) as Button).label;
                if (length == 0 && (label == "删除" || label == "修改")) {
                    (toolbar.getChildAt(j) as Button).enabled = false;
                }
                else if (label == "增行" || label == "增加" || label == "删行" || label == "删除" || label == "修改" || label == "写入" || label == "同步") {
                    (toolbar.getChildAt(j) as Button).enabled = enabled;
                }
                else if (label == "保存" || label == "放弃" || label == "更新" || label == "重置" || label == "测试") {
                    (toolbar.getChildAt(j) as Button).enabled = !enabled;
                }

            }
        }
    }

    /**
     *
     * 函数名：setTabIndex
     * 作者：刘磊
     * 日期：2011-08-10
     * 功能：容器内可编辑控件Enter键替换Tab键功能,仅支持mx控件
     * 参数：@container：容器
     * 返回值：void
     * 修改记录：无
     */
    private static var index:Number = 0;
    private static var uicomp:ArrayCollection = new ArrayCollection();

    public static function setTabIndex(container:Container):void {
        //index = 0;
        //uicomp.removeAll();
        setUITabIndex(container);
    }

    private static function setUITabIndex(container:Container):void {
        for each (var arr:UIComponent in container.getChildren()) {
            if (arr is Container) {
                setUITabIndex(arr as Container);
            }
            else {
                if (arr is TextInput
                        || arr is ComboBase
                        || arr is DateField
                        || arr is TextArea
                        || arr is spark.components.ComboBox
                        || arr is NumericStepper
                        || arr is CheckBox) {//修改人：XZQWJ 修改日期：2012-12-29 功能：对“是否关联”复选框进行处理
                    uicomp.addItemAt(arr, index);
                    (arr as UIComponent).tabIndex = index++;
                    arr.addEventListener(KeyboardEvent.KEY_DOWN, changeEnterToTab);
                }
            }
        }
    }

    private static function changeEnterToTab(event:KeyboardEvent):void {
        var ui:UIComponent = (event.currentTarget as UIComponent);
        var nextui:UIComponent;
        if (ui.tabIndex < uicomp.length - 1) {
            nextui = (uicomp.getItemAt(ui.tabIndex + 1) as UIComponent);
        }
        else {
            nextui = (uicomp.getItemAt(0) as UIComponent);
        }

        /*        if(event.keyCode == Keyboard.TAB){
         ui.setFocus();
         return;
         }*/

        if (event.keyCode == Keyboard.ENTER) {

            //lr add
            if (ui.className == "CrmEapTextArea" || ui is TextArea) {
                return;
            }
            //zmm 添加，过滤 RichTextEditor
            if (ui.id == "textArea" && ui.parent is Panel) {
                return;
            }
            nextui.setFocus();
        }
    }

    /**
     *
     * 函数名：rowMoveEndUp
     * 作者：刘磊
     * 日期：2011-08-19
     * 功能：选中表格行置顶
     * 参数：@datagrid：mx.controls.DataGrid,@sortname:排序字段名
     * 返回值：void
     * 修改记录：无
     */
    public static function rowMoveEndUp(datagrid:DataGrid, sortname:String):void {
        var i:int = datagrid.selectedIndex;
        if (i >= 1 && datagrid.selectedItem) {
            for (var j:int = 0; j < i; j++) {
                IList(datagrid.dataProvider).getItemAt(j)[sortname] += 1;
            }
            datagrid.selectedItem[sortname] = 1;
            IList(datagrid.dataProvider).addItemAt(datagrid.selectedItem, 0);
            IList(datagrid.dataProvider).removeItemAt(i + 1);
            datagrid.selectedIndex = 1;
            datagrid.scrollToIndex(datagrid.selectedIndex);
        }
    }

    /**
     *
     * 函数名：rowMoveDown
     * 作者：刘磊
     * 日期：2011-08-19
     * 功能：选中表格行下移
     * 参数：@datagrid：mx.controls.DataGrid,@sortname:排序字段名
     * 返回值：void
     * 修改记录：无
     */
    public static function rowMoveDown(datagrid:DataGrid, sortname:String):void {
        var i:int = datagrid.selectedIndex;
        if (i < (ArrayCollection(datagrid.dataProvider).length - 1) && datagrid.selectedItem) {
            IList(datagrid.dataProvider).getItemAt(i + 1)[sortname] -= 1;
            datagrid.selectedItem[sortname] += 1;
            IList(datagrid.dataProvider).addItemAt(datagrid.selectedItem, i + 2);
            IList(datagrid.dataProvider).removeItemAt(i);
            datagrid.selectedIndex = i;
            var datgDa:ArrayCollection = datagrid.dataProvider as ArrayCollection;
            if (i < datgDa.length) {
                datagrid.scrollToIndex(i + 2);
            }
        }
    }

    /**
     *
     * 函数名：rowMoveEndDown
     * 作者：刘磊
     * 日期：2011-08-19
     * 功能：选中表格行置底
     * 参数：@datagrid：mx.controls.DataGrid,@sortname:排序字段名
     * 返回值：void
     * 修改记录：无
     */
    public static function rowMoveEndDown(datagrid:DataGrid, sortname:String):void {
        var i:int = datagrid.selectedIndex;
        if (i < (ArrayCollection(datagrid.dataProvider).length - 1) && datagrid.selectedItem) {
            for (var j:int = i; j < (ArrayCollection(datagrid.dataProvider).length); j++) {
                IList(datagrid.dataProvider).getItemAt(j)[sortname] -= 1;
            }
            datagrid.selectedItem[sortname] = (ArrayCollection(datagrid.dataProvider).length);
            IList(datagrid.dataProvider).addItemAt(datagrid.selectedItem, (ArrayCollection(datagrid.dataProvider).length));
            IList(datagrid.dataProvider).removeItemAt(i);
            datagrid.selectedIndex = datagrid.dataProvider.length - 2;
            datagrid.scrollToIndex(datagrid.selectedIndex);
        }
    }


    /**
     *
     * 函数名：rowMoveUp
     * 作者：刘磊
     * 日期：2011-08-19
     * 功能：选中表格行上移
     * 参数：@datagrid：mx.controls.DataGrid,@sortname:排序字段名
     * 返回值：void
     * 修改记录：无
     */
    public static function rowMoveUp(datagrid:DataGrid, sortname:String):void {
        var i:int = datagrid.selectedIndex;
        if (i >= 1 && datagrid.selectedItem) {
            IList(datagrid.dataProvider).getItemAt(i - 1)[sortname] += 1;
            datagrid.selectedItem[sortname] -= 1;
            IList(datagrid.dataProvider).addItemAt(datagrid.selectedItem, i - 1);
            IList(datagrid.dataProvider).removeItemAt(i + 1);
            datagrid.selectedIndex = i;
            if (i == 1) {
                return;
            }
            else {
                datagrid.scrollToIndex(i - 2);
            }
        }
    }

    /**
     *
     * 函数名：dataGridSearchLocate
     * 作者：刘磊
     * 日期：2011-08-19
     * 功能：全表格搜索定位
     * 参数：@datagrid：表格，@findstr：搜索字符串
     * 返回值：void
     * 修改记录：无
     */
    public static function dataGridSearchLocate(datagrid:DataGrid, findstr:String):void {
        var resultArr:ArrayCollection = ArrayCollection(datagrid.dataProvider);
        for (var i:int = datagrid.selectedIndex + 1; i < resultArr.length; i++) {
            for each(var col:DataGridColumn in datagrid.columns) {
                var item:Object = resultArr.getItemAt(i);
                var datastr:String = String(item[col.dataField]);
                if (col.dataField != null && datastr.toLowerCase().indexOf(findstr.toLowerCase()) != -1) {
                    datagrid.selectedItem = item;
                    datagrid.scrollToIndex(i);//将当前行滚动到可视范围内
                    return;
                }
            }
            if ((i + 1) == resultArr.length) {
                datagrid.selectedIndex = -1;
            }
        }
    }

    /**
     *
     * 函数名：getFirstDate
     * 作者：刘磊
     * 日期：2011-09-05
     * 功能：获得月第一天日期
     * 参数：@year：年，@month：月
     * 返回值：Date
     * 修改记录：无
     */
    public static function getFirstDate(year:int, month:int):Date {
        return new Date(year, month - 1, 1);
    }

    /**
     *
     * 函数名：getLastDate
     * 作者：刘磊
     * 日期：2011-09-05
     * 功能：获得月最后一天日期
     * 参数：@year：年，@month：月
     * 返回值：Date
     * 修改记录：无
     */
    public static function getLastDate(year:int, month:int):Date {

        return new Date(year, month, 0);
    }

    /**
     *
     * 函数名：getMonthDays
     * 作者：刘磊
     * 日期：2011-09-15
     * 功能：获得某年某月有多少天
     * 参数：@year：年，@month：月
     * 返回值：int
     * 修改记录：无
     */
    public static function getMonthDays(year:int, month:int):int {
        var arr:Array = convertDateToString(getLastDate(year, month), "YYYY-MM-DD").split("-");
        return int(arr[2]);
    }

    /**
     *
     * 函数名：convertDateToString
     * 作者：刘磊
     * 日期：2011-09-06
     * 功能：日期转字符串
     * 参数：@date：日期，@format：格式
     * 返回值：void
     * 修改记录：无
     */
    public static function convertDateToString(date:Date, format:String):String {
        var dateformat:DateFormatter = new DateFormatter();
        dateformat.formatString = format;
        return dateformat.format(date);
    }

    /**
     *
     * 函数名：openbillonbrowse
     * 作者：刘磊
     * 日期：2012-04-13
     * 功能：从非单据列表中打开公共单据
     * 参数：ifuncregedit:功能内码,iinvoice:单据内码,title:标题
     * 返回值：void
     * 修改记录：无
     */
    public static function openbillonbrowse(ifuncregedit:int, iinvoice:int, title:String = "加载中", ctable:String = ""):void {
        var param:Object = new Object;
        param.operId = "onListDouble";

        param.outifuncregedit = ifuncregedit;
        param.ifuncregedit = null;

        var iid:ArrayCollection = new ArrayCollection();
        iid.addItem({iid: iinvoice});

        param.personArr = iid;

        param.itemType = "onBrowse";

        param.formTriggerType = "fromList";
        CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, title, ifuncregedit + "" + iinvoice);
    }

    public static function isHasAuth(ifuncregedit:int, iinvoice:int):void {
        var auth:OperDataAuth = new OperDataAuth();

        var table:String;
        for each(var item:Object in CRMmodel.funcregeditList) {
            if (item.iid == ifuncregedit)
                table = item.ctable;
        }

        if (CRMtool.isStringNull(table))
            return;

        auth.addEventListener("onGet_FundataauthSucess", function (evt:Event):void {
            var authsql:String = auth.getdataauthcondition("01", ifuncregedit, CRMmodel.userId, CRMmodel.hrperson.idepartment, table, 1);
            var sql:String = "select iid from " + table + " where 1=1 " + authsql;
            AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
                var list:ArrayCollection = event.result as ArrayCollection;
                var flag:Boolean = false;
                for each(var item:Object in list) {
                    if (item.iid == iinvoice) {
                        flag = true;
                    }
                }

                if (flag)
                    CRMtool.openbillonbrowse(ifuncregedit, iinvoice);
                else
                    CRMtool.showAlert("您无浏览此数据的权限。");
            }, sql);
        });
        auth.get_fundataauth({ifuncregedit: ifuncregedit, iperson: CRMmodel.userId});
    }


    /**
     *
     * 函数名：dosqlfields
     * 作者：刘磊
     * 日期：2012-05-22
     * 功能：1、添加原字段数据集中没有的字段且更新数据类型
     2、删除新字段数据集中没有的字段
     * 参数：OldArr:原字段数据集,NewArr:新字段数据集
     * 返回值：void
     * 修改记录：无
     */
    public static function dosqlfields(OldArr:ArrayCollection, NewArr:ArrayCollection):void {
        //1、添加原字段数据集中没有的字段
        for each (var newitem:Object in NewArr) {
            for (var i:int = 0; i < OldArr.length; i++) {
                var oldField:String = OldArr[i].cfield;
                if (oldField.search(".") > -1)
                    oldField = oldField.substring(oldField.indexOf(".") + 1);

                if (newitem.cfield == oldField) {
                    OldArr[i].ifieldtype = newitem.ifieldtype;
                    OldArr.setItemAt(OldArr[i], i);
                    break;
                }
            }
            if (i == OldArr.length) {
                OldArr.addItem(newitem);
            }
        }
        //2、删除新字段数据集中没有的字段
        for (var k:int = 0; k < OldArr.length; k++) {
            for (var j:int = 0; j < NewArr.length; j++) {
                var oldField:String = OldArr[k].cfield;
                if (oldField.search(".") > -1)
                    oldField = oldField.substring(oldField.indexOf(".") + 1);

                if (oldField == NewArr[j].cfield) {
                    break;
                }
            }
            if (j == NewArr.length) {
                OldArr.removeItemAt(OldArr.getItemIndex(OldArr[k]));
                k--;
            }
        }

        // lr add  排序
        var sortArr:ArrayCollection = new ArrayCollection();
        for each(var newitem:Object in NewArr) {
            for each(var olditem:Object in OldArr) {
                if (olditem.cfield.search("." + newitem.cfield) > -1) {
                    sortArr.addItem(olditem);
                } else if (newitem.cfield == olditem.cfield)
                    sortArr.addItem(olditem);
            }
        }
        if (sortArr.length == OldArr.length) {
            OldArr.removeAll();
            OldArr.addAll(sortArr);
        }
    }

    /**
     *
     * 函数名：ObjectCopy
     * 作者：刘磊
     * 日期：2012-05-19
     * 功能：深层复制Object对象
     * 参数：@OldArr：原对象
     * 返回值：新对象
     * 修改记录：无
     */
    public static function ObjectCopy(source:Object):* {
        var myBA:ByteArray = new ByteArray();
        myBA.writeObject(source);
        myBA.position = 0;
        return(myBA.readObject());
    }

    public static function copyArrayCollection(list:ArrayCollection):ArrayCollection {
        return new ArrayCollection(CRMtool.ObjectCopy(list.toArray()));
    }
	/**
	 *
	 * 函数名：clone
	 * 作者：SZC
	 * 功能：克隆
	 */
	public static function clone(source:Object):* {
		var myBA:ByteArray = new ByteArray();
		myBA.writeObject(source);
		myBA.position = 0;
		return(myBA.readObject());
	}
    /**
     *
     * 函数名：GetDataTypeIid
     * 作者：刘磊
     * 日期：2012-05-19
     * 功能：依据元数据类型获得平台类型内码
     * 参数：@OldArr：原对象
     * 返回值：新对象
     * 修改记录：无
     */
    public static function GetDataTypeIid(type:String):int {
        var ifieldtype:int = -1;
        var typeStr:String = "";

        switch (type.toLowerCase()) {
            case "bigint":
            {
                typeStr = "int";
                break;
            }
            case "smallint":
            {
                typeStr = "int";
                break;
            }
            case "int":
            {
                typeStr = "int";
                break;
            }
            case "int identity":
            {
                typeStr = "int";
                break;
            }
            case "bigint identity":
            {
                typeStr = "int";
                break;
            }
            case "smallint identity":
            {
                typeStr = "int";
                break;
            }
            case "nvarchar":
            {
                typeStr = "nvarchar";
                break;
            }
            case "varchar":
            {
                typeStr = "nvarchar";
                break;
            }
            case "smalldatetime":
            {
                typeStr = "datetime";
                break;
            }
            case "datetime":
            {
                typeStr = "datetime";
                break;
            }
            case "bit":
            {
                typeStr = "bit";
                break;
            }
            case "float":
            {
                typeStr = "float";
                break;
            }
            case "money":
            {
                typeStr = "float";
                break;
            }
            case "numeric":
            {
                typeStr = "float";
                break;
            }
            case "text":
            {
                typeStr = "text";
                break;
            }
            case "ntext":
            {
                typeStr = "text";
                break;
            }
        }

        for (var i:int = 0; i < ConstsModel.DATATYPEARR.length; i++) {
            var obj:Object = ConstsModel.DATATYPEARR.getItemAt(i);
            if (obj.ctype == typeStr) {
                ifieldtype = obj.iid;
            }
        }
        return ifieldtype;
    }

    /**
     *
     * 函数名：SetParamValues
     * 作者：刘磊
     * 日期：2012-05-24
     * 功能：打印参数赋值
     * 参数：@rpnames：打印参数名数据,paramvalues多赋值
     * 返回值：新对象
     * 修改记录：无
     */
    public static function SetParamValues(rpnames:Array, paramvalues:Object):ArrayCollection {
        var rpnvalues:ArrayCollection = new ArrayCollection();
		var objindex:Object = new Object();
        if (paramvalues is Array) {
            if (paramvalues.length == 0) {
                return null;
            }
            //为数组赋值
            if (paramvalues.length != rpnames.length) {
                return rpnvalues;
            }
            else {
                var pname:String = "";
				var k:int = 0;
				for(var i:int = 0;i<rpnames.length;i++){
					pname = rpnames[i]+"";
					for(var j:int = 0;j<paramvalues.length;j++){
						objindex = paramvalues[j];
						if(objindex == 1){
							rpnvalues.addItemAt(PrintParam.AddParam(pname, objindex+""), i);
							break;
						}
						else if(objindex != null && objindex != "''" && pname == objindex.cname+""){
							rpnvalues.addItemAt(PrintParam.AddParam(pname, objindex.cvalue), i);
							break;
						}
						else if(objindex == "''")
						{
							rpnvalues.addItemAt(PrintParam.AddParam(pname, "''"), i);
							break;
						}
					}
				}
                return rpnvalues;
            }
        }
        else {
            if (paramvalues == null) {
                return null;
            }
            //为非数组标准类型赋值
            if (1 != rpnames.length) {
                return rpnvalues;
            }
            else {
                var j:int = 0;
                for each (var oname:String in rpnames) {
                    rpnvalues.addItemAt(PrintParam.AddParam(oname, paramvalues.toString()), j);
                    j++;
                }
                return rpnvalues;
            }
        }
    }

    //*******************************************code by liu lei over*******************************************//

    /**
     *
     * 函数名：openMenuItem
     * 作者：zmm
     * 日期：2011-08-09
     * 功能：打开菜单
     * param: nodeXml  菜单xml
     * param: viewStack  菜单对应窗体的显示容器
     * param：linkBar
     * title: 窗体的新名称
     * clzziid: 允许重复创建的的窗体的 唯一标识
     * param:    给窗体传递的参数
     * 返回值：void
     * 修改记录：无
     */
    private static var mainViewStack:ViewStack; // viewstack 引用
    public static var crmLinkBar:CRMLinkBar;		// linkbar 引用
    public static function openMenuItem(nodeXml:XML, param:Object = null, title:String = "", clzzid:String = ""):void {

        if (nodeXml == null) {
            return;
        }

        //lr add   唯一识别码 20120924  每次都打开一个新窗体
        if (nodeXml.@brepeat == "true" && CRMtool.isStringNull(clzzid)) {
            clzzid = new Date().toString();
        }

        if (mainViewStack == null || crmLinkBar == null) {
            mainViewStack = CRMmodel.mainViewStack;
            crmLinkBar = CRMmodel.crmLinkBar;
        }

        if (title == "") {
            title = nodeXml.@cname;
        }

        openMenuItem1(nodeXml, param, title, clzzid);
        return;

        /*        var wyflag:String = nodeXml.@cprogram + nodeXml.@cparameter

         //Alert.show(""+wyflag);

         var brepeat:String = (String(nodeXml.@brepeat) == "true" ? "1" : "0");  // 判断是否允许 重复创建
         var childNum:int = mainViewStack.numChildren;	   // 子节点个数
         var childComp:Object;	// 子节点引用
         if (brepeat == "1") { // 允许重复创建，clzz 中的值 ，存储在 child的 id 中
         for (var i:int = 0; i < childNum; i++) {
         childComp = mainViewStack.getChildAt(i);
         if (childComp.name == String(wyflag) && childComp.id == clzzid) {
         mainViewStack.selectedIndex = i;
         crmLinkBar.selectedIndex = i;
         if (childComp.hasOwnProperty("winParam")) {
         childComp["winParam"] = param;
         }

         if (childComp && childComp.hasOwnProperty("onWindowOpen")) {
         childComp["onWindowOpen"]();
         }

         return;
         }
         }
         } else {
         for (var i:int = 0; i < childNum; i++) {
         childComp = mainViewStack.getChildAt(i);
         if (childComp.name == String(wyflag)) {
         mainViewStack.selectedIndex = i;
         crmLinkBar.selectedIndex = i;
         if (childComp.hasOwnProperty("winParam")) {
         childComp["winParam"] = param;
         }

         if (childComp && childComp.hasOwnProperty("onWindowOpen")) {
         childComp["onWindowOpen"]();
         }

         return;
         }
         }
         }


         var child:Object = CRMtool.getLayoutFromManagerByClzz(nodeXml, brepeat, param);

         if (child == null) {
         return;
         }

         if (title && CRMtool.isStringNotNull(title)) {
         child.label = title;
         child.id = clzzid;
         //nodeXml.@clzzid=clzzid;
         } else {
         child.label = nodeXml.@cname;
         }
         */
        /*			// 添加参数
         if(child.hasOwnProperty("winParam")){
         child["winParam"]=param;
         }*/
        /*
         child.name = wyflag;

         mainViewStack.addChild(child as DisplayObject); // INavigatorContent
         mainViewStack.selectedChild = child as INavigatorContent;*/
    }

    // 删除 当前 选中的 窗体
    public static function removeChildFromViewStack():void {
        mainViewStack.removeChildAt(mainViewStack.selectedIndex);
    }

    public static function setCrmLinkBarLable(obj:Object, title:String):void {

        var flag:Boolean = false;
        for each(var item:Object in mainViewStack.getChildren()) {
            if (item == obj)
                flag = true;
        }

        if (!flag)
            return;

        var index:int = mainViewStack.getChildIndex(obj as DisplayObject);

        //var swapWidth:int = (crmLinkBar.getChildAt(index) as LinkButton).width;
        if (index == -1)
            return;
        (crmLinkBar.getChildAt(index) as LinkButton).toolTip = title;
        if (title.length > 6)
            (crmLinkBar.getChildAt(index) as LinkButton).label = title.substr(0, 6) + "..";
        else
            (crmLinkBar.getChildAt(index) as LinkButton).label = title;
        //(crmLinkBar.getChildAt(index) as LinkButton).width=swapWidth;
    }

    public static function getCrmLinkBarLable(obj:Object):String {

        var flag:Boolean = false;
        for each(var item:Object in mainViewStack.getChildren()) {
            if (item == obj)
                flag = true;
        }

        if (!flag)
            return "";

        var index:int = mainViewStack.getChildIndex(obj as DisplayObject);

        if (index == -1)
            return "";
        return (crmLinkBar.getChildAt(index) as LinkButton).toolTip;
    }


    // 根据 菜单的 clzz 来 获取 对应的xml
    public static function getMenuItemXml(clzz:String, funiid:String = null):XML {
        if (funiid == null || funiid == "") {
            return CRMmodel.authMenu..node.(@cprogram == clzz)[0] as XML;
        } else {
            return CRMmodel.authMenu..node.(@cprogram == clzz && @ifuncregedit == funiid)[0] as XML;
        }
    }

    // 不是从菜单，来打开窗口
    public static function openMenuItemFormOther(clzz:String, param:Object, title:String = "加载中", clzziid:String = "", bshow:int = 1, view:IFlexDisplayObject = null):void {
        //lr 如果不传表名 但是知道功能内码的 自动算出表名
        if (param && !(param is String) && CRMtool.isStringNull(param.ctable) && CRMtool.isStringNotNull(param.ifuncregedit)) {
            for each(var item:Object in CRMmodel.funcregeditList) {
                if (item.iid == param.ifuncregedit) {
                    param.ctable = item.ctable;
                }
            }
        }

        if (bshow == 1) {
            var nodeXml:XML = getMenuItemXml(clzz, (param && param.hasOwnProperty("ifuncregedit") ? param.ifuncregedit : null));
            if (nodeXml == null) {
                var brepeat:String = "0";
                if (param && param.hasOwnProperty("brepeat") && param.brepeat == "1") {
                    brepeat = "true";
                }
                nodeXml = XML("<node cname='" + title + "' cprogram='" + clzz + "' brepeat='" + brepeat + "'/>");
            }

            //lr add
            if (CRMtool.isStringNull(clzziid)) {
                clzziid = new Date().toString();
            }

            openMenuItem(nodeXml, param, title, clzziid);
        } else {
            openView(view);
        }
    }


    /**
     *
     * 函数名：addLayoutToManager
     * 作者：zmm
     * 日期：2011-08-09
     * 功能：crm窗口管理器 管理crm打开的窗口
     * param: clzz  窗口的类路径
     * param: menuItem  窗口对应的菜单
     * param：layout 窗体的引用
     * 返回值：void
     * 修改记录：无
     */
    public static function addLayoutToManager(clzz:String, menuItem:XML, layout:UIComponent):UIComponent {
        CRMmodel.CRMLayoutManagers.push({"clzz": clzz, "menuItem": menuItem, "layout": layout});
        return layout;
    }

    //id 唯一标识，wyflag+clzzid
    public static function addLayoutToManager1(id:String, menuItem:XML, layout:UIComponent):UIComponent {
        CRMmodel.CRMLayoutManagers.push({"id": id, "menuItem": menuItem, "layout": layout});
        return layout;
    }

    // 获取 缓存中的 组件
    public static function getLayoutById(id:String):UIComponent {
        var nums:int = CRMmodel.CRMLayoutManagers.length;
        for (var i:int = 0; i < nums; i++) {
            if (CRMmodel.CRMLayoutManagers[i].id == id) {
                return CRMmodel.CRMLayoutManagers[i].layout;
            }
        }
        return null;
    }


    /**
     * 函数名：getLayoutFromManagerByClzz
     * 作者：zmm
     * 日期：2011-08-09
     * 功能：从crm窗口管理器中 找到指定的窗口 通过
     * param: menuItem  窗口对应的菜单
     * 返回值：窗体的引用
     * 修改记录：无
     */
    public static function getLayoutFromManagerByClzz(menuItem:XML, brepeat:String = "", param:Object = null):UIComponent {
        var tpui:UIComponent = null;
        var clzz:String = menuItem.@cprogram + menuItem.@cparameter;
        if (!isStringNotNull(clzz)) {
            return tpui;
        }

        if (brepeat != "1") { // 不允许重复创建
            //先查看 是不是 已经被缓存了
            var nums:int = CRMmodel.CRMLayoutManagers.length;
            for (var i:int = 0; i < nums; i++) {
                if (CRMmodel.CRMLayoutManagers[i].clzz == clzz) {
                    tpui = CRMmodel.CRMLayoutManagers[i].layout;
                    // 缓存后，再次被打开时，执行相关函数
                    /*						if(tpui &&　tpui.hasOwnProperty("onWindowOpen")){
                     tpui["onWindowOpen"]();
                     }*/
                    break;
                }
            }
        }

        if (tpui && tpui.hasOwnProperty("winParam")) {
            tpui["winParam"] = param;
        }
        // 从缓存中 读取
        if (tpui && tpui.hasOwnProperty("onWindowOpen")) {
            tpui["onWindowOpen"]();
        }
        //如果没有被缓存，则被创建与缓存
        if (tpui == null) {
            tpui = createObjectByClassName(clzz) as UIComponent;

            if (tpui && tpui.hasOwnProperty("winParam")) {
                tpui["winParam"] = param;
            }

            if (tpui && brepeat != "1") {// 允许重复创建的 不就添加缓存了
                addLayoutToManager(clzz, menuItem, tpui); // 添加缓存
            }
        }
        return tpui;
    }

    /**
     * 函数名：createClassByName
     * 作者：zmm
     * 日期：2011-08-09
     * 功能：动态创建类
     * param: clzz  窗口的类路径
     * 返回值: 类的实例
     * 修改记录：无
     */
    public static function createObjectByClassName(clzz:String):Object {
        try {
            var clss:Class;
            /*				if(clzz=="yssoft.views.workflow.FreeCoView"){
             return new FreeCoView();
             }else if(clzz == "yssoft.views.workflow.ZFFreeCoView"){
             return new ZFFreeCoView();
             }else{
             clss=SystemModulescls.getObjectByName(clzz) as Class;//getDefinitionByName(clzz) as Class;
             }*/
            clss = getDefinitionByName(clzz) as Class;
            if (clss) {
                return new clss();
            } else {
                return null;
            }
        } catch (e:Error) {
            Alert.show("创建窗口出错:" + e.message);
            return null;
        }
        return null;
    }

    /**
     * 函数名：addUserHeaderIcon
     * 作者：zmm
     * 日期：2011-08-14
     * 功能：添加用户头像
     * param: userId  用户id
     * param: headerIcon 头像图片引用
     * 返回值: void
     * 修改记录：无
     */
    public static function addUserHeaderIcon(userId:int, headerIcon:Object):void {
        CRMmodel.CRMUserHeaderManagers.push({"userId": userId, "headerIcon": headerIcon});
    }

    /**
     * 函数名：getUserHeaderIconById
     * 作者：zmm
     * 日期：2011-08-14
     * 功能：获取用户头像
     * param: userId  用户id
     * 返回值: 如果存在 就返回用户头像的引用， 不存在 就返回null
     * 修改记录：无
     */
    public static function getUserHeaderIconById(userId:int):DisplayObject {
        var tpicon:Object = null;
        var nums:int = CRMmodel.CRMUserHeaderManagers.length;
        for (var i:int = 0; i < nums; i++) {
            if (CRMmodel.CRMUserHeaderManagers[i].userId == userId) {
                tpicon = CRMmodel.CRMUserHeaderManagers[i].headerIcon;
                break;
            }
        }
        if (tpicon == null) {
            tpicon = ConstsModel.wf_inodetype_0;
        }
        return tpicon as DisplayObject;
    }

    /**
     * 函数名：resourceReplace
     * 作者：zmm
     * 日期：2011-08-19
     * 功能：更改提示信息
     * param: str 信息原文本
     * param: ...rest 要替代的文本
     * 返回值: 替代后 文本
     * 修改记录：无
     */
    public static function resourceReplace(str:String, ...rest):String {
        if (rest) {
            var len:int = rest.length;
            for (var i:int = 0; i < len; i++) {
                var reg:RegExp = new RegExp(i, "g");
                str = str.replace(reg, rest[i]);
            }
        }
        return str;
    }

    /**
     * 函数名称：doKeyDown
     * 函数说明：DataGrid回车事件，在调用回车事件之前DataGrid要处于编辑状态
     * 函数参数：KeyboardEvent，前台无需传入参数
     * 函数返回：void
     *
     * 创建人：YJ
     * 修改人：
     * 创建日期：20110815
     * 修改日期：
     *
     * 调用示例：dglist.addEventListener(KeyboardEvent.KEY_DOWN,CRMtool.doKeyDown);//调用回车事件
     */
    public static function doKeyDown(event:KeyboardEvent):void {  //回车事件

        try {
            var obj:Object = event.currentTarget;
            var index:Object = obj.editedItemPosition;
            //enter
            /*if(event.keyCode == Keyboard.TAB)
             {
             obj.editedItemPosition=index;
             }*/
            if (event.keyCode == Keyboard.ENTER && index != null) {
                doEnter(obj);
            } else if (event.keyCode == Keyboard.UP
                    || event.keyCode == Keyboard.DOWN
                    || event.keyCode == Keyboard.LEFT
                    || event.keyCode == Keyboard.RIGHT) {
                doDirection(obj, event.keyCode);
            }
        }
        catch (e:Error) {
        }
    }

    public static function doEnter(obj:Object):void {
        var counter:int = 0;
        var array:Array = obj.columns;
        var index:Object;
        if (obj.editedItemPosition) {
            index = obj.editedItemPosition;
        }
        else {
            if (obj.hasOwnProperty("curItemPosition") && obj.curItemPosition != null) {
                index = obj.curItemPosition;
            }
            else {
                return;
            }
        }

        for (var i:int = index.columnIndex + 1; i < array.length; i++) {
            if (array[i].editable == true)
                break;
            counter++;
        }
        if (index.columnIndex + 1 + counter == array.length) {
            index.rowIndex++;
            index.columnIndex = 0;
            while (true) {
                if (array[index.columnIndex].editable == true)
                    break;
                index.columnIndex++;
            }
            obj.editedItemPosition = index;
        } else {
            index.columnIndex = index.columnIndex + counter + 1;
            obj.editedItemPosition = index;
        }
    }

    public static function doDirection(obj:Object, key:uint):void {
        var index:Object;
        if (obj.editedItemPosition) {
            index = obj.editedItemPosition;
        }
        else {
            if (obj.hasOwnProperty("curItemPosition") && obj.curItemPosition != null) {
                index = obj.curItemPosition;
            }
            else {
                return;
            }
        }

        if (key == Keyboard.UP && index.rowIndex > 0) {
            index.rowIndex--;
        } else if (key == Keyboard.DOWN && index.rowIndex < obj.dataProvider.length - 1) {
            index.rowIndex++;
        }
        obj.editedItemPosition = index;
    }

    /**
     * 函数名：cutRect
     * 作者：zmm
     * 日期：2011-08-19
     * 功能：裁切矩形
     * 返回值: 裁切后的bitmapdata
     * 修改记录：无
     */
    public static function cutRect(target:DisplayObject, x:Number, y:Number, width:Number, height:Number, transparent:Boolean = true, fillColor:uint = 0x00000000):BitmapData {
        var m:Matrix = target.transform.matrix;
        m.tx -= target.getBounds(target.parent).x + x;
        m.ty -= target.getBounds(target.parent).y + y;

        var bmpData:BitmapData = new BitmapData(width, height, transparent, fillColor);
        bmpData.draw(target, m);

        return bmpData;
    }

    /**
     * 函数名：cutSuper
     * 作者：zmm
     * 日期：2011-08-19
     * 功能：裁切任意形状
     * 返回值: 裁切后的bitmapdata
     * 修改记录：无
     */

    public static function cutSuper(target:DisplayObject, template:DisplayObject):BitmapData {
        //原图的边界矩形
        var rectTarget:Rectangle = target.transform.pixelBounds;
        //先把原图按原大小截出来
        var targetBitmapData:BitmapData = cutRect(target, 0, 0, rectTarget.width, rectTarget.height, true, 0x00000000);
        //截图的边界矩形
        var rectTemplate:Rectangle = template.transform.pixelBounds;
        //然后把虚框部分的图像的矩形截出来
        var templateBitmapData:BitmapData = cutRect(template, 0, 0, rectTemplate.width, rectTemplate.height, true, 0x00000000);
        //再把虚框部分的图像的矩形中没有框住的部分去除,即把不在虚框部分的像素去除
        //循环虚框部分的图像中每一个像素,如果此像素的颜色值不为0,说明就此像素是有图像的
        for (var pixelY:int = 0; pixelY < rectTemplate.height; pixelY++) {
            for (var pixelX:int = 0; pixelX < rectTemplate.width; pixelX++) {
                if (templateBitmapData.getPixel(pixelX, pixelY) != 0) {
                    //返回一个 ARGB 颜色值
                    var color:uint = targetBitmapData.getPixel32(pixelX + rectTemplate.x - rectTarget.x, pixelY + rectTemplate.y - rectTarget.y);
                    //设置 BitmapData 对象单个像素的颜色和 Alpha 透明度值
                    templateBitmapData.setPixel32(pixelX, pixelY, color);
                }
            }
        }
        return templateBitmapData;
    }

    /**
     * 函数名：getFormatDateString
     * 作者：zmm
     * 日期：2011-08-22
     * 功能：按指定格式 获取时间
     * 参数: fs 格式字符串
     * 参数：date 日期
     * 返回值: 日期格式化 字符串
     * 修改记录：无
     */
    private static var df:DateFormatter = new DateFormatter();
    //YYYY-MM-DD HH:NN:SS
    public static function getFormatDateString(fs:String = "YYYY-MM-DD HH:NN:SS", date:Date = null):String {
        if (date == null) {
            date = new Date();
        }
        df.formatString = fs;
        //lr modify 避免 24:00:00问题
        var ds:String = df.format(date);
        ds = ds.replace(" 24:", " 00:")
        return  ds;
    }

    /**
     * 函数名：getItemIndexFromAC
     * 作者：zmm
     * 日期：2011-08-22
     * 功能：根据指定的 属性和值 ，从指定的ac返回第一此出现的索引
     * 参数: ac 数据集
     * 参数：attr 属性名称
     * 参数: value 属性值
     * 返回值: 日期格式化 字符串
     * 修改记录：无
     */
    public static function getItemIndexFromAC(ac:ArrayCollection, attr:String, value:String):int {
        for each(var item:Object in ac) {
            if (item.hasOwnProperty(attr) && item[attr] == value) {
                return ac.getItemIndex(item);
            }
        }
        return -1;
    }

    /**
     * 清除 js
     */
    public static function clearExt():void {
        CRMtool.calljs("eval(window.onbeforeunload=null)");
        CRMtool.calljs("eval(window.onunload=null)");
    }

    /**
     * 添加 js
     */
    public static function addExt():void {
        CRMtool.calljs("eval(window.onbeforeunload=onbeforeunloadHandler)");
        CRMtool.calljs("eval(window.onunload=onunloadHandler)");
    }


    /********************************** add by zhong_jing begin *****************************************/
        //获得sql_advancedArr 存储的字段的信息，_cfieldArr 全字段信息
    public static function getSql(_advancedArr:ArrayCollection, _cfieldArr:ArrayCollection):Object {
        var cou:int = 0;
        var siz:int = 0;
        var sql:String = "";
        var chinaSql:String = "";

        for each(var advancedobj:Object in _advancedArr) {
            if (CRMtool.isStringNotNull(StringUtil.trim(advancedobj.value))) {
                sql += " " + advancedobj.logic + " ";
                chinaSql += " " + logicFo(advancedobj.logic) + " ";
                if (CRMtool.isStringNotNull(advancedobj.leftParenthesis)) {
                    var leftParenthesisStr:String = advancedobj.leftParenthesis as String;
                    cou += leftParenthesisStr.length;

                    sql += advancedobj.leftParenthesis;
                    chinaSql += advancedobj.leftParenthesis;
                }
                if (advancedobj.idatetype == 0 && advancedobj.ifieldtype == 3) {
                    sql += "convert(varchar(10)," + advancedobj.cfiled + ",120)";
                }
                else {
                    sql += advancedobj.cfiled;
                }
                chinaSql += cfiedFo(advancedobj.cfiled, _cfieldArr);
                sql += " " + advancedobj.condition + " ";
                chinaSql += " " + conditionFo(advancedobj.condition) + " ";
                sql += "'";
                chinaSql += "'";
                if (advancedobj.condition == "like") {

                    sql += "%" + StringUtil.trim(advancedobj.value) + "%";
                    chinaSql += "%" + StringUtil.trim(advancedobj.value) + "%";
                }
                else if (advancedobj.condition != " is null ") {
                    sql += StringUtil.trim(advancedobj.value);
                    chinaSql += StringUtil.trim(advancedobj.value);
                }
                sql += "'";
                chinaSql += "'";
                if (CRMtool.isStringNotNull(advancedobj.rightParenthesis)) {
                    sql += advancedobj.rightParenthesis;
                    chinaSql += advancedobj.rightParenthesis;
                    var rightParenthesis:String = advancedobj.rightParenthesis as String;
                    siz += rightParenthesis.length;
                }
            }
            else if (advancedobj.condition == " is null " || advancedobj.condition == " is not null ") {
                sql += " " + advancedobj.logic + " ";
                chinaSql += " " + logicFo(advancedobj.logic) + " ";
                if (advancedobj.leftParenthesis != " ") {
                    var leftParenthesisStr:String = advancedobj.leftParenthesis as String;
                    cou += leftParenthesisStr.length;

                    sql += advancedobj.leftParenthesis;
                    chinaSql += advancedobj.leftParenthesis;
                }
                sql += advancedobj.cfiled;
                chinaSql += cfiedFo(advancedobj.cfiled, _cfieldArr);
                sql += advancedobj.condition;
                chinaSql += conditionFo(advancedobj.condition);
            }
        }
        if (cou != siz) {
            Alert.show("括号没有相对应！！");
            return null;
        }
        var obj:Object = new Object();
        obj.sql = sql;
        obj.chinaSql = chinaSql;
        return obj;
    }


    public static function logicFo(login:String):String {
        switch (login) {
            case "and":
            {
                return "并且";
                break;
            }
            case "or":
            {
                return "或者";
                break;
            }
            default:
            {
                return "否";
                break;
            }

        }
    }

    public static function cfiedFo(cfied:String, _cfieldArr:ArrayCollection):String {
        var str:String = "";
        for each(var obj:Object in _cfieldArr) {
            if (cfied == obj.cfield) {
                str = obj.ccaption;
                break;
            }
        }
        return str;
    }

    //YJ Modify 20110923
    public static function conditionFo(condition:String):String {
        var return_str:String = "";

        switch (condition) {
            case "like":
            {
                return_str = "相似";
                break;
            }
            case "=":
            {
                return_str = "等于";
                break;
            }
            case ">":
            {
                return_str = "大于";
                break;
            }
            case ">":
            {
                return_str = "大于";
                break;
            }
            case "<":
            {
                return_str = "小于";
                break;
            }
            case ">=":
            {
                return_str = "大于等于";
                break;
            }
            case "<=":
            {
                return_str = "小于等于";
                break;
            }
            case "<>":
            {
                return_str = "不等于";
                break;
            }
            case "!>":
            {
                return_str = "不大于";
                break;
            }
            case "!<":
            {
                return_str = "不小于";
                break;
            }
            case " is null ":
            {
                return_str = "为空";
                break;
            }
            case " is not null ":
            {
                return_str = "不为空";
                break;
            }
            default:
                break;
        }
        return return_str;
    }

    //获得菜单传入参数
    public static function getObject(str:Object, symbol1:String = ",", symbol2:String = ":"):Object {
        if (str is String) {
            var strArr:Array = String(str).split(symbol1);
            var item:Object = new Object();
            for (var i:int = 0; i < strArr.length; i++) {
                var st:String = strArr[i] as String;
                var stArr:Array = st.split(symbol2);
                item[StringUtil.trim(stArr[0].toString())] = StringUtil.trim(stArr[1]);
            }
            return item;
        } else {
            return str;
        }
    }

    /********************************** add by zhong_jing end *****************************************/


        // 菜单打开重新设计

        //private static var mainViewStack:ViewStack; // viewstack 引用
        //private static var crmLinkBar:LinkBar;		// linkbar 引用
        //public static function openMenuItem(nodeXml:XML,param:Object=null,title:String="",clzzid:String=""):void{


    public static function openMenuItem1(nodeXml:XML, param:Object = null, title:String = "", clzzid:String = ""):void {
        var cprogram:String = nodeXml.@cprogram;									//菜单对应的 类路径
        var cparameter:String = nodeXml.@cparameter;								//初始化参数
        var cname:String = nodeXml.@cname;										//菜单的显示名称
        var brepeat:String = (String(nodeXml.@brepeat) == "true" ? "1" : "0");  		// 判断是否允许 重复创建
        var bnumber:String = (String(nodeXml.@bnumber) == "true" ? "1" : "0");  		// 是否参与单据编码管理  YJ Add 2012-04-07

        //var wyflag:String=cprogram+"@@"+cparameter+"@@"+clzzid;				// 将要打开的窗体的 唯一标识
        var wyflag:String = cprogram + "@@" + nodeXml.@iid + "@@" + clzzid + "@@" + title;
        var cindex:int = isOpen(wyflag);											// 判断窗体是不是 已经显示 cindex 不为-1

        var child:Object;

        var mcprogram:String = nodeXml.@mcprogram;
        //lr  不对应功能节点，且外部链接有值
        if (CRMtool.isStringNotNull(mcprogram) && !(nodeXml.@ifuncregedit > 0)) {
            /*if(mcprogram.search("http:")>-1){
             navigateToURL(new URLRequest(mcprogram))
             }else{
             navigateToURL(new URLRequest(mcprogram))
             }*/
            navigateToURL(new URLRequest(mcprogram))
            return;
        }

        //Alert.show("是否可以重复["+brepeat+"]"+wyflag);
        if (cindex == -1) {    // 当前没有显示,-------1 该窗体从未被打开过  2该窗体被打开过，但现在没有显示被缓存了
            child = createShowChild(cprogram, title, cname, wyflag, nodeXml, param);
        } else {
            if (brepeat == "1") { //可以重复创建
                child = createShowChild(cprogram, title, cname, wyflag, nodeXml, param, "1");
            } else { // 直接显示,不调用相关方法
                mainViewStack.selectedIndex = cindex;
                crmLinkBar.selectedIndex = cindex;
                child = mainViewStack.selectedChild;
                //从菜单读出注册表主关联功能，程序对应主数据表 add by zhong_jing
                if (param is XMLList) {
                    var paramObj:String = (param as XMLList).toXMLString();
                    paramObj += ",ifuncregedit:" + nodeXml.@ifuncregedit;
                    paramObj += ",ctable:" + nodeXml.@ctable;
                    paramObj += ",outifuncregedit:" + nodeXml.@outifuncregedit;
                    paramObj += ",title:" + nodeXml.@cname;
                    paramObj += ",outtitle:" + nodeXml.@outtitle;
                    paramObj += ",bnumber:" + nodeXml.@bnumber;
                    paramObj += ",ccaptionfield:" + nodeXml.@ccaptionfield;
                    execFun(child, paramObj);
                }
                else {
                    execFun(child, param);
                }
                if (child.hasOwnProperty("onWindowOpen")) {
                    child["onWindowOpen"]();
                }
            }
        }
    }

    // 创建 并 显示 窗体

    private static function createShowChild(cprogram:String, title:String, cname:String, wyflag:String, nodeXml:XML, param:Object, type:String = "0"):Object {
        var child:Object = CRMtool.getLayoutById(wyflag);// 查看缓存
        if (child == null) { // 1  窗体从未打开过，只赋值
            child = createChildUI(cprogram, title, cname, wyflag); // 新创建
            if (child) {
                mainViewStack.addChild(child as DisplayObject); // INavigatorContent
                mainViewStack.selectedChild = child as INavigatorContent;
                //execFun(child,param);
            }
            if (child) {
                //从菜单读出注册表主关联功能，程序对应主数据表 add by zhong_jing
                if (param is XMLList) {
                    var paramObj:String = (param as XMLList).toXMLString();
                    paramObj += ",ifuncregedit:" + nodeXml.@ifuncregedit;
                    paramObj += ",ctable:" + nodeXml.@ctable;
                    paramObj += ",outifuncregedit:" + nodeXml.@outifuncregedit;
                    paramObj += ",outtitle:" + nodeXml.@outtitle;
                    paramObj += ",title:" + nodeXml.@cname;
                    paramObj += ",bnumber:" + nodeXml.@bnumber;
                    paramObj += ",ccaptionfield:" + nodeXml.@ccaptionfield;
                    execFun(child, paramObj);
                }
                else {
                    execFun(child, param);
                }
                addLayoutToManager1(wyflag, nodeXml, child as UIComponent);
            }
        } else {
            if (child) {
                mainViewStack.addChild(child as DisplayObject); // INavigatorContent
                mainViewStack.selectedChild = child as INavigatorContent;
                //execFun(child,param);
            }
            if (type == "0") {
                //从菜单读出注册表主关联功能，程序对应主数据表 add by zhong_jing
                if (param is XMLList) {
                    var paramObj:String = (param as XMLList).toXMLString();
                    paramObj += ",ifuncregedit:" + nodeXml.@ifuncregedit;
                    paramObj += ",ctable:" + nodeXml.@ctable;
                    paramObj += ",outifuncregedit:" + nodeXml.@outifuncregedit;
                    paramObj += ",title:" + nodeXml.@cname;
                    paramObj += ",outtitle:" + nodeXml.@outtitle;
                    paramObj += ",bnumber:" + nodeXml.@bnumber;
                    paramObj += ",ccaptionfield:" + nodeXml.@ccaptionfield;
                    execFun(child, paramObj);
                }
                else {
                    execFun(child, param);
                }
                if (child.hasOwnProperty("onWindowOpen")) {
                    child["onWindowOpen"]();
                }
            }
        }

        return child;
    }

    //执行窗体的相关方法
    private static function execFun(child:Object, param:Object):void {
        if (child.hasOwnProperty("winParam")) {
            child["winParam"] = param;
        }
    }

    // 根据唯一标识 来查看窗体是不是被显示了
    private static function isOpen(wyflag:String):int {
        var childNum:int = mainViewStack.numChildren;
        for (var i:int = 0; i < childNum; i++) {
            var childComp:Object = mainViewStack.getChildAt(i);
            if (childComp.name == wyflag) {
                return i;
            }
        }
        return -1;
    }

    // 创建 组件
    private static function createChildUI(cprogram:String, title:String = "", cname:String = "", wyflag:String = ""):Object {
        var child:Object = createObjectByClassName(cprogram); //创建组件
        if (child == null) {
            return null;
        }
        if (title != "") {
            child.label = title;
        } else {
            child.label = cname;
        }
        child.name = wyflag;
        return child;
    }

    /***
     *
     * 获得默认值
     */
    public static function getDefaultValue(cnewdefault:String, cnewdefaultfix:String, ceditdefault:String, itemType:String):String {

        switch (itemType) {
            case "new":
            {
                if (CRMtool.isStringNotNull(cnewdefault)) {
                    return cnewdefault;
                }
                else if (CRMtool.isStringNotNull(cnewdefaultfix)) {
                    return cnewdefaultfix;
                }
                else {
                    return "";
                }
                break;
            }
            case "edit":
            {
                if (CRMtool.isStringNotNull(ceditdefault)) {
                    return ceditdefault;
                }
                else {
                    return "";
                }
                break;
            }
        }

        return "";
    }

    /**
     *
     * xml格式转换成对象类型
     */
    public static function xmlToObject(tree:XML):Object {
        var paramobj:Object = new Object();
        var objInfo:Object = ObjectUtil.getClassInfo(tree);
        var fieldName:Array = objInfo["properties"] as Array;
        for each(var q:QName in fieldName) {
            var cfieldName:String = q.localName.replace("@", "");
            var str:String = tree.attribute(cfieldName).toString();
            paramobj[cfieldName] = str;
        }
        return paramobj;
    }

    //判断页面上传过来的字符串的长度
    public static function getStrActualLen(sChars:String):int {
        //lr modify
        //return sChars.replace(/[^\x00-\xff]/g,"xx").length; 
        //return sChars.replace(/[^\x00-\xff]/g, "xx").length;
        return (sChars + "").length * 2;
    }

    public static function defaultValue(str:String):String {
        switch (str) {
            case "登录用户职员ID":
            {
                return CRMmodel.userId + "";
            }
            case "登录用户名":
            {
                return CRMmodel.hrperson.cname;
            }
            case "登录用户职务ID":
            {
                return CRMmodel.hrperson.ipost.toString();
            }
            case "登录用户部门ID":
            {
                return CRMmodel.hrperson.idepartment.toString();
            }
            case "本机当前日期":
            {
                return CRMtool.getFormatDateString("YYYY-MM-DD");
            }
            case "本机当前时间":
            {
                return CRMtool.getFormatDateString();
            }
            case "服务器当前日期":
            {
                return "服务器当前日期";
            }
            case "服务器当前时间":
            {
                return "服务器当前时间";
            }
            default:
            {
                return str;
            }
        }
    }

    //lr add 搜索tree
    public static function searchTreeNode(xmlList:XMLList, find:String):XML {
        var x:XML = <root></root>;
        var hasflag:Boolean = false;
        for (var i:int = 0; i < xmlList.length(); i++) {
            var childXml:XML = xmlList[i];
            var guid1:String = childXml.@ccode;
            var guid2:String = childXml.@cname;
            if ((guid1 != null && guid1.indexOf(find) > -1) || (guid2 != null && guid2.indexOf(find) > -1)) {
                x.appendChild(childXml);
                hasflag = true;
            }
        }
        if (hasflag)
            return x;
        else
            return null;
    }

    //lr add
    public static function verificationItem(textInput:Object):Boolean {
        var bool:Boolean = true;
        if (CRMtool.isStringNull(textInput.text)) {
            bool = false;
            //CRMtool.showAlert(textInput.id+"  必填");
            textInput.setFocus();
        }
        return bool;
    }

    public static function getNowDate():String {
        return getFormatDateString("YYYY-MM-DD", new Date());
    }

    public static function getNowDateHNS():String {
        return getFormatDateString("YYYY-MM-DD HH:NN:SS", new Date());
    }

    public static function formatDate(item:Object, column:DataGridColumn):String {
        var value = item[column.dataField];
        if (value is Date) {
            if ((value as Date).fullYear == 1900)
                return "";

            var df:DateFormatter = new DateFormatter();

            df.formatString = "YYYY-MM-DD";

            var s:String = df.format(value);
            s = s.replace(" 24:", " 00:");
            return  s;
        } else {
            return value;
        }
    }

    public static function formatDateHHNNSS(item:Object, column:DataGridColumn):String {
        var value = item[column.dataField];
        if (value is Date) {
            if ((value as Date).fullYear == 1900)
                return "";

            var df:DateFormatter = new DateFormatter();

            df.formatString = "YYYY-MM-DD HH:NN:SS";

            var s:String = df.format(value);
            s = s.replace(" 24:", " 00:");
            return  s;
        } else {
            return value;
        }
    }


    public static function formatDateNoHNS(date:Date = null):String {
        if (date == null)
            date = new Date();

        return getFormatDateString("YYYY-MM-DD", date);
    }

    public static function formatDateWithHNS(date:Date = null):String {
        if (date == null)
            date = new Date();

        return getFormatDateString("YYYY-MM-DD HH:NN:SS", date);
    }

    public static function formatFloat(item:Object, column:DataGridColumn):String {
        var strdate:String;
        if (item[column.dataField] != null && item[column.dataField] != "" && item[column.dataField] != "0") {
            strdate = item[column.dataField].toString();
            return formatFloatString(strdate);
        }
        else {
            return null;
        }
    }

    public static function formatFloatString(value:*):String {
        var formater:NumberFormatter = new NumberFormatter();
        formater.precision = 2;
        formater.rounding = NumberBaseRoundType.UP;
        formater.decimalSeparatorFrom = ".";
        formater.decimalSeparatorTo = ".";
        formater.useThousandsSeparator = true;
        return formater.format(value + "");
    }

    public static function weekOfYear(xday:Date):Number {

        var day = new Date(xday.fullYear, xday.month, xday.date);
        var startDate = new Date(day.fullYear, 0, 1);
        var diff = day.valueOf() - startDate.valueOf();
        var d = Math.round(diff / 86400000);
        return Math.ceil((d + startDate.getDay() + 1) / 7);
    }

    public static function endDayInWeek(year:int, week:int):Date {
        var startDate = new Date(year, 0, 1);
        var diff = (week * 7 - startDate.getDay() - 1) * 86400000 + startDate.valueOf();
        return new Date(diff);
    }

    public static function firstDayInWeek(year:int, week:int):Date {
        var startDate = new Date(year, 0, 1);
        var diff = ((week - 1) * 7 - startDate.getDay()) * 86400000 + startDate.valueOf();
        return new Date(diff);
    }

    public static function getOptionValue(id:int):String {
        for each(var item:Object in CRMmodel.optionAc) {
            if (item.iid == id) {
                if (isStringNull(item.cvalue))
                    return "";
                else
                    return item.cvalue;
            }
        }

        return null;
    }

    //lr add 过滤替换系统变量
    public static function replaceSystemValues(s:String):String {
        //lr 查询 可输入变量

        //@iperson@杀伤力比较大，建议用@myiid@代替使用 lr
        while (s.search("@iperson@") > -1) {
            s = s.replace("@iperson@", CRMmodel.userId);
        }

        while (s.search("@当前时间@") > -1) {
            s = s.replace("@当前时间@", CRMtool.getFormatDateString("YYYY-MM-DD HH:NN:SS", new Date()));
        }

        while (s.search("@当前日期@") > -1) {
            s = s.replace("@当前日期@", CRMtool.getFormatDateString("YYYY-MM-DD", new Date()));
        }

        var objInfo:Object = ObjectUtil.getClassInfo(CRMmodel.hrperson);
        var fieldName:Array = objInfo["properties"] as Array;
        for each (var q:QName in fieldName) {
            var p:String = "@my" + q.localName + "@";
            while (s.search(p) > -1) {
                s = s.replace(p, CRMmodel.hrperson[q.localName]);
            }
        }
        return s;
    }

    /**
     *
     * 函数名：RandomArray
     * 作者：XZQWJ
     * 日期：2013-01-05
     * 功能：取某个范围里的N个随机数
     * 参数：@min 最小值   @max 最大值  @n 随机数个数
     * 修改记录：无
     */
    public static function RandomArray(min:int, max:int, n:int):Array {
        var my_array:Array = new Array();
        var i:int = 0;
        var tmp:int;
        for (i = 0; i < n; i++) {
            tmp = Math.floor(Math.random() * (max - min + 1)) + min;
            my_array.push(tmp);
        }
        return my_array;
    }

    //lr add 过滤替换 单据 变量
    public static function replaceCrmeapAndSystemValues(s:String, crmeap:CrmEapRadianVbox):String {

        if (isStringNull(s))
            return "";

        if (!crmeap)
            return "";

        var mainValue:Object = crmeap.getValue();

        var objInfo:Object = ObjectUtil.getClassInfo(mainValue);
        var fieldName:Array = objInfo["properties"] as Array;
        for each (var q:QName in fieldName) {
            if (!(mainValue[q.localName] is ArrayCollection)) {
                var p:String = "@" + q.localName + "@";
                while (s.search(p) > -1) {
                    s = s.replace(p, mainValue[q.localName]);
                }
            }
        }

        return replaceSystemValues(s);
    }

    //lr add 针对工作流 过滤替换 操作 变量
    public static function replaceWFtypeValues(s:String, wftype:String):String {

        if (isStringNull(s))
            return "";

        while (s.search("@wftype@") > -1) {
            s = s.replace("@wftype@", wftype);
        }

        return s;
    }

    //lr add 过滤xml合法字符
    public static function replaceToXMLMarkValues(s:String):String {

        if (isStringNull(s))
            return "";

        while (s.search("<") > -1) {
            s = s.replace("<", "&lt;");
        }

        while (s.search(">") > -1) {
            s = s.replace(">", "&gt;");
        }


        while (s.search("'") > -1) {
            s = s.replace("'", "&apos;");
        }

        return s;
    }

    //lr add 过滤xml合法字符
    public static function replaceReadXMLMarkValues(s:String):String {

        if (isStringNull(s))
            return "";

        while (s.search("&lt;") > -1) {
            s = s.replace("&lt;", "<");
        }

        while (s.search("&gt;") > -1) {
            s = s.replace("&gt;", ">");
        }


        while (s.search("&apos;") > -1) {
            s = s.replace("&apos;", "'");
        }

        return s;
    }

    public static function getNumber(str:*):Number {
        if (isNumber(str))
            return parseFloat(str)
        else
            return 0;
    }

    public static function isNumber(str:*):Boolean {
        if (parseFloat(str + "") + "" == "NaN")
            return false;
        else
            return true;
    }

    public static function setIME():void {
        IME.enabled = true;
    }

    //必要时 调用此方法 可以等待一个时间 再执行需要执行的方法
    public static function laterFunction(laterFunction:Function):void {
        AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
            laterFunction.call();
        }, "select 1", null, false);

    }

    public static function getPersonDepartmentList(iperson:int):ArrayCollection {
        var ac:ArrayCollection = new ArrayCollection();
        for each(var item:Object in CRMmodel.personlist) {
            if (item.iid == iperson)
                ac.addItem({idepartment: item.idepartment});
        }
        for each(var items:Object in CRMmodel.personslist) {
            if (items.iperson == iperson && items.bend != true) {
                ac.addItem({idepartment: items.idepartment});
            }
        }
        return ac;
    }

    public static function opernMenuItemByIfuncregedit(ifuncregedit:int):void {
        var nodeXml:XML = CRMtool.getTreeNodeByIfuncregedit(ifuncregedit);
        CRMtool.openMenuItem(nodeXml, nodeXml.@cparameter, "", new Date().toString());
    }

    //lr add 搜索tree
    public static function getTreeNodeByIfuncregedit(ifuncregedit:int):XML {
        var xmlList:XMLList = CRMmodel.authMenu.descendants("*");
        for (var i:int = 0; i < xmlList.length(); i++) {
            var childXml:XML = xmlList[i];
            var guid1:int = childXml.@ifuncregedit;
            if (guid1 == ifuncregedit) {
                return childXml;
            }
        }
        return null;
    }

    public static function isTrue(str:*):Boolean {
        if (str == null)
            return false;
        else
            return (str.toSource() == "1" || str.toSource() == "true")
    }

    public static function calljs(fun:String, param:* = null):* {
        var s;
        try {
            s = ExternalInterface.call(fun, param);
        } catch (e:Error) {
        }

        return s;
    }

    public static function labelFunctionFormatDateWithHNS(item:Object, column:DataGridColumn):String {
        var value = item[column.dataField];
        if (value is Date) {
            return formatDateWithHNS(value);
        } else {
            return value;
        }
    }


    public static function getBoolean(str:*):Boolean {
        var bool:Boolean;
        if (str == null) {
            return false;
        }
        if (str == 1 || str == true || str == "1" || str == "true") {
            bool = true;
        } else {
            bool = false;
        }
        return bool;
    }

    public static function getListset(vo:Object, back:Function) {
        var isIn:Boolean = false;
        for each(var item:Object in CRMmodel.listSetList) {
            if (item.ilist == vo.ilist && item.iperson == vo.iperson) {
                isIn = true;
                back.call(null, item);
                break;
            }
        }

        if (isIn == false) {
            AccessUtil.remoteCallJava("ACListsetDest", "getListset", function (event:ResultEvent):void {
                var acListsetVo:ListsetVo = event.result.acListsetVo as ListsetVo;
                var acListclmVos:ArrayCollection = event.result.acListclmVos as ArrayCollection;
                var item:Object = new Object();
                item.iperson = vo.iperson;
                item.ilist = vo.ilist;
                item.acListsetVo = acListsetVo;
                item.acListclmVos = acListclmVos;
                CRMmodel.listSetList.addItem(item);
                back.call(null, item);
            }, vo);
        }
    }

    public static function getFcrelation(vo:Object, back:Function) {
        var isIn:Boolean = false;
        for each(var item:Object in CRMmodel.fcrelationList) {
            if (item.iid == vo.iid) {
                isIn = true;
                back.call(null, item);
                break;
            }
        }

        if (isIn == false) {
            AccessUtil.remoteCallJava("As_fcrelationDest", "getAs_fcrelation1", function (event:ResultEvent):void {
                var item:Object = new Object();
                item.iid = vo.iid;
                item.resultList = event.result.resultList;
                CRMmodel.fcrelationList.addItem(item);
                back.call(null, item);
            }, vo);
        }
    }

    public static function getAuthcontent(ifuncregedit:int, back:Function) {
        var isIn:Boolean = false;
        for each(var item:Object in CRMmodel.authcontentList) {
            if (item.ifuncregedit == ifuncregedit) {
                isIn = true;
                back.call(null, item);
                break;
            }
        }

        if (isIn == false) {
            var sql:String = " select buse,ccode from as_authcontent  where ccode like '" + ifuncregedit + ".%'";
            AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
                var ac:ArrayCollection = event.result as ArrayCollection;
                var item:Object = new Object();
                item.ifuncregedit = ifuncregedit;
                item.list = ac;
                CRMmodel.authcontentList.addItem(item);
                back.call(null, item);
            }, sql, null, false);
        }
    }

    public static function getFuncregedit(iid:int):Object {
        for each(var item:Object in CRMmodel.funcregeditList) {
            if (item.iid == iid)
                return ObjectCopy(item);
        }
        return null
    }

    public static function getFormUI(ifuncregedit:int, back:Function) {
        var isIn:Boolean = false;
        for each(var item:Object in CRMmodel.formUIList) {
            if (item.ifuncregedit == ifuncregedit) {
                isIn = true;
                back.call(null, item.form);
                break;
            }
        }

        if (isIn == false) {
            AccessUtil.remoteCallJava("CommonalityDest", "queryVouch", function (event:ResultEvent):void {
                var form:Object = event.result;
                var item:Object = new Object();
                item.ifuncregedit = ifuncregedit;
                item.form = form;
                CRMmodel.formUIList.addItem(item);
                back.call(null, form);
            }, {ifuncregedit: ifuncregedit}, null, false);
        }
    }

    public static function hideFocus():void {
        if (CRMmodel.mainSearchTextInput)
            CRMmodel.mainSearchTextInput.setFocus();
    }
    /**
     * 四舍五入 保留小数位
     * @param a
     * @param n
     * @return
     */
    public static function round(a:Number, n:Number):Number {
        var x:int= 1;
        for (var i:int = 1; i <= n; i++)
            x = x * 10;

        return Math.round(a * x) / x;
    }

    public static function getacStatus():void {
        AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
            CRMmodel.statusList = event.result as ArrayCollection;
        }, "select * from ac_status", null, false);
    }

    public static function getStatusProperty(iid:int, property:String = "cname"):String {
        for each(var item:Object in CRMmodel.statusList) {
            if (item.iid == iid)
                return item[property];
        }
        return null
    }

    public static function getPersonProperty(iid:int, property:String):String {
        for each(var item:Object in CRMmodel.personlist) {
            if (item.iid == iid)
                return item[property];
        }
        return null;
    }
    public static function labelFunctionFormatDateNoHNS(item:Object, column:DataGridColumn):String {
        var value = item[column.dataField];
        if ((isDate(value) || isDateHNS(value)) && isStringNotNull(value)) {

            return formatDateNoHNS(DateFormatter.parseDateString(value));
        } else {
            return value;
        }
    }
    public static function isDate(text:String):Boolean {
        var reg:RegExp = /^((((1[6-9]|[2-9]\d)\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\d|3[01]))|(((1[6-9]|[2-9]\d)\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\d|30))|(((1[6-9]|[2-9]\d)\d{2})-0?2-(0?[1-9]|1\d|2[0-8]))|(((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29))$/;
        var dateStr:String = text;
        if (!( reg.test(dateStr) || dateStr == "")) {
            return false;
        }
        return true;
    }
    public static function isDateHNS(text:String):Boolean {
        var reg:RegExp = /^((((1[6-9]|[2-9]\d)\d{2})-(0?[13578]|1[02])-(0?[1-9]|[12]\d|3[01]))|(((1[6-9]|[2-9]\d)\d{2})-(0?[13456789]|1[012])-(0?[1-9]|[12]\d|30))|(((1[6-9]|[2-9]\d)\d{2})-0?2-(0?[1-9]|1\d|2[0-8]))|(((1[6-9]|[2-9]\d)(0[48]|[2468][048]|[13579][26])|((16|[2468][048]|[3579][26])00))-0?2-29-)) (20|21|22|23|[0-1]?\d):[0-5]?\d:[0-5]?\d$/;
        var dateStr:String = text;
        if (!( reg.test(dateStr) || dateStr == "")) {
            return false;
        }
        return true;
    }

    //通用报表输出
    public static function dataGridToMyReport(list:ArrayCollection, columns:Array, title:String):ReportSettings {
        var style:ReportSettings = new ReportSettings();
        //数据源
        style.TableData = list;
        var params:Dictionary = new Dictionary();
        params.Title = title;
        style.ParameterData = params;

        //报表样式
        style.TableHeaderRepeat = true;//表格头重复
        style.TableFooterRepeat = true;//表格尾重复
        style.AutoWidth = true;//报表宽度自动递增
        //style.PageByColumn  = true;//分栏打印
        style.SetUnit("px");

        //标题
        var captionRow:CaptionRowSetting = new CaptionRowSetting();
        var caption:CaptionCellSetting = new CaptionCellSetting();


        var reportWidth:Number = 0;
        //表格
        var headerRow:TableRowSetting = new TableRowSetting();
        var contentRow:TableRowSetting = new TableRowSetting();
        var gridColumns:Array = columns;
        for each(var gridCol:Object in gridColumns) {
            if (!gridCol.visible)
                continue;
            //添加列
            var column:TableColumnSetting = new TableColumnSetting();
            column.Width = gridCol.width;
            if (gridCol.headerText != null) {
                reportWidth += gridCol.width;
                style.TableColumnSettings.push(column);
            }

            //添加表格头单元格
            var headerCell:TableCellSetting = new TableCellSetting();
            headerCell.Style.FontBold = true;
            headerCell.Style.TextAlign = "center";
            headerCell.Value = gridCol.headerText;
            if (gridCol.headerText != null) {
                headerRow.TableCellSettings.push(headerCell);
            }

            //添加表格主体单元格
            var contentCell:TableCellSetting = new TableCellSetting();
            if (gridCol.dataField == "sort_id") {
                //contentCell.Value = "=Fields!sort_id.Value";
                contentCell.Value = "=RowNumber()";
            } else {
                contentCell.Value = "=Fields!" + gridCol.dataField + ".Value";
            }

            if (gridCol.headerText != null) {
                if (gridCol.dataField != null) {
                    if (gridCol.dataField.search("dmaker") > -1 || gridCol.dataField.search("dmodify") > -1 || gridCol.dataField.search("date") > -1 || gridCol.dataField.search("dbegin") > -1 || gridCol.dataField.search("dend") > -1) {
                        contentCell.Format = "D";
                    }
                }

                contentRow.TableCellSettings.push(contentCell);
            }

        }
        caption.Width = reportWidth;
        caption.Style.FontBold = true;
        caption.Style.FontSize = 16;
        caption.Style.TextAlign = "center";
        caption.Value = title;
        //caption.Value = "=@Title";
        captionRow.CaptionCellSettings.push(caption);
        style.PageHeaderSettings.push(captionRow);
        style.TableHeaderSettings.push(headerRow);
        style.TableDetailSettings.push(contentRow);
        return style;
    }
}
}