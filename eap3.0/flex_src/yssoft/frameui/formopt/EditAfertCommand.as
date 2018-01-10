package yssoft.frameui.formopt
{
	import mx.core.Container;
	import yssoft.frameui.event.FormEvent;
	import yssoft.impls.ICommand;
	
	public class EditAfertCommand extends BaseCommand
	{
		public function EditAfertCommand(context:Container, optType:String="", param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
		{
			super(context, optType, param, nextCommand, excuteNextCommand);
		}
		
		override public function onExcute():void{
			this.onNext();
		}
	}
}