
/*
* 	模块名称：收藏夹业务操作
* 	模块说明：用于我的收藏夹，加入、移除收藏功能
* 	创建人：	YJ
* 	创建日期：20111015
* 	修改人：
* 	修改日期：
*/

import mx.collections.ArrayCollection;
import mx.controls.Alert;
import mx.core.INavigatorContent;
import mx.formatters.DateFormatter;
import mx.rpc.events.ResultEvent;

import yssoft.models.DateHadle;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;

public var favori_ifuncregedit:int;//功能注册内码

public var listiidArr:ArrayCollection = new ArrayCollection();//管理列表中传入的内码集合

public var listuniidArr:ArrayCollection = new ArrayCollection();//管理列表中未选中的记录

public var favori_iid:int;//收藏夹内码

public var flag_label:String = "";//弹出对话中的临时变量

public var cdetail:String = "";//收藏的记录iid

/*			函数定义			*/


private function onUpdateFavoritesCdetailBack(evt:ResultEvent):void{
	
	if(evt.result as String == "sucess"){
		CRMtool.tipAlert("已经成功"+flag_label+" "+listiidArr.length+" 条记录！");
		this.tre_favorites.selectedItem.@cdetail = cdetail;
	}
	else
		CRMtool.tipAlert(flag_label+"失败！");
	
}

//YJ Add 加入、移除时调用的公共收藏方法
private function onFavorites(flag:int):void{
	
	var objvalue:Object = {};	
	var striid:String = "";
	
	objvalue.iid = favori_iid;
	
	if(flag==0){//加入
		objvalue.cdetail = onResolve(listiidArr);//加入时分解的是选中集合项
		flag_label = "加入";
		
	}
	else{//移除
		flag_label = "移除";
		
		if(this.parentForm.favoritesFlag == 0) {CRMtool.tipAlert("请选择收藏夹列表！");return};
		
		if(this.listuniidArr.length==0)objvalue.cdetail = "";
		else objvalue.cdetail = onConcatIID(listuniidArr);//移除时分解的是未选中集合项
	}
	
	cdetail = objvalue.cdetail;
		
	AccessUtil.remoteCallJava("favoritesDest","updateFavoritesCdetail",onUpdateFavoritesCdetailBack,objvalue);
}

//YJ Add 分解内码集合
private function onResolve(newarr:ArrayCollection):String{
	
	//获取原始收藏记录
	var oldCdetail:String = this.tre_favorites.selectedItem.@cdetail+"";
	var oldarr:ArrayCollection = new ArrayCollection();
	var paramArr:ArrayCollection = new ArrayCollection();//参数记录集
	
	if(oldCdetail != ""){
		var strsub:String = oldCdetail;
		var strsub1:String = strsub.substr(1,strsub.length);
		var strsub2:String = strsub1.substr(0,strsub1.indexOf(")"));
		var temparr:Array = strsub2.split(",");
		if(temparr.length>0){
			for(var i:int=0;i<temparr.length;i++){
				var objitem:Object = {};
				objitem.iid = temparr[i];
				
				oldarr.addItem(objitem);
			}
		}
	}
	
	//新旧数据比对分析
	if(oldarr.length>0){
		
		for(var j:int=0;j<oldarr.length;j++){
			
			var oldiid:String = oldarr[j]["iid"];
			
			for(var k:int=0;k<newarr.length;k++){
				
				var newiid:String = newarr[k]["iid"];
				
				if(newiid == oldiid){
					newarr.removeItemAt(k);
					k--;
					break;
				}
				
			}
			
		}
		
		//将新数据添加至旧数据
		for(var l:int=0;l<newarr.length;l++){
			var lnewiid:String = newarr[l]["iid"];
			var obj:Object = {};
			obj.iid = lnewiid;
			oldarr.addItem(obj);
			
		}
		
		paramArr = oldarr;
	
	}
	else
		paramArr = newarr;
	
	return onConcatIID(paramArr);
	
}

//拼接IID
private function onConcatIID(arr:ArrayCollection):String{
	
	var strsql:String = "(";
	
	for(var i:int=0;i<arr.length;i++){
		var obj:Object = arr.getItemAt(i);
		
		strsql+=obj.iid+",";
	}
	
	strsql = strsql.substr(0,strsql.lastIndexOf(","))+")";
	
	return strsql;
	
}

//YJ Add 根据index分解不同的时间
private function getDate(index:int,datefield:String,ctable:String):String{
	
	/*
		1---今天
		2---本周
		3---本月
		4---本年
		5---自定义时间段
	*/
	
	var datestr:String = "";
	var fmt:DateFormatter = new DateFormatter();
	var date:Date = new Date();
	var dcondition:String = "";
	
	fmt.formatString = "YYYY-MM-DD";
	dcondition = " and substring(convert(nvarchar(120),"+ctable+"."+datefield+",120),0,11)";
	
	this.vdate.visible = false;
	this.vdate.height = 0;
	
	switch(index){
		case 1:
			datestr = dcondition+ "='"+fmt.format(date)+"'";
			break;
		case 2:
			datestr = dcondition+" between '"+DateHadle.getFirstOfWeek()+"' and '"+DateHadle.getEndOfWeek()+"'";
			break;
		case 3:
			datestr = dcondition+" between '"+DateHadle.getFirstOfMonth()+"' and '"+DateHadle.getEndOfMonth()+"'";
			break;
		case 4:
			datestr = dcondition+" between '"+DateHadle.getYear()+"-01-01' and '"+DateHadle.getYear()+"-12-31'";
			break;
		case 5:
			this.vdate.visible = true;
			this.vdate.height = 135;
			break;
		default:
			break;
	}
	
	return datestr;
}