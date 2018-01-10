/**    
 *
 * 文件名：FavoritesView.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-9-22    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.views;

import yssoft.services.IFavoritesService;
import yssoft.utils.ToXMLUtil;

import java.util.HashMap;
import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：FavoritesView    
 * 类描述：    
 * 创建人：zhong_jing 
 * 创建时间：2011-9-22 下午04:28:20        
 *     
 */
public class FavoritesView {

	private IFavoritesService iFavoritesService;

	
	public void setiFavoritesService(IFavoritesService iFavoritesService) {
		this.iFavoritesService = iFavoritesService;
	}

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
	public String addFavorites(HashMap paramObj)
	{
		String result = "sucess";
		try {
			result = this.iFavoritesService.addFavorites(paramObj).toString();
		} catch (Exception e) {
			e.printStackTrace();
			result = "fail";
		}
		return result;
	}
	
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
	public String updateFavorites(HashMap paramObj)
	{
		String result = "sucess";
		try {
			int count =this.iFavoritesService.updateFavorites(paramObj);
			if(count!=1)
			{
				result = "fail";
			}

		} catch (Exception e) {
			e.printStackTrace();
			result = "fail";
		}
		return result;
	}
	
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
	public String removeFavorites(int iid)
	{
		String result = "sucess";
		try {
			int count =this.iFavoritesService.removeFavorites(iid);
			if(count!=1)
			{
				result = "fail";
			}

		} catch (Exception e) {
			e.printStackTrace();
			result = "fail";
		}
		return result;
	}
	
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
	public String getFavorites(HashMap paramObj)
	{
		List<HashMap> favoriteList = this.iFavoritesService.getFavorites(paramObj);
		String favoriteTree = null;
		if(favoriteList.size()>0)
		{
			favoriteTree = ToXMLUtil.createTree(favoriteList,"iid", "ipid", "-1");
		}
		return favoriteTree;
	}
	
	public List<HashMap> getFavoritesList(HashMap paramObj)
	{
		List<HashMap> favoriteList = this.iFavoritesService.getFavorites(paramObj);
		return favoriteList;
	}
	
	/**
	 * 
	 * updateFavoritesCdetail(更新收藏夹内容)
	 * 创建者：YJ
	 * 创建时间：
	 * 修改者：Lenovo
	 * 修改时间：2011-9-22 下午04:22:41
	 * 修改备注：   
	 * @param paramObj
	 * @return int
	 * @Exception 异常对象    
	 *
	 */
	public String updateFavoritesCdetail(HashMap paramObj)
	{
		String result = "sucess";
		try {
			int count =this.iFavoritesService.updateFavoritesCdetail(paramObj);
			if(count!=1)
			{
				result = "fail";
			}

		} catch (Exception e) {
			e.printStackTrace();
			result = "fail";
		}
		return result;
	}
}
