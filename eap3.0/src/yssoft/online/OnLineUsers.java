/**
 * 当前在线人数
 */
package yssoft.online;

import org.apache.log4j.Logger;
import org.springframework.util.Assert;
import yssoft.vos.HrPersonVo;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class OnLineUsers {
	private static Logger logger = Logger.getLogger(OnLineUsers.class);
	private static List<HrPersonVo> userList = new ArrayList<HrPersonVo>();
	//获取在线人数
	public static List<HrPersonVo> getOnLineUsers(){
		return userList;
	}
	//添加 user
	public static void addUser(HrPersonVo hrperson){
		System.out.println("---添加一个用户---"+hrperson.getCname());
		Assert.notNull(hrperson);
		removeUserByName(hrperson.getCname());
		userList.add(hrperson);	
	}
	//根据 用户的 sessionid 来获取用户
	public static HrPersonVo getUserPojoBySid(String sid){
		Iterator<HrPersonVo> i = userList.iterator();
		while(i.hasNext()){
			HrPersonVo tp = i.next();
			if(tp.getSesssionid() != null && tp.getSesssionid().equals(sid)){
				return tp;
			}
		}
		return null;
	}
	//删除 user
	public static void removeUser(HrPersonVo hrPersonVo){
		userList.remove(hrPersonVo);
	}
	//根据名称来 删除在线用户
	public static boolean removeUserByName(String name){
		Iterator<HrPersonVo> i = userList.iterator();
		while(i.hasNext()){
			HrPersonVo hrPersonVo = i.next();
			if(hrPersonVo.getCname().equals(name)){
				i.remove();
				return true;
			}
		}
		return false;
	}
	//根据sessionid来 删除在线用户
	public static boolean removeUserBySid(String sid){
		Iterator<HrPersonVo> i=userList.iterator();
		while(i.hasNext()){
			HrPersonVo hrPersonVo = i.next();
			if(hrPersonVo.getSesssionid().equals(sid)){
				i.remove();
				return true;
			}
		}
		return false;
	}
}