package yssoft.frameui.formopt {

import mx.collections.ArrayCollection;
import mx.core.Container;

import yssoft.comps.frame.module.CrmEapRadianVbox;
import yssoft.impls.ICommand;
import yssoft.tools.CRMtool;

public class NewingCommand extends BaseCommand {
    //传递的参数
    //public var _param:Object;

    private var _optType:String = "";

    public function NewingCommand(context:Container, optType:String, param:*, nextCommand:ICommand, excuteNextCommand:Boolean = false) {
        this._optType = optType;
        this._param = param;
        super(context, optType, param, nextCommand, excuteNextCommand);
    }

    override public function onExcute():void {

        try {
            if (context["paramForm"].hasOwnProperty("_vouchFormValue")) {
                if (context["paramForm"]._vouchFormValue == null) {
                    context["paramForm"]._vouchFormValue = new ArrayCollection();
                }

                context["paramForm"].setOtherButtons(false);

                context["paramForm"].setAllButtonsEnabled(context["paramForm"].curButtonStatus, context["paramForm"]._vouchFormValue.length);
                var crmeap:CrmEapRadianVbox = context as CrmEapRadianVbox;
                crmeap.curButtonStatus = context["paramForm"]["curButtonStatus"];
                var dataObj:Object = new Object();
                dataObj.mainValue = null;
                if (Boolean(context["isFirst"])) {
                    crmeap.setValue(null, 0, 0);
                }
                else {
                    crmeap.setValue(null, 1, 0);
                }
//					context.isSave = false;//新增数据时只显示单据编码，不保存
//					context.onGetNumber();
                context["isFirst"] = false;
                CRMtool.containerChildsEnabled(crmeap, true);
            } else {
                context.setValue(null, 0, 0);
            }

            context.data = "success";
            this.onNext();
        }
        catch (e:Error) {
            context.data = "fail";
            CRMtool.showAlert("新增异常！原因：" + e.toString());
        }
    }

    override public function onResult(result:*):void {
    }
}
}