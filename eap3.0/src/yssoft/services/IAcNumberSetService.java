/**
 * 模块名称：IAcNumberSetService(单据编码接口)
 * 模块说明：单据编码相关业务操作
 * 创建人：YJ
 * 创建日期：20110828
 * 修改人：
 * 修改日期：
 *
 */
package yssoft.services;

import yssoft.vos.AcNumberSetVO;

import java.util.HashMap;
import java.util.List;

public interface IAcNumberSetService {

	/**
	 * 函数名称：getMenuList
	 * 函数说明：获取菜单列表
	 * 函数参数：无
	 * 函数返回：List
	 * 创建人：	YJ
	 * 创建日期：20110828
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap> getMenuList();
	
	
	/**
	 * 函数名称：addNumberSet
	 * 函数说明：添加单据编码
	 * 函数参数：无
	 * 函数返回：List
	 * 创建人：	YJ
	 * 创建日期：20110828
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public Object addNumberSet(AcNumberSetVO asNumberSetVO);
	
	
	/**
	 * 函数名称：updateNumberSet
	 * 函数说明：更新单据编码
	 * 函数参数：无
	 * 函数返回：List
	 * 创建人：	YJ
	 * 创建日期：20110828
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public Object updateNumberSet(AcNumberSetVO asNumberSetVO);
	
	
	
	/**
	 * 函数名称：getPreFixList
	 * 函数说明：获取编码前缀编码
	 * 函数参数：无
	 * 函数返回：List
	 * 创建人：	YJ
	 * 创建日期：20110828
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap> getPreFixList(HashMap paramMap);
	
	
	
	/**
	 * 函数名称：getNumberSetListByIfid
	 * 函数说明：获取单据编码信息(注册编码主键)
	 * 函数参数：无
	 * 函数返回：List
	 * 创建人：	YJ
	 * 创建日期：20110828
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	@SuppressWarnings("unchecked")
	public List getNumberSetListByIfid(int ifuncregeidt);
	
	
	/**
	 * 函数名称：getNumberHistory
	 * 函数说明：获取单据编码历史信息(注册编码主键)
	 * 函数参数：无
	 * 函数返回：List
	 * 创建人：	YJ
	 * 创建日期：20111128
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	@SuppressWarnings("unchecked")
	public List getNumberHistory(int ifuncregeidt);
	
	
	
	/**
	 * 函数名称：showNumber
	 * 函数说明：显示编码，并不保存在数据库中
	 * 函数参数：HashMap paramMap 包含的参数如下：
	 * 			cprefix:前缀类型
	 * 			cprefixvalue：前缀对应的值
	 * 			bprefixrule：是否参与流水依据
	 * 			list:参与单据编码的字段集合
	 * 
	 * 函数返回：String(前缀值)
	 * 
	 * 创建人：	YJ
	 * 创建日期：20110905
	 * 修改人：
	 * 修改日期：
	 */
	@SuppressWarnings("unchecked")
	public HashMap showNumber(HashMap paramMap);
	
	
	/**
	 * 函数名称：saveNumber
	 * 函数说明：保存编码，将流水号更新至单据历史表中
	 * 函数参数：HashMap paramMap 包含的参数如下：
	 * 			cprefix:前缀类型
	 * 			cprefixvalue：前缀对应的值
	 * 			bprefixrule：是否参与流水依据
	 * 			list:参与单据编码的字段集合
	 * 
	 * 函数返回：String(前缀值)
	 * 
	 * 创建人：	YJ
	 * 创建日期：20110905
	 * 修改人：
	 * 修改日期：
	 */
	@SuppressWarnings("unchecked")
	public HashMap saveNumber(HashMap paramMap);
	
	
	/**
	 * 函数名称：onUpdateNumber
	 * 函数说明：更新单据历史流水号
	 * 函数参数：HashMap paramMap 包含的参数如下：
	 * 			iid:内码
	 * 			inumber：流水号
	 * 
	 * 函数返回：HashMap (更新是否成功)
	 * 
	 * 创建人：	YJ
	 * 创建日期：20111129
	 * 修改人：
	 * 修改日期：
	 */
	public HashMap onUpdateHistoryNumber(HashMap paramMap);
	
	
}
