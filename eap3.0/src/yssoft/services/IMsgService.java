/**    
 *
 * 文件名：IMsgService.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-9-29    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.services;

import java.util.HashMap;
import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：IMsgService    
 * 类描述：    
 * 创建人：朱毛毛 
 * 创建时间：2011-2011-9-29 下午10:23:29        
 *     
 */
public interface IMsgService {
	public List select_department_items();
	public List select_person_items();
	public List select_history_msg_items();
	public void insert_msg_item(Object params);
	public String sendMsg(HashMap msgBody,String dest);
	
	public List select_msg_items(Object params);
	public void update_msg_item(Object params) throws Exception;
	
	public void del_message_middle_item(Object params);
	// subhome 中对应修改 
	public void update_msg_item_subhome(Object params) throws Exception;

    public void msgUpdateIsmsStatus(Object params) throws Exception;
}
