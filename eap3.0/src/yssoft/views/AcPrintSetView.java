/**
 * 模块名称：AcPrintSetView
 * 模块说明：数据操作业务实现类
 * 创建人：	YJ
 * 创建日期：20110810
 * 修改人：
 * 修改日期：
 * 
 */

package yssoft.views;

import yssoft.services.IAcConsultService;
import yssoft.services.IAcPrintSetService;
import yssoft.vos.AcPrintSetVO;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

;

public class AcPrintSetView {

	// 视图层的业务层
	private IAcPrintSetService iAcPrintSetService;
	private IAcConsultService iAcConsultService;

	public void setiAcPrintSetService(IAcPrintSetService iAcPrintSetService) {
		this.iAcPrintSetService = iAcPrintSetService;
	}

	public void setiAcConsultService(IAcConsultService iAcConsultService) {
		this.iAcConsultService = iAcConsultService;
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
	public HashMap getMenuList(){

		HashMap<String,Object> returnHashMap = new HashMap<String,Object>();

		try{

			List treeXml = this.iAcPrintSetService.getMenuList();

			if(treeXml.size()>0)
				returnHashMap.put("treeXml", yssoft.utils.ToXMLUtil.createTree(treeXml, "iid", "ipid", "-1"));
			else
				returnHashMap.put("treeXml", null);
		}
		catch(Exception ex){
			System.out.println(ex.getMessage());
		}

		return returnHashMap;

	}

	/**
	 * 函数名称：addAcPrintSet
	 * 函数说明：增加打印设置表信息
	 * 函数参数：AcPrintSetVO（打印设置实体对象）
	 * 函数返回：String(是否成功)
	 * 
	 * 创建人：	YJ
	 * 创建日期：20110810
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public String addAcPrintSet(AcPrintSetVO acprintsetvo){
		String result ="sucess";
		try{

			//保存功能注册信息
			Object resultObj = this.iAcPrintSetService.addAcPrintSet(acprintsetvo);
			result = resultObj.toString();
		}
		catch(Exception ex){
			result ="fail";
		}

		return result;
	}

	/**
	 * 函数名称：updateAcPrintSet
	 * 函数说明：更新打印设置表信息
	 * 函数参数：AcPrintSetVO（打印设置表实体对象）
	 * 函数返回：String(是否成功)
	 * 
	 * 创建人：	YJ
	 * 创建日期：20110810
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public String updateAcPrintSet(AcPrintSetVO acprintsetvo){
		String result ="sucess！";
		try{

			//保存功能注册信息
			@SuppressWarnings("unused")
			Object resultObj = this.iAcPrintSetService.updateAcPrintSet(acprintsetvo);
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
	public String deleteAcPrintSet(int iid){
		String result ="sucess";
		try{

			//保存功能注册信息
			@SuppressWarnings("unused")
			Object resultObj = this.iAcPrintSetService.deleteAcPrintSet(iid);
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
	@SuppressWarnings("unchecked")
	public List getDataByIfuncregedit(int condition){
		List list = null;
		try{

			//保存功能注册信息
			list = this.iAcPrintSetService.getDataByIfuncregedit(condition);
		}
		catch(Exception ex){

		}

		return list;
	}


	/**ac_printsets表操作*/
	public String oper_printsets(HashMap params)
	{
		String result = "sucess";
		try
		{
			List<HashMap> insertdata=(List<HashMap>)params.get("insertdata");
			for (HashMap hashMap : insertdata) {
				this.add_ac_printsets(hashMap);
			}
			List<HashMap> updatedata=(List<HashMap>)params.get("updatedata");
			for (HashMap hashMap : updatedata) {
				this.update_ac_printsets(hashMap);
			}
			List<HashMap> deletedata=(List<HashMap>)params.get("deletedata");
			if (deletedata!=null && deletedata.size()>0)
			{
				String rangeiid="";
				boolean first=true;
				for (HashMap hashMap : deletedata) {
					if (first)
					{
						rangeiid=hashMap.get("iid").toString();
						first=false;
					}
					else
					{
						rangeiid=rangeiid+","+hashMap.get("iid").toString();
					}
				}
				if (!rangeiid.equals(""))
				{
					this.delete_bywhere_ac_printsets("iid in ("+rangeiid+")");
				}
			}
		}
		catch(Exception e)
		{
			result = "fail";
		}
		return result;
	}
	/**ac_printclm表操作*/
	public String oper_printclm(HashMap params)
	{
		String result = "sucess";
		try
		{
			List<HashMap> insertdata=(List<HashMap>)params.get("insertdata");
			for (HashMap hashMap : insertdata) {
				this.add_ac_printclm(hashMap);
			}
			List<HashMap> updatedata=(List<HashMap>)params.get("updatedata");
			for (HashMap hashMap : updatedata) {
				this.update_ac_printclm(hashMap);
			}
			List<HashMap> deletedata=(List<HashMap>)params.get("deletedata");
			if (deletedata!=null && deletedata.size()>0)
			{
				String rangeiid="";
				boolean first=true;
				for (HashMap hashMap : deletedata) {
					if (first)
					{
						rangeiid=hashMap.get("iid").toString();
						first=false;
					}
					else
					{
						rangeiid=rangeiid+","+hashMap.get("iid").toString();
					}
				}
				if (!rangeiid.equals(""))
				{
					this.delete_bywhere_ac_printclm("iid in ("+rangeiid+")");
				}
			}
		}
		catch(Exception e)
		{
			result = "fail";
		}
		return result;
	}
	public List<HashMap> get_sql_byprintsets(String condition)
	{
		try
		{
			return this.iAcPrintSetService.get_bywhere_ac_printsets(condition);
		}
		catch(Exception e)
		{
			return null;
		}         
	}
	public HashMap get_bywhere_ac_printsets(HashMap params)
	{
		try
		{
			String condition="iprint="+params.get("iprint").toString();
			HashMap printdata=new HashMap();
			List<HashMap> sqllist=this.iAcPrintSetService.get_bywhere_ac_printsets(condition);
			int bodyrow=0;
			List<HashMap<Object,Object>> bodylist = new ArrayList<HashMap<Object,Object>>();
			for (HashMap sql : sqllist) 
			{
				String sqlstr=sql.get("csql").toString();
				if (params.containsKey("printparams"))
				{
					List<HashMap> printparams=(List<HashMap>)params.get("printparams");
					for (HashMap printparam : printparams) 
					{
						sqlstr=sqlstr.replace(printparam.get("name").toString(), printparam.get("value").toString());
					}
				}
				String condition2="iprints="+sql.get("iid").toString();
				if (sql.get("bhead").equals(true))
				{
					HashMap head=this.iAcConsultService.getTestSql(sqlstr);
					printdata.put("head",head);
					printdata.put("headclm",get_bywhere_ac_printclm(condition2));
				}
				else
				{
					HashMap body=this.iAcConsultService.getTestSql(sqlstr);
					bodylist.add(body);
					if (!printdata.containsKey("body"))
					{
						printdata.put("body", bodylist);
					}
					printdata.put("bodyclm"+String.valueOf(bodyrow),get_bywhere_ac_printclm(condition2));
					bodyrow++;
				}
			}
			return printdata;
		}
		catch(Exception e)
		{
			return null;
		}         
	}
	public String add_ac_printsets(HashMap vo_ac_printsets)
	{
		String result = "sucess";
		try
		{
			Object resultObj = this.iAcPrintSetService.add_ac_printsets(vo_ac_printsets);
			result = resultObj.toString();
		}
		catch(Exception e)
		{
			result = "fail";
		}         
		return result;
	}
	public String update_ac_printsets(HashMap vo_ac_printsets)
	{
		String result = "sucess";
		try
		{
			int count = this.iAcPrintSetService.update_ac_printsets(vo_ac_printsets);
			if(count!=1)
			{
				result = "fail";
			}
		}
		catch(Exception e)
		{
			result = "fail";
		}
		return result;
	}
	public String delete_bywhere_ac_printsets(String condition)
	{
		String result = "sucess";
		try
		{
			int count = this.iAcPrintSetService.delete_bywhere_ac_printsets(condition);
			if(count!=1)
			{
				result = "fail";
			}
		}
		catch(Exception e)
		{
			result = "fail";
		}
		return result;
	}

	/**ac_printclm表操作*/
	public List<HashMap> get_bywhere_ac_printclm(String condition)
	{
		try
		{
			List<HashMap> listmap=this.iAcPrintSetService.get_bywhere_ac_printclm(condition);
			return listmap;
		}
		catch(Exception e)
		{
			return null;
		}         
	}
	public String add_ac_printclm(HashMap vo_ac_printclm)
	{
		String result = "sucess";
		try
		{
			Object resultObj = this.iAcPrintSetService.add_ac_printclm(vo_ac_printclm);
			result = resultObj.toString();
		}
		catch(Exception e)
		{
			result = "fail";
		}         
		return result;
	}
	public String update_ac_printclm(HashMap vo_ac_printclm)
	{
		String result = "sucess";
		try
		{
			int count = this.iAcPrintSetService.update_ac_printclm(vo_ac_printclm);
			if(count!=1)
			{
				result = "fail";
			}
		}
		catch(Exception e)
		{
			result = "fail";
		}
		return result;
	}
	public String delete_bywhere_ac_printclm(String condition)
	{
		String result = "sucess";
		try
		{
			int count = this.iAcPrintSetService.delete_bywhere_ac_printclm(condition);
			if(count!=1)
			{
				result = "fail";
			}
		}
		catch(Exception e)
		{
			result = "fail";
		}
		return result;
	}
}
