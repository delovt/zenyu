package yssoft.views;

import yssoft.services.IAs_OptionsService;
import yssoft.services.IHrPersonService;
import yssoft.servlets.LicenseServlet;
import yssoft.utils.SystemParamter;

import java.util.HashMap;
import java.util.List;

/**
 * 系统选项实现类
 * @author sdy
 *
 */
public class As_OptionsView {

	/**
	 * 安全策略
	 */
	
	private IAs_OptionsService ipns;
	private IHrPersonService iHrPersonService = null;
	
	public void setIpns(IAs_OptionsService ipns) {
		this.ipns = ipns;
	}
	public void setiHrPersonService(IHrPersonService iHrPersonService) {
		this.iHrPersonService = iHrPersonService;
	}
	
	/**
	 * 查询策略
	 * @param map
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public HashMap getOptionsByCclass(HashMap parm) {
		HashMap _map = new HashMap();
		_map.put("mainOptions",ipns.getOptionsByCclass(parm));
		
		//是否允许多点登录
		List list1 = iHrPersonService.selectOptionsCondition("bmorelogin");
		
		if(list1.size() != 0){
			String[] arr1 = encapsulation(list1).split("__");
			_map.put("bmorelogin_ids", arr1[0]);  
			_map.put("bmorelogin_text",arr1[1] );
		}
		
		
		//是否清退时例外放行
		List list2 = iHrPersonService.selectOptionsCondition("bnotremove");
		
		if(list2.size() != 0){
			String[] arr2 = encapsulation(list2).split("__");
			_map.put("bnotremove_ids", arr2[0] ); 
			_map.put("bnotremove_text",arr2[1] );
		}
		
		return _map;
	}
	
	
	/**
	 * 封装获取组合后字符串
	 */
	@SuppressWarnings("unchecked")
	private String encapsulation(List list){

		String ids = "";
		String nameStr = "";
		
		for(Object obj : list){
			HashMap map = (HashMap)obj;
			ids += map.get("iid") +",";
			nameStr += "【"+map.get("departname")+ "】" + map.get("cname")+":("+map.get("iid")+") 、";
		}
		return ( ids +"__"+nameStr );
		
	}
	
	
	
	/**
	 * 循环更新
	 * @param map
	 * @return
	 */
	public String updateOptions(HashMap map) {
		String result = "suc";
		
		try {
			System.out.println(map.get(0));
			ipns.updateOptions(map);  

			//更新用户关联项
			HashMap<String,Object> _map = new HashMap<String, Object>();
			_map.put("ids_1", map.get("_6_ids")==""?0:map.get("_6_ids"));  
			_map.put("ids_2", map.get("_7_ids")==""?0:map.get("_7_ids"));
			
			iHrPersonService.updatePersonOption(_map);
			
		} catch (Exception e) {
			result = "fail";
			e.printStackTrace();
		}
		
		return result;
	}
	
	/**
	 * 获取系统参数
	 * @param iid
	 * @return
	 */
	public Object getSysParamterByiid(int iid){
		return ipns.getSysParamterByiid(iid);
	}
	
	/**
	 * 获取初始化验证密码
	 * @return
	 */
	public String getInitPwd(){
		return ipns.getSysParamterByiid(SystemParamter.INIT_PWD);
	}
	
	/**
	 * 是否初始化验证密码并强制修改密码
	 * @return
	 */
	public boolean getIsCheckedPwd(){
		String str = ipns.getSysParamterByiid(SystemParamter.IS_INIT_PWD_MOTITY);
		if(str.equals("1") ){
			return true;
		}else{
			return false;
		}
	}
	
	/**
	 * 获取密码最少位数
	 * @return
	 */
	public String getMinPwd(){
		return  ipns.getSysParamterByiid(SystemParamter.MIN_PWD_LENGTH);
	}
	
	/**
	 * 获取登陆验证次数
	 * @return
	 */
	public int getCheckPwdCount(){
		return  Integer.parseInt(ipns.getSysParamterByiid(SystemParamter.CHECK_PWD_COUNT));
	}
	
	
	/**
	 * 获取密码有效时间
	 * @return
	 */
	public int getPwdValidDay(){
		return  Integer.parseInt(ipns.getSysParamterByiid(SystemParamter.USE_MAX_PWD_DAY));
	}
	
	/**
	 * 获取用户多点登陆
	 */
	public int getMorelogined(){
		return  Integer.parseInt(ipns.getSysParamterByiid(SystemParamter.NO_ALLOW_MPLACE_LOGIN));
	}
	
	/**
	 * 获得授权用户
	 * @return
	 */
	public String getCusterName(){
		String cus=null;
		if(LicenseServlet.getLicenseMap().containsKey("RegisterCusterName")){
			cus=(String) LicenseServlet.getLicenseMap().get("RegisterCusterName");
		}
		return cus;
	}
	
	/**
	 * 获得版本
	 * @return
	 */
	public String getRegisterVersion(){
		String version=null;
		if(LicenseServlet.getLicenseMap().containsKey("RegisterVersion")){
			version=(String) LicenseServlet.getLicenseMap().get("RegisterVersion");
		}
		return version;
	}
	
	
	/**
	 * 获得试用天数
	 * @return
	 */
	public String getRegisterDays(){
		String days=null;
		if(LicenseServlet.getLicenseMap().containsKey("RegisterDays")){
			days=(String) LicenseServlet.getLicenseMap().get("RegisterDays");
		}
		return days;
	}
	
	/**
	 * 是否过期
	 * @return
	 */
	public Boolean getRegisterExpire(){
		Boolean bool=true;
		if(LicenseServlet.getLicenseMap().containsKey("RegisterExpire")){
			String d=(String) LicenseServlet.getLicenseMap().get("RegisterExpire");
			bool = new Boolean(d);
		}
		return bool;
	}
	
	
	
	@SuppressWarnings("unchecked")
	public HashMap getSysOptionObject(){
		HashMap map = new HashMap();
		
		map.put("checkFlag", getIsCheckedPwd());
		map.put("userInitpwd", getInitPwd());
		map.put("checkPwdCount", getCheckPwdCount());
		map.put("pwdValidCount", getPwdValidDay());
		map.put("checkMoreLogin", getMorelogined());
		map.put("optionAc", ipns.getOptionAc());
		map.put("RegisterCusterName",getCusterName());
		map.put("RegisterVersion", getRegisterVersion());
		map.put("RegisterDays", getRegisterDays());
		map.put("RegisterExpire",getRegisterExpire());
		
		return map;
	}
	
	
}
