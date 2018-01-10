/**    
 *
 * 文件名：IAbInvoiceatmServices.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-9-5    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.services;

import yssoft.vos.AbInvoiceatmVo;

import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：IAbInvoiceatmServices    
 * 类描述：    
 * 创建人：朱毛毛 
 * 创建时间：2011-2011-9-5 下午02:35:04        
 *     
 */
public interface IAbInvoiceatmService {
	public List selectFile(Object params);
	public int insertFile(AbInvoiceatmVo params) throws Exception;
	public int deleteFile(Object params) throws Exception;
}
