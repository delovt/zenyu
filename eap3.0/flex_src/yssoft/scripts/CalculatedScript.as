import mx.collections.ArrayCollection;
import mx.core.UIComponent;
import mx.rpc.events.ResultEvent;
import mx.utils.ObjectUtil;

import yssoft.comps.frame.module.CrmEapDataGrid;
import yssoft.comps.frame.module.CrmEapRadianVbox;
import yssoft.comps.frame.module.CrmEapTextInput;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;

public var cfunctionObjArr:ArrayCollection;

//传入表体公式
public var subCfunctionObjArr:ArrayCollection;

//约束公式
private var cresfunctionArr:ArrayCollection;

public var messageArr:ArrayCollection = new ArrayCollection();

private var isError:Boolean = false;

private var errorTip:String = "";

private var countNum:int = 0;//修改参照上配计算公式时，不停刷新的bug

//初始化参照公式
private function resolveFormula():void {
    cfunctionObjArr = new ArrayCollection();
    subCfunctionObjArr = new ArrayCollection();
    cfunctionList = new ArrayCollection();

    cresfunctionArr = new ArrayCollection();

    var functionObj:Object = getFunction();
    //存放公式
    var cfunctionArr:ArrayCollection = functionObj.cfunctionArr as ArrayCollection;
    getCfunctionValue(cfunctionArr);

    //存放约束公式
    var cresfunctionObjArr:ArrayCollection = functionObj.cresfunctionObjArr as ArrayCollection;
    getCresfunction(cresfunctionObjArr);
}

//取出约束公式和计算公式
private function getFunction():Object {
    var functionObj:Object = new Object();
    //存放公式
    var cfunctionArr:ArrayCollection = new ArrayCollection();
    functionObj.cfunctionArr = cfunctionArr;
    //存放约束公式
    var cresfunctionObjArr:ArrayCollection = new ArrayCollection();
    functionObj.cresfunctionObjArr = cresfunctionObjArr;
    //先取出所有信息

    //lr add
    if (!_vouchFormArr)
        return null;

    for (var i:int = 0; i < this._vouchFormArr.length; i++) {
        var datadictionaryObj:Object = this._vouchFormArr.getItemAt(i);
        //表头公式
        if (datadictionaryObj.childMap is ArrayCollection) {
            var childList:ArrayCollection = datadictionaryObj.childMap as ArrayCollection;
            for each(var item:Object in childList) {
                //计算公式
                var cfunction:String = item.cfunction;
                if (cfunction != null && cfunction != "") {
                    cfunctionList.addItem({cfunction: cfunction, isHead: Boolean(item.bmain), triggerfield: item.cfield, triggertable: item.ctable});
                    var cfunctionStrArr:Array = cfunction.split("|");
                    for (var h:int = 0; h < cfunctionStrArr.length; h++) {
                        var cfunctionStr:String = cfunctionStrArr[h];
                        if (null != cfunctionStr && cfunctionStr != "") {
                            var cfunctionObj:Object = new Object();

                            cfunctionObj.cfield = cfunctionStr.split("=")[0];
                            cfunctionObj.ctype = item.ctype;
                            cfunctionObj.ctable = item.ctable;
                            cfunctionObj.cfunction = cfunctionStr.substr(cfunctionStr.indexOf("=") + 1, cfunctionStr.length);
                            cfunctionObj.triggerfield = item.cfield;//YJ Add 触发字段(真正计算时用到)
                            cfunctionObj.triggertable = item.ctable;
                            cfunctionObj.isHead = Boolean(item.bmain);
                            cfunctionArr.addItem(cfunctionObj);
                        }
                    }
                }
                //约束公式
                var cresfunction:String = item.cresfunction;
                if (cresfunction != null && cresfunction != "") {
                    var cresfunctionObj:Object = new Object();
                    cresfunctionObj.cresfunction = cresfunction;
                    cresfunctionObj.cresmessage = item.cresmessage;
                    cresfunctionObj.isHead = Boolean(item.bmain);
                    cresfunctionObj.ctable = item.ctable;
                    cresfunctionObj.triggerfield = item.cfield;//YJ Add 触发字段(真正计算时用到)
                    cresfunctionObj.triggertable = item.ctable;
                    cresfunctionObjArr.addItem(cresfunctionObj);
                }
            }
        }
        //表体公式
        else {
            var childMap:Object = datadictionaryObj.childMap;
            var taleChildArr:ArrayCollection = childMap.taleChild as ArrayCollection;
            for each(var taleChild:Object in taleChildArr) {
                //计算公式
                var cfunction:String = taleChild.cfunction;
                if (cfunction != null && cfunction != "") {
                    cfunctionList.addItem({cfunction: cfunction, isHead: false, triggerfield: taleChild.cfield, triggertable: taleChild.ctable});
                    var cfunctionStrArr:Array = cfunction.split("|");
                    for (var h:int = 0; h < cfunctionStrArr.length; h++) {
                        var cfunctionStr:String = cfunctionStrArr[h];
                        var strArrs:Array = cfunctionStr.split("=");
                        if (null != cfunctionStr && cfunctionStr != "") {
                            var cfunctionObj:Object = new Object();
                            var str:String = strArrs[0];
                            if (str.indexOf(".") != -1) {
                                var strs:Array = str.split(".");
                                cfunctionObj.cfield = strs[1];
                                cfunctionObj.ctype = taleChild.ctype;
                                cfunctionObj.ctable = strs[0];
                            }
                            else {
                                cfunctionObj.cfield = str;
                                cfunctionObj.ctype = taleChild.ctype;
                                cfunctionObj.ctable = taleChild.ctable;
                            }
                            cfunctionObj.cfunction = cfunctionStr.substr(cfunctionStr.indexOf("=") + 1, cfunctionStr.length);
                            cfunctionObj.isHead = false;
                            cfunctionObj.triggerfield = taleChild.cfield;//YJ Add 触发字段(真正计算时用到)
                            cfunctionObj.triggertable = taleChild.ctable;
                            cfunctionArr.addItem(cfunctionObj);
                        }
                    }
                }
                //约束公式
                var cresfunction:String = taleChild.cresfunction;
                var cresmessage:String = taleChild.cresmessage;
                if (cresfunction != null && cresfunction != "") {
                    var cresfunctionObj:Object = new Object();
                    cresfunctionObj.cresfunction = cresfunction;
                    cresfunctionObj.cresmessage = cresmessage;
                    cresfunctionObj.isHead = false;
                    cresfunctionObj.ctable = taleChild.ctable;
                    cresfunctionObj.triggerfield = taleChild.cfield;//YJ Add 触发字段(真正计算时用到)
                    cresfunctionObj.triggertable = taleChild.ctable;
                    cresfunctionObjArr.addItem(cresfunctionObj);
                }
            }
        }
    }
    return functionObj;
}

//取出要参与公式运算的值
private function getCfunctionValue(cfunctionArr:ArrayCollection):void {
    //取出要参与公式运算的值
    for (var l:int = 0; l < cfunctionArr.length; l++) {
        var _cfunctionObj:Object = cfunctionArr.getItemAt(l);
        var cfunctionstr:String = _cfunctionObj.cfunction;
        var triggerfield:String = _cfunctionObj.triggerfield;
        var triggertable:String = _cfunctionObj.triggertable;
        var cfields:ArrayCollection = new ArrayCollection();

        //获得公式的信息
        var paramObj:Object = new Object();
        var cfield:String = _cfunctionObj.cfield;
        //判断给谁赋值
        if (cfield.indexOf(".") != -1) {
            var cfieldStrs:Array = cfield.split(".");
            //要赋值的字段
            paramObj.cfield = cfieldStrs[1];
            paramObj.ctable = cfieldStrs[0];
        }
        else {
            //要赋值的字段
            paramObj.cfield = _cfunctionObj.cfield;
            paramObj.ctable = _cfunctionObj.ctable;
        }
        //公式
        paramObj.cfunction = cfunctionstr;
        paramObj.cfieldValue = "";

        //YJ Add
        paramObj.triggerfield = triggerfield;//触发字段
        paramObj.triggertable = triggertable;

        //判断该公式是表头调用还是表体调用
        var isHead:Boolean = Boolean(_cfunctionObj.isHead);

        //如果是表头调用
        if (isHead) {
            //判断是否调用子表的公式
            if (cfunctionstr.indexOf("getcol") != -1) {
                var cfunctionstrArr:Array = cfunctionstr.split("@");
                for (var j:int = 0; j < cfunctionstrArr.length; j++) {
                    var cunStr:String = cfunctionstrArr[j];
                    if (cunStr == "" || null == cunStr || cunStr.indexOf("getcol") == -1) {
                        continue;
                    }
                    var cfunctiStr:String = cunStr.substring(0, Number(cunStr.indexOf(")") + 1));
                    /*********************** 往子界面表格赋值 *************************************/
                    var subParamObj:Object = new Object();
                    if (cfunctiStr.indexOf("getcolsum") != -1) {
                        subParamObj.flag = "1";
                    }
                    else if (cfunctiStr.indexOf("getcolavg") != -1) {
                        subParamObj.flag = "2";
                    }
                    else if (cfunctiStr.indexOf("getcolmax") != -1) {
                        subParamObj.flag = "3";
                    }
                    else if (cfunctiStr.indexOf("getcolmin") != -1) {
                        subParamObj.flag = "4";
                    }
                    subParamObj.operation = cfunctiStr;
                    subParamObj.param = cfunctiStr.substring(Number(cfunctiStr.indexOf("(") + 1), cfunctiStr.indexOf(")"));
                    subParamObj.funname = subTableAssignment;
                    this.subCfunctionObjArr.addItem(subParamObj);
                    /************************************************************/
                    var cfieObj:Object = new Object();
                    cfieObj.cfield = cfunctiStr;
                    cfieObj.value = 0;
                    cfieObj.idatatype = 1;
                    cfieObj.ctype = "float";
                    var cfis:Array = cfunctiStr.split("(");
                    var s:String = cfis[1];
                    var ss:Array = s.split(")");
                    var sss:String = ss.splice(".");
                    cfieObj.ctable = sss[0];
                    cfields.addItem(cfieObj);
                }
            }
            //表头本身计算
            for (var i:int = 0; i < this._vouchFormArr.length; i++) {
                var datadictionaryObj:Object = this._vouchFormArr.getItemAt(i);
                //表头公式
                if (datadictionaryObj.childMap is ArrayCollection) {
                    var childList:ArrayCollection = datadictionaryObj.childMap as ArrayCollection;
                    for each(var item:Object in childList) {
                        var cfieldStr:String = item.cfield;

                        //判断公式里面是否存在该字段
                        if (cfunctionstr.indexOf("@" + cfieldStr + "@") != -1) {
                            var cfieldObj:Object = new Object();
                            cfieldObj.cfield = cfieldStr;
                            cfieldObj.ctable = "";
                            cfieldObj.ctype = item.ctype;
                            switch (item.ctype) {
                                case "int":
                                {
                                    cfieldObj.value = 0;
                                    break;
                                }
                                case "nvarchar":
                                {
                                    cfieldObj.value = "";
                                    break;
                                }
                                case "float":
                                {
                                    cfieldObj.idecimal = item.idecimal;
                                    cfieldObj.value = Number("0").toFixed(int(item.idecimal));
                                    break;
                                }
                                case "datetime":
                                {
                                    cfieldObj.value = "";
                                    break;
                                }
                                case "bit":
                                {
                                    cfieldObj.value = 0;
                                    break;
                                }
                                default:
                                {
                                    break;
                                }
                            }
                            cfields.addItem(cfieldObj);
                        }
                    }
                }
            }
            var isFind:Boolean = false;
            var cctable:String = _cfunctionObj.ctable;
            for (var k:int = 0; k < this.tableMessage.length; k++) {
                var datadictionaryObj:Object = this.tableMessage.getItemAt(k);
                var ctable:String = datadictionaryObj.ctable;
                if (_cfunctionObj.ctable != "" && cctable.toLocaleUpperCase() == ctable.toUpperCase()) {
                    //判断公式里面是否存在该字段
                    if (cfunctionstr.indexOf("@" + datadictionaryObj.foreignKey + "@") != -1) {
                        var cfieldObj:Object = new Object();
                        cfieldObj.cfield = datadictionaryObj.foreignKey;
                        cfieldObj.ctable = "";
                        cfieldObj.ctype = "int";
                        cfields.addItem(cfieldObj);
                    }
                }
                if (datadictionaryObj.foreignKey == "iid") {
                    isFind = true;
                }

                if (!isFind) {
                    if (Boolean(datadictionaryObj.bMain)) {
                        //判断公式里面是否存在该字段
                        if (cfunctionstr.indexOf("@" + datadictionaryObj.ctable + ".iid@") != -1) {
                            var cfieldObj:Object = new Object();
                            cfieldObj.cfield = "iid";
                            cfieldObj.ctable = datadictionaryObj.ctable;
                            cfieldObj.ctype = "int";
                            cfields.addItem(cfieldObj);
                        }

                        //判断公式里面是否存在该字段
                        if (cfunctionstr.indexOf("@iid@") != -1) {
                            var cfieldObj:Object = new Object();
                            cfieldObj.cfield = "iid";
                            cfieldObj.ctable = "";
                            cfieldObj.ctype = "int";
                            cfields.addItem(cfieldObj);
                        }
                    }
                }


            }
            /*if(null!=cfieldObj)
             {
             cfields.addItem(cfieldObj);
             }*/
        }
        else {
            //判断是否调用子表的公式
            if (cfunctionstr.indexOf("getcol") != -1) {
                var cfunctionstrArr:Array = cfunctionstr.split("@");
                for (var j:int = 0; j < cfunctionstrArr.length; j++) {
                    var cunStr:String = cfunctionstrArr[j];
                    if (cunStr == "" || null == cunStr || cunStr.indexOf("getcol") == -1) {
                        continue;
                    }
                    var cfunctiStr:String = cunStr.substring(0, Number(cunStr.indexOf(")") + 1));
                    /*********************** 往子界面表格赋值 *************************************/
                    var subParamObj:Object = new Object();
                    if (cfunctiStr.indexOf("getcolsum") != -1) {
                        subParamObj.flag = "1";
                    }
                    else if (cfunctiStr.indexOf("getcolavg") != -1) {
                        subParamObj.flag = "2";
                    }
                    else if (cfunctiStr.indexOf("getcolmax") != -1) {
                        subParamObj.flag = "3";
                    }
                    else if (cfunctiStr.indexOf("getcolmin") != -1) {
                        subParamObj.flag = "4";
                    }
                    subParamObj.operation = cfunctiStr;
                    subParamObj.param = cfunctiStr.substring(Number(cfunctiStr.indexOf("(") + 1), cfunctiStr.indexOf(")"));
                    subParamObj.funname = subTableAssignment;
                    this.subCfunctionObjArr.addItem(subParamObj);
                    /************************************************************/
                    var cfieObj:Object = new Object();
                    cfieObj.cfield = cfunctiStr;
                    cfieObj.value = 0;
                    cfieObj.idatatype = 1;
                    cfieObj.ctable = "";
                    cfieObj.ctype = "float";
                    cfields.addItem(cfieObj);
                }
            }
            for (var k:int = 0; k < this.tableMessage.length; k++) {
                var datadictionaryObj:Object = this.tableMessage.getItemAt(k);
                if (_cfunctionObj.ctable != "" && datadictionaryObj.ctable == _cfunctionObj.ctable) {
                    //判断公式里面是否存在该字段
                    if (cfunctionstr.indexOf("@" + datadictionaryObj.foreignKey + "@") != -1) {
                        var cfieldObj:Object = new Object();
                        cfieldObj.cfield = datadictionaryObj.foreignKey;
                        cfieldObj.ctable = "";
                        cfieldObj.ctype = "int";
                        cfields.addItem(cfieldObj);
                    }
                }

                if (Boolean(datadictionaryObj.bMain)) {
                    //判断公式里面是否存在该字段
                    if (cfunctionstr.indexOf("@" + datadictionaryObj.ctable + ".iid@") != -1) {
                        var cfieldObj:Object = new Object();
                        cfieldObj.cfield = "iid";
                        cfieldObj.ctable = datadictionaryObj.ctable;
                        cfieldObj.ctype = "int";
                        cfields.addItem(cfieldObj);
                    }

                    //判断公式里面是否存在该字段
                    if (cfunctionstr.indexOf("@iid@") != -1) {
                        var cfieldObj:Object = new Object();
                        cfieldObj.cfield = "iid";
                        cfieldObj.ctable = "";
                        cfieldObj.ctype = "int";
                        cfields.addItem(cfieldObj);
                    }
                }

            }

            //表头本身计算
            for (var i:int = 0; i < this._vouchFormArr.length; i++) {
                var datadictionaryObj:Object = this._vouchFormArr.getItemAt(i);
                //表体调用表头的值
                if (datadictionaryObj.childMap is ArrayCollection) {
                    var childList:ArrayCollection = datadictionaryObj.childMap as ArrayCollection;
                    for each(var item:Object in childList) {
                        var cfieldStr:String = item.cfield;
                        var ctableStr:String = item.ctable;
                        //判断公式里面是否存在该字段
                        if (cfunctionstr.indexOf("@" + ctableStr + "." + cfieldStr + "@") != -1) {
                            var cfieldObj:Object = new Object();
                            cfieldObj.cfield = cfieldStr;
                            cfieldObj.ctable = ctableStr;
                            cfieldObj.ctype = item.ctype;

                            switch (item.ctype) {
                                case "int":
                                {
                                    cfieldObj.value = 0;
                                    break;
                                }
                                case "nvarchar":
                                {
                                    cfieldObj.value = "";
                                    break;
                                }
                                case "float":
                                {
                                    cfieldObj.idecimal = item.idecimal;
                                    cfieldObj.value = Number("0").toFixed(int(item.idecimal));
                                    break;
                                }
                                case "datetime":
                                {
                                    cfieldObj.value = "";
                                    break;
                                }
                                case "bit":
                                {
                                    cfieldObj.value = 0;
                                    break;
                                }
                                default:
                                {
                                    break;
                                }
                            }
                            cfields.addItem(cfieldObj);
                        }
                    }
                }

                if (!(datadictionaryObj.childMap is ArrayCollection)) {
                    //查询表体里面的信息
                    var childMap:Object = datadictionaryObj.childMap;
                    var taleChildArr:ArrayCollection = childMap.taleChild as ArrayCollection;
                    for each(var taleChild:Object in taleChildArr) {
                        if (String(taleChild.ctable).toLocaleUpperCase() == String(_cfunctionObj.ctable).toUpperCase()) {
                            var cfieldStr:String = taleChild.cfield;
                            //判断公式里面是否存在该字段
                            if (cfunctionstr.indexOf("@" + cfieldStr + "@") != -1 || cfunctionstr.toLocaleUpperCase().indexOf("@" + String(_cfunctionObj.ctable).toUpperCase()
                                    + "." + cfieldStr + "@") != -1) {
                                var cfieldObj:Object = new Object();
                                cfieldObj.cfield = cfieldStr;
                                cfieldObj.ctable = "";
                                cfieldObj.ctype = taleChild.ctype;

                                switch (taleChild.ctype) {
                                    case "int":
                                    {
                                        cfieldObj.value = 0;
                                        break;
                                    }
                                    case "nvarchar":
                                    {
                                        cfieldObj.value = "";
                                        break;
                                    }
                                    case "float":
                                    {
                                        cfieldObj.idecimal = item.idecimal;
                                        cfieldObj.value = Number("0").toFixed(int(item.idecimal));
                                        break;
                                    }
                                    case "datetime":
                                    {
                                        cfieldObj.value = "";
                                        break;
                                    }
                                    case "bit":
                                    {
                                        cfieldObj.value = 0;
                                        break;
                                    }
                                    default:
                                    {
                                        break;
                                    }
                                }
                                cfields.addItem(cfieldObj);
                            }

                        }
                    }
                }
            }
        }
        paramObj.cfields = cfields;
        cfunctionObjArr.addItem(paramObj);
    }
}

//取出约束公式
private function getCresfunction(cresfunctionObjArr:ArrayCollection):void {
    //取出约束公式
    for (var p:int = 0; p < cresfunctionObjArr.length; p++) {
        var cresfunctionParamObj:Object = cresfunctionObjArr.getItemAt(p);
        var cresfunctionStr:String = cresfunctionParamObj.cresfunction;
        var cresmessageStr:String = cresfunctionParamObj.cresmessage;
        var triggerfield:String = cresfunctionParamObj.triggerfield;
        var triggertable:String = cresfunctionParamObj.triggertable;
        //找出参与预算的字段
        var cfieldArr:ArrayCollection = new ArrayCollection();

        //获得公式的信息
        var paramObject:Object = new Object();
        //公约束式
        paramObject.cresfunction = cresfunctionStr;
        paramObject.cresmessage = cresmessageStr;
        paramObject.triggerfield = triggerfield;
        paramObject.triggertable = triggertable;

        var yscfields:ArrayCollection = new ArrayCollection();

        //判断该公式是表头调用还是表体调用
        var isHead:Boolean = Boolean(cresfunctionParamObj.isHead);
        paramObject.isHead = isHead;
        //如果是表头调用
        //表头本身计算
        for (var i:int = 0; i < this._vouchFormArr.length; i++) {
            var datadictionaryObj:Object = this._vouchFormArr.getItemAt(i);
            if (isHead) {
                //表头公式
                if (datadictionaryObj.childMap is ArrayCollection) {
                    var childList:ArrayCollection = datadictionaryObj.childMap as ArrayCollection;
                    for each(var item:Object in childList) {
                        if (cresfunctionStr.indexOf("@" + item.cfield + "@") != -1) {
                            var cfieldObject:Object = new Object();
                            cfieldObject.cfield = item.cfield;
                            cfieldObject.ctype = item.ctype;
                            cfieldObject.ctable = item.ctable;
                            cfieldArr.addItem(cfieldObject);
                            switch (item.ctype) {
                                case "int":
                                {
                                    cfieldObject.value = 0;
                                    break;
                                }
                                case "nvarchar":
                                {
                                    cfieldObject.value = "";
                                    break;
                                }
                                case "float":
                                {
                                    cfieldObject.value = Number("0").toFixed(int(item.idecimal));
                                    break;
                                }
                                case "datetime":
                                {
                                    cfieldObject.value = "";
                                    break;
                                }
                                case "bit":
                                {
                                    cfieldObject.value = 0;
                                    break;
                                }
                                default:
                                {
                                    break;
                                }
                            }
                            yscfields.addItem(cfieldObject);
                        }
                    }
                    paramObject.cfields = yscfields;
                    cresfunctionArr.addItem(paramObject);
                }
            }
            else {
                if (!(datadictionaryObj.childMap is ArrayCollection)) {
                    //查询表体里面的信息
                    var childMap:Object = datadictionaryObj.childMap;
                    var taleChildArr:ArrayCollection = childMap.taleChild as ArrayCollection;
                    for each(var taleChild:Object in taleChildArr) {
                        if (taleChild.ctable == cresfunctionParamObj.ctable) {
                            var cfieldStr:String = taleChild.cfield;

                            if (cresfunctionParamObj.cresfunction.indexOf("@iid@") != -1) {
                                var cfieldObj:Object = new Object();
                                cfieldObj.cfield = "iid";
                                cfieldObj.ctable = taleChild.ctable;
                                cfieldObj.ctype = taleChild.ctype;
                                cfieldObj.value = 0;
                                yscfields.addItem(cfieldObj);
                            }
                            //判断公式里面是否存在该字段
                            if (cresfunctionParamObj.cresfunction.indexOf("@" + cfieldStr + "@") != -1) {
                                var cfieldObj:Object = new Object();
                                cfieldObj.cfield = cfieldStr;
                                cfieldObj.ctable = taleChild.ctable;
                                cfieldObj.ctype = taleChild.ctype;

                                switch (taleChild.ctype) {
                                    case "int":
                                    {
                                        cfieldObj.value = 0;
                                        break;
                                    }
                                    case "nvarchar":
                                    {
                                        cfieldObj.value = "";
                                        break;
                                    }
                                    case "float":
                                    {
                                        cfieldObj.idecimal = taleChild.idecimal;
                                        cfieldObj.value = Number("0").toFixed(int(taleChild.idecimal));
                                        break;
                                    }
                                    case "datetime":
                                    {
                                        cfieldObj.value = "";
                                        break;
                                    }
                                    case "bit":
                                    {
                                        cfieldObj.value = 0;
                                        break;
                                    }
                                    default:
                                    {
                                        break;
                                    }
                                }
                                yscfields.addItem(cfieldObj);
                            }
                        }
                    }
                    paramObject.cfields = yscfields;
                    cresfunctionArr.addItem(paramObject);
                }
                else {
                    //表头公式
                    if (datadictionaryObj.childMap is ArrayCollection) {
                        var childList:ArrayCollection = datadictionaryObj.childMap as ArrayCollection;
                        for each(var item:Object in childList) {
                            if (cresfunctionStr.indexOf("@" + item.ctable + "." + item.cfield + "@") != -1) {
                                var cfieldObject:Object = new Object();
                                cfieldObject.cfield = item.cfield;
                                cfieldObject.ctype = item.ctype;
                                cfieldObject.ctable = item.ctable;
                                cfieldArr.addItem(cfieldObject);
                                switch (item.ctype) {
                                    case "int":
                                    {
                                        cfieldObject.value = 0;
                                        break;
                                    }
                                    case "nvarchar":
                                    {
                                        cfieldObject.value = "";
                                        break;
                                    }
                                    case "float":
                                    {
                                        cfieldObject.value = Number("0").toFixed(int(item.idecimal));
                                        break;
                                    }
                                    case "datetime":
                                    {
                                        cfieldObject.value = "";
                                        break;
                                    }
                                    case "bit":
                                    {
                                        cfieldObject.value = 0;
                                        break;
                                    }
                                    default:
                                    {
                                        break;
                                    }
                                }
                                yscfields.addItem(cfieldObject);
                            }
                        }
                        paramObject.cfields = yscfields;
                        cresfunctionArr.addItem(paramObject);
                    }
                }
            }
        }
    }
}

private var obj:Object;
public var cfunctionList:ArrayCollection;//lr 存放原始公式配置
//计算公式
//后台回调的计算公式函数
function getCol(right:String, formValue:Object, list:ArrayCollection):String {
    var pattern:RegExp = /getcol[\w]{3}\([\w.]+\)/g;
    var rightsArr = right.match(pattern);

    //替换公式
    for each(var rights:String in rightsArr) {
        var funName:String = rights.substring(0, rights.indexOf("("));
        var fieldName:String = rights.substring(rights.indexOf("(") + 1, rights.indexOf(")"));

        if (fieldName.indexOf(".") > -1) {
            list = formValue[fieldName.substring(0, fieldName.indexOf("."))];
            fieldName = fieldName.substring(fieldName.indexOf(".") + 1, fieldName.length);
        }

        if (list == null)//list应必须有值
            continue;
        var min, max, avg, sum:Number;
        avg = 0;
        sum = 0;
        var i:int = 0;
        for each(var item:Object in list) {
            var value:Number = CRMtool.getNumber(item[fieldName]);
            if (i == 0) {
                min = value;
                max = value;
            }
            if (i > 0) {
                min = (value < min ? value : min);
                max = (value > max ? value : max);
            }
            sum += value;
            i++;
        }
        avg = (i == 0 ? 0 : sum / i);

        switch (funName) {
            case "getcolsum":
                right = right.replace(rights, sum);
                break;
            case "getcolavg":
                right = right.replace(rights, avg);
                break;
            case "getcolmax":
                right = right.replace(rights, max);
                break;
            case "getcolmin":
                right = right.replace(rights, min);
                break;
        }
    }

    return right;
}

function clientExecFormula(value:String, item:Object, dataObj:Object, dg:CrmEapDataGrid, backFun:Function = null):void {
    var formValue:Object = getValue();
    var itype:int = item.isHead == true ? 1 : dg != null ? 2 : 0; //1 常规主表  2 常规子表 0 特殊子表（非表格形式）
    var ctable:String = item.triggertable;
    var cfunnction:String = item.cfunction;
    while (cfunnction.indexOf("||") > -1) {
        cfunnction = cfunnction.replace("||", "$$$$");//临时替换一下，待会要用 竖线  分割
    }
    var funArr:Array = cfunnction.split("|");
    for each(var funS:String in funArr) {
        while (funS.indexOf("$$$$") > -1) {
            funS = funS.replace("$$$$", "||");
        }

        var left:String = funS.split("=")[0];
        var right:String = funS.split("=")[1];

        var pattern:RegExp = /@[\w.]+@/g;
        var rightsArr = right.match(pattern);

        //替换公式
        for each(var rights:String in rightsArr) {
            while (right.indexOf(rights) > -1) {
                var _value;
                if (rights.indexOf(".") == -1) {//当前
                    var _cfield:String = rights.substring(1, rights.length - 1);
                    if (itype == 2) {//子表
                        _value = dataObj[_cfield];
                    } else {//主表
                        _value = getTextValue(ctable, _cfield);
                    }
                } else {//非当前表,则肯定不是从子表取数
                    var _ctable = rights.substring(1, rights.indexOf("."));
                    var _cfield:String = rights.substring(rights.indexOf(".") + 1, rights.length - 1);
                    _value = getTextValue(_ctable, _cfield);
                }

                if (right.indexOf("'" + rights + "'") > -1)//有单引号，说明是取字符串
                    right = right.replace(rights, _value != null ? _value : '');
                else
                    right = right.replace(rights, CRMtool.getNumber(_value));
            }
        }

        //运算聚合函数
        right = getCol(right, formValue, dg != null ? dg.tableList : null);

        //计算结果
        var n = CRMtool.calljs("eval", right);
        //LC Add 20160224 新购合同金额小数点问题
        n = Number(n.toFixed(2));
        //赋值
        if (left.indexOf(".") == -1) {//当前表
            if (itype == 2) {//子表
                dataObj[left] = (n == Infinity ? '' : n);
                backFun.call();
            } else {//非子表
                setTextValue(ctable, left, n);
            }
        } else if (left.indexOf(".") > -1) {//非当前表
            ctable = left.substring(0, left.indexOf("."));
            left = left.substring(left.indexOf(".") + 1, left.length)

            var isNotTable:Boolean = false;
            for each(var textInput:IAllCrmInput in crmAllInputList) {
                if (textInput.ctable == ctable) {
                    isNotTable = true;
                    break;
                }
            }

            if (isNotTable)//主表
                setTextValue(ctable, left, n);
            else {//子表
                var list:ArrayCollection = formValue[ctable];
                for each(var item:Object in list) {
                    item[left] = n;
                }
                list.refresh();
            }
        }
    }
}
//计算公式
//后台回调的计算公式函数
public function subTableAssignment(cfunctiStr:String, cfunctitable:String, value:String, dataObj:Object = null, isFirst:Boolean = true, dg:CrmEapDataGrid = null, backFun:Function = null):void {
    if (!isFirst) {
        return;
    }
    isFirst = false;

    if (cfunctiStr == null && CRMtool.isStringNotNull(cfunctitable) && dg != null) {
        for each(var item:Object in CRMmodel.tableRelation) {
            if (item.ctable == cfunctitable && item.ifuncregedit == formIfunIid && CRMtool.isStringNotNull(item.cfunction)) {
                item.isHead = false;
                item.triggertable = item.ctable;
                clientExecFormula(null, item, null, dg, backFun);
                return;
            }
        }
        return;
    }

    for each(var item:Object in cfunctionList) {
        if (item.triggerfield == cfunctiStr && item.triggertable == cfunctitable) {
            if (CRMtool.isStringNotNull(item.cfunction) && (item.cfunction + "").indexOf("select ") == -1
                    && (item.cfunction + "").indexOf("dbo.") == -1
                    && (item.cfunction + "").indexOf("datediff(") == -1
                    && (item.cfunction + "").indexOf("dateadd(") == -1) {//说明不含sql语句，即可以纯在前台执行
                clientExecFormula(value, item, dataObj, dg, backFun);
                return;
            }
            break;
        }
    }

    obj = this.getValue();
    var newCfunctionObjArr:ArrayCollection = new ArrayCollection();
    for (var i:int = 0; i < this.cfunctionObjArr.length; i++) {
        var cfunctionObj:Object = cfunctionObjArr.getItemAt(i);
        var cfunction:String = cfunctionObj.cfunction;
        var cfields:ArrayCollection = cfunctionObj.cfields as ArrayCollection;
        var cfieldStr:String = cfunctionObj.cfield;//赋值字段
        var ctable:String = cfunctionObj.ctable;
        var isHead:Boolean = Boolean(cfunctionObj.isHead);
        var triggerfield:String = cfunctionObj.triggerfield;//触发字段
        var triggertable:String = cfunctionObj.triggertable;

        //YJ Add 触发字段对应的公式
        if (cfunctiStr == triggerfield && triggertable == cfunctitable) {
            //			if(cfunction.indexOf("@"+cfunctiStr+"@")!=-1)
            //			{
            for (var k:int = 0; k < cfields.length; k++) {
                var cfStr:Object = cfields.getItemAt(k);
                var cfield:String = cfStr.cfield;
                if (cfield.indexOf(cfunctiStr) != -1) {
                    cfStr.value = value;
                    break;
                }
            }
            //调用尹婕方法获取值
            if (cfunction.indexOf("getcol") != -1) {
                for (var k:int = 0; k < cfields.length; k++) {
                    var cfStr:Object = cfields.getItemAt(k);
                    var cfterstr:String = cfStr.cfield;
                    if (cfunction.indexOf(cfterstr) != -1 && cfterstr.indexOf("getcol") != -1) {
                        for (var p:int = 0; p < subCfunctionObjArr.length; p++) {
                            var subCfunctionObj:Object = subCfunctionObjArr.getItemAt(p);
                            if (cfterstr.indexOf(subCfunctionObj.param) != -1) {
                                var cs:String = cfield + "=" + subCfunctionObj.param;
                                if (null != dg) {
                                    var res:Object = onGetColValue(int(subCfunctionObj.flag), cs, dg);
                                    cfStr.ctable = dg.singleType.ctable;
                                }
                                else {
                                    var res:Object = onGetColValue(int(subCfunctionObj.flag), cs, dg);
                                }
                                if (res != null) {
                                    cfStr.value = res.toString().substr(res.toString().indexOf("=") + 1, res.toString().length);

                                }
                                break;
                            }
                        }
                    }
                }
            }
            newCfunctionObjArr.addItem(cfunctionObj);

        }

    }
    if (newCfunctionObjArr.length > 0) {
        //封装公式
        var funObj:Object = new Object();
        funObj.cfunctionObjArr = newCfunctionObjArr;
        funObj.value = this.getValue();
        funObj.dataObj = dataObj;
//*******开始：XZQWJ 时间：2013-01-07 功能：子表的子表的全量数据***************
        if (null != dg) {
            funObj.all_tableList = dg.child_tablelist;
        } else {
            funObj.all_tableList = new ArrayCollection();
        }
//******结束**********************************************************
        //计算公式
        //调用后台方法
        AccessUtil.remoteCallJava("CommonalityDest", "formula", reFormula, funObj, null, false);
    }
}

public function reFormula(evt:ResultEvent):void {
    var obj:Object = evt.result;
    this.setValue(fzsj(obj), 1, 1);
}


public function fzsj(obj:Object):Object {
    var mainObj:Object = new Object();
    var mainValue:Object = new Object();
    mainObj.mainValue = mainValue;
    var objInfo:Object = ObjectUtil.getClassInfo(obj);
    var fieldName:Array = objInfo["properties"] as Array;
    for each(var q:QName in fieldName) {
        var isFind:Boolean = false;
        for (var k:int = 0; k < this.tableMessage.length; k++) {
            var datadictionaryObj:Object = this.tableMessage.getItemAt(k);
            if (q.localName == datadictionaryObj.ctable) {
                isFind = true;
                break;
            }
        }
        if (q.localName != "all_tableList") {
            if (!isFind) {
                mainValue[q.localName] = obj[q.localName];
            }
            else {
                mainObj[q.localName] = obj[q.localName];
            }
        } else {
            mainObj[q.localName] = obj[q.localName];
        }
    }
    return mainObj;
}


public function onGetColValue(flag:int, toperation:String, dg:CrmEapDataGrid = null):Object {

    //返回值
    var outparam:Object = {};

    switch (flag) {
        case 1://求和
            outparam = onGetColSumByT(toperation, dg);
            break;
        case 2://求平均
            outparam = onGetColAvgByT(toperation, dg);
            break;
        case 3://求最大值
            outparam = onGetColMaxByT(toperation, dg);
            break;
        case 4://求最小值
            outparam = onGetColMinByT(toperation, dg);
            break;
        default:
            break;
    }
    return outparam;
}

//主表需要调用的聚合函数  (主表参数格式：fsum=sa_qunations.ftaxsum)  求和
public function onGetColSumByT(fullparam:String, dg:CrmEapDataGrid = null):Object {
    var pfield:String = fullparam.substring(0, fullparam.indexOf("="));//主表需要赋值的字段
    var tablename:String = fullparam.substring(fullparam.indexOf("=") + 1, fullparam.indexOf("."));//表名
    var field:String = "";
    if (fullparam.indexOf(".") != -1) {
        field = fullparam.substring(fullparam.indexOf(".") + 1, fullparam.length);//需要赋值的字段
    }
    else {
        field = fullparam.substring(fullparam.indexOf("(") + 1, fullparam.indexOf(")"));
    }
    var outparam:Object = {};
    var obj:Object = this.getValue();
    var tableArr:ArrayCollection = obj[tablename] as ArrayCollection;
    outparam = onSum(tableArr, pfield, field, dg);
    return outparam;
}

//公共求和方法
private function onSum(tableArr:ArrayCollection, pfield:String, field:String, dg:CrmEapDataGrid = null):Object {

    //获取DataGrid数据集
    var dgData:ArrayCollection = new ArrayCollection();
    if (null != dg) {
        dgData = dg["dataProvider"] as ArrayCollection;
    }
    else {
        dgData = tableArr;
    }

    var sum:Number = 0;
    //传出参数
    var outparam:String = "";

    //汇总
    for (var i:int = 0; i < dgData.length; i++) {
        var item:Object = dgData.getItemAt(i);
        var tsum:Number = item[field];
        sum += tsum;
    }
    outparam = pfield.substr(pfield.indexOf(".") + 1, pfield.length) + "=" + sum;
    return outparam;
}

//主表需要调用的聚合函数 (主表参数格式：fsum=sa_qunations.ftaxsum)  平均
public function onGetColAvgByT(fullparam:String, dg:CrmEapDataGrid = null):Object {
    var pfield:String = fullparam.substring(0, fullparam.indexOf("="));//主表需要赋值的字段
    var tablename:String = fullparam.substring(fullparam.indexOf("=") + 1, fullparam.indexOf("."));//表名
    var field:String = fullparam.substring(fullparam.indexOf(".") + 1, fullparam.length);//需要赋值的字段

    var outparam:Object = {};

    var obj:Object = this.getValue();
    var tableArr:ArrayCollection = obj[tablename] as ArrayCollection;
    outparam = onAvg(tableArr, pfield, field, dg);
    return outparam;
}

//公共求平均方法
private function onAvg(tableArr:ArrayCollection, pfield:String, field:String, dg:CrmEapDataGrid = null):Object {
    //获取DataGrid数据集
    //获取DataGrid数据集
    var dgData:ArrayCollection = new ArrayCollection();
    if (null != dg) {
        dgData = dg["dataProvider"] as ArrayCollection;
    }
    else {
        dgData = tableArr;
    }
    var sum:Number = 0;
    var avg:Number = 0;
    //传出参数
    var outparam:String = "";

    //汇总
    for (var i:int = 0; i < dgData.length; i++) {
        var item:Object = dgData.getItemAt(i);
        var tsum:Number = item[field];

        sum += tsum;

    }

    avg = sum / dgData.length;

    outparam = pfield.substr(pfield.indexOf(".") + 1, pfield.length) + "=" + avg;

    return outparam;
}

//主表需要调用的聚合函数 (主表参数格式：fsum=sa_qunations.ftaxsum)  最大值
public function onGetColMaxByT(fullparam:String, dg:CrmEapDataGrid = null):Object {
    var pfield:String = fullparam.substring(0, fullparam.indexOf("="));//主表需要赋值的字段
    var tablename:String = fullparam.substring(fullparam.indexOf("=") + 1, fullparam.indexOf("."));//表名
    var field:String = fullparam.substring(fullparam.indexOf(".") + 1, fullparam.length);//需要赋值的字段

    var outparam:Object = {};

    var obj:Object = this.getValue();
    var tableArr:ArrayCollection = obj[tablename] as ArrayCollection;
    outparam = onMax(tableArr, pfield, field, dg);


    return outparam;

}

//公共求最大值方法
private function onMax(tableArr:ArrayCollection, pfield:String, field:String, dg:CrmEapDataGrid = null):Object {
    //获取DataGrid数据集
    var dgData:ArrayCollection = new ArrayCollection();
    if (null != dg) {
        dgData = dg["dataProvider"] as ArrayCollection;
    }
    else {
        dgData = tableArr;
    }
    var arr:Array = new Array();
    //传出参数
    var outparam:String = "";

    for (var i:int = 0; i < dgData.length; i++) {
        var item:Object = dgData.getItemAt(i);
        arr.push(item[field]);
    }

    arr.sortOn(item[field], Array.NUMERIC);

    outparam = arr[arr.length - 1];

    return outparam;
}

//主表需要调用的聚合函数 (主表参数格式：fsum=sa_qunations.ftaxsum)  最小值
public function onGetColMinByT(fullparam:String, dg:CrmEapDataGrid = null):Object {
    var pfield:String = fullparam.substring(0, fullparam.indexOf("="));//主表需要赋值的字段
    var tablename:String = fullparam.substring(fullparam.indexOf("=") + 1, fullparam.indexOf("."));//表名
    var field:String = fullparam.substring(fullparam.indexOf(".") + 1, fullparam.length);//需要赋值的字段

    var outparam:Object = {};

    var obj:Object = this.getValue();
    var tableArr:ArrayCollection = obj[tablename] as ArrayCollection;
    outparam = onMin(tableArr, pfield, field, dg);

    return outparam;

}

//公共求最小值方法
private function onMin(tableArr:ArrayCollection, pfield:String, field:String, dg:CrmEapDataGrid = null):Object {
    //获取DataGrid数据集
    var dgData:ArrayCollection = new ArrayCollection();
    if (null != dg) {
        dgData = dg["dataProvider"] as ArrayCollection;
    }
    else {
        dgData = tableArr;
    }
    var arr:Array = new Array();
    //传出参数
    var outparam:String = "";

    for (var i:int = 0; i < dgData.length; i++) {
        var item:Object = dgData.getItemAt(i);
        arr.push(item[field]);
    }

    arr.sortOn(item[field], Array.NUMERIC);

    outparam = arr[0];

    return outparam;
}

public function initSubTableAssignment():void {
    obj = this.getValue();
    var newCfunctionObjArr:ArrayCollection = new ArrayCollection();
    for (var i:int = 0; i < this.cfunctionObjArr.length; i++) {
        var cfunctionObj:Object = cfunctionObjArr.getItemAt(i);
        var cfunction:String = cfunctionObj.cfunction;
        var cfields:ArrayCollection = cfunctionObj.cfields as ArrayCollection;
        var cfield:String = cfunctionObj.cfield;
        if (cfield.toLocaleUpperCase().indexOf("VI_") != -1) {
            //调用尹婕方法获取值
            if (cfunction.indexOf("@getcol") != -1) {
                for (var k:int = 0; k < cfields.length; k++) {
                    var cfStr:Object = cfields.getItemAt(k);
                    var cfterstr:String = cfStr.cfield;
                    if (cfunction.indexOf(cfterstr) != -1 && cfterstr.indexOf("getcol") != -1) {
                        for (var p:int = 0; p < subCfunctionObjArr.length; p++) {
                            var subCfunctionObj:Object = subCfunctionObjArr.getItemAt(p);
                            if (cfterstr.indexOf(subCfunctionObj.param) != -1) {
                                var cs:String = cfield + "=" + subCfunctionObj.param;
                                var res:Object = onGetColValue(int(subCfunctionObj.flag), cs);
                                if (res != null) {
                                    cfStr.value = res.toString().substr(res.toString().indexOf("=") + 1, res.toString().length);

                                }
                                break;
                            }
                        }
                    }
                }
            }
            else {
                for (var k:int = 0; k < cfields.length; k++) {
                    var cfStr:Object = cfields.getItemAt(k);
                    cfStr.value = obj[cfStr.cfield];
                }
            }
            newCfunctionObjArr.addItem(cfunctionObj);
        }
    }

    if (newCfunctionObjArr.length > 0) {
        //封装公式
        var funObj:Object = new Object();
        funObj.cfunctionObjArr = newCfunctionObjArr;
        funObj.value = this.getValue();
        funObj.dataObj = null;
        //计算公式
        //调用后台方法
        AccessUtil.remoteCallJava("CommonalityDest", "formula", reFormula, funObj, null, false);
    }
}

/**
 * StringReplaceAll
 * @param source:String 源数据
 * @param find:String 替换对象
 * @param replacement:Sring 替换内容
 * @return String
 * **/
public function StringReplaceAll(source:String, find:String, replacement:String):String {
    return source.split(find).join(replacement);
}


//计算约束公式
public function constraintFormula(cfunctiStr:String, cfunctitable:String, value:String, te:UIComponent, dataObj:Object = null, dg:CrmEapDataGrid = null):void {
    if (value != null && value != "") {
        var obj:Object = this.getValue();
        var newCfunctionObjArr:ArrayCollection = new ArrayCollection();
        for (var i:int = 0; i < this.cresfunctionArr.length; i++) {
            var cfunctionObj:Object = cresfunctionArr.getItemAt(i);
            var cfunction:String = cfunctionObj.cresfunction;
            var cfields:ArrayCollection = cfunctionObj.cfields as ArrayCollection;
            var isHead:Boolean = Boolean(cfunctionObj.isHead);
            var triggerfield:String = cfunctionObj.triggerfield;//触发字段
            var triggertable:String = cfunctionObj.triggertable;
            var message:String = cfunctionObj.cresmessage;
            //YJ Add 触发字段对应的公式
            if (cfunctiStr == triggerfield && triggertable == cfunctitable) {

                if (dataObj != null) {
                    constraint(cfields, cfunction, isHead, dataObj, message);
                    break;
                }
                else {
                    constraint(cfields, cfunction, isHead, obj, message);
                    break;
                }
            }
        }
    }
}

/**
 * StringReplaceAll
 * @param cfields:ArrayCollection 参与约束公式的字段
 * @param cfunction:String 约束公式
 * @param isHead:Boolean 是否表头约束公式
 * @return void
 * **/
public function constraint(cfields:ArrayCollection, cfunction:String, isHead:Boolean, obj:Object, message:String):void {
    for (var k:int = 0; k < cfields.length; k++) {
        var cfStr:Object = cfields.getItemAt(k);
        var cfield:String = cfStr.cfield;
        var ctable:String = cfStr.ctable;
        var value:String = "";
        if (isHead) {
            //说明是调用表体的值
            if (cfunction.indexOf(".") != -1 && obj.hasOwnProperty(ctable) && cfunction.indexOf("@" + ctable + "." + cfield + "@") != -1) {
                //说明是表格里面的值
                var childArr:ArrayCollection = obj[ctable] as ArrayCollection;
                //只有子表在组里面
                if (childArr.length > 0) {
                    var childObj:Object = childArr.getItemAt(0);
                    switch (cfStr.ctype) {
                        //字符
                        case "nvarchar":
                        {
                            if (childObj[cfield] != null) {
                                value = "'" + childObj[cfield] + "'";
                            }
                            else {
                                value = "";
                            }
                            break;
                        }
                        //数字
                        case "int":
                        {
                            if (childObj[cfield] != "0") {
                                value = childObj[cfield];
                            }
                            else {
                                value = "0";
                            }
                            break;
                        }
                        //浮点
                        case "float":
                        {
                            if (childObj[cfield] != "0.0") {
                                value = childObj[cfield];
                            }
                            else {
                                value = "0.0";
                            }
                            break;
                        }
                        //日期
                        case "datetime":
                        {
                            if (childObj[cfield] != null) {
                                value = "'" + childObj[cfield] + "'";
                            }
                            else {
                                value = "";
                            }
                            break;
                        }
                        case "bit":
                        {
                            if (childObj[cfield] != null) {
                                value = "'" + childObj[cfield] + "'";
                            }
                            else {
                                value = "0";
                            }
                            break;
                        }
                        default:
                        {
                            break;
                        }
                    }
                    cfunction = StringReplaceAll(cfunction, "@" + ctable + "." + cfield + "@", value);
                }
            }
            else if (cfunction.indexOf("@" + cfield + "@") != -1) {
                switch (cfStr.ctype) {
                    //字符
                    case "nvarchar":
                    {
                        if (obj[cfield] != null) {
                            value = "'" + obj[cfield] + "'";
                        }
                        else {
                            value = "";
                        }
                        break;
                    }
                    //数字
                    case "int":
                    {
                        if (obj[cfield] != "0") {
                            value = obj[cfield];
                        }
                        else {
                            value = "0";
                        }
                        break;
                    }
                    //浮点
                    case "float":
                    {
                        if (obj[cfield] != "0.0") {
                            value = obj[cfield];
                        }
                        else {
                            value = "0.0";
                        }
                        break;
                    }
                    //日期
                    case "datetime":
                    {
                        if (obj[cfield] != null) {
                            value = "'" + obj[cfield] + "'";
                        }
                        else {
                            value = "";
                        }
                        break;
                    }
                    case "bit":
                    {
                        if (obj[cfield] != null) {
                            value = "'" + obj[cfield] + "'";
                        }
                        else {
                            value = "0";
                        }
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                cfunction = StringReplaceAll(cfunction, "@" + cfield + "@", value);
            }
        }
        else {
            if (cfunction.indexOf(".") != -1) {
                if (cfunction.indexOf("@" + ctable + "." + cfield + "@") != -1) {
                    if (obj.hasOwnProperty(ctable)) {
                        //说明是表格里面的值
                        var childArr:ArrayCollection = obj[ctable] as ArrayCollection;
                        //只有子表在组里面
                        if (childArr.length > 0) {
                            var childObj:Object = childArr.getItemAt(0);
                            switch (cfStr.ctype) {
                                //字符
                                case "nvarchar":
                                {
                                    if (childObj[cfield] != null) {
                                        value = "'" + childObj[cfield] + "'";
                                    }
                                    else {
                                        value = "";
                                    }
                                    break;
                                }
                                //数字
                                case "int":
                                {
                                    if (childObj[cfield] != "0") {
                                        value = childObj[cfield];
                                    }
                                    else {
                                        value = "0";
                                    }
                                    break;
                                }
                                //浮点
                                case "float":
                                {
                                    if (childObj[cfield] != "0.0") {
                                        value = childObj[cfield];
                                    }
                                    else {
                                        value = "0.0";
                                    }
                                    break;
                                }
                                //日期
                                case "datetime":
                                {
                                    if (childObj[cfield] != null) {
                                        value = "'" + childObj[cfield] + "'";
                                    }
                                    else {
                                        value = "";
                                    }
                                    break;
                                }
                                case "bit":
                                {
                                    if (childObj[cfield] != null) {
                                        value = "'" + childObj[cfield] + "'";
                                    }
                                    else {
                                        value = "0";
                                    }
                                    break;
                                }
                                default:
                                {
                                    break;
                                }
                            }
                        }
                    }
                    else {
                        switch (cfStr.ctype) {
                            //字符
                            case "nvarchar":
                            {
                                if (obj[cfield] != null) {
                                    value = "'" + obj[cfield] + "'";
                                }
                                else {
                                    value = "";
                                }
                                break;
                            }
                            //数字
                            case "int":
                            {
                                if (obj[cfield] != "0") {
                                    value = obj[cfield];
                                }
                                else {
                                    value = "0";
                                }
                                break;
                            }
                            //浮点
                            case "float":
                            {
                                if (obj[cfield] != "0.0") {
                                    value = obj[cfield];
                                }
                                else {
                                    value = "0.0";
                                }
                                break;
                            }
                            //日期
                            case "datetime":
                            {
                                if (obj[cfield] != null) {
                                    value = "'" + obj[cfield] + "'";
                                }
                                else {
                                    value = "";
                                }
                                break;
                            }
                            case "bit":
                            {
                                if (obj[cfield] != null) {
                                    value = "'" + obj[cfield] + "'";
                                }
                                else {
                                    value = "0";
                                }
                                break;
                            }
                            default:
                            {
                                break;
                            }
                        }
                    }

                }
                cfunction = StringReplaceAll(cfunction, "@" + ctable + "." + cfield + "@", value);
            }
            else {
                switch (cfStr.ctype) {
                    //字符
                    case "nvarchar":
                    {
                        if (obj[cfield] != null) {
                            value = "'" + obj[cfield] + "'";
                        }
                        else {
                            value = "";
                        }
                        break;
                    }
                    //数字
                    case "int":
                    {
                        if (obj[cfield] != "0") {
                            value = obj[cfield];
                        }
                        else {
                            value = "0";
                        }
                        break;
                    }
                    //浮点
                    case "float":
                    {
                        if (obj[cfield] != "0.0") {
                            value = obj[cfield];
                        }
                        else {
                            value = "0.0";
                        }
                        break;
                    }
                    //日期
                    case "datetime":
                    {
                        if (obj[cfield] != null) {
                            value = "'" + obj[cfield] + "'";
                        }
                        else {
                            value = "";
                        }
                        break;
                    }
                    case "bit":
                    {
                        if (obj[cfield] != null) {
                            value = "'" + obj[cfield] + "'";
                        }
                        else {
                            value = "0";
                        }
                        break;
                    }
                    default:
                    {
                        break;
                    }
                }
                cfunction = StringReplaceAll(cfunction, "@" + cfield + "@", value);
            }
        }
    }

    var objparam:Object = {};
    var paramArr:ArrayCollection = new ArrayCollection();
    var sql:String = "select case when " + cfunction + " then 1 else 0 end as value";

    /*var fra:ArrayCollection = this._frameArr;*/
    //调用后台方法
    AccessUtil.remoteCallJava("hrPersonDest", "verificationSql", function (evt:ResultEvent):void {
        var rArr:ArrayCollection = evt.result as ArrayCollection;
        if (rArr == null || rArr.length == 0) {
            return;
        }
        var paramObj:Object = new Object();
        //paramObj[resultCfield] = rArr.getItemAt(0).value;
        //if(rArr.getItemAt(0).rvalue.value==0)
        var objw:Object = null;
        if (rArr.getItemAt(0).value == 0) {
            isError = true;
            if (messageArr.length == 0) {
                var paramObj:Object = new Object();
                paramObj.cfunction = cfunction;
                paramObj.message = message;
                messageArr.addItem(paramObj);
            }
            else {
                for (var i:int = 0; i < messageArr.length; i++) {
                    if (messageArr.getItemAt(i).cfunction != cfunction) {
                        var paramObj:Object = new Object();
                        paramObj.cfunction = cfunction;
                        paramObj.message = message;
                        messageArr.addItem(paramObj);
                    }
                }
            }
            errorTip = message;
            CRMtool.tipAlert1(message);
        }
        else {
            errorTip = "";
            for (var i:int = 0; i < messageArr.length; i++) {
                if (messageArr.getItemAt(i).cfunction == cfunction) {
                    messageArr.removeItemAt(i);
                }
            }
        }
    }, sql, null, false);
}