/**
 * 模块名称：AcNumberSetVO
 * 模块说明：Java中对应的单据编码实体类
 * 创建人：	YJ
 * 创建日期：20110828
 * 修改人：
 * 修改日期：
 *
 */
package yssoft.vos;

@SuppressWarnings("serial")//关闭类或方法级别的编译器警告
public class AcNumberSetVO implements java.io.Serializable{

	public  int iid;				//内码

	public  int ifuncregedit;		//注册功能单据内码
	
	public  int itype;				//编码类型
		
	public  int bedit;				//自动编码是否允许修改
	
	public  String cprefix1;		//前缀1
	
	public  String cprefix1value;	//前缀1值
	
	public  int bprefix1rule;		//前缀1是否流水依据
	
	public  String cprefix2;		//前缀2
	
	public  String cprefix2value;	//前缀2值
	
	public  int bprefix2rule;		//前缀2是否流水依据
	
	public  String cprefix3;		//前缀3
	
	public  String cprefix3value;	//前缀3值
	
	public  int bprefix3rule;		//前缀3是否流水依据
	
	public  int ilength;			//流水号长度
	
	public  int istep;				//流水号步长
	
	public 	 int ibegin;			//流水号起始值
	
	public AcNumberSetVO(){}
	
	public AcNumberSetVO(int iid,int ifuncregedit,int itype,int bedit,String cprefix1,String cprefix1value,
						  int bprefix1rule,String cprefix2,String cprefix2value,int bprefix2rule,
						  String cprefix3,String cprefix3value,int bprefix3rule,int ilength,int istep,int ibegin){
		this.iid = iid;
		this.ifuncregedit = ifuncregedit;
		this.itype = itype;
		this.bedit = bedit;
		this.cprefix1 = cprefix1;
		this.cprefix1value = cprefix1value;
		this.bprefix1rule =bprefix1rule;
		this.cprefix2 = cprefix1;
		this.cprefix2value = cprefix1value;
		this.bprefix2rule =bprefix1rule;
		this.cprefix3 = cprefix1;
		this.cprefix3value = cprefix1value;
		this.bprefix3rule =bprefix1rule;
		this.ilength = ilength;
		this.istep = istep;
		this.ibegin = ibegin;
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

	public int getItype() {
		return itype;
	}

	public void setItype(int itype) {
		this.itype = itype;
	}

	public int getBedit() {
		return bedit;
	}

	public void setBedit(int bedit) {
		this.bedit = bedit;
	}

	public String getCprefix1() {
		return cprefix1;
	}

	public void setCprefix1(String cprefix1) {
		this.cprefix1 = cprefix1;
	}

	public String getCprefix1value() {
		return cprefix1value;
	}

	public void setCprefix1value(String cprefix1value) {
		this.cprefix1value = cprefix1value;
	}

	public int getBprefix1rule() {
		return bprefix1rule;
	}

	public void setBprefix1rule(int bprefix1rule) {
		this.bprefix1rule = bprefix1rule;
	}

	public String getCprefix2() {
		return cprefix2;
	}

	public void setCprefix2(String cprefix2) {
		this.cprefix2 = cprefix2;
	}

	public String getCprefix2value() {
		return cprefix2value;
	}

	public void setCprefix2value(String cprefix2value) {
		this.cprefix2value = cprefix2value;
	}

	public int getBprefix2rule() {
		return bprefix2rule;
	}

	public void setBprefix2rule(int bprefix2rule) {
		this.bprefix2rule = bprefix2rule;
	}

	public String getCprefix3() {
		return cprefix3;
	}

	public void setCprefix3(String cprefix3) {
		this.cprefix3 = cprefix3;
	}

	public String getCprefix3value() {
		return cprefix3value;
	}

	public void setCprefix3value(String cprefix3value) {
		this.cprefix3value = cprefix3value;
	}

	public int getBprefix3rule() {
		return bprefix3rule;
	}

	public void setBprefix3rule(int bprefix3rule) {
		this.bprefix3rule = bprefix3rule;
	}

	public int getIlength() {
		return ilength;
	}

	public void setIlength(int ilength) {
		this.ilength = ilength;
	}

	public int getIstep() {
		return istep;
	}

	public void setIstep(int istep) {
		this.istep = istep;
	}

	public int getIbegin() {
		return ibegin;
	}

	public void setIbegin(int ibegin) {
		this.ibegin = ibegin;
	}
	
	
}
