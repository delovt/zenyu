package yssoft.comps
{
	import mx.containers.DividedBox;
	import mx.containers.dividedBoxClasses.BoxDivider;
	import mx.controls.Alert;
	
	public class CRMHDividedBox extends DividedBox
	{
		public function CRMHDividedBox()
		{
			super();
		}
		override protected function updateDisplayList(w:Number, h:Number):void 
		{ 
			
			super.updateDisplayList(w,h);
			
			graphics.clear();
			var n:int = numDividers;
			//Alert.show("["+n+"]");
			graphics.beginFill(0xFF0000, 1.0);
			//for (var i:int = 0; i < n; i++) 
			//{
				//var box:BoxDivider = getDividerAt(0); 
				//graphics.drawRect(box.x, box.y, box.width, box.height);
				//Alert.show("x["+box.x+"],y["+box.y+"],w["+box.width+"],h["+box.height+"]");
			//}
			graphics.drawRect(0, 0, w, h);
			graphics.endFill();
			
		}
	}
}