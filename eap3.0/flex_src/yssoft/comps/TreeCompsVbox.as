package yssoft.comps {
import flash.events.Event;
import flash.geom.Point;
import flash.utils.describeType;

import mx.collections.XMLListCollection;
import mx.controls.Alert;
import mx.controls.List;
import mx.controls.ToolTip;
import mx.controls.Tree;
import mx.core.ClassFactory;
import mx.core.IFactory;
import mx.events.ListEvent;
import mx.managers.ToolTipManager;
import mx.utils.ObjectUtil;

import yssoft.tools.CRMtool;

/**
 * 三状态复选框树控件
 * <br /><br />
 */
[Event(name="selectChange", type="flash.events.Event")]
[Event(name="selectItemChange", type="flash.events.Event")]
public class TreeCompsVbox extends Tree {
    //数据源中状态字段
    private var m_checkBoxStateField:String = "@state";
    //部分选中的填充色
    [Bindable]
    private var m_checkBoxBgColor:uint = 0x009900;
    //填充色的透明度
    [Bindable]
    private var m_checkBoxBgAlpha:Number = 1;
    //填充色的边距
    [Bindable]
    private var m_checkBoxBgPadding:Number = 3;
    //填充色的四角弧度
    [Bindable]
    private var m_checkBoxBgElips:Number = 2;
    //取消选择是否收回子项
    [Bindable]
    private var m_checkBoxCloseItemsOnUnCheck:Boolean = true;
    //选择项时是否展开子项
    [Bindable]
    private var m_checkBoxOpenItemsOnCheck:Boolean = true;
    //选择框左边距的偏移量
    [Bindable]
    private var m_checkBoxLeftGap:int = 8;
    //选择框右边距的偏移量
    [Bindable]
    private var m_checkBoxRightGap:int = 20;
    //是否显示三状态
    [Bindable]
    private var m_checkBoxEnableState:Boolean = true;
    //与父项子项关联
    [Bindable]
    private var m_checkBoxCascadeOnCheck:Boolean = true;

    //双击项目
    public var itemDClickSelect:Boolean = false;
    [Bindable]
    private var _isShowCheckBox:Boolean = false;
    [Bindable]
    private var _treeCompsXml:XML;

    private var _isLock:Boolean = false;

    //是否多选属性
    private var _allowMulti:Boolean;
    private var _isShowTips:Boolean;

    public function get allowMulti():Boolean {
        return _allowMulti;
    }

    public function set allowMulti(value:Boolean):void {
        _allowMulti = value;
    }

    [Bindable]
    public function set treeCompsXml(_treeCompsXml:XML):void {
        this._treeCompsXml = _treeCompsXml;
        if (_treeCompsXml != null) {
            this.dataProvider = _treeCompsXml;
        } else {
            this.dataProvider = new XML();
        }
    }

    public function get treeCompsXml():XML {
        return this._treeCompsXml;
    }


    override public function set selectedIndex(value:int):void {
        var swapIndex:int = super.selectedIndex;
        super.selectedIndex = value;
        if (value > -1 && value != swapIndex) {
            this.dispatchEvent(new Event("selectChange"));
        }
    }

    override public function set selectedItem(data:Object):void {
        var swapItem:Object = super.selectedItem;
        super.selectedItem = data;
        if (data && data != swapItem) {
            this.dispatchEvent(new Event("selectItemChange"));
        }
    }

    /*public function get selectedIndex():Boolean
     {
     return this._selectedIndex
     }*/

    public function set isShowCheckBox(_isShowCheckBox:Boolean):void {
        this._isShowCheckBox = _isShowCheckBox;
    }

    public function get isShowCheckBox():Boolean {
        return this._isShowCheckBox
    }


    public function TreeCompsVbox() {
        super();
        this.doubleClickEnabled = true;
        this.labelFunction = getCcode;
        this.showRoot = false;
    }


    private var myToolTip:ToolTip;

    override protected function createChildren():void {
        var myFactory:ClassFactory = new ClassFactory(CheckTreeRenderer);
        this.itemRenderer = myFactory;
        super.createChildren();
        if (itemDClickSelect) {
            addEventListener(ListEvent.ITEM_DOUBLE_CLICK, onItemDClick);
        }
        else {
            addEventListener(ListEvent.ITEM_CLICK, onItemDClick);
        }

        if (isShowTips) {
            this.addEventListener(ListEvent.ITEM_ROLL_OVER, function (e:ListEvent):void {
                var listRenderer = e.itemRenderer;
                var tipLable:String = listRenderer.listData.item.@cname

                var _point:Point = new Point(this.x, this.y);
                _point = localToGlobal(_point);

                cleanTip();
                if (CRMtool.isStringNotNull(tipLable)) {
                    myToolTip = ToolTipManager.createToolTip(tipLable, _point.x + mouseX + 15, _point.y + mouseY) as ToolTip;
                }
            });

            this.addEventListener(ListEvent.ITEM_ROLL_OUT, function (e:ListEvent):void {
                cleanTip();
            });
        }
    }

    private function cleanTip():void {
        if (myToolTip is ToolTip) {
            ToolTipManager.destroyToolTip(myToolTip);
        }
        myToolTip = null;
    }

    public function PropertyChange():void {
        dispatchEvent(new ListEvent(mx.events.ListEvent.CHANGE));
    }

    override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
        super.updateDisplayList(unscaledWidth, unscaledHeight);
        if (this.isShowCheckBox) {
            this.setStyle("defaultLeafIcon", null);
            this.setStyle("folderClosedIcon", null);
            this.setStyle("folderOpenIcon", null);
        }
        this.setStyle("borderStyle", "none");
    }

    /**
     * 树菜单，双击事件
     * @param evt 双击事件源
     *
     */
    public function onItemDClick(e:ListEvent):void {
        cleanTip();
        if (isLock)
            return;

        OpenItems();
    }

    /**
     * 打开Tree节点函数，被 有打开节点功能的函数调用
     * @param item  要打开的节点
     *
     */
    public function OpenItems():void {
        if (this.selectedIndex >= 0 && this.dataDescriptor.isBranch(this.selectedItem))
            this.expandItem(this.selectedItem, !this.isItemOpen(this.selectedItem), true);
    }

    /**
     * 数据源中状态字段
     * @return
     *
     */
    [Bindable]
    public function get checkBoxStateField():String {
        return m_checkBoxStateField;
    }

    public function set checkBoxStateField(v:String):void {
        if (v) {
            m_checkBoxStateField = v.toLocaleUpperCase();
            PropertyChange();
        }
    }

    /**
     * 部分选中的填充色
     * @return
     *
     */
    [Bindable]
    public function get checkBoxBgColor():uint {
        return m_checkBoxBgColor;
    }

    public function set checkBoxBgColor(v:uint):void {
        m_checkBoxBgColor = v;
        PropertyChange();
    }

    /**
     * 填充色的透明度
     * @return
     *
     */
    [Bindable]
    public function get checkBoxBgAlpha():Number {
        return m_checkBoxBgAlpha;
    }

    public function set checkBoxBgAlpha(v:Number):void {
        m_checkBoxBgAlpha = v;
        PropertyChange();
    }


    /**
     * 填充色的边距
     * @return
     *
     */
    [Bindable]
    public function get checkBoxBgPadding():Number {
        return m_checkBoxBgPadding;
    }

    public function set checkBoxBgPadding(v:Number):void {
        m_checkBoxBgPadding = v;
        PropertyChange();
    }

    /**
     * 填充色的四角弧度
     * @return
     *
     */
    [Bindable]
    public function get checkBoxBgElips():Number {
        return m_checkBoxBgElips;
    }

    public function set checkBoxBgElips(v:Number):void {
        m_checkBoxBgElips = v;
        PropertyChange();
    }


    /**
     * 取消选择是否收回子项
     * @return
     *
     */
    [Bindable]
    public function get checkBoxCloseItemsOnUnCheck():Boolean {
        return m_checkBoxCloseItemsOnUnCheck;
    }

    public function set checkBoxCloseItemsOnUnCheck(v:Boolean):void {
        m_checkBoxCloseItemsOnUnCheck = v;
        PropertyChange();
    }


    /**
     * 选择项时是否展开子项
     * @return
     *
     */
    [Bindable]
    public function get checkBoxOpenItemsOnCheck():Boolean {
        return m_checkBoxOpenItemsOnCheck;
    }

    public function set checkBoxOpenItemsOnCheck(v:Boolean):void {
        m_checkBoxOpenItemsOnCheck = v;
        PropertyChange();
    }


    /**
     * 选择框左边距的偏移量
     * @return
     *
     */
    [Bindable]
    public function get checkBoxLeftGap():int {
        return m_checkBoxLeftGap;
    }

    public function set checkBoxLeftGap(v:int):void {
        m_checkBoxLeftGap = v;
        PropertyChange();
    }


    /**
     * 选择框右边距的偏移量
     * @return
     *
     */
    [Bindable]
    public function get checkBoxRightGap():int {
        return m_checkBoxRightGap;
    }

    public function set checkBoxRightGap(v:int):void {
        m_checkBoxRightGap = v;
        PropertyChange();
    }


    /**
     * 是否显示三状态
     * @return
     *
     */
    [Bindable]
    public function get checkBoxEnableState():Boolean {
        return m_checkBoxEnableState;
    }

    public function set checkBoxEnableState(v:Boolean):void {
        m_checkBoxEnableState = v;
        PropertyChange();
    }


    /**
     * 与父项子项关联
     * @return
     *
     */
    [Bindable]
    public function get checkBoxCascadeOnCheck():Boolean {
        return m_checkBoxCascadeOnCheck;
    }

    public function set checkBoxCascadeOnCheck(v:Boolean):void {
        m_checkBoxCascadeOnCheck = v;
        PropertyChange();
    }

    private function getCcode(item:Object):String {
        if (item.hasOwnProperty("@ccode") && item.@ccode) {
            return    "(" + item.@ccode + ")" + item.@cname;
        } else {
            return    item.@cname;
        }
    }


    /**
     *
     * 函数名：getIpid
     * 作者：刘磊
     * 日期：2011-08-16
     * 功能：依据当前节点编码ccode，获得父级节点iid
     * 参数：@ccode：当前节点编码
     * 返回值：当前节点ipid
     * 修改记录：无
     *
     */
    public function getIpid(ccode:String):int {
        if (_treeCompsXml == null) {
            return -1;
        }
        var pid:int = ccode.lastIndexOf(".");
        if (pid != -1) {
            var pccode:String = ccode.substr(0, pid);
            pid = ((_treeCompsXml.descendants("*").(@ccode == pccode) as XMLList)[0] as XML).@iid;
        }
        return pid;
    }

    /**
     *
     * 函数名：isExistsCcode
     * 作者：刘磊
     * 日期：2011-08-16
     * 功能：查找当前节点编码ccode是否存在
     * 参数：@ccode：当前节点编码,@warnMsg：节点存在提示信息
     * 返回值：Boolean
     * 修改记录：无
     */
    public function isExistsCcode(ccode:String, warnMsg:String):Boolean {
        if (_treeCompsXml == null) {
            return false;
        }
        var count:int = (_treeCompsXml.descendants("*").(@ccode == ccode) as XMLList).length();
        var exist:Boolean = (count >= 1);
        if (exist && warnMsg != "") {
            CRMtool.showAlert(warnMsg);
        }
        return exist;
    }

    /**
     *
     * 函数名：isExistsChild
     * 作者：刘磊
     * 日期：2011-08-16
     * 功能：查找当前节点编码ccode是否存在子节点
     * 参数：@ccode：当前节点编码,@warnMsg：子节点存在提示信息
     * 返回值：Boolean
     * 修改记录：无
     */
    public function isExistsChild(ccode:String, warnMsg:String = ""):Boolean {
        if (_treeCompsXml == null) {
            return false;
        }
        var count:int = (_treeCompsXml.descendants("*").(@ccode == ccode) as XMLList).children().length();
        var exist:Boolean = (count >= 1);
        if (exist && warnMsg != "") {
            CRMtool.showAlert(warnMsg);
        }
        return exist;
    }

    /**
     *
     * 函数名：isExistsParent
     * 作者：刘磊
     * 日期：2011-08-08
     * 功能：查找当前节点编码ccode是否存在父节点
     * 参数：@ccode：当前节点编码,@warnMsg：父节点存在提示信息
     * 返回值：Boolean
     * 修改记录：无
     */
    public function isExistsParent(ccode:String, warnMsg:String):Boolean {
        if (_treeCompsXml == null) {
            return true;
        }
        var pid:int = ccode.lastIndexOf(".");
        var exist:Boolean = true;
        if (pid != -1) {
            var pccode:String = ccode.substr(0, pid);
            exist = ((_treeCompsXml.descendants("*").(@ccode == pccode) as XMLList).length() >= 1);
            if (!exist && warnMsg != "") {
                CRMtool.showAlert(warnMsg);
            }
        }
        return exist;
    }

    /**
     *
     * 函数名：
     * 作者：刘磊
     * 日期：2011-08-15
     * 功能：增加操作刷新树节点
     * 参数：@vo:树节点对应的VO对象，更新值
     * 返回值：无
     * 修改记录：
     */
    public function AddTreeNode(vo:Object):void {
        //拼接子节点XML串
        /*var xml:XML =flash.utils.describeType(vo);*/
        var newnode:String = "<node ";
        var objInfo:Object = ObjectUtil.getClassInfo(vo);
        var fieldName:Array = objInfo["properties"] as Array;
        for each(var q:QName in fieldName) {
            //q.localName 属性名称，value对应的值
            var value:String = vo[q.localName];
            newnode = newnode + q.localName + "='" + value + "' ";
        }
        /*for each(var accessor in xml..accessor){
         var obj:Object=vo[accessor.@name];
         var value:String;
         if (obj==null)
         {
         value="";
         }
         else
         {
         value=String(obj);
         }
         newnode= newnode+accessor.@name+"='"+value+"' ";
         }*/
        newnode = newnode + "/>";
        if (_treeCompsXml == null) {
            _treeCompsXml = new XML("<root></root>");
            _treeCompsXml.appendChild(XML(newnode));
            this.dataProvider = _treeCompsXml;
        }
        else {
            //获得父节点位置
            var nodeXml:XML = (_treeCompsXml.descendants("*").(@iid == vo.ipid) as XMLList)[0] as XML;


            if (vo.ipid == -1) {
                if (_treeCompsXml.children().length() == 0) {
                    _treeCompsXml.appendChild(XML(newnode));
                }
                else {
                    var _nodeXml:XMLList = _treeCompsXml.descendants("*").(@ccode < vo.ccode) as XMLList;

                    if (_nodeXml == null || _nodeXml.length() == 0) {
                        var _noXml:XMLList = _treeCompsXml.descendants("*").(@ccode > vo.ccode) as XMLList;
                        _treeCompsXml.insertChildBefore(_noXml[0], XML(newnode));
                    }
                    else {
                        var _xml:XML = _nodeXml[_nodeXml.length() - 1] as XML;
                        var ccode:String = vo.ccode as String;
                        var upCcode:String = _xml.@ccode;
                        //原来的代码
                        /*if(upCcode.length==ccode.length)
                         {
                         _treeCompsXml.insertChildAfter(_xml,XML(newnode));
                         }
                         else
                         {
                         var newStr:String = upCcode.substr(0,ccode.length);
                         //解决新增节点消失的bug，不是很好
                         if(newStr.substr(newStr.length-1, newStr.length) == ".") {
                         newStr = newStr.substr(0,newStr.length-1);
                         }
                         var _node:XMLList=_treeCompsXml.descendants("*").(@ccode==newStr) as XMLList;
                         _treeCompsXml.insertChildAfter(_node[0],XML(newnode));
                         }*/
                        //新的代码
                        if (upCcode.length == ccode.length) {
                            //判断ccode=111，upCcode=1.1的情况
                            if (upCcode.indexOf(".") != -1 && ccode.indexOf(".") == -1) {
                                var newStr:String = new String(upCcode);
                                newStr = newStr.substr(0, newStr.indexOf("."));
                                var _node:XMLList = _treeCompsXml.descendants("*").(@ccode == newStr) as XMLList;
                                _treeCompsXml.insertChildAfter(_node[0], XML(newnode));
                            } else {
                                _treeCompsXml.insertChildAfter(_xml, XML(newnode));
                            }
                        }
                        else {
                            var newStr:String = "";
                            if (upCcode.length > ccode.length) {
                                if (upCcode.indexOf(".") > -1) {
                                    newStr = upCcode.substr(0, ccode.length);
                                } else {
                                    var _node:XMLList = _treeCompsXml.descendants("*").(@ccode == upCcode) as XMLList;
                                    _treeCompsXml.insertChildAfter(_node[0], XML(newnode));
                                    newStr = "";
                                }
                            } else {
                                newStr = ccode.substr(0, upCcode.length);
                            }
                            if (newStr.length > 0) {
                                if (newStr.substr(newStr.length - 1, newStr.length) == ".") {
                                    newStr = newStr.substr(0, newStr.length - 1);
                                }
                                var _node:XMLList = _treeCompsXml.descendants("*").(@ccode == newStr) as XMLList;
                                if (_node.length() == 0) {
                                    var str:String = new String(newStr);
                                    while (_node.length() == 0 && str.length != 0) {
                                        str = str.substr(0, str.length - 1);
                                        if (str.length == 0) {
                                            str = new String(upCcode);
                                            if (str.indexOf(".") > -1) {
                                                str = str.substr(0, str.indexOf("."));
                                            }
                                            _node = _treeCompsXml.descendants("*").(@ccode == str) as XMLList;
                                            _treeCompsXml.insertChildAfter(_node[0], XML(newnode));
                                            break;
                                        }
                                        _node = _treeCompsXml.descendants("*").(@ccode == str) as XMLList;
                                        if (_node.length() != 0) {
                                            _treeCompsXml.insertChildAfter(_node[0], XML(newnode));
                                            break;
                                        }
                                    }

                                } else {
                                    _treeCompsXml.insertChildAfter(_node[0], XML(newnode));
                                }
                            }
                        }
                    }


                }

            }
            else {
                if (nodeXml.children().length() == 0) {
                    nodeXml.appendChild(XML(newnode));
                }
                else {
                    var _chnodeXml:XMLList = nodeXml.descendants("*").(@ccode < vo.ccode) as XMLList;

                    if (_chnodeXml == null || _chnodeXml.length() == 0) {
                        var _noXml:XMLList = nodeXml.descendants("*").(@ccode > vo.ccode) as XMLList;
                        nodeXml.insertChildBefore(_noXml[0], XML(newnode));
                    }
                    else {
                        var _chxml:XML = _chnodeXml[_chnodeXml.length() - 1] as XML;

                        var chccode:String = vo.ccode as String;
                        var chupCcode:String = _chxml.@ccode;
                        if (chupCcode.length == chccode.length) {
                            nodeXml.insertChildAfter(_chxml, XML(newnode));
                        }
                        else {
                            var chnewStr:String = chupCcode.substr(0, chccode.length);
                            var _chnode:XMLList = nodeXml.descendants("*").(@ccode == chnewStr) as XMLList;
                            nodeXml.insertChildAfter(_chnode[0], XML(newnode));
                        }
                    }
                }
            }
        }
    }


    /**
     *
     * 函数名：
     * 作者：刘磊
     * 日期：2011-08-15
     * 功能：修改操作刷新树节点
     * 参数：@vo:树节点对应的VO对象，更新值
     * 返回值：无
     * 修改记录：
     */
    public function EditTreeNode(vo:Object):void {

        var curxml:XML = this.selectedItem as XML;
        var ccode:String = curxml.@ccode; //原选中编码

        //用vo更新当前节点值
        /*var xml:XML =flash.utils.describeType(vo);*/
        var newccode:String;
        var iid:int;
        var ipid:int;

        var objInfo:Object = ObjectUtil.getClassInfo(vo);
        var fieldName:Array = objInfo["properties"] as Array;
        for each(var q:QName in fieldName) {
            //q.localName 属性名称，value对应的值
            var value:String = vo[q.localName];
            curxml.@[q.localName] = value;

            switch (q.localName) {
                case "iid":
                {
                    iid = Number(value);
                    break;
                }
                case "ipid":
                {
                    ipid = Number(value);
                    break;
                }
                case "ccode":
                {
                    newccode = String(value);
                    break;
                }
            }
        }
        /*for each(var accessor in xml..accessor){
         var obj:Object=vo[accessor.@name];
         var value:String;
         if (obj==null)
         {
         value="";
         }
         else
         {
         value=String(obj);
         }
         curxml.@[accessor.@name]=value;
         switch(String(accessor.@name))
         {
         case "iid":{iid=Number(value);break;}
         case "ipid":{ipid=Number(value);break;}
         case "ccode":{newccode=String(value);break;}
         }
         }*/

        var curlist:XMLList = curxml.descendants("*");
        //更新当前及子节点编码
        for each(var xmlChildren:XML in curlist) {
            xmlChildren.@ccode = String(xmlChildren.@ccode).replace(ccode, newccode);
            for each(var q:QName in fieldName) {
                //q.localName 属性名称，value对应的值
                var value:String = vo[q.localName];
                curxml.@[q.localName] = value;

                switch (String(q.localName)) {
                    case "buse":
                    {
                        xmlChildren.@[q.localName] = vo.buse;
                        break;
                    }

                }
            }
            /*for each(var accessor in xml..accessor){
             var obj:Object=vo[accessor.@name];
             var value:String;
             if (obj==null)
             {
             value="";
             }
             else
             {
             value=String(obj);
             }
             curxml.@[accessor.@name]=value;
             switch(String(accessor.@name))
             {
             case "buse":{xmlChildren.@[accessor.@name]=vo.buse;break;}

             }
             }*/
        }

        //获得父节点位置
        var nodeXml:XML = (_treeCompsXml.descendants("*").(@iid == iid) as XMLList)[0] as XML;

        var newNodeXml:XML = nodeXml.copy();

        delete(_treeCompsXml.descendants("*").(@iid == iid) as XMLList)[0] as XML;

        if (vo.ipid == -1) {
            if (_treeCompsXml.children().length() == 0) {
                _treeCompsXml.appendChild(XML(newNodeXml));
            }
            else {
                var _nodeXml:XMLList = _treeCompsXml.descendants("*").(@ccode < vo.ccode) as XMLList;
                if (_nodeXml == null || _nodeXml.length() == 0) {
                    var _noXml:XMLList = _treeCompsXml.descendants("*").(@ccode > vo.ccode) as XMLList;
                    _treeCompsXml.insertChildBefore(_noXml[0], newNodeXml);
                }
                else {
                    var _xml:XML = _nodeXml[_nodeXml.length() - 1] as XML;
                    var new_ccode:String = vo.ccode as String;
                    var upCcode:String = _xml.@ccode;
                    if (upCcode.length == new_ccode.length) {
                        _treeCompsXml.insertChildAfter(_xml, newNodeXml);
                    }
                    else {
                        var newStr:String = upCcode.substr(0, ccode.length);
                        var _node:XMLList = _treeCompsXml.descendants("*").(@ccode == newStr) as XMLList;
                        _treeCompsXml.insertChildAfter(_node[0], newNodeXml);
                    }
                }
            }

        }
        else {
            var pidnodeXml:XML = (_treeCompsXml.descendants("*").(@iid == ipid) as XMLList)[0] as XML;
            if (pidnodeXml.children().length() == 0) {
                pidnodeXml.appendChild(newNodeXml);
            }
            else {
                var _chnodeXml:XMLList = pidnodeXml.descendants("*").(@ccode < vo.ccode) as XMLList;
                if (_chnodeXml == null || _chnodeXml.length() == 0) {
                    var _chnoXml:XMLList = pidnodeXml.descendants("*").(@ccode > vo.ccode) as XMLList;
                    pidnodeXml.insertChildBefore(_chnoXml[0], newNodeXml);
                }
                else {
                    var _chxml:XML = _chnodeXml[_chnodeXml.length() - 1] as XML;

                    var chccode:String = vo.ccode as String;
                    var chupCcode:String = _chxml.@ccode;
                    if (chupCcode.length == chccode.length) {
                        pidnodeXml.insertChildAfter(_chxml, newNodeXml);
                    }
                    else {
                        var chnewStr:String = chupCcode.substr(0, chccode.length);
                        var _chnode:XMLList = _treeCompsXml.descendants("*").(@ccode == chnewStr) as XMLList;
                        pidnodeXml.insertChildAfter(_chnode[0], newNodeXml);
                    }
                }
            }
        }
        this.selectedItem = newNodeXml;
    }

    /**
     *
     * 函数名：
     * 作者：刘磊
     * 日期：2011-08-15
     * 功能：删除操作时刷新树节点
     * 参数：
     * 返回值：无
     * 修改记录：
     */
    public function DeleteTreeNode():void {
        var size:int = this.selectedIndex;
        delete (_treeCompsXml.descendants("*").(@iid == this.selectedItem.@iid) as XMLList)[0] as XML;
        if (size == 0) {
            this.selectedIndex = size;
        }
        else {
            this.selectedIndex = size - 1;
        }
    }

    public function DeleteSelectNode():void {
        var nodeXml:XML = (this._treeCompsXml.descendants("*").(@iid == this.selectedItem.@iid) as XMLList)[0] as XML;
        if (null != nodeXml) {
            var i:int = nodeXml.children().length() - 1;
            for (; i >= 0; i--) {
                delete (nodeXml.children())[i] as XML;
            }
        }
    }

    /**
     *
     * 函数名：
     * 作者：刘磊
     * 日期：2011-08-27
     * 功能：全部展开
     * 参数：
     * 返回值：无
     * 修改记录：
     */
    public function expandAll():void {
        this.validateNow();
        for each(var item:XML in this.treeCompsXml)
            this.expandChildrenOf(item, true);
    }

    public function expandRoot():void {
        this.validateNow();
        for each(var item:XML in this.treeCompsXml) {
            this.expandChildrenOf(item, true);
            break;
        }
    }

    /**
     *
     * 函数名：
     * 作者：刘磊
     * 日期：2011-08-27
     * 功能：全部收起
     * 参数：
     * 返回值：无
     * 修改记录：
     */
    public function CollapseAll():void {
        this.validateNow();
        for each(var item:XML in this.treeCompsXml)
            this.expandChildrenOf(item, false);
    }


    public function get isLock():Boolean {
        return _isLock;
    }

    public function set isLock(value:Boolean):void {
        _isLock = value;
    }

    public function get isShowTips():Boolean {
        return _isShowTips;
    }

    public function set isShowTips(value:Boolean):void {
        _isShowTips = value;
    }
}
} 