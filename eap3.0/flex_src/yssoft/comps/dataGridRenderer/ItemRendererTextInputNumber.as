package yssoft.comps.dataGridRenderer
{
	import mx.controls.TextInput;
	import mx.controls.listClasses.BaseListData;
	import mx.controls.listClasses.ListBase;
	
	public class ItemRendererTextInputNumber extends TextInput
	{
		private var txt_value:String;
		
		public function ItemRendererTextInputNumber () 
		{
			super();
			this.restrict = "0-9\.";
			this.percentWidth=100;
		}
		
		public function set iText(value:String):void{
			this.txt_value = value;
		}
		
		public function get iText():String{
			return this.txt_value;
		}
		
//		override public function set listData(value:BaseListData):void
//		{
//			super.listData  = value;
//			 = ((value.owner as ListBase).itemRendererToIndex(this)+1).toString();
//			selected = true;
//		}
		
	}
}