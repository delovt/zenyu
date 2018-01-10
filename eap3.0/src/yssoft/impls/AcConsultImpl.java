/**    
 *
 * 文件名：AcConsultImpl.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-8-12    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IAcConsultService;
import yssoft.vos.AcConsultclmVo;
import yssoft.vos.AcConsultsetVo;

import java.util.HashMap;
import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：AcConsultImpl    
 * 类描述：    
 * 创建人：刘磊 
 * 创建时间：2011-2011-8-12 上午11:18:23        
 *     
 */
public class AcConsultImpl extends BaseDao implements IAcConsultService {

	/**
	 *     
	 * @see yssoft.services.IAcConsultService#addAcConsultset(yssoft.vos.AcConsultsetVo) 
	 *   
	 */
	public Object addAcConsultset(AcConsultsetVo acConsultsetVo)
	{
		return this.insert("addAcConsultset",acConsultsetVo);
	}

	/**
	 *     
	 * @see yssoft.services.IAcConsultService#deleteAcConsultsetByID(int) 
	 *   
	 */
	
	public boolean deleteAcConsultsetByID(int iid) throws Exception {
		// TODO Auto-generated method stub
		return this.delete("deleteAcConsultsetByID",iid)>0;
	}

	/**
	 *     
	 * @see yssoft.services.IAcConsultService#getAcConsultsetByID(int) 
	 *   
	 */
	
	public List<AcConsultsetVo> getAcConsultsetByID(int iid) {
		// TODO Auto-generated method stub
		return this.queryForList("getAcConsultsetByID",iid);
	}
	public String get_cname_AcConsultsetByID(int iid)	{
		return this.queryForObject("get_cname_AcConsultsetByID",iid).toString();
	}
	public List<HashMap> get_bdataauth_AcConsultsetByID(int iid)	{
		return this.queryForList("get_bdataauth_AcConsultsetByID",iid);
	}
	public List<AcConsultsetVo> getAcConsultsetByCCode(String ccode) {
		// TODO Auto-generated method stub
		return this.queryForList("getAcConsultsetByCCode",ccode);
	}
	/**
	 *     
	 * @see yssoft.services.IAcConsultService#getAllAcConsultset() 
	 *   
	 */
	
	public List<HashMap> getAllAcConsultset() {
		// TODO Auto-generated method stub
		return this.queryForList("getAllAcConsultset");
	}

	/**
	 *     
	 * @see yssoft.services.IAcConsultService#updateAcConsultset(yssoft.vos.AcConsultsetVo) 
	 *   
	 */
	
	public boolean updateAcConsultset(AcConsultsetVo acConsultsetVo)
			throws Exception {
		// TODO Auto-generated method stub
		return this.update("updateAcConsultset",acConsultsetVo)>0;
	}
	//-------------------------------------------------主子表上下分隔-------------------------------------------------//
	/**
	 *     
	 * @see yssoft.services.IAcConsultService#getAcConsultclmByID(int) 
	 *   
	 */
	
	public List getAcConsultclmByID(int iid) {
		// TODO Auto-generated method stub
		return this.queryForList("getAcConsultclmByID",iid);
	}
	
	@SuppressWarnings("unchecked")
	public List<AcConsultclmVo> getAcConsultclmByPID(int iconsult) {
		// TODO Auto-generated method stub
		return this.queryForList("getAcConsultclmByPID",iconsult);
	}
	public List<AcConsultclmVo> getAcConsultclmByCCode(String ccode){
		// TODO Auto-generated method stub
		return this.queryForList("getAcConsultclmByCCode",ccode);
	}
	/**
	 *     
	 * @see yssoft.services.IAcConsultService#addAcConsultclm(yssoft.vos.AcConsultclmVo) 
	 *   
	 */
	
	public Object addAcConsultclm(AcConsultclmVo acConsultclmVo)
	{
		return this.insert("addAcConsultclm",acConsultclmVo);
	}

	/**
	 *     
	 * @see yssoft.services.IAcConsultService#updateAcConsultclm(yssoft.vos.AcConsultclmVo) 
	 *   
	 */
	
	public boolean updateAcConsultclm(AcConsultclmVo acConsultclmVo)
			throws Exception {
		// TODO Auto-generated method stub
		return this.update("updateAcConsultclm",acConsultclmVo)>0;
	}

	/**
	 *     
	 * @see yssoft.services.IAcConsultService#deleteAcConsultclmByPID(int) 
	 *   
	 */
	
	public boolean deleteAcConsultclmByPID(int iconsult) throws Exception {
		// TODO Auto-generated method stub
		return this.delete("deleteAcConsultclmByPID",iconsult)>0;
	}

	/**
	 *     
	 * @see yssoft.services.IAcConsultService#getTestSql(String) 
	 *   
	 */
	public HashMap<String,Object> getTestSql(String sqlstr) throws Exception {
		// TODO Auto-generated method stub
		HashMap<String,Object> map=new HashMap<String,Object>();
		map.put("success", this.queryForList("getTestSql",sqlstr));
		return map;
	}
	
	/**
	 *     
	 * @see yssoft.services.IAcConsultService#getTestTreeSql(String) 
	 *   
	 */
	public List<HashMap> getTestTreeSql(String sqlstr) throws Exception {
		// TODO Auto-generated method stub
		return this.queryForList("getTestSql",sqlstr);
	}

	@Override
	public String get_cname_AcConsultsetByID_Relevance_Object(int iid)
			throws Exception {
		return this.queryForObject("get_cname_AcConsultsetByID_Relevance_Object",iid).toString();
	}

}