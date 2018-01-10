/**    
 *
 * 文件名：IHrPersonService.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-8-22    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.services;

import java.util.HashMap;
import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：IHrPersonService    
 * 类描述：    
 * 创建人：zhong_jing 
 * 创建时间：2011-8-22 上午10:19:11        
 *     
 */
public interface IHrPersonService {

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
	public Object addPerson(HashMap hrPersonVo)throws Exception;
	
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
	public String updatePerson(HashMap hrPersonVo)throws Exception;
	
	/**
	 * 
	 *  
	 * updatePersonPwd(修改用户密码)
	 * 创建者：SunDongYa
	 * 创建时间：2011-9-5 上午10:36:05
	 * 修改者：Administrator
	 * 修改时间：2011-9-5 上午10:36:05
	 * 修改备注：   
	 * @param hrPersonVo
	 * @return
	 * @throws Exception String
	 * @Exception 异常对象    
	 *
	 */
	public String updatePersonPwd(HashMap params)throws Exception;
	
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
	public int removePerson(String sql);
	
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
	public HashMap<String,Object> getPersons(String sql);
	
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
	public List<HashMap> get_personplancount(String condition)throws Exception;
	public List<HashMap> get_personplannotin(HashMap<String,String> condition)throws Exception;
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
	public List<HashMap> get_personlogcount(String condition)throws Exception;
	public List<HashMap> get_personlognotin(HashMap<String,String> condition)throws Exception;
	
	
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
	public Object addPm(HashMap sql)throws Exception,RuntimeException;
	
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
	public int updatePm(String sql)throws Exception,RuntimeException;
	
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
	public int deletePm(String sql)throws Exception,RuntimeException;
	
	
	public void updateHomePage(HashMap params);
	
	//保存公告
	public void addComm(HashMap params);
	
	
	/**
	 * 获取人员信息根据部门 SDY
	 * @param iperson
	 * @return
	 */
	public List querydepartment(int iperson);
	public List queryPerson(int iperson);
	// 验证 账户 是否 唯一
	public int check_zh_isonly(HashMap params);
	
	/**
	 * 更新用户系统分项关联参数
	 * @param map
	 */
	public void updatePersonOption(HashMap map);
	
	/**
	 * 获取系统选项关联人员信息
	 * @param map
	 * @return
	 */
	public List  selectOptionsCondition(String conditin);
	
	/**
	 * 获取个人预警信息
	 * @param iperson
	 * @return
	 */
	public List  select_ems_lists_by_iperson(String iperson);
	public void delEmsByperson(int iperson);
	public void inserEms(HashMap params);
	
	/**
	 * 首页全局查询
	 * @param params
	 * @return
	 */
	public List applictionSearch(HashMap params);
	
	public void deleteAll(String childupdateSql);
	
	public String updatePwd(HashMap param);
}
