/**    
 *
 * 文件名：AsAuthcontent.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-8-20    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.services;

import yssoft.vos.AsAuthcontentVo;

import java.util.HashMap;
import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：AsAuthcontent    
 * 类描述：    
 * 创建人：zhong_jing 
 * 创建时间：2011-8-20 上午08:44:34        
 *     
 */
public interface IAsAuthcontentService {

	/**
	 * 
	 * addAuthcontent(新增)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-20 上午08:58:17
	 * 修改者：Lenovo
	 * 修改时间：2011-8-20 上午08:58:17
	 * 修改备注：   
	 * @param asAuthcontentVo void
	 * @Exception 异常对象    
	 *
	 */
	public Object addAuthcontent(AsAuthcontentVo asAuthcontentVo)throws Exception;
	
	/**
	 * 
	 * getAsAuthcontentVos(查询)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-20 上午09:00:09
	 * 修改者：Lenovo
	 * 修改时间：2011-8-20 上午09:00:09
	 * 修改备注：   
	 * @return List<HashMap>
	 * @Exception 异常对象    
	 *
	 */
	public List<HashMap> getAsAuthcontentVos(HashMap paramObj);
	
	/**
	 * 
	 * romveAsAuthcontentVo(删除)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-20 上午10:22:02
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param iid 编码
	 * @return int
	 * @Exception 异常对象    
	 *
	 */
	public String romveAsAuthcontentVo(int iid)throws Exception;
	
	/**
	 * 
	 * updateAsAuthcontentVo(修改)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-20 上午10:23:18
	 * 修改者：Lenovo
	 * 修改时间：2011-8-20 上午10:23:18
	 * 修改备注：   
	 * @param asAuthcontentVo
	 * @return int
	 * @Exception 异常对象    
	 *
	 */
	public String updateAsAuthcontentVo(AsAuthcontentVo asAuthcontentVo)throws Exception;
}
