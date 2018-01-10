/**
 * 模块名称：BmTargetVO
 * 模块说明：
 * 
 * 创建人：lzx
 * 创建日期：2012-10-09
 * 修改人： 
 * 修改日期：
 *	
 */

package yssoft.vos
{

	[Bindable]
	[RemoteClass(alias="yssoft.vos.BmTargetVO")]//对应的java类，不需要数据转换了
	public class BmTargetVO
	{
		public function BmTargetVO(){}
		
		public var iid:int;			//内码
		
		public var ipid:int;       //上级预算内码
		
		public var iifuncregedit:int;	//注册表内码
		
		public var cname:String;		//模板名称
		
		public var ccode:String;		//模板编码
		
		public var oldCcode:String;     //老菜单编码
		
		public var cvaluefield:String;	//预算指标取值字段
		
		public var ivaluetype:int;		//预算指标取值类型
		
		public var csqlcd:String;			//预算维度条件
		
		public var cdepartmentfield:String;		//预算部门组织字段
		
		public var cpersonfield:String;		//预算人员组织字段
		
		public var cdatefield:String;		//预算期间取值字段
		
		public var cmemo:String;		//备注
		
		public var imaker:int;		//制单人
		
		public var dmaker:Date;		//制单时间
		
		public var imodify:int;		//修改人
		
		public var dmodify:Date;		//修改时间
		
		public var cvaluetable:String;   //取值字段
	}
}