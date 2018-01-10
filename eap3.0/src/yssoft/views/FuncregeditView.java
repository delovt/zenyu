/**
 * 模块名称：FuncregeditView
 * 模块说明：数据操作业务实现类
 * 创建人：	YJ
 * 创建日期：20110810
 * 修改人：
 * 修改日期：
 * 
 */

package yssoft.views;

import yssoft.services.IDatadictionaryService;
import yssoft.services.IHandleService;
import yssoft.utils.ToXMLUtil;
import yssoft.vos.AsFuncregeditVO;

import java.util.HashMap;
import java.util.List;

public class FuncregeditView {

	// 视图层的业务层
	private IHandleService iHandleService;
	
	public void setiHandleService(IHandleService iHandleService) {
		this.iHandleService = iHandleService;
	}
	
	private IDatadictionaryService iDatadictonaryService;

	public void setiDatadictonaryService(
			IDatadictionaryService iDatadictonaryService) {
		this.iDatadictonaryService = iDatadictonaryService;
	}
	public List getMenuListByTableName(String tablename){
		
		List list  = null;
		return list;
	}
	
	
	/**
	 * 函数名称：getMenuList
	 * 函数说明：获取菜单数据、表字段(不为空)
	 * 函数参数：无
	 * 函数返回：HashMap(treelist,fieldslist)
	 * 
	 * 创建人：YJ
	 * 修改人：
	 * 创建日期：20110811 
	 * 修改日期：
	 *	
	 */
	@SuppressWarnings("unchecked")
	public HashMap getMenuList(String tablename){
		HashMap<String,Object> resultmap = new HashMap<String,Object>();
		String xmlstr = "";
		
		//获取菜单的数据集
		List<HashMap> treelist = this.iHandleService.getMenuList();
		if(treelist.size()==0){
			resultmap.put("treexml", null);
		}
		else{
			xmlstr =ToXMLUtil.createTree(treelist, "iid", "ipid", "-1");
			resultmap.put("treexml", xmlstr);
		}
		
		//获取不为空的数据集
		List<HashMap> fieldslist = this.iHandleService.getFieldsByTable(tablename);		
		
		resultmap.put("fieldslist", fieldslist);
		
		return resultmap;
	}
	
	/**
	 * 函数名称：addFuncrededit
	 * 函数说明：增加功能注册表信息
	 * 函数参数：AsFuncregeditVO（功能注册表实体对象）
	 * 函数返回：String(是否成功)
	 * 
	 * 创建人：	YJ
	 * 创建日期：20110810
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public String addFuncrededit(AsFuncregeditVO asFuncregeditVO){
		String result ="sucess";
		try{
			
			//保存功能注册信息
			Object resultObj = this.iHandleService.addFuncrededit(asFuncregeditVO);
			result = resultObj.toString();
		}
		catch(Exception ex){
			result ="fail";
		}
		
		return result;
	}
	
	/**
	 * 函数名称：updateFuncrededit
	 * 函数说明：更新功能注册表信息
	 * 函数参数：AsFuncregeditVO（功能注册表实体对象）
	 * 函数返回：String(是否成功)
	 * 
	 * 创建人：	YJ
	 * 创建日期：20110810
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public String updateFuncrededit(AsFuncregeditVO asFuncregeditVO){
		String result ="sucess！";
		try{
			
			//保存功能注册信息
			@SuppressWarnings("unused")
			Object resultObj = this.iHandleService.updateFuncrededit(asFuncregeditVO);
		}
		catch(Exception ex){
			result ="fail";
		}
		
		return result;
	}
	/**
	 * 函数名称：deleteFuncrededit
	 * 函数说明：删除功能注册表信息
	 * 函数参数：iid（主键）
	 * 函数返回：String(是否成功)
	 * 
	 * 创建人：	YJ
	 * 创建日期：20110810
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public String deleteFuncrededit(int iid){
		String result ="sucess";
		try{
			
			//保存功能注册信息
			@SuppressWarnings("unused")
			Object resultObj = this.iHandleService.deleteFuncrededit(iid);
		}
		catch(Exception ex){
			result ="fail";
		}
		
		return result;
	}
	
	/*cody by liu lei begin*/
	public String get_cname_FuncregeditByID(int iid)
	{
	   return this.iHandleService.get_cname_FuncregeditByID(iid);
    }
	/*cody by liu lei end*/

	
	/**
	 * 函数名称：getSingleFuncregeditByID
	 * 函数说明：根据主键获得信息
	 * 函数参数：iid（主键）
	 * 函数返回：HashMap
	 * 创建人：	钟晶
	 * 创建日期：20111010
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public HashMap getSingleFuncregeditByID(int iid)
	{
		HashMap resultMap = new HashMap();
		HashMap funcregeditMap =this.iHandleService.getSingleFuncregeditByID(iid);
		resultMap.put("funcregeditMap", funcregeditMap);
		if(funcregeditMap.get("ctable")!=null)
		{
			HashMap paramObject = new HashMap();
			paramObject.put("ifuncregedit", iid);
			List datadictonaryList =iDatadictonaryService.getCrmRefer(paramObject);
			resultMap.put("datadictonaryList", datadictonaryList);
		}
		return resultMap;
	}

	
	/*cody by liu lei begin*/
	public String get_cparameter_FuncregeditByID(int iid)
	{
	   return this.iHandleService.get_cparameter_FuncregeditByID(iid);
    }
	/*cody by liu lei end*/

	//add by zhong_jing 查询所有主表
	public List getAllFuncregeditBybdataauth1()
	{
		return this.iHandleService.getAllFuncregeditBybdataauth1();
	}
	
	public List getdatadictonaryList(HashMap paramObj)
	{
		return iDatadictonaryService.getCrmRefer(paramObj);
	}
}
