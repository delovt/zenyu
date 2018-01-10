/**    
 *
 * 文件名：IPageService.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-8-24    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.services;

import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：IPageService    
 * 类描述：分页
 * 创建人：zmm
 * 创建时间：2011-2011-8-24 下午09:57:29        
 *     
 */
public interface IPageService {
	//返回的数据集
	public List page(String sqlid,Object params);
	//数据集的个数
	public int  pageAllNum(String sqlid,Object params);
}
