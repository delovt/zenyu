/**    
 *
 * 文件名：IWorkFlowManageService.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-9-2    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.services;

import java.util.HashMap;
import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：IWorkFlowManageService    
 * 类描述：协同管理   
 * 创建人：朱毛毛 
 * 创建时间：2011-2011-9-2 上午10:02:19        
 *     
 */
public interface IWorkFlowManageService {
	//待办事项
	public List selectDdsx(HashMap params);
	//已办事项
	public List selectYdsx(HashMap params);
	//跟踪事项
	public List selectGzsx(HashMap params);
	//待发事项
	public List selectDfsx(HashMap params);
	//已发事项
	public List selectYfsx(HashMap params);
}
