import flash.events.Event;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.utils.Dictionary;
import flash.system.System;

import hlib.MsgUtil;

import mx.collections.ArrayCollection;
import mx.rpc.events.ResultEvent;
import mx.utils.ObjectUtil;

import myreport.ExportUtil;
import myreport.MyReportEvent;
import myreport.ReportEngine;

import myreport.res.Asset;

import myreport.util.ToolButton;

import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.views.printreport.PrintParam;

private var _Loader:URLLoader;
private var _TableData:ArrayCollection;
private var _PageData:Dictionary;
private var _Setting:XML;


//菜单传参：formIfunIid(功能内码)、reportiid(打印模板内码)、paramvalues(变量值-可以为数组)、url(模板地址)
[Bindable]
public var winParam:Object=new Object();

//功能内码
private var ifuncregedit:int;
//打印模板iid(如果该参数为0，则不装载数据，只显示空模板)
private var reportiid:int=0;
//外部传入参数值(可以为数组)
private var paramvalues:Object;
//打印模板文件
private var reportpath:String;
//打印参数名数据
private var reportpnames:Array=new Array();
//打印参数名及赋值
private var reportpnvalues:ArrayCollection=new ArrayCollection();

//打印模板设置记录
[Bindable]
private var printListArr:ArrayCollection;

public function Init():void
{
	if(winParam!=null)
	{
		ifuncregedit=winParam.formIfunIid;
		reportiid=winParam.reportiid;
		paramvalues=winParam.paramvalues;
		reportpath=winParam.printurl;
		//隐藏控件关于和关闭按钮
		this.printReport._ReportViewer_ToolButton2.visible=false;
		this.printReport._ReportViewer_ToolButton3.visible=false;
        //lc add 打印后的操作
        ReportEngine.AddEventListener(MyReportEvent.PRINT, function (event:Event):void {
            if(ifuncregedit==497){
                var sql:String = " update lc_useorder set istatus = 1 where iid = " + winParam.currid;
                AccessUtil.remoteCallJava("CommonalityDest", "assemblyQuerySql", null,sql);
            }
        });
		//加载模板参数
		AccessUtil.remoteCallJava("AcPrintSetDest","getDataByIfuncregedit",onGetDataByIfuncregedit,ifuncregedit);
	}
	else
	{
		CRMtool.showAlert("无法打印！原因：系统参数传递异常。");
	}
}
private function onGetDataByIfuncregedit(evt:ResultEvent):void{
	if (this.reportiid>0)
	{
		if (evt.result)
		{
			printListArr = evt.result as ArrayCollection;
			for each (var item:Object in printListArr) 
			{
				if (item.iid==reportiid)
				{
					reportpnames=GetParamsName(item.ccondit);
					break;
				}
			}
		}
		//为参数赋值
		reportpnvalues=CRMtool.SetParamValues(reportpnames,paramvalues);
		if (reportpnvalues!=null && reportpnvalues.length==0)
		{
			CRMtool.showAlert("装载数据失败！原因：赋值与参数个数不致。");
			return;
		}
	}
	//加载模板SQL串
	var params:Object=new Object();
	params.iprint=reportiid;
	params.printparams=reportpnvalues;
	AccessUtil.remoteCallJava("AcPrintSetDest","get_bywhere_ac_printsets",onget_bywhere_ac_printsets,params);
}

//获得模板参数名
public static function GetParamsName(ccondit:String):Array
{
	var arr:Array=new Array();
	if (ccondit.indexOf(",")==-1)
	{
		arr.push(ccondit);
	}
	else
	{
		arr=ccondit.split(",");
	}
	return arr;
}

private function onget_bywhere_ac_printsets(evt:ResultEvent):void
{
	if (this.reportiid>0 && evt.result!=null)
	{
		if (evt.result.head && evt.result.head.success.length>0)
		{
			var vo:Object=evt.result.head.success[0];
			var headclm:ArrayCollection=evt.result.headclm as ArrayCollection;
			var dict:Dictionary = new Dictionary();
			var objInfo:Object = ObjectUtil.getClassInfo(vo);
			var fieldName:Array = objInfo["properties"] as Array; 
			for each(var q:QName in fieldName){ 
				//q.localName 属性名称，value对应的值 
				var value:String = vo[q.localName];
				var ccaption:String=q.localName;
				if (headclm!=null)
				{
					for each (var fielditem:Object in headclm) 
					{
						if (q.localName==fielditem.cfield)
						{
							ccaption=fielditem.cnewcaption;
							break;
						}
					}
				}
				if (value==null)
				{	
					dict[ccaption]="";
				}
				else
				{
					dict[ccaption]=value;
				}
			}
		}
		
		if (evt.result.body)
		{
			_TableData=new ArrayCollection();
			var objInfo1:Object=ObjectUtil.getClassInfo(evt.result);
			var objName:Array=objInfo1["properties"] as Array;  
			var bodyindex:int=0;
			for (var j:int = 1; j < objName.length-2; j++) 
			{
				if (evt.result.body[bodyindex].hasOwnProperty("success"))
				{
					var bodydata:ArrayCollection=evt.result.body[bodyindex].success;
					bodyindex++;
					if (j==1)
					{
						var objInfo2:Object;
						var fieldName2:Array;
						var bodyclm:ArrayCollection=evt.result["bodyclm"+(j-1).toString()] as ArrayCollection;
						for (var i:int = 0; i < bodydata.length; i++) 
						{
							var item:Object=bodydata.getItemAt(i);
							var itemobj:Object=new Object();
							if (i==0)
							{
								objInfo2 = ObjectUtil.getClassInfo(item);
								fieldName2 = objInfo2["properties"] as Array; 
							}
							for each(var q2:QName in fieldName2){ 
								//q2.localName 属性名称，value对应的值 
								var value2:String = item[q2.localName]; 
								var ccaption2:String=q2.localName;
								if (bodyclm!=null)
								{
									for each (var fielditem2:Object in bodyclm) 
									{
										if (q2.localName==fielditem2.cfield)
										{
											ccaption2=fielditem2.cnewcaption;
											break;
										}
									}
								}
								if (value2==null)
								{	
									itemobj[ccaption2]="";
								}
								else
								{
									itemobj[ccaption2]=value2;
								}
							}
							_TableData.addItem(itemobj);
						}
					}
					else if(dict)
					{
						var objInfo3:Object;
						var fieldName3:Array;
						var dictparam:Dictionary = new Dictionary();
						var subparam:String="子表"+(j-1).toString()+"参数";
						dictparam["子表标题"] = subparam;
						dict[subparam]=dictparam;
						var bodyclm1:ArrayCollection=evt.result["bodyclm"+(j-1).toString()] as ArrayCollection;
						var list:ArrayCollection = new ArrayCollection();
						
						for (var k:int = 0; k < bodydata.length; k++) 
						{
							var item2:Object=bodydata.getItemAt(k);
							var itemobj2:Object=new Object();
							if (k==0)
							{
								objInfo3 = ObjectUtil.getClassInfo(item2);
								fieldName3 = objInfo3["properties"] as Array; 
							}
							for each(var q3:QName in fieldName3){ 
								//q3.localName 属性名称，value对应的值 
								var value3:String = item2[q3.localName]; 
								var ccaption3:String=q3.localName;
								if (bodyclm1!=null)
								{
									for each (var fielditem3:Object in bodyclm1) 
									{
										if (q3.localName==fielditem3.cfield)
										{
											ccaption3=fielditem3.cnewcaption;
											break;
										}
									}
								}
								if (value2==null)
								{	
									itemobj2[ccaption3]="";
								}
								else
								{
									itemobj2[ccaption3]=value3;
								}
							}
							list.addItem(itemobj2);
							var subdata:String="子表"+(j-1).toString()+"数据";
							dict[subdata] = list;
						}
					}
				}
			}  
		}
		_PageData=dict;
		_Loader = new URLLoader();
		_Loader.addEventListener(Event.COMPLETE, LoadCompleteHandler);
		var curtime:Date=new Date();
		System.useCodePage=false;
		_Loader.load(new URLRequest(reportpath+"?t="+curtime.milliseconds.toString()));
	}
}

private function LoadCompleteHandler(event:Event):void
{		
	Load(XML(_Loader.data));
}

private function Load(setting:XML):void
{
	_Setting = setting;
	this.printReport.Load(_Setting, _TableData, _PageData);
}

private function OnExportPDF1(e:MouseEvent):void
{
    var bytes:* = ExportUtil.ExportPDF(printReport.Setting,
            printReport.TableData,
            printReport.ParameterData);
    var file:FileReference = new FileReference();
    //保存到本地，该方法要Flash player 10以上
    file.save(bytes, "Export1.pdf");
    hlib.MsgUtil.ShowInfo("数据已成功导出。");
}

//处理导出PDF代码
private function OnExportPDFAsync1(e:MouseEvent):void
{
    ExportUtil.ExportPDFAsync(printReport.Setting,
            printReport.TableData,
            printReport.ParameterData,
            function(bytes:*):void
            {
                var file:FileReference = new FileReference();
                //保存到本地，该方法要Flash player 10以上
                file.save(bytes, "Export1.pdf");
                hlib.MsgUtil.ShowInfo("数据已成功导出。");
            });
}

//处理导出XLS代码
private function OnExportXLSAsync1(e:MouseEvent):void
{
    ExportUtil.ExportXLSAsync(printReport.Setting,
            printReport.TableData,
            printReport.ParameterData, function(bytes:*):void
            {
                var file:FileReference = new FileReference();
                //保存到本地，该方法要Flash player 10以上
                file.save(bytes, "Export1.xls");
                hlib.MsgUtil.ShowInfo("数据已成功导出。");
            });
}


//窗体初始化
public function onWindowInit():void
{
	
}

//窗体打开
public function onWindowOpen():void
{
	Init();
}
//窗体关闭,完成窗体的清理工作
public function onWindowClose():void
{
	
}
