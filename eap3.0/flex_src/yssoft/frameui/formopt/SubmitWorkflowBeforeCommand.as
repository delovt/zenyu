package yssoft.frameui.formopt {

import mx.collections.ArrayCollection;
import mx.core.Container;
import mx.rpc.events.ResultEvent;

import yssoft.comps.frame.module.CrmEapRadianVbox;

import yssoft.evts.EventAdv;
import yssoft.frameui.FrameCore;
import yssoft.impls.ICommand;
import yssoft.models.CRMmodel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;

public class SubmitWorkflowBeforeCommand extends BaseCommand {
    public function SubmitWorkflowBeforeCommand(context:Container, optType:String = "", param:* = null, nextCommand:ICommand = null, excuteNextCommand:Boolean = false) {
        super(context, optType, param, nextCommand, excuteNextCommand);
    }

    override public function onExcute():void {
        var frameCore:FrameCore = context["paramForm"] as FrameCore;
        if (frameCore.wfiid > 0) {
            CRMtool.showAlert("单据已经绑定了工作流,不能再次提交");
            return;
        }
        if (frameCore.formIfunIid <= 0) {
            CRMtool.showAlert("获取不到单据功能注册码");
            return;
        }
        if (frameCore.currid <= 0) {
            CRMtool.showAlert("获取不到单据内容");
            return;
        }
        else if (CRMmodel.userId != 1 && _param.value.imaker > 0 && _param.value.imaker != CRMmodel.userId) {
            CRMtool.tipAlert("提交人必须是制单人");
            return;
        }

        var mainValue:Object = (context as CrmEapRadianVbox).getValue();
        var sql:String = "select ws.ccomefield from wf_invosets ws  " +
                "left join  wf_invoset wt on ws.iinvoset = wt.iid " +
                "where wt.brelease = 1 and  isnull(ws.ccomefield,'')!=''  and wt.ifuncregedit =  " + frameCore.formIfunIid;
        AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
            var ac:ArrayCollection = event.result as ArrayCollection;
            if (ac.length > 0) {
                var flag:Boolean = true;
                for each(var item:Object in ac) {
                    if (CRMtool.isStringNull(mainValue[item.ccomefield])) {
                        flag = false;
                        break;
                    }
                }
                if (flag)
                    onNext();
                else
                    CRMtool.showAlert("工作流涉及的单据人员不存在，无法提交工作流。");
            } else {
                onNext();
            }
        }, sql, null, false);
    }


}
}