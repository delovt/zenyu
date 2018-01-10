/**    
 *
 * 文件名：IFormWorkFlowService.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-9-10    
 * 类描述: 表单工作流
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.services;

import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：IFormWorkFlowService    
 * 类描述：    
 * 创建人：朱毛毛 
 * 创建时间：2011-2011-9-10 上午11:06:52        
 *     
 */
public interface IFormWorkFlowService {
	//获取模板
	public List getWorkFlowTpl();
	
	/**
	 * add_wf_invoset(添加模板信息)
	 * 创建者：Administrator
	 * 创建时间：2011-2011-9-15 下午01:01:56
	 * 修改者：Administrator
	 * 修改时间：2011-2011-9-15 下午01:01:56
	 * 修改备注：   
	 * @param   name       
	 * @return int 返回新增模板工作流的iid
	 * @Exception 异常对象    
	 *
	 */
	public int add_wf_invoset(Object params) throws Exception;

	/**
	 * add_wf_invosets( 新增表单工作流 模板节点 )
	 * 创建者：Administrator
	 * 创建时间：2011-2011-9-15 下午01:02:45
	 * 修改者：Administrator
	 * 修改时间：2011-2011-9-15 下午01:02:45
	 * 修改备注：   
	 * @param   name       
	 * @return int
	 * @Exception 异常对象    
	 *
	 */
	public int add_wf_invosets(Object params) throws Exception;
	
	public List get_wf_invoset(int ifuncregedit) throws Exception;
	public void update_wf_invoset_patch(Object params) throws Exception;
	public void update_wf_invoset_single(Object params) throws Exception;
	public void delete_wf_invoset(int iid) throws Exception;
	public void delete_wf_invosets(int iid) throws Exception;
	public List get_wf_invosets(int iinvoset);
	
	
	// 模板节点 录入
	public List select_wf_invosetsentry_items(Object cnodeid);
	public void insert_wf_invosetsentry_item(Object params);
	public void delete_wf_invosetsentry_item(Object cnodeid);
	// 模板节点 条件
	public List select_wf_invosetscd_items(Object cnodeid);
	public void insert_wf_invosetscd_item(Object params);
	public void delete_wf_invosetscd_item(Object cnodeid);
	// 模板修改
	public void delete_wf_invoset_all(Object iinvoset);
	public void delete_wf_invosets_item(Object iid);
	public void update_wf_invosets_item(Object params);
	public void update_wf_invoset_info(Object params);
	
	
	
	// 节点录入
	public void insert_fw_nodeentry_item(Object params);
	public void delete_fw_nodeentry_item(Object iid);
	public void update_wf_nodeentry_item(Object params);
	public List selete_wf_nodeentry(Object params);
	public List selete_wf_dd_items(Object ifuniid);
	
	//批量删除 录入
	public void delete_wf_invosetsentry_item_patch(int iinvoset);
	//批量删除 条件
	public void delete_wf_invosetscd_item_patch(int iinvoset);
	
	
}
