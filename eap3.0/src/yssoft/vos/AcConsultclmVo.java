
package yssoft.vos;



/**
 * 
 * 项目名称：yscrm 
 * 类名称：AcConsultclmVo 类描述： 
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


public class AcConsultclmVo implements java.io.Serializable
{

	public int iid;//主键


	public int iconsult;//外键


	public String cfield;//字段名


	public String ccaption;//


	public String cnewcaption;


	public int ifieldtype;


	public String cformat;


	public int icolwidth;


	public int ialign;


	public int bshow;


	public int ino;


	public int bsearch;

	private String cshfield;
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
	 * @return return iconsult
	 */
	public int getIconsult()
	{
		return this.iconsult;
	}

	/**
	 * @param r_Iconsult
	 *     set iconsult
	 */
	public void setIconsult(int r_Iconsult)
	{
		this.iconsult=r_Iconsult;
	}

		
	/**
	 * @return return cfield
	 */
	public String getCfield()
	{
		return this.cfield;
	}

	/**
	 * @param r_Cfield
	 *     set cfield
	 */
	public void setCfield(String r_Cfield)
	{
		this.cfield=r_Cfield;
	}

		
	/**
	 * @return return ccaption
	 */
	public String getCcaption()
	{
		return this.ccaption;
	}

	/**
	 * @param r_Ccaption
	 *     set ccaption
	 */
	public void setCcaption(String r_Ccaption)
	{
		this.ccaption=r_Ccaption;
	}

		
	/**
	 * @return return cnewcaption
	 */
	public String getCnewcaption()
	{
		return this.cnewcaption;
	}

	/**
	 * @param r_Cnewcaption
	 *     set cnewcaption
	 */
	public void setCnewcaption(String r_Cnewcaption)
	{
		this.cnewcaption=r_Cnewcaption;
	}

		
	/**
	 * @return return ifieldtype
	 */
	public int getIfieldtype()
	{
		return this.ifieldtype;
	}

	/**
	 * @param r_Ifieldtype
	 *     set ifieldtype
	 */
	public void setIfieldtype(int r_Ifieldtype)
	{
		this.ifieldtype=r_Ifieldtype;
	}

		
	/**
	 * @return return cformat
	 */
	public String getCformat()
	{
		return this.cformat;
	}

	/**
	 * @param r_Cformat
	 *     set cformat
	 */
	public void setCformat(String r_Cformat)
	{
		this.cformat=r_Cformat;
	}

		
	/**
	 * @return return icolwidth
	 */
	public int getIcolwidth()
	{
		return this.icolwidth;
	}

	/**
	 * @param r_Icolwidth
	 *     set icolwidth
	 */
	public void setIcolwidth(int r_Icolwidth)
	{
		this.icolwidth=r_Icolwidth;
	}

		
	/**
	 * @return return ialign
	 */
	public int getIalign()
	{
		return this.ialign;
	}

	/**
	 * @param r_Ialign
	 *     set ialign
	 */
	public void setIalign(int r_Ialign)
	{
		this.ialign=r_Ialign;
	}

		
	/**
	 * @return return bshow
	 */
	public int getBshow()
	{
		return this.bshow;
	}

	/**
	 * @param r_Bshow
	 *     set bshow
	 */
	public void setBshow(int r_Bshow)
	{
		this.bshow=r_Bshow;
	}

		
	/**
	 * @return return ino
	 */
	public int getIno()
	{
		return this.ino;
	}

	/**
	 * @param r_Ino
	 *     set ino
	 */
	public void setIno(int r_Ino)
	{
		this.ino=r_Ino;
	}

		
	/**
	 * @return return bsearch
	 */
	public int getBsearch()
	{
		return this.bsearch;
	}

	/**
	 * @param r_Bsearch
	 *     set bsearch
	 */
	public void setBsearch(int r_Bsearch)
	{
		this.bsearch=r_Bsearch;
	}

	public String isCshfield() {
		return cshfield;
	}

	public void setCshfield(String cshfield) {
		this.cshfield = cshfield;
	}

		
	
}