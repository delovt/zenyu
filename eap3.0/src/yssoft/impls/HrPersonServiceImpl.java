/**    
 *
 * 文件名：HrPersonServiceImpl.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-8-22    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IHrPersonService;
import yssoft.utils.CrmMd5Util;

import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.util.HashMap;
import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：HrPersonServiceImpl    
 * 类描述：    
 * 创建人：zhong_jing 
 * 创建时间：2011-8-22 上午10:25:16        
 *     
 */
public class HrPersonServiceImpl extends BaseDao implements IHrPersonService {

	/**
	 * 
	 * addPerson(新增人员)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-22 上午10:21:10
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param hrPersonVo 新增类
	 * @return Object 是否增加成功
	 * @Exception 异常对象    
	 *
	 */
	public Object addPerson(HashMap hrPersonVo) throws Exception {
		return this.insert("add_person",hrPersonVo);
	}

	/**
	 * 
	 * deletePerson(删除该人员)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-22 上午10:23:49
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param iid 人员编号
	 * @return int
	 * @Exception 异常对象    
	 *
	 */
	public int removePerson(String sql) {
		return this.delete("remove_person",sql);
//		if(count!=1)
//		{
//			return "fail";
//		}
//		else
//		{
//			return "success";
//		}
	}

	/**
	 *  
	 * updatePerson(修改人员)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-22 上午10:22:17
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param hrPersonVo 人员信息
	 * @return int 是否新增成功
	 * @Exception 异常对象    
	 *
	 */
	public String updatePerson(HashMap hrPersonVo) throws Exception {
		int count =this.update("update_person",hrPersonVo);
		if(count!=1)
		{
			return "fail";
		}
		else
		{
			return "success";
		}
	}

	/**
	 * 
	 * getPersons(查询列表)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-2 上午09:58:10
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param paramObj 查询条件
	 * @return List<HashMap> 
	 *
	 */
	public HashMap<String,Object> getPersons(String sql)
	{
		return (HashMap<String,Object>) this.queryForObject("get_persons",sql);
	}

	public String updatePersonPwd(HashMap params) throws Exception {
		if(params.containsKey("resetFlag")){
			 int count =  this.update("reset_user_pwd",params);
				if(count!=1)
				{
					return "fail";
				}
				else
				{
					return "success";
				}
		}else{
			int count =  this.update("updat_user_pwd",params);
			if(count!=1)
			{
				return "fail";
			}
			else
			{
				return "success";
			}
		}
		
	}

	/**
	 * 
	 * get_personplancount(统计人员计划个数)
	 * 创建者：刘磊
	 * 创建时间：2011-9-10 上午14:58:10
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param having 查询条件
	 * @return List<HashMap> 
	 *
	 */
	public List<HashMap> get_personplancount(String condition) throws Exception {
		return this.queryForList("get_personplancount",condition);
	}
	public List<HashMap> get_personplannotin(HashMap<String,String> condition) throws Exception {
		return this.queryForList("get_personplannotin",condition);
	}
	
	/**
	 * 
	 * get_personlogcount(统计人员日志个数)
	 * 创建者：刘磊
	 * 创建时间：2011-9-10 上午14:58:10
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param having 查询条件
	 * @return List<HashMap> 
	 *
	 */
	public List<HashMap> get_personlogcount(String condition) throws Exception {
		return this.queryForList("get_personlogcount",condition);
	}
	public List<HashMap> get_personlognotin(HashMap<String,String> condition) throws Exception {
		return this.queryForList("get_personlognotin",condition);
	}
	
	/**
	 * 
	 * addPm(新增)
	 * 创建者：zhong_jing
	 * 创建时间：2011-10-13 下午02:11:01
	 * 修改者：Lenovo
	 * 修改时间：2011-10-13 下午02:11:01
	 * 修改备注：   
	 * @param sql
	 * @return
	 * @throws Exception Object
	 * @Exception 异常对象    
	 *
	 */
	public Object addPm(HashMap sql)throws Exception,RuntimeException
	{
		return this.insert("add_pm",sql);
	}
	
	/**
	 * 
	 * updatePm(修改)
	 * 创建者：zhong_jing
	 * 创建时间：2011-10-13 下午02:12:04
	 * 修改者：Lenovo
	 * 修改时间：2011-10-13 下午02:12:04
	 * 修改备注：   
	 * @param sql
	 * @return
	 * @throws Exception int
	 * @Exception 异常对象    
	 *
	 */
	public int updatePm(String sql)throws Exception,RuntimeException
	{
		return this.update("update_pm",sql);
	}
	
	/**
	 * 
	 * deletePm(删除)
	 * 创建者：zhong_jing
	 * 创建时间：2011-10-13 下午02:12:55
	 * 修改者：Lenovo
	 * 修改时间：2011-10-13 下午02:12:55
	 * 修改备注：   
	 * @param sql
	 * @return
	 * @throws Exception int
	 * @Exception 异常对象    
	 *
	 */
	public int deletePm(String sql)throws Exception,RuntimeException
	{
		return this.delete("remove_pm",sql);
	}
	
	
	/**
	 * 
	 * 个人设置首页 注册表IID
	 */
	@Override
	public void updateHomePage(HashMap params) {
		this.update("updateHomePage",params);
	}
	
	//保存公告
	public void addComm(HashMap params)
	{
		this.insert("add_AS_communication",params);
	}


	@Override
	public List queryPerson(int iperson) {
		return this.queryForList("select_main_hrperson",iperson+"");
	}

	@Override
	public List querydepartment(int iperson) {
		return this.queryForList("select_main_department",iperson+"");
	}

	/**
	 * 作者: 朱毛毛
	 * 创建日期: 2011-11-11 上午10:58:30
	 * 方法描述: 
	 *   
	 */
	@Override
	public int check_zh_isonly(HashMap params) {
		// TODO Auto-generated method stub
		return (Integer)this.queryForObject("hr.check_zh_isonly",params);
	}

	@Override
	public void updatePersonOption(HashMap map) {
		
		this.update("update_person_option", map);
	}
	
	public List  selectOptionsCondition(String conditin){
		
		return this.queryForList("select_options_condition",conditin);
	}

	@Override
	public List select_ems_lists_by_iperson(String iperson) {
		return this.queryForList("select_ems_lists",iperson);
	}

	@Override
	public void inserEms(HashMap params) {
		this.insert("insert_ems_data", params);
	}

	@Override
	public void delEmsByperson(int iperson) {
		this.delete("del_ems_data",iperson);
	}

	@Override
	public List applictionSearch(HashMap params) {
		List list = null;
		try {
			
			HashMap map = new HashMap();
			map.put("ccondit",params.get("ccondit"));
			map.put("iperson",Integer.parseInt(params.get("iperson")+""));
			
			
			list = this.queryForList("get_appliction_search_list",map);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		
		return list;
	}
	
	
	public void deleteAll(String childupdateSql)
	{
		HashMap<String, Object> paraMap = new HashMap<String, Object>();
		System.out.println(childupdateSql);
		paraMap.put("sqlValue", childupdateSql);
		this.update("DatadictionaryDest.updateDataList", paraMap);
	}
	/**
	 * 忘记密码
	 * 创建人:王炫皓
	 * 创建时间：20121222
	 * @param param
	 */
	public String updatePwd(HashMap param){
		//使用md5加密算法对新密码进行加密
		try {
			String cusepwd = CrmMd5Util.getEncryptedPwd(param.get("pwd").toString());
			 param.put("pwd", cusepwd);
			 int count =  this.update("updat_user_pwd",param);
			if(count!=1){
					return "fail";
			}else{
					return "success";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}
	}
}
