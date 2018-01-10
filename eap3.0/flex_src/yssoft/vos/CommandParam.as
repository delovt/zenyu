package yssoft.vos
{
	import mx.core.Container;
	
	import yssoft.impls.ICommand;

	public class CommandParam
	{
		public function CommandParam()
		{
		}
		public var param:*;						  //传递的参数
		public var nextCommand:ICommand;			  //要执行的下一个命令
		public var excuteNextCommand:Boolean=false;  //是否立即执行下一条命令，true为立即执行，false 为 参看执行后的结构而定
		public var context:Object=null;             //环境容器变量
		public var optType:String="";               //操作类型
		public var cmdselfName:String="";           //自定义命令名称
	}
}