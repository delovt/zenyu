package yssoft.services;

import java.util.HashMap;
import java.util.List;

public interface Ioa_notices {
	
	public List getOa_noticesList(HashMap map);
	public void inserNotices(HashMap map);
	public int isExistLook(HashMap map);
	public List NoticeFilesList(String  iid);
}
