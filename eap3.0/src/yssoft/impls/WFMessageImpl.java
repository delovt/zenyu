/**    
 *
 * 文件名：WFMessageImpl.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-9-1    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IWFMessageService;

import java.util.HashMap;
import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：WFMessageImpl    
 * 类描述：    
 * 创建人：朱毛毛 
 * 创建时间：2011-2011-9-1 下午01:52:22        
 *     
 */
public class WFMessageImpl extends BaseDao implements IWFMessageService {

	/**
	 * 删除信息
	 * @see yssoft.services.IWFMessageService#deleteMessage(java.lang.Object) 
	 * 
	 */
	@Override
	public void deleteMessage(Object params) {
		// TODO Auto-generated method stub
		this.delete("wf.deleteWorkFlowNode",params);
	}

	/**
	 * 获取信息列表 发起人回复信息列表
	 * @see yssoft.services.IWFMessageService#getMessages(java.lang.Object) 
	 *   
	 */
	@Override
	public List getMessages(Object params) {
		// TODO Auto-generated method stub
		return this.queryForList("wfm.getMessages",params);
	}
	/**
	 * 非发起人回复信息列表
	 * @see yssoft.services.IWFMessageService#getMessageshide(java.lang.Object) 
	 *
	 */
	public List getMessagesHide(Object params){
		return this.queryForList("wfm.getMessagesHide",params);
	}

	/**
	 * 新增信息
	 * @see yssoft.services.IWFMessageService#insertMessage(java.lang.Object) 
	 *   
	 */
	@Override
	public int insertMessage(Object params) {
		// TODO Auto-generated method stub
		return (Integer) this.insert("wfm.insertMessage", params);
	}

	/**
	 * 修改信息
	 * @see yssoft.services.IWFMessageService#updateMessage(java.lang.Object) 
	 *   
	 */
	@Override
	public void updateMessage(Object params) {
		// TODO Auto-generated method stub
		this.update("wfm.updateMessage", params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-23 下午04:33:19
	 * 方法描述: 
	 *   
	 */
	@Override
	public List getFormMessages(Object params) {
		return this.queryForList("wfm.getFormMessages", params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-12-1 下午03:45:19
	 * 方法描述: 
	 *   
	 */
	@Override
	public int insertzdmsg(HashMap params) {
		// TODO Auto-generated method stub
		return (Integer) this.insert("wf.insertzdmsg", params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-12-1 下午04:57:56
	 * 方法描述: 
	 *   
	 */
	@Override
	public List getzdmsgs(HashMap params) {
		// TODO Auto-generated method stub
		return this.queryForList("wf.getzdmsgs", params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-12-16 下午02:32:54
	 * 方法描述: 
	 *   
	 */
	@Override
	public List getdszdmsgs(HashMap params) {
		// TODO Auto-generated method stub
		return this.queryForList("wf.getdszdmsgs", params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-12-16 下午02:32:54
	 * 方法描述: 
	 *   
	 */
	@Override
	public void insertdszdmsg(HashMap params) throws Exception {
		// TODO Auto-generated method stub
		this.insert("wf.insertdszdmsg", params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-12-17 下午02:03:52
	 * 方法描述: 
	 *   
	 */
	@Override
	public void editdjmsgreaded(HashMap params) {
		// TODO Auto-generated method stub
		this.update("wf.editdjmsgreaded", params);
	}

}
