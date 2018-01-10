package yssoft.services;

import java.util.HashMap;

public interface IPrconfirmService {

	/**
	 * 查询项目令号
	 * @param citemcode 是否唯一
	 * @return 记录
	 */
	public HashMap queryPrconfirmById(HashMap paramObj);
	
	/**
	 * 修改项目令号
	 * @param paramObj
	 * @return
	 */
	public int updatePrconfirm(HashMap paramObj)throws Exception;
}
