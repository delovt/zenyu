package yssoft.views;

import yssoft.services.IBasisFileService;
import yssoft.utils.ToXMLUtil;

import java.util.HashMap;
import java.util.List;

public class BasisFileView {
	private IBasisFileService iBasisFileService = null;

	public void setiBasisFileService(IBasisFileService iBasisFileService) {
		this.iBasisFileService = iBasisFileService;
	}
	
	public String getWareHouseTree() throws Exception {
		List d = this.iBasisFileService.getWareHouseList();
		if (d.size() == 0) {
			return null;
		} else {
			return ToXMLUtil.createTree(d, "iid", "ipid", "-1");
		}
	}
	
	public String updateWareHouseCcode(HashMap paramObj)
	{
		String result="success";
		try {
			int count =this.iBasisFileService.updateWareHouseCcode(paramObj);
			if(count==0)
			{
				result ="fail";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	public String getRdTypeTree() throws Exception {
		List d = this.iBasisFileService.getRdTypeList();
		if (d.size() == 0) {
			return null;
		} else {
			return ToXMLUtil.createTree(d, "iid", "ipid", "-1");
		}
	}
	
	public String updateRdTypeCcode(HashMap paramObj)
	{
		String result="success";
		try {
			int count =this.iBasisFileService.updateRdTypeCcode(paramObj);
			if(count==0)
			{
				result ="fail";
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}
	
	public String updateRdTypeIrdflag(HashMap paramObj)
	{
		String result="success";
		try {
			int count =this.iBasisFileService.updateRdTypeIrdflag(paramObj);
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
