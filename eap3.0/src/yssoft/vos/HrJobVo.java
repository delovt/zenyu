/**    
 *
 * 文件名：HrJob.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-8-15    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.vos;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：HrJob    
 * 类描述：    
 * 创建人：zhong_jing 
 * 创建时间：2011-8-15 下午12:58:23        
 *     
 */
public class HrJobVo {

	//内码
	private int iid;
	//部门内码
	private int idepartment;
	//编码
	private String ccode;
	//名称
	private String cname;
	//职责
	private String cwork;
    //编制人数
	private int iperson;
	
	private String departmentName;
	
	//在编人数
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

	public int getIdepartment() {
		return idepartment;
	}

	public void setIdepartment(int idepartment) {
		this.idepartment = idepartment;
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

	public String getCwork() {
		return cwork;
	}

	public void setCwork(String cwork) {
		this.cwork = cwork;
	}

	public int getIperson() {
		return iperson;
	}

	public void setIperson(int iperson) {
		this.iperson = iperson;
	}

	public String getDepartmentName() {
		return departmentName;
	}

	public void setDepartmentName(String departmentName) {
		this.departmentName = departmentName;
	}
}
