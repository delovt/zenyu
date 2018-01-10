package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IBmBudgetService;
import yssoft.vos.BmBudgetVo;

import java.util.HashMap;

public class BmBudgetImpl extends BaseDao implements IBmBudgetService {

	@Override
	public String addBudget(BmBudgetVo bm) {
		return  super.insert("bm_budget_add", bm).toString();
	}

	@Override
	public void getBudgetList() {
		super.queryForList("bm_budget_select");
	}

	@Override
	public void updateBudget(BmBudgetVo bm) {
		super.update("bm_budget_update",bm);
	}

	@Override
	public void delBudget(HashMap map) {
		super.delete("bm_budget_delete", map );
		
	}


	
	

}
