/**
 * 作者：朱毛毛
 * 日期：2011-12-30
 * 描述：单据按钮 相关事件
 */
package yssoft.evts
{
	import flash.events.Event;
	
	public class FWREvent extends Event
	{
		public static const FWRTYPE:String="onFwrEvent";
		public var opt:String="";			//操作类型
		public var label:String="";		//操作类型标题
		public var targetType:String;		//事件触发者的类型
		public var pdata:Object=null;		//携带的数据
		public function FWREvent(type:String,opt:String,label:String,targetType:String,pdata=null)
		{
			super(type,false,true);
			this.opt=opt;
			this.label=label;
			this.targetType=targetType;
			this.pdata=pdata;
		}
		
		override public function clone():Event
		{
			return new FWREvent(type,opt,label,targetType,pdata);
		}
		
		
	}
}