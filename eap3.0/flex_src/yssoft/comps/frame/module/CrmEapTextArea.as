package yssoft.comps.frame.module
{
	import flash.events.FocusEvent;
	
	import mx.controls.TextArea;
	
	import yssoft.tools.CRMtool;
	
	public class CrmEapTextArea extends TextArea
	{
		//所有信息
		private var _singleType:Object = new Object();
		
		//计算公式
		public var subTableAssignment:Function;
		
		public function set singleType(value:Object):void
		{
			this._singleType=value;
			this.name=this._singleType.cobjectname;
			if(CRMtool.isStringNotNull(this._singleType.cnewdefault)&&this._singleType.curButtonStatus=="onNew")
			{
				this.text =CRMtool.defaultValue(this._singleType.cnewdefault);
			}
			else if(CRMtool.isStringNotNull(this._singleType.ceditdefault)&&this._singleType.curButtonStatus=="onEdit")
			{
				this.text =CRMtool.defaultValue(this._singleType.ceditdefault);
			}
			
			if(Boolean(this._singleType.bread))
			{
				this.enabled = false;
			}
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
		
		public function get singleType():Object
		{
			return this._singleType;
		}
		
		public var parentForm:Object;
		
		public function CrmEapTextArea()
		{
			parentForm = this.owner;
			super();
			this.styleName = "contentTextInput";
			this.addEventListener(FocusEvent.FOCUS_OUT,onFocus);
		}
		
		private function onFocus(event:FocusEvent):void
		{
			var length:int = CRMtool.getStrActualLen(this.text);
			if(int(this._singleType.ilength)<length)
			{
				CRMtool.tipAlert("输入超长，不能超过"+this._singleType.ilength+"字节",this);
				return;
			}
		}
	}
}