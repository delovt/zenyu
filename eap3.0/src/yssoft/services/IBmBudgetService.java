package yssoft.services;

import yssoft.vos.BmBudgetVo;

import java.util.HashMap;

/**
 * 预算主表
 * @author sdy
 *
 */
public interface IBmBudgetService {
	
	public String addBudget(BmBudgetVo bm);
	public void updateBudget(BmBudgetVo bm);
	public void getBudgetList();
	public void delBudget(HashMap map);
	
	
}
