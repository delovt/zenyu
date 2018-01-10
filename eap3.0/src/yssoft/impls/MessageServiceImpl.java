package yssoft.impls;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

import yssoft.daos.BaseDao;
import yssoft.services.IMessageService;
import yssoft.vos.AbSmsVo;

public class MessageServiceImpl extends BaseDao implements IMessageService {

    @Override
    public List<AbSmsVo> qureyMessage(HashMap hm) throws Exception {
        // TODO Auto-generated method stub
        List list = null;
        String sql = "";
        String allOrMine = hm.get("allOrMine").toString();
//		String iids = hm.get("iids").toString();
        String ifuncregedit = hm.get("ifuncregedit").toString();
        String imaker = hm.get("imaker").toString();
        if (allOrMine.equals("mine")) {
            sql = "select ab.iid,ab.ifuncregedit,ab.iinvoice, ab.ccusname,ab.cpsnname,ab.ctitle,ab.cdetail,ab.cmobile,hp.cname imaker,ab.dmaker,hp2.cname iverify,ab.dverify,ab.istate from AB_sms ab left join hr_person hp on ab.imaker=hp.iid left join hr_person hp2 on ab.iverify=hp2.iid   where  ab.ifuncregedit=" + ifuncregedit + " and ab.istate=0 and ab.imaker=" + imaker;
        } else {
            sql = "select ab.iid,ab.ifuncregedit,ab.iinvoice, ab.ccusname,ab.cpsnname,ab.ctitle,ab.cdetail,ab.cmobile,hp.cname imaker,ab.dmaker,hp2.cname iverify,ab.dverify,ab.istate from AB_sms ab left join hr_person hp on ab.imaker=hp.iid left join hr_person hp2 on ab.iverify=hp2.iid   where  ab.ifuncregedit=" + ifuncregedit + " and ab.istate=0";
        }
        HashMap hmp = new HashMap();
        hmp.put("sqlvalue", sql);
        list = this.queryForList("SendMessage.search", hmp);
        return list;
    }

    @Override
    public int addMessage(ArrayList<AbSmsVo> abSmsVos) throws Exception {
        // TODO Auto-generated method stub
        HashMap hm = new HashMap();
        String sql = "";
        AbSmsVo abSmsVo = null;
        Iterator<AbSmsVo> it = abSmsVos.iterator();
        while (it.hasNext()) {
            abSmsVo = it.next();
            sql = "insert into AB_sms (ccusname,icustperson,cpsnname,ctitle,cmobile,istate,imaker,dmaker,ifuncregedit,cdetail) values ('" + abSmsVo.getCcusname() + "'," + abSmsVo.getIcustperson() + ",'" + abSmsVo.getCpsnname() + "','" + abSmsVo.getCtitle() + "','" + abSmsVo.getCmobile() + "'," + abSmsVo.getIstate() + "," + abSmsVo.getImaker() + ",getdate()," + abSmsVo.getIfuncregedit() + ",'" + abSmsVo.getCdetail() + "')";
            hm.put("sqlvalue", sql);
            this.insert("SendMessage.insert", hm);
            sql = "";
            hm.clear();
        }
        return 0;
    }

    @Override
    public int modifyMessage(ArrayList<AbSmsVo> abSmsVos) throws Exception {
        // TODO Auto-generated method stub
        HashMap hm = new HashMap();
        String sql = "";
        AbSmsVo abSmsVo = null;
        Iterator<AbSmsVo> it = abSmsVos.iterator();
        while (it.hasNext()) {
            abSmsVo = it.next();
            sql = "update AB_sms set cdetail='" + abSmsVo.getCdetail() + "',istate=1,iverify=" + abSmsVo.getImodify() + ",dverify=getdate()   where iid=" + abSmsVo.getIid();
            hm.put("sqlvalue", sql);
            this.update("SendMessage.update", hm);
            sql = "";
            hm.clear();
        }
        return 0;
    }

    @Override
    public int deleteMessage(ArrayList<AbSmsVo> abSmsVos) throws Exception {
        // TODO Auto-generated method stub
        HashMap hm = new HashMap();
        String sql = "";
        AbSmsVo abSmsVo = null;
        Iterator<AbSmsVo> it = abSmsVos.iterator();
        while (it.hasNext()) {
            abSmsVo = it.next();
            sql = "delete from AB_sms where iid = " + abSmsVo.getIid();
            hm.put("sqlvalue", sql);
            this.delete("SendMessage.delete", hm);
            sql = "";
            hm.clear();
        }
        return 0;
    }

    @Override
    public List<AbSmsVo> getMsgForWorkFlow() throws Exception {
        List al = this.queryForList("SendMessageForWorkFlow", null);
        return al;
    }

}
