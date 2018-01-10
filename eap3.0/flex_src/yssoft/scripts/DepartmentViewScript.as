import flash.events.Event;
import flash.events.KeyboardEvent;

import flashx.textLayout.events.DamageEvent;

import mx.collections.ArrayCollection;
import mx.collections.SortField;
import mx.controls.Alert;
import mx.controls.Button;
import mx.events.ItemClickEvent;
import mx.messaging.AbstractConsumer;
import mx.rpc.events.ResultEvent;

import spark.collections.Sort;

import yssoft.comps.TreeCompsVbox;
import yssoft.comps.frame.module.CrmEapTextInput;
import yssoft.models.ConstsModel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.views.department.DepartmentView;
import yssoft.vos.DepartmentVo;
import yssoft.vos.JobVo;


[Bindable]
private var itemType:String=ConstsModel.ONDELETE_LABLE;

private var departmentVo:DepartmentVo;

[Bindable]
private var jobArr:ArrayCollection=new ArrayCollection();

private var removeArr:ArrayCollection = new ArrayCollection();

[Bindable]
public var departmentXMl:XML = null;



	//窗体初始化
	public function onWindowInit():void
	{
		
	}
	//窗体打开
	public function onWindowOpen():void
	{
		this.tnp_ccode.text ="";
		this.tnp_cname.text ="";
		this.tnp_iperson.text="";
		tnp_irealperson.text = "";
		this.tre_department.enabled= true;
		showAllBox.selected=false;
		if(IheadBox.getChildByName("UI_C1")!=null){
			var consult1:CrmEapTextInput = this.IheadBox.getChildByName("UI_C1") as CrmEapTextInput;
			consult1.text = "";
		}
		
		
		if(IchargeBox.getChildByName("UI_C2")!=null){
			var consult1:CrmEapTextInput = this.IchargeBox.getChildByName("UI_C2") as CrmEapTextInput;
			consult1.text = "";
		}
		
		if(IleadBox.getChildByName("UI_C3")!=null){
			var consult1:CrmEapTextInput = this.IleadBox.getChildByName("UI_C3") as CrmEapTextInput;
			consult1.text = "";
		}
		jobArr=new ArrayCollection();
		getDepartmentTreeXml();
		myinit();
	}
	//窗体关闭,完成窗体的清理工作
	public function onWindowClose():void
	{
	}

/**
 * 
 * 作者：zhong_jing
 * 日期：2011-08-09 
 * 功能 保存后执行操作
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
private function saveTreecallBackHandler(event:ResultEvent):void
{
	if(event.result.toString()!="fail")
	{
		var result:String = event.result as String;
		if(itemType =="onNew")
		{
			departmentVo.iid =int(Number(event.result));
			this.tre_department.AddTreeNode(departmentVo);
			CRMtool.tipAlert(ConstsModel.DEPARTMENT_ADD_SUCCESS);
		}
		else if(itemType=="onDelete")
		{
			this.tre_department.DeleteTreeNode();
			CRMtool.tipAlert(ConstsModel.DEPARTMENT_REMOVE_SUCCESS);
		}
		else if(itemType=="onEdit")
		{
			this.tre_department.EditTreeNode(departmentVo);
			CRMtool.tipAlert(ConstsModel.DEPARTMENT_UPDATE_SUCCESS);
		}
		
		/*getDepartmentTreeXml();*/
		
		onGiveUp(event);
	}
	else
	{
		CRMtool.tipAlert(ConstsModel.FAIL);
	}
}

/**
 *
 * 函数名：
 * 作者：钟晶
 * 日期：2011-08-02
 * 功能： 检查输入字段
 * 参数：无
 * 返回值：无
 * 修改记录：
 * 
 */
private function checkValue():Boolean
{
	if(this.itemType==ConstsModel.ONNEW_LABLE||(this.itemType==ConstsModel.ONEDIT_LABLE&&this.tre_department.selectedItem.@ccode!=this.tnp_ccode.text))
	{
		if(this.tre_department.isExistsCcode(this.tnp_ccode.text,ConstsModel.ROLE_CCODE_WARNMSG))
		{
			return false;
		}
	}
	
	if(CRMtool.isStringNull(this.tnp_ccode.text))
	{
		CRMtool.tipAlert(ConstsModel.DEPARTMENT_CCODE_ISNULL,this.tnp_ccode);
		return false;
	}
	else if(CRMtool.isStringNull(this.tnp_cname.text))
	{
		CRMtool.tipAlert(ConstsModel.DEPARTMENT_CNAME_ISNULL,this.tnp_cname);
		return false;
	}
	else if(!this.tre_department.isExistsParent(this.tnp_ccode.text,ConstsModel.ROLE_PID_WARNMSG))
	{
		return false;
	}
	return true;
}

/**
 *
 * 函数名：
 * 作者：钟晶
 * 日期：2011-08-02
 * 功能： 封装角色值
 * 参数：无
 * 返回值：角色
 * 修改记录：
 * 
 */
private function getRoleItem():DepartmentVo
{
	departmentVo = new DepartmentVo();
	departmentVo.ccode = this.tnp_ccode.text;
	departmentVo.cname = this.tnp_cname.text;
	
	if(IheadBox.getChildByName("UI_C1")!=null){
		var consult1:CrmEapTextInput = this.IheadBox.getChildByName("UI_C1") as CrmEapTextInput;
		if(consult1.text!=null&&consult1.text!=null&&consult1.text!=""){
			departmentVo.ihead = consult1.consultList.getItemAt(0)[consult1.singleType.cconsultbkfld];
		}
		
	}else
	{
		departmentVo.ihead =0;
	}
	
	if(IchargeBox.getChildByName("UI_C2")!=null){
		var consult1:CrmEapTextInput = this.IchargeBox.getChildByName("UI_C2") as CrmEapTextInput;
		if(consult1.text!=null&&consult1.text!=null&&consult1.text!=""){
			departmentVo.icharge = consult1.consultList.getItemAt(0)[consult1.singleType.cconsultbkfld];
		}
		
	}else
	{
		departmentVo.icharge =0;
	}
	
	if(IleadBox.getChildByName("UI_C3")!=null){
		var consult1:CrmEapTextInput = this.IleadBox.getChildByName("UI_C3") as CrmEapTextInput;
		if(consult1.text!=null&&consult1.text!=null&&consult1.text!=""){
			departmentVo.ilead = consult1.consultList.getItemAt(0)[consult1.singleType.cconsultbkfld];
		}
		
	}else
	{
		departmentVo.ilead =0;
	}
	
	
	if(this.itemType=="onEdit")
	{
		departmentVo.iid =  int(Number(this.tre_department.selectedItem.@iid));
		departmentVo.oldCcode = this.tre_department.selectedItem.@ccode;
	}
	
	departmentVo.iperson = 0;
	departmentVo.ipid = this.tre_department.getIpid(this.tnp_ccode.text);
	departmentVo.cabbreviation = this.tnp_cabbreviation.text;
	return departmentVo;
}

/**
 * 
 * 作者：zhong_jing
 * 日期：2011-08-08 
 * 功能：确定删除树
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function onDelete(event:Event):void
{
	this.itemType ="onDelete";
	
	if(this.tre_department.selectedItem==null)
	{
		CRMtool.showAlert("请选择后再操作...");
	}
	else if(this.jobArr.length>0||irealpersonAll>0){
		CRMtool.showAlert("不允许删除。原因：被相关业务引用");
	}else{
		var ccode:String = this.tre_department.selectedItem.@ccode as String;
		if(this.tre_department.isExistsChild(this.tre_department.selectedItem.@ccode,ConstsModel.DEPARTMENT_ROMEVE_PID))
		{
			return;
		}
		CRMtool.tipAlert(ConstsModel.DETERMINE_HEAD+this.tre_department.selectedItem.@ccname+ConstsModel.DEPARTMENT_TAIL,null,"AFFIRM",this,"onDeleteTree");
	}	
}

/**
 * 
 * 作者：zhong_jing
 * 日期：2011-08-08 
 * 功能：删除树
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function onDeleteTree():void
{
	AccessUtil.remoteCallJava("HrDepartmentDest","removeDepartment",saveTreecallBackHandler,int(Number(this.tre_department.selectedItem.@iid)),ConstsModel.DEPARTMENT_REMOVE_INFO);
}

/**
 * 
 * 作者：zhong_jing
 * 日期：2011-08-09 
 * 功能 保存节点
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function onSave(event:Event):void
{
	if(!this.checkValue())
	{
		return;	
	}
	itemType = itemType;
	departmentVo = new DepartmentVo();
	departmentVo = getRoleItem();
	if(itemType=="onNew")
	{
		AccessUtil.remoteCallJava("HrDepartmentDest","addDepartment",saveTreecallBackHandler,departmentVo,ConstsModel.DEPARTMENT_ADD_INFO); 
	}
	else
	{
		AccessUtil.remoteCallJava("HrDepartmentDest","updateDepartment",saveTreecallBackHandler,departmentVo,ConstsModel.DEPARTMENT_UPDATE_INFO);
	}
}

/**
 *
 * 函数名：
 * 作者：钟晶
 * 日期：2011-08-02
 * 功能： 实现功能
 * 参数： event（实现哪个功能）
 * 返回值：无
 * 修改记录：
 * 
 */
public function clickbtr(event:ItemClickEvent):void
{
	var type:String=event.item.name;
	CRMtool.toolButtonsEnabled(this.lbr_Department,type,this.tre_department.treeCompsXml.length());
	if(type !="onSave" ){
		itemType=type;
	}
	if(type=="onNew"||type=="onEdit")
	{
		CRMtool.containerChildsEnabled(this.myBorder,true);
	}
	else if(type=="onGiveUp")
	{
		CRMtool.containerChildsEnabled(this.myBorder,false);
	}
}



/**
 * 
 * 作者：zhong_jing
 * 日期：2011-08-09 
 * 功能 查询部门
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function getDepartmentTreeXml(all:String="false"):void
{
	AccessUtil.remoteCallJava("RoleDest","getDepartment",getEpartmencallBackHandler,all,ConstsModel.EPARTMENT_GET_INFO);
}



private function getEpartmencallBackHandler(event:ResultEvent):void
{
	/*	this.tnp_ilead.visibleIcon = false;
	*/	if(event.result!=null)
	{
		var result:String = event.result as String;
		this.tre_department.treeCompsXml = new XML(result);
		CRMtool.toolButtonsEnabled(this.lbr_Department,null,this.tre_department.treeCompsXml.length());
	}
	else
	{
		CRMtool.toolButtonsEnabled(this.lbr_Department,null,0);
	}
	
	CRMtool.containerChildsEnabled(this.myBorder,false);
	
}

/**
 * 
 * 作者：zhong_jing
 * 日期：2011-08-08 
 * 功能：新增一行记录
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function addNewItem():void {
	if(!this.tre_department.selectedItem)
	{
		CRMtool.tipAlert(ConstsModel.CHOOSE_ROLE);
		return;
	}
	var jobVo:JobVo = new JobVo();
	jobVo.departmentName = this.tre_department.selectedItem.@cname;
	jobVo.idepartment = this.tre_department.selectedItem.@iid;
	jobArr.addItem(jobVo);
}

/**
 * 
 * 作者：zhong_jing
 * 日期：2011-08-08 
 * 功能：删除一行记录
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function deleteItem():void
{
	if(!this.dgrd_department.selectedItem)
	{
		CRMtool.tipAlert(ConstsModel.CHOOSE_ROLE);
		return;
	}

    if(this.dgrd_department.selectedItem.irealperson>0){
        CRMtool.tipAlert("在编人数大于0，不允许删除。");
        return;
    }

	removeArr.addItem(this.dgrd_department.selectedItem);
	
	jobArr.removeItemAt(jobArr.getItemIndex(this.dgrd_department.selectedItem));
/*	for(var i:int=0;i<this.jobArr.length;i++)
	{
		if(jobArr.getItemAt(i)==this.dgrd_department.selectedItem)
		{
			jobArr.removeItemAt(i);
		}
	}*/
}

/**
 * 
 * 作者：zhong_jing
 * 日期：2011-08-08 
 * 功能：校验
 * 参数：无
 * 返回值：无
 * 修改人：
 * 修改时间：
 * 修改记录：
 * 
 */ 
public function checkJob():Boolean
{
	var forengCode:String=null;
	var arc:ArrayCollection = new ArrayCollection();
	sortAc();
	if(this.jobArr.length==0 && this.removeArr.length == 0)
	{
		CRMtool.tipAlert("没有要保存的记录");
		return false;
	}
	for each(var jobVo:JobVo in this.jobArr)
	{
		if(jobVo.ccode==null)
		{
			CRMtool.tipAlert("编码不能为空！！");
			return false;
		}
		else if(jobVo.cname==null)
		{
			CRMtool.tipAlert("岗位名称不能为空！！");
			return false;
		}
		/*else if(jobVo.iperson==0)
		{
			CRMtool.tipAlert("编制人数不能为空！！");
			return false;
		}*/
		
		if(forengCode==null)
		{
			forengCode = jobVo.ccode;
		}
		else
		{
			if(forengCode==jobVo.ccode)
			{
				arc.addItem(jobVo);
			}
			else
			{
				forengCode = jobVo.ccode;
			}
		}
	}
	if(arc.length>0)
	{
		CRMtool.tipAlert("编码不能重复！！");
		return false;
	}
	return true;
}

private function sortAc():void
{
	var sort:Sort=new Sort();  
	//按照ID升序排序  
	sort.fields=[new SortField("ccode")];  
	
	this.jobArr.sort=sort;  
	this.jobArr.refresh();//更新  
}

public function onSaveJob():void
{
	if(!checkJob())
	{
		return;
	}
	var obj:Object = new Object();
	obj.jobArr = this.jobArr;
	obj.removeArr = this.removeArr;
	AccessUtil.remoteCallJava("HrDepartmentDest","addJob",saveJobcallBackHandler,obj,ConstsModel.DEPARTMENT_REMOVE_INFO);
	
	this.removeArr.removeAll();
}

public function saveJobcallBackHandler(event:ResultEvent):void
{
	if(event.result==null)
	{
		CRMtool.tipAlert("保存失败");
	}
	else
	{
		CRMtool.tipAlert("保存成功");
		var addArr:ArrayCollection = event.result as ArrayCollection;
		for each(var jobVo:JobVo in addArr)
		{
			for each(var job:JobVo in this.jobArr)
			{
				if(job.iid==0&&job.ccode==jobVo.ccode)
				{
					job.iid = jobVo.iid;
				}
			}
		}
		
		enableConsult(false);
	}
}

public function enableConsult(b:Boolean):void{
	if(IheadBox.getChildByName("UI_C1")!=null){
		var consult1:CrmEapTextInput = this.IheadBox.getChildByName("UI_C1") as CrmEapTextInput;
		consult1.enabled = b;
	}
	
	
	if(IchargeBox.getChildByName("UI_C2")!=null){
		var consult1:CrmEapTextInput = this.IchargeBox.getChildByName("UI_C2") as CrmEapTextInput;
		consult1.enabled = b;
	}
	
	if(IleadBox.getChildByName("UI_C3")!=null){
		var consult1:CrmEapTextInput = this.IleadBox.getChildByName("UI_C3") as CrmEapTextInput;
		consult1.enabled = b;
	}
}

public function departmentFomart(item:Object,icol:int):String
{
	return this.tre_department.selectedItem.@cname;		
}

public function selectedJob():void
{
	
	if(!this.tre_department.selectedItem)
	{
		CRMtool.tipAlert(ConstsModel.CHOOSE_ROLE);
		return;
	}
	
	if(IheadBox.getChildByName("UI_C1")!=null){
		var consult1:CrmEapTextInput = this.IheadBox.getChildByName("UI_C1") as CrmEapTextInput;
		consult1.text = this.tre_department.selectedItem.@ihead;
		consult1.onDataChange();
	}
	
	
	if(IchargeBox.getChildByName("UI_C2")!=null){
		var consult1:CrmEapTextInput = this.IchargeBox.getChildByName("UI_C2") as CrmEapTextInput;
		consult1.text = this.tre_department.selectedItem.@icharge;
		consult1.onDataChange();
	}
	
	if(IleadBox.getChildByName("UI_C3")!=null){
		var consult1:CrmEapTextInput = this.IleadBox.getChildByName("UI_C3") as CrmEapTextInput;
		consult1.text = this.tre_department.selectedItem.@ilead;
		consult1.onDataChange();
	}

    if(this.tre_department.selectedItem.@istatus==2){
        (pauseBar.getChildAt(0) as Button).enabled = false;
        (pauseBar.getChildAt(1) as Button).enabled = true;
    }else{
        (pauseBar.getChildAt(1) as Button).enabled = false;
        (pauseBar.getChildAt(0) as Button).enabled = true;
    }
	
	
	AccessUtil.remoteCallJava("HrDepartmentDest","getJobVoById",selectedJobcallBackHandler,int(Number(this.tre_department.selectedItem.@iid))
		,null,false);

    var sql:String = "select count(iid) as con from hr_person where   bjobstatus=1 and idepartment = "+Number(this.tre_department.selectedItem.@iid);
    AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
        var ac:ArrayCollection = event.result as ArrayCollection;
        if(ac&&ac.length>0)
         irealpersonAll = ac[0].con;
    }, sql, null, false);
}

private function selectedJobcallBackHandler(event:ResultEvent):void
{ 
	this.jobArr = event.result as ArrayCollection;
	sumTwoJobPersonNum(jobArr);
	dgrd_department.addEventListener(KeyboardEvent.KEY_DOWN,CRMtool.doKeyDown);
	cal();
}

private function sumTwoJobPersonNum(jobArr:ArrayCollection):void
{
	var ipersonNum:int;
	var irealpersonNum:int;
	
	for each(var jobvo:JobVo in jobArr){
		
		ipersonNum = ipersonNum+jobvo.iperson;
		irealpersonNum = irealpersonNum+jobvo.irealperson;
	}
	
//	this.tnp_iperson.text = ipersonNum+"";
//	this.tnp_irealperson.text = irealpersonNum+"";

}


private function onGiveUp(event:Event):void
{
	/*	this.itemType ="onGiveUp";*/
	
	if(this.itemType=="onNew")
	{
		this.tnp_ccode.text ="";
		this.tnp_cname.text ="";
		this.tnp_cabbreviation.text="";
		tnp_iperson.text="";
		tnp_irealperson.text="";
		if(IheadBox.getChildByName("UI_C1")!=null){
			var consult1:CrmEapTextInput = this.IheadBox.getChildByName("UI_C1") as CrmEapTextInput;
			consult1.text = "";
		}
		
		
		if(IchargeBox.getChildByName("UI_C2")!=null){
			var consult1:CrmEapTextInput = this.IchargeBox.getChildByName("UI_C2") as CrmEapTextInput;
			consult1.text = "";
		}
		
		if(IleadBox.getChildByName("UI_C3")!=null){
			var consult1:CrmEapTextInput = this.IleadBox.getChildByName("UI_C3") as CrmEapTextInput;
			consult1.text = "";
		}
		
		enableConsult(false);
	}
	else
	{
		selectedJob();
	}
	if(null==this.tre_department.treeCompsXml)
	{
		CRMtool.toolButtonsEnabled(this.lbr_Department,"onGiveUp",0);
	}
	else
	{
		CRMtool.toolButtonsEnabled(this.lbr_Department,"onGiveUp",this.tre_department.treeCompsXml.length());
	}
	CRMtool.containerChildsEnabled(this.myBorder,false);
	this.tre_department.enabled = true;
}

public function onNew(event:Event):void
{
	//回车替代TAB键
	//CRMtool.setTabIndex(this.myBorder);
	this.tre_department.enabled= false;
	this.tre_department.selectedIndex=-1;
	this.tnp_ccode.text ="";
	this.tnp_cname.text ="";
	this.tnp_iperson.text="";
	tnp_irealperson.text = "";
	jobArr=new ArrayCollection();
	/*	this.tnp_iperson.te="0"*/;
	enableConsult(true);
	if(IheadBox.getChildByName("UI_C1")!=null){
		var consult1:CrmEapTextInput = this.IheadBox.getChildByName("UI_C1") as CrmEapTextInput;
		consult1.text = "";
	}
	
	
	if(IchargeBox.getChildByName("UI_C2")!=null){
		var consult1:CrmEapTextInput = this.IchargeBox.getChildByName("UI_C2") as CrmEapTextInput;
		consult1.text = "";
	}
	
	if(IleadBox.getChildByName("UI_C3")!=null){
		var consult1:CrmEapTextInput = this.IleadBox.getChildByName("UI_C3") as CrmEapTextInput;
		consult1.text = "";
	}
	
	this.itemType ="onNew";
	
	jobArr.removeAll();
	CRMtool.toolButtonsEnabled(this.lbr_Department,"onNew");
	CRMtool.containerChildsEnabled(this.myBorder,true);
}

public function onEdit(event:Event):void
{
	//回车替代TAB键
	//CRMtool.setTabIndex(this.myBorder);
	
	if(!this.tre_department.selectedItem)
	{
		CRMtool.tipAlert(ConstsModel.CHOOSE_ROLE);
		return;
	}

	this.tre_department.enabled= false;
	this.itemType ="onEdit";
	enableConsult(true);
	CRMtool.toolButtonsEnabled(this.lbr_Department,"onEdit");
	CRMtool.containerChildsEnabled(this.myBorder,true);
	tnp_irealperson.editable=false;
	tnp_iperson.editable=false;
}
