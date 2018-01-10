/**    
 *
 * 文件名：wf_invosetVo.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-9-15    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.vos;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：wf_invosetVo    
 * 类描述：    
 * 创建人：朱毛毛 
 * 创建时间：2011-2011-9-15 下午01:16:02        
 *     
 */
public class wf_invosetVo {
	private int iid;
	private int ifuncregedit;	// 表单iid
	private String ifuncname;	//表单名称
	private String ccode;
	private String cname;
	private int brelease;
	private String dmaker;
	private int imaker;
	private String imakername;
	
	public String getDmaker() {
		return dmaker;
	}
	public void setDmaker(String dmaker) {
		this.dmaker = dmaker;
	}
	public int getImaker() {
		return imaker;
	}
	public void setImaker(int imaker) {
		this.imaker = imaker;
	}
	public String getImakername() {
		return imakername;
	}
	public void setImakername(String imakername) {
		this.imakername = imakername;
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
	public String getIfuncname() {
		return ifuncname;
	}
	public void setIfuncname(String ifuncname) {
		this.ifuncname = ifuncname;
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
	public int getBrelease() {
		return brelease;
	}
	public void setBrelease(int brelease) {
		this.brelease = brelease;
	}
	
	
}
