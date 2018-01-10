/**    
 *
 * 文件名：HrDepartmentView.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-8-12    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.views;

import yssoft.services.IHrDepartmentService;
import yssoft.utils.ToXMLUtil;
import yssoft.vos.HRDepartmentVo;
import yssoft.vos.HrJobVo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：HrDepartmentView    
 * 类描述：    
 * 创建人：zhong_jing 
 * 创建时间：2011-8-12 下午04:21:22        
 *     
 */
public class HrDepartmentView {

	private IHrDepartmentService iHrDepartmentService = null;

	public void setiHrDepartmentService(IHrDepartmentService iHrDepartmentService) {
		this.iHrDepartmentService = iHrDepartmentService;
	}
	
	
	/**
	 * 
	 *  
	 * addDepartment(新增部门)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-12 下午04:09:48
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param hrDepartmentVo(新增条件)
	 * @return Object 插入主键
	 * @Exception 异常对象    
	 *
	 */
	public String addDepartment(HRDepartmentVo hrDepartmentVo)
	{
		try {
			return this.iHrDepartmentService.addDepartment(hrDepartmentVo).toString();
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}
	}
	
	/**
	 * 
	 * updateDepartment(修改部门)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-12 下午04:30:00
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param hrDepartmentVo(修改条件)
	 * @return int(修改多少行)
	 * @Exception 异常对象    
	 *
	 */
	public String updateDepartment(HRDepartmentVo hrDepartmentVo)
	{
		String result="success";
		try {
			int count =this.iHrDepartmentService.updateDepartment(hrDepartmentVo);
			if(count==0)
			{
				result ="fail";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 
	 * removeDepartment(删除部门)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-12 下午04:34:11
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param iid 内码
	 * @return int删除行数
	 * @Exception 异常对象    
	 *
	 */
	public String removeDepartment(int iid)
	{
		String result="success";
		try {
			int count = this.iHrDepartmentService.removeDepartment(iid);
			if(count==0)
			{
				result="fail";
			}
		} catch (Exception e) {
			e.printStackTrace();
			result ="fail";
		}
		return result;
	}
	
	/**
	 * 
	 * addJob(邢增一条记录)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-15 下午01:08:05
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param hrJobVo 新增对象
	 * @return Object
	 * @Exception 异常对象    
	 *
	 */
	public List<HrJobVo> addJob(HashMap paramObj)
	{
		List<HrJobVo> jobs = new ArrayList<HrJobVo>();
		try {
			List<HrJobVo> jobvoList =(List<HrJobVo>) paramObj.get("jobArr");
			for(int i=0;i<jobvoList.size();i++) {
				HrJobVo hrJobVo =(HrJobVo)jobvoList.get(i);
				if(hrJobVo.getIid()==0)
				{
					Object obj = this.iHrDepartmentService.addJob(hrJobVo);
					hrJobVo.setIid(Integer.valueOf(obj.toString()).intValue());
					jobs.add(hrJobVo);
				}
				else
				{
					this.iHrDepartmentService.updateJob(hrJobVo);
				}
			}
			List<HrJobVo> removeList=(List<HrJobVo>)paramObj.get("removeArr");
			StringBuffer sqlBuffer = new StringBuffer();
			sqlBuffer.append("(");
			for (int i = 0; i < removeList.size(); i++) {
				HrJobVo hrJobVo = (HrJobVo)removeList.get(i);
				if(hrJobVo.getIid()>0)
				{
					sqlBuffer.append("iid=");
					sqlBuffer.append(hrJobVo.getIid());
					if(removeList.size()>1&&i<removeList.size()-1)
					{
						sqlBuffer.append(" or ");
					}
				}
			}
			if(sqlBuffer.length()>1)
			{
				sqlBuffer.append(")");
				//System.out.println(sqlBuffer);
				this.iHrDepartmentService.removeJob(sqlBuffer.toString());
			}
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		return jobs;
	}
	
	/**
	 * 
	 * getJobVoById(查询工作岗位)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-15 下午03:54:21
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param iid 部门编码
	 * @return List<HrJobVo> 结果
	 *
	 */
	public List<HrJobVo> getJobVoById(int iid)
	{
		return this.iHrDepartmentService.getJobVoById(iid);
	}
	
	/**
	 * 
	 * get_AllHR_department(查询所有部门)
	 * 创建者：刘磊
	 * 创建时间：2011-9-10 下午12:54:21
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param 无
	 * @return List<HashMap> 结果
	 *
	 */
	public String get_AllHR_department() throws Exception {
		
		/******************************创建树******************************/
		List<HashMap> lst = this.iHrDepartmentService.get_AllHR_department();
		if (lst.size()==0)
		{
			return null;
		}
		else
		{
		    return ToXMLUtil.createTree(lst, "iid", "ipid", "-1");
		}
		/******************************创建树******************************/
	}
	
	public String get_HR_departmentByWhere(HashMap params) throws Exception{
		
		/******************************创建树******************************/
		List<HashMap> lst = this.iHrDepartmentService.get_HR_departmentByWhere(params);
		if (lst.size()==0)
		{
			return null;
		}
		else
		{
		    return ToXMLUtil.createTree(lst, "iid", "ipid", "-1");
		}
		/******************************创建树******************************/
	}
}
