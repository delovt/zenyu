/**    
 *
 * 文件名：CsCustomerServiceImpl.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-9-12    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.ICsCustomerService;
import yssoft.vos.CsCustpersonVo;

import java.util.HashMap;
import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：CsCustomerServiceImpl    
 * 类描述：    
 * 创建人：zhong_jing 
 * 创建时间：2011-9-12 下午09:46:29        
 *     
 */
public class CsCustomerServiceImpl extends BaseDao implements ICsCustomerService{

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
	public Object addCsCustomer(HashMap csCustomerVo)throws Exception
	{
		return this.insert("add_CsCustomer",csCustomerVo);
	}
	
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
	public Object addCsCustpersonVo(HashMap csCustpersonVo)throws Exception
	{
		return this.insert("add_custpersonVo",csCustpersonVo);
	}
	
	
	
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
	public int updateCsCustomer(HashMap csCustomerVo)throws Exception
	{
		return this.update("update_CsCustomer",csCustomerVo);
	}
	
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
	public int removeCsCustomer(String sql)throws Exception
	{
		return this.delete("delete_CsCustomer",sql);
	}
	
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
	public Object addCustpersonVo(HashMap csCustpersonVo)throws Exception
	{
		return this.insert("add_custperson",csCustpersonVo);
	}
	
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
	public int updateCustpersonVo(HashMap csCustpersonVo)throws Exception
	{
		return this.update("update_custperson",csCustpersonVo);
	}
	
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
	public int removeCustpersonVo(String sql)throws Exception
	{
		return this.delete("remove_custperson",sql);
	}
	
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
	public CsCustpersonVo getCsCustpersonVo(HashMap paramObj)
	{
		try
		{
			Object obj = this.queryForObject("get_CsCustomer",paramObj);
			return (CsCustpersonVo) obj;
		}
		catch (Exception e) {
			e.printStackTrace();
			return null;// TODO: handle exception
		}
	} 
	
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
	public int updateCsCustpersonVoByCustom(HashMap csCustpersonVo)throws Exception
	{
		return this.update("update_CsCustomer_byCsCustomer",csCustpersonVo);
	}
	
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
	public Object addCsCustpersonVoByCustom(HashMap csCustpersonVo)throws Exception
	{
		return this.insert("add_CsCustomer_byCsCustomer",csCustpersonVo);
	}
	
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
	public int updateCsCustpersonByIid(HashMap map)throws Exception
	{
		return this.update("update_custperson_Byiid",map);
	}
	
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
	public List queryArea()
	{
		return this.queryForList("get_area");
	}
	
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
	public List queryCustomers(String sql)
	{
		return this.queryForList("get_CsCustomers",sql);
	}
	
	
	public List queryCustomPerson(String sql)
	{
		return this.queryForList("get_CsCustomerpersons",sql);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-11-21 上午11:45:27
	 * 方法描述: 
	 *   
	 */
	@Override
	public void kf_info_update(HashMap params) {
		// TODO Auto-generated method stub
		this.update("crm.kf_info_update", params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-11-21 上午11:45:27
	 * 方法描述: 
	 *   
	 */
	@Override
	public HashMap kf_infos(HashMap params) {
		return (HashMap) this.queryForObject("crm.kf_infos",params);
	}
	
	/**
	 * 查询单据编码
	 * @param ccode 客商编码
	 * @return
	 */
	public List queryCustomByIid(HashMap paramObj)
	{
		return this.queryForList("get_CsCustomerById",paramObj);
	}
	/**
	 * 修改客户编码
	 * @param paramObj
	 * @return
	 */
	public int updateCustomCcode(HashMap paramObj)throws Exception
	{
		return this.update("update_customer_ccode",paramObj);
	}
	
	
	/**
	 * 修改外部系统内码
	 * @param paramObj
	 * @return
	 */
	public int updatecmnemonic(HashMap paramObj)throws Exception
	{
		return this.update("update_cmnemonic",paramObj);
	}
}
