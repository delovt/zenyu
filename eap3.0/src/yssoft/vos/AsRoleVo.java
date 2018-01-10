/**    
 *
 * 文件名：RoleVo
 * 版本信息：增宇Crm2.0
 * 日期：20011-08-04    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.vos;

/**
 * 
 *     
 * 项目名称：yscrm    
 * 类名称：RoleVo    
 * 类描述：    
 * 创建人：钟晶  
 * 创建时间：2011-2011-8-5 上午09:27:24        
 *
 */
public class AsRoleVo {

	// 内码
	private int iid;

	// 上级角色内码
	private int ipid;

	// 角色编码
	private String ccode;

	// 角色名称
	private String cname;

	// 是否启用
	private boolean buse;

	// 备注
	private String cmemo;
	
	private String oldCcode;
	

	/**
	 * 
	 * 创建一个新的实例 RoleVo.    
	 *
	 */
	public AsRoleVo() {

	}

	public String getOldCcode() {
		return oldCcode;
	}

	public void setOldCcode(String oldCcode) {
		this.oldCcode = oldCcode;
	}

	/**
	 * 
	 * 创建一个新的实例 RoleVo.    
	 *
	 */
	public AsRoleVo(int iid, int ipid, String ccode, String cname, boolean buse,
			String cmemo) {
		this.iid = iid;
		this.ipid = ipid;
		this.ccode = ccode;
		this.cname = cname;
		this.buse = buse;
		this.cmemo = cmemo;
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

	public boolean getBuse() {
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
