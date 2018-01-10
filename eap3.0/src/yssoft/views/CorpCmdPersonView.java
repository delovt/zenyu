package yssoft.views;

import yssoft.services.ICorpCmdPersonService;
import yssoft.utils.ToXMLUtil;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class CorpCmdPersonView {

	private ICorpCmdPersonService iCorpCmdPersonService = null;


	public String getCmdPersonAndCorp() throws Exception {
		List d = this.iCorpCmdPersonService.getCmdPersonAndCorp();
		if (d.size() == 0) {
			return null;
		} else {
			return ToXMLUtil.createTree(d, "iid", "ipid", "-1");
		}
	}
	
	public String getAllCorpWithCmdPerson(int iid) throws Exception {
		List d = this.iCorpCmdPersonService.getAllCorpWithCmdPerson(iid);
		if (d.size() == 0) {
			return null;
		} else {
			return ToXMLUtil.createTree(d, "iid", "ipid", "-1");
		}
	}
	
	public void refPersons(ArrayList<String> al) throws Exception{
		String iperson = al.get(0);
		this.delPersons(Integer.parseInt(iperson));
		for(int i=1;i<al.size();i++){
			HashMap param=new HashMap();
			param.put("iperson", iperson);
			param.put("icorp", al.get(i));
			
			this.addPersons(param);
		}
	}
	
	public String delPersons(int iperson)
	{
		String result="success";
		try {
			int count = this.iCorpCmdPersonService.delPsersons(iperson);
			if(count==0)
			{
				result="fail";
			}
		} catch (Exception e) {
			e.printStackTrace();
			result ="fail";
		}
		return result;
	}
	
	public void addPersons(HashMap paramObj) throws Exception
	{
		this.iCorpCmdPersonService.addPersons(paramObj);
		
/*		try {
			return this.iCorpCmdPersonService.addPersons(paramObj).toString();
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}*/
	}

	public void setiCorpCmdPersonService(ICorpCmdPersonService iCorpCmdPersonService) {
		this.iCorpCmdPersonService = iCorpCmdPersonService;
	}
	
	
}
