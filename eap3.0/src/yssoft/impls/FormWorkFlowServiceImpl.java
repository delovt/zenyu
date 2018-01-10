/**    
 *
 * 文件名：FormWorkFlowServiceImpl.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-9-10    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IFormWorkFlowService;

import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：FormWorkFlowServiceImpl    
 * 类描述：    
 * 创建人：朱毛毛 
 * 创建时间：2011-2011-9-10 上午11:08:31        
 *     
 */
public class FormWorkFlowServiceImpl extends BaseDao implements IFormWorkFlowService {

	/**
	 * 获取模板
	 */
	@Override
	public List getWorkFlowTpl() {
		return this.queryForList("fwf.getWorkFlowTpl");
	}

	/**
	 * 
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-14 下午04:41:10
	 * 方法描述: 新增表单工作流模板，添加节点
	 *
	 */
	@Override
	public int add_wf_invosets(Object params) throws Exception {
		return (Integer)this.insert("fwf.add_wf_invosets",params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-15 下午01:03:16
	 * 方法描述: 新增表单工作流模板，并返回新增工作流iid
	 *   
	 */
	@Override
	public int add_wf_invoset(Object params) throws Exception {
		return (Integer)this.insert("fwf.add_wf_invoset",params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-15 下午02:15:18
	 * 方法描述: 
	 *   
	 */
	@Override
	public void delete_wf_invoset(int iid) throws Exception {
		// TODO Auto-generated method stub
		this.delete("fwf.delete_wf_invoset",iid);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-15 下午02:15:18
	 * 方法描述: 
	 *   
	 */
	@Override
	public List get_wf_invoset(int ifuncregedit) throws Exception {
		// TODO Auto-generated method stub
		return this.queryForList("fwf.get_wf_invoset",ifuncregedit);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-15 下午02:15:18
	 * 方法描述: 
	 *   
	 */
	@Override
	public void update_wf_invoset_patch(Object params) throws Exception {
		// TODO Auto-generated method stub
		this.update("fwf.update_wf_invoset_patch",params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-15 下午02:15:18
	 * 方法描述: 
	 *   
	 */
	@Override
	public void update_wf_invoset_single(Object params) throws Exception {
		// TODO Auto-generated method stub
		this.update("fwf.update_wf_invoset_single",params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-15 下午02:30:34
	 * 方法描述: 
	 *   
	 */
	@Override
	public void delete_wf_invosets(int iid) throws Exception {
		// TODO Auto-generated method stub
		this.delete("fwf.delete_wf_invosets",iid);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-15 下午05:10:16
	 * 方法描述: 
	 *   
	 */
	@Override
	public List get_wf_invosets(int iinvoset) {
		// TODO Auto-generated method stub
		return this.queryForList("fwf.get_wf_invosets",iinvoset);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-19 下午05:11:30
	 * 方法描述: 
	 *   
	 */
	@Override
	public void delete_fw_nodeentry_item(Object iid) {
		// TODO Auto-generated method stub
		this.delete("fwf.delete_fw_nodeentry_item",iid);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-19 下午05:11:30
	 * 方法描述: 
	 *   
	 */
	@Override
	public void insert_fw_nodeentry_item(Object params) {
		// TODO Auto-generated method stub
		this.insert("insert_fw_nodeentry_item", params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-19 下午05:11:30
	 * 方法描述: 
	 *   
	 */
	@Override
	public List selete_wf_nodeentry(Object params) {
		// TODO Auto-generated method stub
		return this.queryForList("fwf.selete_wf_nodeentry", params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-19 下午05:11:30
	 * 方法描述: 
	 *   
	 */
	@Override
	public void update_wf_nodeentry_item(Object params) {
		// TODO Auto-generated method stub
		this.update("fwf.update_wf_nodeentry_item",params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-19 下午05:16:20
	 * 方法描述: 
	 *   
	 */
	@Override
	public List selete_wf_dd_items(Object ifuniid) {
		// TODO Auto-generated method stub
		return this.queryForList("fwf.selete_wf_dd_items",ifuniid);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-20 下午02:43:15
	 * 方法描述: 
	 *   
	 */
	@Override
	public void delete_wf_invosetscd_item(Object cnodeid) {
		// TODO Auto-generated method stub
		this.delete("fwf.delete_wf_invosetscd_item",cnodeid);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-20 下午02:43:15
	 * 方法描述: 
	 *   
	 */
	@Override
	public void delete_wf_invosetsentry_item(Object cnodeid) {
		// TODO Auto-generated method stub
		this.delete("fwf.delete_wf_invosetsentry_item",cnodeid);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-20 下午02:43:15
	 * 方法描述: 
	 *   
	 */
	@Override
	public void insert_wf_invosetscd_item(Object params) {
		// TODO Auto-generated method stub
		this.insert("fwf.insert_wf_invosetscd_item",params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-20 下午02:43:15
	 * 方法描述: 
	 *   
	 */
	@Override
	public void insert_wf_invosetsentry_item(Object params) {
		// TODO Auto-generated method stub
		this.insert("fwf.insert_wf_invosetsentry_item", params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-20 下午02:43:15
	 * 方法描述: 
	 *   
	 */
	@Override
	public List select_wf_invosetscd_items(Object cnodeid) {
		// TODO Auto-generated method stub
		return this.queryForList("fwf.select_wf_invosetscd_items",cnodeid);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-20 下午02:43:15
	 * 方法描述: 
	 *   
	 */
	@Override
	public List select_wf_invosetsentry_items(Object cnodeid) {
		// TODO Auto-generated method stub
		return this.queryForList("fwf.select_wf_invosetsentry_items",cnodeid);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-20 下午07:02:45
	 * 方法描述: 
	 *   
	 */
	@Override
	public void delete_wf_invoset_all(Object iinvoset) {
		// TODO Auto-generated method stub
		this.delete("fwf.delete_wf_invoset_all",iinvoset);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-20 下午07:02:45
	 * 方法描述: 
	 *   
	 */
	@Override
	public void delete_wf_invosets_item(Object iid) {
		// TODO Auto-generated method stub
		this.delete("fwf.delete_wf_invosets_item",iid);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-20 下午07:02:45
	 * 方法描述: 
	 *   
	 */
	@Override
	public void update_wf_invosets_item(Object params) {
		// TODO Auto-generated method stub
		this.update("fwf.update_wf_invosets_item",params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-20 下午07:11:56
	 * 方法描述: 
	 *   
	 */
	@Override
	public void update_wf_invoset_info(Object params) {
		// TODO Auto-generated method stub
		this.update("fwf.update_wf_invoset_info",params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-10-27 上午11:42:16
	 * 方法描述: 
	 *   
	 */
	@Override
	public void delete_wf_invosetscd_item_patch(int iinvoset) {
		// TODO Auto-generated method stub
		this.delete("fwf.delete_wf_invosetscd_item_patch",iinvoset);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-10-27 上午11:42:16
	 * 方法描述: 
	 *   
	 */
	@Override
	public void delete_wf_invosetsentry_item_patch(int iinvoset) {
		// TODO Auto-generated method stub
		this.delete("fwf.delete_wf_invosetsentry_item_patch",iinvoset);
	}

}
