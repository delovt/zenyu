/**    
 *
 * 文件名：CsCustpersonVo.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-9-12    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.vos;

import java.util.Date;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：CsCustpersonVo    
 * 类描述：    
 * 创建人：zhong_jing 
 * 创建时间：2011-9-12 下午08:30:42        
 *     
 */
public class CsCustpersonVo {

	//内码
	private int iid;
	//编码
	private String ccode;
	//姓名
	private String cname;
	//称谓
	private String ctitle;
	//所属分类
	private int icustpnclass;
	//所属客商
	private int icustomer;
	//是否单位负责人
	private boolean bcharge;
	//是否主联系人
	private boolean bkeycontect;
	//部门
	private String cdepartment;
	//职务
	private String cpost;
	//上级领导
	private int isuperiors;
	//助理秘书
	private int iassistant;
	//性别
	private int isex;
	//生日
	private Date dbirthday;
	//民族
	private String cnation;
	//学历
	private String ceducation;
	//专业
	private String cprofessional;
	//身份证号
	private String cidnumber;
	//联系电话
	private String ctel;
	//手机1
	private String cmobile1;
	//手机2
	private String cmobile2;
	//电子邮件
	private String cemail;
	//QQ/MSN
	private String cqqmsn;
	//传真
	private String cfax;
	//通讯地址
	private String caddress;
	//邮编
	private String czipcode;
	//车辆车牌
	private String ccarnumber;
	//婚姻状况
	private String cmarital;
	//配偶姓名
	private String cspouse;
	//配偶工作单位
	private String cspouseworkunit;
	//配偶部门职务
	private String cspousepost;
	//配偶联系电话
	private String cspousetel;
	//其他家庭成员概述
	private String cfamilymembers;
	//籍贯
	private String cbirthplace;
	//毕业院校
	private String cgraduated;
	//性格
	private String ccharacter;
	//爱好
	private String chobby;
	//生活习惯
	private String chabit;
	//客户关系
	private String crelationship;
	//朋友关系
	private String cfriendships;
	
	public int getIid() {
		return iid;
	}
	public void setIid(int iid) {
		this.iid = iid;
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
	public String getCtitle() {
		return ctitle;
	}
	public void setCtitle(String ctitle) {
		this.ctitle = ctitle;
	}
	public int getIcustpnclass() {
		return icustpnclass;
	}
	public void setIcustpnclass(int icustpnclass) {
		this.icustpnclass = icustpnclass;
	}
	public int getIcustomer() {
		return icustomer;
	}
	public void setIcustomer(int icustomer) {
		this.icustomer = icustomer;
	}
	public boolean isBcharge() {
		return bcharge;
	}
	public void setBcharge(boolean bcharge) {
		this.bcharge = bcharge;
	}
	public boolean isBkeycontect() {
		return bkeycontect;
	}
	public void setBkeycontect(boolean bkeycontect) {
		this.bkeycontect = bkeycontect;
	}
	public String getCdepartment() {
		return cdepartment;
	}
	public void setCdepartment(String cdepartment) {
		this.cdepartment = cdepartment;
	}
	public String getCpost() {
		return cpost;
	}
	public void setCpost(String cpost) {
		this.cpost = cpost;
	}
	public int getIsuperiors() {
		return isuperiors;
	}
	public void setIsuperiors(int isuperiors) {
		this.isuperiors = isuperiors;
	}
	public int getIassistant() {
		return iassistant;
	}
	public void setIassistant(int iassistant) {
		this.iassistant = iassistant;
	}
	public int getIsex() {
		return isex;
	}
	public void setIsex(int isex) {
		this.isex = isex;
	}
	public Date getDbirthday() {
		return dbirthday;
	}
	public void setDbirthday(Date dbirthday) {
		this.dbirthday = dbirthday;
	}
	public String getCnation() {
		return cnation;
	}
	public void setCnation(String cnation) {
		this.cnation = cnation;
	}
	public String getCeducation() {
		return ceducation;
	}
	public void setCeducation(String ceducation) {
		this.ceducation = ceducation;
	}
	public String getCprofessional() {
		return cprofessional;
	}
	public void setCprofessional(String cprofessional) {
		this.cprofessional = cprofessional;
	}
	public String getCidnumber() {
		return cidnumber;
	}
	public void setCidnumber(String cidnumber) {
		this.cidnumber = cidnumber;
	}
	public String getCtel() {
		return ctel;
	}
	public void setCtel(String ctel) {
		this.ctel = ctel;
	}
	public String getCmobile1() {
		return cmobile1;
	}
	public void setCmobile1(String cmobile1) {
		this.cmobile1 = cmobile1;
	}
	public String getCmobile2() {
		return cmobile2;
	}
	public void setCmobile2(String cmobile2) {
		this.cmobile2 = cmobile2;
	}
	public String getCemail() {
		return cemail;
	}
	public void setCemail(String cemail) {
		this.cemail = cemail;
	}
	public String getCqqmsn() {
		return cqqmsn;
	}
	public void setCqqmsn(String cqqmsn) {
		this.cqqmsn = cqqmsn;
	}
	public String getCfax() {
		return cfax;
	}
	public void setCfax(String cfax) {
		this.cfax = cfax;
	}
	public String getCaddress() {
		return caddress;
	}
	public void setCaddress(String caddress) {
		this.caddress = caddress;
	}
	public String getCzipcode() {
		return czipcode;
	}
	public void setCzipcode(String czipcode) {
		this.czipcode = czipcode;
	}
	public String getCcarnumber() {
		return ccarnumber;
	}
	public void setCcarnumber(String ccarnumber) {
		this.ccarnumber = ccarnumber;
	}
	public String getCmarital() {
		return cmarital;
	}
	public void setCmarital(String cmarital) {
		this.cmarital = cmarital;
	}
	public String getCspouse() {
		return cspouse;
	}
	public void setCspouse(String cspouse) {
		this.cspouse = cspouse;
	}
	public String getCspouseworkunit() {
		return cspouseworkunit;
	}
	public void setCspouseworkunit(String cspouseworkunit) {
		this.cspouseworkunit = cspouseworkunit;
	}
	public String getCspousepost() {
		return cspousepost;
	}
	public void setCspousepost(String cspousepost) {
		this.cspousepost = cspousepost;
	}
	public String getCspousetel() {
		return cspousetel;
	}
	public void setCspousetel(String cspousetel) {
		this.cspousetel = cspousetel;
	}
	public String getCfamilymembers() {
		return cfamilymembers;
	}
	public void setCfamilymembers(String cfamilymembers) {
		this.cfamilymembers = cfamilymembers;
	}
	public String getCbirthplace() {
		return cbirthplace;
	}
	public void setCbirthplace(String cbirthplace) {
		this.cbirthplace = cbirthplace;
	}
	public String getCgraduated() {
		return cgraduated;
	}
	public void setCgraduated(String cgraduated) {
		this.cgraduated = cgraduated;
	}
	public String getCcharacter() {
		return ccharacter;
	}
	public void setCcharacter(String ccharacter) {
		this.ccharacter = ccharacter;
	}
	public String getChobby() {
		return chobby;
	}
	public void setChobby(String chobby) {
		this.chobby = chobby;
	}
	public String getChabit() {
		return chabit;
	}
	public void setChabit(String chabit) {
		this.chabit = chabit;
	}
	public String getCrelationship() {
		return crelationship;
	}
	public void setCrelationship(String crelationship) {
		this.crelationship = crelationship;
	}
	public String getCfriendships() {
		return cfriendships;
	}
	public void setCfriendships(String cfriendships) {
		this.cfriendships = cfriendships;
	}
}
