package yssoft.frameui.formopt
{
import mx.collections.ArrayCollection;
import mx.rpc.events.ResultEvent;

import yssoft.comps.frame.module.CrmEapDataGrid;
import yssoft.frameui.FrameCore;
import yssoft.impls.ICommand;
import yssoft.tools.AccessUtil;
import yssoft.tools.CRMtool;
import yssoft.vos.CommandParam;

public class AddDataGridRowingCommand extends BaseCommand
	{
		//获得用户输入值
		private var paramObj:Object;
		
		private var _optType:String="";
		
		private var _context:CrmEapDataGrid;
		
		private var cmdparam:CommandParam=new CommandParam();
		
		private var primaryKey:String="";//子表主键
		private var foreignKey:String="";//子表外键及母表主键
		private var foreignKey_value:Object="";
		private var ctable:String="";//子表
		private var ctable2:String="";//母表 
		
		public function AddDataGridRowingCommand(context:CrmEapDataGrid, optType:String="", param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
		{
			cmdparam.context=context;
			this._param = param;
			this._optType = optType;
			this._context=context;
			this.primaryKey="";
			this.foreignKey="";
			this.foreignKey_value="";
			this.ctable="";
			this.ctable2="";
			super(context, optType, param, nextCommand, excuteNextCommand);
		}
		
		/**
		 * 方法功能：判断是否选择母表
		 * 编写作者：XZQWJ
		 * 创建日期：2013-01-04
		 * 更新日期：
		 */
		public  function isSelectPData():String{
			
			var bool:Boolean=false;
			var Mesg:String="";
			var ordersDG:CrmEapDataGrid =null;
			if(!(this._context.paramForm.paramForm is FrameCore)){
				return Mesg;
			}
			
			var tableMessage:ArrayCollection=this._context.paramForm.paramForm.crmeap.tableMessage;//表之间关系
			
			var currDGridName:Object=cmdparam.context.ctableName ;//当前选择的dg的名称
			
			var l:int = tableMessage.length;
			for(var i:int=0;i<l;i++){
				if(!tableMessage.getItemAt(i).bMain&&tableMessage.getItemAt(i).ctable==currDGridName){
					ctable2=tableMessage.getItemAt(i).ctable2 as String;
					ctable=currDGridName.toString();
					for each(var dg:CrmEapDataGrid in this._context.paramForm.paramForm.crmeap.gridList){
						if(dg.ctableName==ctable2){
							ordersDG=dg;
							primaryKey=tableMessage.getItemAt(i).primaryKey;
							foreignKey=tableMessage.getItemAt(i).foreignKey;
							dg.foreignKey=foreignKey;
							bool=true;
							break;
						}
					}
					if(!bool){
						ctable=currDGridName.toString();
						ctable2="";
						for each(var dg:CrmEapDataGrid in this._context.paramForm.paramForm.crmeap.gridList){
							if(dg.ctableName==ctable){
								primaryKey=tableMessage.getItemAt(i).primaryKey;
								foreignKey=tableMessage.getItemAt(i).foreignKey;
								var arr:Array=CRMtool.RandomArray(-1000,-1,1);
								foreignKey_value=arr[0];
								break;
							}
						}
						
					}
				}
				if(bool){
					break;
				}
			}
			if(!bool){
				
				return Mesg;
			}
			var ctableCNName:Object=ordersDG.singleType.ccaption;
			var dataPro:ArrayCollection=ordersDG.dataProvider as ArrayCollection;
			if(dataPro!=null&&dataPro.length>0){
				if(ordersDG&&ordersDG.selectedItem){
					
					foreignKey_value=ordersDG.selectedItem[primaryKey]
					
					if(foreignKey_value==""){
						var arr:Array=CRMtool.RandomArray(-1000,-1,1);
						foreignKey_value=arr[0];
					}
					trace(foreignKey_value);
				}else{
					
					if(!ctableCNName){
						Mesg="未在其关联主表中发现焦点行，请确认。\n     （被黄色标注的即为焦点行）";
					}else{
						Mesg="未在"+ctableCNName+"中发现焦点行，请确认。\n     （被黄色标注的即为焦点行）";
					}
					
				}
			}else{
				Mesg="请先增加"+ctableCNName+"，再增加。";
			}
			return Mesg;
		}
		
		override public function onExcute():void{
			var Mesg :String=isSelectPData();
			if(Mesg!=""){
				CRMtool.showAlert(Mesg);
				return;
			}
			context["editable"]=true;
			var taleChildArr:ArrayCollection =_param.taleChild as ArrayCollection; 
			var obj:Object = new Object();
			var count:int=1;
			for each(var taleChild:Object in taleChildArr)
			{
				var cfield:String=taleChild.cfield;
				if(taleChild.bread=="false"||!Boolean(taleChild.bread))
				{
					obj[cfield+"_enabled"]="1";
				}
//				if(this._optType=="onNew"){
					if(ctable==taleChild.ctable&&ctable2==""&&primaryKey==cfield){
						obj[cfield]=foreignKey_value;
					}else if(ctable==taleChild.ctable&&ctable2!=""&&foreignKey==cfield){
						obj[cfield]=foreignKey_value;
					}
					
//					if(null!=taleChild&&taleChild.iconsult>0)
//					{
//						var newCfield:String=cfield+"_Name";
//						obj[newCfield]="";
//					}
					
				if(this._optType=="onNew"&&(null!=taleChild.cnewdefault&&""!=taleChild.cnewdefault))
				{
					var cnewdefault:String=taleChild.cnewdefault;
					obj[cfield]=CRMtool.defaultValue(cnewdefault);
					if(null!=taleChild&&taleChild.iconsult>0)
					{
						var sql:String = taleChild.consultSql;
						sql+=" and "+taleChild.cconsultbkfld+"='"+obj[cfield]+"'";
						//调用后台方法
						AccessUtil.remoteCallJava("CommonalityDest","assemblyQuerySql",function(evt:ResultEvent):void{
							var rArr:ArrayCollection = evt.result as ArrayCollection;
							var newCfield:String=cfield+"_Name";
							if(rArr==null||rArr.length==0)
							{
								obj[cfield]="";
								obj[newCfield]="";
							}
							else
							{
								obj[newCfield]=rArr.getItemAt(0)[taleChild.cconsultswfld];
							}
						},sql,null,false);
					}
				}
				else if(this._optType=="onEdit"&&(null!=taleChild.ceditdefault&&""!=taleChild.ceditdefault))
				{
					var ceditdefault:String=taleChild.ceditdefault;
					obj[cfield]=CRMtool.defaultValue(ceditdefault);
					if(null!=taleChild&&taleChild.iconsult>0)
					{
						var sql:String = taleChild.consultSql;
						sql+=" and "+taleChild.cconsultbkfld+"='"+obj[cfield]+"'";
						//调用后台方法
						AccessUtil.remoteCallJava("CommonalityDest","assemblyQuerySql",function(evt:ResultEvent):void{
							var rArr:ArrayCollection = evt.result as ArrayCollection;
							var newCfield:String=cfield+"_Name";
							if(rArr==null||rArr.length==0)
							{
								obj[cfield]="";
								obj[newCfield]="";
							}
							else
							{
								obj[newCfield]=rArr.getItemAt(0)[taleChild.cconsultswfld];
							}
						},sql,null,false);
					}
				}
				else if(this._optType=="onEdit"&&(null!=taleChild.ceditdedefaultfix&&""!=taleChild.ceditdedefaultfix))
				{
					var ceditdefault:String=taleChild.ceditdedefaultfix;
					obj[cfield]=CRMtool.defaultValue(ceditdefault);
					if(null!=taleChild&&taleChild.iconsult>0)
					{
						var sql:String = taleChild.consultSql;
						sql+=" and "+taleChild.cconsultbkfld+"='"+obj[cfield]+"'";
						//调用后台方法
						AccessUtil.remoteCallJava("CommonalityDest","assemblyQuerySql",function(evt:ResultEvent):void{
							var rArr:ArrayCollection = evt.result as ArrayCollection;
							var newCfield:String=cfield+"_Name";
							if(rArr==null||rArr.length==0)
							{
								obj[cfield]="";
								obj[newCfield]="";
							}
							else
							{
								obj[newCfield]=rArr.getItemAt(0)[taleChild.cconsultswfld];
							}
						},sql,null,false);
					}
				}
				else
				{
					if(primaryKey!=cfield&&foreignKey!=cfield){
						obj[cfield]="";
					}
					if(null!=taleChild&&taleChild.iconsult>0)
					{
						var newCfield:String=cfield+"_Name";
						obj[newCfield]="";
					}
				}
			}
			
			
			if(null==context["tableList"])
			{
				context["tableList"]=new ArrayCollection();
			}
			context["tableList"].addItem(obj);
			if(CRMtool.relation){
			var arr :ArrayCollection = new ArrayCollection();
			for each(var temp:Object in context["tableList"]){
				if(temp[foreignKey]==foreignKey_value){
					arr.addItem(temp);
				}
			}
			context["dataProvider"]=arr;
			if(arr.length==0){
				context["dataProvider"]=context["tableList"];
			}
			}else{
				context["dataProvider"]=context["tableList"];
			}
			
			this.onNext();
		}
	}
}