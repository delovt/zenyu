/**
 * 模块名称：FuncregeditServiceImpl
 * 模块说明：业务数据访问类
 * 创建人：	YJ
 * 创建日期：20110810
 * 修改人：
 * 修改日期：
 * 
 */

package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IHandleService;
import yssoft.vos.AsFuncregeditVO;

import java.util.HashMap;
import java.util.List;

public class FuncregeditServiceImpl extends BaseDao implements IHandleService {

	public List getTreeMenuByTableName(String tablename){
		return null;
		
	} 
	
	public List<HashMap> getMenuList(){
		//功能注册树调用此方法
		List<HashMap> list = this.queryForList("DatadictionaryDest.getTreeMenu");	
		return list;
	}
	
	//读取表结构
	public List getFieldsByTableName(String tablename){
		return null;
	}
	
	/**
	 * 函数名称：getFieldsByTable
	 * 函数说明：通过表名获取不为空的字段列表
	 * 函数参数：tablename（表的名称）
	 * 函数返回：List
	 * 创建人：	YJ
	 * 创建日期：20110810
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public List getFieldsByTable(String tablename){
		List<HashMap> list = this.queryForList("get_notnull_fields",tablename);
		return list;
	}
	
	/**
	 * 函数名称：addFuncrededit
	 * 函数说明：增加功能注册表信息
	 * 函数参数：AsFuncregeditVO（功能注册表实体对象）
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110810
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public Object addFuncrededit(AsFuncregeditVO asFuncregeditVO) throws Exception{
		Object obj = this.insert("add_Funcregedit",asFuncregeditVO);
		return obj;
	}
	
	/**
	 * 函数名称：updateFuncrededit
	 * 函数说明：更新功能注册表信息
	 * 函数参数：AsFuncregeditVO（功能注册表实体对象）
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110810
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public Object updateFuncrededit(AsFuncregeditVO asFuncregeditVO) throws Exception{
		Object obj = this.update("update_Funcregedit",asFuncregeditVO);
		return obj;
	}
	
	/**
	 * 函数名称：deleteFuncrededit
	 * 函数说明：删除功能注册表信息
	 * 函数参数：iid（主键）
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110810
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public Object deleteFuncrededit(int iid) throws Exception{
		Object obj = this.delete("delete_Funcregedit",iid);
		return obj;
	}
	
	/*cody by liu lei begin*/
	/**
	 * 函数名称：get_cname_FuncregeditByID
	 * 函数说明：根据主键获得名称
	 * 函数参数：iid（主键）
	 * 函数返回：String
	 * 创建人：	刘磊
	 * 创建日期：20110830
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public String get_cname_FuncregeditByID(int iid)
	{
		String str=null;
		try
		{
          str=this.queryForObject("get_cname_FuncregeditByID",iid).toString();
		}
		catch(Exception e)
		{
			
		}
	   return str;
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
	public HashMap getSingleFuncregeditByID(int iid)
	{
		HashMap map = (HashMap) this.queryForObject("get_single_funcregedit",iid);
	   return map;
    }
	
	//add by zhong_jing 查询所有主表
	public List getAllFuncregeditBybdataauth1()
	{
		return this.queryForList("get_all_funcregedit_bdataauth1");
	}

	/*cody by liu lei begin*/
	/**
	 * 函数名称：get_cparameter_FuncregeditByID
	 * 函数说明：根据主键获得参数
	 * 函数参数：iid（主键）
	 * 函数返回：String
	 * 创建人：	刘磊
	 * 创建日期：20111010
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public String get_cparameter_FuncregeditByID(int iid)
	{
	   return this.queryForObject("get_cparameter_FuncregeditByID",iid).toString();
    }
	/*cody by liu lei end*/

}
