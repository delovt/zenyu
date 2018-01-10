package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IAs_warnsetService;

import java.util.HashMap;
import java.util.List;

public class As_warnsetImpl extends BaseDao implements IAs_warnsetService{

	public List<HashMap> getWarnset() throws Exception {
		return this.queryForList("get_warnset");
	}

	@Override
	public int updateWarnsetCcode(HashMap paramObj) throws Exception {
		return this.update("update_warnsetCcode",paramObj);
	}

}
