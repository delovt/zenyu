package yssoft.services;

import java.util.HashMap;
import java.util.List;

public interface IAs_warnsetService {
	public List<HashMap> getWarnset() throws Exception;
	
	public int updateWarnsetCcode(HashMap paramObj)throws Exception;
}
