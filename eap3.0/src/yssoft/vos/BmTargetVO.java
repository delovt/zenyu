package yssoft.vos;

import java.util.Date;

public class BmTargetVO {
	
	public int iid;			//内码
	
	public int ipid;       //上级预算内码
	
	public int iifuncregedit;	//注册表内码
	
	public String cname;		//模板名称
	
	public String ccode;		//模板编码
	
	private String oldCcode;    //老菜单编码

	public String cvaluefield;	//预算指标取值字段
	
	public int ivaluetype;		//预算指标取值类型
	
	public String csqlcd;			//预算维度条件
	
	public String cdepartmentfield;		//预算部门组织字段
	
	public String cpersonfield;		//预算人员组织字段
	
	public String cdatefield;		//预算期间取值字段
	
	public String cmemo;		//备注
	
	public int imaker;		//制单人
	
	public Date dmaker;		//制单时间
	
	public int imodify;		//修改人
	
	public Date dmodify;		//修改时间
	
	public String cvaluetable;  //取值表名
	
	public String getCvaluetable() {
		return cvaluetable;
	}

	public void setCvaluetable(String cvaluetable) {
		this.cvaluetable = cvaluetable;
	}

	public int getIid() {
		return iid;
	}

	public void setIid(int iid) {
		this.iid = iid;
	}

	public int getIpid() {
		return ipid;
	}

	public void setIpid(int ipid) {
		this.ipid = ipid;
	}

	public int getIifuncregedit() {
		return iifuncregedit;
	}

	public void setIifuncregedit(int iifuncregedit) {
		this.iifuncregedit = iifuncregedit;
	}

	public String getCname() {
		return cname;
	}

	public void setCname(String cname) {
		this.cname = cname;
	}

	public String getCcode() {
		return ccode;
	}

	public void setCcode(String ccode) {
		this.ccode = ccode;
	}
	
	public String getOldCcode() {
		return oldCcode;
	}

	public void setOldCcode(String oldCcode) {
		this.oldCcode = oldCcode;
	}

	public String getCvaluefield() {
		return cvaluefield;
	}

	public void setCvaluefield(String cvaluefield) {
		this.cvaluefield = cvaluefield;
	}

	public int getIvaluetype() {
		return ivaluetype;
	}

	public void setIvaluetype(int ivaluetype) {
		this.ivaluetype = ivaluetype;
	}

	public String getCsqlcd() {
		return csqlcd;
	}

	public void setCsqlcd(String csqlcd) {
		this.csqlcd = csqlcd;
	}

	public String getCdepartmentfield() {
		return cdepartmentfield;
	}

	public void setCdepartmentfield(String cdepartmentfield) {
		this.cdepartmentfield = cdepartmentfield;
	}

	public String getCpersonfield() {
		return cpersonfield;
	}

	public void setCpersonfield(String cpersonfield) {
		this.cpersonfield = cpersonfield;
	}

	public String getCdatefield() {
		return cdatefield;
	}

	public void setCdatefield(String cdatefield) {
		this.cdatefield = cdatefield;
	}

	public String getCmemo() {
		return cmemo;
	}

	public void setCmemo(String cmemo) {
		this.cmemo = cmemo;
	}

	public int getImaker() {
		return imaker;
	}

	public void setImaker(int imaker) {
		this.imaker = imaker;
	}

	public Date getDmaker() {
		return dmaker;
	}

	public void setDmaker(Date dmaker) {
		this.dmaker = dmaker;
	}

	public int getImodify() {
		return imodify;
	}

	public void setImodify(int imodify) {
		this.imodify = imodify;
	}

	public Date getDmodify() {
		return dmodify;
	}

	public void setDmodify(Date dmodify) {
		this.dmodify = dmodify;
	}
	
}
