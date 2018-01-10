/**    
 * 文件名：RoleView.java    
 *    
 * 版本信息：    
 * 日期：2011-8-1    
 * 版权所有    
 *    
 */
package yssoft.views;

import yssoft.services.IRoleService;
import yssoft.utils.ToXMLUtil;
import yssoft.utils.ToolUtil;
import yssoft.vos.AsRoleUserVo;
import yssoft.vos.AsRoleVo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * 
 * 项目名称：yscrm
 * 
 * 类名称：RoleView
 * 
 * 类描述： 角色管理视图层
 * 
 * 创建人：钟晶
 * 
 * 创建时间：2011-8-1
 * 
 * 下午10:49:46
 * 
 * 修改人：钟晶
 * 
 * 
 * 修改时间：2011-8-1
 * 
 * 下午10:49:46 修改备注：
 * 
 * @version
 * 
 */
public class RoleView {

	// 视图层的业务层
	private IRoleService iRoleService;

	public void setiRoleService(IRoleService iRoleService) {
		this.iRoleService = iRoleService;
	}

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
	public String getRolesByIpid() {
		HashMap paramHashMap = new HashMap();
		paramHashMap.put("isT", "");
		paramHashMap.put("buse", false);
		List<HashMap> roleList = this.iRoleService.getRolesByIpid(paramHashMap);
		if(roleList.size()>0)
		{
			return ToXMLUtil.createTree(roleList, "iid", "ipid", "-1");
		}
		return null;
	}

    public String getAllUsers() {
        List<HashMap> useList = this.iRoleService.getAllUser();
        if(useList.size()>0)
        {
            return ToXMLUtil.createTree(useList, "iid", "ipid", "-1");
        }
        return null;
    }

	public String getLastNode(String ccode) {
		return ToolUtil.getPid(ccode);
	}

	/**
	 * 
	 * 
	 * addRole(新增角色)
	 * 
	 * @param roleVo
	 *            要新增的对象
	 * 
	 * @return 是否保存成功
	 * 
	 * @since CodingExample　Ver(编码范例查看) 1.1
	 */
	public String addRole(AsRoleVo roleVo) {
		// 默认声明结果集为成功
		try {
			// 插入角色
			Object resultObj = this.iRoleService.addRole(roleVo);
			return resultObj.toString();
		} catch (Exception e) {
			e.printStackTrace();
			// 如抛异常，则插入失败
			return "fail";
		}
	}

	/**
	 * 
	 * 
	 * updateRole(修改角色)
	 * 
	 * @param roleVo
	 *            修改的内容
	 * 
	 * @return 是否保存成功
	 * 
	 * @since CodingExample　Ver(编码范例查看) 1.1
	 */
	public String updateRole(AsRoleVo roleVo) {
		// 默认声明结果集为成功
		String result = "sucess";
		try {
			result = this.iRoleService.updateRole(roleVo);
		} catch (Exception e) {
			// 如抛异常，则修改失败
			result = "fail";
		}
		return result;
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
	 * removeRole
	 * @since CodingExample　Ver(编码范例查看) 1.1
	 */
	public String removeRole(int iid) {
		// 默认声明结果集为成功
		String result = "sucess";
		try {
			 this.iRoleService.removeRole(iid);
		} catch (Exception e) {
			// 如抛异常，则删除失败
			result = "fail";
		}
		return result;
	}

	/**
	 * 
	 * 
	 * getRoleuserVo(查询角色与用户关联表) 
	 * 创建者：zhong_jing 
	 * 创建时间：2011-2011-8-7 下午09:33:03
	 * 修改者： 修改时间: 修改备注：
	 * 
	 * @param roleid
	 *            较色编号
	 * @return List<AsRoleUserVo> 用户信息
	 * 
	 */
	public List<AsRoleUserVo> getRoleuserVo(int roleid) {
		return this.iRoleService.getRoleuserVo(roleid);
	}

	/**
	 * 
	 * 
	 * deleteRoleUser(删除职员) 
	 * 创建者：zhong_jing 
	 * 创建时间：2011-8-7 下午10:34:45 
	 * 修改者： 修改时间：
	 * 修改备注：
	 * 
	 * @param iids选中编号
	 * @return String 是否成功
	 * @Exception 异常对象
	 * 
	 */
	public String romeveRoleUser(List iids) {
		try {
			String sql = getSql(iids);
			int count = this.iRoleService.romeveRoleUser(sql);
			if(count!=iids.size())
			{
				return "fail";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}
		return "success";
	}
	
	private String getSql(List iids)
	{
		StringBuffer iidStr = new StringBuffer();
		
		for (int i = 0; i < iids.size(); i++) {
			if(i==0)
			{
				iidStr.append("(");
			}
			if (i > 0) {
				iidStr.append(" or ");
			}
			HashMap asRoleUserVo = (HashMap) iids.get(i);
			iidStr.append(" iid=");
			iidStr.append(asRoleUserVo.get("iid"));
		}
		if (iidStr.length() > 0) {
			iidStr.append(")");
		}
		return iidStr.toString();
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
	public List<AsRoleUserVo> getEpartment(int roleId) {
		return this.iRoleService.getRoleuserVo(roleId);

	}
	
	/**
	 * 
	 * getEpartment(查询部门)
	 * 创建者：zhong_jing 
	 * 创建时间：2011-8-7 下午10:34:45 
	 * 修改者： 修改时间：
	 * 修改备注：
	 * 
	 * @param cname
	 *            名称
	 * @return List<HashMap> 部门树
	 * 
	 */
	public String getDepartment(String cname)
	{
		List d = this.iRoleService
		.getEpartment(cname);
		if(d.size()==0)
		{
			return null;
		}
		else
		{
			return ToXMLUtil.createTree(this.iRoleService
						.getEpartment(cname), "iid",
						"ipid", "-1");
		}
	}

    public String getDepartment(HashMap hashMap)
    {
        List d = this.iRoleService.getEpartment1(hashMap);
        if(d.size()==0)
        {
            return null;
        }
        else
        {
            return ToXMLUtil.createTree(d, "iid","ipid", "-1");
        }
    }

	/**
	 * 
	 * getEpartmentUser(查询部门) 
	 * 创建者：zhong_jing 
	 * 创建时间：2011-8-10 下午10:34:45 
	 * 修改者：
	 * 修改时间： 修改备注：
	 * @param idepartment
	 *            部门编码
	 * @return List<HashMap> 部门树
	 * 
	 */
	public List<HashMap> getEpartmentUser(HashMap paramMap) {
		return this.iRoleService.getEpartmentUser(paramMap);
	}

	/**
	 * 
	 * addRoleUser(添加角色和用户相对应) 创建者：zhong_jing 创建时间：2011-8-10 下午10:34:45 修改者：
	 * 修改时间： 修改备注：
	 * 
	 * @param param
	 *            添加值
	 * @return 是否添加成功
	 * 
	 */
	public List addRoleUser(HashMap param) {
		
		HashMap newParam = new HashMap();
		
		List resultList = new ArrayList();
		try {
			List addRoleList = (List) param.get("addRole");
			if(addRoleList.size()>0)
			{
				for(int i=0;i<addRoleList.size();i++)
				{
					HashMap roleUser = (HashMap)addRoleList.get(i);
					newParam.put("irole", param.get("irole"));
					newParam.put("iperson", roleUser.get("iid"));
					
					int iid = Integer.valueOf(this.iRoleService.addRoleUser(newParam).toString()).intValue();
					roleUser.put("iid", iid);
					resultList.add(roleUser);
				}
			}
			List iids = (List)param.get("iids");
			if(iids.size()>0)
			{
				String result = romeveRoleUser(iids);
				if(result=="fail")
				{
					return null;
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		return resultList;
	}
}
