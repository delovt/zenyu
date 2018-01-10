/**
 * 模块名称：IDatadictionaryService
 * 模块说明：数据字典对应的接口类
 * 创建人：	YJ
 * 创建日期：20110815
 * 修改人：
 * 修改日期：
 * 
 */

package yssoft.services;

import java.util.HashMap;
import java.util.List;

public interface IDatadictionaryService {
	
	/**
	 * 函数名称：getTreeMenuList
	 * 函数说明：获取菜单列表
	 * 函数参数：无
	 * 函数返回：List
	 * 创建人：	YJ
	 * 创建日期：20110810
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public List<HashMap> getTreeMenuList(HashMap paramMap);
	
	public List<HashMap> getTable(HashMap paramMap);
	
	public List<HashMap> getDataList(HashMap param);
	
	/**
	 * 函数名称：updateDatadictonary
	 * 函数说明：更新数据字典
	 * 函数参数：无
	 * 函数返回：HashMap
	 * 创建人：	YJ
	 * 创建日期：20110810
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public HashMap updateDatadictonary();
	
	/**
	 * 函数名称：saveDatadictonary
	 * 函数说明：保存数据字典
	 * 函数参数：Array
	 * 函数返回：HashMap
	 * 创建人：	YJ
	 * 创建日期：20110810
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public HashMap saveDatadictonary(HashMap paramMap);
	
	
	/**
	 * 
	 * getCrmRefer(查询数据字典)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-29 下午03:19:06
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param iid
	 * @return HashMap
	 * @Exception 异常对象    
	 *
	 */
	public List getCrmRefer(HashMap iid);
	
	/**
	 * 
	 * getValue(参照转换)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-30 下午04:55:36
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param sql
	 * @return List
	 *
	 */
	public List getValue(String sql);
	
	public HashMap adddDatadictonary(HashMap paramMap);
	
	public List getVouchForm(HashMap paramMap);
	
	public HashMap addVouch(HashMap paramMap);
	
	public List getVouch(HashMap paramMap);
	
	public HashMap updateVouch(HashMap paramMap);
	public void removeVouch(int ifuncregedit) throws Exception ;
	
	public List queryNotinData(HashMap paramMap);
	
	
	
	public String queryData(int iid);
	
	public String get_funcregeditsqlstr(int iid);
	
	public List getBodyConsult(int iid);
	
	/**
	 * 功能：检查参照是否为树型或树表参照
	 * 创建者：XZQWJ
	 * 创建时间：2012-10-10
	 * 
	 * @param iid
	 * @return String 
	 */
	public Object checkIsTreeDatadic(Object iid);
}
