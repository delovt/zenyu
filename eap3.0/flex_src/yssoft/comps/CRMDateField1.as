package yssoft.comps
{
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import mx.controls.DateField;
	
	import yssoft.tools.CRMtool;
	
	[Event(name="enter",type="flash.events.Event")]
	
	public class CRMDateField1 extends DateField
	{
		public function CRMDateField()
		{
			super();
			this.yearNavigationEnabled=true;
			this.dayNames=['日','一','二','三','四','五','六'];
			this.monthNames=['一月','二月','三月','四月','五月','六月','七月','八月','九月','十月','十一月','十二月'];
			this.formatString="YYYY-MM-DD";
			this.addEventListener(KeyboardEvent.KEY_DOWN,onKeyEnterHandler);
		}
		
		private function onKeyEnterHandler(event:KeyboardEvent):void{
			if(event.keyCode==Keyboard.ENTER){
				this.dispatchEvent(new Event("enter"));
			}
		}
		
		private var _isShowToday:Boolean=false;
		public function set isShowToday(value:Boolean):void{
			this._isShowToday=value;
		}
		public function get isShowToday():Boolean{
			return this._isShowToday;
		}
		
		//是否启用样式
		private var _isStyle:Boolean=true;
		
		public function set isStyle(value:Boolean):void{
			this._isStyle=value;
		}
		public function get isStyle():Boolean{
			return this._isStyle;
		}
		
		override protected function updateDisplayList(uw:Number,uh:Number):void{
			super.updateDisplayList(uw,uh);
			if(_isStyle){
				this.textInput.styleName="contentTextInput";
			}
			if(_isShowToday){
				this.text=CRMtool.getFormatDateString(this.formatString,new Date);
				this.selectedDate=new Date();
			}
		}
	}
}