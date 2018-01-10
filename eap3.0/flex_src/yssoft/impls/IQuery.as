/**
 * 规范表单查询
 * 
 * 作者:朱毛毛
 * 日期:2011年08月01日
 * 功能：规范表单查询
 * 
 */
package yssoft.impls
{
	import mx.rpc.events.ResultEvent;
	
	public interface IQuery
	{
		//获取查询参数
		function getQueryParam():Object;
		//重置查询参数
		function resetQueryParam():void;
		//检查查询参数
		function checkQueryParam():Boolean;
		//执行查询
		function execQuery():void;
		//处理查询的返回结果
		function queryCallBack(e:ResultEvent):void;
	}
}