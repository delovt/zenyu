package yssoft.comps
{
	import flash.display.Graphics;
	
	import mx.core.UIComponent;
	
	
	public class CrmDotLine extends UIComponent
	{
		
		private var _dotLineColor:uint=0xcccccc; // 虚线 颜色
		private var _dotLineWH:int=1; // 虚线 宽度
		private var _dotLineGap:int=3;	  // 虚线之间的间隔
		private var _direction:String="h";
		
		public function set direction(value:String):void{
			this._direction=value;
		}
		public function get direction():String{
			return this._direction;
		}
		
		public function set dotLineColor(value:uint):void{
			this._dotLineColor=value;
		}
		public function get dotLineColor():uint{
			return this._dotLineColor;
		}
		
		public function set dotLineWH(value:int):void{
			this._dotLineWH=value;
		}
		public function get dotLineWidth():int{
			return this._dotLineWH;
		}
		
		public function set dotLineGap(value:int):void{
			this._dotLineGap=value;
		}
		public function get dotLineGap():int{
			return this._dotLineGap;
		}
		
		public function CrmDotLine()
		{
			super();
		}
		
		override protected function updateDisplayList(uw:Number,uh:Number):void{
			super.updateDisplayList(uw,uh);
			var g:Graphics = graphics;
			var p:Number = 0; 
			
			g.clear();
			g.lineStyle(1,_dotLineColor); 
			
			if(_direction == "h"){
				while(p < uw) 
				{ 
					g.moveTo(p,uh-1); 
					g.lineTo(p+_dotLineWH,height-1); 
					p += _dotLineWH+_dotLineGap; 
				} 
			}else{
				while(p < uh){
					g.moveTo(uw-1,p);
					g.lineTo(uw-1,p+_dotLineWH);
					p += _dotLineWH+_dotLineGap; 
				}
			}
			
		}
	}
}