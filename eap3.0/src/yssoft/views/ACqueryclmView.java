/**
 * 模块名称：ACqueryclmView
 * 模块说明：查询条件配置表操作业务类
 * 创建人：	YJ
 * 创建日期：20110815
 * 修改人：
 * 修改日期：
 * 
 */
package yssoft.views;

import yssoft.services.IACqueryclmService;

import java.util.HashMap;
import java.util.List;

import flex.messaging.io.ArrayCollection;
import flex.messaging.io.ArrayList;

public class ACqueryclmView {

	private IACqueryclmService iACqueryclmService;

	public void setiACqueryclmService(IACqueryclmService iACqueryclmService) {
		this.iACqueryclmService = iACqueryclmService;
	}

	public List getAcQueryclmList(int ifuncregedit){		
		 
		return iACqueryclmService.getAcQueryclmList(ifuncregedit);
	}
	
	public List getFWFConditionclmList(int ifuncregedit){		
		 
		return iACqueryclmService.getFWFConditionclmList(ifuncregedit);
	}
	/**
	 * 函数名称：addAcqueryclm
	 * 函数说明：增加查询条件定制表信息
	 * 函数参数：AsACqueryclmVO（查询条件定制表实体对象）
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110819
	 * 修改人：
	 * 修改日期：
	 * @throws Exception 
	 * 
	 */
	public Object addAcqueryclm(HashMap hashmap) throws Exception{
			//另外的一种做法，以后考虑
//			List<AsACqueryclmVO> asACqueryclmVOs=(List<AsACqueryclmVO>)hashmap.get("datalist");//记录集
//			for (AsACqueryclmVO asACqueryclmVO : asACqueryclmVOs) {
//				this.iACqueryclmService.addAcqueryclm(asACqueryclmVO);
//			}
			
		Object obj = this.iACqueryclmService.addAcqueryclm(hashmap);
			
		return obj;
	}
	
	
	/**
	 * 函数名称：deleteAcqueryclm
	 * 函数说明：删除查询条件定制表信息
	 * 函数参数：iid（主键）
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110819
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public Object deleteAcqueryclm(int iid) throws Exception{
		
		return this.iACqueryclmService.deleteAcqueryclm(iid);
	}
	
	/**
	 * 函数名称：updateAcqueryclm
	 * 函数说明：更新查询条件定制表信息
	 * 函数参数：iid（主键）
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110819
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public Object updateAcqueryclmData(HashMap paramMap) throws Exception{
		
		return this.iACqueryclmService.updateAcqueryclm(paramMap);
	}
	
	/**
	 * 
	 * updateAcqueryclm(修改排序状态)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-27 上午10:32:41
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param paramMaps 排序值
	 * @return
	 * @throws Exception String
	 * @Exception 异常对象    
	 *
	 */
	@SuppressWarnings("rawtypes")
	public String updateAcqueryclm(List<HashMap> paramMaps)
	{
		try
		{
			for (HashMap hashMap : paramMaps) {
				this.iACqueryclmService.updateAcqueryclmBySort(hashMap);
			}
		}
		catch(Exception e)
		{
			e.printStackTrace();
			return "fail";
		}
		
		return "success";
	}
	
	public String updateAcqueryclm_1(HashMap paramMaps)
	{
		try
		{
			
			ArrayCollection arr =(ArrayCollection) paramMaps.get("datalist");
			for(int i=0;i<arr.size();i++){
				
				this.iACqueryclmService.updateAcqueryclmByCondition((HashMap)arr.get(i));
			}
			
			
		}
		catch(Exception e)
		{
			e.printStackTrace();
			return "fail";
		}
		
		return "success";
	}
}
