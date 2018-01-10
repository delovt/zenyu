
package yssoft.views;

import yssoft.services.IDatadictionaryService;
import yssoft.utils.ToXMLUtil;

import java.util.HashMap;
import java.util.List;

public class DatadictionaryView {
	private IDatadictionaryService iDatadictonaryService;

	public void setiDatadictonaryService(
			IDatadictionaryService iDatadictonaryService) {
		this.iDatadictonaryService = iDatadictonaryService;
	}
	
	/**
	 * 函数名称：getTreeMenuList
	 * 函数说明：获取菜单数据
	 * 函数参数：无
	 * 函数返回：String
	 * 
	 * 创建人：YJ
	 * 修改人：
	 * 创建日期：20110815 
	 * 修改日期：
	 *	
	 */
	public String getTreeMenuList(HashMap paramMap){
		
		//获取树对应的数据集
		List<HashMap> list = iDatadictonaryService.getTreeMenuList(paramMap);
		String treeXml = "";
		
		if(!paramMap.containsKey("single"))
		{
			HashMap param = new HashMap();
			param.put("ifuncregedit", null);
			param.put("ctable", null);
			List<HashMap> tableList= iDatadictonaryService.getTable(param);
			for(int i=0;i<tableList.size();i++)
			{
				HashMap result =(HashMap)tableList.get(i);
				int iid = Integer.valueOf(result.get("iid").toString())+10000000;
				result.put("iid", iid);
				
			}
			list.addAll(tableList);
		}
		//转换为树结构
		if(list.size()>0){
			treeXml = ToXMLUtil.createTree(list, "iid", "ipid", "-1");
		}
		return treeXml;
	}
	
	public List getTreeMenuTable(HashMap paramMap){
		List<HashMap> tableList= iDatadictonaryService.getTable(paramMap);
		for(int i=0;i<tableList.size();i++)
		{
			HashMap result =(HashMap)tableList.get(i);
			int iid = Integer.valueOf(result.get("iid").toString())+10000000;
			result.put("iid", iid);
			
		}
		
		return tableList;
	}
	public String getTable(int iid)
	{
		return this.iDatadictonaryService.queryData(iid);
	}
	
	/**
	 * 函数名称：getTreeMenuList
	 * 函数说明：获取菜单数据
	 * 函数参数：无
	 * 函数返回：String
	 * 
	 * 创建人：YJ
	 * 修改人：
	 * 创建日期：20110815 
	 * 修改日期：getTreeMenuList
	 *	
	 */
	public List getDataList(HashMap param){
		List<HashMap> list = iDatadictonaryService.getDataList(param);
		return list;
	}
	
	/**
	 * 函数名称：getTreeMenuList
	 * 函数说明：获取菜单数据
	 * 函数参数：无
	 * 函数返回：String
	 * 
	 * 创建人：YJ
	 * 修改人：
	 * 创建日期：20110815 
	 * 修改日期：
	 *	
	 */
	public HashMap updateDatadictonary(){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = iDatadictonaryService.updateDatadictonary();
		return resultMap;
	}
	
	public HashMap addDatadictonary(HashMap paramMap){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = iDatadictonaryService.adddDatadictonary(paramMap);
		return resultMap;
	}
	
	/**
	 * 函数名称：saveDatadictonary
	 * 函数说明：保存数据字典
	 * 函数参数：Array
	 * 函数返回：HashMap
	 * 创建人：	YJ
	 * 创建日期：20110810
	 * 修改人：
	 * 修改日期： 
	 **/
	public HashMap saveDatadictonary(HashMap paramMap){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		resultMap = iDatadictonaryService.saveDatadictonary(paramMap);
		return resultMap;
	}
	
	/**
	 * 
	 * getCrmRefer(查询数据字典)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-29 下午03:19:06
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param iid
	 * @return HashMap
	 * @Exception 异常对象    
	 *
	 */
	public List getCrmRefer(HashMap iid)
	{
		return  this.iDatadictonaryService.getCrmRefer(iid); 
	}
	
	/**
	 * 
	 * getValue(查询参照)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-31 上午09:21:50
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param sql
	 * @return List
	 * @Exception 异常对象    
	 *
	 */
	public List getValue(String sql)
	{
//		if(sql ==null || sql == ""){
//			System.out.println("---查询参照 sql 有问题---");
//			return null;
//		}
//		sql = sql.replace("@childsql","");
		
		return this.iDatadictonaryService.getValue(sql);
	}
	
	public List getVouchForm(HashMap paramMap)
	{
		return this.iDatadictonaryService.getVouchForm(paramMap);
	}
	
	/**
	 * 
	 * 
	 * addRole(新增角色)
	 * 
	 * @param roleVo
	 *            要新增的对象
	 * 
	 * @return 是否保存成功
	 * 
	 * @since CodingExample　Ver(编码范例查看) 1.1
	 */
	public HashMap addVouch(HashMap paramMap) {
		return this.iDatadictonaryService.addVouch(paramMap);
	}
	
	public HashMap getVouch(HashMap paramMap)
	{
		HashMap resultMap = new HashMap();
		resultMap.put("vouchList", this.iDatadictonaryService.getVouch(paramMap)) ;
		resultMap.put("vouchFormList",this.iDatadictonaryService.getVouchForm(paramMap));
		resultMap.put("taleList",this.iDatadictonaryService.getTable(paramMap));
		return resultMap;
	}
	
	/**
	 * 
	 * 
	 * updateRole(修改角色)
	 * 
	 * @param roleVo
	 *            修改的内容
	 * 
	 * @return 是否保存成功
	 * 
	 * @since CodingExample　Ver(编码范例查看) 1.1
	 */
	public HashMap updateVouch(HashMap paramMap) {
//		// 默认声明结果集为成功
//		String result = "sucess";
//		try {
//			result = this.iDatadictonaryService.updateVouch(paramMap);
//		} catch (Exception e) {
//			// 如抛异常，则修改失败
//			result = "fail";
//		}
//		return result;
		return this.iDatadictonaryService.updateVouch(paramMap);
	}
	
	public HashMap<String, Object> removeVouch(int ifuncregedit)
	{
		// 默认声明结果集为成功
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		try {
			 this.iDatadictonaryService.removeVouch(ifuncregedit);
			 resultMap.put("message", "删除成功！");
		} catch (Exception e) {
			// 如抛异常，则删除失败
			 resultMap.put("message", "删除失败！");
		}
		return resultMap;
	}
	
	public HashMap queryVouchAndDia(HashMap param)
	{
		HashMap resultMap = new HashMap();
		resultMap.put("notInDataList", this.iDatadictonaryService.queryNotinData(param));
		resultMap.put("vochFormList",this.iDatadictonaryService.getVouchForm(param));
		return resultMap;
	}
	
	public String get_funcregeditsqlstr(int iid)
	{
		return this.iDatadictonaryService.get_funcregeditsqlstr(iid);
	}
	
	public List getBodyConsult(int iid)
	{
		return this.iDatadictonaryService.getBodyConsult(iid);
	}
	
	public String get_checkIsTreeDatadic(Object iid){
		Object result =this.iDatadictonaryService.checkIsTreeDatadic(iid);
		if(result==null){
			return null;
		}else{
			return result.toString();
		}
	}
}
