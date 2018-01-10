import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.TabBar;
import mx.events.ItemClickEvent;
import mx.rpc.events.ResultEvent;
import mx.utils.ObjectUtil;

import yssoft.comps.CropHeaderIcon;
import yssoft.models.CRMmodel;
import yssoft.renders.CrmAccordionHeader;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.vos.HrPersonVo;



[Bindable]
public var STATE_ARRAY:Array = [
	{label:"个人信息设置", data:"0"},
	{label:"个人密码设置", data:"1"},
	//{label:"个人参数设置", data:"2"},
	{label:"个人预警设置", data:"2"}
];

[Bindable]
public var person:Object = CRMmodel.hrperson;

[Bindable]
public var emsArr:ArrayCollection = new ArrayCollection();

//密码最小长度
[Bindable]private var minPwdLength:int = 1 ;



private function init():void{
	//回车替代TAB键
	CRMtool.setTabIndex(personalMessageSet);
	loadMinPwd();
}


/**
 * 初始化密码最少长度
 */ 
private function loadMinPwd():void{
	AccessUtil.remoteCallJava("As_optionsDest","getMinPwd",minpwdCallBack,null);
	AccessUtil.remoteCallJava("hrPersonDest","selectEmsLists",emsListCallBack,CRMmodel.userId+"");
	
}

private function minpwdCallBack(e:ResultEvent):void{
	if(null != e.result)
		minPwdLength = int(e.result);
}

private function emsListCallBack(e:ResultEvent):void{
	if(null != e.result){
		emsArr = e.result.list as ArrayCollection;
		//emsArr.sort;
		//emsArr.refresh();
	}
		
}


private function clickEvt(event:ItemClickEvent):void {
	var targetComp:TabBar = TabBar(event.currentTarget);
	var index:int = targetComp.selectedIndex;
	refButton.visible = false;
	if(index == 0) {
		textname.text="个人信息设置";
		myViewStack.selectedChild = personalMessageSet;
	}
	else if(index == 1){
		textname.text="个人密码设置";
		myViewStack.selectedChild = personalPwdSet ; 
		CRMtool.setTabIndex(personalPwdSet);
	} 
//	else if(index == 2){
//		textname.text="个人参数设置";
		//myViewStack.selectedChild = personalArgmSet ;
//	}
	else if(index == 2){
		refButton.visible = true;
		textname.text="个人预警设置";
		myViewStack.selectedChild = personalEMSSet ;
	} 
}	            


public function getPersonItem():Object
{
	var personVo:Object = new Object();
	personVo.iid = 		CRMmodel.userId;
	personVo.ccode  = CRMmodel.hrperson.ccode;
	personVo.cname = CRMmodel.hrperson.cname;
	
	personVo.cnickname  = this.tnp_cnickname.text;
	personVo.cusecode   =  this.tnp_cusecode.text;
	personVo.cmobile1    = this.tnp_cmobile.text;
	personVo.ctel            = this.tnp_ctel.text;
	personVo.cemail        = this.tnp_cemaill.text;
	personVo.csignature   = this.tnp_csignature.text;
	personVo.cqq   = this.tnp_cqq.text;
	personVo.bjobstatus = CRMmodel.hrperson.bjobstatus;
	personVo.busestatus = CRMmodel.hrperson.busestatus;
	//personVo.cusepassword =  CRMmodel.hrperson;	
	personVo.idepartment = CRMmodel.hrperson.idepartment;
	personVo.ipost =  CRMmodel.hrperson.ipost;
	personVo.ijob1 = CRMmodel.hrperson.ijob1;
	personVo.ijob2 = CRMmodel.hrperson.ijob2;
	personVo.isex   =   CRMmodel.hrperson.isex;
	personVo.dbirthday  = CRMmodel.hrperson.dbirthday;;
	personVo.ieducation =CRMmodel.hrperson.ieducation;
	personVo.cdiscipline = CRMmodel.hrperson.cdiscipline;
	personVo.cmobile2  =CRMmodel.hrperson.cmobile2;
	personVo.chaddress = CRMmodel.hrperson.chaddress;
	personVo.chtel         = CRMmodel.hrperson.chtel;
	personVo.cmemo     = CRMmodel.hrperson.cmemo;
	personVo.cquestion  = this.tnp_cquestion.text;
	personVo.canswer    = this.tnp_canswer.text;
	
/*	if( null != this.tnp_ihfuncregedit&&CRMtool.isStringNotNull(tnp_ihfuncregedit.text))
	{
		personVo.ihfuncregedit = this.tnp_ihfuncregedit.value+"";
	}
	else
	{
		personVo.ihfuncregedit ="";
	}
	if( null != this.tnp_dscreenLock)
	personVo.idscreenlock = this.tnp_dscreenLock.text+"";
	
	if(null != this.confirmtype_2)
	personVo.iconfirmtype = this.confirmtype_2.selected == true?1:0;
	*/

    var iline:String =  ui_icallline.text;
    personVo.icallline =  iline;
    personVo.bcallout = calloutjump.selected?1:0;
    personVo.bisCloseOut = isCloseOutBox.selected?1:0;
    personVo.ilayout = cmb_layout.selectedItem.data;

	return personVo;	
}


public function getPersinPwdAndId():Object{
	var param:Object = {};
	if(this.tnp_new_pwd.text != this.tnp_agin_pwd.text){
		CRMtool.tipAlert("您两次输入密码不一致！");		
		return null;
	}
	
	param.iid    =  CRMmodel.userId;
	param.pwd =  this.tnp_new_pwd.text;
	
	param.oldpwd =tnp_old_pwd.text;
	param.dbpwd = CRMmodel.hrperson.cusepassword;
	
	return param;
}


public function onsubmit():void{
	var index:int = this.myViewStack.selectedIndex;
	var flagMothod:String = "";
	var param:Object =new Object();
	if(index == 0){
		flagMothod = "updatePerson";
		param = this.getPersonItem();	
		if(CRMtool.isStringNull(tnp_cusecode.text)){
			CRMtool.tipAlert1("账号不能为空",this.tnp_cusecode);
			return;
		}
	}else if(index ==1){
		
		if( this.tnp_new_pwd.text.length < minPwdLength ){
			CRMtool.tipAlert("您的密码长度不得低于"+minPwdLength+"位数！");
			return;
		} 
		
		flagMothod = "updatePersonPwd";
		param = this.getPersinPwdAndId();	
		if(param == null)return;
	}/*else if(index ==2){
		flagMothod = "updateHomePage";
		if(!checkDate()){return ;}
		param = this.getPersonItem();
	}*/else if(index ==2){
		flagMothod = "saveEms";
		param.list = this.emsArr;
		param.iperson = CRMmodel.userId;
		param.icorp = "";
	}
	
	AccessUtil.remoteCallJava("hrPersonDest",flagMothod,callFun,param);
}

private function callFun(e:ResultEvent):void{
	var alertStr:String ="";
	var resultStr:String = e.result as String;
	if(resultStr == "success"){
        alertStr="修改信息成功！";
        if(ui_imenup.consultList.length>0){
            var im:int = ui_imenup.consultList[0].iid;
            var sql:String = "update hr_person set imenup="+im+" where iid="+CRMmodel.userId;
            AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {

            }, sql, null, false);
        }
    }
	else if(resultStr =="fail") alertStr="修改信息失败！";
	else if(resultStr == "repeat") alertStr ="旧密码输入错误！";
	else if(resultStr == "checkzhisnotonly") alertStr="该账号已经被占用，请修改后，再更新";
	else alertStr="操作失败";
	
	CRMtool.tipAlert(alertStr);
}

private function openHraderIconView():void{
	var heade:CropHeaderIcon= new CropHeaderIcon();
	CRMtool.openView(heade);
}

/*private function  checkDate():Boolean{
	try{
		var t:int = int(this.tnp_dscreenLock.text);
	}
	catch(error:Error)
	{ 
		CRMtool.tipAlert("请正确输入锁屏时间！");
		return false;
	}
	return true;
}*/

/**获取验证码
private function getCheckCode():void{
	var num:Number;
	var code:String;
	var checkCode:String="";
	for(var i:int=0;i<5;i++){
		num=Math.round(Math.random()*100000);
		if(num%2==0){
			code=String.fromCharCode(48+(num%10));
		}else{
			code=String.fromCharCode(65+(num%26));
		}
		checkCode +=code;
	}
	properCheckCode = checkCode;
	this.lbe_checkCode.text = checkCode;
}*/





public function rownum_DataGrid(objitem:Object,icol:int):String{
	var iindex:int=emsArr.getItemIndex(objitem)+1;
	return String(iindex);
}

public function compileFun(item:Object,icol:int):String{
	if(item.idataauth == 0){return "负责人";}
	else if(item.idataauth == 1){return "相关人";}
	else {return "";}
}



