package yssoft.frameui.formopt
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.Container;
	import mx.rpc.events.ResultEvent;
	
	import yssoft.comps.CRMListMsg;
	import yssoft.comps.frame.module.CrmEapRadianVbox;
	import yssoft.evts.EventAdv;
	import yssoft.evts.onItemDoubleClick;
	import yssoft.frameui.FrameCore;
	import yssoft.impls.ICommand;
	import yssoft.models.CRMmodel;
	import yssoft.tools.AccessUtil;
	import yssoft.tools.CRMtool;
	
	public class DeleteBeforeCommand extends BaseCommand
	{
		
		
		//public var _param:Object=null;
		
		public function DeleteBeforeCommand(context:Container, optType:String="", param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
		{
			//this._param =param;
			super(context, optType, param, nextCommand, excuteNextCommand);
		}
		
		private var isFind:Boolean=false;
		override public function onExcute():void{
			checkUpdate();
		}
		
		
		private function Get_beforedelinfo(event:onItemDoubleClick):void
		{
			if(!isFind)
			{
				isFind=true;
				if (context["paramForm"]["auth"].delinfoArr==null||context["paramForm"]["auth"].delinfoArr.length==0)
				{
					CRMtool.tipAlert1("确定要删除该记录吗?",null,"AFFIRM",deletePm);
				}
				else
				{
					//--------------删除前提示相关表及字段信息 刘磊20111021 begin--------------//
					//动态创建其他数据列
					var columns:Array=new Array();
					var col2:DataGridColumn=new DataGridColumn();
					col2.dataField="cname";
					col2.headerText="单据名称";
					col2.width=45;
					columns.push(col2);
					var col4:DataGridColumn=new DataGridColumn();
					col4.dataField="ccaption";
					col4.headerText="使用字段";
					col4.width=45;
					columns.push(col4);
					var col1:DataGridColumn=new DataGridColumn();
					col1.dataField="iinvoice";
					col1.headerText="业务号";
					col1.width=15;
					columns.push(col1);
					new CRMListMsg(context["paramForm"]["auth"].delinfoArr,columns,"删除失败：该单据已被以下单据使用！");
					//--------------删除前提示相关表及字段信息 刘磊20111021 end--------------//
				}
			}
		}
		
		private function deletePm():void
		{
			onNext();
		}
		
		override public function onResult(result:*):void
		{
			
		}
		
		
		public function checkUpdate():void
		{
			if (context["paramForm"].hasOwnProperty("_vouchFormValue"))
			{
				var crmeap:CrmEapRadianVbox=context["paramForm"].formShowArea.getChildByName("myCanva") as CrmEapRadianVbox;
				var mainValue:Object =crmeap.getValue();
				var param:Object = new Object();
				param.ifuncregedit=mainValue.iifuncregedit;
				param.iinvoice=mainValue.iid;
				param.cfield="bdelete";
				
				AccessUtil.remoteCallJava("UtilViewDest","isRepeatedly",function(evt:ResultEvent):void{
					var isfind:Boolean = evt.result as Boolean;
					if(isfind)
					{
						//--------------权限控制 刘磊 begin--------------//
						var warning:String=context["paramForm"]["auth"].reuturnwarning("04");
						var eventAdv:EventAdv;
						
						if(CRMtool.isStringNull(warning)||(warning=="hasWorkFlow"&&context.paramForm.wfiid==0)||(warning=="hasWorkFlow"&&CRMmodel.hrperson.cname== "admin")){
							eventAdv=new EventAdv("EventAuth",true);
							context.dispatchEvent(eventAdv);
						}else {
							if(warning=="hasWorkFlow")
								warning = "请撤消该单据对应的工作流后再执行此操作！";
							
							CRMtool.showAlert(warning);
							eventAdv=new EventAdv("EventAuth",false);
							context.dispatchEvent(eventAdv);
							return;
						}
						//--------------权限控制 刘磊 end--------------//
						
						context["paramForm"]["auth"].addEventListener("onGet_beforedelinfoSucess",Get_beforedelinfo);
						context["paramForm"]["auth"].get_beforedelinfo(_param.value.iifuncregedit,_param.value.iid);
						isFind=false;
					}
					else
					{
						CRMtool.tipAlert("该单据已经被引用，不能删除！！");
					}
				},param,null,false);
			}
			else
			{
				//--------------权限控制 刘磊 begin--------------//
				var warning:String=context["paramForm"]["auth"].reuturnwarning("04");
				var eventAdv:EventAdv;
				
				if(CRMtool.isStringNull(warning)||(warning=="hasWorkFlow"&&context.paramForm.wfiid==0)||(warning=="hasWorkFlow"&&CRMmodel.hrperson.cname== "admin")){
					eventAdv=new EventAdv("EventAuth",true);
					context.dispatchEvent(eventAdv);
				}else {
					if(warning=="hasWorkFlow")
						warning = "请撤消该单据对应的工作流后再执行此操作！";
					
					CRMtool.showAlert(warning);
					eventAdv=new EventAdv("EventAuth",false);
					context.dispatchEvent(eventAdv);
					return;
				}
				//--------------权限控制 刘磊 end--------------//
				
				context["paramForm"]["auth"].addEventListener("onGet_beforedelinfoSucess",Get_beforedelinfo);
				context["paramForm"]["auth"].get_beforedelinfo(_param.value.iifuncregedit,_param.value.iid);
				isFind=false;
			}
		}
	}
}