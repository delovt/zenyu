package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IBasisFileService;

import java.util.HashMap;
import java.util.List;

public class BasisFileImpl extends BaseDao implements IBasisFileService {

	@Override
	public List<HashMap> getRdTypeList() throws Exception {
		return this.queryForList("getRdTypeList");
	}

	@Override
	public List<HashMap> getWareHouseList() throws Exception {
		return this.queryForList("getWareHouseList");
	}

	@Override
	public int updateRdTypeCcode(HashMap paramObj) throws Exception {
		return this.update("updateRdTypeCcode",paramObj);
	}

	@Override
	public int updateWareHouseCcode(HashMap paramObj) throws Exception {
		return this.update("updateWareHouseCcode",paramObj);
	}

	@Override
	public int updateRdTypeIrdflag(HashMap paramObj) throws Exception {
		return this.update("updateRdTypeIrdflag",paramObj);
	}

}
