package yssoft.vos
{
	[Bindable]
	[RemoteClass(alias="yssoft.vos.AcListclmVo")]
	public class ListclmVo
	{
		public function ListclmVo()
		{
		}
		
		
		public var iid:int;
		
		public var  ilist:int;
		
		public var cfield:String;
		
		public var  ccaption:String;
		
		public var cnewcaption:String;
		
		public var  ifieldtype:int;
		
		public var cformat:String;
		
		public var  icolwidth:int;
		
		public var ialign:int;
		
		public var bshow:Boolean;
		
		public var ino:int;
		
		public var bsearch:Boolean;
		
		public var iperson:int;
		
		public var bsum:Boolean;
		
		public var cshfield:String;
		
		public var blinkfun:Boolean;
		
		public var bgroup:Boolean;//YJ Add 是否分类汇总
		
		public var bfilter:Boolean;
		
		public var bcrossrow:Boolean;//XZQWJ 增加交叉行
		
		public var bcrosscol:Boolean;//XZQWJ 增加交叉列
		
		public var btotalfield:Boolean;//XZQWJ 增加统计字段
		
		public var bamount:Boolean;//XZQWJ 增加汇总字段
		
		public var browtotal:Boolean;//XZQWJ 增加行汇总字段
		
		public var bcoltotal:Boolean;//XZQWJ 增加列汇总字段 
		
	}
}