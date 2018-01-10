package yssoft.comps {
import flash.events.MouseEvent;
import flash.text.TextLineMetrics;

import mx.containers.Canvas;

import mx.controls.Button;
import mx.controls.LinkBar;
import mx.controls.LinkButton;
import mx.core.DragSource;
import mx.core.EdgeMetrics;
import mx.core.IBorder;
import mx.core.IFlexAsset;
import mx.core.IFlexDisplayObject;
import mx.core.UITextField;
import mx.core.mx_internal;
import mx.events.DragEvent;
import mx.events.FlexEvent;
import mx.managers.DragManager;

import spark.effects.Move;

import yssoft.models.ConstsModel;

// 选中 颜色
[Style(name="selectedItemColor", type="uint", format="Color", inherit="no")]
// 未选中 颜色
[Style(name="nuSelectedItemColor", type="uint", format="Color", inherit="no")]
// 选中 图标
[Style(name="selectedItemIcon", type="Class", inherit="no")]

//选中背景色
[Style(name="selectedItemSkin", type="Class", inherit="no")]


public class CRMLinkBar extends LinkBar {
    [Bindable]
    public var barBackCanvas:Canvas;

    public function CRMLinkBar() {
        super();
        this.addEventListener(FlexEvent.UPDATE_COMPLETE, function (e:FlexEvent):void {
            setBarBackVanvas();
        })
    }

    private var _closeEnable:Boolean = true;			//是否可以被关闭 true 是可以被关闭

    public function set closeEnable(value:Boolean):void {
        this._closeEnable = value;
    }

    public function get closeEnable():Boolean {
        return this._closeEnable;
    }

    private var _callBack:Function;
    public function get callBack():Function {
        return _callBack;
    }

    public function set callBack(value:Function):void {
        _callBack = value;
    }

    private var _dragBackFunction:Function;

    override protected function createNavItem(label:String, icon:Class = null):IFlexDisplayObject {
        var newLink:LinkButton = super.createNavItem(label, icon) as LinkButton;

        newLink.toolTip = label;
        if (label && label.length > 6) {
            newLink.label = label.substr(0, 6) + "..";
        }
        newLink.useHandCursor = false;
        newLink.labelPlacement = "left";
        if (newLink.label != "我的桌面" && newLink.label != "常用功能") {
            newLink.setStyle("icon", ConstsModel.png_cancel);
        }
        newLink.percentHeight = 100;
        //newLink.addEventListener(MouseEvent.MOUSE_MOVE, newLink_mouseMoveHandler);
        //newLink.addEventListener(DragEvent.DRAG_ENTER, newLink_dragEnterHandler);
        //newLink.addEventListener(DragEvent.DRAG_DROP, newLink_dragDropHandler);
        //newLink.addEventListener(MouseEvent.MOUSE_OVER,onMouseOver);
        return newLink;
    }

    private var _selectedIndex:int = -1;

    /**
     *  @private
     */
    private var _selectedIndexChanged:Boolean = false;

    [Bindable("valueCommit")]
    [Inspectable(category="General")]

    /**
     *  The index of the last selected LinkButton control if the LinkBar
     *  control uses a ViewStack container as its data provider.
     *
     *  @default -1
     *
     *  @langversion 3.0
     *  @playerversion Flash 9
     *  @playerversion AIR 1.1
     *  @productversion Flex 3
     */
    override public function get selectedIndex():int {
        return _selectedIndex;
    }

    /**
     *  @private
     */
    override public function set selectedIndex(value:int):void {
        /*			if (value == selectedIndex){
         return;
         }*/
        _selectedIndex = value;
        _selectedIndexChanged = true;
        //invalidateProperties();

        resetNavItems();
    }

    override protected function hiliteSelectedNavItem(index:int):void {
        //super.hiliteSelectedNavItem(index);
        //super.hiliteSelectedNavItem(index);
        var child:Button;
        if (selectedIndex != -1 && selectedIndex < numChildren) {
            child = Button(getChildAt(_selectedIndex));
            child.enabled = true;
        }
        super.selectedIndex = index;
        _selectedIndex = index;
        //("----index----"+index);
        //resetNavItems();
    }

    override protected function resetNavItems():void {
        //super.resetNavItems();
        var n:int = numChildren;
        //barBackCanvas.x = -1000;
        for (var i:int = 0; i < n; i++) {
            var child:LinkButton = LinkButton(getChildAt(i));
            child.enabled = true;//!(i == _selectedIndex);
            if (child.label == "我的桌面" || child.label == "常用功能") {
                continue;
            }
            if (i == _selectedIndex) {
                child.setStyle("color", this.getStyle("selectedItemColor"));
                child.setStyle("icon", this.getStyle("selectedItemIcon"));
                child.setStyle("opaqueBackground", "red");
            } else {
                //child.styleName = "unSelectedBarItem";
                child.setStyle("color", this.getStyle("disabledColor"));
                child.setStyle("icon", null)
            }
            //("_selectedIndex="+_selectedIndex+",n="+n);
        }
    }

    public function setBarBackVanvas() {
        if (selectedIndex > -1 && selectedIndex < numChildren) {
            if (selectedIndex == 0) {
                barBackCanvas.width = 0;
                return;
            }

            var child:LinkButton = getChildAt(selectedIndex) as LinkButton;

            var move:Move = new Move();
            move.target = barBackCanvas;
            //move.xFrom = barBackCanvas.x;
            move.xTo = child.x + this.left - 5;

            //barBackCanvas.x = child.x;
            barBackCanvas.width = child.width + 10;
            move.stop();
            move.play();
        }
    }

    private function onMouseOver(event:MouseEvent):void {
        //adjustIconPosition(event);
    }

    //判定 当前 鼠标在linkbutton 上的 大致位置
    private function adjustIconPosition(event:MouseEvent):void {

        var newLink:LinkButton = event.currentTarget as LinkButton;
        var newDif:Number = 0;
        var dif:Number = 0;

        if (!newLink.data) {
            // 文本 大小
            var textWidth:Number = 0;
            var textHeight:Number = 0;
            if (newLink.label) {
                var lineMetrics:TextLineMetrics = newLink.measureText(newLink.label);
                textWidth = lineMetrics.width + UITextField.mx_internal::TEXT_WIDTH_PADDING;
                textHeight = lineMetrics.height + UITextField.mx_internal::TEXT_HEIGHT_PADDING;
            }

            // icon 大小
            var tempCurrentIcon:IFlexDisplayObject = newLink.mx_internal::getCurrentIcon();
            var iconWidth:Number = tempCurrentIcon ? tempCurrentIcon.width : 0;
            var iconHeight:Number = tempCurrentIcon ? tempCurrentIcon.height : 0;

            var horizontalGap:Number = newLink.getStyle("horizontalGap");
            var paddingLeft:Number = newLink.getStyle("paddingLeft");

            var bm:EdgeMetrics = newLink.mx_internal::currentSkin && newLink.mx_internal::currentSkin is IBorder && !(newLink.mx_internal::currentSkin is IFlexAsset) ? IBorder(newLink.mx_internal::currentSkin).borderMetrics : null;
            var bmleft:Number = 0;
            if (bm) {
                bmleft = bm.left;
            }
            dif = textWidth + horizontalGap + paddingLeft + bmleft;
            newLink.data = dif;
        } else {
            dif = Number(newLink.data);
        }
        newDif = event.localX - dif;
        if (newDif > 0) {
            //("我在图标上");
            newLink.useHandCursor = true;
        } else {
            //("我bu在图标上");
            newLink.useHandCursor = false;
        }
    }

    override protected function clickHandler(event:MouseEvent):void {
        super.clickHandler(event);
        this.stage.dispatchEvent(event);
        var newLink:LinkButton = event.currentTarget as LinkButton;
        if (newLink.label == "我的桌面" || newLink.label == "常用功能") {
            return;
        }
        adjustIconPosition(event);
        var index:int = this.getChildIndex(newLink);
        if (newLink.useHandCursor) {
            if (callBack)
                callBack(index);
        } else {
            _selectedIndex = index;
            resetNavItems();
        }
    }

    //lr 实现拖拽 需要用到三个事件 newLink_mouseMoveHandler，newLink_dragEnterHandler，newLink_dragDropHandler

    private function newLink_mouseMoveHandler(event:MouseEvent):void {
        if (event.buttonDown) {
            var dragInitiator:Button = Button(event.currentTarget);
            var ds:DragSource = new DragSource();
            ds.addData(dragInitiator, 'LinkBarButton');
            DragManager.doDrag(dragInitiator, ds, event);
        }
    }

    private function newLink_dragEnterHandler(event:DragEvent):void {
        var dropTarget:Button = event.currentTarget as Button;
        if (event.dragSource.hasFormat('LinkBarButton')) {

            var dropSource:Button = event.dragSource.dataForFormat('LinkBarButton') as Button;

            if (dropSource == dropTarget)
                return;
            // 接受放置。
            DragManager.acceptDragDrop(dropTarget);
            DragManager.showFeedback(DragManager.COPY);
        }
    }

    private function newLink_dragDropHandler(event:DragEvent):void {
        var dropTarget:Button = event.currentTarget as Button;
        if (event.dragSource.hasFormat('LinkBarButton')) {
            var dropSource:Button = event.dragSource.dataForFormat('LinkBarButton') as Button;
            if (dropSource == dropTarget)
                return;

            var dropTargetIndex:int = this.getChildIndex(dropTarget);
            var dropSourceIndex:int = this.getChildIndex(dropSource);

            //this.setChildIndex(dropSource,dropTargetIndex);
            //this.setChildIndex(dropTarget,dropSourceIndex);

            var mainViewStack = this.dataProvider;
            var dropSourceObj = mainViewStack.getChildAt(dropSourceIndex);
            var dropTargetObj = mainViewStack.getChildAt(dropTargetIndex);
            //mainViewStack.removeChild(dropSourceObj);
            mainViewStack.setChildIndex(dropSourceObj, dropTargetIndex);
            mainViewStack.selectedIndex = dropTargetIndex;
            this.selectedIndex = dropTargetIndex;
        }
    }

}
}