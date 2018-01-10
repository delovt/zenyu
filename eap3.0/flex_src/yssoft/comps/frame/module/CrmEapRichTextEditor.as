package yssoft.comps.frame.module
{
	import flash.events.Event;
	import flash.events.FocusEvent;
	
	import mx.events.FlexEvent;
	
	import yssoft.tools.CRMtool;
	import yssoft.comps.myRichTextEditor.MyRichTextEditor;
	
	[Event(name="initialization",type="flash.events.Event")]
	//public class CrmEapRichTextEditor extends CRMRichTextEditor
	public class CrmEapRichTextEditor extends MyRichTextEditor//lzx 新的富文本
	{
		//所有信息
		private var _singleType:Object = new Object();
		
		public function set singleType(value:Object):void
		{
			this._singleType=value;
			this.name=this._singleType.cobjectname;
			if(CRMtool.isStringNotNull(this._singleType.cnewdefault)&&this._singleType.curButtonStatus=="onNew")
			{
				this.htmlText =CRMtool.defaultValue(this._singleType.cnewdefault);
			}
			else if(CRMtool.isStringNotNull(this._singleType.ceditdefault)&&this._singleType.curButtonStatus=="onEdit")
			{
				this.htmlText =CRMtool.defaultValue(this._singleType.ceditdefault);
			}
			
			if(Boolean(this._singleType.bread))
			{
				this.enabled = false;
			}
		}
		public function get singleType():Object
		{
			return this._singleType;
		}
		public var parentForm:Object;
		
		public function CrmEapRichTextEditor()
		{
			super();
			parentForm = this.owner;
			this.addEventListener(FocusEvent.FOCUS_OUT,onFocus);
		}
		
		
		private function onFocus(event:FocusEvent):void
		{
			var length:int = CRMtool.getStrActualLen(this.htmlText);
			if(int(this._singleType.ilength)<length)
			{
				CRMtool.tipAlert("输入超长，不能超过"+this._singleType.ilength+"字节",this.richEditableText);
				//this.textArea.setFocus();
				return;
			}
		}
		
		override public function get htmlText():String
		{
			var ctype:String=this._singleType.ctype;
			
			if(CRMtool.isStringNull(super.htmlText)||"null"==super.htmlText)
			{
				switch(ctype)
				{
					case "datetime":
					{
						super.htmlText=null;
						break;
					}
					case "nvarchar":
					{
						//super.htmlText=null;
						break;
					}
					case "float":
					{
						var number:Number =0;
						super.htmlText=number.toFixed(int(this._singleType.idecimal));
						break;
					}
					case "int":
					{
						super.htmlText =null;
						break;
					}
				}
				return super.htmlText;
			}
			return super.htmlText;
		}
	}
}