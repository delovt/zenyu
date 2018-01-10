package yssoft.impls
{
	public interface IFWROperate
	{
		//表单
		function FormOperate(param:Object):void; 
		//协同
		function CoopOperate(param:Object):void;
		//打印模板
		function TemplateOperate(param:Object):void;
		//单据浏览
		function BrowseOperate(param:Object):void;
		//更多操作
		function MoreOperate(param:Object):void;
	}
}