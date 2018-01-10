package yssoft.frameui.formopt.selfopt
{
	import flashx.textLayout.formats.Float;
	
	import mx.collections.ArrayCollection;
	import mx.core.Container;
	import mx.utils.ObjectUtil;
	
	import yssoft.comps.frame.module.CrmEapRadianVbox;
	import yssoft.frameui.formopt.BaseCommand;
	import yssoft.frameui.formopt.FormOpt;
	import yssoft.impls.ICommand;
	import yssoft.scripts.selfoptimp.InitAfterCommandSelfImp;
	import yssoft.scripts.selfoptimp.InitBeforeCommandSelfImp;
	import yssoft.scripts.selfoptimp.InitingCommandSelfImp;
	import yssoft.tools.CRMtool;
	import yssoft.vos.CommandParam;
	
	public class InitCommandSelf extends BaseCommand
	{
		//传递的参数
		private var cmdparam:CommandParam=new CommandParam();
		//自定义命令实现
		private var initBeforeCommandSelf:InitBeforeCommandSelfImp=new InitBeforeCommandSelfImp();
		private var initingCommandSelf:InitingCommandSelfImp=new InitingCommandSelfImp();
		private var initAfterCommandSelf:InitAfterCommandSelfImp=new InitAfterCommandSelfImp();
		
		public function InitCommandSelf(cmdselfName:String,context:Container, optType:String="",param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
		{
			cmdparam.context=context;
			cmdparam.optType=optType;
			cmdparam.param=param;
			cmdparam.nextCommand=nextCommand;
			cmdparam.excuteNextCommand=excuteNextCommand;
			cmdparam.cmdselfName=cmdselfName;
			super(context,optType, param, nextCommand, excuteNextCommand);
		}
		
		override public function onExcute():void{
			   switch(cmdparam.cmdselfName)
			   {
				   case "InitBeforeCommandSelf":
				   {
					   FormOpt.onCommandSelf(cmdparam,"onExcute",this,initBeforeCommandSelf);
					   break;
				   }
				   case "InitingCommandSelf":
				   {
					   //lr add  自动代入注入数据  关键点：injectObj
					   if(cmdparam!=null&&cmdparam.context.hasOwnProperty("winParam")
						   &&cmdparam.context["winParam"].hasOwnProperty("formTriggerType")
						   &&cmdparam.context["winParam"]["formTriggerType"]=="fromOther"){
						   
						   var crmeap:CrmEapRadianVbox = cmdparam.context["crmeap"] as CrmEapRadianVbox;
						   var obj:Object = new Object();
						   var mainValue:Object = crmeap.getValue();
						   var injectObj:Object = cmdparam.context["winParam"]["injectObj"];
						   
						   if(injectObj){
							   var objInfo:Object=ObjectUtil.getClassInfo(injectObj);
							   var fieldName:Array=objInfo["properties"] as Array;  
							   for each (var q:QName in fieldName)  
							   {  
								   if(injectObj[q.localName] is ArrayCollection){
									   obj[q.localName]=injectObj[q.localName]; 
								   }
								   else{
									   mainValue[q.localName]=injectObj[q.localName]; 
								   }
								   
							   }
							   obj.mainValue = mainValue;
							   crmeap.setValue(obj,1,1);
						   }

					   }
					   
					   FormOpt.onCommandSelf(cmdparam,"onExcute",this,initingCommandSelf);
					   break;
				   }
				   case "InitAfterCommandSelf":
				   {
					   FormOpt.onCommandSelf(cmdparam,"onExcute",this,initAfterCommandSelf);
					   break;
				   }
			   }
		}
	}
}