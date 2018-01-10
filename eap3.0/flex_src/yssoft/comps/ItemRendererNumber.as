package yssoft.comps
{
	import mx.controls.Label;
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.ListBase;
	
	public class ItemRendererNumber extends Label
	{
		public function ItemRendererNumber () 
		{
			super();
		}
		
		override public function set listData(value:BaseListData):void
		{
			super.listData  = value;
			text = ((value.owner as ListBase).itemRendererToIndex(this)+1).toString();
		}
		
	}
}