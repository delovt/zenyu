/**    
 *
 * 文件名：ICsCustomerService.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-9-12    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.services;

import yssoft.vos.CsCustpersonVo;

import java.util.HashMap;
import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：ICsCustomerService    
 * 类描述：    
 * 创建人：zhong_jing 
 * 创建时间：2011-9-12 下午09:30:26        
 *     
 */
public interface ICsCustomerService {

	/**
	 * 
	 * addCsCustomer(添加客户档案)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-12 下午09:33:27
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param csCustomerVo 客户档案
	 * @return
	 * @throws Exception 
	 */
	public Object addCsCustomer(HashMap csCustomerVo)throws Exception;
	
	
	/**
	 *  
	 * addCsCustpersonVo(添加客户联系方式)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-13 上午02:03:33
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param csCustpersonVo
	 * @return
	 * @throws Exception Object
	 * @Exception 异常对象    
	 *
	 */
	public Object addCsCustpersonVo(HashMap csCustpersonVo)throws Exception;
	
	/**
	 * 
	 * updateCsCustomer(修改客户档案)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-12 下午09:35:32
	 * 修改者：Lenovo
	 * 修改时间：2011-9-12 下午09:35:32
	 * 修改备注：   
	 * @param csCustomerVo 客户档案
	 * @return
	 * @throws Exception int
	 * @Exception 异常对象    
	 *
	 */
	public int updateCsCustomer(HashMap csCustomerVo)throws Exception;
	
	/**
	 * 
	 * removeCsCustomer(这里用一句话描述这个方法的作用)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-12 下午09:43:02
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param iid
	 * @return
	 * @throws Exception int
	 * @Exception 异常对象    
	 *
	 */
	public int removeCsCustomer(String sql)throws Exception;
	
	/**
	 * 
	 * addCustpersonVo(添加客户联系方式)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-13 上午04:45:11
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param csCustpersonVo
	 * @return
	 * @throws Exception Object
	 * @Exception 异常对象    
	 *
	 */
	public Object addCustpersonVo(HashMap csCustpersonVo)throws Exception;
	
	
	/**
	 *  
	 * updateCustpersonVo(修改)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-13 上午04:46:45
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param csCustpersonVo
	 * @return
	 * @throws Exception int
	 * @Exception 异常对象    
	 *
	 */
	public int updateCustpersonVo(HashMap csCustpersonVo)throws Exception;
	
	/**
	 * 
	 * removeCustpersonVo(删除)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-13 上午04:48:27
	 * 修改者：Lenovo
	 * 修改时间：2011-9-13 上午04:48:27
	 * 修改备注：   
	 * @param iid
	 * @return
	 * @throws Exception int
	 * @Exception 异常对象    
	 *
	 */
	public int removeCustpersonVo(String sql)throws Exception;
	
	
	/**
	 * 
	 * getCsCustpersonVo(查询客户档案)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-13 上午08:39:59
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param iid
	 * @return CsCustpersonVo
	 * @Exception 异常对象    
	 *
	 */
	public CsCustpersonVo getCsCustpersonVo(HashMap paramObj);
	
	/**
	 * 
	 * updateCsCustpersonVoByCustom(修改客户联系方式)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-15 下午05:58:24
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param csCustpersonVo
	 * @return int
	 * @Exception 异常对象    
	 *
	 */
	public int updateCsCustpersonVoByCustom(HashMap csCustpersonVo)throws Exception;
	
	/**
	 * 
	 * addCsCustpersonVoByCustom(新增客户联系方式)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-15 下午06:10:35
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param csCustpersonVo
	 * @return
	 * @throws Exception Object
	 * @Exception 异常对象    
	 *
	 */
	public Object addCsCustpersonVoByCustom(HashMap csCustpersonVo)throws Exception;
	
	/**
	 * 
	 * updateCsCustpersonByIid(修改客商)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-15 下午06:55:25
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param map
	 * @return
	 * @throws Exception int
	 * @Exception 异常对象    
	 *
	 */
	public int updateCsCustpersonByIid(HashMap map)throws Exception;
	
	/**
	 * 
	 * queryArea(查询区域)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-16 上午10:24:09
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param ipid 父节点编号
	 * @return List
	 * @Exception 异常对象    
	 *
	 */
	public List queryArea();
	
	/**
	 * 
	 * queryCustomers(查询客户档案)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-16 下午06:50:06
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param sql
	 * @return List
	 * @Exception 异常对象    
	 *
	 */
	public List queryCustomers(String sql);
	
	public List queryCustomPerson(String sql);
	
	public HashMap kf_infos(HashMap params);
	public void kf_info_update(HashMap params);
	
	/**
	 * 查询单据编码
	 * @param ccode 客商编码
	 * @return
	 */
	public List queryCustomByIid(HashMap paramObj);
	
	/**
	 * 修改客户编码
	 * @param paramObj
	 * @return
	 */
	public int updateCustomCcode(HashMap paramObj)throws Exception;
	
	/**
	 * 修改外部系统内码
	 * @param paramObj
	 * @return
	 */
	public int updatecmnemonic(HashMap paramObj)throws Exception;
}
