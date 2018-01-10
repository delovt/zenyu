/**    
 *
 * 文件名：PageView.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-8-24    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.views;

import yssoft.services.IPageService;

import java.util.HashMap;
import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：PageView    
 * 类描述：    
 * 创建人：zmm 
 * 创建时间：2011-2011-8-24 下午10:03:24        
 *     
 */
public class PageView {
	private IPageService iPageService;
	public void setiPageService(IPageService iPageService) {
		this.iPageService = iPageService;
	}
	
	public List page(HashMap param){
		String sqlid=(String) param.get("sqlid");
		HashMap params=(HashMap) param.get("params");
		return this.iPageService.page(sqlid,params);
	}
}
