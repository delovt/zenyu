import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.DataGrid;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;

import yssoft.evts.onItemDoubleClick;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;

[Event(name="onResEvent",type="flash.events.Event")]

/**
 	模块功能：操作单据中的子表数据
	 * 		 子表必输项数据的验证
	 * 		 子表默认值赋值
	 * 		 子表约束数据验证
 	创建日期：2011-12-01
	创建人  ：YJ
 
 */

//检查子表中的必输项
//childBUnNullArr 中包含( 表名，需要验证的字段 )
public function onCheckDataIsNull():Boolean{

	if(this.dgnumber.length ==0 ) return true;//没有子表信息
	if(this.childBUnNullArr.length==0) return true;//无数据需要验证
	
	//遍历不为空的字段
	for(var i:int=0;i<this.childBUnNullArr.length;i++){
		var objitem:Object = this.childBUnNullArr.getItemAt(i);//获取一项
		
		var gridArr:Array = objitem.gridArr;//Grid信息
		var fieldArr:Array = objitem.fieldArr;//Grid对应的必输项字段信息
		
		var gitem:Object = gridArr[0];
		var dgid:String = gitem.dg;
		var dgcaption:String = gitem.dgname;
		
		//遍历记录集
		for(var j:int=0;j<this.dgnumber.length;j++){
			var dg:DataGrid = this.dgnumber.getItemAt(j) as DataGrid;
			if(dgid == dg.id){
				if(onCheckNull(dgcaption,fieldArr,dg.dataProvider as ArrayCollection)==false) return false;
			}
		}
	}
	
	return true;
}

/** 
 * onCheckNull(检验必输项) 
 * @param dgcaption:String DataGrid标题
 * @param fieldArr:Array 必输项字段集合
 * @param dgdata:ArrayCollection DataGrid数据集
 * @return String 
 * **/ 
private function onCheckNull(dgcaption:String,fieldArr:Array,dgdata:ArrayCollection):Boolean{

	for(var i:int=0;i<fieldArr.length;i++){
		
		var objitem:Object = fieldArr[i];//获取不能为空的字段信息
		var unfield:String = objitem.field;//字段
		var unfname:String = objitem.fname;//字段名称
		
		for(var j:int=0;j<dgdata.length;j++){
			var item:Object = dgdata.getItemAt(j);
			var fvalue:Object = item[unfield];
			
			if(fvalue == null || fvalue == ""){
				CRMtool.tipAlert("请输入 "+dgcaption+ " 中的 '"+unfname+"'");
				return false;
				break;
			}
				
		}
		
	}
	return true;
	
}

/** 
 * onCheckDataIsRestrain	(检验约束项) 
 * @return Boolean 
 * **/ 
public function onCheckDataIsRestrain():void{
	
	if(this.dgnumber.length ==0 ) return;//没有子表信息
	if(this.childBCresArr.length==0) return;//无数据需要验证
	
	//遍历约束的字段
	for(var i:int=0;i<this.childBCresArr.length;i++){
		
		var objitem:Object = this.childBCresArr.getItemAt(i);//获取一项
		var restrainArr:ArrayCollection = objitem.restrainArr;//Grid对应的约束项字段信息
		
		var dgid:String = objitem.gridid;
		var dgcaption:String = objitem.gridname;
		
		//遍历记录集
		for(var j:int=0;j<this.dgnumber.length;j++){
			var dg:DataGrid = this.dgnumber.getItemAt(j) as DataGrid;
			if(dgid == dg.id){
				//重新封装childBCresArr(加入数据记录集)
				objitem.dgdata = dg.dataProvider as ArrayCollection;
				this.childBCresArr.setItemAt(objitem,i);
			}
		}
	}
	
	var param:Object = {};
	param.resArr = this.childBCresArr;
	AccessUtil.remoteCallJava("CompetitorDest","onGetResFunValue2",function(evt:ResultEvent):void{
		
		dispatchEvent(new onItemDoubleClick("onResEvent",evt.result));
		
	},param,null,false);
	
}

/** 
 * onCheckRestrain	(检验约束项) 
 * @param dgcaption:String DataGrid标题
 * @param restrainArr:Array 约束项字段集合
 * @param dgdata:ArrayCollection DataGrid数据集
 * @return String 
 * **/ 
private function onCheckRestrain(dgcaption:String,restrainArr:ArrayCollection,dgdata:ArrayCollection):Boolean{
	var rvalue:Boolean = true;
	for(var i:int=0;i<restrainArr.length;i++){
		
		var objitem:Object = restrainArr.getItemAt(i);//获取约束的字段信息
		var resfield:String = objitem.cfield;//字段
		var resfname:String = objitem.fname;//字段名称
		var resfun:String   = objitem.cresfun;//约束公式
		var resmes:String   = objitem.cresmes;//约束提示信息
		
		for(var j:int=0;j<dgdata.length;j++){
			var item:Object = dgdata.getItemAt(j);
			var fvalue:Object = item[resfield];//约束字段对应的值
			
			//值带入
			var fun:String = "";
			var param:Object = {};
			
			fun = StringReplaceAll(resfun,resfield,fvalue+"");
			param.cresfun = fun;
			
			//调用后台方法
			AccessUtil.remoteCallJava("CompetitorDest","onGetResFunValue",function(evt:ResultEvent):void{
				var robj:Object = evt.result.rvalue;
				
				if(robj != null && robj.value==0){
					Alert.show(dgcaption+" 中的 "+resmes);
					rvalue = false;
				}
			},param,null,false);
			
		}
		
	}
	return rvalue;
	
}

/** 
 * StringReplaceAll 
 * @param source:String 源数据 
 * @param find:String 替换对象 
 * @param replacement:Sring 替换内容 
 * @return String 
 * **/  
private function StringReplaceAll( source:String, find:String, replacement:String ):String{  
	return source.split( find ).join( replacement );  
}  


/** 
 * onSetDefaultValue 保存时默认值的赋值(新增默认值，修改默认值)
 * @return void 
 * **/ 
public function onSetDefaultValue():void{
	
	var defaultArr:ArrayCollection = new ArrayCollection();
	
	if(dgnumber.length == 0) return;
	if(item == "onNew"){
		if(childDefaultArr.length == 0) return;
		defaultArr = childDefaultArr;
	}
	else if(item == "onEdit"){
		if(childEditDefaultArr.length == 0) return;
		defaultArr = childEditDefaultArr;	
	}
	
	for(var i:int=0;i<this.dgnumber.length;i++){
		var dg:DataGrid = this.dgnumber.getItemAt(i) as DataGrid;
		var dgdata:ArrayCollection = dg.dataProvider as ArrayCollection;//记录集
		
		for(var j:int=0;j<defaultArr.length;j++){
			var itemobj:Object = defaultArr[j];
			var dgid:String = itemobj.dgid;
			var dvalue:Array = itemobj.defaultArr;
			
			if(dgid !=dg.id) continue;
			
			onDefaultValueHandle(dvalue,dgdata);
		}
		
	}
	
}

/** 
 * onDefaultValueHandle 保存时默认值的赋值(新增默认值，修改默认值)
 * @return void 
 * **/ 
private function onDefaultValueHandle(dvalue:Array,dgdata:ArrayCollection):void{

	for(var k:int=0;k<dvalue.length;k++){
		var objdf:Object = dvalue[k];
		var field:String = objdf.dataField;//字段
		var value:Object = objdf.dataValue;//值
		
		//遍历每一条记录的当前字段是否为空,为空设置为默认值
		for(var m:int=0;m<dgdata.length;m++){
			var dataitem:Object = dgdata.getItemAt(m);
			
			if(dataitem[field] == null || mx.utils.StringUtil.trim(dataitem[field].toString()) == ""){
				dataitem[field] = value;
			}
		}
		dgdata.refresh();
	}
	
}










