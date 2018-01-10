package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IBmBudgetsService;
import yssoft.vos.BmBudgetsVo;

import java.util.HashMap;
import java.util.List;

public class BmBudgetsImpl extends BaseDao implements IBmBudgetsService{

	@Override
	public void addBudgets(BmBudgetsVo bm) {
		super.insert("bm_budgets_add", bm);
	}

	@Override
	public void updateBudgets(BmBudgetsVo bm) {
		super.update("bm_budgets_update", bm);
	}

	@Override
	public List  getBudgetsList(HashMap param) {
		return super.queryForList("bm_budgets_select",param);	
	}

	@Override
	public void deleteBudgets(int ibudget) {
		super.delete("bm_budgets_delete",ibudget);
	}
	
}
