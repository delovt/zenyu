/**
 * 模块名称：IHandleService
 * 模块说明：数据操作接口类
 * 创建人：	YJ
 * 创建日期：20110810
 * 修改人：
 * 修改日期：
 * 
 */
package yssoft.services;

import yssoft.vos.AsFuncregeditVO;

import java.util.HashMap;
import java.util.List;


public interface IHandleService {
	
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
	 * 函数名称：getFieldsByTable
	 * 函数说明：通过表名获取不为空的字段列表
	 * 函数参数：tablename（表的名称）
	 * 函数返回：List
	 * 创建人：	YJ
	 * 创建日期：20110810
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public List getFieldsByTable(String tablename);
	
	/**
	 * 函数名称：addFuncrededit
	 * 函数说明：增加功能注册表信息
	 * 函数参数：AsFuncregeditVO（功能注册表实体对象）
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110810
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public Object addFuncrededit(AsFuncregeditVO asFuncregeditVO) throws Exception;
	
	/**
	 * 函数名称：updateFuncrededit
	 * 函数说明：更新功能注册表信息
	 * 函数参数：AsFuncregeditVO（功能注册表实体对象）
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110810
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public Object updateFuncrededit(AsFuncregeditVO asFuncregeditVO) throws Exception;
	
	/**
	 * 函数名称：deleteFuncrededit
	 * 函数说明：删除功能注册表信息
	 * 函数参数：iid（主键）
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110810
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public Object deleteFuncrededit(int iid) throws Exception;
	
	/**
	 * 函数名称：getMenuListByTableName
	 * 函数说明：通过表名获取菜单列表
	 * 函数参数：tablename（表的名称）
	 * 函数返回：List
	 * 创建人：	YJ
	 * 创建日期：20110810
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public List getTreeMenuByTableName(String tablename);
	
	/*cody by liu lei begin*/
	public String get_cname_FuncregeditByID(int iid);
	/*cody by liu lei end*/
	

	/**
	 * 函数名称：getSingleFuncregeditByID
	 * 函数说明：根据主键获得信息
	 * 函数参数：iid（主键）
	 * 函数返回：HashMap
	 * 创建人：	钟晶
	 * 创建日期：20111010
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public HashMap getSingleFuncregeditByID(int iid);
	

	/*cody by liu lei begin*/
	public String get_cparameter_FuncregeditByID(int iid);
	/*cody by liu lei end*/
	
	//add by zhong_jing 查询所有主表
	public List getAllFuncregeditBybdataauth1();
	

}
