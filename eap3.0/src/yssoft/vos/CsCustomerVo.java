/**    
 *
 * 文件名：AcListclmVo.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-8-16    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.vos;

import java.util.Date;

/**
 *     
 * 项目名称：yscrm    
 * 类名称：CsCustomerVo    
 * 类描述：    
 * 创建人：zhong_jing 
 * 创建时间：2011-9-12 下午07:35:30        
 *
 */
public class CsCustomerVo {
	
	//内码
	private int iid;
	
	//客商编码
	private String ccode;
	
	//客商名称
	private String cname;
	
	//cmnemonic	助记码
	private String cmnemonic;
	
	//状态
	private int istatus;
	
	//客商属性
	private int iproperty;
	
	//客商分类
	private int icustclass;
	
	//客商分组
	private int icustgroup;
	
	//商务关系
	private int ipartnership;
	
	//客商性质
	private int iownership;
	
	//客商行业
	private int iindustry;
	
	//主营业务
	private int ibusiness;
	
	//客商来源
	private int isource;
	
	//客商来源
	private String cwebsite;
	
	//股票代码
	private String cstockcode;
	
	//组织形式
	private int iorganization;
	
	//上级单位
	private int iheadcust;
	
	//下级单位数
	private int isubsidiary;
	
	//单位规模
	private int ifirmsize;
	
	//人员规模
	private int istaffsize;
	
	//注册资金
	private String cregistcapital;
	
	//年营业额
	private String cannualturnover;
	
	//客户关系
	private int irelationship;
	
	//价值级别
	private int ivaluelevel;
	
	//销售状态
	private int isalesstatus;
	
	//商机进程
	private int isalesprocess;
	
	//客户热度
	private int ifiery;
	
	//国家
	private int icountry;
	
	//省份
	private int iprovince;
	
	//城市
	private int icity;
	
	//县区
	private int icounty;
	
	//乡镇/街道
	private int itown;
	
	//办公地址
	private String cofficeaddress;
	
	//办公邮编
	private String cofficezipcode;
	
	//发货地址
	private String cshipaddress;
	
	//发货邮编
	private String cshipzipcode;
	
	//交通路线
	private String croute;
	
	//单位电话
	private String ctel;
	
	//单位传真
	private String cfax;
	
	//单位邮箱
	private String cemail;
	
	//主联系人
	private int ikeycontacts;
	
	//业务结构
	private int ibusnstructure;
	
	//销售区域
	private int isalesarea;
	
	//销售部门
	private int isalesdepart;
	
	//销售人员
	private int isalesperson;
	
	//信用级别
	private int icreditrating;
	
	//信用额
	private float fcredit;
	
	//销售折扣
	private float fdiscount;
	
	//销售厂商
	private String csalescompanies;
	
	//已购产品概要
	private String cpurchased;
	
	//已购产品序列号
	private String cpurchasedserial;
	
	//产品使用效果
	private String cproducteffect;
	
	//购买意向
	private String cpurchaseintention;
	
	//服务部门
	private int iservicesdepart;
	
	//服务人员
	private int iservicesperson;
	
	//服务级别
	private int iservicelevel;
	
	//服务收费难易
	private String ceaseofcharges;
	
	//是否服务回访
	private boolean bsvmonitor;
	
	//开票单位名称
	private String ctaxname;
	
	//纳税人识别号
	private String ctaxno;
	
	//开票地址
	private String ctaxaddress;
	
	//开票电话
	private String ctaxtel;
	
	//开票银行
	private String ctaxbank;
	
	//开票银行账号
	private String ctaxbankcode;
	
	//开户银行
	private String cbank;
	
	//银行账号
	private String cbankcode;
	
	//客户开发时间
	private Date  ddevelopment;
	
	//客户开发人员
	private int idevelopperson;
	
	//备注
	private String cmemo;

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

	public String getCmnemonic() {
		return cmnemonic;
	}

	public void setCmnemonic(String cmnemonic) {
		this.cmnemonic = cmnemonic;
	}

	public int getIstatus() {
		return istatus;
	}

	public void setIstatus(int istatus) {
		this.istatus = istatus;
	}

	public int getIproperty() {
		return iproperty;
	}

	public void setIproperty(int iproperty) {
		this.iproperty = iproperty;
	}

	public int getIcustclass() {
		return icustclass;
	}

	public void setIcustclass(int icustclass) {
		this.icustclass = icustclass;
	}

	public int getIcustgroup() {
		return icustgroup;
	}

	public void setIcustgroup(int icustgroup) {
		this.icustgroup = icustgroup;
	}

	public int getIpartnership() {
		return ipartnership;
	}

	public void setIpartnership(int ipartnership) {
		this.ipartnership = ipartnership;
	}

	public int getIownership() {
		return iownership;
	}

	public void setIownership(int iownership) {
		this.iownership = iownership;
	}

	public int getIindustry() {
		return iindustry;
	}

	public void setIindustry(int iindustry) {
		this.iindustry = iindustry;
	}

	public int getIbusiness() {
		return ibusiness;
	}

	public void setIbusiness(int ibusiness) {
		this.ibusiness = ibusiness;
	}

	public int getIsource() {
		return isource;
	}

	public void setIsource(int isource) {
		this.isource = isource;
	}

	public String getCwebsite() {
		return cwebsite;
	}

	public void setCwebsite(String cwebsite) {
		this.cwebsite = cwebsite;
	}

	public String getCstockcode() {
		return cstockcode;
	}

	public void setCstockcode(String cstockcode) {
		this.cstockcode = cstockcode;
	}

	public int getIorganization() {
		return iorganization;
	}

	public void setIorganization(int iorganization) {
		this.iorganization = iorganization;
	}

	public int getIheadcust() {
		return iheadcust;
	}

	public void setIheadcust(int iheadcust) {
		this.iheadcust = iheadcust;
	}

	public int getIsubsidiary() {
		return isubsidiary;
	}

	public void setIsubsidiary(int isubsidiary) {
		this.isubsidiary = isubsidiary;
	}

	public int getIfirmsize() {
		return ifirmsize;
	}

	public void setIfirmsize(int ifirmsize) {
		this.ifirmsize = ifirmsize;
	}

	public int getIstaffsize() {
		return istaffsize;
	}

	public void setIstaffsize(int istaffsize) {
		this.istaffsize = istaffsize;
	}

	public String getCregistcapital() {
		return cregistcapital;
	}

	public void setCregistcapital(String cregistcapital) {
		this.cregistcapital = cregistcapital;
	}

	public String getCannualturnover() {
		return cannualturnover;
	}

	public void setCannualturnover(String cannualturnover) {
		this.cannualturnover = cannualturnover;
	}

	public int getIrelationship() {
		return irelationship;
	}

	public void setIrelationship(int irelationship) {
		this.irelationship = irelationship;
	}

	public int getIvaluelevel() {
		return ivaluelevel;
	}

	public void setIvaluelevel(int ivaluelevel) {
		this.ivaluelevel = ivaluelevel;
	}

	public int getIsalesstatus() {
		return isalesstatus;
	}

	public void setIsalesstatus(int isalesstatus) {
		this.isalesstatus = isalesstatus;
	}

	public int getIsalesprocess() {
		return isalesprocess;
	}

	public void setIsalesprocess(int isalesprocess) {
		this.isalesprocess = isalesprocess;
	}

	public int getIfiery() {
		return ifiery;
	}

	public void setIfiery(int ifiery) {
		this.ifiery = ifiery;
	}

	public int getIcountry() {
		return icountry;
	}

	public void setIcountry(int icountry) {
		this.icountry = icountry;
	}

	public int getIprovince() {
		return iprovince;
	}

	public void setIprovince(int iprovince) {
		this.iprovince = iprovince;
	}

	public int getIcity() {
		return icity;
	}

	public void setIcity(int icity) {
		this.icity = icity;
	}

	public int getIcounty() {
		return icounty;
	}

	public void setIcounty(int icounty) {
		this.icounty = icounty;
	}

	public int getItown() {
		return itown;
	}

	public void setItown(int itown) {
		this.itown = itown;
	}

	public String getCofficeaddress() {
		return cofficeaddress;
	}

	public void setCofficeaddress(String cofficeaddress) {
		this.cofficeaddress = cofficeaddress;
	}

	public String getCofficezipcode() {
		return cofficezipcode;
	}

	public void setCofficezipcode(String cofficezipcode) {
		this.cofficezipcode = cofficezipcode;
	}

	public String getCshipaddress() {
		return cshipaddress;
	}

	public void setCshipaddress(String cshipaddress) {
		this.cshipaddress = cshipaddress;
	}

	public String getCshipzipcode() {
		return cshipzipcode;
	}

	public void setCshipzipcode(String cshipzipcode) {
		this.cshipzipcode = cshipzipcode;
	}

	public String getCroute() {
		return croute;
	}

	public void setCroute(String croute) {
		this.croute = croute;
	}

	public String getCtel() {
		return ctel;
	}

	public void setCtel(String ctel) {
		this.ctel = ctel;
	}

	public String getCfax() {
		return cfax;
	}

	public void setCfax(String cfax) {
		this.cfax = cfax;
	}

	public String getCemail() {
		return cemail;
	}

	public void setCemail(String cemail) {
		this.cemail = cemail;
	}

	public int getIkeycontacts() {
		return ikeycontacts;
	}

	public void setIkeycontacts(int ikeycontacts) {
		this.ikeycontacts = ikeycontacts;
	}

	public int getIbusnstructure() {
		return ibusnstructure;
	}

	public void setIbusnstructure(int ibusnstructure) {
		this.ibusnstructure = ibusnstructure;
	}

	public int getIsalesarea() {
		return isalesarea;
	}

	public void setIsalesarea(int isalesarea) {
		this.isalesarea = isalesarea;
	}

	public int getIsalesdepart() {
		return isalesdepart;
	}

	public void setIsalesdepart(int isalesdepart) {
		this.isalesdepart = isalesdepart;
	}

	public int getIsalesperson() {
		return isalesperson;
	}

	public void setIsalesperson(int isalesperson) {
		this.isalesperson = isalesperson;
	}

	public int getIcreditrating() {
		return icreditrating;
	}

	public void setIcreditrating(int icreditrating) {
		this.icreditrating = icreditrating;
	}

	public float getFcredit() {
		return fcredit;
	}

	public void setFcredit(float fcredit) {
		this.fcredit = fcredit;
	}

	public float getFdiscount() {
		return fdiscount;
	}

	public void setFdiscount(float fdiscount) {
		this.fdiscount = fdiscount;
	}

	public String getCsalescompanies() {
		return csalescompanies;
	}

	public void setCsalescompanies(String csalescompanies) {
		this.csalescompanies = csalescompanies;
	}

	public String getCpurchased() {
		return cpurchased;
	}

	public void setCpurchased(String cpurchased) {
		this.cpurchased = cpurchased;
	}

	public String getCpurchasedserial() {
		return cpurchasedserial;
	}

	public void setCpurchasedserial(String cpurchasedserial) {
		this.cpurchasedserial = cpurchasedserial;
	}

	public String getCproducteffect() {
		return cproducteffect;
	}

	public void setCproducteffect(String cproducteffect) {
		this.cproducteffect = cproducteffect;
	}

	public String getCpurchaseintention() {
		return cpurchaseintention;
	}

	public void setCpurchaseintention(String cpurchaseintention) {
		this.cpurchaseintention = cpurchaseintention;
	}

	public int getIservicesdepart() {
		return iservicesdepart;
	}

	public void setIservicesdepart(int iservicesdepart) {
		this.iservicesdepart = iservicesdepart;
	}

	public int getIservicesperson() {
		return iservicesperson;
	}

	public void setIservicesperson(int iservicesperson) {
		this.iservicesperson = iservicesperson;
	}

	public int getIservicelevel() {
		return iservicelevel;
	}

	public void setIservicelevel(int iservicelevel) {
		this.iservicelevel = iservicelevel;
	}

	public String getCeaseofcharges() {
		return ceaseofcharges;
	}

	public void setCeaseofcharges(String ceaseofcharges) {
		this.ceaseofcharges = ceaseofcharges;
	}

	public boolean isBsvmonitor() {
		return bsvmonitor;
	}

	public void setBsvmonitor(boolean bsvmonitor) {
		this.bsvmonitor = bsvmonitor;
	}

	public String getCtaxname() {
		return ctaxname;
	}

	public void setCtaxname(String ctaxname) {
		this.ctaxname = ctaxname;
	}

	public String getCtaxno() {
		return ctaxno;
	}

	public void setCtaxno(String ctaxno) {
		this.ctaxno = ctaxno;
	}

	public String getCtaxaddress() {
		return ctaxaddress;
	}

	public void setCtaxaddress(String ctaxaddress) {
		this.ctaxaddress = ctaxaddress;
	}

	public String getCtaxtel() {
		return ctaxtel;
	}

	public void setCtaxtel(String ctaxtel) {
		this.ctaxtel = ctaxtel;
	}

	public String getCtaxbank() {
		return ctaxbank;
	}

	public void setCtaxbank(String ctaxbank) {
		this.ctaxbank = ctaxbank;
	}

	public String getCtaxbankcode() {
		return ctaxbankcode;
	}

	public void setCtaxbankcode(String ctaxbankcode) {
		this.ctaxbankcode = ctaxbankcode;
	}

	public String getCbank() {
		return cbank;
	}

	public void setCbank(String cbank) {
		this.cbank = cbank;
	}

	public String getCbankcode() {
		return cbankcode;
	}

	public void setCbankcode(String cbankcode) {
		this.cbankcode = cbankcode;
	}

	public Date getDdevelopment() {
		return ddevelopment;
	}

	public void setDdevelopment(Date ddevelopment) {
		this.ddevelopment = ddevelopment;
	}

	public int getIdevelopperson() {
		return idevelopperson;
	}

	public void setIdevelopperson(int idevelopperson) {
		this.idevelopperson = idevelopperson;
	}

	public String getCmemo() {
		return cmemo;
	}

	public void setCmemo(String cmemo) {
		this.cmemo = cmemo;
	}
}
