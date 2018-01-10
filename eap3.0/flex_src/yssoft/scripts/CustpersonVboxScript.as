import mx.collections.ArrayCollection;
import mx.controls.DateField;
import mx.formatters.DateFormatter;
import mx.rpc.events.ResultEvent;

import yssoft.models.ConstsModel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.vos.CsCustpersonVo;

[Bindable]
private var icountryArr:ArrayCollection = new ArrayCollection([
	{value:0,label:"博士"},
	{value:1,label:"硕士"},
	{value:2,label:"本科"},
	{value:3,label:"大专"},
	{value:4,label:"中专"},
	{value:5,label:"其他"} 
]);

public var item:String="onDelete";

private var _custpersonVo:CsCustpersonVo;

public var parentForm:Object;

public function set custpersonVo(value:CsCustpersonVo):void
{
	this._custpersonVo = value;
}

public function init():void
{
	parentForm = this.owner;
	CRMtool.containerChildsEnabled(this,false);
	CRMtool.setTabIndex(this);
}

private function getItem():CsCustpersonVo
{
	var csCustpersonVo:CsCustpersonVo = new CsCustpersonVo();
	csCustpersonVo.ccode = this.tnp_ccode.text;
	csCustpersonVo.cname = this.tnp_cname.text;
	csCustpersonVo.icustomer = int(Number(this.tnp_icustomer.text));
	csCustpersonVo.icustpnclass = int(Number(this.tnp_icustpnclass.text));
	csCustpersonVo.ctitle = this.tnp_ctitle.text;
	csCustpersonVo.cdepartment = this.tnp_cdepartment.text;
	csCustpersonVo.cpost = this.tnp_cpost.text;
	csCustpersonVo.isuperiors = int(Number(this.tnp_isuperiors.text));
	csCustpersonVo.bcharge = this.chbx_bcharge.selected;
	csCustpersonVo.bkeycontect = this.chbx_bkeycontect.selected;
	csCustpersonVo.cmobile1 = this.tnp_cmobile1.text;
	csCustpersonVo.ctel = this.tnp_ctel.text;
	csCustpersonVo.cemail = this.tnp_cemail.text;
	csCustpersonVo.cfax = this.tnp_cfax.text;
	csCustpersonVo.caddress = this.tnp_caddress.text;
	csCustpersonVo.czipcode = this.tnp_czipcode.text;
	csCustpersonVo.cqqmsn = this.tnp_cqqmsn.text;
	csCustpersonVo.ccarnumber = this.tnp_ccarnumber.text;
	
	csCustpersonVo.isex = int(Number(this.rbtn_sex.selectedValue));
	
	csCustpersonVo.dbirthday = DateField.stringToDate(this.dfl_dbirthday.text,"YYYY-MM-DD");
	csCustpersonVo.cnation = this.tnp_cnation.text;
	csCustpersonVo.ceducation = this.cmb_ieducation.selectedItem.value;
	csCustpersonVo.cprofessional = this.tnp_cprofessional.text;
	csCustpersonVo.cidnumber = this.tnp_cidnumber.text;
	csCustpersonVo.cbirthplace = this.tnp_cbirthplace.text;
	csCustpersonVo.cgraduated = this.tnp_cgraduated.text;
	csCustpersonVo.ccharacter = this.tnp_ccharacter.text;
	csCustpersonVo.chobby = this.tnp_chobby.text;
	csCustpersonVo.chabit = this.tnp_chabit.text;
	csCustpersonVo.crelationship = this.tnp_crelationship.text;
	csCustpersonVo.cfriendships = this.tnp_cfriendships.text;
	csCustpersonVo.cmarital = this.tnp_cmarital.text;
	csCustpersonVo.cspouse = this.tnp_cspouse.text;
	csCustpersonVo.cspouseworkunit = this.tnp_cspouseworkunit.text;
	csCustpersonVo.cspousepost = this.tnp_cspousepost.text;
	csCustpersonVo.cspousetel = this.tnp_cspousetel.text;
	csCustpersonVo.cfamilymembers = this.tnp_cfamilymembers.text;
	return csCustpersonVo;
}

public function onNew():void
{
	 this.tnp_ccode.text="";
	 this.tnp_cname.text="";
	 this.tnp_icustomer.text="";
	 this.tnp_icustpnclass.text="";
	 this.tnp_ctitle.text="";
	 this.tnp_cdepartment.text="";
	 this.tnp_cpost.text="";
	 this.tnp_isuperiors.text="";
	 this.chbx_bcharge.selected=false;
	 this.chbx_bkeycontect.selected = false;
	 this.tnp_cmobile1.text="";
	 this.tnp_ctel.text="";
	 this.tnp_cemail.text="";
	 this.tnp_cfax.text="";
	 this.tnp_caddress.text="";
	 this.tnp_czipcode.text="";
	 this.tnp_cqqmsn.text="";
	 this.tnp_ccarnumber.text="";
	 this.rbtn_sex.selectedValue="";
	 this.dfl_dbirthday.text="";
	 this.tnp_cnation.text="";
	 this.cmb_ieducation.selectedIndex=-1;
	 this.tnp_cprofessional.text="";
	 this.tnp_cidnumber.text="";
	 this.tnp_cbirthplace.text="";
	 this.tnp_cgraduated.text="";
	 this.tnp_ccharacter.text="";
	 this.tnp_chobby.text="";
	 this.tnp_chabit.text="";
	 this.tnp_crelationship.text="";
	 this.tnp_cfriendships.text="";
	 this.tnp_cmarital.text="";
	 this.tnp_cspouse.text="";
	 this.tnp_cspouseworkunit.text="";
	 this.tnp_cspousepost.text="";
	 this.tnp_cspousetel.text="";
	 this.tnp_cfamilymembers.text="";
	 item = "onNew";
	 CRMtool.containerChildsEnabled(this,true);
	/*AccessUtil.remoteCallJava("csCustomerDest","addCustpersonVo",savePerson,getItem()); */
}

public function onEdit():void
{
	item="onEdit";
	CRMtool.containerChildsEnabled(this,true);
	/*AccessUtil.remoteCallJava("csCustomerDest","updateCustpersonVo",savePerson,getItem());*/ 
}

public function onSave():void
{
	if(item=="onNew")
	{
		AccessUtil.remoteCallJava("csCustomerDest","addCsCustomer",saveCustperson,getItem());
	}
	else
	{
		AccessUtil.remoteCallJava("csCustomerDest","updateCsCustomer",saveCustperson,getItem());
	}
}

public function removeCsCustpersonVo():void
{
	CRMtool.tipAlert(ConstsModel.DETERMINE_HEAD+_custpersonVo.cname+"这个人员？】",null,"AFFIRM",this,"onDeleteCustperson");
	/*AccessUtil.remoteCallJava("csCustomerDest","removeCustpersonVo",saveCustperson,getItem()); */
}

public function onDeleteCustperson():void
{
	AccessUtil.remoteCallJava("csCustomerDest","removeCustpersonVo",saveCustperson,_custpersonVo.iid);
}


public function saveCustperson(event:ResultEvent):void
{
	if(event.result || event.result.toString()!="fail")
	{ 
		if(item =="onNew")
		{
			var personVo:CsCustpersonVo = getItem();
			personVo.iid = int(Number(event.result));
			parentForm.pageInitBack(personVo,item);
			CRMtool.tipAlert("新增客户档案成功！！");
		}
		else if(item=="onDelete")
		{
			parentForm.deleteInitBack(_custpersonVo.iid);
			CRMtool.tipAlert("删除客户档案成功!!");
		}
		else if(item=="onEdit")
		{
			CRMtool.tipAlert("修改客户档案成功！！");
		}
		CRMtool.containerChildsEnabled(this,false);
	}
	else
	{
		CRMtool.tipAlert(ConstsModel.FAIL);
	}
}

public function onGiveUp():void
{
	this.tnp_ccode.text="";
	this.tnp_cname.text="";
	this.tnp_icustomer.text="";
	this.tnp_icustpnclass.text="";
	this.tnp_ctitle.text="";
	this.tnp_cdepartment.text="";
	this.tnp_cpost.text="";
	this.tnp_isuperiors.text="";
	this.chbx_bcharge.selected=false;
	this.chbx_bkeycontect.selected = false;
	this.tnp_cmobile1.text="";
	this.tnp_ctel.text="";
	this.tnp_cemail.text="";
	this.tnp_cfax.text="";
	this.tnp_caddress.text="";
	this.tnp_czipcode.text="";
	this.tnp_cqqmsn.text="";
	this.tnp_ccarnumber.text="";
	this.rbtn_sex.selectedValue="";
	this.dfl_dbirthday.text="";
	this.tnp_cnation.text="";
	this.cmb_ieducation.selectedIndex=-1;
	this.tnp_cprofessional.text="";
	this.tnp_cidnumber.text="";
	this.tnp_cbirthplace.text="";
	this.tnp_cgraduated.text="";
	this.tnp_ccharacter.text="";
	this.tnp_chobby.text="";
	this.tnp_chabit.text="";
	this.tnp_crelationship.text="";
	this.tnp_cfriendships.text="";
	this.tnp_cmarital.text="";
	this.tnp_cspouse.text="";
	this.tnp_cspouseworkunit.text="";
	this.tnp_cspousepost.text="";
	this.tnp_cspousetel.text="";
	this.tnp_cfamilymembers.text="";
	item = "onNew";
	CRMtool.containerChildsEnabled(this,true);
}