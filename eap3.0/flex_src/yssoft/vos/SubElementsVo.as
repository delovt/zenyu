package yssoft.vos
{
	import flash.sampler.NewObjectSample;
	
	import mx.collections.ArrayCollection;

	public class SubElementsVo
	{
		public function SubElementsVo(ifieldtype:int,cfield:String,defaultsvalue:String="",isOneCol:Boolean=false,isLine:Boolean=false,
									  isChange:Boolean=false,dataIid:int=0,eleLable:String="",eleVaue:String="",
									  comBoxArr:ArrayCollection=null,conditionObj:Object=null,isNumber:Boolean=false,verticalAlign:String="",horizontalAlign:String="",
									  iseditable:Boolean = true,dgArr:ArrayCollection=null,eventArr:ArrayCollection=null,verificationArr:ArrayCollection=null
									  ,initArr:ArrayCollection=null)
		{
			this.ifieldtype =ifieldtype;
			this.cfield = cfield;
			this.defaultsvalue=defaultsvalue;
			this.dataIid = dataIid;
			this.eleLable= eleLable;
			this.eleVaue=eleVaue;
			this.comBoxArr=comBoxArr;
			this.dgArr = dgArr;
			this.isNumber=isNumber;
            this.isOneCol=isOneCol;
			this.isLine =isLine;
			this.isChange = isChange;
			this.verticalAlign= verticalAlign;
			this.horizontalAlign =horizontalAlign;
			this.iseditable = iseditable;
			this.conditionObj = conditionObj;
			this.eventArr = eventArr;
			this.verificationArr=verificationArr;
			this.initArr=initArr;
		}
		
		
		//类型 1、CRMReferTextInput,2,TextInput,3,CRMDateField,4,RadioButton,5,ComboBox,6,checkBox,7textArr,8,button,9:DataGrid
		public var ifieldtype:int;
		
		//字段名
		public var cfield:String;
		
		//数据字典编码
		public var dataIid:int;
		
		//默认值
		public var defaultsvalue:String;
		
		//RadioButton，checkBox 子标题
		public var eleLable:String;
		
		//RadioButton值
		public var eleVaue:String;
		
		//ComboBox里面的数据源
		public var comBoxArr:ArrayCollection;
		
		//DataGrid数据集
		public var dgArr:ArrayCollection;
		
		//是否需要自动生成内码
		public var isNumber:Boolean;
		
		//是否一列
		public var isOneCol:Boolean;
		//是否换行
		public var isLine:Boolean;
		
		//是否执行change操作
		public var isChange:Boolean;
		
		//垂直对齐容器
		public var verticalAlign:String;
		
		//水平对齐容器
		public var horizontalAlign:String;
		
		//是否灰化
		public var iseditable:Boolean;
		
		//条件
		public var conditionObj:Object;
		
		//事件
		public var eventArr:ArrayCollection;
		
		//验证方法
		public var verificationArr:ArrayCollection;
		
		public var initArr:ArrayCollection;
	}
}