package yssoft.views;

import yssoft.services.IHrCorporationService;
import yssoft.utils.ToXMLUtil;

import java.util.HashMap;
import java.util.List;

public class HrCorporationView {
	private IHrCorporationService iHrCorporationService = null;

	public void setiHrCorporationService(
			IHrCorporationService iHrCorporationService) {
		this.iHrCorporationService = iHrCorporationService;
	}

	public String getAllCorporation() throws Exception {
		List d = this.iHrCorporationService.getAllCorporation();
		if (d.size() == 0) {
			return null;
		} else {
			return ToXMLUtil.createTree(d, "iid", "ipid", "-1");
		}
	}
	
	public String updateCorporationCcode(HashMap paramObj)
	{
		String result="success";
		try {
			int count =this.iHrCorporationService.updateCorporationCcode(paramObj);
			if(count==0)
			{
				result ="fail";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

}
