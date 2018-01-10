/**    
 *
 * 文件名：IWFMessageService.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-9-1    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.services;

import java.util.HashMap;
import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：IWFMessageService    
 * 类描述：协同 回复信息
 * 创建人：朱毛毛 
 * 创建时间：2011-2011-9-1 下午01:49:55        
 *     
 */
public interface IWFMessageService {
	public List getMessages(Object params) throws Exception;
	public List getMessagesHide(Object params) throws Exception;
	public int insertMessage(Object params) throws Exception;
	public void updateMessage(Object params) throws Exception;
	public void deleteMessage(Object params) throws Exception;
	public List getFormMessages(Object params);
	
	//插入 震荡消息
	public int insertzdmsg(HashMap params);
	//获取 震荡消息
	public List getzdmsgs(HashMap params);
	
	//写入 推送的震荡消息 
	public void insertdszdmsg(HashMap params) throws Exception;
	//获取 推送震荡消息关联的 人员的阅读状态
	public List getdszdmsgs(HashMap params);
	
	//相关单据一打开，就设置，登录人对应的单据的所属的消息 为已阅读 
	public void editdjmsgreaded(HashMap params);
}
