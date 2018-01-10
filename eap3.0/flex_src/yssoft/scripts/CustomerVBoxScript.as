import mx.collections.ArrayCollection;
import mx.rpc.events.ResultEvent;

import yssoft.models.ConstsModel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.vos.CsCustomerVo;
import yssoft.vos.CsCustpersonVo;
import yssoft.vos.CustomVo;

[Bindable]
private var icountryArr:ArrayCollection = new ArrayCollection([
	{value:0,label:"中国"}
]);

//省份
[Bindable]
private var iprovinceArr:ArrayCollection = new ArrayCollection([
	{value:0,label:"河北"},
	{value:1,label:"河南"},
	{value:2,label:"陜西"},
	{value:3,label:"山西"},
	{value:4,label:"山东"},
	{value:5,label:"甘肃"},
	{value:6,label:"辽宁"},
	{value:7,label:"吉林"},
	{value:8,label:"黑龙江"},
	{value:9,label:"云南"},
	{value:10,label:"贵州"},
	{value:11,label:"福建"},
	{value:12,label:"广东"},
	{value:13,label:"海南"},
	{value:14,label:"台湾"},
	{value:15,label:"四川"},
	{value:16,label:"湖北"},
	{value:17,label:"湖南"},
	{value:18,label:"江西"},
	{value:19,label:"安徽"},
	{value:20,label:"江苏"},
	{value:21,label:"浙江"},
	{value:22,label:"青海"},
	{value:23,label:"新疆维吾尔族自治区"},
	{value:24,label:"内蒙古自治区"},
	{value:24,label:"宁夏回族自治区"},
	{value:24,label:"西藏自治区"},
	{value:24,label:"广西壮族自治区"},
	{value:25,label:"北京市"},
	{value:26,label:"天津市"},
	{value:27,label:"重庆市"},
	{value:28,label:"上海市"},
	{value:29,label:"澳门特别行政区"},
	{value:30,label:"香港特别行政区"}
]);

//城市
[Bindable]
private var icityArr:ArrayCollection = new ArrayCollection([
	{value:0,label:"南京市",ipid:"20"},
	{value:1,label:"徐州市",ipid:"20"},
	{value:2,label:"连云港市",ipid:"20"},
	{value:3,label:"淮安市",ipid:"20"},
	{value:4,label:"宿迁市",ipid:"20"},
	{value:5,label:"盐城市",ipid:"20"},
	{value:6,label:"扬州市",ipid:"20"},
	{value:7,label:"泰州市",ipid:"20"},
	{value:8,label:"南通市",ipid:"20"},
	{value:9,label:"镇江市",ipid:"20"},
	{value:10,label:"常州市",ipid:"20"},
	{value:11,label:"无锡市",ipid:"20"},
	{value:12,label:"苏州市",ipid:"20"}
]);

public var parentForm:Object;

public var item:String="onDelete";

[Bindable]
private var _customerVo:CsCustomerVo;

private var _custpersonVo:CsCustpersonVo;

public function set customerVo(value:CsCustomerVo):void
{
	this._customerVo = value;
}

public function init():void
{
	parentForm = this.owner;
	CRMtool.containerChildsEnabled(this,false);
	CRMtool.setTabIndex(this);
}


private function getcsCustomerVoItem():CsCustomerVo
{
	var csCustomerVo:CsCustomerVo = new CsCustomerVo();
	if(item=="onEdit")
	{
		csCustomerVo.iid = _customerVo.iid;
	}
	
	csCustomerVo.ccode = this.tnp_ccode.text;
	csCustomerVo.cname = this.tnp_cname.text;
	csCustomerVo.icustclass= int(Number(this.tnp_icustclass.text));
	csCustomerVo.ipartnership =int(Number(this.tnp_ipartnership.text));
	csCustomerVo.iindustry = int(Number(this.tnp_iindustry.text));
	csCustomerVo.cwebsite = this.tnp_cwebsite.text;
	csCustomerVo.iorganization = int(Number(this.tnp_iorganization.text));
	csCustomerVo.iheadcust= int(Number(this.tnp_iheadcust.text));
	csCustomerVo.ivaluelevel=int(Number(this.tnp_ivaluelevel.text));
	csCustomerVo.isalesprocess =int(Number(this.tnp_isalesprocess.text));
	/*csCustomerVo.icountry = int(Number(this.cmb_ieducation.selectedItem.value));*/
	csCustomerVo.iprovince = int(Number(this.cmb_iprovince.selectedItem.value));
	csCustomerVo.icity = int(Number(this.cmb_icity.selectedItem.value));
	csCustomerVo.cofficeaddress = this.tnp_cofficeaddress.text;
	csCustomerVo.cofficezipcode = this.tnp_cofficezipcode.text;
	csCustomerVo.cshipaddress = this.tnp_cshipaddress.text;
	csCustomerVo.cshipzipcode = this.tnp_cshipzipcode.text;
	csCustomerVo.ctel = this.tnp_ctel.text;
	csCustomerVo.cfax = this.tnp_cfax.text;
	csCustomerVo.isalesarea =int(Number(this.tnp_isalesarea.text));
	csCustomerVo.isalesdepart =int(Number(this.tnp_isalesdepart.text));
	csCustomerVo.isalesperson =int(Number(this.tnp_isalesperson.text));
	csCustomerVo.icreditrating = int(Number(this.tnp_icreditrating.text));
	csCustomerVo.cproducteffect =this.tnp_cproducteffect.text;
	csCustomerVo.cmemo = this.tnp_cmemo.text;
	return csCustomerVo;
}

private function getCsCustpersonVoItem():CsCustpersonVo
{
	var cscustpersonVo:CsCustpersonVo = new CsCustpersonVo();
	if(item=="onEdit")
	{
		cscustpersonVo.iid = _custpersonVo.iid;
	}
/*	cscustpersonVo.cname = this.tnp_cname.text;*/
	cscustpersonVo.cdepartment = this.tnp_cdepartment.text;
	cscustpersonVo.cpost=this.tnp_cpost.text;
	cscustpersonVo.ctitle = this.tnp_ctitle.text;
	cscustpersonVo.cmobile1 = this.tnp_cmobile1.text;
/*	cscustpersonVo.ctel =this.tnp_ctel.text;*/
	cscustpersonVo.cemail =this.tnp_cemail.text;
	cscustpersonVo.isex = int(Number(this.rbtn_sex.selectedValue));
	return cscustpersonVo;
}

public function onSave():void
{
	if(item=="onNew")
	{
		var csCustomerVo:CsCustomerVo = this.getcsCustomerVoItem();
		var customerVo:CsCustpersonVo =  this.getCsCustpersonVoItem();
		var obj:Object = new Object();
		obj.csCustomerVo = csCustomerVo;
		obj.csCustpersonVo = csCustomerVo;
		AccessUtil.remoteCallJava("csCustomerDest","addCsCustomer",saveCsCustomerVo,obj);
	}
	else
	{
		AccessUtil.remoteCallJava("csCustomerDest","updateCsCustomer",saveCsCustomerVo,this.getcsCustomerVoItem());
	}
}



public function removeCustomer():void
{
	CRMtool.tipAlert(ConstsModel.DETERMINE_HEAD+_custpersonVo.cname+"这个人员？】",null,"AFFIRM",this,"onDeletecustperson");
}

public function onDeletecustperson():void
{
	this.item="onDelete";
	var obj:Object = new Object();
	obj.iid = this._customerVo.iid;
	obj.oldikeycontacts =this._custpersonVo.iid;
	AccessUtil.remoteCallJava("csCustomerDest","removeCsCustomer",saveCsCustomerVo,obj);
}

private function saveCsCustomerVo(event:ResultEvent):void
{
	if(event.result || event.result.toString()!="fail")
	{ 
		if(item =="onNew")
		{
			var personVo:CsCustomerVo = getcsCustomerVoItem();
			personVo.iid = int(Number(event.result));
			parentForm.pageInitBack(personVo,item);
			CRMtool.tipAlert("新增客户档案成功！！");
		}
		else if(item=="onDelete")
		{
			parentForm.deleteInitBack(_customerVo.iid);
			CRMtool.tipAlert("删除客户档案成功!!");
		}
		else if(item=="onEdit")
		{
			var personVo:CsCustomerVo = getcsCustomerVoItem();
			parentForm.pageInitBack(personVo,item);
			CRMtool.tipAlert("修改客户档案成功！！");
		}
		CRMtool.containerChildsEnabled(this,false);
	}
	else
	{
		CRMtool.tipAlert(ConstsModel.FAIL);
	}
}

public function onNew():void
{
	this.tnp_ccode.text="";
	/*	this.tnp_cname.text="";*/
	this.tnp_icustclass.text ="";
	this.tnp_ipartnership.text="";
	this.tnp_iindustry.text="";
	this.tnp_cwebsite.text="";
	this.tnp_iorganization.text="";
	this.tnp_iheadcust.text="";
	this.tnp_ivaluelevel.text="";
	this.tnp_isalesprocess.text="";
	/*this.cmb_ieducation.selectedIndex=-1;*/
	this.cmb_iprovince.selectedIndex=-1;
	this.cmb_icity.selectedIndex=-1;
	this.tnp_cofficeaddress.text="";
	this.tnp_cofficezipcode.text="";
	this.tnp_cshipaddress.text="";
	this.tnp_cshipzipcode.text="";
	/*	this.tnp_ctel.text="";*/
	this.tnp_cfax.text="";
	this.tnp_isalesarea.text="";
	this.tnp_isalesdepart.text="";
	this.tnp_isalesperson.text="";
	this.tnp_icreditrating.text="";
	this.tnp_cproducteffect.text="";
	this.tnp_cmemo.text="";
	/*	this.tnp_cname.text="";*/
	 this.tnp_cdepartment.text="";
	 this.tnp_cpost.text="";
	this.tnp_ctitle.text="";
	 this.tnp_cmobile1.text="";
	/*	this.tnp_ctel.text="";*/
	this.tnp_cemail.text="";
	this.rbtn_sex.selectedValue="";
	item = "onNew";
	CRMtool.containerChildsEnabled(this,true);
}

public function onEdit():void
{
	item="onEdit";
	CRMtool.containerChildsEnabled(this,true);
}

public function onGiveUp():void
{
	this.tnp_ccode.text="";
	/*	this.tnp_cname.text="";*/
	this.tnp_icustclass.text ="";
	this.tnp_ipartnership.text="";
	this.tnp_iindustry.text="";
	this.tnp_cwebsite.text="";
	this.tnp_iorganization.text="";
	this.tnp_iheadcust.text="";
	this.tnp_ivaluelevel.text="";
	this.tnp_isalesprocess.text="";
	/*this.cmb_ieducation.selectedIndex=-1;*/
	this.cmb_iprovince.selectedIndex=-1;
	this.cmb_icity.selectedIndex=-1;
	this.tnp_cofficeaddress.text="";
	this.tnp_cofficezipcode.text="";
	this.tnp_cshipaddress.text="";
	this.tnp_cshipzipcode.text="";
	/*	this.tnp_ctel.text="";*/
	this.tnp_cfax.text="";
	this.tnp_isalesarea.text="";
	this.tnp_isalesdepart.text="";
	this.tnp_isalesperson.text="";
	this.tnp_icreditrating.text="";
	this.tnp_cproducteffect.text="";
	this.tnp_cmemo.text="";
	/*	this.tnp_cname.text="";*/
	this.tnp_cdepartment.text="";
	this.tnp_cpost.text="";
	this.tnp_ctitle.text="";
	this.tnp_cmobile1.text="";
	/*	this.tnp_ctel.text="";*/
	this.tnp_cemail.text="";
	this.rbtn_sex.selectedValue="";
	CRMtool.containerChildsEnabled(this,false);
}