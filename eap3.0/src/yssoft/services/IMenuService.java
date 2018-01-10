/**    
 * 文件名：IMenuService.java    
 *    
 * 版本信息：    
 * 日期：2011-8-4    
 * 版权所有    
 *    
 */
package yssoft.services;

import yssoft.vos.AsMenuVo;

import java.util.HashMap;
import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：IMenuService    
 * 类描述：菜单接口
 * 创建人：刘磊  
 * 创建时间：2011-8-4 下午18:24:23    
 * 修改人：刘磊   
 * 修改时间：2011-8-4 下午18:24:23    
 * 修改备注：    
 * @version     
 *     
 */
public interface IMenuService {

	/**
	 * 
	 * getMenusByIpid(按照父节点查询菜单)    
	 * @param  asMenuVo  父节点编号
	 * @return   所有菜单   
	 * @since  CodingExample　Ver(编码范例查看) 1.1
	 */
	public List<HashMap> getMenusByIpid(AsMenuVo asMenuVo);
	
	/**
	 * getAuthMenus(根据用户Id 来获取用户的权限菜单)
	 * 创建者：zmm
	 * 创建时间：2011-2011-8-6 下午03:32:11
	 * 修改者：zmm
	 * 修改时间：2011-2011-8-6 下午03:32:11
	 * 修改备注：   
	 * @param   String UserId 用户id       
	 * @return List
	 * @Exception Exception 异常对象    
	 *
	 */
	public List getAuthMenus(HashMap param) throws Exception;

    public List getPersonAuthMenus(HashMap param) throws Exception;
	
	/**
	 * 
	 * addMenu(新增菜单)    
	 * @param   asMenuVo 要新增的对象    
	 * @Exception 是否保存成功  
	 * @since  CodingExample　Ver(编码范例查看) 1.1
	 */
	public Object addMenu(AsMenuVo asMenuVo) throws Exception;
	
	/**
	 * 
	 * updateMenu(修改菜单)    
	 * @param  asMenuVo 修改的内容   
	 * @Exception 异常对象    
	 * @since  CodingExample　Ver(编码范例查看) 1.1
	 */
	public String updateMenu(AsMenuVo asMenuVo) throws Exception;
	
	/**
	 * 
	 * deleteMenu(删除菜单)    
	 * @param   ipid 内码    
	 * @Exception 异常对象    
	 * @since  CodingExample　Ver(编码范例查看) 1.1
	 */
	public String deleteMenu(int iid) throws Exception;
}