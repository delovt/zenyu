
import flashx.textLayout.formats.Float;

import mx.collections.ArrayCollection;

import yssoft.tools.CRMtool;
import yssoft.vos.ScProduct;



/**
 * 获取档案实体
 */
public function getParam():ScProduct
{
	var spt:ScProduct = new ScProduct();
	var proClass:Object = {};
	
	if(this.tnp_iproductclass.text == "" || this.tnp_iproductclass.text == null){
		proClass = product.iporductclass;
	}else{
		proClass = this.tnp_iproductclass.cconsultbkfld.getItemAt(0);
	}
	
	
	spt.iid  = product.iid;
	spt.iproductclass   =  int(proClass);

	spt.iproductgroup = int(this.tnp_iproductgroup.cconsultbkfld.getItemAt(0));
	spt.ccode         = this.tnp_ccode.text;
	spt.cname        = this.tnp_cname.text;
	spt.cpdstv         = this.tnp_cpdstv.text;
	spt.cmnemonic  = this.tnp_cmnemonic.text;
	spt.iunitclass      = int(this.tnp_iunitclass.text);
	spt.iunitdefault   = int(this.tnp_iunitdefault.text);
	spt.iunit 			= int(this.tnp_iunit.text);
	spt.itaxtype		= int(this.tnp_itaxtype.text);
	//spt.itaxrate 		= int(this.tnp_itaxrate.text);
	
	spt.ftaxquotedprice = parseFloat(this.tnp_ftaxquotedprice.text);
	spt.freferencecost   = parseFloat(this.tnp_freferencecost.text);
	spt.fsafequantity = parseFloat(this.tnp_fsafequantity.text);
	 
	spt.bassets   = this.chbx_bassets.selected;
	spt.bservice  = this.chbx_bservice.selected;
	spt.bfittings  = this.chbx_bfittings.selected;
	
	spt.bsn        = this.chbx_bsn.selected;
	spt.bfree1    = this.chbx_bfree1.selected;
	spt.	bfree2 = this.chbx_bfree2.selected;
	spt.bfree3    = this.chbx_bfree3.selected;
	
	spt.bpurchase = this.chbx_bpurchase.selected;
	spt.bsale        = this.chbx_bsale.selected;
	spt.bconsume = this.chbx_bconsume.selected;
	spt.bselfmake = this.chbx_bselfmake.selected;
	spt.istatus = 0;
	return spt;
}

//清除信息
public function clear():void
{
	this.tnp_iproductclass.text="";
	this.tnp_iproductgroup.text="";
	this.tnp_ccode.text="";
	this.tnp_cname.text="";
	this.tnp_cpdstv.text="";
	this.tnp_cmnemonic.text="";
	this.tnp_iunitclass.text="";
	this.tnp_iunitdefault.text="";
	this.tnp_iunit.text="";
	this.tnp_itaxtype.text="";
	this.tnp_itaxrate.text="";
	this.tnp_ftaxquotedprice.text="";
	this.tnp_freferencecost.text="";
	this.tnp_fsafequantity.text="";
	this.chbx_bassets.selected =false;
	this.chbx_bservice.selected=false;
	this.chbx_bfittings.selected=false;
	this.chbx_bsn.selected      =false;
	this.chbx_bfree1.selected  =false;
	this.chbx_bfree2.selected  =false;
	this.chbx_bfree3.selected  =false;
	this.chbx_bpurchase.selected=false;
	this.chbx_bsale.selected       =false;
	this.chbx_bconsume.selected=false;
	this.chbx_bselfmake.selected=false;
}

private function init2():void{
	//回车替代TAB键
	CRMtool.setTabIndex(this);
}


