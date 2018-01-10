/**
 * 单据操作相关事件
 */
package yssoft.frameui.event
{
	import flash.events.Event;
	
	public class FormEvent extends Event
	{
		private var _optType:String=""; 	// 单据的操作类型
		private var _msg:String="";  		// 提示信息
		private var _items:Object=null; 		// 要专递的数据
		
		public static const FORM_OPT_SUCCES:String="form_opt_success"; 	// 操作执行成功
		public static const FORM_OPT_EXCUTE:String="form_opt_excute";  		// 操作进行中
		public static const FORM_OPT_FAILURE:String="form_opt_failure"; 	// 操作执行失败
		
		public function FormEvent(type:String,optType:String,items:Object=null,msg:String="")
		{
			super(type,false,true);
			this._optType=optType;
			this._items=items;
			this._msg=msg;
		}
		
		public function get items():Object
		{
			return _items;
		}

		public function get msg():String
		{
			return _msg;
		}
		
		public function get optType():String
		{
			return _optType;
		}

		override public function clone():Event
		{
			return new FormEvent(type,_optType);
		}
		
	}
}