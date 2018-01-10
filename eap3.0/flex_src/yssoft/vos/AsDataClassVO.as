/**
 * 模块名称：AsDataClassVO
 * 模块说明：Flex中对应的档案分类实体类
 * 创建人：	YJ
 * 创建日期：20110822
 * 修改人：
 * 修改日期：
 *
 */

package yssoft.vos
{
	[Bindable]
	[RemoteClass(alias="yssoft.vos.AsDataClassVO")]//对应的java类，不需要数据转换了
	
	public class AsDataClassVO
	{
		public function AsDataClassVO(){}
		
		public var iid:int;			//主键
		
		public var ipid:int;			//上级内码
		
		public var ccode:String;		//编码
		
		public var cname:String;		//名称
		
		public var bsystem:int;		//是否系统档案
		
		public var coperauth:String;	//操作权限控制
		
		public var cmemo:String;		//备注
		
		public var bbuse:int			//是否启用
		
		public var oldCcode:String;	//旧编码
	}
}