/**    
 *
 * 文件名：AbInvoiceatmVo.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-9-5    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.vos;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：AbInvoiceatmVo    
 * 类描述：    
 * 创建人：朱毛毛 
 * 创建时间：2011-2011-9-5 下午02:09:39        
 *     
 */
public class AbInvoiceatmVo {
	private int iid;
	private int ifuncregedit;
	private int iinvoice;
	private int iinvoices;
	private String cname;
	private String cextname;
	private String cdataauth;
	private int iperson;
	private String dupload;
	
	private String pcname;
	private String size;
	
	private byte[] fdata;
	private String csysname;

	public String getCsysname() {
		return csysname;
	}

	public void setCsysname(String csysname) {
		this.csysname = csysname;
	}

	public byte[] getFdata() {
		return fdata;
	}

	public void setFdata(byte[] fdata) {
		this.fdata = fdata;
	}

	public String getSize() {
		return size;
	}

	public void setSize(String size) {
		this.size = size;
	}

	public int getIid() {
		return iid;
	}

	public void setIid(int iid) {
		this.iid = iid;
	}

	public int getIfuncregedit() {
		return ifuncregedit;
	}

	public void setIfuncregedit(int ifuncregedit) {
		this.ifuncregedit = ifuncregedit;
	}

	public int getIinvoice() {
		return iinvoice;
	}

	public void setIinvoice(int iinvoice) {
		this.iinvoice = iinvoice;
	}

	public int getIinvoices() {
		return iinvoices;
	}

	public void setIinvoices(int iinvoices) {
		this.iinvoices = iinvoices;
	}

	public String getCname() {
		return cname;
	}

	public void setCname(String cname) {
		this.cname = cname;
	}

	public String getCextname() {
		return cextname;
	}

	public void setCextname(String cextname) {
		this.cextname = cextname;
	}

	public String getCdataauth() {
		return cdataauth;
	}

	public void setCdataauth(String cdataauth) {
		this.cdataauth = cdataauth;
	}

	public int getIperson() {
		return iperson;
	}

	public void setIperson(int iperson) {
		this.iperson = iperson;
	}

	public String getDupload() {
		return dupload;
	}

	public void setDupload(String dupload) {
		this.dupload = dupload;
	}

	public String getPcname() {
		return pcname;
	}

	public void setPcname(String pcname) {
		this.pcname = pcname;
	}
	
	
}
