package yssoft.vos
{
	import mx.collections.ArrayCollection;

	//封装组件
	public class CustomVo
	{
		public function CustomVo()
		{
		}
		
		//字段
		public var cfield:String;
		
		//字段标题
		public var ccaption:String;
		
		//组件类型 0代表textInput，1代表RadioButton,2代表参照组件,3代表日期控件,4代表checkBox，5代表下拉框
		public var customType:int;
		
		//是否必输
		public var bunnull:Boolean;
		
		//默认绑定
		public var defaults:String;
		
		//下拉框(RadioButton) 绑定数据集
		public var dataSet:ArrayCollection;
	}
}