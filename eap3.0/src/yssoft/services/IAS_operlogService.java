package yssoft.services;

import yssoft.vos.as_operauthVo;

import java.util.HashMap;
import java.util.List;

/**
 * 
 * 系统日志
 * @author 孙东亚
 *
 */
public interface IAS_operlogService {
	
		//新增日志
		public void insertLog(as_operauthVo vo);
		
		//获取日志列表
		public List getLogList(HashMap params);

		public void deleteLog(HashMap params);
		
		/**
		 * 查询模块使用情况
		 * @return
		 */
		public List<HashMap> queryModuleNumber(HashMap paramMap);
		
		/**
		 * 查询人员使用情况
		 * @return
		 */
		public List<HashMap> queryPersonNumber(HashMap params);
		
		/**
		 * 查询系统使用情况
		 * @param params
		 * @return
		 */
		public List<HashMap> querydoperateNumber(HashMap params) ;

}
