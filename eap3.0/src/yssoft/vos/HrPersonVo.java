package yssoft.vos;

import org.apache.xpath.operations.Bool;

import java.util.Date;
import java.util.List;

public class HrPersonVo {

	// 内码
	private int iid;
	// 编码
	private String ccode;
	// 姓名
	private String cname;
	//昵称
	private String cnickname;
	// 在职状态
	private Boolean bjobstatus;
	// 操作员状态
	private Boolean busestatus;
	// 操作员账号
	private String cusecode;
	// 登录密码
	private String cusepassword;
	// 部门
	private Integer idepartment;
	// 职务
	private Integer ipost;
	// 主岗
	private Integer ijob1;
	// 副岗
	private Integer ijob2;
	// 性别
	private Integer isex;
	// 生日
	private Date dbirthday;
	// 学历
	private Integer ieducation;
	// 专业
	private String cdiscipline;
	// 电话
	private String ctel;
	// 手机1
	private String cmobile1;
	// 手机2
	private String cmobile2;
	// 电子邮件
	private String cemail;
	// 家庭地址
	private String chaddress;
	// 家庭电话
	private String chtel;
	// 备注
	private String cmemo;
	// 个性签名
	private String csignature;
	// 历史记录保存条数
	private String ihistoryoper;

	// 部门名称
	private String departcname;
	// ijob1 名称
	private String ijob1cname;
	// ijob2 名称
	private String ijob2cname;
	// 职务名称
	private String postcname;
	// 角色名称
	private String rolecname;
	// 角色 iid
	private String roleiid;
	// 角色 是否 可用
	private String rolebuse;
	//QQ
	public String cqq;
	
	//问题
	private String cquestion;
	//答案
	private String canswer;
	//首页注册码
	private String ihfuncregedit;
	//锁屏时间
	private Integer idscreenlock;
	
	//消息提醒确认方式
	private Integer iconfirmtype;
	
	//密码最后修改时间
	private String dpasswordchange;
	//是否允许多点登录

	private Boolean bmorelogin;
	
	private Boolean block;

	//是否清退时例外放行
	//private boolean  bnotremove;
	
	private String cip;
	private String cworkstation;
	private String sesssionid;
	
	private String clast; //最后一次登录地点
	private String dlast; //最后一次登录时间
	
	private List rolelist;//角色列表
	
	private String onlinetimestamp;
	private String keyid;
	private Boolean busbkey;
	
	//2013-03-25 XZQWJ 增加;存放加密锁ID
	private String cusbkey;
	
	private String keyRPwd;
	private String keyWPwd;
	
	private String cnote;

    public Integer icallline;
    public Boolean bcallout;
    public Boolean bisCloseOut;

    public Integer ilayout;

    public Integer getIlayout() {
        return ilayout;
    }

    public void setIlayout(Integer ilayout) {
        this.ilayout = ilayout;
    }

    public Integer getIcallline() {
        return icallline;
    }

    public Boolean getBisCloseOut() {
        return bisCloseOut;
    }

    public void setBisCloseOut(Boolean bisCloseOut) {
        this.bisCloseOut = bisCloseOut;
    }

    public Boolean getBcallout() {

        return bcallout;
    }

    public void setBcallout(Boolean bcallout) {
        this.bcallout = bcallout;
    }

    public void setIcallline(Integer icallline) {
        this.icallline = icallline;

    }

    public String getCusbkey() {
		return cusbkey;
	}
	public String getCqq() {
		return cqq;
	}

	public void setCqq(String cqq) {
		this.cqq = cqq;
	}

	public void setCusbkey(String cusbkey) {
		this.cusbkey = cusbkey;
	}
	
	public Boolean getBlock() {
		return block;
	}
	
	public void setBlock(Boolean block) {
		this.block = block;
	}

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

	public String getCnickname() {
		return cnickname;
	}

	public void setCnickname(String cnickname) {
		this.cnickname = cnickname;
	}

	public Boolean getBjobstatus() {
		return bjobstatus;
	}

	public void setBjobstatus(Boolean bjobstatus) {
		this.bjobstatus = bjobstatus;
	}

	public Boolean getBusestatus() {
		return busestatus;
	}

	public void setBusestatus(Boolean busestatus) {
		this.busestatus = busestatus;
	}

	public String getCusecode() {
		return cusecode;
	}

	public void setCusecode(String cusecode) {
		this.cusecode = cusecode;
	}

	public String getCusepassword() {
		return cusepassword;
	}

	public void setCusepassword(String cusepassword) {
		this.cusepassword = cusepassword;
	}

	public Integer getIdepartment() {
		return idepartment;
	}

	public void setIdepartment(Integer idepartment) {
		this.idepartment = idepartment;
	}

	public Integer getIpost() {
		return ipost;
	}

	public void setIpost(Integer ipost) {
		this.ipost = ipost;
	}

	public Integer getIjob1() {
		return ijob1;
	}

	public void setIjob1(Integer ijob1) {
		this.ijob1 = ijob1;
	}

	public Integer getIjob2() {
		return ijob2;
	}

	public void setIjob2(Integer ijob2) {
		this.ijob2 = ijob2;
	}

	public Integer getIsex() {
		return isex;
	}

	public void setIsex(Integer isex) {
		this.isex = isex;
	}

	public Date getDbirthday() {
		return dbirthday;
	}

	public void setDbirthday(Date dbirthday) {
		this.dbirthday = dbirthday;
	}

	public Integer getIeducation() {
		return ieducation;
	}

	public void setIeducation(Integer ieducation) {
		this.ieducation = ieducation;
	}

	public String getCdiscipline() {
		return cdiscipline;
	}

	public void setCdiscipline(String cdiscipline) {
		this.cdiscipline = cdiscipline;
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

	public String getChaddress() {
		return chaddress;
	}

	public void setChaddress(String chaddress) {
		this.chaddress = chaddress;
	}

	public String getChtel() {
		return chtel;
	}

	public void setChtel(String chtel) {
		this.chtel = chtel;
	}

	public String getCmemo() {
		return cmemo;
	}

	public void setCmemo(String cmemo) {
		this.cmemo = cmemo;
	}

	public String getCsignature() {
		return csignature;
	}

	public void setCsignature(String csignature) {
		this.csignature = csignature;
	}

	public String getIhistoryoper() {
		return ihistoryoper;
	}

	public void setIhistoryoper(String ihistoryoper) {
		this.ihistoryoper = ihistoryoper;
	}

	public String getDepartcname() {
		return departcname;
	}

	public void setDepartcname(String departcname) {
		this.departcname = departcname;
	}

	public String getIjob1cname() {
		return ijob1cname;
	}

	public void setIjob1cname(String ijob1cname) {
		this.ijob1cname = ijob1cname;
	}

	public String getIjob2cname() {
		return ijob2cname;
	}

	public void setIjob2cname(String ijob2cname) {
		this.ijob2cname = ijob2cname;
	}

	public String getPostcname() {
		return postcname;
	}

	public void setPostcname(String postcname) {
		this.postcname = postcname;
	}

	public String getRolecname() {
		return rolecname;
	}

	public void setRolecname(String rolecname) {
		this.rolecname = rolecname;
	}

	public String getRoleiid() {
		return roleiid;
	}

	public void setRoleiid(String roleiid) {
		this.roleiid = roleiid;
	}

	public String getRolebuse() {
		return rolebuse;
	}

	public void setRolebuse(String rolebuse) {
		this.rolebuse = rolebuse;
	}

	public String getCquestion() {
		return cquestion;
	}

	public void setCquestion(String cquestion) {
		this.cquestion = cquestion;
	}

	public String getCanswer() {
		return canswer;
	}

	public void setCanswer(String canswer) {
		this.canswer = canswer;
	}

	public String getIhfuncregedit() {
		return ihfuncregedit;
	}

	public void setIhfuncregedit(String ihfuncregedit) {
		this.ihfuncregedit = ihfuncregedit;
	}

	public Integer getIdscreenlock() {
		return idscreenlock;
	}

	public void setIdscreenlock(Integer idscreenlock) {
		this.idscreenlock = idscreenlock;
	}

	public Integer getIconfirmtype() {
		return iconfirmtype;
	}

	public void setIconfirmtype(Integer iconfirmtype) {
		this.iconfirmtype = iconfirmtype;
	}

	public String getDpasswordchange() {
		return dpasswordchange;
	}

	public void setDpasswordchange(String dpasswordchange) {
		this.dpasswordchange = dpasswordchange;
	}

	public Boolean getBmorelogin() {
		return bmorelogin;
	}

	public void setBmorelogin(Boolean bmorelogin) {
		this.bmorelogin = bmorelogin;
	}

	public String getCip() {
		return cip;
	}

	public void setCip(String cip) {
		this.cip = cip;
	}

	public String getCworkstation() {
		return cworkstation;
	}

	public void setCworkstation(String cworkstation) {
		this.cworkstation = cworkstation;
	}

	public String getSesssionid() {
		return sesssionid;
	}

	public void setSesssionid(String sesssionid) {
		this.sesssionid = sesssionid;
	}

	public String getClast() {
		return clast;
	}

	public void setClast(String clast) {
		this.clast = clast;
	}

	public String getDlast() {
		return dlast;
	}

	public void setDlast(String dlast) {
		this.dlast = dlast;
	}

	public List getRolelist() {
		return rolelist;
	}

	public void setRolelist(List rolelist) {
		this.rolelist = rolelist;
	}

	public String getOnlinetimestamp() {
		return onlinetimestamp;
	}

	public void setOnlinetimestamp(String onlinetimestamp) {
		this.onlinetimestamp = onlinetimestamp;
	}

	public String getKeyid() {
		return keyid;
	}

	public void setKeyid(String keyid) {
		this.keyid = keyid;
	}

	public Boolean getBusbkey() {
		return busbkey;
	}

	public void setBusbkey(Boolean busbkey) {
		this.busbkey = busbkey;
	}

	public String getKeyRPwd() {
		return keyRPwd;
	}

	public void setKeyRPwd(String keyRPwd) {
		this.keyRPwd = keyRPwd;
	}

	public String getKeyWPwd() {
		return keyWPwd;
	}

	public void setKeyWPwd(String keyWPwd) {
		this.keyWPwd = keyWPwd;
	}

	public String getCnote() {
		return cnote;
	}

	public void setCnote(String cnote) {
		this.cnote = cnote;
	}

	
	


}
