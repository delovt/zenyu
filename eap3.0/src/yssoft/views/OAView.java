package yssoft.views;

import yssoft.services.IOAService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class OAView {

	private IOAService iOAService = null;

	public List<HashMap> getExpenseNeedList(int iperson) throws Exception {
		return this.iOAService.getExpenseNeedList(iperson);
	}

	public void setiOAService(IOAService iOAService) {
		this.iOAService = iOAService;
	}

	public boolean updateDutyState(HashMap h) throws Exception {
		try {
			this.iOAService.updateDutyState(h);
			if (h.containsKey("dutys")) {
				this.iOAService.delDutyRoleUser(h);

				HashMap hash = (HashMap) this.iOAService.getDutyRoleUser();
				ArrayList<HashMap> dutylist = (ArrayList) h.get("dutys");
				for (HashMap item : dutylist) {
					item.put("irole", hash.get("cvalue"));
					this.iOAService.addDutyRoleUser(item);
				}
			}
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	// 值班失效 add by zhong_jing
	@SuppressWarnings("rawtypes")
	public int deleteDutyState(HashMap h) throws Exception {
		try {
			HashMap stateMap =this.iOAService.queryState(h);
			if(stateMap.get("istate").toString().equals("3")||stateMap.get("istate").toString().equals("1"))
			{
				return 2;
			}
			else
			{
				this.iOAService.delDutyState(h);
				if (h.containsKey("dutys")) {
					this.iOAService.delDutyRoleUser(h);
				}
				return 1;
			}
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	public int addPlan(HashMap h) throws Exception {
		try {
			int iplan = Integer.parseInt(this.iOAService.addPlan(h).toString());
			return iplan;
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	public int addPlans(HashMap h) throws Exception {
		try {
			int iplans = Integer.parseInt(this.iOAService.addPlans(h)
					.toString());
			String dmessage = h.get("dmessage").toString();
			if (dmessage != null && !dmessage.trim().equals("")) {
				if (dmessage.length() > 24
						&& dmessage.substring(24).equals("1900")) {
					return iplans;
				}

				HashMap item = new HashMap();
				item.put("iinvoice", iplans);
				this.iOAService.addMessage(item);
			}
			return iplans;
		} catch (Exception e) {
			e.printStackTrace();
			return 0;
		}
	}

	public void delPlans(HashMap h) throws Exception {
		this.iOAService.delPlans(h);
		if (h.containsKey("coopList")) {
			ArrayList<HashMap> coopList = (ArrayList) h.get("coopList");
			if (coopList != null && coopList.size() > 0) {
				for (HashMap item : coopList) {
					this.iOAService.delPlans(item);
				}
			}
		}

	}

	public boolean updatePlans(HashMap h) throws Exception {
		try {
			this.iOAService.updatePlans(h);
			if (h.containsKey("coopList")) {
				ArrayList<HashMap> coopList = (ArrayList) h.get("coopList");
				if (coopList != null && coopList.size() > 0) {
					for (HashMap item : coopList) {
						this.iOAService.updatePlans(item);
					}
				}
			}
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

	public HashMap getPlanAndPlansListAndCtypeList(int iplan) throws Exception {
		HashMap h = new HashMap();
		h.put("plan", this.iOAService.getPlan(iplan));
		h.put("planList", this.iOAService.getPlansDetail(iplan));
		h.put("ctypeList", this.iOAService.getPlansCtypeListl(iplan));
		return h;
	}

	public HashMap getPlanList(int iplan) throws Exception {
		HashMap h = new HashMap();
		h.put("planList", this.iOAService.getPlansDetail(iplan));
		return h;
	}

	public boolean addPlansList(ArrayList<HashMap> al) {
		try {
			for (HashMap h : al) {
				int iplans = Integer.parseInt(this.iOAService.addPlans(h)
						.toString());
			}
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			return false;
		}
	}

    public boolean addQuestionNodes(HashMap param) {
        try {
            ArrayList<HashMap> al = new ArrayList<HashMap>();
            al = (ArrayList<HashMap>) param.get("selectedAc");
            int iid = Integer.parseInt(param.get("iid").toString());
            this.iOAService.delQuestionNode(Integer.parseInt(al.get(0).get("inotice").toString()));
            int inoticenode = 0;
            for (HashMap h : al) {
                h.put("iifuncregedit", 468);
                inoticenode = Integer.parseInt(this.iOAService.addNoticeNode(h).toString());

                int inodetype = Integer.parseInt(h.get("inodetype").toString());
                int inodevalue = Integer.parseInt(h.get("inodevalue").toString());

                List<HashMap> personList = new ArrayList<HashMap>();
                if (inodetype == 1) {
                    personList = this.iOAService.getDepartmentPerson(inodevalue);
                }
                HashMap quiry = new HashMap();
                for (HashMap person : personList) {
                    person.put("iperson", person.get("iid"));
                    person.put("inoticenode", inoticenode);
                    quiry.put("iid", iid);
                    quiry.put("iperson", person.get("iid"));
                    quiry.put("itype", person.get("itype"));
                    this.iOAService.addNoticeNodes(person);
                    this.iOAService.addinquiryp(quiry);
                }
            }

            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public void addInquiryd(HashMap param) {
        try {
            List<HashMap> list = new ArrayList<HashMap>();
            list = (List) param.get("submitlist");      //预置答案列表

            List<HashMap> list2 = new ArrayList<HashMap>();
            list2 = (List) param.get("anslist");         //其他答案列表

            for (HashMap mp2 : list2) {
                int iinquiryss = Integer.parseInt(this.iOAService.insertInquiryss(mp2).toString());
                mp2.put("iinquiryss",iinquiryss);
                this.iOAService.addInquiryd(mp2);
            }

            for (HashMap mp : list) {
                this.iOAService.addInquiryd(mp);
            }

            this.iOAService.updateInquiryp(param);
            this.iOAService.updatenoticenodes(param);

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
