/**    
 *
 * 文件名：ITravelService.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-9-22    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.services;

import java.util.HashMap;
import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：ITravelService    
 * 类描述：    
 * 创建人：zhong_jing 
 * 创建时间：2011-9-22 上午10:18:11        
 *     
 */
public interface ITravelService {

	/**
	 * 
	 * addTravel(新增出差管理)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-22 上午10:19:12
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param paramObj
	 * @return Object
	 * @Exception 异常对象    
	 *
	 */
	public Object addTravel(HashMap paramObj)throws Exception;
	
	
	/**
	 * 
	 * removeTravel(删除出差管理）
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-22 上午10:20:14
	 * 修改者：Lenovo
	 * 修改时间：2011-9-22 上午10:20:14
	 * 修改备注：   
	 * @param sql
	 * @return int
	 * @Exception 异常对象    
	 *
	 */
	public int removeTravel(String sql)throws Exception;
	
	
	/**
	 * 
	 * updateTravel(修改出差管理)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-22 上午10:20:58
	 * 修改者：Lenovo
	 * 修改时间：2011-9-22 上午10:20:58
	 * 修改备注：   
	 * @param paramObj
	 * @return int
	 * @Exception 异常对象    
	 *
	 */
	public int updateTravel(HashMap paramObj)throws Exception;
	
	public List getTravel(String sql);
}
