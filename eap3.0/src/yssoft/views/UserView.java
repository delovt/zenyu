/**
 * 
 */
package yssoft.views;

import flex.messaging.FlexContext;
import flex.messaging.FlexSession;
import flex.messaging.io.ArrayList;
import yssoft.services.IMenuService;
import yssoft.services.IUserService;
import yssoft.servlets.LicenseServlet;
import yssoft.utils.CrmMd5Util;
import yssoft.utils.DesEncryptUtil;
import yssoft.utils.ToXMLUtil;
import yssoft.utils.ToolUtil;
import yssoft.vos.HrPersonVo;

import java.util.*;

/**
 * @author Administrator
 * 
 */
public class UserView {

	private String key_ready_pwd;
	private String key_write_pwd;
	
	public String getKey_ready_pwd() {
		return DesEncryptUtil.encodeDes(key_ready_pwd,null);
	}

	public void setKey_ready_pwd(String keyReadyPwd) {
		key_ready_pwd = keyReadyPwd;
	}

	public String getKey_write_pwd() {
		return  DesEncryptUtil.encodeDes(key_write_pwd,null);
	}

	public void setKey_write_pwd(String keyWritePwd) {
		key_write_pwd = keyWritePwd;
	}
	
	private IUserService iUserService;

	// 菜单
	private IMenuService iMenuService;

	public void setiMenuService(IMenuService iMenuService) {
		this.iMenuService = iMenuService;
	}

	public void setiUserService(IUserService iUserService) {
		this.iUserService = iUserService;
	}
    String RegisterMaxUser;
	@SuppressWarnings("unchecked")
	public HashMap CheckUser(HashMap params) {

		HrPersonVo hrperson = null;
		HashMap map = new HashMap();
		try {
			//验证登陆用户数
            RegisterMaxUser =(String)LicenseServlet.getLicenseMap().get("RegisterMaxUser");

			List onlinelist = get_online();

            if(RegisterMaxUser==null)
                RegisterMaxUser="20";
			
			int maxUser=Integer.parseInt(RegisterMaxUser);
			//List userList = OnLineUsers.getOnLineUsers();
//			HashSet userSet = new HashSet();
//			for (int i = 0; i < userList.size(); i++) {
//				HrPersonVo vo = (HrPersonVo) userList.get(i);
//				userSet.add(vo.getCusecode());
//			}
//			userSet.add(params.get("cusecode"));
			
//			if(userSet.size()>maxUser){
//				System.out.println("在线人员数超过注册的最大人数");
//				map.put("limitInfo", "注册数已经分配完毕，登录失败");
//				return map;
//			}
	
			//lr modify
			int onLineSize = onlinelist.size();
			for (Object o : onlinelist){
				HashMap h = (HashMap) o;
				if(h.get("cusecode").equals(params.get("cusecode"))){
					onLineSize=onLineSize-1;
				}
			}
			
			if(onLineSize>=maxUser){
				System.out.println("在线人员数超过注册的最大人数");
				map.put("limitInfo", "注册数已经分配完毕，登录失败");
				return map;
			}
			
			String loginName = params.get("cusecode") + "";
			String pwd = params.get("cusepassword") + "";
			
			String keyid=(String) params.get("keyid");
			String keydata=(String) params.get("keydata");

			//			
			// SQLPageUtil sqlutil = new SQLPageUtil();
			// sqlutil.getIbaitsSqlById("get_user_ce");
			//			
			//			
			//		
			String db_pwd = getDB_Pwd(loginName);
			boolean flag = CrmMd5Util.validPassword(pwd, db_pwd);

			if (flag) {
				params.put("cusepassword", db_pwd);
				hrperson = (HrPersonVo) iUserService.getUser(params);
				
			} else {
				System.out.println("密码验证不成功");
				return null;
			}
			// 修改 密码验证规则
			//this.hrperson = (HrPersonVo) iUserService.getUser(params);
			if (hrperson != null) {
				String ip = (String) params.get("ip");
				String cplace = (String) params.get("cplace");

				if (ip == null) {
					ip = "";
				}
				hrperson.setCip(ip);
				hrperson.setCworkstation(cplace);
				hrperson.setKeyRPwd(this.key_ready_pwd);
				hrperson.setKeyWPwd(this.key_write_pwd);
				
				return recordUserInfo(hrperson);
				// 查看 用户是不是已经绑定加密狗
//				if (hrperson.getBusbkey()){
//					if(keyid == null || keydata == null || hrperson.getKeyid()==null || !keyid.toLowerCase().equals(hrperson.getKeyid().toLowerCase()) ||  ! keydata.equals(""+hrperson.getIid())){
//							map.put("keyerr","该账号绑定了加密锁，但加密锁信息不匹配");
//							return map;
//					}else{
//						return recordUserInfo(hrperson);
//					}
//				}else{
//					return recordUserInfo(hrperson);
//				}
				
			} else {
				return null;// SysConstant.USER_CHECK_FAIL;
			}

		} catch (Exception e) {
			e.printStackTrace();
			return null;// SysConstant.USER_CHECK_FAIL;
		}
	}

	/**
	 * getAuthMenus(根据用户id 来获取用户权限菜单)
	 *
	 * @author zmm
	 * @param UserId
	 *            用户id
	 */
	
	public HashMap getAuthMenusAll(HashMap param) {
		try {
			HashMap map = new HashMap();
			List menuXmlList = this.iMenuService.getAuthMenus(param);
            //lc add 2017年8月4日
            List menuXmlList1 = this.iMenuService.getPersonAuthMenus(param);

            for (int i = 0; i < menuXmlList.size();i++) {
                HashMap m = (HashMap) menuXmlList.get(i);
                String hasauth = m.get("hasauth") + "";//是否含有权限  yes   no
                String ifun = m.get("ifuncregedit") + "";//功能码
                if(hasauth.equals("yes")){
                    continue;
                }else if (hasauth.equals("no")){
                    for (int j = 0; j < menuXmlList1.size();j++) {
                        HashMap m1 = (HashMap) menuXmlList1.get(j);
                        String hasauth1 = m1.get("hasauth") + "";//是否含有权限  yes   no
                        String ifun1 = m1.get("ifuncregedit") + "";//功能码
                        if (ToolUtil.isStringNull(ifun) || ToolUtil.isStringNull(ifun1)){
                            continue;
                        }else{
                            if(ifun.equals(ifun1)){
                                if(hasauth1.equals("yes")){
                                    m.put("hasauth","yes");
                                }
                            }else{
                                continue;
                            }
                        }
                    }
                }

            }

			String menuXml = ToXMLUtil.createTree(menuXmlList, "iid", "ipid", "-1");
			map.put("menuXml", menuXml);
			map.put("menuXmlList", menuXmlList);
			return map;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
	}

	// 退出系统
	public void logoff(int iid) {
		iUserService.addLog("用户操作", "退出系统", "成功", "", "");
		String timestamp = "" + ((new Date()).getTime() - 30 * 60 * 1000);
		this.user_update_timestamp(iid, timestamp);
	}

	// 获取数据库密码
	public String getDB_Pwd(String loginName) {
		String pwd = null;
		try {
			pwd = iUserService.getUserPwdByLoginName(loginName);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return pwd;
	}

	// 获取用户对象
	public HrPersonVo getUserObj(String loginName) {
		HrPersonVo result = null;
		try {
			result = iUserService.getUserObjByLoginName(loginName);
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (result != null) {
			return result;
		}
		return null;
	}

	// 获取在线列表
	public HashMap onLineUserParseXML(String iperson) {
		String timestamp = "" + ((new Date()).getTime());
		this.user_update_timestamp(Integer.parseInt(iperson), timestamp);
		
		HashMap map = new HashMap();
		List onlinelist = get_online();
		String user_xml = ToXMLUtil.createTreeFromList(onlinelist);// UserList.getInstance().parseXML();

		int dbsx_sum = -1;
		int jhtx_sum =0;
		try {
			dbsx_sum = iUserService.getDbsx_sum(Integer.parseInt(iperson));
			jhtx_sum = iUserService.getJhtx_sum(Integer.parseInt(iperson));
		} catch (Exception e) {
			e.printStackTrace();
		}
		
		map.put("user_xml", user_xml);
		map.put("dbsx_sum", dbsx_sum);
		map.put("jhtx_sum", jhtx_sum);
		return map;
	}

	// 更新最后一次登录信息
	@SuppressWarnings("unchecked")
	public HashMap updateLoginLast(HashMap params) {
		String flag = "success";
		try {
			iUserService.updateLoginLast(params);
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("更新最后一次登录信息异常!");
			flag = "fail";
		}
		params.put("flag", flag);
		return params;
	}

	// 验证 密码是否匹配
	public String checkUserPwd(HashMap params) {
		String pwd = (String) params.get("pwd");
		String db_pwd = (String) params.get("db_pwd");
		if (pwd == "" || db_pwd == "") {
			return "0";
		}
		boolean flag;
		try {
			flag = CrmMd5Util.validPassword(pwd, db_pwd);
			if (flag) {
				return "1";
			}
		} catch (Exception e) {
			return "0";
		}
		return "0";

	}

	// 更新用户在线时间戳
	public void user_update_timestamp(int iperson, String timestamp) {
		HashMap tsparam = new HashMap();
		tsparam.put("iperson", iperson);
		tsparam.put("timestamp", timestamp);
		this.iUserService.user_update_timestamp(tsparam);
	}

	// 更新登录人信息
	public void update_startinfo(int iperson, String timestamp, String cip,
			String sesssionid) {
		HashMap tsparam = new HashMap();
		tsparam.put("iperson", iperson);
		tsparam.put("timestamp", timestamp);
		tsparam.put("cip", cip);
		tsparam.put("sesssionid", sesssionid);
		this.iUserService.update_startinfo(tsparam);
	}

	// 在线人员
	public List get_online() {
		String endtimestamp = "" + ((new Date()).getTime() - 1 * 13 * 1000);
		return this.iUserService.get_online(endtimestamp);
	}

	// 验证用户是否已经登录
	public HashMap islogin(int iperson) {
		String endtimestamp = "" + ((new Date()).getTime() - 1 * 13 * 1000);
		//String endtimestamp = "" + ((new Date()).getTime() - 10 * 60 * 1000);
		HashMap params = new HashMap();
		params.put("endtimestamp", endtimestamp);
		params.put("iperson", iperson);
		return this.iUserService.islogin(params);
	}

	// 记录用户登录信息
	@SuppressWarnings({ "unused", "unchecked" })
	public HashMap recordUserInfo(HrPersonVo hrperson) {
		if(hrperson == null){
			return null;
		}
		
		HashMap map = new HashMap();
		try {
			 //验证 用户是不是已经登录
			 HashMap logined=islogin(hrperson.getIid());
			 if( logined != null){
                map.put("logined",logined);
                map.put("doperate",logined.get("doperate"));
                 map.put("cip",logined.get("cip"));
			 }

			// if( hrperson.getRolebuse()==null || !
			// hrperson.getRolebuse().equals("1")){ // 当前用户隶属于角色不可用
			// System.out.println("当前用户隶属于角色不可用...");
			// return null;
			// }

			// 获取 角色列表
			List rolelist = this.iUserService.get_user_role(""+ hrperson.getIid());
			// if(rolelist == null || rolelist.size()==0){
			//			
			// }
			hrperson.setRolelist(rolelist);
			// 获取sessionid
			String sessionid = FlexContext.getFlexSession().getId();
			hrperson.setSesssionid(sessionid);

			// 在这里进行相关的用户 验证，ip，是否有效，锁定，权限是否可用等

			// 更新用户 在线时间戳
			String timestamp = "" + (new Date()).getTime();
			update_startinfo(hrperson.getIid(), timestamp, hrperson.getCip(),
					sessionid);
			// this.user_update_timestamp(hrperson.getIid(),timestamp);
			hrperson.setOnlinetimestamp(timestamp);
            
//lr modify			
//			//设置session
//			this.setSession("hrperson",hrperson);
//			//在线人员列表添加
//			OnLineUsers.addUser(hrperson);
			
			// 用户登录成功后，获取权限菜单
			//List menuXmlList = getAuthMenusList("" + hrperson.getIid());
			//String menuXml = ToXMLUtil.createTree(menuXmlList, "iid", "ipid", "-1");
			//map.put("menuXml", menuXml);
			//map.put("menuXmlList", menuXmlList);
			
			iUserService.setAttributeToSession("HrPerson", hrperson);
			// UserList.getInstance().addUser(hrperson);
			map.put("hrperson", hrperson);
			

			iUserService.addLog("用户操作", "登录系统", "成功", "", hrperson.getCworkstation());

			// 所有启用用户总数
			map.put("personCount", iUserService.getPersonCount());
			int maxUser=Integer.parseInt(RegisterMaxUser);
			map.put("authorizedUsersNum",maxUser);
			map.put("userId",hrperson.getIid());
			
			//YJ Add 20120911 获取项目名称
			String purl = this.getClass().getResource("").getFile();
			String turl = purl.substring(0, purl.indexOf("WEB-INF")-1);
			String pname = turl.substring(turl.lastIndexOf("/")+1,turl.length());
			
			map.put("pname", pname);//加入项目名称
			
			System.out.println("增加用户:"+hrperson.getIid()+"\t"+hrperson.getCusecode()+"\t"+hrperson.getCname()+"\t"+sessionid+"\t"+new Date());

			return map;// SysConstant.USER_CHECK_SUC;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}

	}
	
	
	
	
	//更新 用户的便签
	public String update_note(HashMap params){
		try{
		this.iUserService.update_note(params);
		return "保存成功";
		}catch(Exception e){
			e.printStackTrace();
			return " 保存失败";
		}
	}
	
	//删除 用户的 常用设置 
	public void delete_personmenu(HashMap params){
		this.iUserService.delete_personmenu(params);
	}
	
	//插入 用户的 常用设置
	public int insert_personmenu(HashMap params){
		return this.iUserService.insert_personmenu(params);
	}
	
	//获取 用户的 常用设置(不含权限，只是展示)
	public List select_personmenu(HashMap params){
		return this.iUserService.select_personmenu(params);
	}
	
	//获取 用户的 常用设置(含有权限)
	public String select_personmenu_auth(HashMap params){
		List list= this.iUserService.select_personmenu_auth(params);
		return ToXMLUtil.createTreeFromList(list);
	}
	
	//
	public HashMap addPersonMenu(HashMap params){
		HashMap ret=new HashMap();
		//先删除
		List items=(List) params.get("items");
		
		try{
			
			delete_personmenu(params);
			
			if(items==null || items.size()==0){
				ret.put("suc","保存成功");
				return ret;
			}
			
			int len=items.size();
			for(int i=0;i<len;i++){
				HashMap sqlparam=(HashMap) items.get(i);
				this.insert_personmenu(sqlparam);
			}
			ret.put("suc","保存成功");
			return ret;
		}catch(Exception e){
			e.printStackTrace();
			ret.put("error","写入提交信息失败");
			return ret;
		}
	}
	
	//用户注销
	public String onUserLogout(int iid){
		String sessionid = FlexContext.getFlexSession().getId();
		System.out.println("注销用户:"+iid+"\t"+sessionid);

		
		try {
			//此句报错  先注释掉了  lr
			//iUserService.addLog("用户操作", "退出系统", "成功", "", "");
			String timestamp = "" + ((new Date()).getTime() - 30 * 60 * 1000);
			this.user_update_timestamp(iid, timestamp);
			
			HrPersonVo hrPersonVo=((HrPersonVo)this.getSession("hrperson"));
			//this.addLoger("0","用户退出系统,网页",hrPersonVo.getCip());
			//OnLineUsers.removeUserBySid(hrPersonVo.getSesssionid());
			this.setSession("hrperson",null);
			FlexContext.getFlexSession().invalidate();
			System.out.println("用户退出系统");

			return "suc";
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "err";
	}
	
	public void setSession(String key, Object value) {
		FlexContext.getFlexSession().setAttribute(key, value);
	}
	public Object getSession(String name) {
		if (FlexContext.getFlexSession() != null) {
			return FlexContext.getFlexSession().getAttribute(name);
		}
		return null;
	}
	public FlexSession getFlexSession() {
		return FlexContext.getFlexSession();
	}
}
