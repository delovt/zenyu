/*
* 	模块名称：多方通话业务操作
* 	模块说明：用于多方通话功能
* 	创建人：	YJ
* 	创建日期：20150813
* 	修改人：	
* 	修改日期：
*/

import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.controls.dataGridClasses.DataGridColumn;
import mx.events.DataGridEvent;
import mx.formatters.DateFormatter;
import mx.rpc.events.ResultEvent;
import mx.utils.StringUtil;

import yssoft.comps.PageBar;
import yssoft.evts.GetPageComplete;
import yssoft.frameui.formopt.OperDataAuth;
import yssoft.models.CRMmodel;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.views.homeView.Widget;

[Bindable]
public var telperson:ArrayCollection=new ArrayCollection();//通话人员
[Bindable]
public var hrperson:ArrayCollection=new ArrayCollection();//公司员工
public var _isFocusIn:Boolean;

[Bindable]
public var basciSearchText:String = "请输入其他人员号码";

[Bindable]
public var result:String ="-1";//是否通话成功    0成功

[Bindable]
public var fbalance:Number =0;//账户余额
[Bindable]
public var fusetime:Number =0;//可用时间
[Bindable]
public var flasttime:Number =0;//上次通话时长

public var op:int = 0;

[Bindable]
private var _ownerWidget:Widget;

public function get ownerWidget():Widget {
	return _ownerWidget;
}

public function set ownerWidget(value:Widget):void {
	_ownerWidget = value;
}

public function get isFocusIn():Boolean {
	return _isFocusIn;
}

public function set isFocusIn(value:Boolean):void {
	_isFocusIn = value;
	if (value) {
		if (StringUtil.trim(txt1.text) == basciSearchText)
			txt1.text = "";
	} else {
		if (CRMtool.isStringNull(txt1.text))
			txt1.text = basciSearchText;
	}
}

//初始化操作
public function init():void {
	this.onIniGrid(0);
	selFbalance();
}

public function toRefresh():void {
	selFbalance();
}

public function selFbalance():void {
	
	var cust_accountsql:String="select cvalue from as_options where iid in(100,102) order by iid";
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
	   var cust_account:String=event.result[1].cvalue;
	   var account_identify:String=event.result[0].cvalue;
	   var obj:Object=new Object();
	   obj.cust_account=cust_account;
	   obj.account_identify=account_identify;
	   obj.userId=CRMmodel.userId;
	   //获取上次通话时长
	   AccessUtil.remoteCallJava("LotCommunicate", "orderLastTime", function (event:ResultEvent):void {
		   if(event.result!="" || event.result!=null){
			   flasttime=parseInt(event.result+"");
		   }
	   },obj);
	   if(cust_account==null || cust_account==""){
	   
	   }else{
		   //获取账户余额
		   AccessUtil.remoteCallJava("LotCommunicate", "orderBalance", function (event:ResultEvent):void {
			   if(event.result.main_account!="0"){
				   fbalance = parseInt(event.result.main_account+"");
			   }
			   if(event.result.all_resource_num!="0"){
				   fusetime = parseInt(event.result.all_resource_num+"");
			   }
			   
		   },obj);
		   
	   }
	},cust_accountsql);
	
}

public function search_clickHandler():void
{
	var sqlStr:String = "";
	var search:String = tnp_search0.text;
	if(op == 0){
		sqlStr = 	" select '公司员工' corpname,cname,cmobile,cpost,iid from "+
			" (select A.cname,A.iid, "+
			" case when A.cmobile1 is not null then A.cmobile1 "+
			" when A.cmobile2 is not null then A.cmobile2 "+
			" else A.ctel end cmobile,"+
			" B.cname cpost from hr_person A  "+
			" left join HR_post B on A.ipost=B.iid where 1=1 and A.iid not in ("+CRMmodel.userId+")) AA where cmobile is not null  and cmobile <>'' "+
			" and cname like '%"+search+"%' or cmobile like '%"+search+"%' or cpost like '%"+search+"%'";
	}else{
		sqlStr = 	" select * from ( "+
			" select B.iid iid,A.cname corpname,B.cname,"+
			" case	when B.cmobile1 is not null then B.cmobile1  "+
			" when B.cmobile2 is not null then B.cmobile2  "+
			" else B.ctel end cmobile,B.cpost   "+
			" from cs_customer A left join CS_custperson B on A.iid=B.icustomer) AA   "+
			" where cmobile is not null and cmobile <>'' "+
			" and corpname like '%"+search+"%' or cname like '%"+search+"%' or cmobile like '%"+search+"%' or cpost like '%"+search+"%'";
	}
	this.onExecSql(sqlStr);
	
}

public function onIniGrid(flag:int):void{
	var sqlStr:String = "";
	//查询客商人员
	if(flag == 1){
		sqlStr = 		" select * from ( "+
			" select B.iid iid, A.cname corpname,B.cname,"+
			" case	when B.cmobile1 is not null then B.cmobile1  "+
			" when B.cmobile2 is not null then B.cmobile2  "+
			" else B.ctel end cmobile,B.cpost "+
			" from cs_customer A left join CS_custperson B on A.iid=B.icustomer) AA   "+
			" where cmobile is not null  and cmobile <>'' ";
		op = 1;
	}
	else{
		sqlStr = 		" select '公司员工' corpname,cname,cmobile,cpost,iid from "+
			" (select A.iid, A.cname, "+
			" case when A.cmobile1 is not null then A.cmobile1 "+
			" when A.cmobile2 is not null then A.cmobile2 "+
			" else A.ctel end cmobile,"+
			" B.cname cpost  from hr_person A  "+
			" left join HR_post B on A.ipost=B.iid where 1=1 and A.iid not in ("+CRMmodel.userId+")) AA where cmobile is not null  and cmobile <>''";
		op = 0;
	}
	this.onExecSql(sqlStr);
}

//执行传入的SQL，结果集返回至左侧的列表
private function onExecSql(strsql:String):void{
	//调用分页方法
	this.pageBar.initPageHandler({sqlid:"get_persons_sql",sql:strsql,curpage:1,pagesize:50,flag:"1",ifuncregedit:485},function(list:ArrayCollection):void{
		var eventAC:ArrayCollection = list;
		if (eventAC.length > 0) {
			hrperson=eventAC;
		}
	});
	
	
//		AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
//		var eventAC:ArrayCollection = event.result as ArrayCollection;
//		if (eventAC.length > 0) {
//			hrperson=eventAC;
//		}},strsql);
	
}


public function lineNumColFunction(item:Object, column:DataGridColumn):String {
	if (hrperson) {
		for (var i:int = 1; i <= hrperson.length; i++) {
			if (hrperson[i - 1] == item) {
				item.sort_id = i;
				return i + "";
			}
		}
		
	}
	return "0";
}
public function lineNumColFunction1(item:Object, column:DataGridColumn):String {
	if (telperson) {
		for (var i:int = 1; i <= telperson.length; i++) {
			if (telperson[i - 1] == item) {
				item.sort_id = i;
				return i + "";
			}
		}
		
	}
	return "0";
}

public function btnAdd():void {
	var tel:String = "";
	tel = txt1.text;
	var res:RegExp = /^1\d{10}$/;
	if(tel=="" || tel == "请输入其他人员号码" || !(res.test(tel))){
		CRMtool.tipAlert("请确认输入是否正确！");
		return;
	}else{		
		var obj:Object = new Object();
		obj.cmobile = tel;	
		
		if(result!="0"){
			telperson.addItem(obj);
		}else{
			//通话中添加人员
			telperson.addItem(obj);
			var ssql:String="select isessionid from as_commSessionId where iid=(select MAX(iid) from as_commSessionId  where iperson="+CRMmodel.userId+")";
			AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
				var ac:ArrayCollection=event.result as ArrayCollection;
				if(ac[0].isessionid!=null){
					var objId:Object=new Object();
					objId.isessionid=ac[0].isessionid;
					objId.cmobile=tel;
					AccessUtil.remoteCallJava("LotCommunicate", "addPerson", function (event:ResultEvent):void {
						var resVal:Object=event.result as Object;
						if(resVal=="0"){//"0"添加成功
							CRMtool.tipAlert(tel+" 号码邀请成功！");
						}else{
							CRMtool.tipAlert(tel+" 号码邀请失败，请联系管理员！");
						}
					},objId);
				}
			},ssql);
		}
		
		
			
	}
	txt1.text = "";
}
public function toStart():void {
	var param:Object = new Object();
	param.user = CRMmodel.hrperson;
	param.personlist = telperson;
	if(telperson.length == 0){
		CRMtool.tipAlert("未选中通话人员！");
	}else{
		AccessUtil.remoteCallJava("LotCommunicate", "communicate", function (event:ResultEvent):void {
			
			if(event.result.result=="0"){
				result=event.result.result+"";//发起成功
				CRMtool.tipAlert("多方通话接通中，请等待！");
			}else{
				CRMtool.tipAlert("通话失败，请联系管理员！discripe="+event.result.describe);
			}
		}, param,"多方会议通话中....");
	}
	
}

public function toEnd():void {
	var ssql:String="select isessionid from as_commSessionId where iid=(select MAX(iid) from as_commSessionId  where iperson="+CRMmodel.userId+")";
	AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
		var ac:ArrayCollection=event.result as ArrayCollection;
		if(ac[0].isessionid!=null){
			var objId:Object=new Object();
			objId.isessionid=ac[0].isessionid;
			
			AccessUtil.remoteCallJava("LotCommunicate", "telEnd", function (event:ResultEvent):void {
				var res:ArrayCollection=event.result as ArrayCollection;
				if(event.result=="0"){//"0"会议结束成功
					CRMtool.tipAlert("会议结束！");
					result="-1";
				}else{
					CRMtool.tipAlert("会议结束异常，请联系管理员！ "+ res[0].describe);
					result="-1";
				}
			},objId);
		}
	},ssql);
	
}

protected function pageBar_getPageCompleteHandler(event:GetPageComplete):void {
	if (ownerWidget) {
		ownerWidget.subTitle = event.pageNum + "";
		ownerWidget.listVbox.visible = true;
	}
}




