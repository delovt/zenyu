/**    
 *
 * 文件名：AsOperauthVo.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-8-24    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.vos;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：AsOperauthVo    
 * 类描述：    
 * 创建人：zhong_jing 
 * 创建时间：2011-8-24 上午10:39:19        
 *     
 */
public class AsOperauthVo {

	//自增值
	private int iid;
	
	//角色内码
	private int irole;
	
	//操作权限值
	private String coperauth;

	public int getIid() {
		return iid;
	}

	public void setIid(int iid) {
		this.iid = iid;
	}

	public int getIrole() {
		return irole;
	}

	public void setIrole(int irole) {
		this.irole = irole;
	}

	public String getCoperauth() {
		return coperauth;
	}

	public void setCoperauth(String coperauth) {
		this.coperauth = coperauth;
	}
}
