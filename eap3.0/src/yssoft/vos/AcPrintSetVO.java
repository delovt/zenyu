package yssoft.vos;

@SuppressWarnings("serial")
public class AcPrintSetVO implements java.io.Serializable {

	private int iid;			 //内码		

	private int ifuncregedit;
	
	private String cname;
	
	private int itype;
	
	private String ctemplate;
	
	private String ccondit;
	
	private int buse;
	
	private int bdefault;
	
	private String cmemo;
	
	public AcPrintSetVO(){}
	
	/**
	 * 
	 * 创建一个新的实例 AsFuncregeditVO    
	 *
	 */
	public AcPrintSetVO(int iid,int ifuncregedit,String cname,int itype,String ctemplate,String ccondit,int buse,int bdefault,String cmemo) {
		
		this.setIid(iid);
		this.setIfuncregedit(ifuncregedit);
		this.setCname(cname);
		this.setItype(itype);
		this.setCtemplate(ctemplate);
		this.setCcondit(ccondit);
		this.setBuse(buse);
		this.setBdefault(bdefault);
		this.setCmemo(cmemo);
		
	}

	public void setIid(int iid) {
		this.iid = iid;
	}

	public int getIid() {
		return iid;
	}

	public void setItype(int itype) {
		this.itype = itype;
	}

	public int getItype() {
		return itype;
	}

	public void setIfuncregedit(int ifuncregedit) {
		this.ifuncregedit = ifuncregedit;
	}

	public int getIfuncregedit() {
		return ifuncregedit;
	}

	public void setCname(String cname) {
		this.cname = cname;
	}

	public String getCname() {
		return cname;
	}

	public void setCtemplate(String ctemplate) {
		this.ctemplate = ctemplate;
	}

	public String getCtemplate() {
		return ctemplate;
	}

	public void setCcondit(String ccondit) {
		this.ccondit = ccondit;
	}

	public String getCcondit() {
		return ccondit;
	}

	public void setBuse(int buse) {
		this.buse = buse;
	}

	public int getBuse() {
		return buse;
	}

	public void setBdefault(int bdefault) {
		this.bdefault = bdefault;
	}

	public int getBdefault() {
		return bdefault;
	}

	public void setCmemo(String cmemo) {
		this.cmemo = cmemo;
	}

	public String getCmemo() {
		return cmemo;
	}
	
	

	
}
