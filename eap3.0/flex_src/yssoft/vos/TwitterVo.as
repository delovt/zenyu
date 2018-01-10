package yssoft.vos
{
	
	[Bindable]
	[RemoteClass(alias="yssoft.vos.twitter.TwitterVo")]
	public class TwitterVo
	{
		public function TwitterVo()
		{
		}
		
		public var iid:int;
		public var cname:String;
		public var cdetail:String;
		public var itype:int;
		public var bpopclassic:Boolean;
		public var istatus:int; 
		public var bhide:Boolean;
		public var imaker:int;
		public var dmaker:String;
		public var iread:int;
		public var ibrowse:int;
		public var iwriteback:int;
		public var dwriteback:String;
		public var irecommend:int;
		public var type:String;
		public var userId:int;
	}
}