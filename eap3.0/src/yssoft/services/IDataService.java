/**
 * 模块名称：IDataService(档案数据接口)
 * 模块说明：档案数据相关业务操作
 * 创建人：YJ
 * 创建日期：20110822
 * 修改人：
 * 修改日期：
 *
 */
package yssoft.services;

import yssoft.vos.AsDataVO;

import java.util.HashMap;
import java.util.List;

;

public interface IDataService {

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
	public List<HashMap> getMenuListByClass(int bsystem);
	
	
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
	public List<HashMap> getMenuList(int iclass);
	
	
	/**
	 * 函数名称：addData
	 * 函数说明：添加档案分类
	 * 函数参数：AsDataVO
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110823
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public Object addData(AsDataVO asDataVO);
	
	
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
	public Object delData(int iid);
	
	
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
	public Object updateData(AsDataVO asDataVO);
}
