/**
 * 单据的相关操作
 */
package yssoft.impls
{
	public interface IFormHandle
	{
		//新增
		function onAdd();
		//修改
		function onEdit();
		//删除
		function onDelete();
		//保存
		function onSave();
		//放弃
		function onGiveup();
	}
}