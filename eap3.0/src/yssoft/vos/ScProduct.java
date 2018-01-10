package yssoft.vos;

/**
 * 存货档案
 * @author 孙东亚
 *
 */
public class ScProduct {
	
	private int iid;
	private int iproductclass;
	private int iproductgroup;
	private String ccode;
	private String cname;
	private String cpdstv;
	private String cmnemonic;
	private int iunitclass;
	private int iunitdefault;
	private int iunit;
	private int itaxtype;
	//private int itaxrate;
	private float ftaxquotedprice;
	private float freferencecost;
	private float fsafequantity;
	private boolean bassets;
	private boolean bservice;
	private boolean bfittings;
	private boolean bsn;
	private boolean bfree1;
	private boolean bfree2;
	private boolean bfree3;
	private boolean bpurchase;
	private boolean bsale;
	private boolean bconsume;
	private boolean bselfmake;
	private int istatus;
	
	
	public int getIid() {
		return iid;
	}
	public void setIid(int iid) {
		this.iid = iid;
	}
	public int getIproductclass() {
		return iproductclass;
	}
	public void setIproductclass(int iproductclass) {
		this.iproductclass = iproductclass;
	}
	public int getIproductgroup() {
		return iproductgroup;
	}
	public void setIproductgroup(int iproductgroup) {
		this.iproductgroup = iproductgroup;
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
	public String getCpdstv() {
		return cpdstv;
	}
	public void setCpdstv(String cpdstv) {
		this.cpdstv = cpdstv;
	}
	public String getCmnemonic() {
		if(cmnemonic == null)return "";
		return cmnemonic;
	}
	public void setCmnemonic(String cmnemonic) {
		this.cmnemonic = cmnemonic;
	}
	public int getIunitclass() {
		return iunitclass;
	}
	public void setIunitclass(int iunitclass) {
		this.iunitclass = iunitclass;
	}
	public int getIunitdefault() {
		return iunitdefault;
	}
	public void setIunitdefault(int iunitdefault) {
		this.iunitdefault = iunitdefault;
	}
	public int getIunit() {
		return iunit;
	}
	public void setIunit(int iunit) {
		this.iunit = iunit;
	}
	public int getItaxtype() {
		return itaxtype;
	}
	public void setItaxtype(int itaxtype) {
		this.itaxtype = itaxtype;
	}
	public float getFtaxquotedprice() {
		return ftaxquotedprice;
	}
	public void setFtaxquotedprice(float ftaxquotedprice) {
		this.ftaxquotedprice = ftaxquotedprice;
	}
	public float getFreferencecost() {
		return freferencecost;
	}
	public void setFreferencecost(float freferencecost) {
		this.freferencecost = freferencecost;
	}
	public float getFsafequantity() {
		return fsafequantity;
	}
	public void setFsafequantity(float fsafequantity) {
		this.fsafequantity = fsafequantity;
	}
	public boolean isBassets() {
		return bassets;
	}
	public void setBassets(boolean bassets) {
		this.bassets = bassets;
	}
	public boolean isBservice() {
		return bservice;
	}
	public void setBservice(boolean bservice) {
		this.bservice = bservice;
	}
	public boolean isBfittings() {
		return bfittings;
	}
	public void setBfittings(boolean bfittings) {
		this.bfittings = bfittings;
	}
	public boolean isBsn() {
		return bsn;
	}
	public void setBsn(boolean bsn) {
		this.bsn = bsn;
	}
	public boolean isBfree1() {
		return bfree1;
	}
	public void setBfree1(boolean bfree1) {
		this.bfree1 = bfree1;
	}
	public boolean isBfree2() {
		return bfree2;
	}
	public void setBfree2(boolean bfree2) {
		this.bfree2 = bfree2;
	}
	public boolean isBfree3() {
		return bfree3;
	}
	public void setBfree3(boolean bfree3) {
		this.bfree3 = bfree3;
	}
	public boolean isBpurchase() {
		return bpurchase;
	}
	public void setBpurchase(boolean bpurchase) {
		this.bpurchase = bpurchase;
	}
	public boolean isBsale() {
		return bsale;
	}
	public void setBsale(boolean bsale) {
		this.bsale = bsale;
	}
	public boolean isBconsume() {
		return bconsume;
	}
	public void setBconsume(boolean bconsume) {
		this.bconsume = bconsume;
	}
	public boolean isBselfmake() {
		return bselfmake;
	}
	public void setBselfmake(boolean bselfmake) {
		this.bselfmake = bselfmake;
	}
	public int getIstatus() {
		return istatus;
	}
	public void setIstatus(int istatus) {
		this.istatus = istatus;
	}

	
}
