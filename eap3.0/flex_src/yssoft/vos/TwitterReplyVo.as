package yssoft.vos
{
	
	[Bindable]
	[RemoteClass(alias="yssoft.vos.twitter.TwitterReplyVo")]
	public class TwitterReplyVo
	{
		public function TwitterReplyVo()
		{
		}
		
		public var iid:int;
		public var itwitter:int;
		public var cdetail:String;
		public var bhide:Boolean;
		public var imaker:int;
		public var dmaker:String;
		public var userId:int;
	}
}