/**    
 *
 * 文件名：HrPostclassVo.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-8-15    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.vos;

/**
 * 
 * 项目名称：yscrm 
 * 类名称：HrPostclassVo 
 * 类描述： 创建人：zhong_jing 
 * 创建时间：2011-8-15 下午06:28:28
 * 
 */
public class HrPostclassVo {

	// 内码
	private int iid;

	// 编码
	private String ccode;

	// 名称
	private String cname;

	// 备注
	private String cmemo;

	private int ipid;
	
	private String oldCcode;

	public String getOldCcode() {
		return oldCcode;
	}

	public void setOldCcode(String oldCcode) {
		this.oldCcode = oldCcode;
	}

	public int getIid() {
		return iid;
	}

	public void setIid(int iid) {
		this.iid = iid;
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

	public String getCmemo() {
		return cmemo;
	}

	public void setCmemo(String cmemo) {
		this.cmemo = cmemo;
	}

	public int getIpid() {
		return ipid;
	}

	public void setIpid(int ipid) {
		this.ipid = ipid;
	}

}
