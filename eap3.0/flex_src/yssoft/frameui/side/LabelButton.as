package yssoft.frameui.side
{
	
	import spark.components.Label;

;
	
	public class LabelButton extends Label
	{
		private var _paramData:Object = {};
		
		public function get paramData():Object
		{
			return _paramData;
		}
		
		public function set paramData(value:Object):void
		{
			_paramData = value;
		}
		public function LabelButton()
		{
			super();
		}
		
		
	
		
	}
}