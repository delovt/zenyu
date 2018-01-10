package yssoft.services.twitterServices;

import yssoft.vos.twitter.TwitterReplyVo;

import java.util.List;

public interface ITwitterReplyService 
{
	public List getAllTwitterReplyList(int itwitter);
	
	public String addTwitterReply(TwitterReplyVo twitterReplyVo);
	
	public void updateTwitterReply(TwitterReplyVo twitterReplyVo);
	
	public void deleteTwitterReply(int iid);
}
