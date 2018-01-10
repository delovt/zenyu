package yssoft.callcenter;

import yssoft.services.UtilService;
import yssoft.utils.DesEncryptUtil;

import java.util.HashMap;
import java.util.List;

/**
 * Created by LN on 2014/6/23.
 */
public class CallCenterUtil {
    public UtilService utilService;

    public void setUtilService(UtilService utilService) {
        this.utilService = utilService;
    }

    public String getAllowCount() {
        String enc_data = "";
        String deccode = "";
        String key = "12345678";
        String sql = "select cvalue from as_options where iid='2202' ";
        try {
            List<HashMap> list = utilService.exeSql(sql);
            if (list.size() > 0) {
                for (HashMap cvalue : list) {
                    enc_data = (String) cvalue.get("cvalue");
                }

            }
            if (!enc_data.isEmpty()) {
                deccode = DesEncryptUtil.decodeDes(enc_data, key);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return deccode;
    }

    public List<HashMap> getLocalNumber() {
        List<HashMap> list = null;

        String sql = "select clineno,clinenum from cc_calllineset order by clineno ";

        try {
            list = utilService.exeSql(sql);

        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<HashMap> getLineDetails(HashMap map) {
        List<HashMap> list = null;
        int iintelcount = getSysIntelCount();
        boolean flag = getSysDealIntel();

        String date = (String) map.get("date");
        if (date.equals("today"))
            date = "convert(varchar(10),getdate(),23) ";
        else {
            date = "'" + date + "'";
        }

        String lineno = (String) map.get("lineno");
        if (!lineno.equals("全部")) {
            lineno = "line" + lineno.substring(2, lineno.length());  //去掉“线路”
        } else {
            lineno = "%";
        }
        String sql = "";
        if(flag) {
            sql = "select 'in_call' [types],COUNT(iid) [counts] from cc_callcenter where (ccallstate='打入' or ccallstate='未接来电') " +
                    "and convert(varchar(10),dbegin,23) = " + date + " and crouteline like '" + lineno + "' " +
                    "union " +
                    "select 'in_accept' [types],COUNT(iid) [counts] from CC_callcenter where ccallstate = '打入' " +
                    "and convert(varchar(10),dbegin,23) = " + date + " and crouteline like '" + lineno + "' " +
                    "union " +
                    "select 'in_noaccept' [types],COUNT(iid) [counts] from CC_callcenter where ccallstate = '未接来电' " +
                    "and convert(varchar(10),dbegin,23) = " + date + " and crouteline like '" + lineno + "' " +
                    "union " +
                    "select 'in_deal' [types],COUNT(iid) [counts] from ( " +
                    "select iid,ccallintel,ccallstate,dbegin,crouteline,ideal from CC_callcenter where (ccallstate='打入')  and isnull(ideal,0) <> 0 " +
                    "and LEN(ccallintel) <>  " + iintelcount +
                    "union " +
                    "select iid,ccallintel,ccallstate,dbegin,crouteline,ideal from cc_callcenter where (ccallstate='打入') and LEN(ccallintel) = " + iintelcount + ") A " +
                    "where convert(varchar(10),dbegin,23) = " + date + " and crouteline like '" + lineno + "' " +
                    "union " +
                    "select 'in_nodeal' [types],COUNT(iid) [counts] from CC_callcenter where (ccallstate='打入')  and isnull(ideal,0) = 0 " +
                    "and LEN(ccallintel) <> " + iintelcount + "  and convert(varchar(10),dbegin,23) = " + date + " and crouteline like '" + lineno + "' " +
                    "union " +
                    "select 'in_time' [types],isnull(SUM(DATEDIFF(MINUTE,dbegin,dend)+1),0) [counts] from CC_callcenter where ccallstate = '打入' " +
                    "and convert(varchar(10),dbegin,23) = " + date + " and crouteline like '" + lineno + "' " +
                    "union " +
                    "select 'out_call' [types],COUNT(iid) [counts] from cc_callcenter where ccallstate='打出' " +
                    "and convert(varchar(10),dbegin,23) = " + date + " and crouteline like '" + lineno + "' " +
                    "union " +
                    "select 'out_accept' [types],COUNT(iid) [counts] from CC_callcenter where ccallstate = '打出' " +
                    "and convert(varchar(10),dbegin,23) = " + date + " and crouteline like '" + lineno + "' " +
                    "union " +
                    "select 'out_noaccept' [types],COUNT(iid) [counts] from CC_callcenter where ''<>'' " +
                    "and convert(varchar(10),dbegin,23) = " + date + " and crouteline like '" + lineno + "' " +
                    "union " +
//                    "select 'out_deal' [types],COUNT(iid) [counts] from ( " +
//                    "select iid,ccallouttel,ccallstate,dbegin,crouteline,ideal from CC_callcenter where ccallstate='打出' and isnull(ideal,0) <> 0  " +
//                    "and LEN(ccallouttel) <>  " + iintelcount +
//                    "union " +
//                    "select iid,ccallouttel,ccallstate,dbegin,crouteline,ideal from cc_callcenter where ccallstate='打出' and LEN(ccallouttel) = " + iintelcount + ") A " +
//                    "where convert(varchar(10),dbegin,23) = " + date + " and crouteline like '" + lineno + "' " +
                    "select 'out_deal' [types],COUNT(iid) [counts] from cc_callcenter where ccallstate='打出' " +
                    "and convert(varchar(10),dbegin,23) = " + date + " and crouteline like '" + lineno + "' " +
                    "union " +
//                    "select 'out_nodeal' [types],COUNT(iid) [counts] from CC_callcenter where ccallstate='打出' and LEN(ccallouttel) <>  " + iintelcount +
//                    " and isnull(ideal,0) = 0 and convert(varchar(10),dbegin,23) = " + date + " and crouteline like '" + lineno + "' " +
                    "select 'out_nodeal' [types],COUNT(iid) [counts] from CC_callcenter where '1' <> '1' " +
                    "union " +
                    "select 'out_time' [types],isnull(SUM(DATEDIFF(MINUTE,dbegin,dend)+1),0) [counts] from CC_callcenter where isnull(ccallouttel,'')<>'' and ccallstate = '打出' " +
                    "and convert(varchar(10),dbegin,23) = " + date + " and crouteline like '" + lineno + "' ";
        } else {
            sql = "select 'in_call' [types],COUNT(iid) [counts] from cc_callcenter where (ccallstate='打入' or ccallstate='未接来电') " +
                    "and convert(varchar(10),dbegin,23) = " + date + " and crouteline like '" + lineno + "' " +
                    "union " +
                    "select 'in_accept' [types],COUNT(iid) [counts] from CC_callcenter where ccallstate = '打入' " +
                    "and convert(varchar(10),dbegin,23) = " + date + " and crouteline like '" + lineno + "' " +
                    "union " +
                    "select 'in_noaccept' [types],COUNT(iid) [counts] from CC_callcenter where ccallstate = '未接来电' " +
                    "and convert(varchar(10),dbegin,23) = " + date + " and crouteline like '" + lineno + "' " +
                    "union " +
                    "select 'in_deal' [types],COUNT(iid) [counts] from CC_callcenter "+
                    "where convert(varchar(10),dbegin,23) = " + date + " and crouteline like '" + lineno + "' and isnull(ideal,0)<>0 and (ccallstate='打入')" +
                    "union " +
                    "select 'in_nodeal' [types],COUNT(iid) [counts] from CC_callcenter where (ccallstate='打入')  and isnull(ideal,0) = 0 " +
                    " and convert(varchar(10),dbegin,23) = " + date + " and crouteline like '" + lineno + "' " +
                    "union " +
                    "select 'in_time' [types],isnull(SUM(DATEDIFF(MINUTE,dbegin,dend)+1),0) [counts] from CC_callcenter where ccallstate = '打入' " +
                    "and convert(varchar(10),dbegin,23) = " + date + " and crouteline like '" + lineno + "' " +
                    "union " +
                    "select 'out_call' [types],COUNT(iid) [counts] from cc_callcenter where ccallstate='打出' " +
                    "and convert(varchar(10),dbegin,23) = " + date + " and crouteline like '" + lineno + "' " +
                    "union " +
                    "select 'out_accept' [types],COUNT(iid) [counts] from CC_callcenter where ccallstate = '打出' " +
                    "and convert(varchar(10),dbegin,23) = " + date + " and crouteline like '" + lineno + "' " +
                    "union " +
                    "select 'out_noaccept' [types],COUNT(iid) [counts] from CC_callcenter where ''<>'' " +
                    "and convert(varchar(10),dbegin,23) = " + date + " and crouteline like '" + lineno + "' " +
                    "union " +
                    "select 'out_deal' [types],COUNT(iid) [counts] from CC_callcenter "+
                    "where convert(varchar(10),dbegin,23) = " + date + " and crouteline like '" + lineno + "' and ccallstate='打出' and isnull(ideal,0)<>0 " +
                    "union " +
                    "select 'out_nodeal' [types],COUNT(iid) [counts] from CC_callcenter where ccallstate='打出' "+
                    " and isnull(ideal,0) = 0 and convert(varchar(10),dbegin,23) = " + date + " and crouteline like '" + lineno + "' " +
                    "union " +
                    "select 'out_time' [types],isnull(SUM(DATEDIFF(MINUTE,dbegin,dend)+1),0) [counts] from CC_callcenter where isnull(ccallouttel,'')<>'' and ccallstate = '打出' " +
                    "and convert(varchar(10),dbegin,23) = " + date + " and crouteline like '" + lineno + "' ";
        }


        try {
            list = utilService.exeSql(sql);


        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<HashMap> getLineNo() {
        List<HashMap> list = null;

        String sql = "select '线路'+clineno as clineno from cc_calllineset " +
                "union " +
                "select '全部' as clineno " +
                "order by clineno ";

        try {
            list = utilService.exeSql(sql);


        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;
    }

    public List<HashMap> getDataGrid(HashMap map) {
        List<HashMap> list = null;
        int iintelcount = getSysIntelCount();
        boolean flag = getSysDealIntel();
        String sql = "";
        if(flag) {
            sql = "select distinct iid,dealprogress,ccustname,cstatus,icustomer,ctime,cpersonname,ctelphone,cdeal,dbegin,'线路'+substring(crouteline,5,len(crouteline)) crouteline,cdetail,imstype," +
                    "case when len(ctelphone) = " + iintelcount + " or cstatus in ('打出','未接来电') then '系统管理员' else ideal end ideal," +
                    "case when isnull(ideal,'')='' then '' else convert(varchar(10),ddeal,23) end ddeal,cdegree,area,ordertime from (" +
                    "select cc.iid,cc.dealprogress,cc.ccsname ccustname,cc.ccallstate ,case when ccallstate='摘机' and isnull(ccallintel,'')<>'' then '打入摘机' " +
                    "when ccallstate='摘机' and isnull(ccallouttel,'')<>'' then '打出摘机' else ccallstate end cstatus,cc.icustomer,CONVERT(varchar(10),dbegin,8) ctime,book.cname cpersonname," +
                    "case when isnull(ccallintel,'')='' then ccallouttel else ccallintel end ctelphone, " +
                    "cc.cdeal,convert(varchar(10),cc.dbegin,23) dbegin,cc.crouteline,cc.cdetail,data.cname imstype,person.cname ideal,ddeal,cdegree,cc.area,cc.dbegin ordertime " +
                    "from CC_callcenter cc " +
                    "left join (select tab2.ddate,tab2.ctel,book.cname from (" +
                    "select ctel,MAX(ddate) ddate from (" +
                    "select ctel,case when isnull(dmodify,'')<>'' then dmodify else dmaker end ddate from cc_callbook) tab1 " +
                    "group by tab1.ctel)tab2 " +
                    "left join cc_callbook book on tab2.ctel = book.ctel and (tab2.ddate = book.dmodify or tab2.ddate = book.dmaker)" +
                    ") book on cc.ccallouttel = book.ctel or cc.ccallintel = book.ctel " +
                    "left join (select data.iid,data.ccode,data.cname from aa_data data where iclass = 154) data on cc.imstype = data.ccode " +
                    "left join as_person person on cc.ideal = person.iid " +
                    ")A where 1=1 ";
        } else {
            sql = "select distinct iid,dealprogress,ccustname,cstatus,icustomer,ctime,cpersonname,ctelphone,cdeal,dbegin,'线路'+substring(crouteline,5,len(crouteline)) crouteline,cdetail,imstype," +
                    " ideal,ddeal,cdegree,area,ordertime from (" +
                    "select cc.iid,cc.dealprogress,cc.ccsname ccustname,cc.ccallstate ,case when ccallstate='摘机' and isnull(ccallintel,'')<>'' then '打入摘机' " +
                    "when ccallstate='摘机' and isnull(ccallouttel,'')<>'' then '打出摘机' else ccallstate end cstatus,cc.icustomer,CONVERT(varchar(10),dbegin,8) ctime,book.cname cpersonname," +
                    "case when isnull(ccallintel,'')='' then ccallouttel else ccallintel end ctelphone, " +
                    "cc.cdeal,convert(varchar(10),cc.dbegin,23) dbegin,cc.crouteline,cc.cdetail,data.cname imstype,person.cname ideal,ddeal,cdegree,cc.area,cc.dbegin ordertime " +
                    "from CC_callcenter cc " +
                    "left join (select tab2.ddate,tab2.ctel,book.cname from (" +
                    "select ctel,MAX(ddate) ddate from (" +
                    "select ctel,case when isnull(dmodify,'')<>'' then dmodify else dmaker end ddate from cc_callbook) tab1 " +
                    "group by tab1.ctel)tab2 " +
                    "left join cc_callbook book on tab2.ctel = book.ctel and (tab2.ddate = book.dmodify or tab2.ddate = book.dmaker)" +
                    ") book on cc.ccallouttel = book.ctel or cc.ccallintel = book.ctel " +
                    "left join (select data.iid,data.ccode,data.cname from aa_data data where iclass = 154) data on cc.imstype = data.ccode " +
                    "left join as_person person on cc.ideal = person.iid " +
                    ")A where 1=1 ";
        }
        String condition = "";
        String date = (String) map.get("date");
        if (date.equals("today"))
            condition += " and A.dbegin = convert(varchar(10),getdate(),23) ";
        else
            condition += " and A.dbegin = '" + date + "'";
        String lineno = (String) map.get("lineno");
        if (!lineno.equals("全部")) {
            lineno = lineno.substring(2, lineno.length());  //去掉“线路”
            condition += " and substring(A.crouteline,5," + lineno.length() + ") = '" + lineno + "'";  //去掉“line”
        }
        String type = (String) map.get("type");
        if (!type.equals("全部"))
            if (type.equals("打出"))
                condition += " and A.cstatus like '%" + type + "%' ";
        if (type.equals("打入"))
            condition += " and (A.cstatus like '%" + type + "%' or A.cstatus like '%未接来电%') ";

        sql += condition;

        sql += "order by A.ordertime desc ";


        try {
            list = utilService.exeSql(sql);


        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;


    }

    public List<HashMap> getAllRecordToday(HashMap map) {
        List<HashMap> list = null;
        int iintelcount = getSysIntelCount();
        boolean flag = getSysDealIntel();
        String sql = "";
        if(flag) {
            sql = "select distinct iid,dealprogress,ccustname,cstatus,icustomer,calltime,ctime,cpersonname,ctelphone,cdeal,dbegin,'线路'+substring(crouteline,5,len(crouteline)) crouteline,cdetail,imstype," +
                    "case when len(ctelphone) = "+ iintelcount +" or cstatus in ('打出','未接来电') then '系统管理员' else ideal end ideal, " +
                    "case when isnull(ideal,'')='' then '' else convert(varchar(10),ddeal,23) end ddeal,cdegree,ctype from ( " +
                    "select cc.iid,cc.dealprogress,book.ccsname ccustname,cc.ccallstate ,case when ccallstate='摘机' and isnull(ccallintel,'')<>'' then '打入摘机'  " +
                    "when ccallstate='摘机' and isnull(ccallouttel,'')<>'' then '打出摘机' else ccallstate end cstatus,book.icustomer,CONVERT(varchar(20),dbegin,120) calltime,CONVERT(varchar(8),dbegin,8) ctime,book.cname cpersonname, " +
                    "case when isnull(ccallintel,'')='' then ccallouttel else ccallintel end ctelphone,book.ctype," +
                    "cc.cdeal,convert(varchar(10),cc.dbegin,23) dbegin,cc.crouteline,cc.cdetail,data.cname imstype,person.cname ideal,ddeal,cdegree  " +
                    "from CC_callcenter cc  " +
                    "left join (select tab2.ddate,tab2.ctel,book.cname,book.ctype,book.icustomer,corp.cname ccsname from ( " +
                    "select ctel,MAX(ddate) ddate from ( " +
                    "select ctel,case when isnull(dmodify,'')<>'' then dmodify else dmaker end ddate from cc_callbook) tab1  " +
                    "group by tab1.ctel)tab2  " +
                    "left join cc_callbook book on tab2.ctel = book.ctel and (tab2.ddate = book.dmodify or tab2.ddate = book.dmaker) " +
                    "left join as_corporation corp on book.icustomer = corp.iid " +
                    ") book on cc.ccallouttel = book.ctel or cc.ccallintel = book.ctel  " +
                    "left join (select data.iid,data.ccode,data.cname from aa_data data where iclass = 154) data on cc.imstype = data.ccode  " +
                    "left join as_person person on cc.ideal = person.iid " +
                    ")A where 1=1 ";
        } else {
            sql = "select distinct iid,dealprogress,ccustname,cstatus,icustomer,calltime,ctime,cpersonname,ctelphone,cdeal,dbegin,'线路'+substring(crouteline,5,len(crouteline)) crouteline,cdetail,imstype," +
                    " ideal, ddeal,cdegree,ctype from ( " +
                    "select cc.iid,cc.dealprogress,book.ccsname ccustname,cc.ccallstate ,case when ccallstate='摘机' and isnull(ccallintel,'')<>'' then '打入摘机'  " +
                    "when ccallstate='摘机' and isnull(ccallouttel,'')<>'' then '打出摘机' else ccallstate end cstatus,book.icustomer,CONVERT(varchar(20),dbegin,120) calltime,CONVERT(varchar(8),dbegin,8) ctime,book.cname cpersonname, " +
                    "case when isnull(ccallintel,'')='' then ccallouttel else ccallintel end ctelphone,book.ctype," +
                    "cc.cdeal,convert(varchar(10),cc.dbegin,23) dbegin,cc.crouteline,cc.cdetail,data.cname imstype,person.cname ideal,ddeal,cdegree  " +
                    "from CC_callcenter cc  " +
                    "left join (select tab2.ddate,tab2.ctel,book.cname,book.ctype,book.icustomer,corp.cname ccsname from ( " +
                    "select ctel,MAX(ddate) ddate from ( " +
                    "select ctel,case when isnull(dmodify,'')<>'' then dmodify else dmaker end ddate from cc_callbook) tab1  " +
                    "group by tab1.ctel)tab2  " +
                    "left join cc_callbook book on tab2.ctel = book.ctel and (tab2.ddate = book.dmodify or tab2.ddate = book.dmaker) " +
                    "left join as_corporation corp on book.icustomer = corp.iid " +
                    ") book on cc.ccallouttel = book.ctel or cc.ccallintel = book.ctel  " +
                    "left join (select data.iid,data.ccode,data.cname from aa_data data where iclass = 154) data on cc.imstype = data.ccode  " +
                    "left join as_person person on cc.ideal = person.iid " +
                    ")A where 1=1 ";
        }

        String condition = "";
        if ("1".equals(map.get("itype")))
            condition = " and icustomer = " + map.get("icustomer");
        else
            condition = " and ctelphone = '" + map.get("phone") + "'";
        sql += condition;

        sql += " order by calltime desc";

        try {
            list = utilService.exeSql(sql);


        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;


    }

    public List<HashMap> getContactsInfo(HashMap map) {
        List<HashMap> list = null;

        String sql = "select top 1 book.ctype itype,book.cname names,book.csex sex,book.icustomer,  " +
                "case when isnull(book.ctel,'')='' then book.cmobile else book.ctel end phone,  " +
                "book.icustarea,book.iareaperson,book.isalesdepart,book.isalesperson,  " +
                "area.cname area,h1.ctitle manager,depart.cname department,h2.ctitle salesman, " +
                "cust.caddress address,book.cmemo demo from cc_callbook book  " +
                "left join cs_customerarea area on book.icustarea = area.iid " +
                "left join hr_person h1 on book.iareaperson = h1.iid " +
                "left join hr_department depart on book.isalesdepart = depart.iid " +
                "left join hr_person h2 on book.isalesperson = h2.iid " +
                "left join cs_customer cust on book.icustomer = cust.icorp  " +
                "where book.ctel='" + map.get("num") + "' " +
                " order by book.dmaker desc ";

        try {
            list = utilService.exeSql(sql);


        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;

    }

    public String updateInfo(HashMap map) {
        String returns="";
        String cdetail = "";
        if (map.get("cdetail") != null)
            cdetail = map.get("cdetail").toString();
        String cdeal = "";
        if (map.get("cdeal") != null)
            cdeal = map.get("cdeal").toString();
        String imstype = "";
        if (map.get("imstype") != null)
            imstype = map.get("imstype").toString();
        String dealprogress = "";
        if (map.get("dealprogress") != null)
            dealprogress = map.get("dealprogress").toString();
        String cdegree = "";
        if (map.get("cdegree") != null)
            cdegree = map.get("cdegree").toString();
        String area = "";
        if (map.get("area") != null)
            area = map.get("area").toString();

        String sql = "update CC_callcenter set cdetail = '" + cdetail + "',cdeal='" + cdeal + "',imstype='" + imstype + "',dealprogress='" + dealprogress +
                "',cdegree='" + cdegree + "',imaker='"+  map.get("userid")  +"',ideal='" + map.get("userid") + "',dmaker='" + map.get("ddeal") + "',imodify='" + map.get("userid") + "',dmodify='" + map.get("ddeal") + "',ddeal='" + map.get("ddeal") + "',area = '" + area + "' where 1=1 ";
        if ( Integer.parseInt(map.get("iid").toString()) > 0)   //已有记录处理
        {
            sql = sql + " and iid = " + map.get("iid");
        }
        //呼入呼出电话处理
        else {
            sql = sql + " and ichannel = " + map.get("ichannel") + " and (ccallintel = '" + map.get("ctel") + "' or ccallouttel = '" + map.get("ctel") + "') and convert(varchar(19),dbegin,20) = convert(varchar(19),'" + map.get("dbegin") + "',20)";
        }


        try {
           utilService.exeSql(sql);

           returns = "success";

        } catch (Exception e) {
            e.printStackTrace();
        }

        return returns;

    }

    public List<HashMap> rollbackDeal(HashMap map) {
        List<HashMap> list = null;


        String sql = "update CC_callcenter set ideal='',ddeal='',imodify='',dmodify='' where 1=1 ";
        if (Integer.parseInt(map.get("iid").toString()) > 0)   //已有记录处理
        {
            sql = sql + " and iid = " + map.get("iid");
        }
        //呼入呼出电话处理
        else {
            sql = sql + " and ichannel = " + map.get("ichannel") + " and (ccallintel = '" + map.get("ctel") + "' or ccallouttel = '" + map.get("ctel") + "') and convert(varchar(19),dbegin,20) = convert(varchar(19),'" + map.get("dbegin") + "',20)";
        }

        try {
            list = utilService.exeSql(sql);


        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;

    }

    public List<HashMap> getBookByInfo(HashMap map) {
        List<HashMap> list = null;
        String names = "";
        if (map.get("names") != null)
            names = (String) map.get("names");

        int icustomer = 0;
        if (map.get("icustomer") != null)
            icustomer = Integer.parseInt(map.get("icustomer").toString());

        String phone = "";
        if (map.get("phone") != null)
            phone = (String) map.get("phone");

        String sql = "select iid from cc_callbook where ctel = '" + phone + "' and icustomer = " + icustomer + " and cname = '" + names + "'";

        try {
            list = utilService.exeSql(sql);


        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;

    }

    public List<HashMap> getPersonByInfo(HashMap map) {
        List<HashMap> list = null;
        String names = "";
        if (map.get("names") != null)
            names = (String) map.get("names");

        int icustomer = 0;
        if (map.get("icustomer") != null)
            icustomer = Integer.parseInt(map.get("icustomer").toString());

        String phone = "";
        if (map.get("phone") != null)
            phone = (String) map.get("phone");

        String sql = "select iid from hr_person where (ctel = '" + phone + "' or cmobile = '" + phone + "') and icorp = " + icustomer + " and ctitle = '" + names + "'";

        try {
            list = utilService.exeSql(sql);


        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;

    }

    public HashMap updateBookInfo(HashMap map) {
        HashMap returnmap = new HashMap();
        HashMap parammap = new HashMap();
        HashMap idmap = new HashMap();

        try {
            List list = getBookByInfo(map);

            if (list.size() >= 1) {
                returnmap.put("rvalue", "人员信息重复，无法更新人员档案！");
            } else {
                String sql = "";
                List rlist = null;
                if (list.size() > 0) {
                    //update
                    idmap = (HashMap) list.get(0);
                    sql = "update cc_callbook set ctel = '" + map.get("phone") + "',imodify = " + map.get("uid") + ",dmodify = GETDATE(),cname = '" + map.get("names") + "',icustomer = " + map.get("icustomer") + "," +
                            "cdepartment = '" + map.get("department") + "',cpost = '',ctype = '" + map.get("itype") + "',csex = '" + map.get("sex") + "',icustarea = " + map.get("area") + ",cmemo = '" + map.get("demo") + "' " +
                            "where iid = " + idmap.get("iid") + ";";

                    sql += "update cc_callcenter set ccsname = a.cname from as_corporation a where a.iid = " + map.get("icustomer");
                    if (Integer.parseInt(map.get("iid").toString()) > 0) {
                        sql += " and cc_callcenter.iid = " + map.get("iid") + ";";
                    } else {
                        sql = sql + " and ichannel = " + map.get("ichannel") + " and (ccallintel = '" + map.get("ctel") + "' or ccallouttel = '" + map.get("ctel") + "') and convert(varchar(19),dbegin,20) = convert(varchar(19),'" + map.get("dbegin") + "',20)";
                    }
                    rlist = utilService.exeSql(sql);
                    returnmap.put("rvalue", "人员信息更新成功！");
                    ;
                } else {
                    //insert
                    sql = "insert into cc_callbook(ctel,imaker,dmaker,cname,icustomer,cdepartment,cpost,ctype,csex,cmemo) " +
                            "values('" + map.get("phone") + "'," + map.get("uid") + ",getdate(),'" + map.get("names") + "'," + map.get("icustomer") + ",'" + map.get("department") + "','','" + map.get("itype") + "'," +
                            "'" + map.get("sex") + "','" + map.get("demo") + "')";

                    sql += "update cc_callcenter set ccsname = a.cname from as_corporation a where a.iid = " + map.get("icustomer");
                    if (Integer.parseInt(map.get("iid").toString()) > 0) {
                        sql += " and cc_callcenter.iid = " + map.get("iid") + ";";
                    } else {
                        sql = sql + " and ichannel = " + map.get("ichannel") + " and (ccallintel = '" + map.get("ctel") + "' or ccallouttel = '" + map.get("ctel") + "') and convert(varchar(19),dbegin,20) = convert(varchar(19),'" + map.get("dbegin") + "',20)";
                    }
                    rlist = utilService.exeSql(sql);

                    returnmap.put("rvalue", "人员信息插入成功！");

                }
            }
        } catch (Exception e) {
            returnmap.put("rvalue", "操作失败！");
            e.printStackTrace();
        }
        return returnmap;
    }

    public HashMap updatePersonInfo(HashMap map) {
        HashMap returnmap = new HashMap();
        HashMap parammap = new HashMap();
        HashMap idmap = new HashMap();

        try {
            List list = getPersonByInfo(map);

            if (list.size() > 1) {
                returnmap.put("rvalue", "人员信息重复，无法更新人员档案！");
            } else {
                String sql = "";
                List rlist = null;
                if (list.size() > 0) {
                    //update
                    idmap = (HashMap) list.get(0);
                    sql = "update hr_person set ctel = '" + map.get("phone") + "',ctitle = '" + map.get("names") + "',icorp = " + map.get("icustomer") + "," +
                            "isex = '" + map.get("sex") + "' where iid = " + idmap.get("iid") + ";";

                    rlist = utilService.exeSql(sql);
                    returnmap.put("rvalue", "经销商信息已更新！");
                    ;
                } else {
                    //insert
                    sql = "insert into hr_person(ctel,icorp,ctitle,isex) " +
                            "values('" + map.get("phone") + "'," + map.get("icustomer") + ",'" + map.get("names") + "','" + map.get("sex") + "')";

                    rlist = utilService.exeSql(sql);

                    returnmap.put("rvalue", "经销商信息已插入！");

                }
            }
        } catch (Exception e) {
            returnmap.put("rvalue", "操作失败！");
            e.printStackTrace();
        }
        return returnmap;
    }

    public String getOutNum(HashMap map) {
        //String phoneNum = (String)map.get("callnum");
        String callNum = (String) map.get("callnum");
        List<HashMap> list = null;
        String outNum = "";
        int iintelcount = getSysIntelCount();
        //boolean flag = getSysDealIntel();
        String sql = " select cvalue from as_options where iid='2002' ";

        try {
            list = utilService.exeSql(sql);
            if (list.size() > 0) {
                outNum = (String) list.get(0).get("cvalue");
            }


                if (callNum.length() < iintelcount) {
                    //内部号码
                } else {
                    String results = Mobile.getMobileNoTrack(callNum);
                    if(results.indexOf(" ") == -1) {    //查不到记录
                          //号码不变
                    }
                    else if (results.split(" ").length > 0) {
                        results = results.split(" ")[1];
                        if (!results.equals("徐州")) { //本地手机
                            callNum = outNum + "0" + callNum;
                        } else {
                            callNum = outNum + callNum;
                        }
                    } else {
                        callNum = outNum + callNum;
                    }
                }



        } catch (Exception e) {
            e.printStackTrace();
        }

        return callNum;

    }

    public List<HashMap> getDataGridBylabel(HashMap map) {
        List<HashMap> list = null;
        int iintelcount = getSysIntelCount();
        boolean flag = getSysDealIntel();
        String sql = "";
        if(flag) {
            sql = "select distinct iid,dealprogress,ccustname,cstatus,icustomer,ctime,cpersonname,ctelphone,cdeal,dbegin,'线路'+substring(crouteline,5,len(crouteline)) crouteline,cdetail,imstype," +
                    "case when len(ctelphone) = "+ iintelcount +" or cstatus in ('打出','未接来电') then '系统管理员' else ideal end ideal," +
                    "case when isnull(ideal,'')='' then '' else convert(varchar(10),ddeal,23) end ddeal,cdegree,area,ordertime from (" +
                    "select cc.iid,cc.dealprogress,cc.ccsname ccustname,cc.ccallstate ,case when ccallstate='摘机' and isnull(ccallintel,'')<>'' then '打入摘机' " +
                    "when ccallstate='摘机' and isnull(ccallouttel,'')<>'' then '打出摘机' else ccallstate end cstatus,cc.icustomer,CONVERT(varchar(10),dbegin,8) ctime,book.cname cpersonname," +
                    "case when isnull(ccallintel,'')='' then ccallouttel else ccallintel end ctelphone, " +
                    "cc.cdeal,convert(varchar(10),cc.dbegin,23) dbegin,cc.crouteline,cc.cdetail,data.cname imstype,person.cname ideal,ddeal,cdegree,cc.area,cc.dbegin ordertime " +
                    "from CC_callcenter cc " +
                    "left join (select tab2.ddate,tab2.ctel,book.cname from (" +
                    "select ctel,MAX(ddate) ddate from (" +
                    "select ctel,case when isnull(dmodify,'')<>'' then dmodify else dmaker end ddate from cc_callbook) tab1 " +
                    "group by tab1.ctel)tab2 " +
                    "left join cc_callbook book on tab2.ctel = book.ctel and (tab2.ddate = book.dmodify or tab2.ddate = book.dmaker)" +
                    ") book on cc.ccallouttel = book.ctel or cc.ccallintel = book.ctel " +
                    "left join (select data.iid,data.ccode,data.cname from aa_data data where iclass = 154) data on cc.imstype = data.ccode " +
                    "left join as_person person on cc.ideal = person.iid " +
                    ")A where 1=1 ";
        } else {
            sql = "select distinct iid,dealprogress,ccustname,cstatus,icustomer,ctime,cpersonname,ctelphone,cdeal,dbegin,'线路'+substring(crouteline,5,len(crouteline)) crouteline,cdetail,imstype," +
                    " ideal, ddeal,area,ordertime from (" +
                    "select cc.iid,cc.dealprogress,cc.ccsname ccustname,cc.ccallstate ,case when ccallstate='摘机' and isnull(ccallintel,'')<>'' then '打入摘机' " +
                    "when ccallstate='摘机' and isnull(ccallouttel,'')<>'' then '打出摘机' else ccallstate end cstatus,cc.icustomer,CONVERT(varchar(10),dbegin,8) ctime,book.cname cpersonname," +
                    "case when isnull(ccallintel,'')='' then ccallouttel else ccallintel end ctelphone, " +
                    "cc.cdeal,convert(varchar(10),cc.dbegin,23) dbegin,cc.crouteline,cc.cdetail,data.cname imstype,person.cname ideal,ddeal,cdegree,cc.area,cc.dbegin ordertime " +
                    "from CC_callcenter cc " +
                    "left join (select tab2.ddate,tab2.ctel,book.cname from (" +
                    "select ctel,MAX(ddate) ddate from (" +
                    "select ctel,case when isnull(dmodify,'')<>'' then dmodify else dmaker end ddate from cc_callbook) tab1 " +
                    "group by tab1.ctel)tab2 " +
                    "left join cc_callbook book on tab2.ctel = book.ctel and (tab2.ddate = book.dmodify or tab2.ddate = book.dmaker)" +
                    ") book on cc.ccallouttel = book.ctel or cc.ccallintel = book.ctel " +
                    "left join (select data.iid,data.ccode,data.cname from aa_data data where iclass = 154) data on cc.imstype = data.ccode " +
                    "left join as_person person on cc.ideal = person.iid " +
                    ")A where 1=1 ";
        }
        String condition = "";
        String date = (String) map.get("date");
        if (date.equals("today"))
            condition += " and A.dbegin = convert(varchar(10),getdate(),23) ";
        else
            condition += " and A.dbegin = '" + date + "'";
        String lineno = (String) map.get("lineno");
        if (!lineno.equals("全部")) {
            lineno = lineno.substring(2, lineno.length());  //去掉“线路”
            condition += " and substring(A.crouteline,5," + lineno.length() + ") = '" + lineno + "'";  //去掉“line”
        }
//        String type = (String) map.get("type");
//        if (!type.equals("全部"))
//            if (type.equals("打出"))
//                condition += " and A.cstatus like '%" + type + "%' ";
//        if (type.equals("打入"))
//            condition += " and (A.cstatus like '%" + type + "%' or A.cstatus like '%未接来电%') ";


        String lab = (String) map.get("lab");
        if (lab.equals("lb_in_call"))
            condition += " and (A.cstatus like '%打入%' or A.cstatus like '%未接来电%') ";
        if (lab.equals("lb_in_accept"))
            condition += " and (A.cstatus like '%打入%' ) ";
        if (lab.equals("lb_in_noaccept"))
            condition += " and ( A.cstatus like '%未接来电%') ";
        if (lab.equals("lb_in_deal"))
            condition += " and (A.cstatus like '%打入%') and (ISNULL(ideal,'')<>'' or  len(A.ctelphone) = "+ iintelcount +") ";
        if (lab.equals("lb_in_nodeal"))
            condition += " and (A.cstatus like '%打入%') and ISNULL(ideal,'') = '' and len(A.ctelphone) <>  "+ iintelcount ;
        if (lab.equals("lb_out_call"))
            condition += " and (A.cstatus like '%打出%' ) ";
        if (lab.equals("lb_out_accept"))
            condition += " and (A.cstatus like '%打出%' ) ";
        if (lab.equals("lb_out_noaccept"))      //不存在打出未接的情况
            condition += " and (1<>1) ";
        if (lab.equals("lb_out_deal"))
            condition += " and (A.cstatus like '%打出%' ) and (ISNULL(ideal,'') <> '' or  len(A.ctelphone) = "+ iintelcount +") ";
        if (lab.equals("lb_out_nodeal"))
            condition += " and (A.cstatus like '%打出%' )  and ISNULL(ideal,'') = '' and len(A.ctelphone) <> "+ iintelcount ;


        sql += condition;

        sql += " order by ordertime desc ";


        try {
            list = utilService.exeSql(sql);


        } catch (Exception e) {
            e.printStackTrace();
        }

        return list;


    }

    public int getSysIntelCount() {
        int iintelCount = 0;
        String sql = " select cvalue from as_options where iid in ('2204') ";

        try {
            List list = utilService.exeSql(sql);
            if (list.size() > 0) {
                HashMap<String,String> map = (HashMap) list.get(0);
                iintelCount = Integer.parseInt(map.get("cvalue"));
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return iintelCount;

    }

    public boolean getSysDealIntel() {
        boolean flag = false;
        String sql = " select cvalue from as_options where iid in ('2205') ";

        try {
            List list = utilService.exeSql(sql);
            if (list.size() > 0) {
                HashMap<String,String> map = (HashMap) list.get(0);
                flag = ((map.get("cvalue")).equals("0")?false:true);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return flag;

    }

    public HashMap getRecordId(HashMap param) {
        int ichannel = Integer.parseInt(param.get("line").toString());
        String time = param.get("callinfulltime").toString();
        String sql = " select iid ccid,ISNULL(icustomer,0)icustomer from cc_callcenter where ichannel = "+ ichannel + " and dbegin = '"+ time +"' ";
        HashMap<String,String> map = new HashMap<String, String>();

        try {
            List list = utilService.exeSql(sql);
            if (list.size() > 0) {
                map = (HashMap) list.get(0);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return map;

    }
}
