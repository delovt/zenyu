/**
 * 模块名称：AsDataVO
 * 模块说明：Java中对应的档案数据实体类
 * 创建人：	YJ
 * 创建日期：20110822
 * 修改人：
 * 修改日期：
 *
 */

package yssoft.vos;

public class AsDataVO implements java.io.Serializable{
	
	public int iid;			//主键	
	
	public int ipid;			//上级内码
	
	public String ccode;		//编码
	
	public String cname;		//名称
	
	public String cmnemonic;	//助记码
	
	public String cmemo;		//备注
	
	public String cabbreviation;//单据编码前缀
	
	public int bbuse;			//是否启用
	
	public String coutkey;		//外部系统内码
	
	public String oldCcode;		//旧编码
	
	public int iclass;			//所属分类
	
	public AsDataVO(){}
	
	public AsDataVO(int iid,int iclass,int ipid,String ccode,String cname,String cmnemonic,String cmemo,
					String cabbreviation,int bbuse,String coutkey){
		this.iid = iid;
		this.iclass = iclass;
		this.ipid = ipid;
		this.ccode = ccode;
		this.cname = cname;
		this.cmnemonic = cmnemonic;
		this.cmemo = cmemo;
		this.cabbreviation = cabbreviation;
		this.bbuse = bbuse;
		this.coutkey=coutkey;
	}

	public int getIid() {
		return iid;
	}

	public void setIid(int iid) {
		this.iid = iid;
	}

	public int getIclass() {
		return iclass;
	}

	public void setIclass(int iclass) {
		this.iclass = iclass;
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

	public String getCmnemonic() {
		return cmnemonic;
	}

	public void setCmnemonic(String cmnemonic) {
		this.cmnemonic = cmnemonic;
	}

	public String getCmemo() {
		return cmemo;
	}

	public void setCmemo(String cmemo) {
		this.cmemo = cmemo;
	}

	public String getCabbreviation() {
		return cabbreviation;
	}

	public void setCabbreviation(String cabbreviation) {
		this.cabbreviation = cabbreviation;
	}

	public String getOldCcode() {
		return oldCcode;
	}

	public void setOldCcode(String oldCcode) {
		this.oldCcode = oldCcode;
	}

	public int getBuse() {
		return bbuse;
	}

	public void setBuse(int bbuse) {
		this.bbuse = bbuse;
	}

	public String getCoutkey() {
		return coutkey;
	}

	public void setCoutkey(String coutkey) {
		this.coutkey = coutkey;
	}
}
