/**    
 *
 * 文件名：IAsOperauthService.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-8-24    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.services;

import yssoft.vos.AsOperauthVo;

import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：IAsOperauthService    
 * 类描述：    
 * 创建人：zhong_jing 
 * 创建时间：2011-8-24 上午11:19:01        
 *     
 */
public interface IAsOperauthService {

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
	public List<AsOperauthVo> getAsOperauthVoByIrole(int irole);
	
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
	public Object addOperauth(AsOperauthVo asOperauthVo)throws Exception;
	
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
	public int removeOperauth(int irole)throws Exception;
}
