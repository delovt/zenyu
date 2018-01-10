package yssoft.frameui.formopt {
import mx.collections.ArrayCollection;

import yssoft.comps.frame.module.CrmEapDataGrid;
import yssoft.impls.ICommand;

public class DeleteAllDataGridingCommand extends BaseCommand {
    public function DeleteAllDataGridingCommand(context:CrmEapDataGrid, optType:String = "", param:* = null, nextCommand:ICommand = null, excuteNextCommand:Boolean = false) {
        super(context, optType, param, nextCommand, excuteNextCommand);
    }

    override public function onExcute():void {
        context["tableList"].removeAll();
        context["dataProvider"] = context["tableList"];
        deleteChildData(context as CrmEapDataGrid);
        this.onNext();
    }

    public function deleteChildData(context:CrmEapDataGrid):void {
        var tableMessage:ArrayCollection = new ArrayCollection();
        if (context.paramForm.paramForm.hasOwnProperty("crmeap")) {
            tableMessage = context.paramForm.paramForm.crmeap.tableMessage;//表之间关系
        } else {
            tableMessage = context.paramForm.tableMessage;
        }
        var currDGridName:Object = context.ctableName;//当前表名
        var ctable2:String = "";
        var ctable:String = "";
        var l:int = tableMessage.length;
        for (var i:int = 0; i < l; i++) {
            if (!tableMessage.getItemAt(i).bMain && tableMessage.getItemAt(i).ctable2 == currDGridName) {
                ctable2 = currDGridName.toString();
                ctable = tableMessage.getItemAt(i).ctable as String;//子表表名
                for each(var dg:CrmEapDataGrid in context.paramForm.paramForm.crmeap.gridList) {
                    if (dg.ctableName == ctable) {
                        dg["tableList"].removeAll();
                        dg["dataProvider"] = dg["tableList"];
                        dg["all_tableList"] = dg["tableList"];
                        break;
                    }
                }
            }
        }
    }
}
}