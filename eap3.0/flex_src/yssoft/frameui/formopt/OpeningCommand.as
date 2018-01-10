package yssoft.frameui.formopt
{
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.controls.Alert;
	import mx.core.Container;
	import mx.rpc.events.ResultEvent;
	
	import yssoft.comps.frame.module.CrmEapRadianVbox;
	import yssoft.frameui.FrameCore;
	import yssoft.impls.ICommand;
	import yssoft.tools.AccessUtil;
	import yssoft.tools.CRMtool;
	
	public class OpeningCommand extends BaseCommand
	{
		//传递的参数
		private var _context:FrameCore;
		
		public function OpeningCommand(context:Container,optType:String, param:*, nextCommand:ICommand, excuteNextCommand:Boolean=false)
		{
			_context=context as FrameCore;
			super(context, optType,param, nextCommand, excuteNextCommand);
		}
		
		override public function onExcute():void{
			
			try
			{
				_context.curFormIndex=-1;
				_context._vouchFormValue.removeAll();
				_context.curButtonStatus="onNew";
				_context.formStatus="new";
				_context.openWin();
				
				if(_context.formStatus=="edit"||_context.formStatus=="new")
				{
					if(_context.formStatus=="edit")
					{
						_context.curFormIndex=0;
						_context.onEdit();
						_context.crmeap.initSubTableAssignment();
					}
					else
					{
						_context.curFormIndex=0;
						_context.onNew();
					}
					_context.setOtherButtons(false);
				}
				else
				{
					if(_context.formStatus=="browser")
					{
						_context.curFormIndex=0;
						_context.onNext();
					}
					_context.setOtherButtons(true);
				}
				_context.crmeap["isFirst"]=false;
				this.onNext();
			}
			catch(e:Error)
			{
				CRMtool.showAlert("新增异常！原因："+e.toString()); 
			}
		}
	}
}