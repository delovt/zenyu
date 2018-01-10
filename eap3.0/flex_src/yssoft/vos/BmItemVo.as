package yssoft.vos{
	
	[Bindable]
	[RemoteClass(alias="yssoft.vos.BmItemVo")]
	public class BmItemVo {
		
		public function  BmItemVo(){}
		
		public var iid:int;
		public var ipid:int;
		public var ccode:String;
		public var cname:String;
		public var cmemo:String;
		public var bdetail:int;
		
		public var oldCode:String;
	}
}