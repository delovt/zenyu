package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IAS_fcrelation;

import java.util.HashMap;
import java.util.List;

public class AS_fcrelationImpl extends BaseDao implements IAS_fcrelation {

	@Override
	public void addAs_fcrelation(HashMap params) {
		 
		this.insert("add_as_fcrelation",params);
	}

	@Override
	public void deleteAs_fcrelation(HashMap params) {
		this.delete("delete_as_fcrelation",params.get("iid").toString());
	}

	@Override
	public List getAs_fcrelation(HashMap params) {
		return this.queryForList("get_as_fcrelation_list", params);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void updateAs_fcrelation(HashMap params) {
		this.update("update_as_fcrelation",params);
	}

	@Override
	public List getAs_fcrelation_tree() {
		return this.queryForList("get_ac_fcrelation_tree");
	}
	
	public List queryTableField(String ifuncregit){
		return this.queryForList("get_cfield_by_ifuncregedit",ifuncregit);
	}
	
}
