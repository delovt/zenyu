package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.Ias_smssetService;
import yssoft.vos.AsSmssetVO;

import java.util.HashMap;
import java.util.List;

public class Ias_smssetServiceImpl extends BaseDao implements Ias_smssetService {

	@Override
	public HashMap get_as_smsset_byiid(int iid) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<HashMap> get_all_as_smsset() {
		// TODO Auto-generated method stub
		return this.queryForList("get_all_as_smsset");
	}

	@Override
	public Object add_as_smsset(AsSmssetVO asSmssetVO) {
		// TODO Auto-generated method stub
		return this.insert("add_as_smsset", asSmssetVO);
	}

	@Override
	public Object update_as_smsset(AsSmssetVO asSmssetVO) {
		// TODO Auto-generated method stub
		return this.update("update_as_smsset", asSmssetVO);
	}

	@Override
	public Object delete_as_smsset_byiid(int iid) {
		// TODO Auto-generated method stub
		return this.delete("delete_as_smsset_byiid", iid);
	}

	@Override
	public List getFieldsByTable(String tablename) {
		// TODO Auto-generated method stub
		return null;
	}

	

}
