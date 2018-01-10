/**
 * 在DataGrid中使用显示CheckBox列的组件，该组件会保存用户选中的数据当前行的引用，
 * 该组件要求在数据源中存在属性dgSelected属性，此属性用来记录当前行是否被选中
 * 
 * */
package yssoft.comps.dataGridForCheckBox
{
    import mx.controls.dataGridClasses.DataGridColumn;
    
    
    public class CheckBoxColumn extends DataGridColumn{
    	
            public var cloumnSelected:Boolean=false;//保存该列是否全选的属性（用户先点击全选后在手动的取消几行数据的选中状态时，这里的状态不会改变）          
            
            public var selectItems:Array = new Array();//用户保存用户选中的数据

			/*public function cleanSelectItems():void{
				selectItems= new Array();
			}*/

            public function CheckBoxColumn(columnName:String=null){
                    super(columnName); 
            }
            
    }
}