/**
 *
 * @author：zhong_jing
 * 日期：2011-8-7
 * 功能：角色和职员的关联关系
 * 修改记录：
 *
 */
package yssoft.vos
{
	[Bindable]
	[RemoteClass(alias="yssoft.vos.AsRoleUserVo")]
	public class RoleUseVo
	{
		public function RoleUseVo()
		{
			super();
		}
		
		// 自增值
		public var iid:int;
		
		// 编码
		public var ccode:String;
		
		// 姓名
		public var personName:String;
		
		// 部门名称
		public var departmentName:String;
		
		// 主岗名称
		public var jobName:String;
		
		// 职务
		public var irealperson:String;
	}
}
