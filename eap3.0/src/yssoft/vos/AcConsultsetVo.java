
package yssoft.vos;



/**
 * 
 * 项目名称：yscrm 
 * 类名称：AcConsultsetVo 类描述： 
 * 角色的实体类 
 * 创建人：刘磊
 * 创建时间：2011-8-12
 * 下午10:04:00
 * 修改人：刘磊
 * 修改时间：2011-8-12
 * 下午10:04:00 修改备注：
 * @version
 * 
 */


public class AcConsultsetVo implements java.io.Serializable
{
	

	public int iid;


	public int ipid;


	public String ccode;

	private String oldCcode;

	public String cname;


	public String itype;


	public int ipage;


	public String cdataauth;


	public String ctreesql;


	public String cgridsql;


	public String cconnsql;


	public String ifuncregedit;


	public int iheigh;


	public int iwidth;

	public boolean bdataauth;
	
	public boolean ballowmulti;
	
	public String cordersql;
	
	public String getCordersql() {
		return cordersql;
	}

	public void setCordersql(String cordersql) {
		this.cordersql = cordersql;
	}

	public String getOldCcode() {
		return oldCcode;
	}

	public void setOldCcode(String oldCcode) {
		this.oldCcode = oldCcode;
	}
	
	/**
	 * @return return iid
	 */
	public int getIid()
	{
		return this.iid;
	}

	/**
	 * @param r_Iid
	 *     set iid
	 */
	public void setIid(int r_Iid)
	{
		this.iid=r_Iid;
	}

		
	/**
	 * @return return ipid
	 */
	public int getIpid()
	{
		return this.ipid;
	}

	/**
	 * @param r_Ipid
	 *     set ipid
	 */
	public void setIpid(int r_Ipid)
	{
		this.ipid=r_Ipid;
	}

		
	/**
	 * @return return ccode
	 */
	public String getCcode()
	{
		return this.ccode;
	}

	/**
	 * @param r_Ccode
	 *     set ccode
	 */
	public void setCcode(String r_Ccode)
	{
		this.ccode=r_Ccode;
	}

		
	/**
	 * @return return cname
	 */
	public String getCname()
	{
		return this.cname;
	}

	/**
	 * @param r_Cname
	 *     set cname
	 */
	public void setCname(String r_Cname)
	{
		this.cname=r_Cname;
	}

		
	/**
	 * @return return itype
	 */
	public String getItype()
	{
		return this.itype;
	}

	/**
	 * @param r_Itype
	 *     set itype
	 */
	public void setItype(String r_Itype)
	{
		this.itype=r_Itype;
	}

		
	/**
	 * @return return ipage
	 */
	public int getIpage()
	{
		return this.ipage;
	}

	/**
	 * @param r_Ipage
	 *     set ipage
	 */
	public void setIpage(int r_Ipage)
	{
		this.ipage=r_Ipage;
	}

		
	/**
	 * @return return cdataauth
	 */
	public String getCdataauth()
	{
		return this.cdataauth;
	}

	/**
	 * @param r_Cdataauth
	 *     set cdataauth
	 */
	public void setCdataauth(String r_Cdataauth)
	{
		this.cdataauth=r_Cdataauth;
	}

		
	/**
	 * @return return ctreesql
	 */
	public String getCtreesql()
	{
		return this.ctreesql;
	}

	/**
	 * @param r_Ctreesql
	 *     set ctreesql
	 */
	public void setCtreesql(String r_Ctreesql)
	{
		this.ctreesql=r_Ctreesql;
	}

		
	/**
	 * @return return cgridsql
	 */
	public String getCgridsql()
	{
		return this.cgridsql;
	}

	/**
	 * @param r_Cgridsql
	 *     set cgridsql
	 */
	public void setCgridsql(String r_Cgridsql)
	{
		this.cgridsql=r_Cgridsql;
	}

		
	/**
	 * @return return cconnsql
	 */
	public String getCconnsql()
	{
		return this.cconnsql;
	}

	/**
	 * @param r_Cconnsql
	 *     set cconnsql
	 */
	public void setCconnsql(String r_Cconnsql)
	{
		this.cconnsql=r_Cconnsql;
	}

		
	/**
	 * @return return ifuncregedit
	 */
	public String getIfuncregedit()
	{
		return this.ifuncregedit;
	}

	/**
	 * @param r_Ifuncregedit
	 *     set ifuncregedit
	 */
	public void setIfuncregedit(String r_Ifuncregedit)
	{
		this.ifuncregedit=r_Ifuncregedit;
	}

		
	/**
	 * @return return iheigh
	 */
	public int getIheigh()
	{
		return this.iheigh;
	}

	/**
	 * @param r_Iheigh
	 *     set iheigh
	 */
	public void setIheigh(int r_Iheigh)
	{
		this.iheigh=r_Iheigh;
	}

		
	/**
	 * @return return iwidth
	 */
	public int getIwidth()
	{
		return this.iwidth;
	}

	/**
	 * @param r_Iwidth
	 *     set iwidth
	 */
	public void setIwidth(int r_Iwidth)
	{
		this.iwidth=r_Iwidth;
	}

	public boolean getBdataauth() {
		return this.bdataauth;
	}

	public void setBdataauth(boolean bdataauth) {
		this.bdataauth = bdataauth;
	}
	

	public boolean getBallowmulti() {
		return this.ballowmulti;
	}

	public void setBallowmulti(boolean ballowmulti) {
		this.ballowmulti = ballowmulti;
	}
}