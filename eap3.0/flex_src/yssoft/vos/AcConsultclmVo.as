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
	[Bindable]
	[RemoteClass(alias="yssoft.vos.AcConsultclmVo")]
	public class AcConsultclmVo
	{
		public function AcConsultclmVo()
		{
		}
		
		public var iid:int;
		
		
		public var iconsult:int;
		
		
		public var cfield:String;
		
		
		public var ccaption:String;
		
		
		public var cnewcaption:String;
		
		
		public var ifieldtype:int;
		
		
		public var cformat:String;
		
		
		public var icolwidth:int;
		
		
		public var ialign:int;
		
		
		public var bshow:int;
		
		
		public var ino:int;
		
		
		public var bsearch:int;
	}
}