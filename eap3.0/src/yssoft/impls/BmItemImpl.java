package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IBmItemService;
import yssoft.vos.BmItemVo;

import java.util.List;

public class BmItemImpl extends BaseDao implements IBmItemService{

	@Override
	public String addBmItem(BmItemVo item) {
		return super.insert("bm_item_add", item).toString();
	}

	@Override
	public void delBmItem(String iid) {
		super.delete("bm_item_del", iid);
	}

	@Override
	public List getBmItemList() {
		List list = super.queryForList("bm_item_select");
		return list;
	}

	@Override
	public void updateBmItem(BmItemVo item) {
		super.update("bm_item_update", item);
	}

	@SuppressWarnings("unchecked")
	@Override
	public List getChildNodeItem(String _ipid) {
		int ipid = Integer.parseInt(_ipid);
		List list = super.queryForList("bm_item_childnode",ipid);
		return list;
	}
	
	@Override
	public String get_cname_bmitem(int iid) {
		return queryForObject("bm_item_getcname",iid+"")+"";
	}
	
}
