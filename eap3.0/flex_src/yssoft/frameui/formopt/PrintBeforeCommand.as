package yssoft.frameui.formopt
{
	import mx.controls.Alert;
	import mx.core.Container;
	
	import yssoft.evts.EventAdv;
	import yssoft.impls.ICommand;
	import yssoft.tools.CRMtool;
	
	public class PrintBeforeCommand extends BaseCommand
	{
		public function PrintBeforeCommand(context:Container, optType:String="", param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
		{
			super(context, optType, param, nextCommand, excuteNextCommand);
		}
		
		override public function onExcute():void{
			//Alert.show("---打印前权限验证----");
			//--------------权限控制 刘磊 begin--------------//
			var warning:String=context["paramForm"]["auth"].reuturnwarning("05");
			var eventAdv:EventAdv;
			if (warning!=null){
				CRMtool.showAlert(warning);
				eventAdv=new EventAdv("EventAuth",false);
				context.dispatchEvent(eventAdv);
				return;
			}else{
				eventAdv=new EventAdv("EventAuth",true);
				context.dispatchEvent(eventAdv);
				this.onNext();
			}
			//--------------权限控制 刘磊 end--------------//
		}
	}
}