/**    
 * 文件名：RoleService.java    
 *    
 * 版本信息：    
 * 日期：2011-8-1    
 * 版权所有    
 *    
 */
package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IRoleService;
import yssoft.vos.AsRoleUserVo;
import yssoft.vos.AsRoleVo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * 
 * 项目名称：yscrm
 * 
 * 类名称：RoleService
 * 
 * 类描述：角色业务实现类
 * 
 * 创建人：钟晶
 * 
 * 创建时间：2011-8-1
 * 
 * 下午02:17:30 修改人：钟晶
 * 
 * 修改时间：2011-8-1 下午02:17:30 修改备注：
 * 
 * @version
 * 
 */
public class RoleServiceImpl extends BaseDao implements IRoleService {

	/**
	 * 
	 * getRolesByIpid(按照父节点查询角色)
	 * 
	 * @param ipid
	 *            父节点编号
	 * 
	 * @return 所有角色
	 * 
	 * @since CodingExample　Ver(编码范例查看) 1.1
	 */
	public List<HashMap> getRolesByIpid(HashMap paramObj) {
		// 执行查询
		return this.queryForList("get_all_roles",paramObj);
	}

    public List<HashMap> getAllUser(){
        return this.queryForList("get_all_use");
    }

	/**
	 * 
	 * addRole(新增角色)
	 * 
	 * @param roleVo
	 *            要新增的对象
	 * @Exception 是否保存成功
	 * @since CodingExample　Ver(编码范例查看) 1.1
	 */
	public Object addRole(AsRoleVo roleVo) throws Exception {
		Object object = this.insert("add_role", roleVo);
		return object;

	}

	/**
	 * 
	 * 
	 * updateRole(修改角色)
	 * 
	 * @param roleVo
	 *            修改的内容
	 * 
	 * @Exception 异常对象
	 * 
	 * @since CodingExample　Ver(编码范例查看) 1.1
	 */
	public String updateRole(AsRoleVo roleVo) throws Exception {
		
		int count = this.update("update_role", roleVo);
		if(count!=1)
		{
			return "fail";
		}
		else
		{
			return "success";
		}
	}

	/**
	 * 
	 * 
	 * deleteRolse(删除角色)
	 * 
	 * @param ipid
	 *            内码
	 * 
	 * @Exception 异常对象
	 * 
	 * @since CodingExample　Ver(编码范例查看) 1.1
	 */
	public void removeRole(int iid) throws Exception {
		
		this.delete("remove_role", iid);
	}
	
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
	public List<AsRoleUserVo> getRoleuserVo(int roleid)
	{
		List<AsRoleUserVo> asRoleUser = this.queryForList("getRoleuser_by_role",roleid);
		return asRoleUser;
	}
	
	
	/**
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
	public int romeveRoleUser(String sql)throws Exception
	{
		return this.delete("remove_roleUser",sql);
	}
	
	/**
	 * 
	 * getEpartment(查询部门)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-7 下午10:34:45
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param   cname 名称        
	 * @return List<HashMap> 部门树
	 *
	 */
	public List<HashMap> getEpartment(String cname)
	{
		List<HashMap> epartmentList = new ArrayList();
		try
		{
			HashMap<String, String> map = new HashMap<String, String>();
            map.put("cname", cname);

            //lr add  如果是这两个字段，说明是请求 所有部门 或者 仅启用部门
            if(cname.equals("true")||cname.equals("false"))
                map.put("cname", "");

            if(cname.equals("true"))
			    epartmentList= this.queryForList("getepartment_by_cname_all",map);
            else
                epartmentList= this.queryForList("getepartment_by_cname",map);
		}
		catch (Exception e) {
			e.printStackTrace();
		}
		return epartmentList;
	}

    public List<HashMap> getEpartment1(HashMap hashMap) {
        if(!hashMap.containsKey("cname"))
            hashMap.put("cname","");

        List<HashMap> epartmentList = new ArrayList();
        try {
            //lr add  如果是这两个字段，说明是请求 所有部门 或者 仅启用部门
            if (hashMap.containsKey("isAll") && new Boolean(hashMap.get("isAll").toString())){
                epartmentList = this.queryForList("getepartment_by_cname_all", hashMap);
            }else{
                epartmentList = this.queryForList("getepartment_by_cname", hashMap);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }
        return epartmentList;
    }
	
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
	public List<HashMap> getEpartmentUser(HashMap paramMap)
	{
		
		List<HashMap> epartmentList =new ArrayList<HashMap>();
		try {
			epartmentList = this.queryForList("getUser_by_cname",paramMap);
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		
		return epartmentList;
	}
	
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
	public Object addRoleUser(HashMap param)throws Exception
	{
		return this.insert("add_roleUser",param);
	}
	
	/**
	 * 
	 * getRdrecordCcode(查询客商资产所对应的出库单据的ccode)
	 * 创建者：lzx
	 * 创建时间：2012-8-30
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param   param 添加值      
	 * @return 是否添加成功
	 *
	 */
	public List<HashMap> getRdrecordCcode(String sql) throws Exception {
		return this.queryForList("get_rdrecord_ccode", sql);
	}
	/**
	 * 
	 * getFields(查询ifuncregedit对应的fields)
	 * 创建者：lzx
	 * 创建时间：2012-9-5
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param   param 添加值      
	 * @return 是否添加成功
	 *
	 */
	public List<HashMap> getFields(int passRegedit) throws Exception {
		return this.queryForList("get_fields", passRegedit);
	}
}