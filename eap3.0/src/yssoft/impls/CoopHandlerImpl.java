/**    
 *
 * 文件名：CoopHandlerImpl.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-9-22    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.ICoopHandlerService;

import java.util.HashMap;
import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：CoopHandlerImpl    
 * 类描述：    
 * 创建人：朱毛毛 
 * 创建时间：2011-2011-9-22 上午11:50:48        
 *     
 */
public class CoopHandlerImpl extends BaseDao implements ICoopHandlerService {

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-22 上午11:50:48
	 * 方法描述: 
	 *   
	 */
	@Override
	public Object co_invoset_judge(Object params) {
		// TODO Auto-generated method stub
		return this.queryForObject("fwf.co_invoset_judge", params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-22 上午11:50:48
	 * 方法描述: 
	 *   
	 */
	@Override
	public List co_invosets_items(Object params) {
		// TODO Auto-generated method stub
		return this.queryForList("fwf.co_invosets_items", params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-22 下午04:22:45
	 * 方法描述: 
	 *   
	 */
	@Override
	public void co_insert_nodecd(Object params) {
		// TODO Auto-generated method stub
		this.insert("fwf.co_insert_nodecd", params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-22 下午04:22:45
	 * 方法描述: 
	 *   
	 */
	@Override
	public void co_insert_nodeentry(Object params) {
		// TODO Auto-generated method stub
		this.insert("fwf.co_insert_nodeentry", params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-23 上午09:34:07
	 * 方法描述: 
	 *   
	 */
	@Override
	public List co_select_wfnodecd(int ioainvoice) {
		// TODO Auto-generated method stub
		return this.queryForList("fwf.co_select_wfnodecd",ioainvoice);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-23 上午09:34:07
	 * 方法描述: 
	 *   
	 */
	@Override
	public List co_select_wfnodeentry(int ioainvoice) {
		// TODO Auto-generated method stub
		return this.queryForList("fwf.co_select_wfnodeentry",ioainvoice);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-23 上午09:35:46
	 * 方法描述: 
	 *   
	 */
	@Override
	public Object co_select_oainvoice(Object params) {
		// TODO Auto-generated method stub
		return this.queryForObject("fwf.co_select_oainvoice",params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-23 下午04:11:04
	 * 方法描述: 
	 *   
	 */
	@Override
	public Object co_select_abinvoiceproperty(int iinvoice) {
		// TODO Auto-generated method stub
		return this.queryForObject("fwf.co_select_abinvoiceproperty",iinvoice);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-24 下午03:26:24
	 * 方法描述: 
	 *   
	 */
	@Override
	public List co_select_subnodes(Object params) {
		// TODO Auto-generated method stub
		return this.queryForList("fwf.co_select_subnodes", params);
	}

    @Override
    public List co_select_allnodes(Object params) {
        // TODO Auto-generated method stub
        return this.queryForList("co_select_allnodes", params);
    }

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-24 下午03:26:24
	 * 方法描述: 
	 *   
	 */
	@Override
	public List co_zd_select_wfnodecd(Object params) {
		// TODO Auto-generated method stub
		return this.queryForList("fwf.co_zd_select_wfnodecd", params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-24 下午03:26:24
	 * 方法描述: 
	 *   
	 */
	@Override
	public List co_zd_select_wfnodeentry(Object params) {
		// TODO Auto-generated method stub
		return this.queryForList("fwf.co_zd_select_wfnodeentry", params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-24 下午03:46:50
	 * 方法描述: 
	 *   
	 */
	@Override
	public int co_judge_nodecd(String sql) {
		// TODO Auto-generated method stub
		return (Integer)this.queryForObject("fwf.co_judge_nodecd",sql);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-24 下午04:05:16
	 * 方法描述: 
	 *   
	 */
	@Override
	public String co_form_tablename(Object params) {
		// TODO Auto-generated method stub
		return (String)this.queryForObject("fwf.co_form_tablename", params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-24 下午04:26:34
	 * 方法描述: 
	 *   
	 */
	@Override
	public void co_update_node(Object params) {
		// TODO Auto-generated method stub
		this.update("fwf.co_update_node", params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-24 下午04:26:34
	 * 方法描述: 
	 *   
	 */
	@Override
	public void co_update_nodes(Object params) {
		// TODO Auto-generated method stub
		this.update("fwf.co_update_nodes", params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-24 下午04:26:34
	 * 方法描述: 
	 *   
	 */
	@Override
	public void co_update_nodes_patch(Object params) {
		// TODO Auto-generated method stub
		this.update("fwf.co_update_nodes_patch", params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-24 下午05:22:56
	 * 方法描述: 
	 *   
	 */
	@Override
	public void co_updateNode(Object params) {
		this.update("fwf.co_updateNode", params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-24 下午05:42:27
	 * 方法描述: 
	 *   
	 */
	@Override
	public void co_update_nodeentry(String sql) {
		// TODO Auto-generated method stub
		this.update("fwf.co_update_nodeentry",sql);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-27 下午04:39:16
	 * 方法描述: 
	 *   
	 */
	@Override
	public void co_deleteWorkFlow(Object params) {
		// TODO Auto-generated method stub
		this.delete("fwf.co_deleteWorkFlow", params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-29 上午09:53:41
	 * 方法描述: 
	 *   
	 */
	@Override
	public void co_node_return_update(Object params) throws Exception {
		// TODO Auto-generated method stub
		this.update("fwf.co_node_return_update", params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-29 上午09:53:41
	 * 方法描述: 
	 *   
	 */
	@Override
	public void co_node_return_update_p(Object params) throws Exception {
		// TODO Auto-generated method stub
		this.update("fwf.co_node_return_update_p", params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-29 上午10:50:13
	 * 方法描述: 
	 *   
	 */
	@Override
	public void co_node_return_2(Object params) throws Exception {
		// TODO Auto-generated method stub
		this.delete("fwf.co_node_return_2", params);
	}

	@Override
	public List checkformwf(HashMap param) throws Exception {
		// TODO Auto-generated method stub
		return this.queryForList("fwf.checkformwf", param);
	}
	
	@Override
	public HashMap pr_canback(HashMap params) throws Exception {
		// TODO Auto-generated method stub
		this.queryForObject("fwf.pr_canback", params);
		return params;
	}
}
