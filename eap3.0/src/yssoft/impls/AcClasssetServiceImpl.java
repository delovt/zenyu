package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IAcClasssetService;

import java.util.HashMap;
import java.util.List;

public class AcClasssetServiceImpl extends BaseDao implements
		IAcClasssetService {

	@Override
	public List<HashMap> getListcd(HashMap paramObj) {
		// TODO Auto-generated method stub
		return this.queryForList("get_classlist",paramObj);
	}

	@Override
	public List<HashMap> getListcd2(HashMap paramObj) {
		// TODO Auto-generated method stub
		
		return this.queryForList("get_classviewlist",paramObj);
		
	}

	@Override
	public List<HashMap> getDatadicSql(String iid) {
		// TODO Auto-generated method stub
		return this.queryForList("get_DatadicSql",iid);
	}


}
