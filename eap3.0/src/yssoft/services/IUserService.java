/**
 * 
 */
package yssoft.services;

import yssoft.vos.HrPersonVo;

import java.util.HashMap;
import java.util.List;

/**
 * @author zmm
 *
 */
public interface IUserService {
	
	public Object getUser(HashMap params) throws Exception;
	public String getUserPwdByLoginName(String loginName) throws Exception;
	public void   addLog(String cnode,String cfunction,String cresult,String iinvoice,String cplace);
	public Object getAttributeFromSession(String key);
	public void   setAttributeToSession(String key,Object value);
	public HrPersonVo getUserObjByLoginName(String loginName);
	
	public List get_user_role(String loginName);
	public void updateLoginLast(HashMap params);
	
	//待办事项总数
	public int getDbsx_sum(int iperson);
	
	//待办事项总数
	public int getJhtx_sum(int iperson);
		
		
	//更新用户的在线时间戳
	public void user_update_timestamp(HashMap param);
	//在线人员
	public List get_online(String endtimestamp);
	
	//获取已启用总人数
	public String getPersonCount();
	
	//验证，用户是不是 已经登录
	public HashMap islogin(HashMap params);
	
	//跟新用户登录信息
	public void update_startinfo(HashMap params);
	
	
	
	
	
	//更新 用户的便签
	public void update_note(HashMap params);
	
	//删除 用户的 常用设置 
	public void delete_personmenu(HashMap params);
	
	//插入 用户的 常用设置
	public int insert_personmenu(HashMap params);
	
	//获取 用户的 常用设置(不含权限，只是展示)
	public List select_personmenu(HashMap params);
	
	//获取 用户的 常用设置(含有权限)
	public List select_personmenu_auth(HashMap params);
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}
