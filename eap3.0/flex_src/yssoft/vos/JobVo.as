package yssoft.vos
{
	import mx.messaging.AbstractConsumer;

	[Bindable]
	[RemoteClass(alias="yssoft.vos.HrJobVo")]
	
	public class JobVo
	{
		public function JobVo()
		{
		}
		//内码
		private var _iid:int;
		//部门内码
		private var _idepartment:int;
		//编码
		private var _ccode:String;
		//名称
		private var _cname:String;
		//职责
		private var _cwork:String;
	    //编制人数
		private var _iperson:int;
		
		//部门名称
		private var _departmentName:String;
		
		//在编人数
		private var _irealperson:int;
		
		public function set iid(value:int):void
		{
			this._iid = value;
		}
		
		public function get iid():int
		{
			return this._iid;
		}
		
		public function set idepartment(value:int):void
		{
			this._idepartment = value;	
		}
		
		public function get idepartment():int
		{
			return _idepartment;
		}
		
		public function set ccode(value:String):void
		{
			this._ccode = value;
		}
		
		public function get ccode():String
		{
			return _ccode;
		}
		
		public function set cname(value:String):void
		{
			 this._cname=value;
		}
		
		public function get cname():String
		{
			return _cname;
		}
		
		public function set cwork(value:String):void
		{
			_cwork = value;
		}
		
		public function get cwork():String
		{
			return _cwork;
		}
		
		public function set iperson(value:int):void
		{
			this._iperson = value;	
		}
		
		public function get iperson():int
		{
			return this._iperson;
		}
		
		public function set departmentName(value:String):void
		{
			_departmentName = value;		
		}
		
		public function get departmentName():String
		{
			return this._departmentName;
		}
		
		
		public function set irealperson(value:int):void
		{
			this._irealperson = value;	
		}
		
		public function get irealperson():int
		{
			return this._irealperson;
		}
	}
}