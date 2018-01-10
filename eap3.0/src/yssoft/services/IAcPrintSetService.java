/**
 * 模块名称：IAcPrintSetService
 * 模块说明：打印设置接口类
 * 创建人：	YJ
 * 创建日期：20111019
 * 修改人：
 * 修改日期：
 * 
 */
package yssoft.services;

import yssoft.vos.AcPrintSetVO;

import java.util.HashMap;
import java.util.List;

public interface IAcPrintSetService {
	/**
	 * 函数名称：getMenuList
	 * 函数说明：获取菜单列表
	 * 函数参数：无
	 * 函数返回：List
	 * 创建人：	YJ
	 * 创建日期：20110810
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public List<HashMap> getMenuList();
	
	
	/**
	 * 函数名称：getDataByIfuncregedit
	 * 函数说明：通过注册功能内码获取列表信息
	 * 函数参数：ifuncregedit(注册功能内码)
	 * 函数返回：List
	 * 创建人：	YJ
	 * 创建日期：20110810
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public List getDataByIfuncregedit(int condition);
	
	/**
	 * 函数名称：addAcPrintSet
	 * 函数说明：增加打印设表信息
	 * 函数参数：acprintsetvo（打印设置实体对象）
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110810
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public Object addAcPrintSet(AcPrintSetVO acprintsetvo) throws Exception;
	
	/**
	 * 函数名称：updateAcPrintSet
	 * 函数说明：更新打印设置表信息
	 * 函数参数：acprintsetvo（打印设置实体对象）
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110810
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public Object updateAcPrintSet(AcPrintSetVO acprintsetvo) throws Exception;
	
	/**
	 * 函数名称：deleteAcPrintSet
	 * 函数说明：删除打印设置信息
	 * 函数参数：iid（主键）
	 * 函数返回：Object
	 * 创建人：	YJ
	 * 创建日期：20110810
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public Object deleteAcPrintSet(int iid) throws Exception;
	
	/**ac_printsets表操作*/
    public List<HashMap> get_bywhere_ac_printsets(String condition) throws Exception;
    public int add_ac_printsets(HashMap vo_ac_printsets) throws Exception;
    public int update_ac_printsets(HashMap vo_ac_printsets) throws Exception;
    public int delete_bywhere_ac_printsets(String condition) throws Exception;
    
    /**ac_printclm表操作*/
    public List<HashMap> get_bywhere_ac_printclm(String condition) throws Exception;
    public int add_ac_printclm(HashMap vo_ac_printclm) throws Exception;
    public int update_ac_printclm(HashMap vo_ac_printclm) throws Exception;
    public int delete_bywhere_ac_printclm(String condition) throws Exception;
}
