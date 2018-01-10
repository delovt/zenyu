/**    
 *
 * 文件名：ASRoleuserVo.java
 * 版本信息：增宇Crm2.0
 * 日期：2011-8-7    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.vos;

/**
 * 
 * 项目名称：yscrm 
 * 类名称：ASRoleuserVo 
 * 类描述： 
 * 创建人：钟晶 
 * 创建时间：2011-8-7 下午09:06:28
 * 
 */
public class AsRoleUserVo {

	// 自增值
	private int iid;

	// 编码
	private String ccode;

	// 姓名
	private String cname;

	// 部门名称
	private String departmentName;

	// 主岗名称
	private String jobName;

	// 职务
	private String postName;


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

	public String getDepartmentName() {
		return departmentName;
	}

	public void setDepartmentName(String departmentName) {
		this.departmentName = departmentName;
	}

	public String getJobName() {
		return jobName;
	}

	public void setJobName(String jobName) {
		this.jobName = jobName;
	}

	public String getPostName() {
		return postName;
	}

	public void setPostName(String postName) {
		this.postName = postName;
	}

}
