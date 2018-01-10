/**    
 *
 * 文件名：OperauthView.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-8-24    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.views;

import yssoft.services.IAsAuthcontentService;
import yssoft.services.IAsOperauthService;
import yssoft.services.IRoleService;
import yssoft.utils.ToXMLUtil;
import yssoft.vos.AsOperauthVo;

import java.util.HashMap;
import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：OperauthView    
 * 类描述：    
 * 创建人：zhong_jing 
 * 创建时间：2011-8-24 上午08:44:03        
 *     
 */
public class AsOperauthView {

	//角色业务层
	private IRoleService iRoleService;
	
	//操作权限业务层
	private IAsAuthcontentService iAsAuthcontentService;
	
	//操作权限分配
	private IAsOperauthService iAsOperauthService;
	
	private List<HashMap> authcontentVos;
	

	public void setiRoleService(IRoleService iRoleService) {
		this.iRoleService = iRoleService;
	}
	
	public void setiAsAuthcontentService(IAsAuthcontentService iAsAuthcontentService) {
		this.iAsAuthcontentService = iAsAuthcontentService;
	}
	
	public void setiAsOperauthService(IAsOperauthService iAsOperauthService) {
		this.iAsOperauthService = iAsOperauthService;
	}

	/**
	 *  
	 * queryTree(查询角色树，操作权限树)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-24 上午08:52:41
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @return HashMap<String,String> 角色树，操作权限树
	 *
	 */
	public HashMap<String, String> queryTree()
	{
		HashMap<String, String> treeHashMap = new HashMap<String, String>();
		
		HashMap paramHashMap = new HashMap();
		paramHashMap.put("isT", "1");
		paramHashMap.put("buse", true);
		
		authcontentVos =this.iAsAuthcontentService.getAsAuthcontentVos(paramHashMap);
		treeHashMap.put("roleTree",  ToXMLUtil.createTree(this.iRoleService.getRolesByIpid(paramHashMap), "iid", "ipid", "-1"));
		treeHashMap.put("authcontentTree", ToXMLUtil.createTree(authcontentVos, "iid", "ipid", "-1"));
		return treeHashMap;
	}
	
	/**
	 * 
	 * getAsOperauthVoByIrole(查询已经分配过的权限)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-24 上午11:37:13
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param irole 角色编号
	 * @return String
	 * @Exception 异常对象    
	 *
	 */
	public String getAsOperauthVoByIrole(int irole)
	{
		List<AsOperauthVo> asOperauthVos =this.iAsOperauthService.getAsOperauthVoByIrole(irole);
		for(HashMap authcontentVo : authcontentVos)
		{
			authcontentVo.put("state", 0);
		}
		if(asOperauthVos.size()>0)
		{
			for (AsOperauthVo asOperauthVo : asOperauthVos) {
				for (HashMap authcontentVo : authcontentVos) {
					if(asOperauthVo.getCoperauth().equals(authcontentVo.get("coperauth")))
					{
						authcontentVo.put("state", 1);
						break;
					}
				}
			}
			
			return ToXMLUtil.createTree(authcontentVos, "iid", "ipid", "-1");
		}
		return null;
	}
	
	/**
	 * 
	 * addOperauth(新增)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-24 下午06:04:01
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param asOperauthVo
	 * @return Object
	 * @Exception 异常对象    
	 *
	 */
	public String addOperauth(List<AsOperauthVo> asOperauthVos)throws Exception
	{
		try
		{
			if(asOperauthVos.size()>0)
			{
				this.iAsOperauthService.removeOperauth(asOperauthVos.get(0).getIrole());
				for (AsOperauthVo asOperauthVo : asOperauthVos) {
					this.iAsOperauthService.addOperauth(asOperauthVo);
				}
			}
		}catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}
		return "success";
	}
}
