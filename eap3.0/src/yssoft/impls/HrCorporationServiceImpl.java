package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IHrCorporationService;

import java.util.HashMap;
import java.util.List;

public class HrCorporationServiceImpl extends BaseDao implements
		IHrCorporationService {

	/**
	 * 
	 */
	private static final long serialVersionUID = 7196026069117448474L;


	@Override
	public List<HashMap> getAllCorporation() throws Exception {
		return this.queryForList("get_corporation");
	}

	public int updateCorporationCcode(HashMap paramObj)throws Exception
	{
		return this.update("update_corporationCcode",paramObj);
	}
}
