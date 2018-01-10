/**    
 *
 * 文件名：HRDepartmentVo.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-8-12    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.vos;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：HRDepartmentVo    
 * 类描述：    
 * 创建人：zhong_jing 
 * 创建时间：2011-8-12 下午04:01:35        
 *     
 */
public class HRDepartmentVo {

	//内码
	private int iid;
	
	//上级内码
	private int ipid;
	
	//编码
	private String ccode; 
	
	//名称
	private String cname;
	
	//部门主管
	private int ihead;
	
	//分管主管
	private int icharge;
	
	//编制人数
	private int iperson;
	
	//在编人数
	private int irealperson;
	
	//新的编码
	private String oldCcode;
	//分管领导
	private int ilead; 
	
	private String cabbreviation;


	public String getCabbreviation() {
		return cabbreviation;
	}

	public void setCabbreviation(String cabbreviation) {
		this.cabbreviation = cabbreviation;
	}

	public int getIlead() {
		return ilead;
	}

	public void setIlead(int ilead) {
		this.ilead = ilead;
	}

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

	public int getIhead() {
		return ihead;
	}

	public void setIhead(int ihead) {
		this.ihead = ihead;
	}

	public int getIcharge() {
		return icharge;
	}

	public void setIcharge(int icharge) {
		this.icharge = icharge;
	}

	public int getIperson() {
		return iperson;
	}

	public void setIperson(int iperson) {
		this.iperson = iperson;
	}

	public int getIrealperson() {
		return irealperson;
	}

	public void setIrealperson(int irealperson) {
		this.irealperson = irealperson;
	}
	
	
}
