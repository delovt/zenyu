/**    
 *
 * 文件名：IWorkFlowService.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-8-19    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.services;

import yssoft.vos.OAinvoiceVo;
import yssoft.vos.WfNodeVo;

import java.util.HashMap;
import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：IWorkFlowService    
 * 类描述：工作流业务
 * 创建人：zmm
 * 创建时间：2011-2011-8-19 下午03:26:46        
 *     
 */
public interface IWorkFlowService {
	public int insertOAinvoice(Object params) 		throws Exception;
	public int insertWorkFlow(Object params) 		throws Exception;
	public int insertWorkFlowNode(Object params) 	throws Exception;
	public void insertNodeDetail(Object params) 	throws Exception;
	public List getNodeTypeDetail(Object params);
	public List getPersons(Object params);
	
	//获取协同数据
	public List getWorkFlows(Object params);
	
	//获取指定工作流节点信息
	public List getWorkFlowNodes(Object params);

    //获取指定节点的主子表iid
    public List getNodeAndNodes(HashMap params);

    //获取当前登录人对应的节点信息
    public List getCurNodeiid(HashMap params);

	//获取指定工作流节点 对应的详细信息
	public List getWorkFlowNodeDetails(Object params);
	//获取指定协同的 信息
	public OAinvoiceVo getWorkFlow(Object params);
	//分页
	public HashMap crmPage(HashMap params);
	//修改协同
	public String editWorkFlow(HashMap params) throws Exception;

    //插入节点时间信息
    public void insertWfTime(Boolean isNode,int iinvoice,int itype);

	//没有绘制，就直接修改,就是直接修改，发起人的信息
	public int zjEditWorkFlow(HashMap params) throws Exception;
	//修改节点信息
	public void updateWFNode(Object params) throws Exception;
	public void updateWFNodes(Object params) throws Exception;
	
	// 删除 节点
	public void deleteWorkFlowNode(Object params);
	// 删除 协同
	public void deleteWorkFlow(Object params) throws Exception;
	//getCurNodeInfo
	public WfNodeVo getCurNodeInfo(Object params);
	//获取发起人节点
	public WfNodeVo getStartNodeInfo(Object params);
	
	
	// xiugao 
	public String wfHandleNode(HashMap params) throws Exception;
	
	public void updateOAinvoice(OAinvoiceVo oainvoiceVo) throws Exception;
	
	
	//撤销
	public String cxHandler(int iid) throws Exception;
	// 判断 是否 能被撤销
	//fwf.co_is_zx
	public int co_is_zx(Object param);
	
	
	//特殊处理
	public HashMap co_node_ts_js(int iid) throws Exception;
	public HashMap co_node_ts_js_sql(String sql) throws Exception;
	
	//插入工作流节点 消息 ， 下级节点
	public void insert_node_items_msg(Object params) throws Exception;
	
	// 给指定节点的 父节点发送信息
	public void insert_pnode_items_msg(Object params) throws Exception;
	
	// 给指定节点的 父节点发送回退信息
	public void insert_pnodeback_item_msg(Object params) throws Exception;
	
	//给指定节点（如组织节点），所属的人员 发送信息
	public void insert_node_items_msg_zd(Object params) throws Exception;
	
	//工作流中，设置相关人员 权限信息
	 // 1  获取指定工作流中，指定节点的 人员信息
	public List select_xgry_person_info(HashMap params);
	public List select_xgry_person_info_xj(HashMap params);
	public List select_xgry_person_info_nukown(HashMap params);
	
	// 工作流提交，撤销，更新对应单据的状态
	public String get_form_table_name(String ifuniid);
	public void update_form_status(String sql) throws Exception;
	
	// 单据 批量修改对应的 附件
	public String getitemcode(String sql) throws Exception;
	public int getdjfjnum(HashMap params);
	public int patcheditfj(HashMap params)  throws Exception;
	
	//判断 单据是不是已经绑定了流程,单据提交验证
	public List djtjcheck(HashMap params);
	//消息浮动窗口，收到点击关闭时，把所有登录人 已被处理 的消息 置成已阅的 
	public void msgreaded(String ipersonid);
	
}
