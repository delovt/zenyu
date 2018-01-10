package yssoft.vos.twitter;

public class TwitterReplyVo 
{
	private int iid;
	private int itwitter;
	private String cdetail;
	private boolean bhide;
	private int imaker;
	private String dmaker;
	private int userId;//用户ID用来对上传的图片进行操作
	
	public int getUserId() {
		return userId;
	}
	public void setUserId(int userId) {
		this.userId = userId;
	}
	public int getIid() {
		return iid;
	}
	public void setIid(int iid) {
		this.iid = iid;
	}
	public int getItwitter() {
		return itwitter;
	}
	public void setItwitter(int itwitter) {
		this.itwitter = itwitter;
	}
	public String getCdetail() {
		return cdetail;
	}
	public void setCdetail(String cdetail) {
		this.cdetail = cdetail;
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
}
