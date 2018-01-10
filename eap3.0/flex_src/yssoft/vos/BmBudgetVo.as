package yssoft.vos{

[Bindable]
[RemoteClass=(alias="yssoft.vos.BmBudgetVo")]
public class BmBudgetVo {
	
	public function BmBudgetVo(){
	}
	
	public var  iid:int;
	public var  ccode:String;
	public var  cname:String;
	public var  cversion:String;
	public var  iyear:int;
	public var  iorganization:int ;
	public var  iitem:int;
	public var  bdetail:Boolean;
	public var  fsum:Number;
	public var  cproportion:String;
	public var  cproportions:String;
	public var  cmemo:String;
	public var  istatus:int;
}
}