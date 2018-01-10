/**
 * 模块名称：AcPrintSetVO
 * 模块说明：
 * 
 * 创建人：YJ
 * 创建日期：2011-10-19
 * 修改人： 
 * 修改日期：
 *	
 */

package yssoft.vos
{

	[Bindable]
	[RemoteClass(alias="yssoft.vos.AcPrintSetVO")]//对应的java类，不需要数据转换了
	public class AcPrintSetVO
	{
		public function AcPrintSetVO(){}
		
		public var iid:int;			//内码
		
		public var ifuncregedit:int;	//注册表内码
		
		public var cname:String;		//模板名称
		
		public var itype:int;		//模板类型
		
		public var ctemplate:String;	//打印模板
		
		public var ccondit:String;		//传入参数
		
		public var buse:int;			//是否启用
		
		public var bdefault:int;		//默认值
		
		public var cmemo:String;		//备注
	}
}