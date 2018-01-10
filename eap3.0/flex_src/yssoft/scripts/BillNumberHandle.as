import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.collections.ArrayList;
import mx.rpc.events.ResultEvent;

import yssoft.business.AcNumberHandleClass;
import yssoft.tools.CRMtool;

/*

 YJ Add 2012-04-01 单据编码管理的脚本,注入在 CrmEapRadianVbox.mxml中

 */

[Bindable]
public var nFieldsArr:ArrayCollection;


/*
 flag
 0:新增
 1:保存
 */
public function onGetNumber(flag:int = 0):void {

    //有几个字段参与了编码管理
    if (null == nFieldsArr) {
        nFieldsArr = new ArrayCollection();
        nFieldsArr = onGetFieldsByCoding();//参与编码管理的字段信息

    }
    //wxh add 再次刷新参照编码字段值
    onReSetnFieldsArr();
//	if(flag == 0){
//		//遍历参与单据编码管理的字段数据集，分析参照的默认值(有默认值的要获取该字段对应的值)
//		for(var i:int=0;i<nFieldsArr.length;i++){
//			
//			var objitem:Object = {};
//			objitem = nFieldsArr.getItemAt(i);
//			
//			if(objitem.fdefaultvalue != ""){
//				this.addEventListener("numberEvent",onNumberEvent);//一旦默认值不为空，即执行参照的翻译，并获取其值
//				return;
//			}
//			
//		}
//		
//		//另外点击参与编码前缀的参照时调用编码方案
//		if(this.numFlag == 0){
//			this.addEventListener("numberEvent",onNumberEvent);//一旦默认值不为空，即执行参照的翻译，并获取其值
//			return;
//		}
//	}
    isSave = flag == 1 ? true : false;

    if (this.curButtonStatus == "onNew")
        onExecBillNumber();

}

//执行单据编码操作
private function onExecBillNumber():void {

    this.billnumber.nfields = nFieldsArr;
    this.billnumber.bnumber = this.vouch.bnumber == true ? 1 : 0;//当前业务单据是否参与单据编码管理
    this.billnumber.ifuncregedit = this.vouch.ifuncregedit;//当前业务单据对应的注册码
    this.billnumber.ctable = this.paramForm.winParam.ctable;//当前业务单据对应的表名
    this.billnumber.crmEapRadianVbox = this;
    this.billnumber.isSave = this.isSave;//是否保存单据编码

    this.billnumber.onGetBillNumber();

}


//监听参照翻译后的操作
public function onNumberEvent(event:Event):void {

    if (this.numbercount == nFieldsArr.length) {

        //赋值于参与单据编码管理的数据集合
        onReSetnFieldsArr();

        //初始化参数
        this.billnumberArr = new ArrayCollection();
        this.numbercount = 0;
        this.numFlag = 1;
    }

}

//重新给  参与单据编码管理的数据集(nFieldsArr--fieldvalue) 赋值
private function onReSetnFieldsArr():void {

    if (null == this.billnumberArr || this.billnumberArr.length == 0) return;

    for (var i:int = 0; i < nFieldsArr.length; i++) {//参与单据编码管理的数据集，未翻译的

        var nfObj:Object = nFieldsArr.getItemAt(i);
        var nfield:String = nfObj.cfield;

        for (var j:int = 0; j < this.billnumberArr.length; j++) {//参照翻译后的数据集

            var bnObj:Object = this.billnumberArr.getItemAt(j);
            var bnfield:String = bnObj.curField;
            var bnvalue:String = bnObj.curValue;

            if (nfield == bnfield)
                nfObj.fieldvalue = bnvalue;

        }

    }

}


/*
 获取参与编码管理的字段集合
 */
private function onGetFieldsByCoding():ArrayCollection {

    var rvalue:ArrayCollection = new ArrayCollection();

    try {

        var vfArr:ArrayList = this.vouchFormArr;//页面所有元素
        if (vfArr == null || vfArr.length == 0) return null;

        for (var i:int = 0; i < vfArr.length; i++) {

            var vfObj:Object = {};
            var childMapArr:ArrayCollection = new ArrayCollection();

            vfObj = vfArr.getItemAt(i);


            childMapArr = vfObj.childMap as ArrayCollection;//一组中包含字段的详细信息
            if (childMapArr == null) {
                continue;
            }
            if (childMapArr.length > 0) {

                for (var j:int = 0; j < childMapArr.length; j++) {

                    var childMapObj:Object = childMapArr.getItemAt(j);
                    if (childMapObj.bprefix == true) {//参与编码管理

                        var fObj:Object = {};
                        fObj.cfield = childMapObj.cfield;//字段
                        fObj.fieldvalue = "";//值
                        fObj.fdefaultvalue = childMapObj.cnewdefault == null ? "" : childMapObj.cnewdefault;//默认值

                        rvalue.addItem(fObj);//加入参与编码管理的字段

                    }

                }
            }

        }

    } catch (e:Error) {
        //CRMtool.tipAlert("错误原因:"+e.message);
    }

    return rvalue;

}

/*
 参与编码管理的字段赋值
 param:
 1、参与编码管理的字段集合
 2、单据中所有参照项的集合
 */
private function onGetnFieldsAllArr(nFieldsArr:ArrayCollection, nFieldsValueArr:ArrayCollection):ArrayCollection {

    for (var i:int = 0; i < nFieldsArr.length; i++) {

        var fieldObj:Object = {};
        var nfield:String = "";//参与编码管理的字段
        fieldObj = nFieldsArr.getItemAt(i);
        nfield = fieldObj.nfield + "";

        for (var j:int = 0; j < nFieldsValueArr.length; j++) {

            var fieldAllObj:Object = {};
            var afield:String = "";//参照字段
            var avalue:String = "";//字段对应的值
            fieldAllObj = nFieldsValueArr.getItemAt(j);
            afield = fieldAllObj.nfield + "";
            avalue = fieldAllObj.nvalue + "";

            if (nfield == afield) {
                fieldObj.nvalue = avalue;
                nFieldsValueArr.removeItemAt(j);
                break;
            }
        }

    }

    return nFieldsArr;

}


public function onClear():void {

    if (nFieldsArr == null || nFieldsArr.length == 0) return;

    for (var i:int = 0; i < nFieldsArr.length; i++) {

        var nfObj:Object = nFieldsArr.getItemAt(i);
        nfObj.fieldvalue = "";
    }
}
