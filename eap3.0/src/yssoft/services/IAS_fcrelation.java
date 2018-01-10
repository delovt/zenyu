package yssoft.services;

import java.util.HashMap;
import java.util.List;

/**
 * 相关对象
 * @author 孙东亚
 */

public interface IAS_fcrelation {
	
	public List getAs_fcrelation_tree();
	
	public List  getAs_fcrelation(HashMap params);
	
	public void addAs_fcrelation(HashMap params);
	
	public void deleteAs_fcrelation(HashMap params);
	
	public void updateAs_fcrelation(HashMap params);
	
	public List queryTableField(String ifuncregit);
}
