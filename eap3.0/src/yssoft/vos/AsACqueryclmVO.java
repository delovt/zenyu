/**
 * 模块名称：AsACqueryclmVO
 * 模块说明：查询条件配置表实体类
 * 创建人：	YJ
 * 创建日期：20110815
 * 修改人：
 * 修改日期：
 * 
 */
package yssoft.vos;

public class AsACqueryclmVO implements java.io.Serializable {
	
	public int iid;				 //内码		
	
	public int ifuncregedit;		//注册程序内码		
	
	public String cfield;       	//字段名	
	
	public String ccaption;		//字段标题		
	
	public String ifieldtype;			//字段类型		
	
	public int iconsult;			//参照窗体		
	
	public String cconsultbkfld;	//参照返回存入字段
	
	public String cconsultswfld;	//参照返回显示字段	
	
	public int iqryno;				//查询优先序号	
	
	public int bcommon;			//是否常用条件	
	
	public String icmtype;			//常用条件类型
	
	public int isortno;			//排序优先序号
	
	public int isttype;			//排序类型
	
	public AsACqueryclmVO(){}
	
	/**
	 * 
	 * 创建一个新的实例 AsACqueryclmVO    
	 *
	 */
	public AsACqueryclmVO(int iid, int ifuncregedit, String cfield, String ccaption, String ifieldtype,
						   int iconsult,String cconsultbkfld,String cconsultswfld,int iqryno,int bcommon,
						   String icmtype,int isortno,int isttype) {
		this.iid = iid;
		this.ifuncregedit = ifuncregedit;
		this.cfield = cfield;
		this.ccaption = ccaption;
		this.ifieldtype = ifieldtype;
		this.iconsult = iconsult;
		this.cconsultbkfld = cconsultbkfld;
		this.cconsultswfld = cconsultswfld;
		this.iqryno = iqryno; 
		this.bcommon = bcommon;
		this.icmtype = icmtype;
		this.icmtype = icmtype;
		this.isttype = isttype;
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

	public String getCfield() {
		return cfield;
	}

	public void setCfield(String cfield) {
		this.cfield = cfield;
	}

	public String getCcaption() {
		return ccaption;
	}

	public void setCcaption(String ccaption) {
		this.ccaption = ccaption;
	}

	public String getIfieldtype() {
		return ifieldtype;
	}

	public void setIfieldtype(String ifieldtype) {
		this.ifieldtype = ifieldtype;
	}

	public int getIconsult() {
		return iconsult;
	}

	public void setIconsult(int iconsult) {
		this.iconsult = iconsult;
	}

	public String getCconsultbkfld() {
		return cconsultbkfld;
	}

	public void setCconsultbkfld(String cconsultbkfld) {
		this.cconsultbkfld = cconsultbkfld;
	}

	public String getCconsultswfld() {
		return cconsultswfld;
	}

	public void setCconsultswfld(String cconsultswfld) {
		this.cconsultswfld = cconsultswfld;
	}

	public int getIqryno() {
		return iqryno;
	}

	public void setIqryno(int iqryno) {
		this.iqryno = iqryno;
	}

	public int getBcommon() {
		return bcommon;
	}

	public void setBcommon(int bcommon) {
		this.bcommon = bcommon;
	}

	public String getIcmtype() {
		return icmtype;
	}

	public void setIcmtype(String icmtype) {
		this.icmtype = icmtype;
	}

	public int getIsortno() {
		return isortno;
	}

	public void setIsortno(int isortno) {
		this.isortno = isortno;
	}

	public int getIsttype() {
		return isttype;
	}

	public void setIsttype(int isttype) {
		this.isttype = isttype;
	}
	

}
