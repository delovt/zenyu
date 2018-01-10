package yssoft.vos;

public class AsSmssetVO {
	
	public int iid;			//内码
	
	public int ipid;       //上级预算内码
		
	public String cname;		//模板名称
	
	public String ccode;		//模板编码
	
	private String oldCcode;    //老菜单编码
	
	public String cport;			//预算维度条件
	
	public String cuser;		//预算部门组织字段
	
	public String cpassword;		//预算人员组织字段
	
	public String cphoneprefix;		//预算期间取值字段
	
	public String cmemo;		//备注
	
	public String caddress; //IP地址

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

	public String getCport() {
		return cport;
	}

	public void setCport(String cport) {
		this.cport = cport;
	}

	public String getCuser() {
		return cuser;
	}

	public void setCuser(String cuser) {
		this.cuser = cuser;
	}

	public String getCpassword() {
		return cpassword;
	}

	public void setCpassword(String cpassword) {
		this.cpassword = cpassword;
	}

	public String getCphoneprefix() {
		return cphoneprefix;
	}

	public void setCphoneprefix(String cphoneprefix) {
		this.cphoneprefix = cphoneprefix;
	}

	public String getCmemo() {
		return cmemo;
	}

	public void setCmemo(String cmemo) {
		this.cmemo = cmemo;
	}

	public String getCaddress() {
		return caddress;
	}

	public void setCaddress(String caddress) {
		this.caddress = caddress;
	}
	
	
	
}
