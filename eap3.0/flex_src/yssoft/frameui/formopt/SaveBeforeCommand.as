package yssoft.frameui.formopt {
import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.collections.ArrayList;
import mx.core.Container;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;

import yssoft.comps.frame.module.CrmEapRadianVbox;
import yssoft.impls.ICommand;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;

public class SaveBeforeCommand extends BaseCommand {
    //获得用户输入值
    private var paramObj:Object;
    //获得规则
    [Bindables]
    private var ruleObj:ArrayList;

    //传递的参数
    private var param:Object;

    public function SaveBeforeCommand(context:Container, optType:String = "", param:* = null, nextCommand:ICommand = null, excuteNextCommand:Boolean = false) {
        this.param = param;
        ruleObj = param.ruleObj as ArrayList;
        super(context, optType, param, nextCommand, excuteNextCommand);
    }

    override public function onExcute():void {

        (context as CrmEapRadianVbox).addEventListener("resultSucc", resultSucc);
        if (isNotNull()) {
            if (context.vouch.bnumber == true && param.curButtonStatus == "onNew") {
                //YJ Add 2012-04-07 单据编码
                context.isSave = true;//保存数据时要保存单据编码。将新生成的单据编码赋值到当前单据
                context.onGetNumber(1);
            }
            else {
                context.isUnique();
            }
        }
    }

    public function resultSucc(event:Event):void {
        if ((context as CrmEapRadianVbox).isSaveFirst) {
            this.param.value = (context as CrmEapRadianVbox).getValue();
            (context as CrmEapRadianVbox).isSaveFirst = false;
            this.onNext();
        }
        //lr add
        (context as CrmEapRadianVbox).removeEventListener("resultSucc", resultSucc);
    }

    override public function onResult(result:*):void {

    }

    //非空验证
    private function isNotNull():Boolean {
        var cou:int = this.ruleObj.length;
        var tableChildArr:ArrayCollection;
        for (var i:int = 0; i < cou; i++) {
            var item:Object = ruleObj.getItemAt(i);
            //验证子表里面的东西
            if (item.childMap.hasOwnProperty("taleChild")) {
                var tableName:String = item.childMap.ccaption;
                if(CRMtool.isStringNull(tableName))
                    tableName="";
                else
                    tableName=" <"+tableName+"> ";

                var childTableObj:ArrayCollection = item.childMap.taleChild as ArrayCollection;
                //找到表体的具体内容
                for each(var item3:Object in childTableObj) {
                    var ctype2:String = item3.ctype;
                    //找到表体中的内容
                    var childList:ArrayCollection = param.value[item3.ctable] as ArrayCollection;
                    //验证表中记录是否为空 lr
                    if(Boolean(item.childMap.bunnull)&&(childList==null||childList.length==0)){
                        CRMtool.tipAlert(tableName+"表中记录不能为空");
                        return false;
                    }
                    //验证表中数据中某一列，数据是否为空
                    if (Boolean(item3.bunnull)) {
                        if (null != childList && childList.length > 0) {
                            for (var o:int = 0; o < childList.length; o++) {
                                var childObj:Object = childList.getItemAt(o);
                                var value:String = childObj[item3.cfield];
                                var cfield:String = item3.cfield + "_enabled";
                                var cfield1:String = item3.cfield + "_Name_enabled";
                                if ((childObj.hasOwnProperty(cfield) && childObj[cfield] == -1) || (childObj.hasOwnProperty(cfield1) && childObj[cfield1] == -1)) {
                                    continue;
                                }
                                if (!isNotNullByCfield(ctype2, value, item3.ccaption, item3.idecimal)) {

                                    CRMtool.tipAlert(tableName+"表中" + "第" + int(o + 1) + "行的 <" + item3.ccaption + "> 不能为空");
                                    return false;
                                }
                            }
                        }
                    }
                }
            }
            //验证主表里面的东西
            else {
                var valueArr:ArrayCollection = item.childMap as ArrayCollection;

                for each(var item2:Object in valueArr) {
                    var ctype:String = item2.ctype;
                    if (Boolean(item2.bunnull)) {
						if(Boolean(item2.bmain))
						{
	                        var value1:String = this.param.value[item2.cfield];
	                        if (!isNotNullByCfield(ctype, value1, item2.ccaption, item2.idecimal)) {
	                            CRMtool.tipAlert(item2.ccaption + "不能为空");
	                            return false;
	                        }
						}
						else
						{
							var childList:ArrayCollection = param.value[item2.ctable] as ArrayCollection;
							if(childList.length>0)
							{
								var value2:String = childList.getItemAt(0)[item2.cfield];
								if (!isNotNullByCfield(ctype, value2, item2.ccaption, item2.idecimal)) {
									CRMtool.tipAlert(item2.ccaption + "不能为空");
									return false;
								}
							}
							else
							{
								CRMtool.tipAlert(item2.ccaption + "不能为空");
								return false;
							}
						}
					}
                }
            }
        }
        return true;
    }

    //非空判断
    private function isNotNullByCfield(ctype:String, value:String, ccaption:String, idecimal:int, ctable:String = null, count:int = 0):Boolean {
        switch (ctype) {
            case "int":
            {
                if (value == null || value == "") {
                    return false;
                }
                break;
            }
            case "datetime":
            {
                if (value == null || value == "") {
                    return false;
                }
                break;
            }
            case "nvarchar":
            {
                if (value == null || value == "") {
                    return false;
                }
                break;
            }
            case "float":
            {
                /*
                var number:Number = 0;
                if (value == null || StringUtil.trim(value) == "" || value == number.toFixed(idecimal)) {
                    return false;
                }*/
                // lr modify
                if (value == null || StringUtil.trim(value) == "") {
                    return false;
                }
                break;
            }
        }
        return true;
    }

    //唯一约束验证
    private function isUnique():void {
        AccessUtil.remoteCallJava("CommonalityDest", "isUnique", isUniqueBack, this.param, null, false);
    }

    public function isUniqueBack(event:ResultEvent):void {
        if (event.result != null) {
            CRMtool.tipAlert(event.result.toString());
        }
        else {
            //YJ Add 2012-04-07 单据编码
            context.isSave = true;//保存数据时要保存单据编码。将新生成的单据编码赋值到当前单据
            context.onGetNumber(1);

            this.onNext();
        }
    }
}
}