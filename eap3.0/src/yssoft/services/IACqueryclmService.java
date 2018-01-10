/**
 * 模块名称：IACqueryclmService
 * 模块说明：查询条件配置表操作接口类
 * 创建人：	YJ
 * 创建日期：20110815
 * 修改人：
 * 修改日期：
 * 
 */

package yssoft.services;

import java.util.HashMap;
import java.util.List;


public interface IACqueryclmService {
	
	public List getAcQueryclmList(int ifuncregedit);
	public List getFWFConditionclmList(int ifuncregedit);
	
	/**
	 * 函数名称：addAcqueryclm
	 * 函数说明：增加查询条件定制表信息
	 * 函数参数：AsACqueryclmVO（查询定制表实体对象）
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110819
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public Object addAcqueryclm(HashMap paramMap) throws Exception;
	
	
	/**
	 * 函数名称：deleteAcqueryclm
	 * 函数说明：删除查询条件定制表信息
	 * 函数参数：iid（主键）
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110819
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public Object deleteAcqueryclm(int iid) throws Exception;
	
	/**
	 * 函数名称：updateAcqueryclm
	 * 函数说明：更新查询条件定制表信息
	 * 函数参数：iid（主键）
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110819
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public Object updateAcqueryclm(HashMap paramMap) throws Exception;
	
	/**
	 * 
	 * updateAcqueryclm(修改排序状态)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-27 上午10:32:41
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param paramMaps 排序值
	 * @return
	 * @throws Exception String
	 * @Exception 异常对象    
	 *
	 */
	public int updateAcqueryclmBySort(HashMap paramMaps)throws Exception;
	
	public int updateAcqueryclmByCondition(HashMap paramMaps)throws Exception;
}
