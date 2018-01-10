/**
 * 命令接口
 */
package yssoft.impls
{
	public interface ICommand
	{
		function onExcute():void;
		function onResult(param:*):void;
		function onNext():void;
	}
}