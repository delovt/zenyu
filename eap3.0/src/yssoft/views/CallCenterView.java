package yssoft.views;

import yssoft.services.ICallCenterService;
import yssoft.servlets.LicenseServlet;

import java.util.HashMap;
import java.util.List;

public class CallCenterView {
    private ICallCenterService iCallCenterService;

    private WorkFlowView wfview;

    private String cpsip;
    private String cpsport;

    public void setCpsip(String cpsip) {
        this.cpsip = cpsip;
    }

    public void setCpsport(String cpsport) {
        this.cpsport = cpsport;
    }

    public HashMap getCpsipAndPort() {
        HashMap map = new HashMap();
        map.put("cpsip", cpsip);
        map.put("cpsport", cpsport);
        String registerCallCenter = "4";
        String registerMobile = "0";
        if ((String) LicenseServlet.getLicenseMap().get("RegisterCallCenter") != null)
            registerCallCenter = (String) LicenseServlet.getLicenseMap().get("RegisterCallCenter");
        if ((String) LicenseServlet.getLicenseMap().get("RegisterMobile") != null)
            registerMobile = (String) LicenseServlet.getLicenseMap().get("RegisterMobile");
        map.put("line", registerCallCenter);
        map.put("mobile",registerMobile);
        return map;
    }

    public void setWfview(WorkFlowView wfview) {
        this.wfview = wfview;
    }

    public void setiCallCenterService(ICallCenterService iCallCenterService) {
        this.iCallCenterService = iCallCenterService;
    }

    public List<?> callInfos(HashMap<?, ?> param) {
        return this.iCallCenterService.getcallinfos(param);
    }

    public List<?> getCallcenterForProjects(HashMap param) {
        //查询某客户的对应的所有联系电话
       /* List list = this.iCallCenterService.getPersonCtel(param);
        String ctelStr = "";
        for (int i = 0; i < list.size(); i++) {
            HashMap map = (HashMap) list.get(i);
            if (i == 0) {
                ctelStr = ctelStr + map.get("ctel");
            } else {
                ctelStr = ctelStr + "," + map.get("ctel");
            }
        }
        param.put("ctel", ctelStr);*/
        //查询一下报岗信息。
        List<HashMap> newList = (List<HashMap>) this.iCallCenterService.getCallcenterForProjects(param);

       /* if (newList == null)
            return null;
        ArrayList returnList = new ArrayList();
        for (HashMap h : newList) {
            if (h.containsKey("ccallintel") && h.get("ccallintel") != null && ctelStr.indexOf(h.get("ccallintel") + "") > -1)
                returnList.add(h);
        }*/

        return newList;
    }

    public HashMap<?, ?> singleCallInfo(HashMap<?, ?> param) {
        return this.iCallCenterService.getsinglecallinfo(param);
    }

    public List<?> nowWorkOrder(HashMap<?, ?> param) {
        return this.iCallCenterService.getnowworkorder(param);
    }

    public List<?> getAssets(HashMap<?, ?> param) {
        return this.iCallCenterService.getassets(param);
    }

    public List<?> getActivities(HashMap<?, ?> param) {
        return this.iCallCenterService.getactivity(param);
    }

    public List<?> hisotryWorkOrder(HashMap<?, ?> param) {
        // TODO Auto-generated method stub
        return this.iCallCenterService.gethisotryworkorder(param);
    }

    public List<?> historyHotLine(HashMap<?, ?> param) {
        // TODO Auto-generated method stub
        return this.iCallCenterService.gethistoryhotline(param);
    }

    public List<?> getReceivable(HashMap<?, ?> param) {
        // TODO Auto-generated method stub
        return this.iCallCenterService.getReceivable(param);
    }

    public List<?> historyPaidRecord(HashMap<?, ?> param) {
        // TODO Auto-generated method stub
        return this.iCallCenterService.getHistoryPaidRecord(param);
    }

    public String saveMoment(HashMap<?, ?> param) {
        return this.iCallCenterService.saveMoment(param);
    }

    public HashMap updateCustPerson(HashMap<?, ?> param) {
        HashMap<String, Object> rhm = new HashMap<String, Object>();

        try {
            rhm = this.iCallCenterService.updatecustperson(param);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return rhm;
    }

    public String updateArrivalDate(HashMap<?, ?> param) {
        try {
            this.iCallCenterService.updatearrivaldate(param);
            return "suc";
        } catch (Exception e) {
            return "fail";
        }
    }

    public String updateDepartureDate(HashMap<?, ?> param) {
        try {
            this.iCallCenterService.updatedeparturedate(param);
            return "suc";
        } catch (Exception e) {
            return "fail";
        }
    }

    public boolean updataSrProjectsAndCC(HashMap param) {
        try {
            int arrid = 0, leaid = 0;
            if (param.containsKey("arrid"))
                arrid = (Integer) param.get("arrid");
            if (param.containsKey("leaid"))
                leaid = (Integer) param.get("leaid");

            param.put("breport", 1);

            if (arrid != 0) {
                param.put("cciid", arrid);
                this.iCallCenterService.updatesolution(param);
                this.iCallCenterService.updateSrProjectsArr(param);
            }

            if (leaid != 0) {
                param.put("cciid", leaid);
                this.iCallCenterService.updatesolution(param);
                this.iCallCenterService.updateSrProjectsLea(param);
            }

            this.iCallCenterService.updatesolution(param);
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public String updatesolution(HashMap<?, ?> param) {
        try {
            this.iCallCenterService.updatesolution(param);
            return "suc";
        } catch (Exception e) {
            return "fail";
        }
    }

    //变更 工程师
    public String updateEngineer(HashMap<?, ?> param) {
        try {
            this.iCallCenterService.updateiengineer(param);
            return "suc";
        } catch (Exception e) {
            return "fail";
        }
    }

    // 变更单号

    public String updateCcode(HashMap<?, ?> param) {
        try {
            int ret = this.iCallCenterService.countCcode(param); // 验证 单号是不是 唯一
            if (ret != 0) {
                return "error";
            }
            this.iCallCenterService.updateCcode(param);
            return "suc";
        } catch (Exception e) {
            return "fail";
        }
    }

    // 生成 单据
    public String insertDJ(HashMap<?, ?> param) {
        try {
            if (param == null) {
                return "参数传递错误";
            }

            HashMap<?, ?> req = (HashMap<?, ?>) param.get("req");
            HashMap<Object, Object> bill = (HashMap<Object, Object>) param.get("bill");

            if (req == null || bill == null) {
                return "参数解析失败";
            }

            int ret = this.iCallCenterService.countSrRequest(req); // 验证 单号是不是 唯一
            if (ret != 0) {
                return "关联服务单据已经生成";
            }

            int reqid = this.iCallCenterService.insertSrRequest(req);

            bill.put("billiinvoice", reqid);

            this.iCallCenterService.insertSrBill(bill);

            return "suc";
        } catch (Exception e) {
            return "提交错误";
        }
    }

    // 生成线索
    public String insertSaCule(HashMap<?, ?> param) {
        try {
            int ret = this.iCallCenterService.countSaCule(param);
            if (ret != 0) {
                return "已经生成了，对应的线索信息";
            }
            this.iCallCenterService.insertSaClue(param);
            return "生成线索成功";
        } catch (Exception e) {
            return "生成线索失败";
        }
    }

    // 撤销生成的 服务单据
    public String deleteService(HashMap<?, ?> param) {
        try {
            this.iCallCenterService.deleteService(param);
            return "撤销成功";
        } catch (Exception e) {
            return "撤销失败";
        }
    }

    //变更呼叫中心记录的状态
    public String updateCallcenterIsolution(HashMap<?, ?> param) {
        try {
            this.iCallCenterService.updateCallcenterIsolution(param);
            return "撤销成功";
        } catch (Exception e) {

            return "撤销失败";
        }
    }

    //获得当前呼叫中心记录 生成的服务工单
    public List<?> getSrbilloniinvoice(HashMap<?, ?> param) {
        return this.iCallCenterService.getSrbilloniinvoice(param);
    }

    //获得工单状态
    public List<?> getistatus(HashMap<?, ?> param) {
        return this.iCallCenterService.getistatus(param);
    }

    //获得工单号
    public List<?> getccode(HashMap<?, ?> param) {
        return this.iCallCenterService.getccode(param);
    }

    //获得客商人员
    public List<?> getcusperson(HashMap<?, ?> param) {
        return this.iCallCenterService.getcusperson(param);
    }

    //提交 协同
    public String submitXT(HashMap<?, ?> param) {
        try {
            return wfview.coopHandler(param);
        } catch (Exception e) {
            return "提交协同失败";
        }
    }
}
