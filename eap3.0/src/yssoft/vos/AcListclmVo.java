/**    
 *
 * 文件名：AcListclmVo.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-8-16    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.vos;

/**
 * 
 * 项目名称：yscrm 
 * 类名称：AcListclmVo 
 * 类描述： 
 * 创建人：zhong_jing 
 * 创建时间：2011-8-16 下午04:48:31
 * 
 */
public class AcListclmVo {

	private int iid;

	private int ilist;

	private String cfield;

	private String ccaption;

	private String cnewcaption;

	private int ifieldtype;

	private String cformat;

	private int icolwidth;

	private int ialign;

	private boolean bshow;

	private int ino;

	private boolean bsearch;
	
	private int iperson;
	
	private boolean bsum;
	
	private String cshfield;
	
	private boolean blinkfun;
	
	private boolean bgroup;
	
	private boolean bfilter;
	
	private boolean bcrossrow; //XZQWJ 增加 交叉行
	
	private boolean bcrosscol;//XZQWJ 增加交叉列
	
	private boolean btotalfield;//XZQWJ 增加统计字段
	
	private boolean bamount;//XZQWJ 增加汇总字段
	
	private boolean browtotal;//XZQWJ 增加行汇总字段
	
	private boolean bcoltotal;//XZQWJ 增加列汇总字段
	
	public boolean isBcoltotal() {
		return bcoltotal;
	}
	
	public void setBcoltotal(boolean bcoltotal) {
		this.bcoltotal = bcoltotal;
	}
	
	public boolean isBrowtotal() {
		return browtotal;
	}
	
	public void setBrowtotal(boolean browtotal) {
		this.browtotal = browtotal;
	}
	
	public boolean isBamount() {
		return bamount;
	}
	
	public void setBamount(boolean bamount) {
		this.bamount = bamount;
	}
	
	public boolean isBcrossrow() {
		return bcrossrow;
	}
	
	public void setBcrossrow(boolean bcrossrow) {
		this.bcrossrow = bcrossrow;
	}
	
	public boolean isBcrosscol() {
		return bcrosscol;
	}
	
	public void setBcrosscol(boolean bcrosscol) {
		this.bcrosscol = bcrosscol;
	}
	
	public boolean isBtotalfield() {
		return btotalfield;
	}
	
	public void setBtotalfield(boolean btotalfield) {
		this.btotalfield = btotalfield;
	}
	
	public boolean isBfilter() {
		return bfilter;
	}

	public void setBfilter(boolean bfilter) {
		this.bfilter = bfilter;
	}

	public boolean isBgroup() {
		return bgroup;
	}

	public void setBgroup(boolean bgroup) {
		this.bgroup = bgroup;
	}

	public boolean isBlinkfun() {
		return blinkfun;
	}

	public void setBlinkfun(boolean blinkfun) {
		this.blinkfun = blinkfun;
	}

	public boolean isBsum() {
		return bsum;
	}

	public void setBsum(boolean bsum) {
		this.bsum = bsum;
	}

	public int getIperson() {
		return iperson;
	}

	public void setIperson(int iperson) {
		this.iperson = iperson;
	}

	public int getIid() {
		return iid;
	}

	public void setIid(int iid) {
		this.iid = iid;
	}

	public int getIlist() {
		return ilist;
	}

	public void setIlist(int ilist) {
		this.ilist = ilist;
	}

	public String getCfield() {
		return cfield;
	}

	public void setCfield(String cfield) {
		this.cfield = cfield;
	}

	public String getCcaption() {
		return ccaption;
	}

	public void setCcaption(String ccaption) {
		this.ccaption = ccaption;
	}

	public String getCnewcaption() {
		return cnewcaption;
	}

	public void setCnewcaption(String cnewcaption) {
		this.cnewcaption = cnewcaption;
	}

	public int getIfieldtype() {
		return ifieldtype;
	}

	public void setIfieldtype(int ifieldtype) {
		this.ifieldtype = ifieldtype;
	}

	public String getCformat() {
		return cformat;
	}

	public void setCformat(String cformat) {
		this.cformat = cformat;
	}

	public int getIcolwidth() {
		return icolwidth;
	}

	public void setIcolwidth(int icolwidth) {
		this.icolwidth = icolwidth;
	}

	public int getIalign() {
		return ialign;
	}

	public void setIalign(int ialign) {
		this.ialign = ialign;
	}

	public boolean isBshow() {
		return bshow;
	}

	public void setBshow(boolean bshow) {
		this.bshow = bshow;
	}

	public int getIno() {
		return ino;
	}

	public void setIno(int ino) {
		this.ino = ino;
	}

	public boolean isBsearch() {
		return bsearch;
	}

	public void setBsearch(boolean bsearch) {
		this.bsearch = bsearch;
	}

	public String getCshfield() {
		return cshfield;
	}

	public void setCshfield(String cshfield) {
		this.cshfield = cshfield;
	}

}
