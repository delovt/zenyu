package yssoft.comps.frame.module
{
	import mx.controls.LinkButton;
	
	public class CrmEapLinkButton extends LinkButton
	{
		private var _subitem:XML;
		
		
		public function set subitem(value:XML):void
		{
			this._subitem = value;
		}
		
		public function get subitem():XML
		{
			return this._subitem;
		}
		
		public function CrmEapLinkButton()
		{
			super();
		}
	}
}