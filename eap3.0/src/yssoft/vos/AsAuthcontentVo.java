/**    
 *
 * 文件名：AsAuthcontentVo.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-8-20    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.vos;

/**
 * 
 * 项目名称：yscrm 
 * 类名称：AsAuthcontentVo 
 * 类描述： 创建人：zhong_jing 
 * 创建时间：2011-8-20 上午08:46:23
 * 
 */
public class AsAuthcontentVo {

	// 自增值
	private int iid;

	// 上级分类码
	private int ipid;

	// 编码
	private String ccode;

	// 名称
	private String cname;

	// 参数值
	private String coperauth;

	// 是否启用
	private boolean buse;

	// 备注
	private String cmemo;
	
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

	public int getIpid() {
		return ipid;
	}

	public void setIpid(int ipid) {
		this.ipid = ipid;
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

	public String getCoperauth() {
		return coperauth;
	}

	public void setCoperauth(String coperauth) {
		this.coperauth = coperauth;
	}

	public boolean isBuse() {
		return buse;
	}

	public void setBuse(boolean buse) {
		this.buse = buse;
	}

	public String getCmemo() {
		return cmemo;
	}

	public void setCmemo(String cmemo) {
		this.cmemo = cmemo;
	}

}
