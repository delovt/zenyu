package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IExplorerService;

import java.util.HashMap;
import java.util.List;

public class ExplorerImpl extends BaseDao implements IExplorerService {

	@Override
	public List<?> getDesktopList(HashMap<?, ?> params) {
		// TODO Auto-generated method stub
		return this.queryForList("explorer.getDesktopList", params);
	}

	@Override
	public List<?> getDetailDesktopList(HashMap<?, ?> params) {
		// TODO Auto-generated method stub
		return this.queryForList("explorer.getDetailDesktopList", params);
	}

	@Override
	public int insertDesktopItem(HashMap<?, ?> params) {
		// TODO Auto-generated method stub
		return (Integer)this.insert("explorer.insertDesktopItem", params);
	}

	@Override
	public void deleteDesktopItem(HashMap<?, ?> params) {
		// TODO Auto-generated method stub
		this.delete("explorer.deleteDesktopItem", params);
	}

	@Override
	public void updateDesktopItem(HashMap<?, ?> params) {
		// TODO Auto-generated method stub
		this.update("explorer.updateDesktopItem", params);
	}

	@Override
	public int insertDesktopsItem(HashMap<?, ?> params) {
		// TODO Auto-generated method stub
		return (Integer)this.insert("explorer.insertDesktopsItem", params);
	}

	@Override
	public void deleteDesktopsItem(HashMap<?, ?> params) {
		// TODO Auto-generated method stub
		this.delete("explorer.deleteDesktopsItem", params);
	}

	@Override
	public void updateDesktopsItem(HashMap<?, ?> params) {
		// TODO Auto-generated method stub
		this.update("explorer.updateDesktopsItem", params);
	}

}
