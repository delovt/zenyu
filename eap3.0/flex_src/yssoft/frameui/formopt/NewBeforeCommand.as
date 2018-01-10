package yssoft.frameui.formopt
{
	import mx.core.Container;
	
	import yssoft.evts.EventAdv;
	import yssoft.impls.ICommand;
	import yssoft.tools.AccessUtil;
	import yssoft.tools.CRMtool;
	
	public class NewBeforeCommand extends BaseCommand
	{
		public function NewBeforeCommand(context:Container, optType:String="",param:*=null, nextCommand:ICommand=null, excuteNextCommand:Boolean=false)
		{
			super(context,optType, param, nextCommand, excuteNextCommand);
		}
		override public function onExcute():void{
			//--------------权限控制 刘磊 begin--------------//
			var warning:String=context["paramForm"]["auth"].reuturnwarning("02");
			var eventAdv:EventAdv;
			if (warning!=null){
				CRMtool.showAlert(warning);
				eventAdv=new EventAdv("EventAuth",false);
				context.dispatchEvent(eventAdv);
				return;
			}else{
				eventAdv=new EventAdv("EventAuth",true);
				context.dispatchEvent(eventAdv);
				
				//YJ Add 2012-04-07 单据编码
			/*	context.isSave = false;//新增数据时只显示单据编码，不保存
				context.onGetNumber();*/
				
				this.onNext();
			}
			//--------------权限控制 刘磊 end--------------//
		}
		
		override public function onResult(result:*):void
		{
			
		}
	}
}