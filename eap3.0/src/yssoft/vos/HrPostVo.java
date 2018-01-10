/**    
 *
 * 文件名：HrPostVo.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-8-15    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.vos;

/**
 * 
 * 项目名称：yscrm 
 * 类名称：HrPostVo 
 * 类描述： 
 * 创建人：zhong_jing 
 * 创建时间：2011-8-15 下午06:40:22
 * 
 */
public class HrPostVo {

	// 内码
	private int iid;

	// 职类内码
	private int ipostclass;

	// 编码
	private String ccode;

	// 名称
	private String cname;

	// 级别
	private int ilevel;

	// 职务描述
	private String cwork;

	// 备注
	private String cmemo;
	//在职人数
	private int irealperson;
	
	public int getIrealperson() {
		return irealperson;
	}

	public void setIrealperson(int irealperson) {
		this.irealperson = irealperson;
	}

	public int getIid() {
		return iid;
	}

	public void setIid(int iid) {
		this.iid = iid;
	}

	public int getIpostclass() {
		return ipostclass;
	}

	public void setIpostclass(int ipostclass) {
		this.ipostclass = ipostclass;
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

	public int getIlevel() {
		return ilevel;
	}

	public void setIlevel(int ilevel) {
		this.ilevel = ilevel;
	}

	public String getCwork() {
		return cwork;
	}

	public void setCwork(String cwork) {
		this.cwork = cwork;
	}

	public String getCmemo() {
		return cmemo;
	}

	public void setCmemo(String cmemo) {
		this.cmemo = cmemo;
	}
}
