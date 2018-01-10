/**    
 *
 * 文件名：HRPostclassView.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-8-16    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.views;

import yssoft.services.IHrPostclassService;
import yssoft.utils.ToXMLUtil;
import yssoft.vos.HrJobVo;
import yssoft.vos.HrPostVo;
import yssoft.vos.HrPostclassVo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：HRPostclassView    
 * 类描述：    
 * 创建人：zhong_jing 
 * 创建时间：2011-8-16 上午09:07:52        
 *     
 */
public class HRPostclassView {

	private IHrPostclassService iHrPostclassService;

	public void setiHrPostclassService(IHrPostclassService iHrPostclassService) {
		this.iHrPostclassService = iHrPostclassService;
	}
	
	/**
	 * 
	 *  
	 * addDepartment(新增部门)
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
	public String addPostclass(HrPostclassVo hrPostclassVo)
	{
		String result="success";
		try {
			result= this.iHrPostclassService.addPostclass(hrPostclassVo).toString();
		} catch (Exception e) {
			e.printStackTrace();
			result ="fail";
		}
		return result;
	}
	
	/**
	 * 
	 * updateDepartment(修改部门)
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
	public String updatePostclass(HrPostclassVo hrPostclassVo)
	{
		String result="success";
		try {
			int count =this.iHrPostclassService.updatePostclass(hrPostclassVo);
			if(count==0)
			{
				result ="fail";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	/**
	 * 
	 * removeDepartment(删除部门)
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
	public String removePostclass(int iid)
	{
		String result="success";
		try {
			int count = this.iHrPostclassService.removePostclass(iid);
			if(count==0)
			{
				result="fail";
			}
		} catch (Exception e) {
			e.printStackTrace();
			result ="fail";
		}
		return result;
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
	public String getAllPostclass()
	{
		List post =this.iHrPostclassService.getAllPostclass();
		if(post.size()==0)
		{
			return null;
		}
		return ToXMLUtil.createTree(post, "iid", "ipid", "-1");
	}
	
	/**
	 * 
	 * addJob(邢增一条记录)
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
	@SuppressWarnings("unchecked")
	public List<HrPostVo> addPost(HashMap paramObj)
	{
		List<HrPostVo> posts = new ArrayList<HrPostVo>();
		StringBuffer sqlBuffer = new StringBuffer();
		
		try {
			List<HrPostVo> jobvoList =(List<HrPostVo>) paramObj.get("jobArr");
			for(int i=0;i<jobvoList.size();i++) {
				HrPostVo hrPostVo =(HrPostVo)jobvoList.get(i);
				if(hrPostVo.getIid()==0)
				{
					Object obj = this.iHrPostclassService.addPost(hrPostVo);
					hrPostVo.setIid(Integer.valueOf(obj.toString()).intValue());
					posts.add(hrPostVo);
				}
				else
				{
					this.iHrPostclassService.updatePost(hrPostVo);
				}
			}
			List<HrPostVo> removeList=(List<HrPostVo>)paramObj.get("removeArr");
			
			if(removeList.size() >0){
				
				sqlBuffer.append(" iid in (");
				
				for (int j = 0; j < removeList.size(); j++) {
					
					HrPostVo hrJobVo = (HrPostVo)removeList.get(j);
					
					if(hrJobVo.getIid()>0)
					{
						sqlBuffer.append(hrJobVo.getIid()+",");
					}
				}
				if(sqlBuffer.length()>1)
				{
                    int endNum = 0;
                    if(sqlBuffer.toString().lastIndexOf(",") > -1) {
                        endNum =  sqlBuffer.toString().lastIndexOf(",");
                    }
                    String delstr = "";
                    if (endNum != 0) {
                        delstr   = sqlBuffer.toString().substring(0,endNum)+")";
                        this.iHrPostclassService.removePost(delstr);
                    }
				}
			}
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		}
		return posts;
	}
	
	/**
	 * 
	 * getJobVoById(查询工作岗位)
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
		return this.iHrPostclassService.getPostVoById(iid);
	}
}
