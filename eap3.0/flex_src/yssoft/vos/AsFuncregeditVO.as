/**
 * 模块名称：FuncregeditVO
 * 模块说明：
 * 
 * 创建人：YJ
 * 创建日期：20110811
 * 修改人： 
 * 修改日期：
 *	
 */

package yssoft.vos
{

	[Bindable]
	[RemoteClass(alias="yssoft.vos.AsFuncregeditVO")]//对应的java类，不需要数据转换了
	public class AsFuncregeditVO
	{
		public function AsFuncregeditVO()
		{
		}
		public var iid:int;			 //内码		
		
		public var ipid:int;			//父级内码		
		
		public var ccode:String;       //编码		
		
		public var cname:String;		//功能模块名称		
		
		public var cprogram:String;	//程序路径	
		
		public var ifuncregedit:int;		//列表式程序对应的列表参数ID
		
		public var ctable:String;		//程序对应主数据表		
		
		public var brepeat:int			//是否允许多次创建	
		
		public var iworkflow:int;		//默认工作流ID		
		
		public var iform:int;			//默认UI界面ID
		
		private var coperauth:String;	//浏览操作权限控制		
		
		private var cdataauth:String;	//浏览数据权限控制
		
		public var boperauth:int;	//是否参与操作权限管理		
		
		public var bdataauth:int;	//是否参与数据权限管理
		
		public var bdataauth1:int;	//是否参与组织权限管理
		
		public var bdataauth2:int;	//是否参与客户权限管理
		
		public var brelation:int;  //是否参与相关对象管理
		
		public var bdictionary:int;	//是否参与数据字典管理
		
		public var bnumber:int;		//是否参与单据编码管理
		
		public var bquery:int;			//是否参与查询条件定制
		
		public var blist:int;			//是否参与列表定制
		
		public var oldCcode:String;	//旧编码
		
		public var bworkflow:Boolean; //是否参与工作流程管理
		
		public var cparameter:String; //程序参数
		
		public var bprint:int;		  //是否参与打印设置管理
		
		public var iimage:int;	      //功能图标
		
		public var bvouchform:int;	  //是否参与表单界面配置
		
		public var buse:int;		  //生效\失效
		
		public var bbind:int;		  //是否参与单据关系定制
		
		public var ccaptionfield:String;
		
		public var bworkflowmodify:int;        //发起工作流后是否允许修改
	}
}