import flash.events.Event;
import flash.net.FileReference;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.system.System;
import flash.utils.ByteArray;
import flash.utils.Dictionary;

import mx.collections.ArrayCollection;
import mx.rpc.events.ResultEvent;
import mx.utils.ObjectUtil;

import myreport.design.DesignEvent;

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

private function Init():void
{
	//注册打开事件
	this.printReport.addEventListener(DesignEvent.OPEN, OnOpen);
	//注册保存事件
	this.printReport.addEventListener(DesignEvent.SAVE, OnSave);
	
	if(winParam!=null)
	{
		ifuncregedit=winParam.formIfunIid;
		reportiid=winParam.reportiid;
		//vouchiid=winParam.currid;
		reportpath=winParam.printurl;
		//隐藏控件关于和关闭按钮
		this.printReport._ReportDesigner_ToolButton8.visible=false;
		this.printReport._ReportDesigner_ToolButton9.visible=false;
		
		//加载模板参数
		AccessUtil.remoteCallJava("AcPrintSetDest","getDataByIfuncregedit",onGetDataByIfuncregedit,ifuncregedit);
	}
	else
	{
		CRMtool.showAlert("无法打印！原因：系统参数传递异常。");
	}
}

private function OnOpen(event:DesignEvent):void
{
	//处理打开事件
	var file:FileReference = new FileReference();
	file.addEventListener(Event.SELECT, 
		function(e1:Event):void
		{
			file.load();
		});
	file.addEventListener(Event.COMPLETE, 
		function(e2:Event):void
		{
			OnLoadFile(file);
		});
	
	file.browse();
}
private function OnLoadFile(file:FileReference):void
{
	//处理打开事件
	var text:String = file.data.readMultiByte(file.data.length, "utf-8");
	var xml:XML = new XML(text);
	this.printReport.Open(xml);
}

private function OnSave(event:DesignEvent):void
{
	//处理保存事件
	var style:XML = new XML(this.printReport.GetSettingXML());
	var file:FileReference = new FileReference();
	file.save(style, winParam.filename);
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
		if (reportpnames.length==0)
		{
			paramvalues=1;
		}
		else
		{
			var arr:Array=new Array();
			for (var i:int = 0; i < reportpnames.length; i++) 
			{
				arr[i]=1;
			}
			paramvalues=arr;
		}
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
	if (reportpnames.length>0)
	{		
		params.printparams=reportpnvalues;
	}
	AccessUtil.remoteCallJava("AcPrintSetDest","get_bywhere_ac_printsets",onget_bywhere_ac_printsets,params);
}

//获得模板参数名
public static function GetParamsName(ccondit:String):Array
{
	var arr:Array=new Array();
	if (ccondit)
	{
		if (ccondit.indexOf(",")==-1)
		{
			arr.push(ccondit);
		}
		else
		{
			arr=ccondit.split(",");
		}
	}
	return arr;
}

private function onget_bywhere_ac_printsets(evt:ResultEvent):void
{
	if (this.reportiid>0 && evt.result!=null)
	{
		var dict:Dictionary = new Dictionary();
		if (evt.result.head.hasOwnProperty("success"))
		{
			var headclm:ArrayCollection=evt.result.headclm as ArrayCollection;
			if (headclm!=null)
			{
				for each (var fielditem:Object in headclm) 
				{
					dict[fielditem.cnewcaption]="8888888888888888";
				}
			}
		}
		if (evt.result.body && evt.result.body.hasOwnProperty("success"))
		{
			var objInfo:Object=ObjectUtil.getClassInfo(evt.result);
			var objName:Array=objInfo["properties"] as Array;  
			_TableData=new ArrayCollection();
			for (var j:int = 1; j < objName.length-2; j++) 
			{
				if (j==1)
				{
					var bodyclm:ArrayCollection=evt.result["bodyclm"+j.toString()] as ArrayCollection;
					var itemobj:Object=new Object();
					for (var i:int = 0; i < 9; i++) 
					{
						for each (var fielditem2:Object in bodyclm) 
						{
							itemobj[fielditem2.cnewcaption]="8888";
						}
						_TableData.addItem(itemobj);
					}
				}
				else
				{
					var dictparam2:Dictionary = new Dictionary();
					var subparam2:String="子表"+(j-1).toString()+"参数";
					dictparam2["子表标题"] = subparam2;
					dict[subparam2]=dictparam2;
					var bodyclm2:ArrayCollection=evt.result["bodyclm"+j.toString()] as ArrayCollection;
					var itemobj2:Object=new Object();
					var list2:ArrayCollection = new ArrayCollection();
					for (var k:int = 0; k < 9; k++) 
					{
						for each (var fielditem3:Object in bodyclm2) 
						{
							itemobj2[fielditem3.cnewcaption]="8888";
						}
						list2.addItem(itemobj2);
					}
					var subdata:String="子表"+(j-1).toString()+"数据";
					dict[subdata] = list2;
				}
			}
		}
	}
	this._PageData=dict;
	_Loader = new URLLoader();
	_Loader.addEventListener(Event.COMPLETE, LoadCompleteHandler);
	var curtime:Date=new Date();
	System.useCodePage=false;
	_Loader.load(new URLRequest(reportpath+"?t="+curtime.milliseconds.toString()));
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