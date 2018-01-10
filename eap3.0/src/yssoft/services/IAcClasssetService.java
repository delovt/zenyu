/**    
 *
 * 文件名：IListsetService.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-8-16    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.services;

import java.util.HashMap;
import java.util.List;


/**    
 *     
 * 项目名称：yscrm    
 * 类名称：IListsetService    
 * 类描述：    
 * 创建人：zhong_jing 
 * 创建时间：2011-8-16 下午05:25:00        
 *     
 */
public interface IAcClasssetService {

	
	
	/**
	 * 
	 * getListcd(列表配置常用条件查询)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-20 上午11:35:53
	 * 修改者：Lenovo
	 * 修改时间：2011-9-20 上午11:35:53
	 * 修改备注：   
	 * @return List<HashMap>
	 * @Exception 异常对象    
	 *
	 */
	public List<HashMap> getListcd(HashMap paramObj);
	public List<HashMap> getListcd2(HashMap paramObj);
	public List<HashMap> getDatadicSql(String iid);

}
