package yssoft.vos;

public class BmItemVo {
	private int iid;
	private int ipid;
	private String ccode;
	private String cname;
	private String cmemo;
	private int bdetail;
	private String oldCode;
	
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
	public String getCcode() {
		return ccode;
	}
	public void setCcode(String ccode) {
		this.ccode = ccode;
	}
	public String getCname() {
		return cname;
	}
	public void setCname(String cname) {
		this.cname = cname;
	}
	public String getCmemo() {
		return cmemo;
	}
	public void setCmemo(String cmemo) {
		this.cmemo = cmemo;
	}
	public int isBdetail() {
		return bdetail;
	}
	public void setBdetail(int bdetail) {
		this.bdetail = bdetail;
	}
	public String getOldCode() {
		return oldCode;
	}
	public void setOldCode(String oldCode) {
		this.oldCode = oldCode;
	}

}