package yssoft.vos;

public class AsFuncregeditVO implements java.io.Serializable {

	private int iid;			 //内码		

	private int ipid;			//父级内码		
	
	private String ccode;     //编码		
	
	private String cname;		//功能模块名称		
	
	private String cprogram;		//程序路径		
	
	private int ifuncregedit;		//列表式程序对应的列表参数ID
	
	private String ctable;		//程序对应主数据表		
	
	private int iworkflow;		//默认工作流ID		
	
	private int iform;			//默认UI界面ID		
	
	private String coperauth;	//浏览操作权限控制		
	
	private String cdataauth;	//浏览数据权限控制
	
	private int boperauth;	 //是否参与操作权限管理		
	
	private int bdataauth;	 //是否参与数据权限管理
	
	private int bdataauth1;	 //是否参与组织权限管理
	
	private int bdataauth2;	 //是否参与客户权限管理
	
	private int brepeat;		//是否允许多次创建
	
    private int brelation;   //是否参与相关对象管理
    
	private int bdictionary;	//是否参与数据字典管理
	
	private int bnumber;		//是否参与单据编码管理
	
	private int bquery;			//是否参与查询条件定制
	
	private int blist;			//是否参与列表定制
	
	private int bprint;			//是否参与打印设置管理
	
	private String oldCcode;		//旧编码
	
	private boolean bworkflow; //是否参与工作流程管理
	
	private String cparameter; //程序参数
	
	public int iimage;	      //功能图标
	
	public int bvouchform;	  //是否参与表单界面配置
	
	public int buse;		  //生效\失效
	
	public int bbind;		  //是否参与单据关系定制
	
	public String ccaptionfield;
	
	public int bworkflowmodify;          //发起工作流后是否允许修改
	
	public AsFuncregeditVO(){}
	
	/**
	 * 
	 * 创建一个新的实例 AsFuncregeditVO    
	 *
	 */
	public AsFuncregeditVO(int iid, int ipid, String ccode, String cname, String cprogram,
							String ctable,int brepeat,int iworkflow,int iform,String coperauth,
							String cdataauth,int bdictionary,int bnumber,int bquery,int blist,int boperauth,int bdataauth,int bdataauth1,
							int bdataauth2,int brelation,int bprint,String cparameter,int iimage,int bvouchform,int buse,int bbind,int bworkflowmodify) {
		this.iid = iid;
		this.ipid = ipid;
		this.ccode = ccode;
		this.cname = cname;
		this.cprogram = cprogram;
		this.ctable = ctable;
		this.brepeat = brepeat;
		this.iworkflow = iworkflow;
		this.iform = iform; 
		this.coperauth = coperauth;
		this.cdataauth = cdataauth;
		this.bdictionary = bdictionary;
		this.bnumber = bnumber;
		this.bquery = bquery;
		this.blist = blist;
		this.boperauth=boperauth;
		this.bdataauth=bdataauth;
		this.bdataauth1=bdataauth1;
		this.bdataauth2=bdataauth2;
		this.brelation=brelation;
		this.bprint=bprint;
		this.cparameter=cparameter;
		this.iimage=iimage;
		this.bvouchform=bvouchform;
		this.buse=buse;
		this.bbind=bbind;
		this.bworkflowmodify=bworkflowmodify;
	}
	
	

	public String getCparameter() {
		return cparameter;
	}

	public void setCparameter(String cparameter) {
		this.cparameter = cparameter;
	}


	public int getIfuncregedit() {
		return ifuncregedit;
	}

	public void setIfuncregedit(int ifuncregedit) {
		this.ifuncregedit = ifuncregedit;
	}

	public boolean isBworkflow() {
		return bworkflow;
	}

	public void setBworkflow(boolean bworkflow) {
		this.bworkflow = bworkflow;
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

	public String getCprogram() {
		return cprogram;
	}

	public void setCprogram(String cprogram) {
		this.cprogram = cprogram;
	}

	public String getCtable() {
		return ctable;
	}

	public void setCtable(String ctable) {
		this.ctable = ctable;
	}

	public int getIworkflow() {
		return iworkflow;
	}

	public void setIworkflow(int iworkflow) {
		this.iworkflow = iworkflow;
	}

	public int getIform() {
		return iform;
	}

	public void setIform(int iform) {
		this.iform = iform;
	}

	public String getCoperauth() {
		return coperauth;
	}

	public void setCoperauth(String coperauth) {
		this.coperauth = coperauth;
	}

	
	
	public int getBrepeat() {
		return brepeat;
	}

	public void setBrepeat(int brepeat) {
		this.brepeat = brepeat;
	}

	public String getCdataauth() {
		return cdataauth;
	}

	public void setCdataauth(String cdataauth) {
		this.cdataauth = cdataauth;
	}

	public int getBdictionary() {
		return bdictionary;
	}

	public void setBdictionary(int bdictionary) {
		this.bdictionary = bdictionary;
	}

	public int getBnumber() {
		return bnumber;
	}

	public void setBnumber(int bnumber) {
		this.bnumber = bnumber;
	}

	public int getBquery() {
		return bquery;
	}

	public void setBquery(int bquery) {
		this.bquery = bquery;
	}

	public int getBlist() {
		return blist;
	}

	public void setBlist(int blist) {
		this.blist = blist;
	}	
	
	public String getOldCcode() {
		return oldCcode;
	}

	public void setOldCcode(String oldCcode) {
		this.oldCcode = oldCcode;
	}

	public int getBoperauth() {
		return boperauth;
	}

	public void setBoperauth(int boperauth) {
		this.boperauth = boperauth;
	}

	public int getBdataauth() {
		return bdataauth;
	}

	public void setBdataauth(int bdataauth) {
		this.bdataauth = bdataauth;
	}

	public int getBrelation() {
		return brelation;
	}

	public void setBrelation(int brelation) {
		this.brelation = brelation;
	}

	public int getBdataauth1() {
		return bdataauth1;
	}

	public void setBdataauth1(int bdataauth1) {
		this.bdataauth1 = bdataauth1;
	}

	public int getBdataauth2() {
		return bdataauth2;
	}

	public void setBdataauth2(int bdataauth2) {
		this.bdataauth2 = bdataauth2;
	}

	public void setBprint(int bprint) {
		this.bprint = bprint;
	}

	public int getBprint() {
		return bprint;
	}
    
	public int getIimage() {
		return iimage;
	}

	public void setIimage(int iimage) {
		this.iimage = iimage;
	}

	public int getBvouchform() {
		return bvouchform;
	}

	public void setBvouchform(int bvouchform) {
		this.bvouchform = bvouchform;
	}

	public int getBuse() {
		return buse;
	}

	public void setBuse(int buse) {
		this.buse = buse;
	}
	public int getBbind() {
		return bbind;
	}

	public void setBbind(int bbind) {
		this.bbind = bbind;
	}
	
	public int getBworkflowmodify() {
		return bworkflowmodify;
	}

	public void setBworkflowmodify(int bworkflowmodify) {
		this.bworkflowmodify = bworkflowmodify;
	}

}
