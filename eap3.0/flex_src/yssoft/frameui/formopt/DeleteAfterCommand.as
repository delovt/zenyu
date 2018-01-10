package yssoft.frameui.formopt
{
	import mx.core.Container;
	
	import yssoft.impls.ICommand;
	
	import yssoft.frameui.event.FormEvent;
	
	public class DeleteAfterCommand extends BaseCommand
	{
		public function DeleteAfterCommand(context:Container, optType:String="", param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
		{
			super(context, optType, param, nextCommand, excuteNextCommand);
		}
		
		override public function onExcute():void{
			
			var evt:FormEvent=null;
			if(context.data!="fail")
			{
				evt=new FormEvent(FormEvent.FORM_OPT_SUCCES,"deleteafter",null,"删除成功...");
				
			}
			else
			{
				evt=new FormEvent(FormEvent.FORM_OPT_FAILURE,"fail",null,"删除失败...");
			}
			context.dispatchEvent(evt);
			this.onNext();
		}
	}
}