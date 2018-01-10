package yssoft.views.twitterViews;

import yssoft.services.twitterServices.ITwitterService;
import yssoft.utils.FileUtil;
import yssoft.utils.LogOperateUtil;
import yssoft.vos.twitter.TwitterReplyVo;
import yssoft.vos.twitter.TwitterVo;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class TwitterView 
{
	ITwitterService iTwitterService;
	
	private final static String M_SUCCEED = "succeed";
	private final static String M_FAILED = "failed";
	
	public ITwitterService getiTwitterService() 
	{
		return iTwitterService;
	}
	
	public void setiTwitterService(ITwitterService iTwitterService) 
	{
		this.iTwitterService = iTwitterService;
	}
	
	public String addTwitter(TwitterVo twitterVo)
	{
		try {
			//begin  删除未保存富文本图片
			HashMap hm = new HashMap();
			List imagesForDelNew = new ArrayList();		
			List userId = new ArrayList();
			List status = new ArrayList();
			List imagesForDelOld = new ArrayList();
			status.add("save");
			String cdetail = twitterVo.getCdetail();
			imagesForDelNew.add(cdetail);
			userId.add(twitterVo.getUserId());
			hm.put("userId", userId);
			hm.put("imagesForDelNew", imagesForDelNew);
			hm.put("status", status);
			hm.put("imagesForDelOld", imagesForDelOld);
			cdetail = cdetail.replaceAll(twitterVo.getUserId()+"_temp_", "img_");
			twitterVo.setCdetail(cdetail);
			//删除未保存富文本图片
			FileUtil fu = new FileUtil();
			fu.deleteImage(hm);
			//end
			
			String iid = iTwitterService.addTwitter(twitterVo);
			String result = "success";
			HashMap logParams = new HashMap();
			
			logParams.put("iinvoice",iid);
			logParams.put("iifuncregedit", 151);
			HashMap<String, Serializable> map_0 = new HashMap<String, Serializable>();
			map_0.put("operate", twitterVo.getType()+"");
			map_0.put("result", result);
			map_0.put("iinvoice", iid);
			map_0.put("params", logParams);
			LogOperateUtil.insertLog(map_0);
			return iid;
		} catch (Exception e) {
			e.printStackTrace();
			return M_FAILED;
		}
	}
	
	public String deleteTwitter(int iid) {
		
		try {
			iTwitterService.deleteTwitter(iid);
			return M_SUCCEED;
		} catch (Exception e) {
			e.printStackTrace();
			return M_FAILED;
		}
	}

	public List getAllTwitterList() {
		List list = iTwitterService.getAllTwitterList();
		return list;
		
	}
	
	
	public List getAllListViewTwitterTitle(int itype) {
		List list = new ArrayList();
		try {
			list = iTwitterService.getAllListViewTwitterTitle(itype);
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public List getAllDetailViewReply(int iid) {
		List list = iTwitterService.getAllDetailViewReply();
		
		return list;
		
	}

	public String updateTwitter(TwitterVo twitterVo) {
		
		try {
			this.iTwitterService.updateTwitter(twitterVo);
			return M_SUCCEED;
		} catch (Exception e) {
			e.printStackTrace();
			return M_FAILED;
		}
	}
	
	public String reply(TwitterReplyVo twitterReplyVo) {
		
		try {
			//begin  删除未保存富文本图片
			HashMap hm = new HashMap();
			List imagesForDelNew = new ArrayList();		
			List userId = new ArrayList();
			List status = new ArrayList();
			List imagesForDelOld = new ArrayList();
			status.add("save");
			String cdetail = twitterReplyVo.getCdetail();
			imagesForDelNew.add(cdetail);
			userId.add(twitterReplyVo.getUserId());
			hm.put("userId", userId);
			hm.put("imagesForDelNew", imagesForDelNew);
			hm.put("status", status);
			hm.put("imagesForDelOld", imagesForDelOld);
			//删除未保存富文本图片
			FileUtil fu = new FileUtil();
			fu.deleteImage(hm);
			//end
			String iid = twitterReplyVo.getItwitter()+"";
			String result = "success";
			HashMap logParams = new HashMap();
			
			logParams.put("iinvoice",iid);
			logParams.put("iifuncregedit", 151);
			HashMap<String, Serializable> map_0 = new HashMap<String, Serializable>();
			map_0.put("operate", "回复");
			map_0.put("result", result);
			map_0.put("iinvoice", iid);
			map_0.put("params", logParams);
			LogOperateUtil.insertLog(map_0);
			String cdetailNew = twitterReplyVo.getCdetail();
			cdetailNew = cdetailNew.replaceAll(twitterReplyVo.getUserId()+"_temp_", "img_");
			twitterReplyVo.setCdetail(cdetailNew);
			this.iTwitterService.reply(twitterReplyVo);
			return M_SUCCEED;
		} catch (Exception e) {
			e.printStackTrace();
			return M_FAILED;
		}
	}
	
	public List get_TwitterReplyList(int itwitter) {
		List list = iTwitterService.get_TwitterReplyList(itwitter);
		return list;
		
	}
	
	
	public HashMap getDetailViewOwner(int iid) {
		HashMap map = iTwitterService.getDetailViewOwner(iid);
		return map;
		
	}
	
	public String addUpReadTwitter(int iid) {
		
		try {
			this.iTwitterService.addUpReadTwitter(iid);
			return M_SUCCEED;
		} catch (Exception e) {
			e.printStackTrace();
			return M_FAILED;
		}
	}
	
	public String addUpBrowseTwitter(int iid) {
		
		try {
			this.iTwitterService.addUpBrowseTwitter(iid);
			return M_SUCCEED;
		} catch (Exception e) {
			e.printStackTrace();
			return M_FAILED;
		}
	}
	
	public List geCreamList() {
		List list = iTwitterService.geCreamList();
		return list;
		
	}
	
	public List getHotList() {
		List list = iTwitterService.getHotList();
		return list;
		
	}
	
	public List getAllTwitterTypeList() {
		List list = iTwitterService.getAllTwitterTypeList();
		return list;
	}
	
	public List getTwitterTypeList() {
		List list = iTwitterService.getTwitterTypeList();
		return list;
	}
	
	public HashMap getStatForMainView(int imaker) {
		return iTwitterService.getStatForMainView(imaker);
	}
	
	public void updateTwitterReply(TwitterReplyVo twitterReplyVo) {
		iTwitterService.updateTwitterReply(twitterReplyVo);
	}
	
	public String addCream_twitter(int iid){
		try {
			this.iTwitterService.addCream_twitter(iid);
			return M_SUCCEED;
		} catch (Exception e) {
			e.printStackTrace();
			return M_FAILED;
		}
	}
	
	public String reIssue_twitter(int iid){
		try {
			this.iTwitterService.reIssue_twitter(iid);
			return M_SUCCEED;
		} catch (Exception e) {
			e.printStackTrace();
			return M_FAILED;
		}
	}
	
}
