package yssoft.comps
{
	import mx.controls.LinkButton;
	import mx.controls.Text;
	
	import yssoft.views.MainView;
	
	public class CrmLinkButton extends LinkButton
	{
		//活动显示的文本
		private var _floatText:Text;
		private var _floatTxt:String;
		
		public function CrmLinkButton()
		{
			super();
		}
		
		public function set floatTxt(value:String):void{
			this._floatTxt=value;
			var using:int = int(value);
			
			if(_floatText){
				_floatText.text=value;
			}
			
  		   if(this.owner && this.id =="xxzxbt"){
			  //(this.owner as MainView).paly_stop_Glow(using);
		   }
		}
		public function get floatTxt():String{
			return this._floatTxt;
		}
		
		
		override protected function createChildren():void
		{
			super.createChildren();
			if(_floatText==null){
				_floatText=new Text();
				_floatText.text=_floatTxt;
				_floatText.toolTip=this.toolTip;
				this.addChild(_floatText);
			}
		}
		
		override protected function updateDisplayList(uw:Number,uh:Number):void
		{
			super.updateDisplayList(uw,uh);
			if(_floatText){
				_floatText.setActualSize(20,22);
				_floatText.x=uw;
				_floatText.y=uh-18;
			}
		}
		
	}
}