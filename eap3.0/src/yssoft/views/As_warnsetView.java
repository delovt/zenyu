package yssoft.views;

import yssoft.services.IAs_warnsetService;
import yssoft.utils.ToXMLUtil;

import java.util.HashMap;
import java.util.List;

public class As_warnsetView {
	private IAs_warnsetService iAs_warnsetService = null;

	public void setiAs_warnsetService(IAs_warnsetService iAsWarnsetService) {
		iAs_warnsetService = iAsWarnsetService;
	}
	
	public String getWarnset() throws Exception{
		List d = this.iAs_warnsetService.getWarnset();
		if (d.size() == 0) {
			return null;
		} else {
			return ToXMLUtil.createTree(d, "iid", "ipid", "-1");
		}
	}
	
	public String updateWarnsetCcode(HashMap paramObj)
	{
		String result="success";
		try {
			int count =this.iAs_warnsetService.updateWarnsetCcode(paramObj);
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
