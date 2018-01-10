/**
 * Created with IntelliJ IDEA.
 * User: aruis
 * Date: 13-11-22
 * Time: 下午3:05
 * To change this template use File | Settings | File Templates.
 */
package yssoft.scripts.selfoptimp {
import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.utils.ObjectUtil;

import yssoft.comps.frame.module.CrmEapRadianVbox;
import yssoft.comps.frame.module.CrmEapTextInput;
import yssoft.renders.DGConsultTextInput;
import yssoft.tools.CRMtool;

public class ConsultRelated {
    public function ConsultRelated() {
    }

    public function doConsultBefore(singleType:Object, text:CrmEapTextInput, crmeap:CrmEapRadianVbox, next:Function) {

        if (crmeap != null && this.hasOwnProperty("before_" + crmeap.formIfunIid + "_" + text.crmName)) {
            this["before_" + crmeap.formIfunIid + "_" + text.crmName](singleType, text, crmeap, next);
        } else {
            next.call();
        }

    }

    public function doConsultAfter(consultList:ArrayCollection, singleType:Object, text:CrmEapTextInput, crmeap:CrmEapRadianVbox, isSuccess:Boolean = true) {
        if (crmeap != null && this.hasOwnProperty("after_" + crmeap.formIfunIid + "_" + text.crmName)) {
            this["after_" + crmeap.formIfunIid + "_" + text.crmName](consultList, singleType, text, crmeap, isSuccess);
        } else if (isSuccess && text.owner is DGConsultTextInput && consultList.length > 1) {
            var dgtext:DGConsultTextInput = text.owner as DGConsultTextInput;
            var ac:ArrayCollection = dgtext.grid.dataProvider as ArrayCollection;

            var i:int = 1;
            for each(var item:Object in consultList) {
                _do(ac.getItemIndex(dgtext.data) + i - 2);

                function _do(index:int):void {
                    index++;
                    var data = new Object();
                    var isNull:Boolean = true;
                    if (index < ac.length) {
                        data = ac.getItemAt(index);
                        var objInfo:Object = ObjectUtil.getClassInfo(data);
                        var fieldName:Array = objInfo["properties"] as Array;
                        for each(var q:QName in fieldName) {
                            //q.localName 属性名称，value对应的值
                            if (q.localName != "sort_id" && q.localName != "mx_internal_uid" && q.localName != "checked" && q.localName != "doCalculate" && q.localName != "ino" && CRMtool.isStringNotNull(data[q.localName])) {
                                isNull = false;
                                break;
                            }
                        }
                    }

                    if (isNull || i == 1) {
                        data[text.cfield] = item[singleType.cconsultbkfld];
                        data[text.cfield+"_Name"] = item[singleType.cconsultswfld];
                        data.doCalculate = true;

                        if (index < ac.length) {
                            ac.setItemAt(data, index);
                        } else
                            ac.addItem(data);
                    } else {
                        _do(index)
                    }
                }

                i++;
            }
        }
    }
}
}
