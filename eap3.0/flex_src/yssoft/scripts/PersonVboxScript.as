import flash.events.Event;
import flash.events.MouseEvent;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.DateField;
import mx.events.IndexChangedEvent;
import mx.events.ValidationResultEvent;
import mx.formatters.DateFormatter;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;
import mx.validators.EmailValidator;

import yssoft.models.ConstsModel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.views.person.PersonRecord;
import yssoft.vos.AbInvoiceatmVo;
import yssoft.vos.HrPersonVo;

private var item:String;

public var parentForm:Object;

[Bindable]
private var ieducationArr:ArrayCollection = new ArrayCollection([
	{value:0,label:"博士"},
	{value:1,label:"硕士"},
	{value:2,label:"本科"},
	{value:3,label:"大专"},
	{value:4,label:"中专"},
	{value:5,label:"其他"} 
]);


public function init():void
{
	parentForm = this.owner;
/*	this.rbtgn_bjobstatus.selectedValue="1";
	this.rbtn_working.selected = true;
	this.rbtn_Leaving.selected = false;
	this.rbtgn_busestatus.selectedValue="0";
	this.rbtn_enabled.selected = false;
	this.rbtn_disable.selected = true;*/
	if(_personVo!=null)
	{
		this.rbtgn_bjobstatus.selectedValue = _personVo.bjobstatus;
		if(_personVo.bjobstatus)
		{
			this.rbtn_working.selected = true;
		}
		else
		{
			this.rbtn_Leaving.selected = true;
		}
		
		this.rbtgn_busestatus.selectedValue = _personVo.busestatus;
		
		if( _personVo.busestatus)
		{
			this.rbtn_enabled.selected = true;
		}
		else
		{
			this.rbtn_disable.selected = true;
		}
		
		this.rbtn_sex.selectedValue = _personVo.isex;
		if(_personVo.isex==0)
		{
			this.rbtn_Male.selected = true;	
		}
		else if(_personVo.isex==1)
		{
			this.rbtn_Female.selected = true;	
		}
		else
		{
			this.rbtn_Unknown.selected = true;	
		}
	}
	else
	{
		this.rbtgn_bjobstatus.selectedValue="1";
		this.rbtn_working.selected = true;
		this.rbtn_Leaving.selected = false;
		this.rbtgn_busestatus.selectedValue="1";
		this.rbtn_enabled.selected = true;
		this.rbtn_disable.selected = false;
	}
	CRMtool.containerChildsEnabled(this,false);
	CRMtool.setTabIndex(this);
	clear();
	
}

public function clear():void
{
	if(this.tnp_idepartment.text=="0")
	{
		this.tnp_idepartment.text="";
	}
	if(this.tnp_ipost.text=="0")
	{
		this.tnp_ipost.text="";
	}
	if(this.tnp_ijob1.text=="0")
	{
		this.tnp_ijob1.text="";
	}
	
	if(this.tnp_ijob2.text=="0")
	{
		this.tnp_ijob2.text="";
	}
}




//添加
public function onNew():void
{
	this.tnp_ccode.text ="";
	this.tnp_cname.text="";
	this.rbtgn_bjobstatus.selectedValue="1";
	this.rbtn_working.selected = true;
	this.rbtn_Leaving.selected = false;
	this.rbtgn_busestatus.selectedValue="1";
	this.rbtn_enabled.selected = true;
	this.rbtn_disable.selected = false;
	this.tnp_cusecode.text="";
	this.tnp_idepartment.text="";
	this.tnp_ipost.text="";
	this.tnp_ijob1.text="";
	this.tnp_ijob2.text="";
	this.rbtn_sex.selectedValue="0";
	this.rbtn_Male.selected = true;
	this.tnp_dbirthday.text="";
	this.cmb_ieducation.selectedIndex=-1;
	this.tnp_cdiscipline.text="";
	this.tnp_ctel.text ="";
	this.tnp_cmobile1.text="";
	this.tnp_cmobile2.text="";
	this.tnp_cemail.text="";
	this.tnp_chaddress.text="";
	this.tnp_chtel.text="";
	this.tnp_cmemo.text="";
	
	item = "onNew";
	CRMtool.containerChildsEnabled(this,true);
	this.tnp_ccode.editable = false;
}
[Bindable]
private var _personVo:HrPersonVo;

public function set personVo(value:HrPersonVo):void
{
	this._personVo = value;
}

public function getPersonItem():HrPersonVo
{
	var personVo:HrPersonVo = new HrPersonVo();
	if(item=="onEdit")
	{
		personVo.iid = _personVo.iid;
	}
	personVo.ccode = this.tnp_ccode.text;
	personVo.cname = this.tnp_cname.text;
	personVo.bjobstatus = this.rbtgn_bjobstatus.selectedValue;
	personVo.busestatus =this.rbtgn_busestatus.selectedValue;
	
	/*if(this.rbtgn_bjobstatus.selectedValue==1)
	{
		personVo.bjobstatus = true;
	}
	else
	{
		personVo.bjobstatus = false;
	}
	if(this.rbtgn_busestatus.selectedValue==0)	
	{
		personVo.busestatus = false;
	}
	else
	{
		personVo.busestatus = true;
	}*/
	personVo.cusecode=this.tnp_cusecode.text;
	if(CRMtool.isStringNotNull(this.tnp_idepartment.text))
	{
		personVo.idepartment = int(Number(this.tnp_idepartment.cconsultbkfld.getItemAt(0)));
	}
	else
	{
		personVo.idepartment =0;
	}
	if(CRMtool.isStringNotNull(this.tnp_ipost.text))
	{
		personVo.ipost =int(Number(this.tnp_ipost.cconsultbkfld.getItemAt(0)));
	}
	else
	{
		personVo.ipost =0;
	}
	if(CRMtool.isStringNotNull(this.tnp_ijob1.text))
	{
		personVo.ijob1 =int(Number(this.tnp_ijob1.cconsultbkfld.getItemAt(0)));
	}
	else
	{
		personVo.ijob1=0;
	}
	if(CRMtool.isStringNotNull(this.tnp_ijob2.text))
	{
		personVo.ijob2=int(Number(this.tnp_ijob2.cconsultbkfld.getItemAt(0)));
	}
	else
	{
		personVo.ijob2=0;
	}
	personVo.isex = int(Number(this.rbtn_sex.selectedValue));
	
	var startDate:Date = DateField.stringToDate(this.tnp_dbirthday.text,"YYYY-MM-DD"); 
	personVo.dbirthday = startDate;
	if(this.cmb_ieducation.selectedIndex!=-1)
	{
		personVo.ieducation =int(Number(this.cmb_ieducation.selectedItem.value));
	}
	personVo.cdiscipline = this.tnp_cdiscipline.text;
	personVo.ctel=this.tnp_ctel.text;
	personVo.cmobile1 =this.tnp_cmobile1.text;
	personVo.cmobile2 =this.tnp_cmobile2.text;
	personVo.cemail =this.tnp_cemail.text;
	personVo.chaddress = this.tnp_chaddress.text;
	personVo.chtel = this.tnp_chtel.text;
	personVo.cmemo = this.tnp_cmemo.text;
	return personVo;	
}

public function onEdit():void
{
	item="onEdit";
	clear();
	CRMtool.containerChildsEnabled(this,true);
	this.tnp_ccode.editable = false;
}
	

public function onSave():void
{
	if(!checkValue())
	{
		return;
	}
	if(item=="onNew")
	{
		var arr:ArrayCollection = new ArrayCollection();
		var objv:Object = new Object();
		objv.cfield = "idepartment";
		objv.fieldvalue = tnp_idepartment.cabbreviation;
		arr.addItem(objv);
		
		var obj:Object = new Object();
		obj.iid = 13;
		obj.ctable = "HR_person";
		var daf:DateFormatter = new DateFormatter();
		daf.formatString ="YYYYMMDD";
		obj.cusdate = daf.format(new Date());
		
		obj.frontlist = arr;
		AccessUtil.remoteCallJava("NumberSetDest","savenumber",savenumberBack,obj);
		/*AccessUtil.remoteCallJava("hrPersonDest","addPerson",savePerson,getPersonItem(),"新增人员处理中..."); */
	}
	else
	{
		AccessUtil.remoteCallJava("hrPersonDest","updatePerson",savePerson,getPersonItem(),"修改用户处理中...");
	}
}


public function savenumberBack(event:ResultEvent):void
{
	var result:String = event.result.number as String;
	var personVo:HrPersonVo = getPersonItem();
	personVo.ccode = result;
	AccessUtil.remoteCallJava("hrPersonDest","addPerson",savePerson,personVo,"新增人员处理中..."); 
}

private function savePerson(event:ResultEvent):void
{
	if(event.result || event.result.toString()!="fail")
	{ 
		if(item =="onNew")
		{
			var personVo:HrPersonVo = getPersonItem();
			personVo.iid = int(Number(event.result));
			parentForm.pageInitBack(personVo,item);
			CRMtool.tipAlert("新增人员成功！！");
		}
		else if(item=="onDelete")
		{
			parentForm.deleteInitBack(_personVo.iid);
			CRMtool.tipAlert("删除人员成功!!");
		}
		else if(item=="onEdit")
		{
			var personVo:HrPersonVo = getPersonItem();
			parentForm.pageInitBack(personVo,item);
			CRMtool.tipAlert("修改人员成功！！");
		}
		CRMtool.containerChildsEnabled(this,false);
	}
	else
	{
		CRMtool.tipAlert(ConstsModel.FAIL);
	}
}

public function removePerson():void
{
	CRMtool.tipAlert(ConstsModel.DETERMINE_HEAD+_personVo.cname+"这个人员？】",null,"AFFIRM",this,"onDeletePerson");
}

public function onDeletePerson():void
{
	this.item="onDelete";
	this.clear();
	var paramObj:Object = new Object();
	paramObj.iid = this._personVo.iid;
	AccessUtil.remoteCallJava("hrPersonDest","removePerson",savePerson,paramObj,"删除人员处理中...");
}

public function onGiveUp():void
{
	this.tnp_ccode.text ="";
	this.tnp_cname.text="";
	this.rbtgn_bjobstatus.selectedValue="1";
	this.rbtn_working.selected = true;
	this.rbtn_Leaving.selected = false;
	this.rbtgn_busestatus.selectedValue="0";
	this.rbtn_enabled.selected = false;
	this.rbtn_disable.selected = true;
	this.tnp_cusecode.text="";
	this.tnp_idepartment.text="";
	this.tnp_ipost.text="";
	this.tnp_ijob1.text="";
	this.tnp_ijob2.text="";
	this.rbtn_sex.selectedValue="0";
	this.rbtn_Male.selected = true;
	this.tnp_dbirthday.text="";
	this.cmb_ieducation.selectedIndex=-1;
	this.tnp_cdiscipline.text="";
	this.tnp_ctel.text ="";
	this.tnp_cmobile1.text="";
	this.tnp_cmobile2.text="";
	this.tnp_cemail.text="";
	this.tnp_chaddress.text="";
	this.tnp_chtel.text="";
	this.tnp_cmemo.text="";
	CRMtool.containerChildsEnabled(this,false);
}

public function checkValue():Boolean
{
	if(CRMtool.isStringNull(this.tnp_ccode.text))
	{
		CRMtool.tipAlert("人员编码不能为空！！",this.tnp_ccode);
		return false;
	}
	else if(CRMtool.isStringNull(this.tnp_cusecode.text))
	{
		CRMtool.tipAlert("操作员账号不能为空！！",this.tnp_cusecode);
		return false;
	}
	else if(CRMtool.isStringNull(this.tnp_cname.text))
	{
		CRMtool.tipAlert("姓名不能为空！！",this.tnp_cname);
		return false;
	}
	else if(CRMtool.isStringNotNull(this.tnp_cemail.text))
	{
		var cemailReg:RegExp = /^([a-zA-Z0-9_-])+@([a-zA-Z0-9_-])+(.[a-zA-Z0-9_-])+/;
		
		if(!cemailReg.test(this.tnp_cemail.text))
		{
			CRMtool.tipAlert("电子邮件格式不正确！！",this.tnp_cemail);
			return false;
		}
	}
	return true;
}

public function getNumber(event:Event):void
{
	var arr:ArrayCollection = new ArrayCollection();
	var objv:Object = new Object();
	objv.cfield = "idepartment";
	objv.fieldvalue = tnp_idepartment.cabbreviation;
	arr.addItem(objv);
	
	var obj:Object = new Object();
	obj.iid = 13;
	obj.ctable = "HR_person";
	var daf:DateFormatter = new DateFormatter();
	daf.formatString ="YYYYMMDD";
	obj.cusdate = daf.format(new Date());
	
	obj.frontlist = arr;
	AccessUtil.remoteCallJava("NumberSetDest","showNumber",onBack,obj);
}

private function onBack(event:ResultEvent):void
{
	var result:String = event.result.number as String;
	this.tnp_ccode.text = result;
}

private function myCB_changeHandler():void
{
	if(cmb_ieducation.selectedIndex == spark.components.ComboBox.CUSTOM_SELECTED_ITEM)
	{
		cmb_ieducation.selectedItem="";
	}
}
