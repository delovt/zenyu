/**
 * 模块名称：DataServiceImpl(档案数据)
 * 模块说明：档案数据相关业务操作
 * 创建人：YJ
 * 创建日期：20110822
 * 修改人：
 * 修改日期：
 *
 */

package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IDataService;
import yssoft.vos.AsDataVO;

import java.util.HashMap;
import java.util.List;

public class DataServiceImpl extends BaseDao implements IDataService{

	/**
	 * 函数名称：getMenuListByClass
	 * 函数说明：获取菜单列表(根据分类)
	 * 函数参数：无
	 * 函数返回：List
	 * 创建人：	YJ
	 * 创建日期：20110810
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public List<HashMap> getMenuListByClass(int bsystem){
		return this.queryForList("DataDest.getMenuListByClass",bsystem);
	}
	
	
	/**
	 * 函数名称：getMenuList
	 * 函数说明：获取菜单列表
	 * 函数参数：无
	 * 函数返回：List
	 * 创建人：	YJ
	 * 创建日期：20110810
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap> getMenuList(int iclass){
		return this.queryForList("DataDest.getMenuList",iclass);
	}
	
	
	/**
	 * 函数名称：addData
	 * 函数说明：添加档案数据
	 * 函数参数：AsDataVO
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110823
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public Object addData(AsDataVO asDataVO){
		return this.insert("DataDest.addData",asDataVO);		
	}
	
	
	/**
	 * 函数名称：delData
	 * 函数说明：删除档案数据
	 * 函数参数：iid
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110823
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public Object delData(int iid){
		return this.delete("DataDest.delData",iid);
	}
	
	
	/**
	 * 函数名称：updateData
	 * 函数说明：更新档案数据
	 * 函数参数：AsDataVO
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110823
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public Object updateData(AsDataVO asDataVO){
		return this.update("DataDest.updateData", asDataVO);
	}
}
