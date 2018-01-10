/**
 * 
 */
package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IUserService;
import yssoft.vos.HrPersonVo;

import java.util.Date;
import java.util.HashMap;
import java.util.List;

/**
 * @author zmm
 *
 */
public class UserServiceImple extends BaseDao implements IUserService {

	/* (non-Javadoc)
	 * @see yssoft.services.IUserService#getUser()
	 */
	@Override
	public Object getUser(HashMap params) throws Exception {
		if(params.containsKey("cusepassword"))
			return this.queryForObject("get_user", params);
		else
			return this.queryForObject("get_userbyid", params);
			
	}
	
	public void addLog(String cnode,String cfunction,String cresult,String iinvoice,String place){
		super.addLog(cnode, cfunction, cresult, iinvoice,place);
	}
	
	public Object getAttributeFromSession(String key){
		return super.getAttributeFromSession(key);
	}
	
	public void setAttributeToSession(String key,Object value){
		super.setAttributeToSession(key, value);
	}

	@Override
	public String getUserPwdByLoginName(String loginName) throws Exception {
		HashMap obj = (HashMap)this.queryForObject("get_user_pwd",loginName);
		return obj.get("cusepassword")+"";
	}
	
	@Override
	public HrPersonVo getUserObjByLoginName(String loginName) {
		HrPersonVo obj = (HrPersonVo)this.queryForObject("get_user_obj",loginName); 
		return obj; 
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-10-18 上午11:34:27
	 * 方法描述: 
	 *   
	 */
	@Override
	public List get_user_role(String loginName) {
		// TODO Auto-generated method stub
		return this.queryForList("get_user_role",loginName);
	}

	@Override
	public void updateLoginLast(HashMap params) {
		 this.update("update_user_last",params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public int getDbsx_sum(int iperson) {
		HashMap map = new HashMap();
		map.put("iperson",iperson);
		
		int resultNum = Integer.parseInt(this.queryForObject("xtgl.selectDbsx_sum",map)+"");
		return resultNum;
	}
	
	@Override
	public int getJhtx_sum(int iperson) {
		HashMap map = new HashMap();
		map.put("iperson",iperson);
		map.put("nowDate",new Date());
		
		int resultNum = Integer.parseInt(this.queryForObject("selectJhtx_sum",map)+"");
		return resultNum;
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-11-4 下午01:21:14
	 * 方法描述: 
	 *   
	 */
	@Override
	public void user_update_timestamp(HashMap params) {
		// TODO Auto-generated method stub
		this.update("user.update_timestamp",params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-11-4 下午01:56:04
	 * 方法描述: 
	 *   
	 */
	@Override
	public List get_online(String endtimestamp) {
		return this.queryForList("user.get_online",endtimestamp);
	}

	@Override
	public String getPersonCount() {
		return this.queryForObject("user.getperson_count").toString();
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-12-1 下午02:01:59
	 * 方法描述: 
	 *   
	 */
	@Override
	public HashMap islogin(HashMap params) {
		// TODO Auto-generated method stub
		return (HashMap) this.queryForObject("user.islogin", params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-12-2 下午12:06:09
	 * 方法描述: 
	 *   
	 */
	@Override
	public void update_startinfo(HashMap params) {
		// TODO Auto-generated method stub
		this.update("user.update_startinfo", params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-12-22 上午10:23:48
	 * 方法描述: 
	 *   
	 */
	@Override
	public void delete_personmenu(HashMap params) {
		// TODO Auto-generated method stub
		this.delete("user.delete.personmenu", params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-12-22 上午10:23:48
	 * 方法描述: 
	 *   
	 */
	@Override
	public int insert_personmenu(HashMap params) {
		// TODO Auto-generated method stub
		return (Integer)this.insert("user.insert.personmenu", params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-12-22 上午10:23:48
	 * 方法描述: 
	 *   
	 */
	@Override
	public List select_personmenu(HashMap params) {
		// TODO Auto-generated method stub
		return this.queryForList("user.select.personmenu", params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-12-22 上午10:23:48
	 * 方法描述: 
	 *   
	 */
	@Override
	public List select_personmenu_auth(HashMap params) {
		// TODO Auto-generated method stub
		return this.queryForList("user.select.personmenu.auth", params);
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-12-22 上午10:23:48
	 * 方法描述: 
	 *   
	 */
	@Override
	public void update_note(HashMap params) {
		// TODO Auto-generated method stub
		this.update("user.update.note", params);
	}
	
}
