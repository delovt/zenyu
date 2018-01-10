package yssoft.services;

import java.util.HashMap;
import java.util.List;

/**
 * 系统选项
 * @author SDY
 *
 */
public interface IAs_OptionsService {
		
	public List getOptionsByCclass(HashMap map); 
	
	public void updateOptions(HashMap map);
	
	public String getSysParamterByiid(int iid);
	
	public List getOptionAc();
	public int InsertCommSessionid(String sql);
	
}
