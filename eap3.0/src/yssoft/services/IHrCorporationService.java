package yssoft.services;

import java.util.HashMap;
import java.util.List;

public interface IHrCorporationService {

	public List<HashMap> getAllCorporation() throws Exception;
	
	public int updateCorporationCcode(HashMap paramObj)throws Exception;
	
}
