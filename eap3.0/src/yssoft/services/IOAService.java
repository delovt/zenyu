package yssoft.services;

import java.util.HashMap;
import java.util.List;

public interface IOAService {
	
	public List<HashMap> getExpenseNeedList(int iperson) throws Exception;
	
	public Object getDutyRoleUser() throws Exception;

	public int updateDutyState(HashMap paramObj) throws Exception;
	
	public void delDutyRoleUser(HashMap paramObj) throws Exception;
	
	public Object addDutyRoleUser(HashMap paramObj) throws Exception;
	
	public Object addPlan(HashMap paramObj)throws Exception;
	public Object addPlans(HashMap paramObj)throws Exception;

    public Object addMessage(HashMap paramObj)throws Exception;
	
	public void delPlans(HashMap paramObj) throws Exception;
	
	public List<HashMap> getPlan(int iplan) throws Exception;
	public List<HashMap> getPlansDetail(int iplan) throws Exception;
	public List<HashMap> getPlansCtypeListl(int iplan) throws Exception;

	public int updatePlans(HashMap paramObj) throws Exception;
	
	public int delDutyState(HashMap paramObj) throws Exception;
	
	public HashMap queryState(HashMap paramObj)throws Exception;

    public Object addNoticeNode(HashMap paramObj)throws Exception;

    public Object addNoticeNodes(HashMap paramObj)throws Exception;

    public Object addinquiryp(HashMap paramObj)throws Exception;

    public Object addInquiryd(HashMap paramObj)throws Exception;

    public Object updateInquiryp(HashMap paramObj)throws Exception;

    public Object updatenoticenodes(HashMap paramObj)throws Exception;

    public Object insertInquiryss(HashMap paramObj)throws Exception;
    public List<HashMap> getDepartmentPerson(int idepartment) throws Exception;

    public List<HashMap> getNoticeNode(int inotice) throws Exception;
    public int delNoticeNode(int inotice) throws Exception;
    public int delQuestionNode(int inotice) throws Exception;

}
