/**    
 *
 * 文件名：WfNodeVo.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-8-23    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.vos;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：WfNodeVo    
 * 类描述：    
 * 创建人: ZMM
 * 创建时间：2011-2011-8-23 下午06:43:46        
 *     
 */
public class WfNodeVo {
	private int iid;
	private int  ipid;
	private String inodeid;
	private String ipnodeid;
	private int inodelevel;
	private int ioainvoice;
	private int inodetype;
	private int inodevalue;
	private int inodeattribute;
	private int inodemode;
	private int bfinalverify;
	private int baddnew;
	private int bsendnew;
	private int istatus;
	private String cnotice;
	//private int iistatus;
	private Integer iistatus;
	
	private int nodesIstatus; // wf_nodes 下当前用户节点的 状态
	private String source;	// 标示该节点是来自 wf_node 表 还是 wf_nodes表，只有在 组织节点时有效
	
	private int iinvoset;
	
	private String ccomefield;
	private int bavailable=0;
    private String cexecsql;
    private int baddnode;

    public String getCexecsql() {
        return cexecsql;
    }

    public void setCexecsql(String cexecsql) {
        this.cexecsql = cexecsql;
    }
	
	public String getCcomefield() {
		return ccomefield;
	}
	public void setCcomefield(String ccomefield) {
		this.ccomefield = ccomefield;
	}
	public int getIinvoset() {
		return iinvoset;
	}
	public void setIinvoset(int iinvoset) {
		this.iinvoset = iinvoset;
	}
	public int getBaddnode() {
		return baddnode;
	}
	public void setBaddnode(int baddnode) {
		this.baddnode = baddnode;
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
	public int getInodelevel() {
		return inodelevel;
	}
	public void setInodelevel(int inodelevel) {
		this.inodelevel = inodelevel;
	}
	public int getIoainvoice() {
		return ioainvoice;
	}
	public void setIoainvoice(int ioainvoice) {
		this.ioainvoice = ioainvoice;
	}
	public int getInodetype() {
		return inodetype;
	}
	public void setInodetype(int inodetype) {
		this.inodetype = inodetype;
	}
	public int getInodevalue() {
		return inodevalue;
	}
	public void setInodevalue(int inodevalue) {
		this.inodevalue = inodevalue;
	}
	public int getInodeattribute() {
		return inodeattribute;
	}
	public void setInodeattribute(int inodeattribute) {
		this.inodeattribute = inodeattribute;
	}
	public int getInodemode() {
		return inodemode;
	}
	public void setInodemode(int inodemode) {
		this.inodemode = inodemode;
	}
	public int getBfinalverify() {
		return bfinalverify;
	}
	public void setBfinalverify(int bfinalverify) {
		this.bfinalverify = bfinalverify;
	}
	public int getBaddnew() {
		return baddnew;
	}
	public void setBaddnew(int baddnew) {
		this.baddnew = baddnew;
	}
	public int getBsendnew() {
		return bsendnew;
	}
	public void setBsendnew(int bsendnew) {
		this.bsendnew = bsendnew;
	}
	public int getIstatus() {
		return istatus;
	}
	public void setIstatus(int istatus) {
		this.istatus = istatus;
	}
	public String getCnotice() {
		return cnotice;
	}
	public void setCnotice(String cnotice) {
		this.cnotice = cnotice;
	}
	public String getInodeid() {
		return inodeid;
	}
	public void setInodeid(String inodeid) {
		this.inodeid = inodeid;
	}
	public String getIpnodeid() {
		return ipnodeid;
	}
	public void setIpnodeid(String ipnodeid) {
		this.ipnodeid = ipnodeid;
	}
	public int getNodesIstatus() {
		return nodesIstatus;
	}
	public void setNodesIstatus(int nodesIstatus) {
		this.nodesIstatus = nodesIstatus;
	}
	public String getSource() {
		return source;
	}
	public void setSource(String source) {
		this.source = source;
	}
	public int getBavailable() {
		return bavailable;
	}
	public void setBavailable(int bavailable) {
		this.bavailable = bavailable;
	}
    public Integer getIistatus() {
        return iistatus;
    }

    public void setIistatus(Integer iistatus) {
        this.iistatus = iistatus;
    }


}
