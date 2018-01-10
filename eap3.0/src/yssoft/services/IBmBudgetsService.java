package yssoft.services;

import yssoft.vos.BmBudgetsVo;

import java.util.HashMap;
import java.util.List;

/**
 * 预算子表
 * @author sdy
 *
 */
public interface IBmBudgetsService {
	
	public List  getBudgetsList(HashMap param);
	public void addBudgets(BmBudgetsVo bm);
	public void updateBudgets(BmBudgetsVo bm);
	public void deleteBudgets(int ibudget);
}
