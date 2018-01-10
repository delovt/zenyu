/**
 * 项目名称：yscrm 
 * 类名称：WfMessage 类描述： 
 * 角色的实体类 
 * 创建人：zmm
 * 创建时间：2011-09-01
 */
package yssoft.vos;

public class WfMessageVo{
	
	private int iid;
	private int ioainvoice;
	private int iperson;
	private String dprocess;
	private int iresult;
	private String cmessage;
	private int bhide;
	private int inoticeperson;
	private int breceive;
	private int bdiary;
	
	private String resultname;
	private String fdate;
	private String cname;
	
	public String getCname() {
		return cname;
	}
	public void setCname(String cname) {
		this.cname = cname;
	}
	public String getResultname() {
		return resultname;
	}
	public void setResultname(String resultname) {
		this.resultname = resultname;
	}
	public String getFdate() {
		return fdate;
	}
	public void setFdate(String fdate) {
		this.fdate = fdate;
	}
	public int getIid() {
		return iid;
	}
	public void setIid(int iid) {
		this.iid = iid;
	}
	public int getIoainvoice() {
		return ioainvoice;
	}
	public void setIoainvoice(int ioainvoice) {
		this.ioainvoice = ioainvoice;
	}
	public int getIperson() {
		return iperson;
	}
	public void setIperson(int iperson) {
		this.iperson = iperson;
	}
	public String getDprocess() {
		return dprocess;
	}
	public void setDprocess(String dprocess) {
		this.dprocess = dprocess;
	}
	public int getIresult() {
		return iresult;
	}
	public void setIresult(int iresult) {
		this.iresult = iresult;
	}
	public String getCmessage() {
		return cmessage;
	}
	public void setCmessage(String cmessage) {
		this.cmessage = cmessage;
	}
	public int getBhide() {
		return bhide;
	}
	public void setBhide(int bhide) {
		this.bhide = bhide;
	}
	public int getInoticeperson() {
		return inoticeperson;
	}
	public void setInoticeperson(int inoticeperson) {
		this.inoticeperson = inoticeperson;
	}
	public int getBreceive() {
		return breceive;
	}
	public void setBreceive(int breceive) {
		this.breceive = breceive;
	}
	public int getBdiary() {
		return bdiary;
	}
	public void setBdiary(int bdiary) {
		this.bdiary = bdiary;
	}
	
}