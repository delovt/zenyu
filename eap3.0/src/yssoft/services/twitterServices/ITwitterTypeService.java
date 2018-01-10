package yssoft.services.twitterServices;

import yssoft.vos.twitter.TwitterTypeVo;

import java.util.HashMap;

public interface ITwitterTypeService 
{
	public HashMap<String,Object> getAllTwitterTypeList();
	
	public String addTwitterType(TwitterTypeVo twitterTypeVo);
	
	public void updateTwitterType(TwitterTypeVo twitterTypeVo);
	
	public void deleteTwitterType(int iid);
}
