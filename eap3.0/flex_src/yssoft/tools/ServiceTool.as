/**
 * Created with IntelliJ IDEA.
 * User: aruis
 * Date: 13-6-4
 * Time: 上午8:57
 * To change this template use File | Settings | File Templates.
 */
package yssoft.tools {
import flash.events.Event;

import mx.collections.ArrayCollection;
import mx.rpc.events.ResultEvent;


import yssoft.comps.frame.module.CrmEapRadianVbox;

import yssoft.views.moreHandleViews.MoreHandleTW;
import yssoft.models.CRMmodel;

public class ServiceTool {
    public function ServiceTool() {

    }
    
	//发票分配
    public static function allotInvoice(title:String, iid:int, mainValue:Object, crmeap:CrmEapRadianVbox = null):void {
        var sql:String = "select istatus from tr_invoice where iid = " + iid;
        AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
            var list:ArrayCollection = event.result as ArrayCollection;
            if (list && list.length > 0) {
                var istatus:int = list[0].istatus;
                if (istatus == 0) {
                    var more:MoreHandleTW = new MoreHandleTW();
                    more.formIfunIid = 398;
                    more.width = 400;
                    more.title = title;

                    more.addEventListener("onSubmit", function (e:Event):void {
                        var newObj:Object = more.crmeap.getValue();
                        if(newObj.iperson != null){
                            mainValue.iperson = newObj.iperson;
                            mainValue.istatus = 1;

                            var sql:String = "update tr_invoice set iperson = " + newObj.iperson + ",istatus = 1 where iid = " + iid;
                            AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
                                if (crmeap != null) {
                                    addInvoices(iid,mainValue,crmeap);
                                    CRMtool.showAlert("操作成功。");
                                } else
                                    CRMtool.showAlert("操作失败。");
                            }, sql, null, false);
                        }
                    })
                    more.open();
                } else {
                    CRMtool.showAlert("发票非未使用状态，不允许分配！");
                    return;
                }
            } else {
                CRMtool.showAlert("数据有误，请检查！");
            }
        }, sql);
    }
    public static function insertInvoices():void{

    }
    //插入发票子表明细
    public static function addInvoices(iid:int, mainValue:Object, crmeap:CrmEapRadianVbox = null):void{

        var sql:String = "insert into tr_invoices(itrinvoice,itype,imaker,dmaker,cmemo,iperson,itrrule) select iid,istatus,imaker,dmaker,cmemo,iperson,iinvoice from tr_invoice where iid = " + iid +
                ";select a.itype,c.cname typename,b.cname makername,d.cname pername from tr_invoices a left join hr_person b on a.imaker = b.iid left join aa_data c on a.itype = c.ccode left join hr_person d on a.iperson = d.iid where c.iclass = 141 and a.itrinvoice = " + iid + " and iperson " ;
        if( mainValue.iperson == null){
            sql += "is null" ;
        }else{
            sql += "= "+mainValue.iperson;
        }
        AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
            var obj:ArrayCollection = e.result as ArrayCollection;
            if(obj != null && obj.length > 0){
                var arr:ArrayCollection = mainValue.tr_invoices;
                var paramObj:Object = new Object();
                paramObj.itype = obj[0].itype;//流通类别
                paramObj.itype_Name = obj[0].typename;
                paramObj.dmaker = mainValue.dmaker;//流通日期
                paramObj.imaker = mainValue.imaker;//经手人
                paramObj.imaker_Name = obj[0].makername;
                paramObj.iperson = mainValue.iperson;//发票所属人
                paramObj.iperson_Name = obj[0].pername;
                paramObj.cmemo = mainValue.cmemo;//备注
                arr.addItem(paramObj);
                mainValue.mainValue = mainValue;
                crmeap.setValue(mainValue, 1, 1);
            }
        }, sql);
    }
	
	//收费单合同日期更新
	public static function modifycontdate(title:String, iid:int, mainValue:Object, crmeap:CrmEapRadianVbox = null):void {
		var sql:String = "select istatus from tr_charge where iid = " + iid;
		AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (event:ResultEvent):void {
			var list:ArrayCollection = event.result as ArrayCollection;
			if (list && list.length > 0) {
				var istatus:int = list[0].istatus;
				if (istatus == 0) {
					var more:MoreHandleTW = new MoreHandleTW();
					more.formIfunIid = 401;
					more.width = 400;
					more.title = title;
					
					var obj:Object = new Object();
					obj.dscontdate = mainValue.dscontdate;
					obj.decontdate = mainValue.decontdate;
					
					more.injectObj = obj;
					
					more.addEventListener("onSubmit", function (e:Event):void {
						var newObj:Object = more.crmeap.getValue();
						if(newObj.dscontdate != null && newObj.decontdate!= null){
							if(newObj.dscontdate > newObj.decontdate){
								CRMtool.showAlert("合同开始日期不能小于结束日期！");
								return;
							}
							mainValue.dmscontdate = newObj.dscontdate;
							mainValue.dmecontdate = newObj.decontdate;
							
							var sql:String = "update tr_charge set dmecontdate = '" + newObj.decontdate + "',dmscontdate = '"+ newObj.dscontdate +"' where iid = " + iid;
							AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", function (e:ResultEvent):void {
								mainValue.mainValue = mainValue;
								crmeap.setValue(mainValue,1,1);
								CRMtool.showAlert("操作成功。");
							}, sql, null, false);
						}
					})
					more.open();
				} else {
					CRMtool.showAlert("收费单已审核不能更改合同日期！");
					return;
				}
			} else {
				CRMtool.showAlert("数据有误，请检查！");
			}
		}, sql);
	}

    //批量分配发票
    public static function bathAllotInvoice(title:String,ac:ArrayCollection):void{
        var more:MoreHandleTW = new MoreHandleTW();
        more.formIfunIid = 398;
        more.width = 400;
        more.title = title;
        more.addEventListener("onSubmit", function (e:Event):void {
            var newObj:Object = more.crmeap.getValue();
            if(newObj.iperson != null){
                var iperson = newObj.iperson;
                AccessUtil.remoteCallJava("InvoiceManager", "bathAllotInvoice", function onExecImportBack(e:ResultEvent):void {
                    var result:String = e.result + "";
                    CRMtool.tipAlert(result+"");
                }, {billsList:ac,tableName:"tr_invoice",checkStatus:0,iperson:iperson},null,true);
            }
        })
        more.open();
    }
	
	
	//生成收费单
	public static function createCharge(arr:ArrayCollection):void{

		var injectObj:Object = new Object();
		injectObj.iid=0;
		injectObj.icustomer = arr[0].iid;
		injectObj.dscontdate = arr[0].dstartdate;
		injectObj.decontdate = arr[0].denddate;
		injectObj.icustperson = arr[0].ipsn;
		injectObj.iperson = CRMmodel.userId;
		injectObj.imaker = CRMmodel.userId;
		injectObj.dmaker = "服务器当前时间";
		
		var param:Object = new Object();
		
		param.ctable = "tr_charge";
		param.ifuncregedit = 390;
		param.itemType = "onNew";
		param.operId = "onListNew";
		param.formTriggerType = "fromOther";
		param.injectObj = injectObj;
		var array:ArrayCollection = new ArrayCollection();
		param.personArr = array;		
		
		CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "加载中 ...", "");
	
		//CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param);

	}
	
	//生成客商活动
	public static function createWorkdiary(arr:ArrayCollection):void{
		
		var injectObj:Object = new Object();
		injectObj.iid=0;
		injectObj.icustomer = arr[0].iid;
		injectObj.imaker = CRMmodel.userId;
		injectObj.dmaker = "服务器当前时间";
		
		var param:Object = new Object();
		
		param.ctable = "oa_workdiary";
		param.ifuncregedit = 46;
		param.itemType = "onNew";
		param.operId = "onListNew";
		param.formTriggerType = "fromOther";
		param.injectObj = injectObj;
		var array:ArrayCollection = new ArrayCollection();
		param.personArr = array;		
		
		CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param, "加载中 ...", "");
		
		//CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param);
		
	}

	//生成回访单
//	public static function createFeedBack(arr:ArrayCollection):void{
//		
//		var injectObj:Object = new Object();			
//		injectObj.ddate = arr[0].ddate;
//		injectObj.icustomer = arr[0].iid;
//		injectObj.icustperson = arr[0].icustperson;
//		injectObj.imaker = CRMmodel.userId;
//		injectObj.dmaker = "服务器当前时间";
//		
//		var param:Object = new Object();
//		param.ifuncregedit = 154;
//		param.itemType = "onNew";
//		param.operId = "onListNew";
//		param.formTriggerType = "fromOther";
//		param.injectObj = injectObj;
//		param.personArr = new ArrayCollection();
//		
//		CRMtool.openMenuItemFormOther("yssoft.frameui.FrameCore", param);
//		
//	}

}




}
