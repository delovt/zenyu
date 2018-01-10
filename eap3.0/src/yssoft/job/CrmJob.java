/**    
 *
 * 文件名：CrmJob.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-10-18    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.job; 

import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;
import org.springframework.scheduling.quartz.QuartzJobBean;

/**    
 *     
 * 项目名称：rkycrm_zg    
 * 类名称：CrmJob    
 * 类描述：    
 * 创建人：朱毛毛 
 * 创建时间：2011-2011-10-18 下午12:41:13        
 *     
 */
public class CrmJob extends QuartzJobBean {
	

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-10-18 下午12:41:18
	 * 方法描述: 
	 *   
	 */
	@Override
	protected void executeInternal(JobExecutionContext arg0)throws JobExecutionException {
		// TODO Auto-generated method stub
		System.out.println("---spring job----");
	}

}
