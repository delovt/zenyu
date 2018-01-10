/**
 *
 * @author：liu_lei
 * 日期：2011-8-20
 * 功能：
 * 修改记录：
 *
 */
import flash.events.KeyboardEvent;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.DataGrid;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.managers.PopUpManager;
import mx.rpc.events.ResultEvent;

import yssoft.models.*;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.vos.*;

public var iid:int;
//表头VO
[Bindable]
public var acConsultsetVo:AcConsultsetVo=new AcConsultsetVo();
//表体VO
public var acConsultclmVo:AcConsultclmVo;

//列表表头
[Bindable]
private var acListsetVo:ListsetVo=new ListsetVo();

//列表标题
[Bindable]
private var acListclmVos:ArrayCollection = new ArrayCollection();

//表体集
[Bindable]
public var resultArr:ArrayCollection=new ArrayCollection();

public var parentForm:Object;

[Bindable]
public var ifieldtypeArr:ArrayCollection=new ArrayCollection();
[Bindable]
public var isFand:Boolean = true;

[Bindable]public var arrDataList:ArrayCollection = new ArrayCollection();	//数据集

//回调刷新参照设置样式
[Bindable]
public var refreshStyle:Function;

private var _isShowList:int= 0;

public function  set isShowList(value:int):void
{
	this._isShowList = value;	
}

[Bindable]
private var _isShow:Boolean; 

public function set isShow(value:Boolean):void
{
	this._isShow = value;
}


//常用条件类型
[Bindable]
public var arr_icmtype:ArrayCollection = new ArrayCollection(
	[
		{label:"单项", value:"0"},
		{label:"区间", value:"1"},
		{label:"多选", value:"2"},
		{label:"是否BIT型", value:"3"}
	]
);

/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-22
 * 功能：获得表头数据
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function getHeadData():void
{
	if(this._isShowList ==0)
	{
		AccessUtil.remoteCallJava("ConsultDest","getAcConsultsetByID",headData_callBackHandler,iid,'',false);
	}
	else if(this._isShowList ==1)
	{
		parentForm = this.owner;
		var acListclmVo:ListclmVo = new ListclmVo();
		acListclmVo.ilist = this.iid;
		acListclmVo.iperson = CRMmodel.userId;
		//update by zhong_jing 查询列表查询
		AccessUtil.remoteCallJava("ACListsetDest","getListsetSet",getAcConsultclmBack,acListclmVo,'',false);
	}
	else if(this._isShowList==2)
	{
		parentForm = this.owner;
		AccessUtil.remoteCallJava("ACqueryclmDest","getAcQueryclmList",onGetAcQueryclmListBack,iid,'',false);
	}
}

private function onGetAcQueryclmListBack(evt:ResultEvent):void{
	this.currentState ="queryState";
	arrDataList = evt.result as ArrayCollection;
	this.dgrd_consultclm.dataProvider = arrDataList;
	isFand = false;
	this.dgrd_assembly.visible = true;
	this.title ="查询条件设置";

}

private function getAcConsultclmBack(event:ResultEvent):void
{
	this.currentState ="consultState";
	
	acListclmVos = event.result.acListclmVos as ArrayCollection;
	if(null!=event.result.acListsetVo)
	{
		acListsetVo = event.result.acListsetVo as ListsetVo;
		acListclmVos = event.result.acListclmVos as ArrayCollection;


        //lr add 如果查出来的数据中 iperson都不大于0，说明此人以前没有配置过，所以默认让 bshow为1 ，默认显示。
        var flag:Boolean = false;
        for each(var item:Object in acListclmVos){
            if(item.iperson>0)
                flag = true;
        }
        if(!flag){
            for each(var item:Object in acListclmVos){
                item.bshow = 1;
            }
        }

		this.tnp_rownum.text = acListsetVo.ipage.toString();
		this.tnp_fixnum.text = acListsetVo.ifixnum.toString();
		this.dgrd_consultclm.dataProvider = acListclmVos;
	}
	
	if(_isShow)
	{
		this.dgc_bgroup.visible =true;
		this.dgc_bsum.visible = true;
	}
	this.btn_resume.visible =true;
	
	this.title ="列表配置";
	(dgrd_consultclm as DataGrid).dragEnabled = true;
	(dgrd_consultclm as DataGrid).dropEnabled = true;
	(dgrd_consultclm as DataGrid).dragMoveEnabled = true;
}

public function  rowMoveEndUp():void
{
	var sortname:String ="";
	if(this._isShowList==0||this._isShowList==1)
	{
		sortname ="ino";
		CRMtool.rowMoveEndUp(this.dgrd_consultclm,sortname);
	}
	else if(this._isShowList==2)
	{
		sortname ="iqryno";
		CRMtool.rowMoveEndUp(this.dgrd_assembly,sortname);
	}
	
	
}

public function  rowMoveUp():void
{
	var sortname:String ="";
	if(this._isShowList==0||this._isShowList==1)
	{
		sortname ="ino";
		CRMtool.rowMoveUp(this.dgrd_consultclm,sortname);
	}
	else if(this._isShowList==2)
	{
		sortname ="iqryno";
		CRMtool.rowMoveUp(this.dgrd_assembly,sortname);
		
	}
	
	
}

public function  rowMoveDown():void
{
	var sortname:String ="";
	if(this._isShowList==0||this._isShowList==1)
	{
		sortname ="ino";
		CRMtool.rowMoveDown(this.dgrd_consultclm,sortname);
	}
	else if(this._isShowList==2)
	{
		sortname ="iqryno";
		CRMtool.rowMoveDown(this.dgrd_assembly,sortname);
	}
	
	
}

public function  rowMoveEndDown():void
{
	var sortname:String ="";
	if(this._isShowList==0||this._isShowList==1)
	{
		sortname ="ino";
		CRMtool.rowMoveEndDown(this.dgrd_consultclm,sortname);
	}
	else if(this._isShowList==2)
	{
		sortname ="iqryno";
		CRMtool.rowMoveEndDown(this.dgrd_assembly,sortname);
	}
}

/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-22
 * 功能：获得表头数据回调
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function headData_callBackHandler(event:ResultEvent):void
{
	if (event.result!=null)
	{
		this.currentState ="consultState";
		var arr:ArrayCollection=event.result as ArrayCollection;
		if (arr.length>0)
		{
		   acConsultsetVo=AcConsultsetVo(arr[0]);
		}
	}
}

/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-20
 * 功能：获得表体数据
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function getBodyData():void
{
	if(this._isShowList==0)
	{
		AccessUtil.remoteCallJava("ConsultDest","getAcConsultclmByPID",bodyData_callBackHandler,iid);
	}
}

/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-20
 * 功能：获得表体数据回调
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function bodyData_callBackHandler(event:ResultEvent):void
{
	if (event.result!=null)
	{
		resultArr=event.result as ArrayCollection;
	}
}

/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-19
 * 功能：对齐方式显示文字
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */
public function getIalignArrLabel(item:Object,icol:int):String
{
	var lbltext:String;
	switch(String(item.ialign))
	{
		case "0":
		{
			lbltext="居左对齐";
			break;
		}
		case "1":
		{
			lbltext="居中对齐";
			break;
		}
		case "2":
		{
			lbltext="居右对齐";
			break;
		}
	}
	return lbltext;
}

/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-21
 * 功能：确定
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */
protected function btn_ok_clickHandler():void
{
	var obj:Object=new Object();
	if(this._isShowList==0)
	{
		acConsultsetVo.ipage=Number(this.tnp_rownum.text);
		obj.head=acConsultsetVo;
		obj.body=this.resultArr;
		AccessUtil.remoteCallJava("ConsultDest","updateAcConsultset",saveTreecallBackHandler,obj,ConstsModel.CONSULT_UPDATE_INFO);
	}
	else if(this._isShowList==1)
	{
		var paramObj:Object = new Object();
		paramObj.acListclmVos = this.acListclmVos;
        var ipage =  int(Number(this.tnp_rownum.text));
        var ifixnum =  int(Number(this.tnp_fixnum.text));
		this.acListsetVo.ipage = ipage;
		this.acListsetVo.ifixnum = ifixnum;
		paramObj.acListsetVo =this.acListsetVo;
		paramObj.oldacListsetVo = this.acListsetVo;
		paramObj.iperson = CRMmodel.userId;
		AccessUtil.remoteCallJava("ACListsetDest","updateList",updatelistsetsBack,paramObj);

        var sql:String = "delete ac_listsetp where ilist="+acListsetVo.iid+" and iperson="+CRMmodel.userId+" " +
                "insert into ac_listsetp(ilist,iperson,ipage,ifixnum)values("+acListsetVo.iid+","+CRMmodel.userId+","+ipage+","+ifixnum+")";
        AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null, sql, null, false);
	}
	else if(this._isShowList==2)
	{
		var objvalue:Object = new Object();
		objvalue.ifuncregedit = iid;//注册程序内码
		objvalue.datalist = arrDataList;			
		//数据集
		AccessUtil.remoteCallJava("ACqueryclmDest","updateAcqueryclm_1",onAddAcqueryclmBack,objvalue)
	}
}

/**
 * 函数名称：onAddAcqueryclmBack
 * 函数说明：保存事件后处理
 * 函数参数：event:ListEvent
 * 函数返回：void
 * 
 * 创建人：YJ
 * 修改人：
 * 创建日期：20110819
 * 修改日期：
 *	
 */
private function onAddAcqueryclmBack(evt:ResultEvent):void{
	
	var result:String = evt.result as String;
	if(result=="fail")
	{
		CRMtool.tipAlert("保存失败");
	}else{
		this.closeWindow();
	}
	
}

private function updatelistsetsBack(event:ResultEvent):void
{
	var result:String = event.result as String;
	if(result=="fail")
	{
		CRMtool.tipAlert("保存失败");
	}
	else
	{
		/*CRMtool.tipAlert("保存成功");*/
		parentForm.refreshStyle();
		this.closeWindow();
	}
}

/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-21
 * 功能：确定回调
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function saveTreecallBackHandler(event:ResultEvent):void
{
	if(event.result || event.result.toString()!="false")
	{
			if (this.refreshStyle!=null)
			{
				this.refreshStyle();
	            this.closeWindow();
			}
	}
	else
	{
		CRMtool.tipAlert(ConstsModel.CONSULT_FAIL);
	}
}

/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-21
 * 功能：取消
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */
protected function closeWindow():void
{
	PopUpManager.removePopUp(this);
}

/**
 * 
 * 作者：liu_lei
 * 日期：2011-08-22
 * 功能：全表格搜索定位
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */
protected function tnp_search_searchHandler():void
{
	CRMtool.dataGridSearchLocate(this.dgrd_consultclm,this.tnp_search.text);
}
protected function tnp_search_keyDownHandler(event:KeyboardEvent):void
{
	if (event.keyCode==13)
	{
		tnp_search_searchHandler();
	}
}


//窗体初始化
public function onWindowInit():void
{
	
}
//窗体打开
public function onWindowOpen():void
{
	getHeadData();
	getBodyData();
}
//窗体关闭,完成窗体的清理工作
public function onWindowClose():void
{
	
}

public function resume():void
{
	/*if(null==resultArr||resultArr.length==0)
	{
		CRMtool.tipAlert("无需恢复默认");
		return;
	}*/
	var paramObj:Object = new Object();
	paramObj.iperson = CRMmodel.userId;
	paramObj.ilist = this.acListsetVo.iid;
	AccessUtil.remoteCallJava("ACListsetDest","addObj",updatelistsetsBack,paramObj);
}

public function convertIcmType(item:Object,column:DataGridColumn):String{
	var itemlabel:String = item.icmtype+"";
	
	switch(itemlabel){	
		case "0":
			return "单项";
			break;
		case "1":
			return "区间";
			break;
		case "2":
			return "多选";
			break;
		case "3":
			return "是否BIT型";
			break;
		default:
			break;
	}
	return "";
}