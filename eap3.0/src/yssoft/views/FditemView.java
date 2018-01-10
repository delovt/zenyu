package yssoft.views;

import yssoft.services.IFditemService;
import yssoft.utils.ToXMLUtil;

import java.util.List;

public class FditemView {

	private IFditemService iFditemService;

	public void setiFditemService(IFditemService iFditemService) {
		this.iFditemService = iFditemService;
	}
	
	public String queryFditem()
	{
		List fditemList=this.iFditemService.queryFditem();
		if(null!=fditemList&&fditemList.size()>0)
		{
			return ToXMLUtil.createTree(fditemList, "iid", "ipid", "-1");
		}
		else
		{
			return null;
		}
	}
}
