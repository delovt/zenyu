package yssoft.views.twitterViews;

import yssoft.services.twitterServices.ITwitterTypeService;
import yssoft.vos.twitter.TwitterTypeVo;

import java.util.HashMap;

public class TwitterTypeView 
{
	ITwitterTypeService iTwitterTypeService;
	
	private final static String M_SUCCEED = "succeed";
	private final static String M_FAILED = "failed";
	
	public ITwitterTypeService getiTwitterTypeService() {
		return iTwitterTypeService;
	}

	public void setiTwitterTypeService(ITwitterTypeService iTwitterTypeService) {
		this.iTwitterTypeService = iTwitterTypeService;
	}

	public String addTwitterType(TwitterTypeVo twitterTypeVo)
	{
		try {
			return iTwitterTypeService.addTwitterType(twitterTypeVo);
		} catch (Exception e) {
			e.printStackTrace();
			return M_FAILED;
		}
	}
	
	public String deleteTwitterType(int iid) {
		
		try {
			iTwitterTypeService.deleteTwitterType(iid);
			return M_SUCCEED;
		} catch (Exception e) {
			e.printStackTrace();
			return M_FAILED;
		}
	}

	public HashMap getAllTwitterTypeList() {

		return iTwitterTypeService.getAllTwitterTypeList();
		
	}

	public String updateTwitterType(TwitterTypeVo twitterTypeVo) {
		
		try {
			this.iTwitterTypeService.updateTwitterType(twitterTypeVo);
			return M_SUCCEED;
		} catch (Exception e) {
			e.printStackTrace();
			return M_FAILED;
		}
	}
}
