/**    
 * 文件名：MenuView.java    
 *    
 * 版本信息：    
 * 日期：2011-8-5   
 * 版权所有    
 *    
 */
package yssoft.views;

import yssoft.services.IMenuService;
import yssoft.utils.ToXMLUtil;
import yssoft.vos.AsMenuVo;

import java.util.HashMap;
import java.util.List;

/**
 * 
 * 项目名称：yscrm 
 * 
 * 类名称：MenuView 
 * 
 * 类描述： 菜单管理视图层 
 * 
 * 创建人：刘磊
 * 
 * 创建时间：2011-8-5 
 * 
 * 下午13:49:46 
 * 
 * 修改人：刘磊
 * 
 * 
 * 修改时间：2011-8-5 
 * 
 * 下午13:49:46 修改备注：
 * 
 * @version
 * 
 */
public class MenuView {

	// 视图层的业务层
	private IMenuService iMenuService;


	public void setiMenuService(IMenuService iMenuService) {
		this.iMenuService = iMenuService;
	}

	/**
	 * 
	 * getMenusByIpid(按照父节点查询菜单)    
	   
	 * @param  ipid  父节点编号
	   
	 * @return   所有菜单   
	   
	 * @since  CodingExample　Ver(编码范例查看) 1.1
	 */
	public String getMenusByIpid(AsMenuVo asMenuVo)
	{
		/******************************创建树******************************/
		List<HashMap> menuList = this.iMenuService.getMenusByIpid(asMenuVo);
		if (menuList.size()==0)
		{
			return null;
		}
		else
		{
		    return ToXMLUtil.createTree(menuList, "iid", "ipid", "-1");
		}
		/******************************创建树******************************/
	}
	
	/**
	 * 
	   
	 * addMenu(新增菜单)    
	   
	 * @param   asMenuVo 要新增的对象    
	   
	 * @return  是否保存成功    
	   
	 * @since  CodingExample　Ver(编码范例查看) 1.1
	 */
	public String addMenu(AsMenuVo asMenuVo)
	{
		//默认声明结果集为成功
		String result ="sucess";
		try
		{
			//插入菜单
			Object resultObj = this.iMenuService.addMenu(asMenuVo);
		    result = resultObj.toString();
		}
		catch (Exception e) {
			//如抛异常，则插入失败
			result ="fail";
		}
		return result;
	}
	
	/**
	 * 
	   
	 * updateMenu(修改菜单)    
	   
	 * @param  AsMenuVo 修改的内容   
	   
	 * @return  是否保存成功   
	   
	 * @since  CodingExample　Ver(编码范例查看) 1.1
	 */
	public String updateMenu(AsMenuVo asMenuVo){
		//默认声明结果集为成功
		String result ="sucess";
		try
		{
			this.iMenuService.updateMenu(asMenuVo);
		}
		catch (Exception e) {
			//如抛异常，则修改失败
			result ="fail";
		}
		return result;
	}
	
	
	/**
	 * 
	   
	 * deleteMenu(删除菜单)    
	 * 
	 * @param   ipid 内码    
	   
	 * @Exception 异常对象    
	   
	 * @since  CodingExample　Ver(编码范例查看) 1.1
	 */
	public String deleteMenu(int iid)
	{
		//默认声明结果集为成功
		String result ="sucess";
		try
		{
			this.iMenuService.deleteMenu(iid);
		}
		catch (Exception e) {
			//如抛异常，则删除失败
			result ="fail";
		}
		return result;
	}
	/**
	 * getAuthMenus(根据用户id 来获取用户权限菜单，目前废弃)
	 * @author zmm
	 * @param  UserId 用户id
	 * 废弃时间  2011-08-21
	 */
//	public String getAuthMenus(String UserId){
//		try {
//			List menuList=this.iMenuService.getAuthMenus(UserId);
//			String xmlstr =ToXMLUtil.createTree(menuList, "iid", "ipid", "-1");
//			return xmlstr;
//		} catch (Exception e) {
//			e.printStackTrace();
//			return "";
//		}
//	}


}
