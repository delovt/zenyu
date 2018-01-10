package yssoft.scripts
{
	import flash.display.Sprite;
	
	import mx.controls.AdvancedDataGrid;
	
	public class MyAdvancedDataGrid extends AdvancedDataGrid
	{
		private var _rowColor:Function; 

		public function MyAdvancedDataGrid()
		{
			super();
		}
		
		/**用于设置每行的颜色  
		 * uint表示返回的颜色值  
		 * @param item 对应每列的数据  
		 * @param color 对应原始的颜色值  
		 * @param dataIndex 数据索引  
		 * @return uint 表示返回的颜色值  
		 *  
		 */        
		public function set rowColor(f:Function):void{ 
			this._rowColor = f; 
		} 

		override protected function drawRowBackground(s:Sprite,rowIndex:int,y:Number, height:Number, color:uint, dataIndex:int):void  
		{   
			if( this._rowColor != null )   
			{   
				if( dataIndex < this.dataProvider.length )   
				{   
					color = this._rowColor.call(this, listItems[rowIndex][0].data,color,dataIndex);   
				}   
			}              
			super.drawRowBackground(s, rowIndex, y, height, color, dataIndex);   
		}  
	}
}