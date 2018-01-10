/**    
 *
 * 文件名：InvoicepropertyImpl.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-8-22    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IInvoicepropertyService;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：InvoicepropertyImpl    
 * 类描述：    
 * 创建人: zmm
 * 创建时间：2011-2011-8-22 下午07:22:30        
 *     
 */
public class InvoicepropertyServiceImpl extends BaseDao implements IInvoicepropertyService {

	@Override
	public int insertImaker(Object params) {
		// TODO Auto-generated method stub
		return (Integer) this.insert("invoice.insertImaker", params);
	}

	@Override
	public String updateIaccounting(Object params) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String updateIclose(Object params) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String updateIdelete(Object params) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String updateImodify(Object params) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public String updateIverify(Object params) {
		// TODO Auto-generated method stub
		return null;
	}

}
