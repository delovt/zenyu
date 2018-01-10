package yssoft.comps
{
	import spark.components.ComboBox;
	
	public class CRMComboBox extends ComboBox
	{
		public function CRMComboBox()
		{
			super();
		}
		
		private var _editable:Boolean=true;
		
		public function set editable(value:Boolean):void
		{
			this._editable=value;
		}
		
		public function get editable():Boolean{
			return this._editable;
		}
		
		override protected function commitProperties():void
		{
			this.textInput.editable=_editable;
		}
	}
}