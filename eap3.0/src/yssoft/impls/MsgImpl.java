/**    
 *
 * 文件名：MsgImpl.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-9-29    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.impls;

import flex.messaging.MessageBroker;
import flex.messaging.messages.AsyncMessage;
import yssoft.daos.BaseDao;
import yssoft.services.IMsgService;

import java.util.Date;
import java.util.HashMap;
import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：MsgImpl    
 * 类描述：    
 * 创建人：朱毛毛 
 * 创建时间：2011-2011-9-29 下午10:31:16        
 *     
 */
public class MsgImpl extends BaseDao implements IMsgService {

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-29 下午10:31:16
	 * 方法描述: 
	 *   
	 */
	@Override
	public void insert_msg_item(Object params) {
		// TODO Auto-generated method stub
		this.insert("msg.insert_msg_item", params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-29 下午10:31:16
	 * 方法描述: 
	 *   
	 */
	@Override
	public List select_department_items() {
		// TODO Auto-generated method stub
		return this.queryForList("msg.select_department_items");
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-29 下午10:31:16
	 * 方法描述: 
	 *   
	 */
	@Override
	public List select_history_msg_items() {
		// TODO Auto-generated method stub
		return this.queryForList("msg.select_history_msg_items");
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-9-29 下午10:33:14
	 * 方法描述: 
	 *   
	 */
	@Override
	public List select_person_items() {
		// TODO Auto-generated method stub
		return this.queryForList("msg.select_person_items");
	}
	
	/**
	 * 
	 * @param info  	消息内容
	 * @param msgType	消息类型	
	 * @param sender	消息发送者
	 * @param receiver	消息接受者
	 * @param dest		消息通道
	 */
	public String sendMsg(HashMap msgBody,String dest){
		System.out.println("---发送信息开始启动---");
		if(msgBody == null){
			return "消息体结构错误";
		}
		int sender=(Integer) msgBody.get("isperson");
		if(sender==0){
			return "发送人不能为空";
		}
		int msgType=(Integer) msgBody.get("itype");
		int receiver= (msgBody.get("irperson") == null ? 0:(Integer) msgBody.get("irperson"));
		String isonline=(String) msgBody.get("isonline");
		
		//System.out.println("111"+isonline);
		
		if("1".equals(isonline)){ // 接收人在线，就发送在线消息
			String msgid=msgType+"_"+System.currentTimeMillis()+"_"+Math.random()*100;
			AsyncMessage msg = new AsyncMessage();
			msg.setTimestamp(new Date().getTime());
			msg.setMessageId(msgid);
			msg.setDestination(dest);
			//设置消息体
			msg.setBody(msgBody);
			//设置消息头部 
			msg.setHeader("itype",msgType);
			msg.setHeader("isperson",sender);
			msg.setHeader("irperson",receiver);
			//发送消息到消息中心
			MessageBroker.getMessageBroker(null).routeMessageToService(msg, null);
			System.out.println("---向指定目标发送信息---");
			// 消息入库
			msgBody.put("ifuncregedit",0);
			msgBody.put("iinvoice",0);
		}
		this.insert_msg_item(msgBody);
		return "suc";
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-10-21 上午09:20:50
	 * 方法描述: 
	 *   
	 */
	@Override
	public List select_msg_items(Object params) {
		// TODO Auto-generated method stub
		return this.queryForList("msg.select_msg_items", params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-10-21 上午09:20:50
	 * 方法描述: 
	 *   
	 */
	@Override
	public void update_msg_item(Object params) throws Exception {
			this.update("msg.update_msg_item", params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-11-7 下午04:13:42
	 * 方法描述: 
	 *   
	 */
	@Override
	public void update_msg_item_subhome(Object params) throws Exception {
		// TODO Auto-generated method stub
		this.update("msg.update_msg_item_subhome",params);
	}
	
	/**
	 * sdy
	 * 删除消息中心信息 
	 * @param params
	 */
	public void del_message_middle_item(Object params){
		this.delete("msg.del_msg_item",params);
	}

    public void msgUpdateIsmsStatus(Object params) {
        this.update("msgUpdateIsmsStatus", params);
    }
}
