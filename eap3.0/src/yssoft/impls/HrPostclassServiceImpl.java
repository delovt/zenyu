/**    
 *
 * 文件名：HrPostclassServiceImpl.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-8-15    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IHrPostclassService;
import yssoft.vos.HrJobVo;
import yssoft.vos.HrPostVo;
import yssoft.vos.HrPostclassVo;

import java.util.HashMap;
import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：HrPostclassServiceImpl    
 * 类描述：    
 * 创建人：zhong_jing 
 * 创建时间：2011-8-15 下午06:37:04        
 *     
 */
public class HrPostclassServiceImpl extends BaseDao implements IHrPostclassService{

	/**
	 * 
	 *  
	 * addPostclass(新增职类)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-12 下午04:09:48
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param hrDepartmentVo(新增条件)
	 * @return Object 插入主键
	 * @Exception 异常对象    
	 *
	 */
	public Object addPostclass(HrPostclassVo postclassVo)throws Exception
	{
		return this.insert("add_postclass",postclassVo);
	}
	
	/**
	 * 
	 * updateDepartment(修改职类别)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-12 下午04:30:00
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param hrDepartmentVo(修改条件)
	 * @return int(修改多少行)
	 * @Exception 异常对象    
	 *
	 */
	public int updatePostclass(HrPostclassVo postclassVo)throws Exception
	{
		return this.update("update_postclass",postclassVo);
	}
	
	/**
	 * 
	 * removeDepartment(删除职类别)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-12 下午04:34:11
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param iid 内码
	 * @return int删除行数
	 * @Exception 异常对象    
	 *
	 */
	public int removePostclass(int iid)throws Exception
	{
		return this.delete("remove_postclass",iid);
	}
	//lzx删除同以职务体系下的所有职务
	public int removeAllPost(int ipostclass) throws Exception {
		return this.delete("remove_all_post", ipostclass);
	}

	
	/**
	 *  
	 * getAllPostclass(查询职类)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-16 上午08:39:19
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @return List<HashMap>职类
	 *
	 */
	public List<HashMap> getAllPostclass()
	{
		List<HashMap> allPostclass =this.queryForList("get_all_postclass");
		return allPostclass;
	}
	
	/**
	 * 
	 * addJob(新增一条职位)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-15 下午01:08:05
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param hrJobVo 新增对象
	 * @return Object
	 * @Exception 异常对象    
	 *
	 */
	public Object addPost(HrPostVo hrPostVo)throws Exception
	{
		return this.insert("add_post",hrPostVo);
	}
	
	/**
	 * 
	 * removeJob(删除职位)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-15 下午02:19:03
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param sql sql语句
	 * @return
	 * @throws Exception int
	 * @Exception 异常对象    
	 *
	 */
	public int removePost(String sql)throws Exception
	{
		return this.delete("remove_post",sql);
	}

	/**
	 * 
	 * updateJob(修改职位)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-15 下午02:20:16
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param hrJobVo 修改记录
	 * @return
	 * @throws Exception int
	 * @Exception 异常对象    
	 *
	 */
	public int updatePost(HrPostVo hrPostVo)throws Exception
	{
		return this.update("update_post",hrPostVo);
	}
	
	/**
	 * 
	 * getJobVoById(查询职位)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-15 下午03:54:21
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param iid 部门编码
	 * @return List<HrJobVo> 结果
	 *
	 */
	public List<HrJobVo> getPostVoById(int iid)
	{
		return this.queryForList("getpost_by_ipostclass",iid);
	}
}
