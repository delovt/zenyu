/**
 * 表单对应的协同操作
 */
package yssoft.impls
{
	public interface ICoopHandle
	{
		//提交
		function onSubmit();
		//撤销
		function onRevocation();
		//打印
		function onPrint();
	}
}