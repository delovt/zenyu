/**    
 *
 * 文件名：IListsetService.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-8-16    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.services;

import yssoft.vos.AcListclmVo;
import yssoft.vos.AcListsetVo;

import java.util.HashMap;
import java.util.List;


/**    
 *     
 * 项目名称：yscrm    
 * 类名称：IListsetService    
 * 类描述：    
 * 创建人：zhong_jing 
 * 创建时间：2011-8-16 下午05:25:00        
 *     
 */
public interface IAcListsetService {

	/**
	 * 
	 * verificationSql(验证sql)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-16 下午05:26:43
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param sql SQL语句
	 * @return 查询值
	 * @throws Exception List<HashMap>
	 * @Exception 异常对象    
	 *
	 */
	public List<HashMap<String, Object>> verificationSql(String sql)throws Exception;
	
	/**
	 * 
	 * getListset(列表配置表)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-17 下午05:12:10
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param id 关联功能注册码
	 * @return AcListsetVo 查询结果
	 *
	 */
	public AcListsetVo getListset(int ifuncregedit);

    public List getListsetp(HashMap hashMap);
	
	/**
	 * 
	 * getAcListclm(列表格式设置表)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-17 下午05:14:49
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param ilist 配置表内码
	 * @return List<AcListclmVo> 列表格式设置表
	 *
	 */
	public List<AcListclmVo> getAcListclm(AcListclmVo acListclmVo);
    public List<AcListclmVo> getAcListclmSet(AcListclmVo acListclmVo);
	/**
	 * 
	 * getAcListclm(列表格式设置表)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-17 下午05:14:49
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param ilist 配置表内码
	 * @return List<AcListclmVo> 列表格式设置表
	 *
	 */
	public List<AcListclmVo> getAcListclmForServer(AcListclmVo acListclmVo);
	
	/**
	 * 
	 * addlistclm(保存列表格式设置表)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-18 下午02:17:13
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param acListclmVo 要增加的列表
	 * @return Object 是否添加成功
	 * @Exception 异常对象    
	 *
	 */
	public Object addlistclm(AcListclmVo acListclmVo)throws Exception;
	
	/**
	 *  
	 * updatelistclm(修改列表配置表)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-18 下午02:26:17
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param acListsetVo 修改问题
	 * @return 是否成功
	 * @throws Exception  
	 * @Exception 异常对象    
	 *
	 */
	public int updateListset(AcListsetVo acListsetVo)throws Exception;
	
	/**
	 * 
	 * addlistclm(添加列表配置表)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-18 下午02:27:53
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param acListsetVo 新增的列表
	 * @return 是否成功
	 * @throws Exception 
	 * @Exception 异常对象    
	 *
	 */
	public Object addListset(AcListsetVo acListsetVo)throws Exception;
	
	/**
	 * 
	 * removeListclm(删除)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-21 下午01:51:35
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param iid
	 * @return int
	 * @Exception 异常对象    
	 *
	 */
	public int removeListclm(HashMap paramObject)throws Exception;
	
	/**
	 * 
	 * updatelistclm(修改)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-3 上午10:44:51
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param acListclmVo
	 * @return int
	 * @Exception 异常对象    
	 *
	 */
	public int updatelistclm(AcListclmVo acListclmVo)throws Exception;
	
	/**
	 * 
	 * addlistclmByResume(恢复默认)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-6 下午02:59:07
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param iperson
	 * @return
	 * @throws Exception Object
	 * @Exception 异常对象    
	 *
	 */
	public Object addlistclmByResume(HashMap iperson) throws Exception;
	
	/**
	 * 
	 * getListcd(列表配置常用条件查询)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-20 上午11:35:53
	 * 修改者：Lenovo
	 * 修改时间：2011-9-20 上午11:35:53
	 * 修改备注：   
	 * @return List<HashMap>
	 * @Exception 异常对象    
	 *
	 */

    public List<HashMap> getListcd(HashMap paramObj);
    public List<HashMap> getListStyle(HashMap paramObj);
	public List<HashMap> getListcd2(HashMap paramObj);
	/**
	 * 
	 * addListcd(添加列表配置常用条件)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-20 下午04:41:34
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param listcdVo
	 * @return Object
	 * @Exception 异常对象    
	 *
	 */
	public Object addListcd(HashMap paramObj)throws Exception;

    public Object addListStyle(HashMap paramObj)throws Exception;
	
	/**
	 * 
	 * updateListcd(修改列表配置常用条件)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-20 下午04:42:38
	 * 修改者：Lenovo
	 * 修改时间：2011-9-20 下午04:42:38
	 * 修改备注：   
	 * @param listcdVo
	 * @return int
	 * @Exception 异常对象    
	 *
	 */
	public int updateListcd(HashMap paramObj)throws Exception;

    public int updateListStyle(HashMap paramObj)throws Exception;
	
	/**
	 * 
	 * removeListcd(删除列表配置常用条件)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-20 下午04:44:21
	 * 修改者：Lenovo
	 * 修改时间：2011-9-20 下午04:44:21
	 * 修改备注：   
	 * @param iid
	 * @return int
	 * @Exception 异常对象    
	 *
	 */
	public int removeListcd(int iid)throws Exception;
	
	public int deleteListclm(int ifuncregedit);
    public int deleteListStyle(int iid);
	
	public List queryType(String sql)throws Exception;
	
	public List queryDataType();
}
