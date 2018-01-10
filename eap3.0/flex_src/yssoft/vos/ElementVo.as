package yssoft.vos
{
	import mx.collections.ArrayCollection;

	//存放Vbox里面元素的
	public class ElementVo
	{
		
		public function ElementVo(ccaption:String,subElement:ArrayCollection,isLine:Boolean=false)
		{
			this.ccaption=ccaption;
			this.subElement=subElement;
			this.isLine = isLine;
		}
		
		//字段标题
		public var ccaption:String;
		
		public var isLine:Boolean;
		
		//该标题里面的数据
		public var subElement:ArrayCollection;
		
	}
}