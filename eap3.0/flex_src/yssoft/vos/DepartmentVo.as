/**
 *
 * @author：zhong_jing
 * 日期：2011-8-12
 * 功能：部门
 * 修改记录：
 *
 */
package yssoft.vos
{
	[Bindable]
	[RemoteClass(alias="yssoft.vos.HRDepartmentVo")]
	
	public class DepartmentVo
	{
		public function DepartmentVo()
		{
		}
		
		//内码
		public var iid:int;
		//上级内码
		public var ipid:int;
		//编码
		public var ccode:String;
		//名称
		public var cname:String;
		//部门主管
		public var ihead:int;
		//分管主管
		public var icharge:int;
		//编制人数
		public var iperson:int;
		//在编人数
		public var irealperson:int;
		//新的编码
		public var oldCcode:String;
		
		public var ilead:int;
		
		public var cabbreviation:String;

	}
}