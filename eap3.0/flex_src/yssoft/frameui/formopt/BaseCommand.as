package yssoft.frameui.formopt
{
	import mx.core.Container;
	
	import yssoft.impls.ICommand;
	
	public class BaseCommand implements ICommand
	{
		
		public  var _param:*;							//传递的参数
		private var _nextCommand:ICommand;				//要执行的下一个命令
		private var _excuteNextCommand:Boolean=false; //是否立即执行下一条命令，ture为立即执行，false 为 参看执行后的结构而定
		private var _context:Object=null;
		private var _optType:String="";
		public function BaseCommand(context:Object,optType:String="",param:*=null,nextCommand:ICommand=null,excuteNextCommand:Boolean=false)
		{
			this._param=param;
			this._nextCommand=nextCommand;
			this._excuteNextCommand=excuteNextCommand;
			this._context=context;
			this._optType=optType;
		}
		
/*		public function get param():*
		{
			return _param;
		}

		public function set param(value:*):void
		{
			_param = value;
		}*/

		public function get optType():String
		{
			return _optType;
		}

		public function get context():Object
		{
			return _context;
		}
		
		public function set excuteNextCommand(value:Boolean):void
		{
			this._excuteNextCommand = value;
		}
		
		public function onExcute():void
		{
			if(_excuteNextCommand){
				onNext();
			}
		}
		
		public function onResult(result:*):void
		{
			
		}
		
		public function onNext():void
		{
			if(_nextCommand){
				_nextCommand.onExcute();
			}
		}
	}
}