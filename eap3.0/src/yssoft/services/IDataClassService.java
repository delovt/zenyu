/**
 * 模块名称：IDataClassService(档案分类接口)
 * 模块说明：档案分类相关业务操作
 * 创建人：YJ
 * 创建日期：20110822
 * 修改人：
 * 修改日期：
 *
 */
package yssoft.services;

import yssoft.vos.AsDataClassVO;

import java.util.HashMap;
import java.util.List;

public interface IDataClassService {
	
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
	public List<HashMap> getMenuList();
	
	
	/**
	 * 函数名称：addDataClass
	 * 函数说明：添加档案分类
	 * 函数参数：AsDataClassVO
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110823
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public Object addDataClass(AsDataClassVO asDataClassVO);
	
	
	/**
	 * 函数名称：delDataClass
	 * 函数说明：删除档案分类
	 * 函数参数：iid
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110823
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public Object delDataClass(int iid);
	
	
	/**
	 * 函数名称：updateDataClass
	 * 函数说明：更新档案分类
	 * 函数参数：AsDataClassVO
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110823
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public Object updateDataClass(AsDataClassVO asDataClassVO);
	
	
	/**
	 * 函数名称：getDataCountByClass
	 * 函数说明：相关档案分类的档案数据记录数
	 * 函数参数：iid 档案分类主键
	 * 函数返回：int
	 * 创建人：	YJ
	 * 创建日期：20110826
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public int getDataCountByClass(int iid);
}
