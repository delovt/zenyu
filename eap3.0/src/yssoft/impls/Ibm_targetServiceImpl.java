package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.Ibm_targetService;
import yssoft.vos.BmTargetVO;

import java.util.HashMap;
import java.util.List;

public class Ibm_targetServiceImpl extends BaseDao implements Ibm_targetService {

	@Override
	public HashMap get_bm_target_byiid(int iid) {
		// TODO Auto-generated method stub
		return null;
	}

	@Override
	public List<HashMap> get_all_bm_target() {
		// TODO Auto-generated method stub
		return this.queryForList("get_all_bm_target");
	}

	@Override
	public Object add_bm_target(BmTargetVO bmTargetVO) {
		// TODO Auto-generated method stub
		return this.insert("add_bm_target", bmTargetVO);
	}

	@Override
	public Object update_bm_target(BmTargetVO bmTargetVO) {
		// TODO Auto-generated method stub
		return this.update("update_bm_target", bmTargetVO);
	}

	@Override
	public Object delete_bm_target_byiid(int iid) {
		// TODO Auto-generated method stub
		return this.delete("delete_bm_target_byiid", iid);
	}

	@Override
	public List getFieldsByTable(String tablename) {
		// TODO Auto-generated method stub
		return null;
	}

	

}
