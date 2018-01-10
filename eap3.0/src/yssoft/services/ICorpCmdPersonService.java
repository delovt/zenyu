package yssoft.services;

import java.util.HashMap;
import java.util.List;

public interface ICorpCmdPersonService {

	public List<HashMap> getCmdPersonAndCorp() throws Exception;
	
	public List<HashMap> getAllCorpWithCmdPerson(int iid) throws Exception;
	
	public int delPsersons(int iperson)throws Exception;
	
	public Object addPersons(HashMap paramObj)throws Exception;
	
	public int resetPassword(HashMap paramObj)throws Exception;
}
