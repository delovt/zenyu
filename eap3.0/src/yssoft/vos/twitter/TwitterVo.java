package yssoft.vos.twitter;

public class TwitterVo {
	
	private int iid;
	private String cname;
	private String cdetail;
	private int itype;
	private boolean bpopclassic;
	private int istatus; 
	private boolean bhide;
	private int imaker;
	private String dmaker;
	private int iread;
	private int ibrowse;
	private int iwriteback;
	private String dwriteback;
	private int irecommend;
	private String type;//通过此可以判断是发布还是暂存
	private int userId;//用户ID用来对上传的图片进行操作
	
	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}
	public String getType() {
		return type;
	}
	public void setType(String type) {
		this.type = type;
	}
	public int getIid() {
		return iid;
	}
	public void setIid(int iid) {
		this.iid = iid;
	}
	public String getCname() {
		return cname;
	}
	public void setCname(String cname) {
		this.cname = cname;
	}
	public String getCdetail() {
		return cdetail;
	}
	public void setCdetail(String cdetail) {
		this.cdetail = cdetail;
	}
	public int getItype() {
		return itype;
	}
	public void setItype(int itype) {
		this.itype = itype;
	}
	public boolean isBpopclassic() {
		return bpopclassic;
	}
	public void setBpopclassic(boolean bpopclassic) {
		this.bpopclassic = bpopclassic;
	}
	public int getIstatus() {
		return istatus;
	}
	public void setIstatus(int istatus) {
		this.istatus = istatus;
	}
	public boolean isBhide() {
		return bhide;
	}
	public void setBhide(boolean bhide) {
		this.bhide = bhide;
	}
	public int getImaker() {
		return imaker;
	}
	public void setImaker(int imaker) {
		this.imaker = imaker;
	}
	public String getDmaker() {
		return dmaker;
	}
	public void setDmaker(String dmaker) {
		this.dmaker = dmaker;
	}
	public int getIread() {
		return iread;
	}
	public void setIread(int iread) {
		this.iread = iread;
	}
	public int getIbrowse() {
		return ibrowse;
	}
	public void setIbrowse(int ibrowse) {
		this.ibrowse = ibrowse;
	}
	public int getIwriteback() {
		return iwriteback;
	}
	public void setIwriteback(int iwriteback) {
		this.iwriteback = iwriteback;
	}
	public String getDwriteback() {
		return dwriteback;
	}
	public void setDwriteback(String dwriteback) {
		this.dwriteback = dwriteback;
	}
	public int getIrecommend() {
		return irecommend;
	}
	public void setIrecommend(int irecommend) {
		this.irecommend = irecommend;
	}
}
