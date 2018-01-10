/**    
 *
 * 文件名：AcListsetVo.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-8-16    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.vos;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：AcListsetVo    
 * 类描述： 列表配置表   
 * 创建人：zhong_jing 
 * 创建时间：2011-8-16 下午04:45:24        
 *     
 */
public class AcListsetVo {

	//内码
	private int iid;
	
	//关联功能注册码
	private int ifuncregedit;
	
	private int ipage;
	
	private String cdataauth;
	
	private String csql1;
	
	private String csql2;
	
	private String ctable;
	
	private int itype;
	
	private int idiagram;
	
	private String cxfield;
	
	private String cyfield;
	
	private Boolean border;
	
	private Boolean bpage;

    private Boolean bmap;

    public Boolean getBmap() {
        return bmap;
    }

    public void setBmap(Boolean bmap) {
        this.bmap = bmap;
    }

    public String getCmapfield() {
        return cmapfield;
    }

    public void setCmapfield(String cmapfield) {
        this.cmapfield = cmapfield;
    }

    private String cmapfield;
	
	private int ifixnum;

	public Boolean getBpage() {
		return bpage;
	}

	public void setBpage(Boolean bpage) {
		this.bpage = bpage;
	}

	public Boolean getBorder() {
		return border;
	}

	public void setBorder(Boolean border) {
		this.border = border;
	}

	public int getItype() {
		return itype;
	}

	public void setItype(int itype) {
		this.itype = itype;
	}

	public int getIdiagram() {
		return idiagram;
	}

	public void setIdiagram(int idiagram) {
		this.idiagram = idiagram;
	}

	public String getCxfield() {
		return cxfield;
	}

	public void setCxfield(String cxfield) {
		this.cxfield = cxfield;
	}

	public String getCyfield() {
		return cyfield;
	}

	public void setCyfield(String cyfield) {
		this.cyfield = cyfield;
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

	public int getIpage() {
		return ipage;
	}

	public void setIpage(int ipage) {
		this.ipage = ipage;
	}

	public String getCdataauth() {
		return cdataauth;
	}

	public void setCdataauth(String cdataauth) {
		this.cdataauth = cdataauth;
	}

	public String getCsql1() {
		return csql1;
	}

	public void setCsql1(String csql1) {
		this.csql1 = csql1;
	}

	public String getCsql2() {
		return csql2;
	}

	public void setCsql2(String csql2) {
		this.csql2 = csql2;
	}

	public void setCtable(String ctable) {
		this.ctable = ctable;
	}

	public String getCtable() {
		return ctable;
	}

	public int getIfixnum() {
		return ifixnum;
	}
	
	public void setIfixnum(int ifixnum) {
		this.ifixnum = ifixnum;
	}
}
