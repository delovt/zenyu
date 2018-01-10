/**    
 * 文件名：AsMenuVo.java    
 *    
 * 版本信息：    
 * 日期：2011-8-1    
 * 版权所有    
 *    
 */
package yssoft.vos;

/**
 * 
 * 项目名称：yscrm 
 * 类名称：AsMenuVo 类描述： 
 * 角色的实体类 
 * 创建人：刘磊
 * 创建时间：2011-8-4 
 * 下午17:12:29
 * 修改人：刘磊
 * 修改时间：2011-8-4
 * 下午17:12:29 修改备注：
 * @version
 * 
 */

public class AsMenuVo implements java.io.Serializable
{
	/**
	 *
	 */	

	public int iid;             //自增值


	public int ipid;            //上级菜单内码


	public String ccode;        //菜单编码
	
	private String oldCcode;    //老菜单编码


	public String cname;        //菜单名称


	public int iimage;         //菜单图标


	public int itype;          //菜单类型


	public String cprogram;    //外部程序链接地址


	public String ifuncregedit;   //关联注册程序ID


	public int iopentype;      //打开方式

	public int bshow;          //窗口状态
	
	public String cparameter;  //参数

    public int imenup;
	
	
	private String crname;
	
	private String irfuncregedit;

	public String getCrname() {
		return crname;
	}

	public void setCrname(String crname) {
		this.crname = crname;
	}



	public String getIrfuncregedit() {
		return irfuncregedit;
	}

	public void setIrfuncregedit(String irfuncregedit) {
		this.irfuncregedit = irfuncregedit;
	}

	/**
	 * 
	 * 创建一个新的实例 AsMenuVo.    
	 *
	 */
	public AsMenuVo() {

	}
	
	public String getOldCcode() {
		return oldCcode;
	}

	public void setOldCcode(String oldCcode) {
		this.oldCcode = oldCcode;
	}

	/**
	 * 
	 * 创建一个新的实例 AsMenuVo.    
	 *
	 */
	public AsMenuVo(int iid, int ipid, String ccode, String cname, int iimage,
			int itype,String cprogram,String ifuncregedit,int iopentype,int bshow) {
		this.iid = iid;
		this.ipid = ipid;
		this.ccode = ccode;
		this.cname = cname;
		this.iimage = iimage;
		this.itype = itype;
		this.cprogram = cprogram;
		this.ifuncregedit = ifuncregedit;
		this.iopentype = iopentype; 
		this.bshow = bshow;
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
	 * @return return iimage
	 */
	public int getIimage()
	{
		return this.iimage;
	}

	/**
	 * @param r_Iimage
	 *     set iimage
	 */
	public void setIimage(int r_Iimage)
	{
		this.iimage=r_Iimage;
	}

		
	/**
	 * @return return itype
	 */
	public int getItype()
	{
		return this.itype;
	}

	/**
	 * @param r_Itype
	 *     set itype
	 */
	public void setItype(int r_Itype)
	{
		this.itype=r_Itype;
	}

		
	/**
	 * @return return cprogram
	 */
	public String getCprogram()
	{
		return this.cprogram;
	}

	/**
	 * @param r_Cprogram
	 *     set cprogram
	 */
	public void setCprogram(String r_Cprogram)
	{
		this.cprogram=r_Cprogram;
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
	 * @return return iopentype
	 */
	public int getIopentype()
	{
		return this.iopentype;
	}

	/**
	 * @param r_Iopentype
	 *     set iopentype
	 */
	public void setIopentype(int r_Iopentype)
	{
		this.iopentype=r_Iopentype;
	}

	/**
	 * @return return bshow
	 */
	public int getBshow() {
		return bshow;
	}

	/**
	 * @param r_Bshow
	 *     set bshow
	 */
	public void setBshow(int r_Bshow) {
		this.bshow = r_Bshow;
	}
	
	public String getCparameter()
	{
         return cparameter;		
	}
	
	public void setCparameter(String r_Cparameter)
	{
         this.cparameter=r_Cparameter;		
	}
	
}