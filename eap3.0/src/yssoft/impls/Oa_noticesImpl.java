package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.Ioa_notices;

import java.util.HashMap;
import java.util.List;

@SuppressWarnings("serial")
public class Oa_noticesImpl extends BaseDao implements Ioa_notices {

	@SuppressWarnings("unchecked")
	@Override
	public List getOa_noticesList(HashMap map) {
		
		return this.queryForList("select_oa_notices",map);
	}

	@SuppressWarnings("unchecked")
	@Override
	public void inserNotices(HashMap map) {
		this.insert("insert_oa_notices",map);
	}

	@Override
	public int isExistLook(HashMap map) {
		return Integer.parseInt(this.queryForObject("isExistLook_oa_notices",map)+"");
	}

	@Override
	public List NoticeFilesList(String iid) {
		return this.queryForList("select_notice_file",iid);
	}

}
