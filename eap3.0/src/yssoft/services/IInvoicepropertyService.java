/**    
 *
 * 文件名：IInvoicepropertyService.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-8-22    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.services;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：IInvoicepropertyService    
 * 类描述：公共表单属性 
 * 创建人：zmm
 * 创建时间：2011-2011-8-22 下午07:13:00        
 *     
 */
public interface IInvoicepropertyService {
	public int insertImaker(Object params);
	public String updateImodify(Object params);
	public String updateIverify(Object params);
	public String updateIaccounting(Object params);
	public String updateIclose(Object params);
	public String updateIdelete(Object params);
}
