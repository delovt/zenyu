/**    
 *
 * 文件名：WorkFlowServiceImpl.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-8-22    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.impls;

import flex.messaging.FlexContext;
import yssoft.daos.BaseDao;
import yssoft.exceptions.CRMRuntimeException;
import yssoft.services.IWorkFlowService;
import yssoft.utils.LogOperateUtil;
import yssoft.utils.ToolUtil;
import yssoft.vos.HrPersonVo;
import yssoft.vos.OAinvoiceVo;
import yssoft.vos.WfNodeVo;

import java.io.Serializable;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：WorkFlowServiceImpl    
 * 类描述：    
 * 创建人：zmm
 * 创建时间：2011-2011-8-22 下午04:23:25        
 *     
 */
@SuppressWarnings("serial")
public class WorkFlowServiceImpl extends BaseDao implements IWorkFlowService {

	/**
	 * insertOAinvoice 插入工作流的 关联信息
	 * 创建者：zmm
	 * 创建时间：2011-8-16 下午05:26:43
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param sql SQL语句
	 * @return 查询值
	 * @throws Exception List<HashMap>
	 * @Exception 异常对象    
	 *
	 */
	@Override
	public int insertOAinvoice(Object params) throws Exception {
		return (Integer) this.insert("wf.insertOAinvoice", params);
	}
	/**
	 * 获取用户当前处在的节点位置
	 *     
	 * @see yssoft.services.IWorkFlowService#getCurNodeInfo(java.lang.Object) 
	 *
	 */
	@Override
	public WfNodeVo getCurNodeInfo(Object params) {
		// TODO Auto-generated method stub
		return (WfNodeVo) this.queryForObject("wf.getCurNodeInfo", params);
	}

	/**
	 * 
	 * insertNodeDetail 根据工作流的节点来，插入非人员节点的 详细信息
	 * 创建者：zmm
	 * 创建时间：2011-8-16 下午05:26:43
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param sql SQL语句
	 * @return 查询值
	 * @throws Exception List<HashMap>
	 * @Exception 异常对象    
	 *
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	public void insertNodeDetail(Object params) throws Exception {
		// TODO Auto-generated method stub
		String nodeType= (String) ((HashMap) params).get("nodeType");
		String nodeValue=(String)((HashMap) params).get("nodeValue");
		String iperson=((HashMap) params).get("iperson")+"";
		System.out.println("nodeType="+nodeType+",nodeValue="+nodeValue);
		if(nodeType.equals("2")){ // 角色特殊处理
			// 获取 当前登录用户的 iid
			//HrPersonVo person=(HrPersonVo) this.queryForObject("get_userbyid", params);
			//((HashMap) params).put("personiid",""+((HrPersonVo)this.getAttributeFromSession("HrPerson")).getIid());
			((HashMap) params).put("personiid",iperson);
			this.insert("wf.insertRoleNodeDetail"+nodeValue,params);
		}else{
			this.insert("wf.insertNodeDetail"+nodeType,params);
		}
	}

	/**
	 * 
	 * insertWorkFlow 插入工作流 信息
	 * 创建者：zmm
	 * 创建时间：2011-8-16 下午05:26:43
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param sql SQL语句
	 * @return 查询值
	 * @throws Exception List<HashMap>
	 * @Exception 异常对象    
	 *
	 */
	@Override
	public int insertWorkFlow(Object params) throws Exception {
		// TODO Auto-generated method stub
		return 0;
	}

	/**
	 * 
	 * insertWorkFlowNode 插入工作流节点
	 * 创建者：zmm
	 * 创建时间：2011-8-16 下午05:26:43
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param sql SQL语句
	 * @return 查询值
	 * @throws Exception List<HashMap>
	 * @Exception 异常对象    
	 *
	 */
	@Override
	public int insertWorkFlowNode(Object params) throws Exception {
		// TODO Auto-generated method stub
		return (Integer)this.insert("wf.insertWorkFlowNode", params);
	}

	/**
	 * 
	 * getPersons 根据不同的 nodetype 来获取人员列表
	 * 创建者：zmm
	 * 创建时间：2011-8-16 下午05:26:43
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param sql SQL语句
	 * @return 查询值
	 * @throws Exception List<HashMap>
	 * @Exception 异常对象    
	 *
	 */
	@SuppressWarnings("rawtypes")
	@Override
	public List getPersons(Object params) {
		String nodeType= (String)((HashMap) params).get("nodeType");
		String nodeValue=(String)((HashMap) params).get("nodeValue");
		System.out.println("nodeType="+nodeType+",nodeValue="+nodeValue);
		if(nodeType.equals("2")){ // 角色特殊处理
			//int personid=((HrPersonVo)this.getAttributeFromSession("HrPerson")).getIid();
			String personid=((HashMap) params).get("iperson")+"";
			return this.queryForList("wf.selectUserRole"+nodeValue,""+personid);
		}else{
			return this.queryForList("wf.selectNodeDetail"+nodeType,nodeValue);
		}
	}

	/**
	 * 
	 * getNodeTypeDetail 根据不同的 nodetype 来获取 对应的信息
	 * 创建者：zmm
	 * 创建时间：2011-8-16 下午05:26:43
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param sql SQL语句
	 * @return 查询值
	 * @throws Exception List<HashMap>
	 * @Exception 异常对象    
	 *
	 */
	@SuppressWarnings("rawtypes")
	@Override
	public List getNodeTypeDetail(Object params) {
		// TODO Auto-generated method stub
		return this.queryForList("wf.selectNodeType"+params, params);
	}

	/**
	 * 
	 * getWorkFlow 获取当前登录用户的 协同信息
	 * 创建者：zmm
	 * 创建时间：2011-8-16 下午05:26:43
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param sql SQL语句
	 * @return 查询值
	 * @throws Exception List<HashMap>
	 * @Exception 异常对象    
	 *
	 */
	@SuppressWarnings("rawtypes")
	@Override
	public List getWorkFlows(Object params) {
		// TODO Auto-generated method stub
		return this.queryForList("wf.getWorkFlows",((HrPersonVo)this.getAttributeFromSession("HrPerson")).getIid());
	}

	/**
	 * 
	 * getWorkFlowNodeDetails 获取指定工作流节点 对应的详细信息
	 * 创建者：zmm
	 * 创建时间：2011-8-16 下午05:26:43
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param sql SQL语句
	 * @return 查询值
	 * @throws Exception List<HashMap>
	 * @Exception 异常对象    
	 *
	 */
	@SuppressWarnings("rawtypes")
	@Override
	public List getWorkFlowNodeDetails(Object params) {
		// TODO Auto-generated method stub
		return this.queryForList("wf.getWorkFlowNodeDetails",params);
	}

	/**
	 * 
	 * getWorkFlowNodes 获取指定工作流节点信息
	 * 创建者：zmm
	 * 创建时间：2011-8-16 下午05:26:43
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param sql SQL语句
	 * @return 查询值
	 * @throws Exception List<HashMap>
	 * @Exception 异常对象    
	 *
	 */
	@SuppressWarnings("rawtypes")
	@Override
	public List getWorkFlowNodes(Object params) {
		// TODO Auto-generated method stub
		return this.queryForList("wf.getWorkFlowNodes",params);
	}

    public List getNodeAndNodes(HashMap params) {
        // TODO Auto-generated method stub
        return this.queryForList("getNodeAndNodes",params);
    }

    public List getCurNodeiid(HashMap params){
        return this.queryForList("getCurNodeiid",params);
    }

	/**
	 *     
	 * @see yssoft.services.IWorkFlowService#getWorkFlow(java.lang.Object) 
	 *   
	 */
	@Override
	public OAinvoiceVo getWorkFlow(Object params) {
		// TODO Auto-generated method stub
		return (OAinvoiceVo) this.queryForObject("wf.getWorkFlow", params);
	}

	/**
	 * 
	 * crmPage 分页实现
	 * 创建者：zmm
	 * 创建时间：2011-8-16 下午05:26:43
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param sql SQL语句
	 * @return 查询值
	 * @throws Exception List<HashMap>
	 * @Exception 异常对象    
	 *
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
    public HashMap crmPage(HashMap params) {
		HashMap map=new HashMap();
		String sqlid= (String)params.get("sqlid");
//		int curpage=(Integer)params.get("curpage"); // 当前页（从1，2,3...开始）
//		int pagesize=(Integer)params.get("pagesize");
		String flag=(String) map.get("flag");
		String flag_to = (String)(params.get("flag")==null?"":params.get("flag"));

        int i = 1;
        String sql = (String)params.get("sql")+"";

        while (sql.length()>4000){
            params.put("sql"+i,sql.substring(0,4000));
            sql = sql.substring(4000);
            i++;
        }
        params.put("sql"+i,sql);

		if(flag == null  && !flag_to.equals("2")){ // 不请求总记录数
			Object obj = this.queryForObject(sqlid+"_sum",params);
			
			if(obj.toString().indexOf("_")!=-1){  //  -- sdy 公告
				String count=obj.toString();
				map.put("count", count);
			}else{
//				int count=Integer.parseInt(""+obj);
				map.put("count",obj);
			}
		}
		//params.put("topsize",curpage*pagesize);
		List list=this.queryForList(sqlid,params);
		map.put("list",list);
		return map;
	}

	/**
	 * editWorkFlow 修改协同
	 * 创建者：zmm
	 * 创建时间：2011-8-16 下午05:26:43
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param sql SQL语句
	 * @return 查询值
	 * @throws Exception 
	 * @throws Exception List<HashMap>
	 * @Exception 异常对象    
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	@Override
	public String editWorkFlow(HashMap params) {
		int ioainvoice=(Integer)params.get("ioainvoice");
		List newNodes=		(List) params.get("newNodes");
		List editNodes=		(List) params.get("editNodes");
		List deleteNodes=	(List) params.get("deleteNodes");
		
		int newLen=0;
		int editLen=0;
		int deleteLen=0;
		
//		String inodeid=null;
		
		if(newNodes != null){
			newLen=newNodes.size();
		}
		if(editNodes != null){
			editLen=editNodes.size();
		}
		if(deleteNodes != null){
			deleteLen=deleteNodes.size();
		}
		
		OAinvoiceVo oainvoiceVo=(OAinvoiceVo)params.get("oAinvoiceVo");
		this.update("wf.updateOAinvoice",oainvoiceVo);
		
		if(newLen==0 && editLen==0 && deleteLen==0){
			zjEditWorkFlow(params);
			return ""+ioainvoice;
		}
		
		try{
			for(int i=0;i<newLen;i++){ // 新增节点
				WfNodeVo wfnodeVo=(WfNodeVo) newNodes.get(i);
				wfnodeVo.setIoainvoice(ioainvoice);
				this.insertWorkFlowNode(wfnodeVo);
//				if("startnode".equals(wfnodeVo.getIpnodeid())){
//					inodeid=wfnodeVo.getInodeid();
//				}
				
				if(wfnodeVo.getInodetype() != 0){ //只对非人员节点做处理
					HashMap param=new HashMap();
						param.put("ioainvoice",""+ioainvoice);
						param.put("inodeid",wfnodeVo.getInodeid());
						param.put("istatus",""+wfnodeVo.getIstatus());
						param.put("nodeType",""+wfnodeVo.getInodetype());
						param.put("nodeValue",""+wfnodeVo.getInodevalue());
						param.put("iperson", params.get("iperson")+"");
						this.insertNodeDetail(param);
				}
			}
			// 修改
			for(int i=0;i<editLen;i++){
				WfNodeVo wfnodeVo=(WfNodeVo) editNodes.get(i);
				this.updateWFNode(wfnodeVo);
//				if("startnode".equals(wfnodeVo.getIpnodeid())){
//					inodeid=wfnodeVo.getInodeid();
//				}
				if(wfnodeVo.getInodetype() != 0){ //只对非人员节点做处理
					HashMap param=new HashMap();
						param.put("ioainvoice",""+ioainvoice);
						param.put("inodeid",wfnodeVo.getInodeid());
						param.put("istatus",""+wfnodeVo.getIstatus());
//						param.put("nodeType",""+wfnodeVo.getInodetype());
//						param.put("nodeValue",""+wfnodeVo.getInodevalue());
						this.updateWFNodes(param);
				}
			}
			// 删除
			for(int i=0;i<deleteLen;i++){
				WfNodeVo wfnodeVo=(WfNodeVo) deleteNodes.get(i);
				wfnodeVo.setIoainvoice(ioainvoice);
				this.deleteWorkFlowNode(wfnodeVo);
			}
			
			HashMap map = new HashMap();
			map.put("personiid", params.get("iperson")+"");
			//map.put("personiid",((HrPersonVo)this.getAttributeFromSession("HrPerson")).getIid());
			map.put("ioainvoice",ioainvoice);
			this.update("wf.modifyab",map);
			
			//插入工作流节点对应的 消息提示
//			if(inodeid !=null && !inodeid.equals("")){
//				this.insertNodeItemsMsg("自由系统",inodeid,10,ioainvoice);
//			}
			String result = "success";
			HashMap logParams = new HashMap();
			int iid = oainvoiceVo.getIid();
			logParams.put("iinvoice", oainvoiceVo.getIinvoice());
			logParams.put("iifuncregedit", 10);
			HashMap<String, Serializable> map_0 = new HashMap<String, Serializable>();
			map_0.put("operate", "修改暂存协同");
			map_0.put("result", result);
			map_0.put("iinvoice", iid);
			map_0.put("params", logParams);
			LogOperateUtil.insertLog(map_0);
			
			return ""+ioainvoice;
		}catch (Exception e) {
			e.printStackTrace();
			throw new CRMRuntimeException("工作流，修改节点数据失败！");
		}
	}

	/**
	 * updateWFNode 修改节点信息
	 * 创建者：zmm
	 * 创建时间：2011-8-16 下午05:26:43
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param sql SQL语句
	 * @return 查询值
	 * @throws Exception 
	 * @throws Exception List<HashMap>
	 * @Exception 异常对象    
	 */
	@Override
	public void updateWFNode(Object params) throws Exception {
		this.update("wf.updateWFNode",params);
	}
	@Override
	public void updateWFNodes(Object params) throws Exception {
		this.update("wf.updateWFNodes",params);
	}

	/**
	 *     
	 * @see yssoft.services.IWorkFlowService#deleteWorkFlow(java.lang.Object) 
	 *   
	 */
	@Override
	public void deleteWorkFlow(Object params) {
		// TODO Auto-generated method stub
		this.delete("wf.deleteWorkFlow",params);
		try{
			HashMap param = (HashMap) params;
			String result = "success";
			HashMap logParams = new HashMap();
			int iid = (Integer) param.get("ioainvoice");
			logParams.put("iinvoice",null);
			logParams.put("iifuncregedit", 10);
			HashMap<String, Serializable> map_0 = new HashMap<String, Serializable>();
			map_0.put("operate", "删除");
			map_0.put("result", result);
			map_0.put("iinvoice", iid);
			map_0.put("params", logParams);
			LogOperateUtil.insertLog(map_0);
		}catch (Exception e) {
		}
	}

	/**
	 *     
	 * @see yssoft.services.IWorkFlowService#deleteWorkFlowNode(java.lang.Object) 
	 *   
	 */
	@Override
	public void deleteWorkFlowNode(Object params) {
		// TODO Auto-generated method stub
		this.delete("wf.deleteWorkFlowNode", params);
	}
	/**
	 *     
	 * @see yssoft.services.IWorkFlowService#getStartNodeInfo(java.lang.Object) 
	 *   
	 */
	@Override
	public WfNodeVo getStartNodeInfo(Object params) {
		// TODO Auto-generated method stub
		return (WfNodeVo) this.queryForObject("wf.getStartNodeInfo", params);
	}
	/**
	 *     
	 * @see yssoft.services.IWorkFlowService#wfHandleNode(java.lang.Object) 
	 *   
	 */
	@SuppressWarnings("rawtypes")
	@Override
	public String wfHandleNode(HashMap params) throws Exception {
		// TODO Auto-generated method stub
		String opt=(String) params.get("opt");
		String flag=(String) params.get("flag"); // 判断是自由，还是表协同工作流
		if(opt.equals("startnode")){
			this.update("wf.clstartnode",params);
			int ioainvoice=(Integer)params.get("ioainvoice");
			String inodeid=(String) params.get("inodeid");
			if(inodeid !=null && !inodeid.toString().equals(""))
				insertNodeItemsMsg("处理",inodeid,10,ioainvoice);
		}else if(opt.equals("wf_node")){


			if(flag==null || flag==""){ // 自由协同
                this.update("wf.clnode", params);
				int ioainvoice=(Integer)params.get("ioainvoice");
				String inodeid=(String) params.get("inodeid");
				insertNodeItemsMsg("处理",inodeid,10,ioainvoice);
				return "wf_xgry";
			}else{
                this.update("wf.clnode2", params);
				return "fwf"; //表单协同工作流
			}
		}else if(opt.equals("wf_nodes")){
			this.update("wf.clnodes", params); // 首先跟新 nodes 中的 节点
			
			//获取 组织节点 对应的 nodes 中的 节点 未处理的的节点个数，以此来判断是否要更新 node 中的组织节点与下级节点
			int count=(Integer)this.queryForObject("wf.clnodesishandled",params);
			if(count==0){
				if(flag==null || flag==""){ // 自由协同
					this.update("wf.clnode", params);
					//处理节点消息
					int ioainvoice=(Integer)params.get("ioainvoice");
					String inodeid=(String) params.get("inodeid");
					insertNodeItemsMsg("处理",inodeid,10,ioainvoice);
					//插入工作流 相关人员信息
					return "wf_xgry";
				}else{
					this.update("wf.clnode_only", params);
					return "fwf"; //表单协同工作流
				}
			}
		}
		return "";
	}
	
	/**
	 * 发送节点消息
	 */
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void insertNodeItemsMsg(String cdetail,String inodeid,int ifuncregedit,int ioainvoice){
		HrPersonVo person=(HrPersonVo) FlexContext.getFlexSession().getAttribute("HrPerson");
		HashMap params=new HashMap();
		params.put("isperson",person.getIid());
		params.put("cdetail",cdetail);
		params.put("inodeid",inodeid);
		params.put("ifuncregedit",ifuncregedit);
		params.put("ioainvoice",ioainvoice);
		this.insert("wf.insert_node_items_msg",params);
	}

    //lr 插入节点时间信息
    public void insertWfTime(Boolean isNode,int iinvoice,int itype){
        HashMap params=new HashMap();
        if(isNode)
            params.put("ifuncregedit",1);
        else
            params.put("ifuncregedit",2);

        params.put("iinvoice",iinvoice);
        params.put("itype",itype);
        params.put("ddate", ToolUtil.formatDay(new Date(), null));
        this.insert("insertWfTime",params);
    }
	
	/**
	 * 待发页面中，没有打开绘制界面，就发送
	 * @see yssoft.services.IWorkFlowService#zjEditWorkFlow(java.util.HashMap) 
	 *   
	 */
	@SuppressWarnings("rawtypes")
	@Override
	public int zjEditWorkFlow(HashMap params){
		int ioainvoice = (Integer)params.get("ioainvoice");
//		int ret = this.update("wf.clstartnode",params);
		insert_startnode_item_msg("发起",10,ioainvoice);
		return ioainvoice;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public void insert_startnode_item_msg(String cdetail,int ifuncregedit,int ioainvoice){
		HrPersonVo person=(HrPersonVo) FlexContext.getFlexSession().getAttribute("HrPerson");
		HashMap params=new HashMap();
		params.put("isperson",person.getIid());
		params.put("cdetail",cdetail);
		params.put("ifuncregedit",ifuncregedit);
		params.put("ioainvoice",ioainvoice);
		this.insert("wf.insert_startnode_item_msg",params);
	}
	/**
	 * 修改协同信息
	 * @see yssoft.services.IWorkFlowService#updateOAinvoice(yssoft.vos.OAinvoiceVo) 
	 *   
	 */
	@Override
	public void updateOAinvoice(OAinvoiceVo oainvoiceVo) throws Exception {
		// TODO Auto-generated method stub
		this.update("wf.updateOAinvoice",oainvoiceVo);
	}
	/**
	 * 撤销
	 * @see yssoft.services.IWorkFlowService#cxHandler(int) 
	 *   
	 */
	@Override
	public String cxHandler(int iid) throws Exception {
		// TODO Auto-generated method stub
		// 验证 能否撤销
		int sum=(Integer)this.queryForObject("wf.yzcx",iid);
		if(sum==0){ // 为 0 就可以撤销
			this.update("wf.cxcl",iid);
			return "suc";
		}else{
			return "fail";
		}
		
	}
	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-10-11 下午05:56:20
	 * 方法描述: 
	 *   
	 */
	@SuppressWarnings("rawtypes")
	@Override
	public HashMap co_node_ts_js(int iid) throws Exception {
		// TODO Auto-generated method stub
		return (HashMap) this.queryForObject("fwf.co_node_ts_js",iid);
	}
	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-10-11 下午05:56:20
	 * 方法描述: 
	 *   
	 */
	@SuppressWarnings("rawtypes")
	@Override
	public HashMap co_node_ts_js_sql(String sql) throws Exception {
		// TODO Auto-generated method stub
		return (HashMap) this.queryForObject("fwf.co_node_ts_js_sql",sql);
	}
	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-10-21 上午11:01:38
	 * 方法描述: 
	 *   
	 */
	@Override
	public void insert_node_items_msg(Object params) throws Exception {
		this.insert("wf.insert_node_items_msg",params);
	}
	
	
	@Override
	public void insert_pnodeback_item_msg(Object params) throws Exception {
		this.insert("wf.insert_pnodeback_item_msg",params);
	}
	
	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-10-25 下午07:06:59
	 * 方法描述: 
	 *   
	 */
	@Override
	public void insert_pnode_items_msg(Object params) throws Exception {
		// TODO Auto-generated method stub
		this.insert("wf.insert_pnode_items_msg", params);
	}
	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-10-29 下午06:08:34
	 * 方法描述: 
	 *   
	 */
	@Override
	public int co_is_zx(Object param) {
		// TODO Auto-generated method stub
		return (Integer)this.queryForObject("fwf.co_is_zx",param);
	}
	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-11-26 上午08:41:59
	 * 方法描述: 
	 *   
	 */
	@Override
	public void insert_node_items_msg_zd(Object params) throws Exception {
		// TODO Auto-generated method stub
		this.insert("wf.insert_node_items_msg_zd", params);
	}
	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-12-6 上午10:22:15
	 * 方法描述: 
	 *   
	 */
	@SuppressWarnings("rawtypes")
	@Override
	public List select_xgry_person_info(HashMap params) {
		return this.queryForList("wf.select_xgry_person_info", params);
	}
	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-12-6 上午11:54:00
	 * 方法描述: 
	 *   
	 */
	@SuppressWarnings("rawtypes")
	@Override
	public List select_xgry_person_info_xj(HashMap params) {
		// TODO Auto-generated method stub
		return this.queryForList("wf.select_xgry_person_info_xj", params);
	}
	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-12-6 下午02:38:57
	 * 方法描述: 
	 *   
	 */
	@SuppressWarnings("rawtypes")
	@Override
	public List select_xgry_person_info_nukown(HashMap params) {
		// TODO Auto-generated method stub
		return this.queryForList("wf.select_xgry_person_info_nukown", params);
	}
	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-12-6 下午03:51:04
	 * 方法描述: 
	 *   
	 */
	@Override
	public String get_form_table_name(String ifuniid) {
		// TODO Auto-generated method stub
		return (String) this.queryForObject("wf.get_form_table_name",ifuniid);
	}
	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-12-6 下午03:51:04
	 * 方法描述: 
	 *   
	 */
	@Override
	public void update_form_status(String sql) {
		// TODO Auto-generated method stub
		this.update("wf.update_form_status",sql);
	}
	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-12-13 下午02:26:05
	 * 方法描述: 
	 *   
	 */
	@SuppressWarnings("rawtypes")
	@Override
	public int getdjfjnum(HashMap params) {
		// TODO Auto-generated method stub
		return (Integer)this.queryForObject("dj.getdjfjnum", params);
	}
	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-12-13 下午02:26:05
	 * 方法描述: 
	 *   
	 */
	@SuppressWarnings("rawtypes")
	@Override
	public int patcheditfj(HashMap params) throws Exception {
		// TODO Auto-generated method stub
		return this.update("dj.patcheditfj", params);
	}
	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-12-13 下午02:35:54
	 * 方法描述: 
	 *   
	 */
	@Override
	public String getitemcode(String sql) {
		// TODO Auto-generated method stub
		return (String) this.queryForObject("dj.getitemcode",sql);
	}
	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-12-15 下午04:32:03
	 * 方法描述: 
	 *   
	 */
	@SuppressWarnings("rawtypes")
	@Override
	public List djtjcheck(HashMap params) {
		// TODO Auto-generated method stub
		return this.queryForList("fwf.djtjcheck", params);
	}
	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-12-16 上午11:51:22
	 * 方法描述: 
	 *   
	 */
	@Override
	public void msgreaded(String ipersonid) {
		// TODO Auto-generated method stub
		this.update("fwf.msgreaded",ipersonid);
	}


}
