/*
	模块功能：单据中的DataGrid内部特殊业务处理
			 目前的功能点有：
			 1、DataGrid参照返回多值赋值
			 2、DataGrid内部运算

	创建人：  YJ
	创建日期：2011-11-18
*/

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.DataGrid;

import yssoft.renders.DGConsultTextInput;

[Bindable]
public var dgdata:ArrayCollection = new ArrayCollection();//DataGrid的记录集

[Bindable]
public var consultArr:ArrayCollection = new ArrayCollection();//参照返回的记录集

//YJ Add DataGrid参照返回多值赋值
public function setDgOtherFields(dataField:String):void{
	
	var dg:DataGrid = null;
	
	//参照赋值公式为空直接返回
/*	if(cselsetValues == null || cselsetValues == "") return;*/
	
	//获取参照所在的DataGrid的记录集
	dg = (((consultti.owner) as DGConsultTextInput).owner) as DataGrid;
	dgdata = dg.dataProvider as ArrayCollection;
	
	//获取参照返回的记录集
	/*consultArr = consultti.allList;*/
	
	//解析参照赋值公式
/*	var arr:Array = onAnalysisExp(cselsetValues);*/
	
	//参照返回多值
	for(var i:int=0;i<consultArr.length;i++){
		
		var itemObj:Object = {};
		if(i==0) itemObj = dg.selectedItem;//参照第一条记录赋值于当前行
		
		//循环遍历参照公式
		/*for(var j:int=0;j<arr.length;j++){
			var tempArr:Array = arr[j].toString().split("=");//获取一个元素
			var field:String = tempArr[0]+"";//表字段
			var confield:String = tempArr[1]+"";//参照字段
			
			itemObj[field] = consultArr[i][confield];//根据参照公式赋值
			
		}*/
		
		if(i==0) {
			dgdata.setItemAt(itemObj,dg.selectedIndex);//当前记录赋值
		}
		else{
		/*	itemObj[dataField] = consultti.cconsultbkfld[i];*/
			dgdata.addItemAt(itemObj,dg.selectedIndex+i);//当前记录后附加
		}
	}
		
	dg.invalidateList();
}

//YJ Add 解析参照赋值公式,参数：oriExp(原始参照赋值公式)  例：A=a,B=b
private function onAnalysisExp(oriExp:String):Array{
	//返回值
	var reArr:Array = new Array();
	
	reArr = oriExp.split(",");
	
	return reArr;
}

