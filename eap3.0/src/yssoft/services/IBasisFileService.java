package yssoft.services;

import java.util.HashMap;
import java.util.List;

public interface IBasisFileService {	
	
	/**
	 * 仓库档案
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> getWareHouseList() throws Exception;
	public int updateWareHouseCcode(HashMap paramObj)throws Exception;
	
	/**
	 * 收发类别档案
	 * @return
	 * @throws Exception
	 */
	public List<HashMap> getRdTypeList() throws Exception;
	public int updateRdTypeCcode(HashMap paramObj)throws Exception;
	public int updateRdTypeIrdflag(HashMap paramObj)throws Exception;
}
