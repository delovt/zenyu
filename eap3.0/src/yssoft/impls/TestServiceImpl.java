/**    
 * 文件名：TestServiceImpl.java    
 *    
 * 版本信息：    
 * 日期：2011 2011-8-3 下午02:35:58  
 * Copyright 足下 Corporation 2011     
 * 版权所有 徐州市增宇软件有限公司
 *    
 */
package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.ITestService;

import java.util.HashMap;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：TestServiceImpl    
 * 类描述：    
 * 创建人：zmm    
 * 创建时间：2011-8-3 下午02:35:58    
 * 修改人：zmm    
 * 修改时间：2011-8-3 下午02:35:58    
 * 修改备注：    
 * @version     
 *     
 */
public class TestServiceImpl extends BaseDao implements ITestService {

	/* (non-Javadoc)    
	 * @see yssoft.services.ITestService#addTest(java.util.HashMap)    
	 */
	@Override
	public void addTest(HashMap params) throws Exception {
		this.insert("test.trans.insert", params);
	}

}
