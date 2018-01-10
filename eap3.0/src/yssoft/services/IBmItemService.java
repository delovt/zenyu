package yssoft.services;

import yssoft.vos.BmItemVo;

import java.util.List;

/**
 * 预算项目
 * @author sdy
 *
 */
public interface IBmItemService {

	public List  getBmItemList();
	
	public String addBmItem(BmItemVo item);
	
	public void updateBmItem(BmItemVo item);
	
	public void delBmItem(String iid);
	
	public List getChildNodeItem(String ipid);
	
	public String get_cname_bmitem(int iid);
	
}
