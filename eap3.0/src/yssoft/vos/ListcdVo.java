/**    
 *
 * 文件名：ListcdVo.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-9-20    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.vos;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：ListcdVo    
 * 类描述：    
 * 创建人：zhong_jing 
 * 创建时间：2011-9-20 下午04:07:14        
 *     
 */
public class ListcdVo {

	//内码
	private int iid;
	
	//列表配置上级内码
	private int ipid;
	
	//关联功能注册码
	private int ifuncregedit;
	
	//常用条件编码
	private String ccode;
	
	//常用条件名
	private String cname;
	
	//SQL语句
	private String csql;
	
	//老编码
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

	public int getIfuncregedit() {
		return ifuncregedit;
	}

	public void setIfuncregedit(int ifuncregedit) {
		this.ifuncregedit = ifuncregedit;
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

	public String getCsql() {
		return csql;
	}

	public void setCsql(String csql) {
		this.csql = csql;
	}
	
	
}
