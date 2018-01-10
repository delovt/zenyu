package yssoft.vos
{
	[Bindable]
	[RemoteClass(alias="yssoft.vos.AcListsetVo")]
	public class ListsetVo
	{
		public function ListsetVo()
		{
		}
		
		//内码
		public var iid:int;
		
		//关联功能注册码
		public var ifuncregedit:int;
		
		public var ipage:int;
		
		public var cdataauth:String;
		
		public var csql1:String;
		
		public var csql2:String;
		
		public var ctable:String;//YJ Add 功能注册表名(管理中的表名)
		
		public var itype:int;
		
		public var idiagram:int;
		
		public var cxfield:String;
		
		public var cyfield:String;
		
		public var border:Boolean;
		
		public var bpage:Boolean;

        public var bmap:Boolean;

        public var cmapfield:String;
		
		public var ifixnum:int;
	}
}