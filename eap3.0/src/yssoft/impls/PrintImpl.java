/**    
 *
 * 文件名：PrintImpl.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-10-19    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IPrintService;

import java.util.List;

/**    
 *     
 * 项目名称：rkycrm_zg    
 * 类名称：PrintImpl    
 * 类描述：    
 * 创建人：朱毛毛 
 * 创建时间：2011-2011-10-19 下午03:37:45        
 *     
 */
public class PrintImpl extends BaseDao implements IPrintService {

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-10-19 下午03:37:46
	 * 方法描述: 
	 *   
	 */
	@Override
	public Object print_selete_item(Object params) {
		// TODO Auto-generated method stub
		return this.queryForObject("crm.print_selete_item",params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-10-20 下午01:45:13
	 * 方法描述: 
	 *   
	 */
	@Override
	public List print_selete_items(Object params) {
		// TODO Auto-generated method stub
		List list=this.queryForList("crm.print_selete_items",params); 
		return list;
	}

}
