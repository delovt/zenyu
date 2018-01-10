/**    
 *
 * 文件名：YwhandlerImpl.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-10-13    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IYwhandler;

import java.util.List;

/**    
 *     
 * 项目名称：RKYCRM    
 * 类名称：YwhandlerImpl    
 * 类描述：    
 * 创建人：朱毛毛 
 * 创建时间：2011-2011-10-13 下午04:40:23        
 *     
 */
public class YwhandlerImpl extends BaseDao implements IYwhandler {

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-10-13 下午04:40:23
	 * 方法描述: 
	 *   
	 */
	@Override
	public void xgry_delete_item(Object param) {
		// TODO Auto-generated method stub
		this.delete("ywhd.xgry_delete_item",param);

	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-10-13 下午04:40:23
	 * 方法描述: 
	 *   
	 */
	@Override
	public int xgry_insert_item(Object param) {
		// TODO Auto-generated method stub
		return (Integer)this.insert("ywhd.xgry_insert_item",param);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-10-13 下午04:40:23
	 * 方法描述: 
	 *   
	 */
	@Override
	public List xgry_selete_items(Object param) {
		// TODO Auto-generated method stub
		return this.queryForList("ywhd.xgry_selete_items",param);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-10-13 下午04:40:23
	 * 方法描述: 
	 *   
	 */
	@Override
	public int xgry_selete_items_count(Object param) {
		// TODO Auto-generated method stub
		return (Integer)this.queryForObject("ywhd.xgry_selete_items_count",param);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-10-13 下午04:40:23
	 * 方法描述: 
	 *   
	 */
	@Override
	public void ywzs_delete_item(Object param) {
		// TODO Auto-generated method stub
		this.delete("ywhd.ywzs_delete_item",param);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-10-13 下午04:40:23
	 * 方法描述: 
	 *   
	 */
	@Override
	public int ywzs_insert_item(Object param) {
		// TODO Auto-generated method stub
		return (Integer)this.insert("ywhd.ywzs_insert_item", param);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-10-13 下午04:40:23
	 * 方法描述: 
	 *   
	 */
	@Override
	public List ywzs_selete_items(Object param) {
		// TODO Auto-generated method stub
		return this.queryForList("ywhd.ywzs_selete_items", param);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-10-14 上午09:07:02
	 * 方法描述: 
	 *   
	 */
	@Override
	public int xgry_selete_fz_items_count(Object param) {
		// TODO Auto-generated method stub
		return (Integer)this.queryForObject("ywhd.xgry_selete_fz_items_count",param);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-10-14 上午10:54:02
	 * 方法描述: 
	 *   
	 */
	@Override
	public List ywdx_selete_items(Object param) {
		// TODO Auto-generated method stub
		return this.queryForList("ywhd.ywdx_selete_items",param);
	}

}
