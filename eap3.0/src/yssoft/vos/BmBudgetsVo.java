package yssoft.vos;

public class BmBudgetsVo {
	private int iid;
	private int ibudget;		//预算主表内码
	private int imonth;		//预算月份
	private int icorp;			//预算公司（预留）
	private int idepartment;//预算部门
	private int iperson ; //预算人员;
	private int iitems;    //预算项目明细
	private double fsum;  //预算数据
	
	public int getIid() {
		return iid;
	}
	public void setIid(int iid) {
		this.iid = iid;
	}
	public int getIbudget() {
		return ibudget;
	}
	public void setIbudget(int ibudget) {
		this.ibudget = ibudget;
	}
	public int getImonth() {
		return imonth;
	}
	public void setImonth(int imonth) {
		this.imonth = imonth;
	}
	public int getIcorp() {
		return icorp;
	}
	public void setIcorp(int icorp) {
		this.icorp = icorp;
	}
	public int getIdepartment() {
		return idepartment;
	}
	public void setIdepartment(int idepartment) {
		this.idepartment = idepartment;
	}
	public int getIperson() {
		return iperson;
	}
	public void setIperson(int iperson) {
		this.iperson = iperson;
	}
	public int getIitems() {
		return iitems;
	}
	public void setIitems(int iitems) {
		this.iitems = iitems;
	}
	public double getFsum() {
		return fsum;
	}
	public void setFsum(double fsum) {
		this.fsum = fsum;
	}
}
