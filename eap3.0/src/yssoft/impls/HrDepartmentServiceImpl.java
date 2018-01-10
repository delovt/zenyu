/**    
 *
 * 文件名：HrDepartmentServiceImpl.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-8-12    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IHrDepartmentService;
import yssoft.vos.HRDepartmentVo;
import yssoft.vos.HrJobVo;

import java.util.HashMap;
import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：HrDepartmentServiceImpl    
 * 类描述：部门操作类
 * 创建人：zhong_jing 
 * 创建时间：2011-8-12 下午04:13:03        
 *     
 */
public class HrDepartmentServiceImpl extends BaseDao implements IHrDepartmentService {

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
	public Object addDepartment(HRDepartmentVo hrDepartmentVo) throws Exception {
		
		return this.insert("add_department",hrDepartmentVo);
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
	public int updateDepartment(HRDepartmentVo hrDepartmentVo)throws Exception
	{
		return this.update("update_department",hrDepartmentVo);
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
	public int removeDepartment(int iid)throws Exception
	{
		return this.delete("remove_department",iid);
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
	public Object addJob(HrJobVo hrJobVo)throws Exception
	{
		return this.insert("add_job",hrJobVo);
	}
	
	/**
	 * 
	 * removeJob(删除工作岗位)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-15 下午02:19:03
	 * 修改者：Lenovo
	 * 修改时间：2011-8-15 下午02:19:03
	 * 修改备注：   
	 * @param sql sql语句
	 * @return
	 * @throws Exception int
	 * @Exception 异常对象    
	 *
	 */
	public int removeJob(String sql)throws Exception
	{
		return this.delete("remove_job",sql);
	}
	
	/**
	 * 
	 * updateJob(修改工作岗位)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-15 下午02:20:16
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param hrJobVo 修改记录
	 * @return
	 * @throws Exception int
	 * @Exception 异常对象    
	 *
	 */
	public int updateJob(HrJobVo hrJobVo)throws Exception
	{
		return this.update("update_job",hrJobVo);
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
		return this.queryForList("getJob_by_idepartment",iid);
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
	public List<HashMap> get_AllHR_department() throws Exception {
		return this.queryForList("get_AllHR_department");
	}
	public List<HashMap> get_HR_departmentByWhere(HashMap params) throws Exception {
		return this.queryForList("get_HR_departmentByWhere",params);
	}
}
