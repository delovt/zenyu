/**
 * 作者：钟晶
 *
 * 日期：2011-8-2
 *
 * 功能：bean
 *
 * 修改记录：
 *
 * 修改人：钟晶
 *
 * 修改时间：2011-8-2
 */
package yssoft.vos
{
	[Bindable]
	[RemoteClass(alias="yssoft.vos.AsRoleVo")]
	public class RoleVo
	{
		
		public function RoleVo()
		{
		}
		
		// 内码
		public var iid:int;
		
		// 上级角色内码
		public var ipid:int;
		
		// 角色编码
		public var ccode:String;
		
		// 角色名称
		public var cname:String;
		
		// 是否启用
		public var buse:Boolean;
		
		// 备注
		public var cmemo:String;
		
		public var oldCcode:String;
	}
}
