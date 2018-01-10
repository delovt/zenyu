/**    
 *
 * 文件名：MsgView.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-9-29    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.views;

import yssoft.exceptions.CRMRuntimeException;
import yssoft.services.IMsgService;
import yssoft.services.IUserService;
import yssoft.utils.ToXMLUtil;

import java.util.Date;
import java.util.HashMap;
import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：MsgView    
 * 类描述：    
 * 创建人：朱毛毛 
 * 创建时间：2011-2011-9-29 下午10:34:41        
 *     
 */
public class MsgView {
	private IMsgService iMsgService;
	private IUserService iUserService;

	public void setiUserService(IUserService iUserService) {
		this.iUserService = iUserService;
	}

	public void setiMsgService(IMsgService iMsgService) {
		this.iMsgService = iMsgService;
	}
	
	public List select_department_items(){
		return this.iMsgService.select_department_items();
	}
	public List select_person_items(){
		return this.iMsgService.select_person_items();
	}
	public List select_history_msg_items(){
		return this.iMsgService.select_history_msg_items();
	}
	public void insert_msg_item(Object params){
		this.iMsgService.insert_msg_item(params);
	}
	
	//获取 人员，部门信息
	public HashMap getDeptPersonInfo(){
		HashMap map=new HashMap();
		List list = this.select_department_items();
		String xmlstr = ToXMLUtil.createTree(list,"iid","ipid","-1");
		map.put("dept_xml",xmlstr);
		list = this.select_person_items();
		xmlstr=ToXMLUtil.createTreeFromList(list);
		map.put("person_xml",xmlstr);
		return map;
	}
	
	public String sendMsg(HashMap msgBody){
		try{
			this.iMsgService.sendMsg(msgBody,"MsgCenter");
			return "suc";
		}catch(Exception e){
			return "fail";
		}
	}
	
	public List select_msg_items(HashMap params){
		user_update_timestamp(params.get("irperson").toString());
		return this.iMsgService.select_msg_items(params);
	}
	public String update_msg_item(HashMap params){
		try{
			this.iMsgService.update_msg_item(params);
			return "suc";
		} catch (Exception e) {
			e.printStackTrace();
			throw new CRMRuntimeException("更新消息状态失败");
		}
	}
	
	public String update_msg_item_subhome(HashMap params){
		try{
			this.iMsgService.update_msg_item_subhome(params);
			return "suc";
		} catch (Exception e) {
			e.printStackTrace();
			throw new CRMRuntimeException("subhome,更新消息状态失败");
		}
	}
	
	public String del_message_middle_item(HashMap params){
		try{
			this.iMsgService.del_message_middle_item(params);
			return "suc";
		}catch(Exception e){
			e.printStackTrace();
			return "fail";
		}
	}
	
	// 更新用户在线时间戳
	//更新用户在线时间戳
	public void user_update_timestamp(String iperson){
		HashMap tsparam=new HashMap();
		String timestamp=""+(new Date()).getTime();
		tsparam.put("iperson",iperson);
		tsparam.put("timestamp",timestamp);
		this.iUserService.user_update_timestamp(tsparam);
	}

    public void updateMsgIsmsStatus(HashMap params) {
        try {
            iMsgService.msgUpdateIsmsStatus(params);
        } catch (Exception e) {
            e.printStackTrace();  //To change body of catch statement use File | Settings | File Templates.
        }
    }
	
}
