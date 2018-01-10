/**    
 * 文件名：IRoleService.java    
 *    
 * 版本信息：    
 * 日期：2011-8-1    
 * 版权所有    
 *    
 */
package yssoft.services;

import yssoft.vos.AsRoleUserVo;
import yssoft.vos.AsRoleVo;

import java.util.HashMap;
import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：IRoleService    
 * 类描述：角色接口   
 * 创建人：钟晶  
 * 创建时间：2011-8-1 下午03:24:23    
 * 修改人：钟晶   
 * 修改时间：2011-8-1 下午03:24:23    
 * 修改备注：    
 * @version     
 *     
 */
public interface IRoleService {

	/**
	 * 
	 * getRolesByIpid(按照父节点查询角色)    
	   
	 * @param  ipid  父节点编号
	   
	 * @return   所有角色   
	   
	 * @since  CodingExample　Ver(编码范例查看) 1.1
	 */
	public List<HashMap> getRolesByIpid(HashMap paramObj);

    public List<HashMap> getAllUser();
	
	/**
	 * 
	   
	 * addRole(新增角色)    
	   
	 * @param   roleVo 要新增的对象     
	   
	 * @Exception 是否保存成功  
	   
	 * @since  CodingExample　Ver(编码范例查看) 1.1
	 */
	public Object addRole(AsRoleVo roleVo) throws Exception;
	
	/**
	 * 
	   
	 * updateRole(修改角色)    
	   
	 * @param  roleVo 修改的内容   
	   
	 * @Exception 异常对象    
	   
	 * @since  CodingExample　Ver(编码范例查看) 1.1
	 */
	public String updateRole(AsRoleVo roleVo) throws Exception;
	
	
	/**
	 * 
	   
	 * deleteRolse(删除角色)    
	 * 
	 * @param   ipid 内码    
	   
	 * @Exception 异常对象    
	   
	 * @since  CodingExample　Ver(编码范例查看) 1.1
	 */
	public void removeRole(int iid) throws Exception;
	
	/**
	 * 
	 *  
	 * getRoleuserVo(查询角色与用户关联表)
	 * 创建者：zhong_jing
	 * 创建时间：2011-2011-8-7 下午09:33:03
	 * 修改者：
	 * 修改时间:
	 * 修改备注：   
	 * @param  roleid 较色编号       
	 * @return List<AsRoleUserVo> 用户信息
	 *
	 */
	public List<AsRoleUserVo> getRoleuserVo(int roleid);
	
	

	/**
	 * 
	 *  
	 * deleteRoleUser(删除职员)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-7 下午10:34:45
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param   iids选中编号       
	 * @return String 是否成功
	 * @Exception 异常对象    
	 *
	 */
	public int romeveRoleUser(String sql)throws Exception;
	
	
	/**
	 * 
	 *  
	 * getEpartment(查询部门)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-7 下午10:34:45
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param   cname 名称        
	 * @return List<HashMap> 部门树
	 * @Exception 异常对象    
	 *
	 */
	public List<HashMap> getEpartment(String cname);

    public List<HashMap> getEpartment1(HashMap param);
	/**
	 * 
	 * getEpartmentUser(查询部门)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-10 下午10:34:45
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param   idepartment 部门编码        
	 * @return List<HashMap> 部门树
	 *
	 */
	public List<HashMap> getEpartmentUser(HashMap paramMap);
	
	/**
	 * 
	 * addRoleUser(添加角色和用户相对应)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-10 下午10:34:45
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param   param 添加值      
	 * @return 是否添加成功
	 *
	 */
	public Object addRoleUser(HashMap param)throws Exception;
}
