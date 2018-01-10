/**
 * 规范表单查询
 * 
 * 作者:钟晶
 * 日期:2011年08月01日
 * 功能：规范增删改查操作
 * 
 */
package yssoft.impls
{
	import flash.events.Event;

	public interface IOperating
	{
		//新增
		function onSave(selectedItem:Object,getIpid:Function):void;
		
		//删除
		function onDelete(selectedItem:Object):void;
	
		//修改
		function onEdit():void;
		
		//查询
		function onGet():void;
		
		//放弃
		function onGiveUp(selectedItem:Object,treeCompsXml:XML):void;
		
		//测试
		function onTest():void;
		
		function onNew():void;
		
	}
}