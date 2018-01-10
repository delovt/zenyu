/**    
 *
 * 文件名：SessionHandler.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-9-30    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.online;

import yssoft.utils.ToolUtil;

import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;
import java.util.Date;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：SessionHandler    
 * 类描述：    
 * 创建人：朱毛毛 
 * 创建时间：2011-2011-9-30 下午01:30:51        
 *     
 */
public class SessionHandler implements HttpSessionListener {

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-30 下午01:30:51
	 * 方法描述: 
	 *   
	 */
	@Override
	public void sessionCreated(HttpSessionEvent e) {
		System.out.println("---会话创建,有效期["+e.getSession().getMaxInactiveInterval()+"],创建时间:["+ToolUtil.formatDay(new Date(),null)+"],会话id:["+e.getSession().getId()+"]");
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-30 下午01:30:51
	 * 方法描述: 
	 *   
	 */
	@Override
	public void sessionDestroyed(HttpSessionEvent e) {
		System.out.println("---会话销毁,销毁时间:["+ToolUtil.formatDay(new Date(),null)+"],会话id:["+e.getSession().getId()+"]");
	}

}
