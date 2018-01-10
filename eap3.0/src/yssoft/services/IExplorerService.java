package yssoft.services;

import java.util.HashMap;
import java.util.List;

public interface IExplorerService {
	public List<?> getDesktopList(HashMap<?, ?> params);
	public List<?> getDetailDesktopList(HashMap<?, ?> params);
	public int insertDesktopItem(HashMap<?, ?> params);
	public void deleteDesktopItem(HashMap<?, ?> params);
	public void updateDesktopItem(HashMap<?, ?> params);
	
	
	public int insertDesktopsItem(HashMap<?, ?> params);
	public void deleteDesktopsItem(HashMap<?, ?> params);
	public void updateDesktopsItem(HashMap<?, ?> params);
	
}
