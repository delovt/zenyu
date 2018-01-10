/**    
 *
 * 文件名：ICoopHandler.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-9-22    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.services;

import java.util.HashMap;
import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：ICoopHandler    
 * 类描述：协同处理
 * 创建人：朱毛毛 
 * 创建时间：2011-2011-9-22 上午11:47:42        
 *     
 */
public interface ICoopHandlerService {
	public Object co_invoset_judge(Object params);
	public List co_invosets_items(Object params);
	public void co_insert_nodecd(Object params);
	public void co_insert_nodeentry(Object params);
	
	public List co_select_wfnodecd(int ioainvoice);
	public List co_select_wfnodeentry(int ioainvoice);
	
	public Object co_select_oainvoice(Object params);
	public Object co_select_abinvoiceproperty(int iinvoice);
	
	
	public List co_zd_select_wfnodecd(Object params);
	public List co_zd_select_wfnodeentry(Object params);
	public List co_select_subnodes(Object params);
    public List co_select_allnodes(Object params);

	public int co_judge_nodecd(String sql);
	public String co_form_tablename(Object params);
	
	public void co_update_node(Object params);
	public void co_update_nodes(Object params);
	public void co_update_nodes_patch(Object params);
	
	public void co_updateNode(Object params);
	public void co_update_nodeentry(String sql);
	
	//撤销
	public void co_deleteWorkFlow(Object params) throws Exception;
	
	// 回退
	public void co_node_return_update(Object params) throws Exception;
	public void co_node_return_update_p(Object params) throws Exception;
	public void co_node_return_2(Object params) throws Exception;
	
	
	// 验证工作流的有效性
	
	public List checkformwf(HashMap param) throws Exception;
	
	// 验证工作流 是否可以撤销
	
	public HashMap pr_canback(HashMap params) throws Exception;
	
}
