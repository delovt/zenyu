/**    
 *
 * 文件名：FormWorkFlowView.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-9-10    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.views;

import yssoft.exceptions.CRMRuntimeException;
import yssoft.services.IFormWorkFlowService;
import yssoft.utils.ToXMLUtil;
import yssoft.vos.WfNodeVo;
import yssoft.vos.wf_invosetVo;

import java.util.HashMap;
import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：FormWorkFlowView    
 * 类描述：表单工作流
 * 创建人：朱毛毛 
 * 创建时间：2011-2011-9-10 上午11:10:21        
 *     
 */
public class FormWorkFlowView {
	private IFormWorkFlowService  iFormWorkFlowService;
	
	public void setiFormWorkFlowService(IFormWorkFlowService iFormWorkFlowService) {
		this.iFormWorkFlowService = iFormWorkFlowService;
	}
	/**
	 * getWorkFlowTpl(获取关联工作流的表单)
	 * 创建者：lovecd
	 * 创建时间：2011-2011-9-10 上午11:22:39
	 * 修改者：lovecd
	 * 修改时间：2011-2011-9-10 上午11:22:39
	 * 修改备注：   
	 * @param   name       
	 * @return String
	 * @Exception 异常对象    
	 */
	public String getWorkFlowTpl(){
		List list = this.iFormWorkFlowService.getWorkFlowTpl();
		return ToXMLUtil.createTree(list,"iid","ipid","-1");
	}
	/**
	 * addFormWorkFlow(新增模板的节点)
	 * 创建者：zmm
	 * 创建时间：2011-2011-9-15 上午10:45:30
	 * 修改者：zmm
	 * 修改时间：2011-2011-9-15 上午10:45:30
	 * 修改备注：   
	 * @param   params       
	 * @return int 新增的iid
	 * @Exception 异常对象    
	 */
	public int add_wf_invosets(WfNodeVo node) throws Exception{
		return this.iFormWorkFlowService.add_wf_invosets(node);
	}
	
	/**
	 * add_wf_invoset(新增模板)
	 * 创建者：zmm
	 * 创建时间：2011-2011-9-15 下午01:06:26
	 * 修改者：zmm
	 * 修改时间：2011-2011-9-15 下午01:06:26
	 * 修改备注：   
	 * @param   name       
	 * @return int
	 * @Exception 异常对象    
	 */
	public int add_wf_invoset(wf_invosetVo wfvo) throws Exception{
		return this.iFormWorkFlowService.add_wf_invoset(wfvo);
	}
	
	/**
	 * newFormWorkFlow(新增模板，添加节点)
	 * 创建者：zmm
	 * 创建时间：2011-2011-9-15 下午01:06:49
	 * 修改者：zmm
	 * 修改时间：2011-2011-9-15 下午01:06:49
	 * 修改备注：   
	 * @param   name       
	 * @return String
	 * @Exception 异常对象    
	 */
	public String newFormWorkFlow(HashMap params){
		List nodes = (List) params.get("nodes");// 节点
		List conds = (List) params.get("conds"); //条件
		List relats = (List) params.get("relat"); //关联
		wf_invosetVo wfvo=(wf_invosetVo) params.get("wfvo");
		
		try {
			//添加模板描述信息
			int iid = add_wf_invoset(wfvo);
			
			//添加节点信息
			int len=nodes.size();
			for(int i=0;i<len;i++){
				WfNodeVo node = (WfNodeVo) nodes.get(i);
				node.setIinvoset(iid);
				add_wf_invosets(node);
			}
			//添加节点的录入信息
			len=relats.size();
			for(int i=0;i<len;i++){
				HashMap param=(HashMap) relats.get(i);
				this.insert_wf_invosetsentry_item(param);
			}
			
			
			//添加节点的条件信息
			len=conds.size();
			for(int i=0;i<len;i++){
				HashMap param=(HashMap) conds.get(i);
				this.insert_wf_invosetscd_item(param);
			}
			
			return "suc";
		} catch (Exception e) {
			e.printStackTrace();
			throw new CRMRuntimeException("表单工作流，插入单据数据失败");
		}
	}
	
	//启动
	public String startFormWorkFlow(HashMap params){
		int ifuncregedit=(Integer) params.get("ifuncregedit");
		int iid=(Integer) params.get("iid");
		
		try {
			HashMap map=new HashMap();
			map.put("ifuncregedit",ifuncregedit);
			map.put("brelease",0);
			this.iFormWorkFlowService.update_wf_invoset_patch(map);
			
			map.remove("ifuncregedit");
			map.put("iid",iid);
			map.put("brelease",1);
			this.iFormWorkFlowService.update_wf_invoset_single(map);
			return "suc";
		} catch (Exception e) {
			e.printStackTrace();
			throw new CRMRuntimeException("表单工作流，启动模板失败");
		}
		
	}
	//停止
	public String stopFormWorkFlow(HashMap params){
		try {
			this.iFormWorkFlowService.update_wf_invoset_single(params);
			return "suc";
		} catch (Exception e) {
			e.printStackTrace();
			throw new CRMRuntimeException("表单工作流，停止模板失败");
		}
	}
	// 删除
	public String delete_wf_invoset(int iid){
		// 删除模板描述信息
		try {
			//删除模板节点的 条件，录入
			this.delete_wf_invoset_all(iid);
			this.iFormWorkFlowService.delete_wf_invoset(iid);
			this.iFormWorkFlowService.delete_wf_invosets(iid);
			return "suc";
		} catch (Exception e) {
			e.printStackTrace();
			throw new CRMRuntimeException("表单工作流，删除模板失败");
		}
	}
	// 表单对应的 模板
	public List get_wf_invoset(int ifuncregedit){
		try {
			return this.iFormWorkFlowService.get_wf_invoset(ifuncregedit);
		} catch (Exception e) {
			e.printStackTrace();
			throw new CRMRuntimeException("表单工作流，获取表单模板列表失败");
		}
	}
	// 获取表单工作流 节点信息
	public List get_wf_invosets(int iinvoset){
		return this.iFormWorkFlowService.get_wf_invosets(iinvoset);
	}
	
	public String getWfInvosets(int iinvoset){
		List list=get_wf_invosets(iinvoset);
		return ToXMLUtil.createTree(list,"inodeid","ipnodeid","startnode");
	}
	
	public HashMap getWfInvosetInfos(int iinvoset){
		HashMap ret = new HashMap();
		ret.put("xmlstr",getWfInvosets(iinvoset));
		ret.put("cons",this.select_wf_invosetscd_items(""+iinvoset));
		ret.put("relats",this.select_wf_invosetsentry_items(""+iinvoset));
		return ret;
	}
	
	// 节点 录入
	public void insert_fw_nodeentry_item(HashMap params){
		this.iFormWorkFlowService.insert_fw_nodeentry_item(params);
	}
	public void delete_fw_nodeentry_item(int iid){
		this.iFormWorkFlowService.delete_fw_nodeentry_item(iid);
	}
	public void update_wf_nodeentry_item(HashMap params){
		this.iFormWorkFlowService.update_wf_nodeentry_item(params);
	}
	public List selete_wf_nodeentry(HashMap params){
		return this.iFormWorkFlowService.selete_wf_nodeentry(params);
	}
	public List selete_wf_dd_items(int ifuniid){
		return this.iFormWorkFlowService.selete_wf_dd_items(ifuniid);
	}
	
	//模板节点 条件
	public List select_wf_invosetscd_items(String cnodeid){
		return this.iFormWorkFlowService.select_wf_invosetscd_items(cnodeid);
	}
	public void insert_wf_invosetscd_item(HashMap params){
		this.iFormWorkFlowService.insert_wf_invosetscd_item(params);
	}
	public void delete_wf_invosetscd_item(String cnodeid){
		this.iFormWorkFlowService.delete_wf_invosetscd_item(cnodeid);
	}
	//模板节点 录入
	public List select_wf_invosetsentry_items(String cnodeid){
		return this.iFormWorkFlowService.select_wf_invosetsentry_items(cnodeid);
	}
	public void insert_wf_invosetsentry_item(HashMap params){
		this.iFormWorkFlowService.insert_wf_invosetsentry_item(params);
	}
	public void delete_wf_invosetsentry_item(String cnodeid){
		this.iFormWorkFlowService.delete_wf_invosetsentry_item(cnodeid);
	}
	
	// 模板修改
	public void delete_wf_invoset_all(int iinvoset){
		this.iFormWorkFlowService.delete_wf_invoset_all(iinvoset);
	}
	public void delete_wf_invosets_item(int iid){
		this.iFormWorkFlowService.delete_wf_invosets_item(iid);
	}
	public void update_wf_invosets_item(WfNodeVo node){
		this.iFormWorkFlowService.update_wf_invosets_item(node);
	}
	public void update_wf_invoset_info(wf_invosetVo wfvo){
		this.iFormWorkFlowService.update_wf_invoset_info(wfvo);
	}
	
	public String editFormWorkFlow(HashMap params){
		
		List conds = (List) params.get("conds"); //条件
		List relats = (List) params.get("relat"); //关联
		
		List newNodes = (List) params.get("newNodes"); // 新增节点
		List editNodes = (List) params.get("editNodes"); // 修改后的节点
		List deleteNodes = (List) params.get("deleteNodes"); // 删除节点
		int len=0;
		
		
		wf_invosetVo wfvo=(wf_invosetVo) params.get("wfvo");
		
		
		try {
			//修改模板描述信息
			this.update_wf_invoset_info(wfvo);
			//删除模板节点的 条件，录入
			this.delete_wf_invoset_all(wfvo.getIid());
			
			//删除节点
			len=deleteNodes.size();
			for (int i=0;i<len;i++){
				WfNodeVo node = (WfNodeVo) deleteNodes.get(i);
				this.delete_wf_invosets_item(node.getIid());
			}
			// 修改节点
			len=editNodes.size();
			for (int i=0;i<len;i++){
				WfNodeVo node = (WfNodeVo) editNodes.get(i);
				this.update_wf_invosets_item(node);
			}
			
			//添加节点信息
			len=newNodes.size();
			for (int i=0;i<len;i++){
				WfNodeVo node = (WfNodeVo) newNodes.get(i);
				node.setIinvoset(wfvo.getIid());
				add_wf_invosets(node);
			}
			
			
			//添加节点的录入信息
			len=relats.size();
			
			if(len>0){
				// 删除所有 节点录入
				this.iFormWorkFlowService.delete_wf_invosetsentry_item_patch(wfvo.getIid());
			}
			
			for(int i=0;i<len;i++){
				HashMap param=(HashMap) relats.get(i);
				this.insert_wf_invosetsentry_item(param);
			}
			
			
			//添加节点的条件信息
			len=conds.size();
			if(len>0){
				// 删除所有 节点条件
				this.iFormWorkFlowService.delete_wf_invosetscd_item_patch(wfvo.getIid());
			}
			for(int i=0;i<len;i++){
				HashMap param=(HashMap) conds.get(i);
				//delete_wf_invosetscd_item((String) param.get("cnodeid"));
				this.insert_wf_invosetscd_item(param);
			}
			
			return "suc";
		} catch (Exception e) {
			e.printStackTrace();
			throw new CRMRuntimeException("表单工作流，插入单据数据失败");
		}
	}
	
	
	
}













