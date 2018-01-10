/**    
 *
 * 文件名：IPrintService.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-10-19    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.services;

import java.util.List;

/**    
 *     
 * 项目名称：rkycrm_zg    
 * 类名称：IPrintService    
 * 类描述：    
 * 创建人：朱毛毛 
 * 创建时间：2011-2011-10-19 下午03:29:02        
 *     
 */
public interface IPrintService {
	//获取模板
	public Object print_selete_item(Object param);
	public List print_selete_items(Object param);
}
