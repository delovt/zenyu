/**
 * 模块名称：DataClassView(档案分类)
 * 模块说明：档案分类相关业务操作
 * 创建人：YJ
 * 创建日期：20110822
 * 修改人：
 * 修改日期：
 *
 */

package yssoft.views;

import yssoft.services.IDataClassService;
import yssoft.services.IHandleService;
import yssoft.vos.AsDataClassVO;

import java.util.HashMap;
import java.util.List;

public class DataClassView {
	private IDataClassService iDataClassService;
	private IHandleService iHandleService;

	public void setiHandleService(IHandleService iHandleService) {
		this.iHandleService = iHandleService;
	}

	public void setiDataClassService(IDataClassService iDataClassService) {
		this.iDataClassService = iDataClassService;
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
	public HashMap getMenuList(String tablename){
		HashMap<String,Object> returnHashMap = new HashMap<String,Object>();
		
		try{
			
			List treelist = this.iDataClassService.getMenuList();
			returnHashMap.put("treeXml", yssoft.utils.ToXMLUtil.createTree(treelist, "iid", "ipid", "-1"));
			
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
	 * 函数名称：addDataClass
	 * 函数说明：添加档案分类
	 * 函数参数：AsDataClassVO
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110823
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public String addDataClass(AsDataClassVO asDataClassVO){
		String result = "ok";
		try{
			
			Object obj = this.iDataClassService.addDataClass(asDataClassVO);
			result = obj.toString();
			
		}
		catch(Exception ex){
			result = "no";
		}
		return result;	
	}
	
	
	/**
	 * 函数名称：delDataClass
	 * 函数说明：删除档案分类
	 * 函数参数：iid
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110823
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public Object delDataClass(int iid){		
		Object obj = "ok";
		try{
			
			this.iDataClassService.delDataClass(iid);
			
		}
		catch(Exception ex){
			obj = "no";
		}
		return obj;	
	}
	
	
	/**
	 * 函数名称：updateDataClass
	 * 函数说明：更新档案分类
	 * 函数参数：AsDataClassVO
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110823
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public Object updateDataClass(AsDataClassVO asDataClassVO){
		Object obj = "ok";
		try{
			
			this.iDataClassService.updateDataClass(asDataClassVO);
			
		}
		catch(Exception ex){
			ex.printStackTrace();
			obj = "no";
		}
		return obj;	
	}
	
	
	/**
	 * 函数名称：getDataCountByClass
	 * 函数说明：相关档案分类的档案数据记录数
	 * 函数参数：iid 档案分类主键
	 * 函数返回：int
	 * 创建人：	YJ
	 * 创建日期：20110826
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public int getDataCountByClass(int iid){
		return this.iDataClassService.getDataCountByClass(iid);
	}
}
