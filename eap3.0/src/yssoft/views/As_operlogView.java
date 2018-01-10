package yssoft.views;

import yssoft.services.IAS_operlogService;
import yssoft.vos.as_operauthVo;

import java.util.HashMap;
import java.util.List;

/**
 * 系统日志
 * @author 孙东亚
 *
 */
public class As_operlogView {
		
	private IAS_operlogService I_As_operlog;

	public void setI_As_operlog(IAS_operlogService iAsOperlog) {
		I_As_operlog = iAsOperlog;
	}
	
	//新增日志
	public void insertLog(as_operauthVo vo){
		
		I_As_operlog.insertLog(vo);
	}
	
	//获取日志列表
	public HashMap getLogList(HashMap params){
		params.put("list",I_As_operlog.getLogList(params));
		return params;
	}
	
	//删除日志
	public void deleteLog(HashMap params){
		
		I_As_operlog.deleteLog(params);
	}
	
	/**
	 * 查询模块使用情况
	 * @return
	 */
	public List<HashMap> queryModuleNumber(HashMap paramMap)
	{
		return this.I_As_operlog.queryModuleNumber(paramMap);
	}
	
	/**
	 * 查询人员使用情况
	 * @return
	 */
	public List<HashMap> queryPersonNumber(HashMap params)
	{
		return this.I_As_operlog.queryPersonNumber(params);
	}
	
	/**
	 * 查询系统使用情况
	 * @param params
	 * @return
	 */
	public List<HashMap> querydoperateNumber(HashMap params)
	{
		return this.I_As_operlog.querydoperateNumber(params);
	}
}
