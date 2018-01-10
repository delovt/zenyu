package yssoft.services;
/**    
 * 文件名：IAcConsultService.java    
 *    
 * 版本信息：    
 * 日期：2011-8-12    
 * 版权所有    
 *    
 */

import yssoft.vos.AcConsultclmVo;
import yssoft.vos.AcConsultsetVo;

import java.util.HashMap;
import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：IAcConsultService     
 * 类描述：菜单接口
 * 创建人：刘磊  
 * 创建时间：2011-8-12 下午10:24:00    
 * 修改人：刘磊   
 * 修改时间：2011-8-12 下午10:24:00    
 * 修改备注：    
 * @version     
 *     
 */
public interface IAcConsultService {
	/**
	 * 
	 * getAllAcConsultset(获得参照配置主表所有记录)    
	 * @param
	 * @return 参照配置主表所有记录
	 * @since  CodingExample　Ver(编码范例查看) 1.1
	 */
	public List<HashMap> getAllAcConsultset();
	
	/**
	 * getAcConsultsetByID(根据用户Id 来获取参照配置主表记录)
	 * @param  iid
	 * @return 单条参照配置主表记录   
	 * @since  CodingExample　Ver(编码范例查看) 1.1 
	 *
	 */
	public List<AcConsultsetVo> getAcConsultsetByID(int iid);
	
	public String get_cname_AcConsultsetByID(int iid) throws Exception;
	
	public List<HashMap> get_bdataauth_AcConsultsetByID(int iid) throws Exception;
	
	public List<AcConsultsetVo> getAcConsultsetByCCode(String ccode);
	
	/**
	 * addAcConsultset(增加参照配置主表记录)
	 * @param  iid
	 * @return 主表主键   
	 * @since  CodingExample　Ver(编码范例查看) 1.1 
	 *
	 */
	public Object addAcConsultset(AcConsultsetVo acConsultsetVo) throws Exception;
	
	/**
	 * updateAcConsultset(修改参照配置主表记录)
	 * @param  iid
	 * @return 成功/失败   
	 * @since  CodingExample　Ver(编码范例查看) 1.1 
	 *
	 */
	public boolean updateAcConsultset(AcConsultsetVo acConsultsetVo) throws Exception;
	
	/**
	 * 
	 * deleteAcConsultsetByID(删除参照配置主表记录)    
	 * @param   iid    
	 * @return 成功/失败   
	 * @since  CodingExample　Ver(编码范例查看) 1.1
	 */
	public boolean deleteAcConsultsetByID(int iid) throws Exception;
	//-------------------------------------------------主子表上下分隔-------------------------------------------------//
	/**
	 * 
	 * getAcConsultclmByPID(获得参照配置主表关联子表所有记录)    
	 * @param
	 * @return 参照配置子表所有记录
	 * @since  CodingExample　Ver(编码范例查看) 1.1
	 */
	public List<AcConsultclmVo> getAcConsultclmByPID(int iconsult);
	
	/**
	 * 
	 * getAcConsultclmByCCode(获得参照配置主表关联子表所有记录)    
	 * @param
	 * @return 参照配置子表所有记录
	 * @since  CodingExample　Ver(编码范例查看) 1.1
	 */
	public List<AcConsultclmVo> getAcConsultclmByCCode(String ccode);
	
	/**
	 * getAcConsultclmByID(根据用户Id 来获取参照配置子表记录)
	 * @param  iid
	 * @return 单条参照配置子表表记录   
	 * @since  CodingExample　Ver(编码范例查看) 1.1 
	 *
	 */
	public List getAcConsultclmByID(int iid);
	
	/**
	 * addAcConsultclm(增加参照配置子表记录)
	 * @param  iid
	 * @return 成功/失败   
	 * @since  CodingExample　Ver(编码范例查看) 1.1 
	 *
	 */
	public Object addAcConsultclm(AcConsultclmVo acConsultclmVo) throws Exception;
	
	/**
	 * updateAcConsultclm(修改参照配置子表记录)
	 * @param  iid
	 * @return 子表主键   
	 * @since  CodingExample　Ver(编码范例查看) 1.1 
	 *
	 */
	public boolean updateAcConsultclm(AcConsultclmVo acConsultclmVo) throws Exception;
	
	/**
	 * 
	 * deleteAcConsultclmByPID(删除参照配置主表关联子表记录)    
	 * @param   iconsult   
	 * @return 成功/失败   
	 * @since  CodingExample　Ver(编码范例查看) 1.1
	 */
	public boolean deleteAcConsultclmByPID(int iconsult) throws Exception;
	
	/**
	 * 
	 * getTestSql(测试SQL串)    
	 * @param   SQL串   
	 * @return 错误信息/HashMap
	 * @since  CodingExample　Ver(编码范例查看) 1.1
	 */
	public HashMap<String,Object> getTestSql(String sqlstr) throws Exception;
	
	/**
	 * 
	 * getTestTreeSql(测试SQL串)    
	 * @param   SQL串   
	 * @return 错误信息/HashMap
	 * @since  CodingExample　Ver(编码范例查看) 1.1
	 */
	public List<HashMap> getTestTreeSql(String sqlstr) throws Exception;
	
	
	/**
	 * 相关对象 初始化转化 注册表单内 到 as_funcregedit 查
	 * @param iid
	 * @return
	 */
	public String get_cname_AcConsultsetByID_Relevance_Object(int iid) throws Exception;
	
}