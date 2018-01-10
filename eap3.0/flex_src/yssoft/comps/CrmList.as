package yssoft.comps
{
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import mx.controls.List;
	import mx.controls.listClasses.IListItemRenderer;
	
	public class CrmList extends List
	{
		private var _dotLineColor:uint=0xCCCCCC; // 虚线 颜色
		
		private var _dotLineWidth:int=1; // 虚线 宽度
		
		//private var _dotLineHeight:int=1; // 虚线 宽度
		
		private var _dotLineGap:int=3;	  // 虚线之间的间隔
		
		public function set dotLineColor(value:uint):void{
			this._dotLineColor=value;
		}
		
		public function get dotLineColor():uint{
			return this._dotLineColor;
		}
		
		public function set dotLineWidth(value:int):void{
			this._dotLineWidth=value;
		}
		public function get dotLineWidth():int{
			return this._dotLineWidth;
		}
		
	/*	public function set dotLineHeight(value:int):void{
			this._dotLineWidth=value;
		}
		public function get dotLineHeight():int{
			return this._dotLineHeight;
		}*/
		
		public function set dotLineGap(value:int):void{
			this._dotLineGap=value;
		}
		public function get dotLineGap():int{
			return this._dotLineGap;
		}
		
		
		public function CrmList()
		{
			super();
			//alternatingItemColors="0xFFFFFF"
			this.setStyle("alternatingItemColors",[0xFFFFFF,0xFFFFFF]);
			this.setStyle("rollOverColor",0xc0e0f8);
			this.setStyle("selectionColor",0xfce9a1);
		}
		
		override protected function drawRowBackground(s:Sprite,rowIndex:int,y:Number,height:Number,color:uint,dataIndex:int):void
		{ 
			super.drawRowBackground(s,rowIndex,y,height,color,dataIndex); 
			/*var bg:Shape = Shape(s.getChildAt(rowIndex)); 
			//此外为了显示虚线~使用一个while来循环来模拟虚线效果~ 
			var p:Number = 0; 
			bg.graphics.lineStyle(1,_dotLineColor); 
			while(p < listContent.width) 
			{ 
				bg.graphics.moveTo(p,height-1); 
				bg.graphics.lineTo(p+_dotLineWidth,height-1); 
				p += _dotLineWidth+_dotLineGap; 
			} */
		}
	}
}