/**    
 *
 * 文件名：IYwhandler.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-10-13    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.services;

import java.util.List;

/**    
 *     
 * 项目名称：RKYCRM    
 * 类名称：IYwhandler    
 * 类描述：    
 * 创建人：朱毛毛 
 * 创建时间：2011-2011-10-13 下午04:03:57        
 *     
 */
public interface IYwhandler {
	//业务注释
	public List ywzs_selete_items(Object param);
	public int ywzs_insert_item(Object param) throws Exception;
	public void ywzs_delete_item(Object param) throws Exception;
	
	//相关人员
	public List xgry_selete_items(Object param);
	public int xgry_insert_item(Object param) throws Exception;
	public int xgry_selete_items_count(Object param);
	public void xgry_delete_item(Object param) throws Exception;
	public int xgry_selete_fz_items_count(Object param);
	
	//业务对象
	public List ywdx_selete_items(Object param);
}
