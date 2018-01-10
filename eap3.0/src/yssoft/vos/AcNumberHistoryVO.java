/**
 * 模块名称：AcNumberHistoryVO
 * 模块说明：Java中对应的单据编码历史实体类
 * 创建人：	YJ
 * 创建日期：20110828
 * 修改人：
 * 修改日期：
 *
 */
package yssoft.vos;

public class AcNumberHistoryVO {

	public int 	iid;
	
	public int 	ifuncregedit;
	
	public String 	cprefix;
	
	public int 	inumber;
	
	public AcNumberHistoryVO(){}
	
	public AcNumberHistoryVO(int iid,int ifuncregedit,String cprefix,int inumber){
	
		this.iid 			= iid;
		this.ifuncregedit	= ifuncregedit;
		this.cprefix 		= cprefix;
		this.inumber 		= inumber;
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

	public String getCprefix() {
		return cprefix;
	}

	public void setCprefix(String cprefix) {
		this.cprefix = cprefix;
	}

	public int getInumber() {
		return inumber;
	}

	public void setInumber(int inumber) {
		this.inumber = inumber;
	}
	
	
}
