package yssoft.evts
{
	import flash.events.Event;
	
	//分页控件加载完数据调用
	public class GetPageComplete extends Event
	{
		public var ifuncregedit:int;
		public var pageNum:int;
		public function GetPageComplete(type:String,ifuncregedit:int,pageNum:int)
		{
			super(type,false,false);
			this.ifuncregedit=ifuncregedit;
			this.pageNum=pageNum;
		}
	}
}