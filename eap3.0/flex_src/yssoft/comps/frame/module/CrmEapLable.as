package yssoft.comps.frame.module
{
	import mx.containers.VBox;
	
	import spark.components.Label;
	
	import yssoft.tools.CRMtool;
	
	public class CrmEapLable extends Label
	{
		//所有信息
		private var _singleType:Object = new Object();
		
		public var parentForm:Object;
		
		public function set singleType(value:Object):void
		{
			this._singleType=value;
			
			parentForm = this.owner;
			this.name=this._singleType.cobjectname;
			if(CRMtool.isStringNotNull(this._singleType.cnewdefault)&&this._singleType.curButtonStatus=="new")
			{
				this.text =CRMtool.defaultValue(this._singleType.cnewdefault);
			}
			else if(CRMtool.isStringNotNull(this._singleType.ceditdefault)&&this._singleType.curButtonStatus=="edit")
			{
				this.text =CRMtool.defaultValue(this._singleType.ceditdefault);
			}
		}
		
		public function get singleType():Object
		{
			return this._singleType;
		}
		
		public function CrmEapLable()
		{
			super();
		}
		
		override public function get text():String
		{
			var ctype:String=this._singleType.ctype;
			
			if(CRMtool.isStringNull(super.text)||"null"==super.text)
			{
				switch(ctype)
				{
					case "datetime":
					{
						super.text=null;
						break;
					}
					case "nvarchar":
					{
						super.text=null;
						break;
					}
					case "float":
					{
						var number:Number =0;
						super.text=number.toFixed(int(this._singleType.idecimal));
						break;
					}
					case "int":
					{
						super.text =null;
						break;
					}
				}
				return super.text;
			}
			return super.text;
		}
	}
}