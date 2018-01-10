/**    
 *
 * 文件名：AsOperauthServiceImpl.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-8-24    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IAsOperauthService;
import yssoft.vos.AsOperauthVo;

import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：AsOperauthServiceImpl    
 * 类描述：    
 * 创建人：zhong_jing 
 * 创建时间：2011-8-24 上午11:21:26        
 *     
 */
public class AsOperauthServiceImpl extends BaseDao implements
		IAsOperauthService {

	/**
	 * 
	 * getAsOperauthVoByIrole(按照角色查询操作权限)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-24 上午11:20:00
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param irole 角色编号
	 * @return List<AsOperauthVo>
	 * @Exception 异常对象    
	 *
	 */
	public List<AsOperauthVo> getAsOperauthVoByIrole(int irole) {
		return (List<AsOperauthVo>)this.queryForList("get_operauth_byRoleId",irole);
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
	public Object addOperauth(AsOperauthVo asOperauthVo)throws Exception
	{
		return this.insert("add_operauth",asOperauthVo);
	}
	
	/**
	 * 
	 * removeOperauth(删除)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-25 上午08:52:27
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param irole
	 * @return int
	 * @Exception 异常对象    
	 *
	 */
	public int removeOperauth(int irole)
	{
		return this.delete("remove_operauth",irole);
	}

}
