/**    
 *
 * 文件名：OnLineUser.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-9-29    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.online;

/**
 * 
 * 项目名称：yscrm 类名称：OnLineUser 类描述： 创建人：朱毛毛 创建时间：2011-2011-9-29 下午06:02:44
 * 
 */

import yssoft.vos.HrPersonVo;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

public class UserList {
	private static final UserList userList=new UserList();
	private List list;
	public UserList(){
		list=new ArrayList();
	}
	public static UserList getInstance(){
		return userList;
	}
	//在线人数
	public int getOnLineCount(){
		return list.size();
	}
	
	//是否已经登录
	public boolean existUserBySessionId(HrPersonVo user){
		if(user == null){
			return false;
		}
		Iterator i=list.iterator();
		while(i.hasNext()){
			HrPersonVo person=(HrPersonVo) i.next();
			if(person.getSesssionid().equals(user.getSesssionid())){
				return true;
			}
		}
		return false;
	}
	public boolean existUserByCusercode(HrPersonVo user){
		if(user == null){
			return false;
		}
		Iterator i=list.iterator();
		while(i.hasNext()){
			HrPersonVo person=(HrPersonVo) i.next();
			if(person.getCusecode().equals(user.getCusecode())){
				return true;
			}
		}
		return false;
		
	}
	//添加用户
	public void addUser(HrPersonVo user){
		System.out.println("添加新的用户了["+user.getCname()+"]");
		if(existUserByCusercode(user)){
			removeUserByCusecode(user);
		}
		list.add(user);
	}
	//删除用户
	public void removeUserBySessionId(HrPersonVo user){
		if(user == null){
			return;
		}
		Iterator i=list.iterator();
		while(i.hasNext()){
			HrPersonVo person=(HrPersonVo) i.next();
			if(person.getSesssionid().equals(user.getSesssionid())){
				i.remove();
			}
		}
		user=null;
	}
	
	//删除用户
	public void removeUserByCusecode(HrPersonVo user){
		if(user == null){
			return;
		}
		Iterator i=list.iterator();
		while(i.hasNext()){
			HrPersonVo person=(HrPersonVo) i.next();
			if(person.getCusecode().equals(user.getCusecode())){
				i.remove();
			}
		}
		user=null;
	}
	
	//获取在线用户xml数据
	public String parseXML(){
		String xml=userXml();
		return xml;
	}
	// 遍历 在线用户信息
	public String userXml(){
		
		if(list==null || list.size()==0){
			return "<root />";
		}
		
		StringBuffer buf = new StringBuffer();  
		int len=list.size();
		for(int j=0;j<len;j++){
			HrPersonVo user = (HrPersonVo) list.get(j);
			buf.append("<node ");
			
			buf.append(" iid='"+user.getIid()+"' cname='"+user.getCname()+"' cnickname='"+user.getCnickname()
							   +"' idepartment='"+user.getIdepartment()+"' cusecode='"+user.getCusecode()
							   +"' departcname='"+user.getDepartcname()+"' sesssionid='"+user.getSesssionid()+"' isonline='1' ");
			buf.append(" />");
		}
		
		
		return "<root>"+buf.toString()+"</root>";
		
	}
	
}
