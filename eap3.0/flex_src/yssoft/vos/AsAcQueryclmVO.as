/**
 * 模块名称：AsAcQueryclmVO
 * 模块说明：查询条件定制VO
 * 
 * 创建人：YJ
 * 创建日期：20110816
 * 修改人： 
 * 修改日期：
 *	
 * 		AC_queryclm		查询条件配置表
 * 			
		字段				字段名			字段类型		字段长度		说明
		iid				内码				int		
		ifuncregedit	注册程序内码		int		
		cfield			字段名			nvarchar	30	
		ccaption		字段标题			nvarchar	40	
		ifieldtype		字段类型			int						0数字、1文本、2日期、3布尔
		iconsult		参照窗体			int		
		cconsultbkfld	参照返回存入字段	nvarchar	30	
		cconsultswfld	参照返回显示字段	nvarchar	30	
		iqryno			查询优先序号		int		
		bcommon			是否常用条件		bit		
		icmtype			常用条件类型		int						0单项、1区间、2多选、3是否BIT型
		isortno			排序优先序号		int		
		isttype			排序类型			int						0无序、1升级、2降序

 */	

package yssoft.vos
{
	
	[Bindable]
	[RemoteClass(alias="yssoft.vos.AsACqueryclmVO")]//对应的java类，不需要数据转换了
	public class AsAcQueryclmVO
	{
		public function AsAcQueryclmVO()
		{}
		
		public var iid:int;				 //内码		
		
		public var ifuncregedit:int;		//注册程序内码		
		
		public var cfield:String;       	//字段名	
		
		public var ccaption:String;		//字段标题		
		
		public var ifieldtype:int;			//字段类型		
		
		public var iconsult:int;			//参照窗体		
		
		public var cconsultbkfld:String;	//参照返回存入字段
		
		public var cconsultswfld:String;	//参照返回显示字段	
		
		public var iqryno:int;				//查询优先序号	
		
		public var bcommon:int;			//是否常用条件	
		
		public var icmtype:String;			//常用条件类型
		
		public var isortno:int;			//排序优先序号
		
		public var isttype:int;			//排序类型
	}
	
	
}