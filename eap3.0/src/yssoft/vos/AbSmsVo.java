/**    
 *
 * 文件名：AbSmsVo.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-9-5    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.vos;

import java.util.Date;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：AbSmsVo    
 * 类描述：  
 * 创建人：lzx
 * 创建时间：2012-12-03      
 *     
 */
public class AbSmsVo {
	
	private int iid;
	
	private int ifuncregedit;
	
	private int iinvoice;
	
	private int icustomer;
	
	private int imrcustomer;
	
	private String ccusname;
	
	private int icustperson;
	
	private String cpsnname;
	
	private String ctitle;
	
	private String cmobile;
	
	private String cdetail;
	
	private int istate;
	
	private int imaker;
	
	private Date dmaker;
	
	private int imodify;
	
	private Date dmodify;

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

	public int getIcustomer() {
		return icustomer;
	}

	public void setIcustomer(int icustomer) {
		this.icustomer = icustomer;
	}

	public int getImrcustomer() {
		return imrcustomer;
	}

	public void setImrcustomer(int imrcustomer) {
		this.imrcustomer = imrcustomer;
	}

	public String getCcusname() {
		return ccusname;
	}

	public void setCcusname(String ccusname) {
		this.ccusname = ccusname;
	}

	public int getIcustperson() {
		return icustperson;
	}

	public void setIcustperson(int icustperson) {
		this.icustperson = icustperson;
	}

	public String getCpsnname() {
		return cpsnname;
	}

	public void setCpsnname(String cpsnname) {
		this.cpsnname = cpsnname;
	}

	public String getCtitle() {
		return ctitle;
	}

	public void setCtitle(String ctitle) {
		this.ctitle = ctitle;
	}

	public String getCmobile() {
		return cmobile;
	}

	public void setCmobile(String cmobile) {
		this.cmobile = cmobile;
	}

	public String getCdetail() {
		return cdetail;
	}

	public void setCdetail(String cdetail) {
		this.cdetail = cdetail;
	}

	public int getIstate() {
		return istate;
	}

	public void setIstate(int istate) {
		this.istate = istate;
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
