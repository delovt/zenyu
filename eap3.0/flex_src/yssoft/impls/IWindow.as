package yssoft.impls
{
	public interface IWindow
	{
		//窗体初始化
		function onWindowInit():void;
		//窗体打开，重新打开
		function onWindowOpen():void;
		//窗体关闭,完成窗体的清理工作
		function onWindowClose():void;
		//窗体数据刷新
		function onWindowClear():void;
	}
}