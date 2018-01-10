/**
 * 单据操作 ，执行命令
 */
package yssoft.frameui.formopt
{
	import mx.core.Container;
	
	import yssoft.comps.frame.module.CrmEapDataGrid;
	import yssoft.frameui.formopt.selfopt.AddDataGridRowCommandSelf;
	import yssoft.frameui.formopt.selfopt.DClickDataGridRowCommandSelf;
	import yssoft.frameui.formopt.selfopt.DeleteCommandSelf;
	import yssoft.frameui.formopt.selfopt.DeleteDataGridRowCommandSelf;
	import yssoft.frameui.formopt.selfopt.EditCommandSelf;
	import yssoft.frameui.formopt.selfopt.InitCommandSelf;
	import yssoft.frameui.formopt.selfopt.NewCommandSelf;
	import yssoft.frameui.formopt.selfopt.OpenCommandSelf;
	import yssoft.frameui.formopt.selfopt.PrintCommandSelf;
	import yssoft.frameui.formopt.selfopt.SaveCommandSelf;
	import yssoft.scripts.selfoptimp.DeleteBeforeCommandSelfImp;
	import yssoft.scripts.selfoptimp.DeleteDataGridRowBeforeCommandSelfImp;
	import yssoft.scripts.selfoptimp.SaveBeforeCommandSelfImp;
	import yssoft.vos.CommandParam;

	public class FormOpt
	{
		public function FormOpt()
		{
			
		}
		
		/**
		 * 初始化命令
		 * context 被操作的窗体引用
		 * optType 操作类型
		 * param   操作传递的参数
		 */
		public static function initOpt(context:Container,optType:String="",param:*=null):void{
			var afterself:InitCommandSelf=new InitCommandSelf("InitAfterCommandSelf",context,optType,param,null,false);
			var after:InitAfertCommand=new InitAfertCommand(context,optType,param,afterself,false);
			var initingself:InitCommandSelf=new InitCommandSelf("InitingCommandSelf",context,optType,param,after,false);
			var initing:InitingCommand=new InitingCommand(context,optType,param,initingself,false);
			var before:InitBeforeCommand=new InitBeforeCommand(context,optType,param,initing,false);
			var beforeself:InitCommandSelf=new InitCommandSelf("InitBeforeCommandSelf",context,optType,param,before,true);
			beforeself.onExcute();
		}
		
		/**
		 * 再次打开窗体命令
		 * context 被操作的窗体引用
		 * optType 操作类型
		 * param   操作传递的参数
		 */
		public static function openOpt(context:Container,optType:String="",param:*=null):void{
			var afterself:OpenCommandSelf=new OpenCommandSelf("OpenAfterCommandSelf",context,optType,param,null,false);
			var after:OpenAfterCommand=new OpenAfterCommand(context,optType,param,afterself,false);
			var openingself:OpenCommandSelf=new OpenCommandSelf("OpeningCommandSelf",context,optType,param,after,false);
			var opening:OpeningCommand=new OpeningCommand(context,optType,param,openingself,false);
			var before:OpenBeforeCommand=new OpenBeforeCommand(context,optType,param,opening,false);
			var beforeself:OpenCommandSelf=new OpenCommandSelf("OpenBeforeCommandSelf",context,optType,param,before,true);
			beforeself.onExcute(); 
		}
		
		/**
		 * 保存命令
		 * context 被操作的窗体引用
		 * optType 操作类型
		 * param   操作传递的参数
		 */
		public static function saveOpt(context:Container,optType:String="",param:*=null,arr:Array=null):void{
			var afterself:SaveCommandSelf=new SaveCommandSelf("SaveAfterCommandSelf",context,optType,param,null,false);
			var after:SaveAfterCommand=new SaveAfterCommand(context,optType,param,afterself,false);
			var savingself:SaveCommandSelf=new SaveCommandSelf("SavingCommandSelf",context,optType,param,after,false);
			var saving:SavingCommand=new SavingCommand(context,optType,param,savingself,false,arr);
			var before:SaveBeforeCommand=new SaveBeforeCommand(context,optType,param,saving,false);
			var beforeself:SaveCommandSelf=new SaveCommandSelf("SaveBeforeCommandSelf",context,optType,param,before,true);
			beforeself.onExcute();
		}
		
		/**
		 * 删除命令
		 * context 被操作的窗体引用
		 * optType 操作类型
		 * param   操作传递的参数
		 */
		public static function deleteOpt(context:Container,optType:String="",param:*=null):void{
			var afterself:DeleteCommandSelf=new DeleteCommandSelf("DeleteAfterCommandSelf",context,optType,param,null,false);
			var after:DeleteAfterCommand=new DeleteAfterCommand(context,optType,param,afterself,false);
			var deletingself:DeleteCommandSelf=new DeleteCommandSelf("DeletingCommandSelf",context,optType,param,after,false);
			var deleting:DeletingCommand=new DeletingCommand(context,optType,param,deletingself,false);
			var before:DeleteBeforeCommand=new DeleteBeforeCommand(context,optType,param,deleting,false);
			var beforeself:DeleteCommandSelf=new DeleteCommandSelf("DeleteBeforeCommandSelf",context,optType,param,before,true);
			beforeself.onExcute();
		}
		
		/**
		 * 新增命令
		 * context 被操作的窗体引用
		 * optType 操作类型
		 * param   操作传递的参数
		 */
		public static function newOpt(context:Container,optType:String="",param:*=null):void{
			var afterself:NewCommandSelf=new NewCommandSelf("NewAfterCommandSelf",context,optType,param,null,false);
			var after:NewAfterCommand=new NewAfterCommand(context,optType,param,afterself,false);
			var newingself:NewCommandSelf=new NewCommandSelf("NewingCommandSelf",context,optType,param,after,false);
			var newing:NewingCommand=new NewingCommand(context,optType,param,newingself,false);
			var before:NewBeforeCommand=new NewBeforeCommand(context,optType,param,newing,false);
			var beforeself:NewCommandSelf=new NewCommandSelf("NewBeforeCommandSelf",context,optType,param,before,true);
			beforeself.onExcute(); 
		}
		
		/**
		 * 修改命令
		 * context 被操作的窗体引用
		 * optType 操作类型
		 * param   操作传递的参数
		 */
		public static function editOpt(context:Container,optType:String="",param:*=null):void{
			var afterself:EditCommandSelf=new EditCommandSelf("EditAfterCommandSelf",context,optType,param,null,false);
			var after:EditAfertCommand=new EditAfertCommand(context,optType,param,afterself,false);
			var editingself:EditCommandSelf=new EditCommandSelf("EditingCommandSelf",context,optType,param,after,false);
			var editing:EditingCommand=new EditingCommand(context,optType,param,editingself,false);
			var before:EditBeforeCommand=new EditBeforeCommand(context,optType,param,editing,false);
			var beforeself:EditCommandSelf=new EditCommandSelf("EditBeforeCommandSelf",context,optType,param,before,true);
			beforeself.onExcute();
		}
		
		//工作流 lr add  包含先保存再提交功能
		public static function submitWorkflowOpt(context:Container,optType:String="",param:*=null):void{
			var flag:Boolean = false;
			
			var submitAfter:SubmitWorkflowAfterCommand=new SubmitWorkflowAfterCommand(context,optType,param,null,false);
			var submitIniting:SubmitWorkflowingCommand=new SubmitWorkflowingCommand(context,optType,param,submitAfter,false);
			var submitBefore:SubmitWorkflowBeforeCommand=new SubmitWorkflowBeforeCommand(context,optType,param,submitIniting,flag);
			//before.onExcute();
			
			//注入命令行 好像有问题，注释掉一切正常，如果要解除注释，注意更改对应的“下一条”属性。
			//var afterself:SaveCommandSelf=new SaveCommandSelf("SaveAfterCommandSelf",context,optType,param,submitBefore,false);
			var after:SaveAfterCommand=new SaveAfterCommand(context,optType,param,submitBefore,false);
			//var savingself:SaveCommandSelf=new SaveCommandSelf("SavingCommandSelf",context,optType,param,after,false);
			var saving:SavingCommand=new SavingCommand(context,optType,param,after,false);
			var before:SaveBeforeCommand=new SaveBeforeCommand(context,optType,param,saving,false);
			//var beforeself:SaveCommandSelf=new SaveCommandSelf("SaveBeforeCommandSelf",context,optType,param,before,true);
			
			
			if(context["paramForm"].currid<=0){//是新增单据
				before.onExcute();
				return;
			}
			if(context["paramForm"].currid>0&&optType=="onEdit"){//是修改单据
				before.onExcute();
				return;
			}
			if(context["paramForm"].currid>0){//不是新增单据
				flag = true;
				submitBefore.onExcute();
				flag = false;
			}			
		}
		
/*先保存再提交，已废弃，且功能不完整  lr		//新增提交
		public static function saveSumitOpt(context:Container,optType:String="",param:*=null):void{
			
			//提交
			var beforeself:SaveCommandSelf=new SaveCommandSelf("SaveBeforeCommandSelf",context,optType,param,before,true);
			var sumitAfter:SubmitWorkflowAfterCommand=new SubmitWorkflowAfterCommand(context,optType,param,null,false);
			var sumitIniting:SubmitWorkflowingCommand=new SubmitWorkflowingCommand(context,optType,param,sumitAfter,false);
			var sumitBefore:SubmitWorkflowBeforeCommand=new SubmitWorkflowBeforeCommand(context,optType,param,sumitIniting,true);
			
			
			before.onExcute();
		}*/
		
		/**
		 * 打印命令
		 * 
		 */
		public static function printOpt(context:Container,optType:String="onPrint",param:*=null):void{
			var afterself:PrintCommandSelf=new PrintCommandSelf("PrintAfterCommandSelf",context,optType,param,null,false);
			var after:PrintAfterCommand=new PrintAfterCommand(context,optType,param,afterself,false);
			var printingself:PrintCommandSelf=new PrintCommandSelf("PrintingCommandSelf",context,optType,param,after,false);
			var printing:PrintingCommand=new PrintingCommand(context,optType,param);
			var before:PrintBeforeCommand=new PrintBeforeCommand(context,optType,param,printing,false);
			var beforeself:PrintCommandSelf=new PrintCommandSelf("PrintBeforeCommandSelf",context,optType,param,before,true);
			beforeself.onExcute();
		}
		
		/**
		 * 调用自定义命令
		 * 
		 */
		public static function onCommandSelf(cmdparam:CommandParam,onname:String,cmd:Object,cmdself:Object,arr:Array=null):void
		{
			var curcontext:Object;
			
			if (cmdparam.hasOwnProperty("paramForm"))
			{
				curcontext=cmdparam.context["paramForm"];
				
			}
			else
			{
				if (cmdparam.context is CrmEapDataGrid)
				{
					curcontext=cmdparam.context["paramForm"]["paramForm"];
				}
				else
				{
				    curcontext=cmdparam.context;
				}
			}				
			cmdparam.context=curcontext;
			if (cmdparam.context.hasOwnProperty("formIfunIid"))
			{
				var formIfunIid:int=int(cmdparam.context["formIfunIid"]);
				if (cmdself.hasOwnProperty(onname+"_IFun"+formIfunIid))
				{
					cmdself[onname+"_IFun"+formIfunIid](cmdparam);
					
					//非保存前注入命令特殊处理，以保证保存前牵扯到回调的命令链控制 lr add
					if (cmdparam.excuteNextCommand&&!(cmdself is SaveBeforeCommandSelfImp)&&!(cmdself is DeleteBeforeCommandSelfImp)&&!(cmdself is DeleteDataGridRowBeforeCommandSelfImp))
					{
						cmd.onNext();
					}
					
/*					if (cmdparam.excuteNextCommand)
					{
						cmd.onNext();
					}*/
				}
				else
				{
					cmd.onNext();
				}
			}
			else
			{
				cmd.onNext();
			}
		}
		
		//表格新增行
		public static function addDataGridRowOpt(context:CrmEapDataGrid,optType:String="",param:*=null):void{
			var afterself:AddDataGridRowCommandSelf=new AddDataGridRowCommandSelf("AddDataGridRowAfterCommandSelf",context,optType,param,null,false);
			var after:AddDataGridRowAfterCommand=new AddDataGridRowAfterCommand(context,optType,param,afterself,false);
			var addingself:AddDataGridRowCommandSelf=new AddDataGridRowCommandSelf("AddDataGridRowingCommandSelf",context,optType,param,after,false);
			var adding:AddDataGridRowingCommand=new AddDataGridRowingCommand(context,optType,param,addingself,false);
			var before:AddDataGridRowBeforeCommand=new AddDataGridRowBeforeCommand(context,optType,param,adding,false);
			var beforeself:AddDataGridRowCommandSelf=new AddDataGridRowCommandSelf("AddDataGridRowBeforeCommandSelf",context,optType,param,before,true);
			beforeself.onExcute();
		}
		
		
		//表格删行
		public static function deleteDataGridRowOpt(context:CrmEapDataGrid,optType:String="",param:*=null):void{
			var afterself:DeleteDataGridRowCommandSelf=new DeleteDataGridRowCommandSelf("DeleteDataGridRowAfterCommandSelf",context,optType,param,null,false);
			var after:DeleteDataGridRowAfterCommand=new DeleteDataGridRowAfterCommand(context,optType,param,afterself,false);
			var initing:DeleteDataGridRowingCommand=new DeleteDataGridRowingCommand(context,optType,param,after,false);
			var before:DeleteDataGridRowBeforeCommand=new DeleteDataGridRowBeforeCommand(context,optType,param,initing,false);
			var beforeself:DeleteDataGridRowCommandSelf=new DeleteDataGridRowCommandSelf("DeleteDataGridRowBeforeCommandSelf",context,optType,param,before,true);
			beforeself.onExcute();
		}
		
		//表格删行
		public static function deleteAllDataGridRowOpt(context:CrmEapDataGrid,optType:String="",param:*=null):void{
			var after:DeleteAllDataGridAfterCommand=new DeleteAllDataGridAfterCommand(context,optType,param,null,false);
			var initing:DeleteAllDataGridingCommand=new DeleteAllDataGridingCommand(context,optType,param,after,false);
			var before:DeleteAllDataGridBeforeCommand=new DeleteAllDataGridBeforeCommand(context,optType,param,initing,true);
			before.onExcute();
		}
		
		//双击表格
		public static function dclickDataGridRowOpt(context:CrmEapDataGrid,optType:String="",param:*=null):void{
			var afterself:DClickDataGridRowCommandSelf=new DClickDataGridRowCommandSelf("DClickDataGridRowAfterCommandSelf",context,optType,param,null,false);
			var after:DClickDataGridRowAfterCommand=new DClickDataGridRowAfterCommand(context,optType,param,afterself,false);
			var addingself:DClickDataGridRowCommandSelf=new DClickDataGridRowCommandSelf("DClickDataGridRowingCommandSelf",context,optType,param,after,false);
			var adding:DClickDataGridRowingCommand=new DClickDataGridRowingCommand(context,optType,param,addingself,false);
			var before:DClickDataGridRowBeforeCommand=new DClickDataGridRowBeforeCommand(context,optType,param,adding,false);
			var beforeself:DClickDataGridRowCommandSelf=new DClickDataGridRowCommandSelf("DClickDataGridRowBeforeCommandSelf",context,optType,param,before,true);
			beforeself.onExcute();
		}
	}
}