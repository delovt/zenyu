package yssoft.views;

import yssoft.services.Ioa_notices;

import java.util.HashMap;
import java.util.List;

public class OA_notices {
	
	private Ioa_notices  i_oa_notices;
	public void setI_oa_notices(Ioa_notices iOaNotices) {
		i_oa_notices = iOaNotices;
	}
	
	/**
	 * 
	 * 系统公告查询 ,新增
	 * SDY add
	 */
	public List getOa_noticesList(HashMap map)
	{
		return this.i_oa_notices.getOa_noticesList(map);
	}
	
	public void inserNotices(HashMap map)
	{
		this.i_oa_notices.inserNotices(map);
	}
	
	public int isExistLook(HashMap map)
	{
		return this.i_oa_notices.isExistLook(map);
	}
	
	//公告附件列表
	public List noticeFilesList(String iid)
	{
		return this.i_oa_notices.NoticeFilesList(iid);
	}
	
}
