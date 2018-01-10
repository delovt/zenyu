package yssoft.vos{

[Bindable]
[RemoteClass=(alias="yssoft.vos.BmBudgetsVo")]
public class BmBudgetsVo {
	
	public function BmBudgetsVo(){
	}
	public var iid:int;
	public var ibudget:int;		//预算主表内码
	public var imonth:int;		//预算月份
	public var icorp:int ;			//预算公司（预留）
	public var idepartment:int ;//预算部门
	public var iperson:int  ; //预算人员;
	public var iitems:int ;    //预算项目明细
	public var fsum:Number;  //预算数据
	
}
}