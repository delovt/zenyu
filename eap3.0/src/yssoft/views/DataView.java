/**
 * 模块名称：DataView(档案分类)
 * 模块说明：档案数据相关业务操作
 * 创建人：YJ
 * 创建日期：20110822
 * 修改人：
 * 修改日期：
 *
 */

package yssoft.views;

import yssoft.services.IDataService;
import yssoft.services.IHandleService;
import yssoft.vos.AsDataVO;

import java.util.HashMap;
import java.util.List;

public class DataView {
	private IDataService iDataService;
	private IHandleService iHandleService;

	
	public void setiDataService(IDataService iDataService) {
		this.iDataService = iDataService;
	}


	public void setiHandleService(IHandleService iHandleService) {
		this.iHandleService = iHandleService;
	}


	/**
	 * 函数名称：getMenuListByClass
	 * 函数说明：获取菜单列表(根据分类)
	 * 函数参数：无
	 * 函数返回：List
	 * 创建人：	YJ
	 * 创建日期：20110810
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public HashMap getMenuListByClass(HashMap paramMap){
		HashMap<String,Object> returnHashMap = new HashMap<String,Object>();
		
		int bsystem = Integer.parseInt(paramMap.get("bsystem").toString());
		String tablename = paramMap.get("tablename").toString();
		
		try{
			List treeXml = this.iDataService.getMenuListByClass(bsystem);
			if(treeXml.size()>0)
				returnHashMap.put("treeXml", yssoft.utils.ToXMLUtil.createTree(treeXml, "iid", "ipid", "-1"));
			else
				returnHashMap.put("treeXml", null);
			
			//获取不为空的数据集
			List<HashMap> fieldslist = this.iHandleService.getFieldsByTable(tablename);				
			returnHashMap.put("fieldslist", fieldslist);
			                                                                        
		}
		catch(Exception ex){
			System.out.println(ex.getMessage());
		}
		
		return returnHashMap;
	}
	
	
	/**
	 * 函数名称：getMenuList
	 * 函数说明：获取菜单列表
	 * 函数参数：tablename(业务表名称)
	 * 函数返回：HashMap
	 * 创建人：	YJ
	 * 创建日期：20110822
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	@SuppressWarnings("unchecked")
	public String getMenuList(int iclass){
			
		List list = this.iDataService.getMenuList(iclass);
		if(list.size() == 0)
			return null;
		else
			return yssoft.utils.ToXMLUtil.createTree(list, "iid", "ipid", "-1");
		
	}
	
	
	/**
	 * 函数名称：addData
	 * 函数说明：添加档案数据
	 * 函数参数：AsDataVO
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110823
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public String addData(AsDataVO asDataVO){
		String result = "ok";
		try{
			
			Object obj = this.iDataService.addData(asDataVO);
			result = obj.toString();
			
		}
		catch(Exception ex){
			ex.printStackTrace();
			result = "no";
		}
		return result;	
	}
	
	
	/**
	 * 函数名称：delData
	 * 函数说明：删除档案数据
	 * 函数参数：iid
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110823
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public Object delData(int iid){		
		Object obj = "ok";
		try{
			
			this.iDataService.delData(iid);
			
		}
		catch(Exception ex){
			ex.printStackTrace();
			obj = "no";
		}
		return obj;	
	}
	
	
	/**
	 * 函数名称：updateData
	 * 函数说明：更新档案分类
	 * 函数参数：AsDataVO
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110823
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public Object updateData(AsDataVO asDataVO){
		Object obj = "ok";
		try{
			
			this.iDataService.updateData(asDataVO);
			
		}
		catch(Exception ex){
			ex.printStackTrace();
			obj = "no";
		}
		return obj;	
	}
}
