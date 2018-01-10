package yssoft.vos
{
	[Bindable]
	[RemoteClass(alias="yssoft.vos.HrCorporationVo")]
	public class HrCorporation
	{
		public function HrCorporation()
		{
		}
		
		public var iid:int;
		public var ipid:int;
		public var ccode:String;
		public var cname:String;
		public var cfname;String
		public var caddress:String;
		public var czipcode:String;
		public var ctel:String;
		public var ccontactpersopn:String;
		public var istate:int;
		public var cmemo:String;
		public var imaker:int;
		public var dmaker:Date;
		public var imodify:int;
		public var dmodidy:Date;
		
	}
}