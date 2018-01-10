/**    
 *
 * 文件名：AsAuthcontentServieceImpl.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-8-20    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IAsAuthcontentService;
import yssoft.vos.AsAuthcontentVo;

import java.util.HashMap;
import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：AsAuthcontentServieceImpl    
 * 类描述：    
 * 创建人：zhong_jing 
 * 创建时间：2011-8-20 上午10:23:58        
 *     
 */
public class AsAuthcontentServiceImpl extends BaseDao implements IAsAuthcontentService {

	/**
	 * 
	 * addAuthcontent(这里用一句话描述这个方法的作用)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-20 上午08:58:17
	 * 修改者：Lenovo
	 * 修改时间：2011-8-20 上午08:58:17
	 * 修改备注：   
	 * @param asAuthcontentVo void
	 * @Exception 异常对象    
	 *
	 */
	public Object addAuthcontent(AsAuthcontentVo asAuthcontentVo)throws Exception {
		
		return this.insert("add_AsAuthcontent",asAuthcontentVo);
	}

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
	public List<HashMap> getAsAuthcontentVos(HashMap paramObj) {
		return this.queryForList("get_all_AsAuthcontent",paramObj);
	}

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
	public String romveAsAuthcontentVo(int iid)throws Exception {
		int count = this.delete("remove_AsAuthcontent",iid);
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
	public String updateAsAuthcontentVo(AsAuthcontentVo asAuthcontentVo)throws Exception {
		int count =this.update("update_AsAuthcontent",asAuthcontentVo);
		
		if(count!=1)
		{
			return "fail";
		}
		else
		{
			return "success";
		}
	}

}
