/**
 * 模块名称：MrCompetitorView
 * 模块说明：竞争对手操作业务类
 * 创建人：	YJ
 * 创建日期：20110923
 * 修改人：
 * 修改日期：
 * 
 */

package yssoft.views;

import yssoft.services.IMrCompetitorService;

import java.util.HashMap;
import java.util.List;

public class MrCompetitorView {

	private IMrCompetitorService iMrCompetitorService;

	public void setiMrCompetitorService(IMrCompetitorService iMrCompetitorService) {
		this.iMrCompetitorService = iMrCompetitorService;
	}
	
	@SuppressWarnings("unchecked")
	public List getMrCopetitorList(String condition){
		return this.iMrCompetitorService.getMrCopetitorList(condition);
	}

	/**
	 * 函数名称：addMrCopetitor
	 * 函数说明：增加竞争对手信息
	 * 函数参数：
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110923
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	@SuppressWarnings("unchecked")
	public Object addMrCopetitor(HashMap paramMap) throws Exception{
		String result = "sucess";
		
		try {
			
			result = iMrCompetitorService.addMrCopetitor(paramMap).toString();//保存主表
			
		} catch (Exception e) {
			e.printStackTrace();
			result = "fail";
		}
		return result;
	}


	/**
	 * 函数名称：deleteMrCopetitor
	 * 函数说明：删除竞争对手信息
	 * 函数参数：iid（主键）
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110923
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public Object deleteMrCopetitor(String condition) throws Exception{
		String result = "sucess";
		try {
			int count = Integer.parseInt(iMrCompetitorService.deleteMrCopetitor(condition).toString());
			if(count!=1)
			{
				result = "fail";
			}

		} catch (Exception e) {
			e.printStackTrace();
			result = "fail";
		}
		return result;
	}

	/**
	 * 函数名称：updateMrCopetitor
	 * 函数说明：更新竞争对手信息
	 * 函数参数：iid（主键）
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110923
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	@SuppressWarnings("unchecked")
	public Object updateMrCopetitor(HashMap paramMap) throws Exception{
		String result = "sucess";
		try {
			int count = Integer.parseInt(iMrCompetitorService.updateMrCopetitor(paramMap).toString());
			if(count!=1)
			{
				result = "fail";
			}

		} catch (Exception e) {
			e.printStackTrace();
			result = "fail";
		}
		return result;
	}
	
	
	/**
	 * 函数名称：getSublistInfo
	 * 函数说明：获取子表信息
	 * 函数参数：HashMap paramMap
	 * 			tablename:表名
	 * 
	 * 函数返回：List
	 * 创建人：	YJ
	 * 创建日期：20110923
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	@SuppressWarnings("unchecked")
	public HashMap getSublistInfo(HashMap paramMap) throws Exception{
		
		HashMap<String, Object> returnMap = new HashMap<String, Object>();
		
		try {
			
			returnMap = this.iMrCompetitorService.getSublistInfo(paramMap);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return returnMap;
	}
	
	/**
	 * 函数名称：reGetChildrenData
	 * 函数说明：重新获取子表信息
	 * 函数参数：HashMap paramMap
	 * 			tablename:表名
	 * 			condition:条件
	 * 			
	 * 函数返回：List
	 * 创建人：	YJ
	 * 创建日期：20110923
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	@SuppressWarnings("unchecked")
	public List reGetChildrenData(HashMap paramMap) throws Exception{
		
		List reList = null;
		
		try{
			
			reList = this.iMrCompetitorService.reGetChildrenData(paramMap);
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		
		return reList;
	}
	
	@SuppressWarnings("unchecked")
	public HashMap onGetResult(HashMap paramMap){
		
		HashMap hm = new HashMap();
		try{
			
			hm = this.iMrCompetitorService.onGetResult(paramMap);
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		return hm;
	}
	
	@SuppressWarnings("unchecked")
	public HashMap onGetResFunValue(HashMap paramMap){
		
		HashMap hm = new HashMap();
		try{
			
			hm = this.iMrCompetitorService.onGetResFunValue(paramMap);
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		return hm;
	}
	
	@SuppressWarnings("unchecked")
	public String onGetResFunValue2(HashMap paramMap){
		
		String rstr = "";
		try{
			
			rstr = this.iMrCompetitorService.onGetResFunValue2(paramMap);
			
		}catch (Exception e) {
			e.printStackTrace();
		}
		return rstr;
	}
	
}
