package yssoft.impls.twitterImpls;

import yssoft.daos.BaseDao;
import yssoft.services.twitterServices.ITwitterReplyService;
import yssoft.vos.twitter.TwitterReplyVo;

import java.util.List;

public class TwitterReplyServiceImpl extends BaseDao implements ITwitterReplyService {

	@Override
	public String addTwitterReply(TwitterReplyVo twitterReplyVo) {
		
		Integer i = (Integer)this.insert("add_twitterReply", twitterReplyVo);
		return i.toString();
	}

	@Override
	public void deleteTwitterReply(int iid) {
		this.delete("delete_twitterReply", iid);
	}

	@Override
	public List getAllTwitterReplyList(int itwitter) {
		return this.queryForList("get_persons_sql", itwitter);
	}

	@Override
	public void updateTwitterReply(TwitterReplyVo twitterReplyVo) {
		this.update("update_twitterReply", twitterReplyVo);

	}

}
