/**
 * 作者：刘磊
 *
 * 日期：2011-8-12
 *
 * 功能：bean
 *
 * 修改记录：
 *
 * 修改人：刘磊
 *
 * 修改时间：2011-8-12
 */
package yssoft.vos
{
	/**********************引用Vo**********************/
	[Bindable]
	[RemoteClass(alias="yssoft.vos.AcConsultsetVo")]
	/**********************引用Vo**********************/
	public class AcConsultsetVo
	{
		public function AcConsultsetVo()
		{
		}
		
		public var iid:int;
		
		
		public var ipid:int;
		
		
		public var ccode:String;
		
		public var oldCcode:String;		
		
		public var cname:String;
		
		
		public var itype:String;
		
		
		public var ipage:int;
		
		
		public var cdataauth:String;
		
		
		public var ctreesql:String;
		
		
		public var cgridsql:String;
		
		
		public var cconnsql:String;
		
		
		public var ifuncregedit:String;
		
		
		public var iheigh:int;
		
		
		public var iwidth:int;
		
		public var bdataauth:Boolean;
		
		public var ballowmulti:Boolean;
		
		public var cordersql:String;
		
		public var ifixnum:int;
	}
}