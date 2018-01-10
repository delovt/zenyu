/**    
 *
 * 文件名：FavoritesServiceImpl.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-9-22    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IFavoritesService;

import java.util.HashMap;
import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：FavoritesServiceImpl    
 * 类描述：    
 * 创建人：zhong_jing 
 * 创建时间：2011-9-22 下午04:25:13        
 *     
 */
public class FavoritesServiceImpl extends BaseDao implements IFavoritesService {

	/**
	 *     
	 * @see yssoft.services.IFavoritesService#addFavorites(java.util.HashMap) 
	 *   
	 */
	@Override
	public Object addFavorites(HashMap paramObj)throws Exception{
		// TODO Auto-generated method stub
		return this.insert("add_favorites",paramObj);
	}

	/**
	 *     
	 * @see yssoft.services.IFavoritesService#getFavorites(java.util.HashMap) 
	 *   
	 */
	@Override
	public List<HashMap> getFavorites(HashMap paramObj){
		return this.queryForList("get_favorites",paramObj);
	}

	/**
	 *     
	 * @see yssoft.services.IFavoritesService#removeFavorites(int) 
	 *   
	 */
	@Override
	public int removeFavorites(int iid)throws Exception {
		// TODO Auto-generated method stub
		return this.delete("remove_favorites",iid);
	}

	/**
	 *     
	 * @see yssoft.services.IFavoritesService#updateFavorites(java.util.HashMap) 
	 *   
	 */
	@Override
	public int updateFavorites(HashMap paramObj)throws Exception {
		// TODO Auto-generated method stub
		return this.update("update_favorites",paramObj);
	}
	
	public int updateFavoritesCdetail(HashMap paramObj){
		// TODO Auto-generated method stub
		return this.update("favoritesDest.updateFavorites",paramObj);
	}

}
