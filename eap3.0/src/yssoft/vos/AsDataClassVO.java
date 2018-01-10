/**
 * 模块名称：AsDataClassVO
 * 模块说明：Java中对应的档案分类实体类
 * 创建人：	YJ
 * 创建日期：20110822
 * 修改人：
 * 修改日期：
 *
 */

package yssoft.vos;

public class AsDataClassVO implements java.io.Serializable{
	
	public int iid;			//主键
	
	public int ipid;			//上级内码
	
	public String ccode;		//编码
	
	public String cname;		//名称
	
	public int bsystem;		//是否系统档案
	
	public String coperauth;	//操作权限控制
	
	public String cmemo;		//备注
	
	public int bbuse;			//是否启用
	
	public String oldCcode;		//旧编码
	
	public AsDataClassVO(){}
	
	public AsDataClassVO(int iid,int ipid,String ccode,String cname,int bsystem,int bbuse,String coperauth,String cmemo){
		this.iid = iid;
		this.ipid = ipid;
		this.ccode = ccode;
		this.cname = cname;
		this.bsystem = bsystem;
		this.coperauth = coperauth;
		this.bbuse = bbuse;
		this.cmemo = cmemo;
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

	public int getBsystem() {
		return bsystem;
	}

	public void setBsystem(int bsystem) {
		this.bsystem = bsystem;
	}

	public String getCoperauth() {
		return coperauth;
	}

	public void setCoperauth(String coperauth) {
		this.coperauth = coperauth;
	}

	public String getCmemo() {
		return cmemo;
	}

	public void setCmemo(String cmemo) {
		this.cmemo = cmemo;
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
	
	
}
