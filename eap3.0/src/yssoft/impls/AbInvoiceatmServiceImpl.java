/**    
 *
 * 文件名：AbInvoiceatmServiceImpl.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-9-5    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IAbInvoiceatmService;
import yssoft.vos.AbInvoiceatmVo;

import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：AbInvoiceatmServiceImpl    
 * 类描述：    
 * 创建人：朱毛毛 
 * 创建时间：2011-2011-9-5 下午02:39:36        
 *     
 */
public class AbInvoiceatmServiceImpl extends BaseDao implements
		IAbInvoiceatmService {

	/**
	 *     
	 * @see yssoft.services.IAbInvoiceatmServices#deleteFile(java.lang.Object) 
	 *   
	 */
	@Override
	public int deleteFile(Object params) throws Exception {
		// TODO Auto-generated method stub
		return this.delete("adfile.deleteFile", params);
	}

	/**
	 *     
	 * @see yssoft.services.IAbInvoiceatmServices#insertFile(yssoft.vos.AbInvoiceatmVo) 
	 *   
	 */
	@Override
	public int insertFile(AbInvoiceatmVo params) throws Exception {
		// TODO Auto-generated method stub
		return (Integer) this.insert("adfile.insertFile", params);
	}

	/**
	 *     
	 * @see yssoft.services.IAbInvoiceatmServices#selectFile(java.lang.Object) 
	 *   
	 */
	@Override
	public List selectFile(Object params) {
		// TODO Auto-generated method stub
		return this.queryForList("abfile.selectFile", params);
	}

}
