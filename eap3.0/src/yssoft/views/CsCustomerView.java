/**    
 *
 * 文件名：CsCustomerView.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-9-13    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.views;

import yssoft.services.ICsCustomerService;
import yssoft.vos.CsCustpersonVo;

import java.util.HashMap;
import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：CsCustomerView    
 * 类描述：    
 * 创建人：zhong_jing 
 * 创建时间：2011-9-13 上午12:01:06        
 *     
 */
public class CsCustomerView {
	
	private ICsCustomerService iCsCustomerService;
	

	public void setiCsCustomerService(ICsCustomerService iCsCustomerService) {
		this.iCsCustomerService = iCsCustomerService;
	}



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
	public String addCsCustomer(HashMap paramObj)
	{
		try {
			return this.iCsCustomerService.addCsCustomer(paramObj).toString();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "fail";
		}
		
//		HashMap resultMap = new HashMap();
//		try {
//			//新增客户档案
//			CsCustomerVo csCustomerVo=(CsCustomerVo)paramObj.get("customerItem");
//			int count= Integer.valueOf(paramObj.get("isUpdate").toString());
//			String csCustpersonIid ="";
//			if(count==1)
//			{
//				CsCustpersonVo csCustpersonVo= (CsCustpersonVo)paramObj.get("custpersonItem");
//				csCustpersonIid = this.iCsCustomerService.addCsCustpersonVoByCustom(csCustpersonVo).toString();
//				csCustomerVo.setIid(Integer.valueOf(csCustpersonIid));
//				resultMap.put("csCustpersonIid", csCustpersonIid);
//			}
//			
//			String customerIid = this.iCsCustomerService.addCsCustomer(csCustomerVo).toString();
//			resultMap.put("customerIid", customerIid);
//			if(count==1)
//			{
//				HashMap map = new HashMap();
//				map.put("icustomer", customerIid);
//				map.put("iid", csCustpersonIid);
//				this.iCsCustomerService.updateCsCustpersonByIid(map);
//			}
//			return null;
//		} catch (Exception e) {
//			e.printStackTrace();
//			return null;
//		}
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
	public String updateCsCustomer(HashMap paramObj)
	{
		try {
			int count = this.iCsCustomerService.updateCsCustomer(paramObj);
			if(count==1)
			{
				return "success";
			}
			else
			{
				return "fail";
			}
			
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "fail";
		}
//		HashMap resultMap = new HashMap();
//		try {
//			int count= Integer.valueOf(paramObj.get("isUpdate").toString());
//			CsCustpersonVo csCustpersonVo= (CsCustpersonVo)paramObj.get("custpersonItem");
//			//新增客户档案
//			CsCustomerVo csCustomerVo=(CsCustomerVo)paramObj.get("customerItem");
//			String csCustpersonIid ="";
//			if(count==2)
//			{
//				csCustpersonVo.setIcustomer(csCustomerVo.getIid());
//				csCustpersonIid = this.iCsCustomerService.addCsCustpersonVoByCustom(csCustpersonVo).toString();
//				csCustomerVo.setIid(Integer.valueOf(csCustpersonIid));
//				resultMap.put("csCustpersonIid", csCustpersonIid);
//			 }
//			 else if(count==1)
//			 {
//				 this.iCsCustomerService.updateCsCustpersonVoByCustom(csCustpersonVo);
//			 }
//			this.iCsCustomerService.updateCsCustomer(csCustomerVo);
//			if(!csCustpersonIid.equals(""))
//			{
//				return csCustpersonIid;
//			}
//			else
//			{
//				return "success";
//			}
//		} catch (Exception e) {
//			e.printStackTrace();
//			return "fail";
//		}
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
	public String removeCsCustomer(String sql)
	{
		try {
			int count = this.iCsCustomerService.removeCsCustomer(sql);
			return "success";
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}
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
	public String addCustpersonVo(HashMap csCustpersonVo)
	{
		 try {
			return this.iCsCustomerService.addCustpersonVo(csCustpersonVo).toString();
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}
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
	public String updateCustpersonVo(HashMap csCustpersonVo)
	{
		try {
			this.iCsCustomerService.updateCustpersonVo(csCustpersonVo);
			return "success";
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}
	}
	
	/**
	 * 
	 * removeCustpersonVo(删除)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-13 上午04:48:27
	 * 修改者:
	 * 修改时间：
	 * 修改备注：   
	 * @param iid
	 * @return
	 * @throws Exception int
	 * @Exception 异常对象    
	 *
	 */
	public String removeCustpersonVo(String sql)
	{
		try {
			this.iCsCustomerService.removeCustpersonVo(sql);
			return "success";
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}
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
		return this.iCsCustomerService.getCsCustpersonVo(paramObj);
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
		return this.iCsCustomerService.queryArea();
	}
	
	/**
	 * 
	 * getCustoums(查询客户档案)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-16 下午06:56:31
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param custoums
	 * @return List
	 * @Exception 异常对象    
	 *
	 */
	public List getCustoums(String sql)
	{
//		StringBuffer newTj = new StringBuffer();
//		int count=0;
//		for (HashMap hashMap : custoums) {
//			if(count>0)
//			{
//				newTj.append(",");
//			}
//			newTj.append("'"+hashMap.get("iid").toString()+"'");
//			count++;
//		}
//		if(newTj.length()>0)
//		{
//			StringBuffer tjstr = new StringBuffer();
//			tjstr.append("customer.iid in (");
//			tjstr.append(newTj.toString());
//			tjstr.append(")");
			return this.iCsCustomerService.queryCustomers(sql);
//		}
//		return null;
	}
	
	
	/**
	 * 
	 * deletePerson(删除该人员) 
	 * 创建者：zhong_jing 
	 * 创建时间：2011-8-22 上午10:23:49 
	 * 修改者： 修改时间：
	 * 修改备注：
	 * 
	 * @param iid
	 *            人员编号
	 * @return int
	 * @Exception 异常对象
	 * 
	 */
	public String removePerson(String sql) {
		// 默认声明结果集为成功
		String result = "sucess";
		try {
//			if(paramObj.get("iidStr")!=null)
//			{
//				List selectIds = (List)paramObj.get("iidStr");
//				StringBuffer str = new StringBuffer();
//				str.append(" iid in(");
//				for (int i = 0; i < selectIds.size(); i++) {
//					HashMap po = (HashMap)selectIds.get(i);
//					if(i>0)
//					{
//						str.append(",");
//					}
//					str.append("'"+po.get("iid").toString()+"'");
//				}
//				str.append(")");
//				paramObj.put("iidStr", str.toString());
//			}
			this.iCsCustomerService.removeCsCustomer(sql);
		} catch (Exception e) {
			e.printStackTrace();
			// 如抛异常，则删除失败
			result = "fail";
		}
		return result;
	}
	
	/**
	 * 
	 * queryCustomPerson(查询联系人员)
	 * 创建者：zhong_jing
	 * 创建时间：2011-10-8 下午03:52:49
	 * 修改者：Lenovo
	 * 修改时间：2011-10-8 下午03:52:49
	 * 修改备注：   
	 * @param sql
	 * @return List
	 * @Exception 异常对象    
	 *
	 */
	public List queryCustomPerson(String sql)
	{
		return this.iCsCustomerService.queryCustomPerson(sql);
	}
	
	/**
	 * 查询单据编码
	 * @param ccode 客商编码
	 * @return
	 */
	public List queryCustomByIid(HashMap paramObj)
	{
		List aa = this.iCsCustomerService.queryCustomByIid(paramObj);
		return aa;
	}
	
	/**
	 * 修改客户编码
	 * @param paramObj
	 * @return
	 */
	public String updateCustomCcode(HashMap paramObj)
	{
		try {
			int count=this.iCsCustomerService.updateCustomCcode(paramObj);
			if(count==1)
			{
				return "success";
			}
			else
			{
				return "fail";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}
	}
	
	
	/**
	 * 修改外部系统内码
	 * @param paramObj
	 * @return
	 */
	public String updatecmnemonic(HashMap paramObj)
	{
		try {
			int count=this.iCsCustomerService.updatecmnemonic(paramObj);
			if(count==1)
			{
				return "success";
			}
			else
			{
				return "fail";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}
	} 
}
