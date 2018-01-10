/**
 * 规范表单查询
 * 
 * 作者:朱毛毛
 * 日期:2011年08月01日
 * 功能：规范 窗体的行为
 * 
 */
package yssoft.impls
{
	public interface ICRMWindow
	{
		//窗体初始化
		function onWindowInit():void;
		//窗体打开
		function onWindowOpen():void;
		//窗体关闭,完成窗体的清理工作
		function onWindowClose():void;
	}
}