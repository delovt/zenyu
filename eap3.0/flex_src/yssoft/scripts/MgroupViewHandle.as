/*
	模块名称：MgroupViewHandle.as
	模块功能：列表管理中汇总视图的处理
	创建日期：2011-12-31
	创建人： YJ

*/
import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.rpc.events.ResultEvent;

import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.vos.ListclmVo;

private var _strsum:String= "";//合计

private var _strgroup:String = "";//汇总字段

private var _strsql:String = "";//列表配置中的sql

private var groupArr:String = "";//记录合计与汇总的字段

public function get strsum():String{
	return this._strsum;
}
public function set strsum(value:String):void{
	_strsum = value;
}

public function get strgroup():String{
	return this._strgroup;
}
public function set strgroup(value:String):void{
	_strgroup = value;
}

public function get strsql():String{
	return this._strsql;
}
public function set strsql(value:String):void{
	_strsql = value;
}

//初始化汇总视图所需要的信息
public function iniGroupViewInfo(acListclmVos:ArrayCollection):void{

	if(null == acListclmVos) return;
	_strsum = "";
	_strgroup = "";
	
	for each(var listclm:ListclmVo in acListclmVos){
		
		if(listclm.bsum){
			_strsum+="sum("+listclm.cfield+") as "+listclm.cfield+",";
			groupArr+="@"+listclm.cfield+"@,";
		}
		if(listclm.bgroup){
			_strgroup+=listclm.cfield +",";
			groupArr+="@"+listclm.cfield+"@,";
		}
		
	}
	
	if(groupArr != "")groupArr.substring(0,groupArr.lastIndexOf(","));
	
}

//汇总视图的切换
private function oncbGroupView_click():void{
	
	if(this.cbGroupView.selected){
		iniGroupView();
	}
	else{
        this.personArr = backList;
        //lr headerWordWrap 临时解决办法
        for each(var c:DataGridColumn in this.dgrd_person.columns){
            if(c.headerWordWrap == true){
                c.visible = true;
                c.headerWordWrap == false;
            }
        }
    }
		//iniListView();
	
}


//初始化分组汇总视图
private function iniGroupView():void{

    if (_strgroup == "") {
        CRMtool.showAlert("请设置汇总字段。");
        this.cbGroupView.selected = false;
        return;
    }
    if(dgrd_person.dataProvider.length==0){
        CRMtool.showAlert("请先查询数据，再进行汇总。");
        this.cbGroupView.selected = false;
        return;
    }
	var psql:String = "select max(iid) iid";
	var sql:String = "";
	
	psql += ","+_strgroup;
	if("" != strsum) psql+=","+strsum;
	
	psql = psql.replace(",,",",");
	//SZC Add  只有','在最后时才截取
	if((psql.length-1)==psql.lastIndexOf(",") && psql.lastIndexOf(",") != -1)
		psql = psql.substring(0,psql.lastIndexOf(","));
	//SZC 注销   多次点击汇总视图按钮，会一直截取
	/*if(psql.lastIndexOf(",") != -1)
	/psql = psql.substring(0,psql.lastIndexOf(","));
	if(_strgroup.lastIndexOf(",") != -1)*/
	if((_strgroup.length-1)==_strgroup.lastIndexOf(",")&&_strgroup.lastIndexOf(",") != -1)//SZC Add
		_strgroup = _strgroup.substring(0,_strgroup.lastIndexOf(","));
	
	//YJ Modify 20120713 remove order by
	if(strsql.indexOf("order by") != -1)
		strsql = strsql.substring(0,strsql.indexOf("order by"));
	
	var beraStr:String="";
	
	if(CRMtool.isStringNotNull(tnp_bjobstatus.text)){
		
		var bsearch:Boolean = false;
		count = 0;
		for each(var listclmVo:ListclmVo in this.acListclmVos)
		{
			if(listclmVo.bsearch)
			{
				if(!bsearch)
				{
					bsearch = true;
				}
				if(count>0)
				{
					beraStr+=" or ";
				}
				
				if(CRMtool.isStringNotNull(this.tnp_bjobstatus.text))
				{
					/* beraStr+=itemObj.ctable+"."; */
					beraStr+=listclmVo.cfield+" like '%"+this.tnp_bjobstatus.text+"%'";
					count++;
				}
			}
		}
		if(beraStr!="")
		{
			beraStr = " and "+beraStr;
		}	
		
	}
	sql = psql + "  from ("+ strsql +") total where 1=1 "+beraStr+" group by "+_strgroup;
	
	AccessUtil.remoteCallJava("hrPersonDest","verificationSql",onGroupViewBack,sql,null,false);
	
}

private function onGroupViewBack(evt:ResultEvent):void{
    backList = new ArrayCollection(CRMtool.ObjectCopy(personArr.toArray()));
	this.personArr = evt.result as ArrayCollection;
	var j:int=1;
	for each (var item:Object in this.personArr) 
	{
		item.sort_id=j++;
	}
	
	var columncols:Array = this.dgrd_person.columns;
	for(var i:int=0;i<columncols.length;i++){
		
		var objitem:String = columncols[i].dataField+"";
		
		if(objitem != "null" && groupArr.indexOf("@"+objitem+"@") ==-1 && objitem != "sort_id"){
            (columncols[i] as DataGridColumn).visible = false;
            (columncols[i] as DataGridColumn).headerWordWrap = true;
        }

	}
	this.dgrd_person.isAllowMulti = true;
	//this.dgrd_person.InitColumns();
	this.dgrd_person.columns = columncols;
}

//初始化列表视图
private function iniListView():void{
	/*this.itemObj = null;*/
/*	this.checkBoxHbox.removeAllChildren();*/
	this.init();

    if(pageBarSearchObj)
        pageBarSearch(pageBarSearchObj);
    else{
        search(0);
    }
}