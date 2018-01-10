package yssoft.services.twitterServices;

import yssoft.vos.twitter.TwitterReplyVo;
import yssoft.vos.twitter.TwitterVo;

import java.util.HashMap;
import java.util.List;

public interface ITwitterService 
{
	public List getAllTwitterList();
	
	public List getAllListViewTwitterTitle(int itype);
	
	public List getAllDetailViewReply();
	
	public String addTwitter(TwitterVo twitterTypeVo);
	
	public void updateTwitter(TwitterVo twitterTypeVo);
	
	public void deleteTwitter(int iid);
	
	public void reply(TwitterReplyVo twitterReplyVo);
	
	public List get_TwitterReplyList(int itwitter);
	
	public HashMap getDetailViewOwner(int iid);
	
	public void addUpReadTwitter(int iid);
	
	public void addUpBrowseTwitter(int iid);
	
	public List getHotList();
	
	public List geCreamList();
	
	public List getAllTwitterTypeList();
	
	public List getTwitterTypeList();
	
	public HashMap getStatForMainView(int imaker);
	
	public void updateTwitterReply(TwitterReplyVo twitterReplyVo);
	
	public void addCream_twitter(int iid);
	
	public void reIssue_twitter(int iid);
}
