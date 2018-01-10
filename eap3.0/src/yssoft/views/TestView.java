/**    
 * 文件名：TestView.java    
 *    
 * 版本信息：    
 * 日期：2011 2011-8-3 下午02:39:17  
 * Copyright 足下 Corporation 2011     
 * 版权所有 徐州市增宇软件有限公司
 *    
 */
package yssoft.views;

import yssoft.exceptions.CRMRuntimeException;
import yssoft.services.ITestService;

import java.util.HashMap;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：TestView    
 * 类描述：    
 * 创建人：zmm    
 * 创建时间：2011-8-3 下午02:39:17    
 * 修改人：zmm    
 * 修改时间：2011-8-3 下午02:39:17    
 * 修改备注：    
 * @version     
 *     
 */
public class TestView {
	
	private ITestService iTestService;
	/**
	 * 
	 * @auth:  		zmm  
	 * @date： 		2011 2011-8-3 下午02:40:30  
	 * @param:     
	 * @return: 	void
	 */
	public void setiTestService(ITestService iTestService) {
		this.iTestService = iTestService;
	}
	
	public String addTest(HashMap params){
		try {
			iTestService.addTest(params);
			return "测试成功";
		} catch (Exception e) {
			e.printStackTrace();
			throw new CRMRuntimeException("测试sqlser2000事务回滚");
		}
	}


}
