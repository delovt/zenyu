/**    
 *
 * 文件名：IFavoritesService.java
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
 * 类名称：IFavoritesService    
 * 类描述：    
 * 创建人：zhong_jing 
 * 创建时间：2011-9-22 下午04:21:16        
 *     
 */
public interface IFavoritesService {

	/**
	 * 
	 * addFavorites(新增)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-22 下午04:22:06
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param paramObj
	 * @return Object
	 * @Exception 异常对象    
	 *
	 */
	public Object addFavorites(HashMap paramObj)throws Exception;
	
	/**
	 * 
	 * updateFavorites(修改)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-22 下午04:22:41
	 * 修改者：Lenovo
	 * 修改时间：2011-9-22 下午04:22:41
	 * 修改备注：   
	 * @param paramObj
	 * @return int
	 * @Exception 异常对象    
	 *
	 */
	public int updateFavorites(HashMap paramObj)throws Exception;
	
	/**
	 * 
	 * removeFavorites(删除)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-22 下午04:23:42
	 * 修改者：Lenovo
	 * 修改时间：2011-9-22 下午04:23:42
	 * 修改备注：   
	 * @param iid
	 * @return int
	 * @Exception 异常对象    
	 *
	 */
	public int removeFavorites(int iid)throws Exception;
	
	/**
	 * 
	 * getFavorites(查询)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-22 下午04:24:25
	 * 修改者：Lenovo
	 * 修改时间：2011-9-22 下午04:24:25
	 * 修改备注：   
	 * @param paramObj
	 * @return List<HashMap>
	 * @Exception 异常对象    
	 *
	 */
	public List<HashMap> getFavorites(HashMap paramObj);
	
	/**
	 * 
	 * updateFavoritesCdetail(更新收藏夹内容)
	 * 创建者：YJ
	 * 创建时间：
	 * 修改者：Lenovo
	 * 修改时间：2011-9-22 下午04:24:25
	 * 修改备注：   
	 * @param paramObj
	 * @return List<HashMap>
	 * @Exception 异常对象    
	 *
	 */
	public int updateFavoritesCdetail(HashMap paramObj);
	
	
}
