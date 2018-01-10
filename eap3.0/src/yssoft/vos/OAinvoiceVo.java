/**    
 *
 * 文件名：OAinvoiceVo.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-8-22    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.vos;

/**
 *     
 * 项目名称：yscrm    
 * 类名称：OAinvoiceVo    
 * 类描述：    
 * 创建人：zmm
 * 创建时间：2011-2011-8-22 下午04:27:12        
 *     
 */
public class OAinvoiceVo {
	private int iid;
	private int ifuncregedit;
	private int iinvoice;
	private String csubject;
	private int icustomer;
	private String dfinished;
	private int bplan;;
	private String cdetail;
	private int baddnew;
	private int bsendnew;
	private int istatus;
	private int imaker;
	private String csendnew;
	private int isendnew;
	
	private String nodes; // 工作流，节点信息
	private String nodeDetail; // 工作流中，节点对应的详细信息
	
	private String dmaker;					//制单时间
	private int adiid;					//协同对应的单据信息
	private String maker;				//制单人的名称
	private String customername;		//相关客户的名称
	
	private int bfinalverify;			//是否终审
	private int iinvoset;				//主表内码
	
	
	public int getBfinalverify() {
		return bfinalverify;
	}
	public void setBfinalverify(int bfinalverify) {
		this.bfinalverify = bfinalverify;
	}
	public int getIinvoset() {
		return iinvoset;
	}
	public void setIinvoset(int iinvoset) {
		this.iinvoset = iinvoset;
	}
	public String getCustomername() {
		return customername;
	}
	public void setCustomername(String customername) {
		this.customername = customername;
	}
	public String getMaker() {
		return maker;
	}
	public void setMaker(String maker) {
		this.maker = maker;
	}
	public String getNodes() {
		return nodes;
	}
	public void setNodes(String nodes) {
		this.nodes = nodes;
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
	public String getCsubject() {
		return csubject;
	}
	public void setCsubject(String csubject) {
		this.csubject = csubject;
	}
	public int getIcustomer() {
		return icustomer;
	}
	public void setIcustomer(int icustomer) {
		this.icustomer = icustomer;
	}
	public String getDfinished() {
		return dfinished;
	}
	public void setDfinished(String dfinished) {
		this.dfinished = dfinished;
	}
	public int getBplan() {
		return bplan;
	}
	public void setBplan(int bplan) {
		this.bplan = bplan;
	}
	public String getCdetail() {
		return cdetail;
	}
	public void setCdetail(String cdetail) {
		this.cdetail = cdetail;
	}
	public int getBaddnew() {
		return baddnew;
	}
	public void setBaddnew(int baddnew) {
		this.baddnew = baddnew;
	}
	public int getBsendnew() {
		return bsendnew;
	}
	public void setBsendnew(int bsendnew) {
		this.bsendnew = bsendnew;
	}
	public int getIstatus() {
		return istatus;
	}
	public void setIstatus(int istatus) {
		this.istatus = istatus;
	}
	public int getImaker() {
		return imaker;
	}
	public void setImaker(int imaker) {
		this.imaker = imaker;
	}
	public String getNodeDetail() {
		return nodeDetail;
	}
	public void setNodeDetail(String nodeDetail) {
		this.nodeDetail = nodeDetail;
	}
	public String getDmaker() {
		return dmaker;
	}
	public void setDmaker(String dmaker) {
		this.dmaker = dmaker;
	}
	public int getAdiid() {
		return adiid;
	}
	public void setAdiid(int adiid) {
		this.adiid = adiid;
	}
	public String getCsendnew() {
		return csendnew;
	}
	public void setCsendnew(String csendnew) {
		this.csendnew = csendnew;
	}
	public int getIsendnew() {
		return isendnew;
	}
	public void setIsendnew(int isendnew) {
		this.isendnew = isendnew;
	}
	
}
