package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IOAService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class OAServiceImpl extends BaseDao implements IOAService {

	@Override
	public List<HashMap> getExpenseNeedList(int iperson) throws Exception {
		ArrayList returnList = new ArrayList();
		
		boolean billFlag = false;
		boolean projectsFlag = false;
		boolean  unresolved = false;
		HashMap cclass = new HashMap();
		cclass.put("cclass", "oa");
		List<HashMap> oalist =  this.queryForList("get_as_options_aqcl",cclass);
		for(HashMap oaitem:oalist){
			String oatitle = (String) oaitem.get("ctitle");
			String oavalue = (String) oaitem.get("cvalue");
			if(oatitle.equals("服务工单报销是否控制电话报岗")&&oavalue.equals("1")){
				System.out.println(oatitle+":"+oavalue);
				billFlag = true;
			}
			if(oatitle.equals("实施工单报销是否控制电话报岗")&&oavalue.equals("1")){
				System.out.println(oatitle+":"+oavalue);
				projectsFlag = true;
			}
            if(oatitle.equals("服务工单未解决是否参与报销")&&oavalue.equals("0")){
                unresolved = true;
            }
		}
		for(HashMap oaitem:oalist){
			String oatitle = (String) oaitem.get("ctitle");
			String oavalue = (String) oaitem.get("cvalue");
			if(oatitle.equals("日志活动是否参与费用报销")&&oavalue.equals("1")){				
				returnList.addAll(this.queryForList("getExpenseNeedListWorkdiary",iperson));
			}
			if(oatitle.equals("售前支持是否参与费用报销")&&oavalue.equals("1")){			
				returnList.addAll(this.queryForList("getExpenseNeedListPresupport",iperson));
			}
			if(oatitle.equals("服务工单是否参与费用报销")&&oavalue.equals("1")){
                List billList;
                List newBillList = new ArrayList();
				if(billFlag){
                    billList = this.queryForList("getExpenseNeedListBill",iperson);
                    if(unresolved){
                        for (int i = 0;i<billList.size();i++){
                            HashMap bill= (HashMap)billList.get(i);
                            if(bill != null && bill.size() > 0){
                                if (Integer.parseInt(bill.get("iresult").toString()) != 377){
                                    newBillList.add(bill);
                                }
                            }
                        }
                    }else{
                        newBillList = billList;
                    }
                    returnList.addAll(newBillList);
                }else{
                    billList = this.queryForList("getExpenseNeedListBill2",iperson);
                    if(unresolved){
                        for (int i = 0;i<billList.size();i++){
                            HashMap bill= (HashMap)billList.get(i);
                            if(bill != null && bill.size() > 0){
                                if (Integer.parseInt(bill.get("iresult").toString()) != 377){
                                    newBillList.add(bill);
                                }
                            }
                        }
                    }else{
                        newBillList = billList;
                    }
					returnList.addAll(newBillList);
                }

			}
			if(oatitle.equals("实施日志是否参与费用报销")&&oavalue.equals("1")){	
				if(projectsFlag)
					returnList.addAll(this.queryForList("getExpenseNeedListProjects",iperson));
				else
					returnList.addAll(this.queryForList("getExpenseNeedListProjects2",iperson));
			}
			if(oatitle.equals("加班是否参与费用报销")&&oavalue.equals("1")){				
				returnList.addAll(this.queryForList("getExpenseNeedListOvertime",iperson));
			}
			
		}
		return returnList;
	}

	@Override
	public int updateDutyState(HashMap paramObj) throws Exception {
		return this.update("updateDutyState",paramObj);
	}
	
	public int delDutyState(HashMap paramObj) throws Exception {
		return this.update("delDutyState",paramObj);
	}
	
	public HashMap queryState(HashMap paramObj)throws Exception
	{
		return (HashMap)this.queryForObject("select_state",paramObj);
	}
	
	@Override
	public Object addDutyRoleUser(HashMap paramObj) throws Exception {
		return this.insert("add_roleUser",paramObj);
	}

	@Override
	public void delDutyRoleUser(HashMap paramObj) throws Exception {
		this.delete("delDutyRoleUser");
	}

	@Override
	public Object getDutyRoleUser() throws Exception {
		return this.queryForObject("queryDutyRole");
	}

	@Override
	public Object addPlan(HashMap paramObj) throws Exception {
		Object o =  this.insert("add_Plan",paramObj);
		
		HashMap invocieuser = new HashMap();
		invocieuser.put("iinvoice", Integer.parseInt(o.toString()));
		invocieuser.put("ifuncregedit", 320);
		invocieuser.put("irole", 1);
		int imaker =  (Integer) paramObj.get("iperson");
		invocieuser.put("iperson", imaker);
		// invocieuser.put("iid", iid);
		this.insert("add_ab_invoiceuser", invocieuser);
		
		return o;
	}
	
	@Override
	public Object addPlans(HashMap paramObj) throws Exception {
		return this.insert("add_Plans",paramObj);
	}

    @Override
    public Object addMessage(HashMap paramObj) throws Exception {
        return this.insert("addMessage",paramObj);
    }

	@Override
	public void delPlans(HashMap paramObj) throws Exception {
		this.delete("delPlans",paramObj);
        HashMap m = new HashMap();
        m.put("iinvoice",paramObj.get("iid"));
        this.delete("delMessage",m);

		List<HashMap> list =  this.queryForList("getPlans",paramObj);
		if(list==null||list.size()==0){
			this.delete("delPlan", paramObj);
			
			HashMap invocieuser = new HashMap();
			invocieuser.put("iinvoice",(Integer) paramObj.get("iplan") );
			invocieuser.put("ifuncregedit", 321);
			this.delete("delete_ab_invoiceuser", invocieuser);			
		}
			
	}

	@Override
	public List<HashMap> getPlan(int iplan) throws Exception {
		return this.queryForList("getPlan",iplan);
	}

	@Override
	public List<HashMap> getPlansDetail(int iplan) throws Exception {
		return this.queryForList("getPlansDetail",iplan);
	}

	@Override
	public List<HashMap> getPlansCtypeListl(int iplan) throws Exception {
		return this.queryForList("getPlansCtypeListl",iplan);
	}
	
	@Override
	public int updatePlans(HashMap paramObj) throws Exception {
        HashMap m = new HashMap();
        m.put("iinvoice",paramObj.get("iid"));
        this.delete("delMessage",m);
        String dmessage = paramObj.get("dmessage").toString();
        if(dmessage!=null&&!dmessage.trim().equals("")){
            if(dmessage.length()>24 &&dmessage.substring(24).equals("1900")){

            }else{
                this.insert("addMessage",m);
            }
        }

		return this.update("updatePlans",paramObj);
	}

    @Override
    public Object addNoticeNode(HashMap paramObj) throws Exception {
        return this.insert("addNoticeNode",paramObj);
    }

    @Override
    public Object addNoticeNodes(HashMap paramObj) throws Exception {
        return this.insert("addNoticeNodes",paramObj);
    }
    @Override
    public Object addinquiryp(HashMap paramObj) throws Exception {
        return this.insert("addinquiryp",paramObj);
    }
    @Override
    public Object addInquiryd(HashMap paramObj) {return this.insert("addInquiryd",paramObj); }
    @Override
    public Object updateInquiryp(HashMap paramObj) {return this.update("updateInquiryp",paramObj); }
    @Override
    public Object updatenoticenodes(HashMap paramObj) {return this.update("updatenoticenodes",paramObj); }

    @Override
    public Object insertInquiryss(HashMap paramObj) {return this.insert("insertInquiryss",paramObj); }

    @Override
    public List<HashMap> getDepartmentPerson(int idepartment) throws Exception {
        return this.queryForList("getDepartmentPerson",idepartment);
    }

    @Override
    public List<HashMap> getNoticeNode(int inotice) throws Exception {
        return this.queryForList("getNoticeNode",inotice);
    }

    @Override
    public int delQuestionNode(int inotice) throws Exception {
        return this.delete("delQuestionNode",inotice);
    }

    @Override
    public int delNoticeNode(int inotice) throws Exception {
        return this.delete("delNoticeNode",inotice);
    }

}
