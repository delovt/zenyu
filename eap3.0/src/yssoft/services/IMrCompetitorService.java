
/**
 * 模块名称：IMrCompetitorService(竞争对手接口)
 * 模块说明：竞争对手相关业务操作
 * 创建人：YJ
 * 创建日期：20110923
 * 修改人：
 * 修改日期：
 *
 */

package yssoft.services;

import java.util.HashMap;
import java.util.List;

public interface IMrCompetitorService {

	@SuppressWarnings("unchecked")
	public List getMrCopetitorList(String condition);

	/**
	 * 函数名称：addMrCopetitor
	 * 函数说明：增加竞争对手信息
	 * 函数参数：
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110923
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	@SuppressWarnings("unchecked")
	public Object addMrCopetitor(HashMap paramMap) throws Exception;


	/**
	 * 函数名称：deleteMrCopetitor
	 * 函数说明：删除竞争对手信息
	 * 函数参数：iid（主键）
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110923
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public Object deleteMrCopetitor(String condition) throws Exception;

	/**
	 * 函数名称：updateMrCopetitor
	 * 函数说明：更新竞争对手信息
	 * 函数参数：iid（主键）
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110923
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	@SuppressWarnings("unchecked")
	public Object updateMrCopetitor(HashMap paramMap) throws Exception;
	
	/**
	 * 函数名称：getSublistInfo
	 * 函数说明：获取子表信息
	 * 函数参数：HashMap paramMap
	 * 			tablename:表名
	 * 
	 * 函数返回：List
	 * 创建人：	YJ
	 * 创建日期：20110923
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	@SuppressWarnings("unchecked")
	public HashMap getSublistInfo(HashMap paramMap) throws Exception;
	
	
	/**
	 * 函数名称：reGetChildrenData
	 * 函数说明：重新获取子表信息
	 * 函数参数：HashMap paramMap
	 * 			tablename:表名
	 * 			condition:条件
	 * 			
	 * 函数返回：List
	 * 创建人：	YJ
	 * 创建日期：20110923
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	@SuppressWarnings("unchecked")
	public List reGetChildrenData(HashMap paramMap) throws Exception;
	
	public HashMap onGetResult(HashMap paramMap) throws Exception;
	public HashMap onGetResFunValue(HashMap paramMap) throws Exception;
	public String onGetResFunValue2(HashMap paramMap) throws Exception;
	
}
