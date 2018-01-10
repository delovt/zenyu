/**    
 *
 * 文1件名：AcConsultImpl.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-8-12    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IAS_operlogService;
import yssoft.vos.as_operauthVo;

import java.util.HashMap;
import java.util.List;

/**    
 *     
 *  系统日志
 *  孙东亚   
 */
public class As_operlogImpl extends BaseDao implements IAS_operlogService {

	/**
	 * 
	 */
	private static final long serialVersionUID = -8071342557983326052L;

	@Override
	public void deleteLog(HashMap params) {
		this.delete("delete_log",params);
	}

	@Override
	public List getLogList(HashMap params) {
		return this.queryForList("select_log", params);
		
	}

	@Override
	public void insertLog(as_operauthVo vo) {
		this.insert("add_log", vo);
	}
	
	@Override
	public List<HashMap> queryModuleNumber(HashMap paramMap) {
		return this.queryForList("select_module_number",paramMap);
	}
	
	@Override
	public List<HashMap> queryPersonNumber(HashMap params) {
		return this.queryForList("select_person_number",params);
	}
	
	
	public List<HashMap> querydoperateNumber(HashMap params) {
		return this.queryForList("select_doperate_number",params);
	}
 
}