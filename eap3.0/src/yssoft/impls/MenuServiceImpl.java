/**    
 * 文件名：MenuService.java    
 *    
 * 版本信息：    
 * 日期：2011-8-1    
 * 版权所有    
 *    
 */
package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IMenuService;
import yssoft.utils.ToolUtil;
import yssoft.vos.AsMenuVo;

import java.util.HashMap;
import java.util.List;

/**
 * 
 * 项目名称：yscrm
 * 
 * 类名称：MenuService
 * 
 * 类描述：菜单业务实现类
 * 
 * 创建人：刘磊
 * 
 * 创建时间：2011-8-5
 * 
 * 下午02:17:30 修改人：刘磊
 * 
 * 修改时间：2011-8-5 下午02:17:30 修改备注：
 * 
 * @version
 * 
 */
public class MenuServiceImpl extends BaseDao implements IMenuService {
	

	/**
	 * 
	 * getMenusByIpid(按照父节点查询菜单)
	 * @param ipid
	 * 父节点编号
	 * @return 所有菜单
	 * @since CodingExample　Ver(编码范例查看) 1.1
	 */
	public List<HashMap> getMenusByIpid(AsMenuVo asMenuVo) {
		return this.queryForList("get_all_AsMenu", asMenuVo);
	}

	/**
	 * 
	 * addMenu(新增菜单)
	 * @param asMenuVo
	 * 要新增的对象
	 * @Exception 是否保存成功
	 * @since CodingExample　Ver(编码范例查看) 1.1
	 */
	public Object addMenu(AsMenuVo asMenuVo) throws Exception {
		Object object = this.insert("add_AsMenu", asMenuVo);
		return object;
	}

	/**
	 * 
	 * updateMenu(修改菜单)
	 * @param asMenuVo
	 * 修改的内容
	 * @Exception 异常对象
	 * @since CodingExample　Ver(编码范例查看) 1.1
	 */
	public String updateMenu(AsMenuVo asMenuVo) throws Exception {
		
		// 获得编码
		String ccode = ToolUtil.getPid(asMenuVo.getCcode());
		
		int count = update("update_AsMenu", asMenuVo);
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
	 * deleteRolse(删除菜单)
	 * @param ipid
	 * 内码
	 * @Exception 异常对象
	 * @since CodingExample　Ver(编码范例查看) 1.1
	 */
	public String deleteMenu(int iid) throws Exception {
		int count = this.delete("delete_AsMenu", iid);
		if(count==1)
		{
			return "success";
		}
		else
		{
			return "fail";
		}
	}

	/**
	 * getAuthMenus(删除菜单)
	 * @param UserId 用户ID
	 * @Exception 异常对象
	 */
	public List getAuthMenus(HashMap param) throws Exception {
		return this.queryForList("get_auth_AsMenu", param);
	}

    @Override
    public List getPersonAuthMenus(HashMap param) throws Exception {
        return this.queryForList("get_person_auth_AsMenu", param);
    }
}