//特殊方法
package yssoft.scripts
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.CheckBox;
	import mx.controls.DataGrid;
	import mx.controls.RadioButtonGroup;
	import mx.controls.TextArea;
	import mx.controls.TextInput;
	import mx.rpc.events.ResultEvent;
	
	import spark.components.ComboBox;
	
	import yssoft.comps.CRMReferTextInput;
	import yssoft.comps.CRMRichTextEditor;
	import yssoft.comps.ConsultList;
	import yssoft.comps.DateControl;
	import yssoft.comps.RadianVbox;
	import yssoft.evts.onItemDoubleClick;
	import yssoft.models.CRMmodel;
	import yssoft.models.DateHadle;
	import yssoft.tools.AccessUtil;
	import yssoft.tools.CRMtool;
	import yssoft.tools.LoginTool;

	public class SpecialScript
	{
		public function SpecialScript()
		{
		}
		
		[Bindable]
		private static var icountryArr:ArrayCollection = new ArrayCollection();
		
		//省份
		[Bindable]
		private static var iprovinceArr:ArrayCollection = new ArrayCollection();
		
		//城市
		[Bindable]
		private static var icityArr:ArrayCollection = new ArrayCollection();
		
		[Bindable]
		private  static var allData:ArrayCollection = new ArrayCollection();
		
		//判断两个时间大小
		public static function compareTime(resultObj:Object,cfield:Array):Boolean
		{
			var isFun:Boolean = DateHadle.myDateCompare(resultObj[cfield[0]],resultObj[cfield[1]]);
			if(!isFun)
			{
				LoginTool.tipAlert("开始时间不能大于结束时间");
				return false;
			}
			return true;
		}
		//添加记录
		public static function addcommunication(param:Object):void
		{
			var paramObj:Object = new Object();
			paramObj.isperson = CRMmodel.hrperson.iid;
			paramObj.dsend = param.dmaker;
			paramObj.cdetail = param.csubject;
			paramObj.ifuncregedit="116";
			paramObj.iinvoice=param.iid;
			
			AccessUtil.remoteCallJava("hrPersonDest","addComm",null,paramObj);
		}
		
		public static function initCon(objup:Object,customerVbox:RadianVbox,parameter:String):void
		{
			AccessUtil.remoteCallJava("csCustomerDest","queryArea",function (e:ResultEvent):void{queryAreaBack(e,objup,customerVbox,parameter)});
			
		}
		//查询下拉框值
		private static function queryAreaBack(event:ResultEvent,objup:Object,customerVbox:RadianVbox,parameter:String):void
		{
			allData = event.result as ArrayCollection;
			
			icountryArr.removeAll();
			
			if(CRMtool.isStringNotNull(parameter))
			{
				var paramperts:Array = parameter.split(",");
				for(var i:int=0;i<allData.length;i++)
				{
					var obj:Object = allData.getItemAt(i);
					if(obj.ipid=="-1")
					{
						icountryArr.addItem(obj);
					}
					
					if(CRMtool.isStringNotNull(objup[paramperts[0]]))
					{
						if(obj.ipid==objup[paramperts[0]])
						{
							iprovinceArr.addItem(obj);
						}
					}
					
					if(CRMtool.isStringNotNull(objup[paramperts[1]]))
					{
						if(obj.ipid==objup[paramperts[1]])
						{
							icityArr.addItem(obj);
						}
					}
				}
				customerVbox.comDatdPr(paramperts[0],icountryArr);
				customerVbox.comDatdPr(paramperts[1],iprovinceArr);
				customerVbox.comDatdPr(paramperts[2],icityArr);
				
				if(CRMtool.isStringNotNull(objup.icountry))
				{
					for(var k:int=0;k<icountryArr.length;k++)
					{
						var iid:String =icountryArr.getItemAt(k).iid;
						if(objup.icountry==iid)
						{
							customerVbox.sele(paramperts[0],k);
						}
					}
				}
				
				if(CRMtool.isStringNotNull(objup.iprovince))
				{
					for(var j:int=0;j<iprovinceArr.length;j++)
					{
						var iprovinceiid:String =iprovinceArr.getItemAt(j).iid;
						if(objup.iprovince==iprovinceiid)
						{
							customerVbox.sele(paramperts[1],j);
						}
					}
				}
				
				if(CRMtool.isStringNotNull(objup.icity))
				{
					for(var l:int=0;l<icityArr.length;l++)
					{
						var icityiid:String =icityArr.getItemAt(l).iid;
						if(objup.icity==icityiid)
						{
							customerVbox.sele(paramperts[2],l);
						}
					}
				}
			}
			/*customerVbox.sele(icountryArr,objup);*/
				
			/*	trace("选中记录"+customerVbox.getResult().icountry);*/
			/*customerVbox.comDatdPr("icountry",icountryArr);*/
		}
		
		//下拉框change事件
		public static function setComber(event:Event,fun:Function):void
		{
			var cmb_cfield:ComboBox =  event.currentTarget as ComboBox;
			if(cmb_cfield.selectedIndex!=-1)
			{
				if(cmb_cfield.selectedItem.ccode.split(".").length==1)
				
				{
					iprovinceArr.removeAll();
					icityArr.removeAll();
					getData(cmb_cfield.selectedItem.iid,iprovinceArr);
					fun("iprovince",iprovinceArr);
				}
				else if(cmb_cfield.selectedItem.ccode.split(".").length==2)
				{
					icityArr.removeAll();
					getData(cmb_cfield.selectedItem.iid,icityArr);
					fun("icity",icityArr);
				} 
			}
			else
			{
				var comArr:ArrayCollection = cmb_cfield.dataProvider as ArrayCollection;
				if(comArr.getItemAt(0).ccode.split(".").length==1)
				{
					iprovinceArr.removeAll();
					icityArr.removeAll();
				}
				else if(comArr.getItemAt(0).ccode.split(".").length==2)
				{
					icityArr.removeAll();
				}
			}
		}
		
		//往下拉框里面赋值
		private static function getData(iid:String,datas:ArrayCollection):void
		{
			for(var i:int=0;i<allData.length;i++)
			{
				var obj:Object = allData.getItemAt(i);
				if(obj.ipid==iid)
				{
					datas.addItem(obj);
				}
			}
		}
		
		//YJ Add
		//componentsArr:页面中的元素集合，para：需要处理的字段
		public static function DateDiffer(componentsArr:ArrayCollection,para:Object):Function{
			var fun:Function=function(e:Event):void
			{
				var result:Object = new Object();
				var txtday:TextInput = null;//承载相差天数的控件
				var strArr:Array = para.toString().split(",");//承载需要特殊处理的字段集合
				
				//遍历页面元素，获取开始时间、结束时间的值(页面中会存在多个日期控件)
				for each(var obj:Object  in componentsArr)
				{
					switch(obj.type)
					{
						case "DateControl":
						{
							var dfl_cfield:DateControl = obj.components as DateControl;
							result[obj.cfield]=dfl_cfield.text;
							break;
						}
						case "TextInput":
							if(obj.cfield == strArr[2]){//与传入的字段比较
								
								txtday = obj.components as TextInput;
								
							}
							break;
						default:
							break;
					}
				}
				
				//得到具体的开始时间、结束时间,并计算其相差天数
				if(para != null){
					
					var day:int = DateHadle.myDateDiffer(result[strArr[0]],result[strArr[1]]);
					if(txtday != null)
						txtday.text = day.toString();
					
				}
				
			}         
			return fun;
		}
		
		
		public static function dateDiffer(event:Event,componentsArr:ArrayCollection,paramObj:Object):void
		{
			Alert.show("1111");
		}
		
		//打开参照
		private static var frameArr:ArrayCollection;
		public static function onNewOpen(_frameArr:ArrayCollection):void
		{
			frameArr = _frameArr;
			new ConsultList(getSelectListRows,66,false);
		}
		
		
		private static function getSelectListRows(list:ArrayCollection):void{
			var listObj:Object = list.getItemAt(0);
			listObj.imaker=CRMmodel.hrperson.iid;
			for(var i:int=0;i<frameArr.length;i++)
			{
				var obj:Object = frameArr.getItemAt(i);
				var customerVbox:RadianVbox  = obj.customerVbox as RadianVbox;
				customerVbox.parametersObj = listObj;
				customerVbox.clean();
				customerVbox.reset();
				customerVbox.endi();
			}
		}
		
		//判断客户档案有没有变更
		public static function custerchange(resultObj:Object):Boolean
		{
			var isFun:Boolean =false;
			if(resultObj.o_ccode!=resultObj.ccode)
			{
				isFun=true;
			}
			else if(resultObj.o_cname!=resultObj.cname)
			{
				isFun=true;
			}
			else if(resultObj.o_icustclass!=resultObj.icustclass)
			{
				isFun=true;
			}
			else if(resultObj.o_ipartnership!=resultObj.ipartnership)
			{
				isFun=true;
			}
			else if(resultObj.o_iindustry!=resultObj.iindustry)
			{
				isFun=true;
			}
			else if(resultObj.o_cwebsite!=resultObj.cwebsite)
			{
				isFun=true;
			}
			else if(resultObj.o_iorganization!=resultObj.iorganization)
			{
				isFun=true;
			}
			else if(resultObj.o_iheadcust!=resultObj.iheadcust)
			{
				isFun=true;
			}
			else if(resultObj.o_icreditrating!=resultObj.icreditrating)
			{
				isFun=true;
			}
			else if(resultObj.o_iprovince!=resultObj.iprovince)
			{
				isFun=true;
			}
			else if(resultObj.o_cofficeaddress!=resultObj.cofficeaddress)
			{
				isFun=true;
			}
			else if(resultObj.o_cofficezipcode!=resultObj.cofficezipcode)
			{
				isFun=true;
			}
			else if(resultObj.o_cshipaddress!=resultObj.cshipaddress)
			{
				isFun=true;
			}
			else if(resultObj.o_cshipzipcode!=resultObj.cshipzipcode)
			{
				isFun=true;
			}
			else if(resultObj.o_ctel!=resultObj.ctel)
			{
				isFun=true;
			}
			else if(resultObj.o_cfax!=resultObj.cfax)
			{
				isFun=true;
			}
			else if(resultObj.o_isalesarea!=resultObj.isalesarea)
			{
				isFun=true;
			}
			else if(resultObj.o_isalesdepart!=resultObj.isalesdepart)
			{
				isFun=true;
			}
			else if(resultObj.o_isalesperson!=resultObj.isalesperson)
			{
				isFun=true;
			}
			else if(resultObj.o_icreditrating!=resultObj.icreditrating)
			{
				isFun=true;
			}
			else if(resultObj.o_cproducteffect!=resultObj.cproducteffect)
			{
				isFun=true;
			}
			else if(resultObj.o_cmemo!=resultObj.cmemo)
			{
				isFun=true;
			}
			if(!isFun)
			{
				LoginTool.tipAlert("原客户档案没有变更信息，禁止保存");
				return false;
			}
			return true;
		}
		
		
		
		

		public static function custerRed(framArr:ArrayCollection,resultObj:Object):void
		{
			for(var i:int=0;i<framArr.length;i++)
			{
				var framObj:Object = framArr.getItemAt(i);
				var customerVbox:RadianVbox  = framObj.customerVbox as RadianVbox;
				var componentsArr:ArrayCollection = customerVbox.componentsArr;
				/*var resultObj:Object = customerVbox.getResult();*/
				if(resultObj!=null)
				{
					for each(var obj:Object  in componentsArr)
					{
						switch(obj.type)
						{
							case "CRMReferTextInput":
							{
								var crmtnp_cfield:CRMReferTextInput = obj.components as CRMReferTextInput;
								if(obj.cfield=="o_ccode")
								{
									if(resultObj.o_ccode!=resultObj.ccode)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="ccode")
								{
									if(resultObj.o_ccode!=resultObj.ccode)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else  if(obj.cfield=="o_cname")
								{
									if(resultObj.o_cname!=resultObj.cname)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else  if(obj.cfield=="cname")
								{
									if(resultObj.o_cname!=resultObj.cname)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else  if(obj.cfield=="o_icustclass")
								{
									if(resultObj.o_icustclass!=resultObj.icustclass)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else  if(obj.cfield=="icustclass")
								{
									if(resultObj.o_icustclass!=resultObj.icustclass)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_ipartnership")
								{
									if(resultObj.o_ipartnership!=resultObj.ipartnership)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="ipartnership")
								{
									if(resultObj.o_ipartnership!=resultObj.ipartnership)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_iindustry")
								{
									if(resultObj.o_iindustry!=resultObj.iindustry)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="iindustry")
								{
									if(resultObj.o_iindustry!=resultObj.iindustry)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_cwebsite")
								{
									if(resultObj.o_cwebsite!=resultObj.cwebsite)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="cwebsite")
								{
									if(resultObj.o_cwebsite!=resultObj.cwebsite)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_iorganization")
								{
									if(resultObj.o_iorganization!=resultObj.iorganization)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="iorganization")
								{
									if(resultObj.o_iorganization!=resultObj.iorganization)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_iheadcust")
								{
									if(resultObj.o_iheadcust!=resultObj.iheadcust)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="iheadcust")
								{
									if(resultObj.o_iheadcust!=resultObj.iheadcust)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_icreditrating")
								{
									if(resultObj.o_icreditrating!=resultObj.icreditrating)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="icreditrating")
								{
									if(resultObj.o_icreditrating!=resultObj.icreditrating)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_iprovince")
								{
									if(resultObj.o_iprovince!=resultObj.iprovince)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="iprovince")
								{
									if(resultObj.o_iprovince!=resultObj.iprovince)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_cofficeaddress")
								{
									if(resultObj.o_cofficeaddress!=resultObj.cofficeaddress)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="cofficeaddress")
								{
									if(resultObj.o_cofficeaddress!=resultObj.cofficeaddress)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_cofficezipcode")
								{
									if(resultObj.o_cofficezipcode!=resultObj.cofficezipcode)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="cofficezipcode")
								{
									if(resultObj.o_cofficezipcode!=resultObj.cofficezipcode)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_cshipaddress")
								{
									if(resultObj.o_cshipaddress!=resultObj.cshipaddress)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="cshipaddress")
								{
									if(resultObj.o_cshipaddress!=resultObj.cshipaddress)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_cshipzipcode")
								{
									if(resultObj.o_cshipzipcode!=resultObj.cshipzipcode)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="cshipzipcode")
								{
									if(resultObj.o_cshipzipcode!=resultObj.cshipzipcode)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_ctel")
								{
									if(resultObj.o_ctel!=resultObj.ctel)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="ctel")
								{
									if(resultObj.o_ctel!=resultObj.ctel)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_cfax")
								{
									if(resultObj.o_cfax!=resultObj.cfax)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="cfax")
								{
									if(resultObj.o_cfax!=resultObj.cfax)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_isalesarea")
								{
									if(resultObj.o_isalesarea!=resultObj.isalesarea)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="isalesarea")
								{
									if(resultObj.o_isalesarea!=resultObj.isalesarea)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_isalesdepart")
								{
									if(resultObj.o_isalesdepart!=resultObj.isalesdepart)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="isalesdepart")
								{
									if(resultObj.o_isalesdepart!=resultObj.isalesdepart)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_isalesperson")
								{
									if(resultObj.o_isalesperson!=resultObj.isalesperson)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="isalesperson")
								{
									if(resultObj.o_isalesperson!=resultObj.isalesperson)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_icreditrating")
								{
									if(resultObj.o_icreditrating!=resultObj.icreditrating)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="icreditrating")
								{
									if(resultObj.o_icreditrating!=resultObj.icreditrating)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_cproducteffect")
								{
									if(resultObj.o_cproducteffect!=resultObj.cproducteffect)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="cproducteffect")
								{
									if(resultObj.o_cproducteffect!=resultObj.cproducteffect)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_cmemo")
								{
									if(resultObj.o_cmemo!=resultObj.cmemo)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="cmemo")
								{
									if(resultObj.o_cmemo!=resultObj.cmemo)
									{
										crmtnp_cfield.setStyle("color","red");
									}
								}
								break;
							}
							case "TextInput":
							{
								var tnp_cfield:TextInput = obj.components as TextInput;
								if(obj.cfield=="o_ccode")
								{
									if(resultObj.o_ccode!=resultObj.ccode)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="ccode")
								{
									if(resultObj.o_ccode!=resultObj.ccode)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else  if(obj.cfield=="o_cname")
								{
									if(resultObj.o_cname!=resultObj.cname)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else  if(obj.cfield=="cname")
								{
									if(resultObj.o_cname!=resultObj.cname)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else  if(obj.cfield=="o_icustclass")
								{
									if(resultObj.o_icustclass!=resultObj.icustclass)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else  if(obj.cfield=="icustclass")
								{
									if(resultObj.o_icustclass!=resultObj.icustclass)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_ipartnership")
								{
									if(resultObj.o_ipartnership!=resultObj.ipartnership)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="ipartnership")
								{
									if(resultObj.o_ipartnership!=resultObj.ipartnership)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_iindustry")
								{
									if(resultObj.o_iindustry!=resultObj.iindustry)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="iindustry")
								{
									if(resultObj.o_iindustry!=resultObj.iindustry)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_cwebsite")
								{
									if(resultObj.o_cwebsite!=resultObj.cwebsite)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="cwebsite")
								{
									if(resultObj.o_cwebsite!=resultObj.cwebsite)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_iorganization")
								{
									if(resultObj.o_iorganization!=resultObj.iorganization)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="iorganization")
								{
									if(resultObj.o_iorganization!=resultObj.iorganization)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_iheadcust")
								{
									if(resultObj.o_iheadcust!=resultObj.iheadcust)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="iheadcust")
								{
									if(resultObj.o_iheadcust!=resultObj.iheadcust)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_icreditrating")
								{
									if(resultObj.o_icreditrating!=resultObj.icreditrating)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="icreditrating")
								{
									if(resultObj.o_icreditrating!=resultObj.icreditrating)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_iprovince")
								{
									if(resultObj.o_iprovince!=resultObj.iprovince)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="iprovince")
								{
									if(resultObj.o_iprovince!=resultObj.iprovince)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_cofficeaddress")
								{
									if(resultObj.o_cofficeaddress!=resultObj.cofficeaddress)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="cofficeaddress")
								{
									if(resultObj.o_cofficeaddress!=resultObj.cofficeaddress)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_cofficezipcode")
								{
									if(resultObj.o_cofficezipcode!=resultObj.cofficezipcode)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="cofficezipcode")
								{
									if(resultObj.o_cofficezipcode!=resultObj.cofficezipcode)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_cshipaddress")
								{
									if(resultObj.o_cshipaddress!=resultObj.cshipaddress)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="cshipaddress")
								{
									if(resultObj.o_cshipaddress!=resultObj.cshipaddress)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_cshipzipcode")
								{
									if(resultObj.o_cshipzipcode!=resultObj.cshipzipcode)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="cshipzipcode")
								{
									if(resultObj.o_cshipzipcode!=resultObj.cshipzipcode)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_ctel")
								{
									if(resultObj.o_ctel!=resultObj.ctel)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="ctel")
								{
									if(resultObj.o_ctel!=resultObj.ctel)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_cfax")
								{
									if(resultObj.o_cfax!=resultObj.cfax)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="cfax")
								{
									if(resultObj.o_cfax!=resultObj.cfax)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_isalesarea")
								{
									if(resultObj.o_isalesarea!=resultObj.isalesarea)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="isalesarea")
								{
									if(resultObj.o_isalesarea!=resultObj.isalesarea)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_isalesdepart")
								{
									if(resultObj.o_isalesdepart!=resultObj.isalesdepart)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="isalesdepart")
								{
									if(resultObj.o_isalesdepart!=resultObj.isalesdepart)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_isalesperson")
								{
									if(resultObj.o_isalesperson!=resultObj.isalesperson)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="isalesperson")
								{
									if(resultObj.o_isalesperson!=resultObj.isalesperson)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_icreditrating")
								{
									if(resultObj.o_icreditrating!=resultObj.icreditrating)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="icreditrating")
								{
									if(resultObj.o_icreditrating!=resultObj.icreditrating)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_cproducteffect")
								{
									if(resultObj.o_cproducteffect!=resultObj.cproducteffect)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="cproducteffect")
								{
									if(resultObj.o_cproducteffect!=resultObj.cproducteffect)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="o_cmemo")
								{
									if(resultObj.o_cmemo!=resultObj.cmemo)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								else if(obj.cfield=="cmemo")
								{
									if(resultObj.o_cmemo!=resultObj.cmemo)
									{
										tnp_cfield.setStyle("color","red");
									}
								}
								break;
							}
						}
					}
				}
			}
		}
	}
}