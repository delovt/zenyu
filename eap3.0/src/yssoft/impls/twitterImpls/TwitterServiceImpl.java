package yssoft.impls.twitterImpls;

import yssoft.daos.BaseDao;
import yssoft.services.twitterServices.ITwitterReplyService;
import yssoft.services.twitterServices.ITwitterService;
import yssoft.vos.twitter.TwitterReplyVo;
import yssoft.vos.twitter.TwitterVo;

import java.util.HashMap;
import java.util.List;

public class TwitterServiceImpl extends BaseDao implements ITwitterService {

	private ITwitterReplyService iTwitterReplyService;
	
	public ITwitterReplyService getiTwitterReplyService() {
		return iTwitterReplyService;
	}

	public void setiTwitterReplyService(ITwitterReplyService iTwitterReplyService) {
		this.iTwitterReplyService = iTwitterReplyService;
	}

	@Override
	public String addTwitter(TwitterVo twitterVo) {
		Integer iid = (Integer) this.insert("add_twitter", twitterVo);
		return iid.toString();
	}

	@Override
	public void deleteTwitter(int iid) {
		this.delete("delete_twitterReply", iid);
		this.delete("delete_twitter", iid);
	}

	@Override
	public List getAllTwitterList(){
		return this.queryForList("getAllMainViewTwitterType");
	}

	@Override
	public void updateTwitter(TwitterVo twitterTypeVo) {

	}

	@Override
	public void reply(TwitterReplyVo twitterReplyVo) {
		iTwitterReplyService.addTwitterReply(twitterReplyVo);
	}

	@Override
	public List getAllListViewTwitterTitle(int itype) {
		return this.queryForList("get_persons_sql", itype);
	}

	@Override
	public List getAllDetailViewReply() {
		return this.queryForList("get_persons_sql");
	}

	@Override
	public List get_TwitterReplyList(int itwitter) {
		return iTwitterReplyService.getAllTwitterReplyList(itwitter);
	}

	@Override
	public HashMap getDetailViewOwner(int iid) {
		return (HashMap) this.queryForObject("getDetailViewOwner", iid);
	}

	@Override
	public void addUpReadTwitter(int iid) {
		this.update("addUpRead_twitter", iid);
	}
	
	@Override
	public void addUpBrowseTwitter(int iid) {
		this.update("addUpBrowse_twitter", iid);
	}

	@Override
	public List geCreamList() {
		return this.queryForList("getCreamTwitterList");
	}

	@Override
	public List getHotList() {
		return this.queryForList("getHotTwitterList");
	}

	@Override
	public List getAllTwitterTypeList() {
		HashMap map = new HashMap();
		map.put("cname", "全部");
		map.put("ccode", "0");
		
		List list = this.queryForList("getAllTwitterType");
		list.add(0, map);
		
		return list;
	}
	
	@Override
	public List getTwitterTypeList() {
		return this.queryForList("getAllTwitterType");
	}

	@Override
	public HashMap getStatForMainView(int imaker) {
		return (HashMap) this.queryForObject("getStatForMainView", imaker);
	}

	@Override
	public void updateTwitterReply(TwitterReplyVo twitterReplyVo) {
		iTwitterReplyService.updateTwitterReply(twitterReplyVo);
	}

	@Override
	public void addCream_twitter(int iid) {
		this.update("addCream_twitter", iid);
	}

	@Override
	public void reIssue_twitter(int iid) {
		this.update("reIssue_twitter", iid);
	}



}
