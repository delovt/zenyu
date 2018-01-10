/**    
 *
 * 文件名：invoicepropertyAop.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-8-22    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.aops;

import org.springframework.aop.AfterReturningAdvice;

import java.lang.reflect.Method;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：invoicepropertyAop    
 * 类描述：插入公共单据 aop
 * 创建人：zmm 
 * 
 * 创建时间：2011-2011-8-22 下午04:43:45        
 *     
 */
public class InvoicepropertyAop implements AfterReturningAdvice {

	/**
	 *     
	 * @see org.springframework.aop.AfterReturningAdvice#afterReturning(java.lang.Object, java.lang.reflect.Method, java.lang.Object[], java.lang.Object) 
	 *   
	 */
	@Override
	public void afterReturning(Object arg0, Method arg1, Object[] arg2,Object arg3) throws Throwable {
		System.out.println("---后置通知，切入成功---["+arg2.toString()+"]");
	}

}
