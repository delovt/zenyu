/**    
 *
 * 文件名：CsCustpersonVo.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-9-12    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.vos;

import java.util.Date;

/**
 * 
 * 项目名称：yscrm    
 * 类名称：AbInvoicepropertyVo    
 * 类描述：    
 * 创建人：zhong_jing 
 * 创建时间：2011-9-12 下午09:04:18        
 *
 */
public class AbInvoicepropertyVo {

	//自增值
	private int iid;
	//业务单据类型内码
	private int ifuncregedit;
	//业务单据内码ID
	private int iinvoice;
	//业务单据编码
	private String ccode;
	//工作流ID
	private int iworkflow;
	//UI界面ID
	private int iform;
	//源单类型内码
	private int isourceregedit;
	//源单内码ID
	private int isource;
	//制单人
	private int imaker;
	//制单时间
	private Date dmaker;
	//最后修改人	
	private int imodify;
	//最后修改时间
	private Date dmodify;
	//审核人
	private int iverify;
	//审核时间
	private Date dverify;
	//记账人
	private int iaccounting;
	//记账时间
	private Date daccounting;
	//关闭人
	private int iclose;
	//关闭时间
	private Date dclose;
	//删除人
	private int idelete;
	//删除时间
	private Date ddelete;
	//信息完整度
	private int ffullrate;
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
	public String getCcode() {
		return ccode;
	}
	public void setCcode(String ccode) {
		this.ccode = ccode;
	}
	public int getIworkflow() {
		return iworkflow;
	}
	public void setIworkflow(int iworkflow) {
		this.iworkflow = iworkflow;
	}
	public int getIform() {
		return iform;
	}
	public void setIform(int iform) {
		this.iform = iform;
	}
	public int getIsourceregedit() {
		return isourceregedit;
	}
	public void setIsourceregedit(int isourceregedit) {
		this.isourceregedit = isourceregedit;
	}
	public int getIsource() {
		return isource;
	}
	public void setIsource(int isource) {
		this.isource = isource;
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
	public int getIverify() {
		return iverify;
	}
	public void setIverify(int iverify) {
		this.iverify = iverify;
	}
	public Date getDverify() {
		return dverify;
	}
	public void setDverify(Date dverify) {
		this.dverify = dverify;
	}
	public int getIaccounting() {
		return iaccounting;
	}
	public void setIaccounting(int iaccounting) {
		this.iaccounting = iaccounting;
	}
	public Date getDaccounting() {
		return daccounting;
	}
	public void setDaccounting(Date daccounting) {
		this.daccounting = daccounting;
	}
	public int getIclose() {
		return iclose;
	}
	public void setIclose(int iclose) {
		this.iclose = iclose;
	}
	public Date getDclose() {
		return dclose;
	}
	public void setDclose(Date dclose) {
		this.dclose = dclose;
	}
	public int getIdelete() {
		return idelete;
	}
	public void setIdelete(int idelete) {
		this.idelete = idelete;
	}
	public Date getDdelete() {
		return ddelete;
	}
	public void setDdelete(Date ddelete) {
		this.ddelete = ddelete;
	}
	public int getFfullrate() {
		return ffullrate;
	}
	public void setFfullrate(int ffullrate) {
		this.ffullrate = ffullrate;
	}

}
