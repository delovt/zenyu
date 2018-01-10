package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.ICorpCmdPersonService;

import java.util.HashMap;
import java.util.List;

public class CorpCmdPersonServiceImpl extends BaseDao implements ICorpCmdPersonService {

	@Override
	public List<HashMap> getCmdPersonAndCorp() throws Exception {
		return this.queryForList("getCmdPersonAndCorp");
	}

	@Override
	public List<HashMap> getAllCorpWithCmdPerson(int iid) throws Exception {
		return this.queryForList("getAllCorpWithCmdPerson",iid);
	}

	@Override
	public Object addPersons(HashMap paramObj) throws Exception {
		return this.insert("addPersons", paramObj);
	}

	@Override
	public int delPsersons(int iperson) throws Exception {
		return this.delete("delPsersons",iperson);
	}

	@Override
	public int resetPassword(HashMap paramObj) throws Exception {
		return this.update("resetPassword",paramObj);
	}

}
