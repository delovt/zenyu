package yssoft.impls;

import java.io.IOException;
import java.io.Reader;
import java.io.Serializable;
import java.sql.SQLException;
import java.util.*;

import flex.messaging.io.amf.ASObject;
import yssoft.daos.BaseDao;
import yssoft.services.ICommonalityService;
import yssoft.services.Iab_invoiceuserService;
import yssoft.services.UtilService;
import yssoft.utils.LogOperateUtil;
import flex.messaging.io.ArrayCollection;
import flex.messaging.io.ArrayList;
import yssoft.utils.ToolUtil;

/**
 * 公共框架所需的实现类
 *
 * @author zhong_jing
 */
public class CommonalityServiceImpl extends BaseDao implements
        ICommonalityService {

    /**
     *
     */
    private static final long serialVersionUID = -1707187574430724518L;
    private UtilService utilservice;
    public void setUtilservice(UtilService utilservice) {
        this.utilservice = utilservice;
    }
    private Iab_invoiceuserService i_ab_invoiceuserService;

    public void setI_ab_invoiceuserService(
            Iab_invoiceuserService i_ab_invoiceuserService) {
        this.i_ab_invoiceuserService = i_ab_invoiceuserService;
    }

    /**
     * 判断数据类型
     *
     * @param paramObj 包含字段，表名
     * @return 数据类型
     */
    @SuppressWarnings("rawtypes")
	public List getItype(HashMap paramObj) {
        // 查询数据类型
        return this.queryForList("commonality.itype", paramObj);
        // 判断是否为空

    }

    /**
     * 动态拼装查询语句 创建者：zhong_jing 创建时间：2011-8-16 下午05:26:43 修改者： 修改时间： 修改备注：
     *
     * @param sql SQL语句
     * @return 查询值
     * @throws Exception List<HashMap>
     * @Exception 异常对象
     */
    @SuppressWarnings("rawtypes")
	public List assemblyQuerySql(String sql) throws Exception {
        return this.queryForList("assembly_query_sql", sql);
    }

    /**
     * 查询单据信息
     *
     * @param
     * @return 单据信息
     * @throws Exception
     */
    @SuppressWarnings({ "unchecked", "rawtypes", "unused" })
	public HashMap queryVouch(HashMap param) throws Exception {

        HashMap resultMap = new HashMap();
        int ifuncregedit = Integer
                .valueOf(param.get("ifuncregedit").toString());
        List vouchList = this.queryForList("query_vouch", ifuncregedit);

        StringBuffer sql = new StringBuffer();
        sql.append("select * from ac_tableRelationship where ifuncregedit=");
        sql.append(ifuncregedit);
        List tableList = this.assemblyQuerySql(sql.toString());
        resultMap.put("tableMessage", tableList);

        List vouchFormList;
        // 查询单据信息
        if (null != vouchList && vouchList.size() > 0) {
            resultMap.put("vouch", vouchList.get(0));

            HashMap vouchMap = (HashMap) vouchList.get(0);
            HashMap vouchForm = new HashMap();
            int ivouch = Integer.valueOf(vouchMap.get("iid").toString());
            vouchForm.put("ivouch", ivouch);
            vouchForm.put("ifuncregedit", ifuncregedit);

            vouchFormList = param.containsKey("vouchForm") ? (List) param.get("vouchForm") : this.queryVouchForm(vouchForm);
            resultMap.put("vouchForm", vouchFormList);

            String ctableSql = "select ctable from ac_vouchform where " +
                    "ivouch=" + ivouch + " and bmain=0 and iobjecttype!=8 and ctable" +
                    " is not null and ipgroup not in" +
                    "(select iid from ac_vouchform where ivouch=" + ivouch + " and iobjecttype=8) group by ctable";
            List ctableList = this.assemblyQuerySql(ctableSql);
            if (ctableList.size() > 0) {
                HashMap childFieldMap = new HashMap();
                for (int i = 0; i < ctableList.size(); i++) {
                    HashMap ctableMap = (HashMap) ctableList.get(i);
                    String fieldSql = "select cfield,vf.cobjectname,v.cobjectname maincobjectname from ac_vouchform vf left join " +
                            "ac_datadictionary d on vf.idatadictionary=d.iid" +
                            " left join ac_vouchform v on v.iid=vf.ipgroup " +
                            " where d.ifuncregedit=" +
                            ifuncregedit +
                            " and d.ctable ='" + ctableMap.get("ctable").toString() + "' and vf.ivouch=" + ivouch + " order by v.igroupno";
                    List fildList = this.assemblyQuerySql(fieldSql);
                    childFieldMap.put(ctableMap.get("ctable").toString(), fildList);
                }
                resultMap.put("childTable", childFieldMap);
            }
            // 查询所有表头的列
            HashMap mainMap = getMainSql(tableList, ivouch, ifuncregedit);
            resultMap.put("mainSql", mainMap);

            List tableMapList = getChildSql(tableList, ivouch, ifuncregedit);
            resultMap.put("childSql", tableMapList);

            if (param.containsKey("iid") || param.containsKey("paramObj")) {

                HashMap result;
                HashMap mainValue;
                if (param.containsKey("iid")) {
                    HashMap paramObj = new HashMap();
                    paramObj.put("childSql", tableMapList);
                    String mainSql = mainMap.get("selectSql").toString();
                    paramObj.put("selectSql", mainSql);
                    for (int i = 0; i < tableList.size(); i++) {
                        HashMap tableMap = (HashMap) tableList.get(i);
                        if (Boolean.valueOf(tableMap.get("bMain").toString())) {
                            paramObj.put(tableMap.get("foreignKey"), param
                                    .get("iid"));
                        }
                    }
                    result = queryPm(paramObj);
                    mainValue = (HashMap) result.get("mainValue");
                    resultMap.put("value", result);
                } else {
                    mainValue = (HashMap) param.get("paramObj");
                }

                for (Object object : vouchFormList) {
                    HashMap vouchFormMap = (HashMap) object;
                    if (vouchFormMap.get("childMap") instanceof List
                            && null != vouchFormMap.get("childMap")) {
                        List childMapList = (List) vouchFormMap.get("childMap");
                        for (int i = 0; i < childMapList.size(); i++) {
                            HashMap childMap = (HashMap) childMapList.get(i);
                            // 说明是拉式生单
                            if (null != childMap.get("cfield")
                                    && childMap.get("cfield").toString()
                                    .equals("iinvoice")
                                    && null != childMap.get("cconsultfunction")
                                    && !"".equals(childMap.get(
                                    "cconsultfunction").toString())
                                    && null != mainValue.get("ifunconsult")
                                    && !"0".equals(mainValue.get("ifunconsult") + "")) {
                                int ifunconsult = Integer.valueOf(mainValue
                                        .get("ifunconsult").toString());
                                childMap.put("iconsult", ifunconsult);

                                // 查询参照sql
                                String sqlStr = "select case when itype=0 then ctreesql else REPLACE(cgridsql,'@join','') "
                                        + "end consultSql,itype  from dbo.ac_consultset where iid="
                                        + ifunconsult;
                                HashMap p = (HashMap) this.assemblyQuerySql(
                                        sqlStr).get(0);
                                childMap.put("consultSql", p.get("consultSql")
                                        .toString());
                                childMap.put("itype", Integer.valueOf(p.get(
                                        "itype").toString()));

                                // 在查询参照信息
                                String sqlStr2 = "select * from AC_relationship where ifuncregedit="
                                        + ifuncregedit
                                        + " and ifuncregedit2="
                                        + mainValue.get("ifuncregedit")
                                        .toString() + " and (bpull=1 or bpush=1)";
                                HashMap p2 = (HashMap) this.assemblyQuerySql(
                                        sqlStr2).get(0);
                                String cconsultbkfld = p2.get("cconsultbkfld")
                                        .toString();
                                childMap.put("cconsultbkfld", cconsultbkfld);
                                childMap.put("cconsultswfld", p2.get(
                                        "cconsultswfld").toString());
                                String cconsultipvf = p2.get("cconsultipvf")
                                        .toString();
                                childMap.put("cconsultipvf", p2.get(
                                        "cconsultipvf").toString());
                                childMap.put("cconsultconfld", p2
                                        .get("cconsultconfld"));
                                childMap.put("cconsultcondition", p2
                                        .get("cconsultcondition"));

                                // 查询返回表名
                                String sqlStr3 = "select ctable from as_funcregedit where iid="
                                        + ifuncregedit;
                                HashMap p3 = (HashMap) this.assemblyQuerySql(
                                        sqlStr3).get(0);
                                childMap.put("cconsulttable", p3.get("ctable")
                                        .toString());
                                break;
                            }
                        }
                    }
                }
            }

        }
        List writeLit = this.queryWrite(ifuncregedit);
        if (writeLit.size() > 0) {
            resultMap.put("writeMap", getWriteSql(writeLit));
            resultMap.put("writeLit", writeLit);
        }
        return resultMap;
    }

    // 获得表头查询语句
    @SuppressWarnings({ "unchecked", "rawtypes" })
	private HashMap getMainSql(List tableList, int ivouch, int ifuncregedit)
            throws Exception {
        // 找到所有列
        StringBuffer sqlStr = new StringBuffer();

        sqlStr
                .append("select vf.iid,vf.bmain,vf.ctable,d.cfield,dt.ctype,d.ilength,d.bprefix,"
                        + "vf.ccaption,vf.idecimal,vf.bunnull,vf.bread,vf.beditread,case when vf.cnewdefaultfix is null "
                        + "then vf.cnewdefault else vf.cnewdefaultfix end cnewdefault,vf.ceditdefault,vf.cobjectname,"
                        + "vf.iobjecttype,ct.ctype,vf.igroupno,vf.igrouprow,vf2.cobjectname ipgroup,vf.ichildno,vf.iwidth,"
                        + "vf.iheight,vf.bshow,vf.idatetype,d.bwfentry,d.bwfcd,d.cregularfunction,"
                        + "d.cregularmessage,d.cunique,REPLACE(d.cfunction,'`','''') cfunction,REPLACE(d.cresfunction,'`','''') cresfunction,"
                        + "d.cresmessage,d.binvoiceuser,cc.iconsult,case "
                        + "when c.itype=0 then c.ctreesql else REPLACE(c.cgridsql,'@join','') "
                        + "end consultSql,c.itype,c.bdataauth,cc.cconsulttable,cc.cconsultbkfld,"
                        + "cc.cconsultswfld,cc.cconsultipvf,cc.bconsultmtbk,cc.bconsultendbk,"
                        + "cc.bconsultcheck,cc.cconsultconfld,"
                        + "bdataauth,cc.cconsultcondition,d.bintitle "
                        + "from AC_vouchform vf left join AC_datadictionary d "
                        + "on vf.idatadictionary=d.iid left join as_datatype dt on "
                        + "dt.iid = d.idatatype left join Ac_consultConfiguration cc on "
                        + "cc.idatadictionary = d.iid left join ac_consultset c "
                        + "on c.iid=cc.iconsult "
                        + " left join ac_vouchform vf2 "
                        + "on vf.ipgroup=vf2.iid left join as_controltype ct on vf.iobjecttype=ct.iid "
                        + "where vf.ivouch=" + ivouch + " and vf.ctable='");

        String ctable = "";
        for (int i = 0; i < tableList.size(); i++) {
            HashMap tableMap = (HashMap) tableList.get(i);
            boolean bmain = Boolean.valueOf(tableMap.get("bMain").toString());
            if (bmain) {
                ctable = tableMap.get("ctable").toString();
                break;
            }
        }
        sqlStr.append(ctable);
        sqlStr.append("' and ct.ctype!='DataGrid'");
        List coloumnList = this.assemblyQuerySql(sqlStr.toString());

        return getSqlList(coloumnList, tableList, true, ifuncregedit);
    }

    // 查询表体列
    @SuppressWarnings({ "unchecked", "rawtypes" })
	public List getChildSql(List tableList, int ivouch, int ifuncregedit)
            throws Exception {
        List sqlList = new ArrayList();
        for (Object tableobject : tableList) {

            HashMap tableMap = (HashMap) tableobject;

            boolean bMain = (tableMap.get("bMain") == null ? false : Boolean
                    .valueOf(tableMap.get("bMain").toString()));
            if (null != tableMap.get("ctable") && !bMain) {

                String sql = "select vf.iid,vf.bmain,vf.ctable,d.cfield,dt.ctype,d.ilength,d.bprefix,"
                        + "vf.ccaption,vf.idecimal,isnull(vf.bunnull,0) bunnull,isnull(vf.bread,0) bread,isnull(vf.beditread,0) beditread,case when vf.cnewdefaultfix is null "
                        + "then vf.cnewdefault else vf.cnewdefaultfix end cnewdefault,vf.ceditdefault,vf.cobjectname,"
                        + "vf.iobjecttype,ct.ctype,vf.igroupno,vf.igrouprow,vf2.cobjectname ipgroup,vf.ichildno,vf.iwidth,"
                        + "vf.iheight,vf.bshow,vf.idatetype,d.bwfentry,d.bwfcd,d.cregularfunction,"
                        + "d.cregularmessage,d.cunique,REPLACE(d.cfunction,'`','''') cfunction,REPLACE(d.cresfunction,'`','''') cresfunction,"
                        + "d.cresmessage,d.binvoiceuser,cc.iconsult,case "
                        + "when c.itype=0 then c.ctreesql else REPLACE(c.cgridsql,'@join','') "
                        + "end consultSql,c.itype,c.bdataauth,cc.cconsulttable,cc.cconsultbkfld,"
                        + "cc.cconsultswfld,cc.cconsultipvf,cc.bconsultmtbk,cc.bconsultendbk,"
                        + "cc.bconsultcheck,cc.cconsultconfld, "
                        + "bdataauth,cc.cconsultcondition,d.bintitle "
                        + "from AC_vouchform vf left join AC_datadictionary d "
                        + "on vf.idatadictionary=d.iid left join as_datatype dt on "
                        + "dt.iid = d.idatatype left join Ac_consultConfiguration cc on "
                        + "cc.idatadictionary = d.iid left join ac_consultset c "
                        + "on c.iid=cc.iconsult "
                        + " left join ac_vouchform vf2 "
                        + "on vf.ipgroup=vf2.iid left join as_controltype ct on vf.iobjecttype=ct.iid "
                        + "where vf.ivouch="
                        + ivouch
                        + " and vf.ctable='"
                        + tableMap.get("ctable").toString()
                        + "' and ct.ctype!='DataGrid'";

                List coloumnList = this.assemblyQuerySql(sql);

                if (null != coloumnList && coloumnList.size() > 0) {
                    HashMap coloumnMap = new HashMap();
                    coloumnMap.put(tableMap.get("ctable").toString(), getSqlList(coloumnList, tableList, false, ifuncregedit));
                    // 查询所有的约束只读控制
                    HashMap creParam = new HashMap();
                    creParam.put("ctable", tableMap.get("ctable").toString());
                    creParam.put("ifuncregedit", tableMap.get("ifuncregedit")
                            .toString());
                    coloumnMap.put("cresfunctionreadMap", this.queryForList(
                            "query_cresfunctionread", creParam));
                    sqlList.add(coloumnMap);
                }
            }
        }
        return sqlList;
    }

    // 修改人：王炫皓
    // 修改时间：2012-11-19
    // insert update 不执行iid
    @SuppressWarnings("rawtypes")
	public HashMap getSqlList(List<HashMap> coloumnList, List<HashMap> tableList, boolean bmain,
                              int ifuncregedit) {
        HashMap result = new HashMap();
        try {
            // 查询sql语句
            StringBuffer selectSql = new StringBuffer();
            selectSql.append("select ");

            // 修改语句
            StringBuffer updateSql = new StringBuffer();
            updateSql.append("update ");
            StringBuffer updateColoumnSql = new StringBuffer();

            // 新增语句
            StringBuffer insertSql = new StringBuffer();
            insertSql.append("insert into ");
            StringBuffer insertColoumnSql = new StringBuffer();
            StringBuffer insertValueSql = new StringBuffer();

            int count = 0;
            String ctable = "";
            String mainTable = "";
            HashMap thisTableMap = null; //当前表关系信息

            ctable = coloumnList.get(0).get("ctable").toString().trim();

            for (HashMap hm:tableList){
                if(Boolean.parseBoolean(hm.get("bMain").toString()) == true){
                    mainTable = (String) hm.get("ctable");
                    break;
                }
            }

            for (HashMap tableobject : tableList) {
                if (tableobject.get("ctable").toString().toUpperCase().equals(
                        ctable.toUpperCase())) {
                    thisTableMap = tableobject;
                }
            }

            int size = 0;
            StringBuffer selectleftjoin = new StringBuffer();

            for (HashMap coloumnMap : coloumnList) {
                if (count > 0) {
                    selectSql.append(",");
                    if (!"iid".equals(coloumnMap.get("cfield").toString()
                            .trim())) {
                        updateColoumnSql.append(",");
                    }
                    if (!"iid".equals(coloumnMap.get("cfield").toString()
                            .trim())) {
                        if (!insertValueSql.toString().isEmpty()) {
                            insertValueSql.append(",");
                            insertColoumnSql.append(",");
                        }

                    }

                }
                String ctype = coloumnMap.get("ctype").toString();

                if (ctype.equals("bit")) {
                    selectSql.append("isnull(");
                }
                selectSql.append(ctable);
                selectSql.append(".");
                // 查询
                selectSql.append(coloumnMap.get("cfield").toString().trim());

                if (ctype.equals("bit")) {
                    selectSql.append(",0) ");
                    selectSql
                            .append(coloumnMap.get("cfield").toString().trim());
                }

                if (!bmain
                        && !Boolean.valueOf(coloumnMap.get("bread").toString())) {
                    selectSql.append(",0 "
                            + coloumnMap.get("cfield").toString().trim()
                            + "_enabled");
                }
                if (!bmain
                        && null != coloumnMap.get("iconsult")
                        && Integer.valueOf(coloumnMap.get("iconsult")
                        .toString()) > 0) {
                    String cfield = coloumnMap.get("cfield").toString().trim();
                    // 列
                    selectSql
                            .append(","
                                    + coloumnMap.get("cconsulttable")
                                    .toString() + size);
                    selectSql.append(".");
                    selectSql
                            .append(coloumnMap.get("cconsultswfld").toString());
                    selectSql.append(" " + cfield + "_Name");

                    // 左连接
                    selectleftjoin.append(" left join ");
                    selectleftjoin.append("(");
                    selectleftjoin.append(coloumnMap.get("consultSql")
                            .toString().replace("@condition", "").replace(
                                    "@childsql", ""));
                    selectleftjoin.append(")");
                    selectleftjoin
                            .append(" "
                                    + coloumnMap.get("cconsulttable")
                                    .toString() + size);
                    selectleftjoin.append(" on ");
                    selectleftjoin.append(ctable);
                    selectleftjoin.append(".");
                    selectleftjoin.append(cfield);
                    selectleftjoin.append("=");
                    selectleftjoin.append(coloumnMap.get("cconsulttable")
                            .toString()
                            + size);
                    selectleftjoin.append(".");
                    selectleftjoin.append(coloumnMap.get("cconsultbkfld")
                            .toString());
                    if (null != coloumnMap.get("cconsultconfld")
                            && !"".equals(coloumnMap.get("cconsultconfld")
                            .toString())) {
                        String cconsultconfld = coloumnMap
                                .get("cconsultconfld").toString();
                        String[] cconsultconflds = cconsultconfld.split("\\|");
                        for (int k = 0; k < cconsultconflds.length; k++) {
                            String cconsultconfldStr = cconsultconflds[k];
                            if ("".equals(cconsultconfldStr)) {
                                continue;
                            }
                            String[] cconsultconfldStrs = cconsultconfldStr
                                    .split("=");
                            // 是否存在这个字段
                            String cIexitSql = "select * from ac_table t left join ac_fields f on t.iid=f.itable where ctable='"
                                    + coloumnMap.get("cconsulttable")
                                    .toString()
                                    + "' and cfield='"
                                    + cconsultconfldStrs[0] + "'";
                            List list = this.assemblyQuerySql(cIexitSql);
                            if (list.size() == 0) {
                                continue;
                            }
                            if (cconsultconfldStrs[1].indexOf(".") != -1) {
                                String[] a = cconsultconfldStrs[1].split("\\.");
                                if(a[0].trim().toUpperCase().equals(mainTable.trim().toUpperCase())){
                                    selectleftjoin.append(" and ");
                                    selectleftjoin.append(coloumnMap.get(
                                            "cconsulttable").toString().trim()
                                            + size);
                                    selectleftjoin.append(".");
                                    selectleftjoin.append(cconsultconfldStrs[0]);
                                    selectleftjoin.append("=#");
                                    selectleftjoin.append(a[1]);
                                    selectleftjoin.append("#");
                                }else{
                                    //元素型子表 条件 在此 拼写替换
                                    selectleftjoin.append(" and ");
                                    selectleftjoin.append(coloumnMap.get(
                                            "cconsulttable").toString()
                                            + size);
                                    selectleftjoin.append(".");
                                    selectleftjoin.append(cconsultconfldStrs[0]);
                                    selectleftjoin.append("=(select ");
                                    selectleftjoin.append(a[1]);
                                    selectleftjoin.append(" from ");
                                    selectleftjoin.append(a[0]);
                                    selectleftjoin.append(" where  ");
                                    selectleftjoin.append(thisTableMap.get("foreignKey"));
                                    selectleftjoin.append(" =  #");
                                    selectleftjoin.append(thisTableMap.get("primaryKey"));
                                    selectleftjoin.append("#) ");
                                }

                            } else {
                                selectleftjoin.append(" and ");
                                selectleftjoin.append(coloumnMap.get(
                                        "cconsulttable").toString()
                                        + size);
                                selectleftjoin.append(".");
                                selectleftjoin.append(cconsultconfldStrs[0]);
                                selectleftjoin.append("=");
                                selectleftjoin.append(ctable);
                                selectleftjoin.append(".");
                                selectleftjoin.append(cconsultconfldStrs[1]);
                            }
                        }
                    }
                    size++;
                }

                // 修改列
                if (!"iid".equals(coloumnMap.get("cfield").toString().trim())) {
                    updateColoumnSql.append(coloumnMap.get("cfield").toString()
                            .trim());
                    updateColoumnSql.append("=#");
                    updateColoumnSql.append(coloumnMap.get("cfield").toString()
                            .trim());
                    updateColoumnSql.append("#");

                    if (updateColoumnSql.indexOf(",") == 0)
                        updateColoumnSql.deleteCharAt(0);
                }

                // 新增
                if (!"iid".equals(coloumnMap.get("cfield").toString().trim())) {

                    insertColoumnSql.append(coloumnMap.get("cfield").toString()
                            .trim());
                    insertValueSql.append("#");
                    insertValueSql.append(coloumnMap.get("cfield").toString()
                            .trim());
                    insertValueSql.append("#");

//					for (Object tableobject : tableList) {
//						HashMap tableMap = (HashMap) tableobject;
//						if (tableMap.get("ctable").toString().toUpperCase().equals(
//								ctable.toUpperCase())) {
//							if(!tableMap.get("foreignKey").toString().trim().equals(coloumnMap.get("cfield").toString().trim())){
//								
//								insertColoumnSql.append(coloumnMap.get("cfield").toString()
//										.trim());
//								insertValueSql.append("#");
//								insertValueSql.append(coloumnMap.get("cfield").toString()
//										.trim());
//								insertValueSql.append("#");
//								break;
//							}
//						}
//					}

                }
                count++;
            }

            selectSql.append(",");
            selectSql.append(ctable);
            selectSql.append(".iid");
            selectSql.append(" from ");
            // 查询sql
            selectSql.append(ctable);
            if (bmain) {
                // 判断是否有iifuncregedit列和ifuncregedit列
                boolean hasiifuncregedit = false;
                boolean hasifuncregedit = false;
                for (int i = 0; i < coloumnList.size(); i++) {
                    HashMap coloumnMap = (HashMap) coloumnList.get(i);
                    if (coloumnMap.get("cfield").toString().trim().equals(
                            "iifuncregedit")) {
                        hasiifuncregedit = true;
                    }

                    if (coloumnMap.get("cfield").toString().trim().equals(
                            "ifuncregedit")) {
                        hasifuncregedit = true;
                    }
                }
                String querycfield = "select * from AC_datadictionary where cfield='iifuncregedit' and ifuncregedit="
                        + ifuncregedit + " and ctable='" + ctable + "'";
                List cfields = this.assemblyQuerySql(querycfield);
                if (cfields != null && cfields.size() > 0) {
                    if (!hasiifuncregedit) {
                        insertColoumnSql.append(",iifuncregedit");
                        insertValueSql.append(",#iifuncregedit#");
                    }
                } else {
                    if (!hasifuncregedit) {
                        String querycfield2 = "select * from AC_datadictionary where cfield='ifuncregedit' and ifuncregedit="
                                + ifuncregedit + " and ctable='" + ctable + "'";
                        List cfields2 = this.assemblyQuerySql(querycfield2);
                        if (cfields2 != null && cfields2.size() > 0) {
                            insertColoumnSql.append(",ifuncregedit");
                            insertValueSql.append(",#ifuncregedit#");
                        }
                    }
                }
            }

            if (!bmain) {
                selectSql.append(" " + selectleftjoin.toString().trim());
            }

            // 修改sql
            updateSql.append(ctable);
            updateSql.append(" set ");
            updateSql.append(updateColoumnSql.toString().trim());

            // 删除语句
            StringBuffer deleteAllSql = new StringBuffer();
            deleteAllSql.append("delete from ");
            deleteAllSql.append(ctable);

            StringBuffer deleteSingleSql = new StringBuffer();
            if (!bmain) {
                deleteSingleSql.append("delete from ");
                deleteSingleSql.append(ctable);
                deleteSingleSql.append(" where ");
                deleteSingleSql.append("iid not in (#childiid#) and ");
                // 删除部分语句
            }

            selectSql.append(" where ");
            updateSql.append(" where ");
            deleteAllSql.append(" where ");




            selectSql.append(ctable + ".");
            selectSql.append(thisTableMap.get("foreignKey").toString()
                    .trim());
            // *****************XZQWJ
            // 修改前代码*************************************
            // selectSql.append("=");
            // *****************XZQWJ
            // 修改后代码*************************************
            selectSql.append(" in ");
            updateSql.append(thisTableMap.get("foreignKey").toString()
                    .trim());
            // *****************XZQWJ
            // 修改前代码*************************************
            // updateSql.append("=");
            // *****************XZQWJ
            // 修改后代码*************************************
            updateSql.append(" in ");
            deleteAllSql.append(thisTableMap.get("foreignKey").toString()
                    .trim());
            // *****************XZQWJ
            // 修改前代码*************************************
            // deleteAllSql.append("=");
            // *****************XZQWJ
            // 修改后代码*************************************
            deleteAllSql.append(" in ");

            deleteSingleSql.append(thisTableMap.get("foreignKey")
                    .toString().trim());
            // *****************XZQWJ
            // 修改前代码*************************************
            // deleteSingleSql.append("=");
            // *****************XZQWJ
            // 修改后代码*************************************
            deleteSingleSql.append(" in ");
            if (bmain) {
                selectSql.append("( #");
                selectSql.append(thisTableMap.get("foreignKey").toString()
                        .trim());
                selectSql.append("# )");

                updateSql.append("( #");
                updateSql.append(thisTableMap.get("foreignKey").toString()
                        .trim());
                updateSql.append("# )");

                deleteAllSql.append("( #");
                deleteAllSql.append(thisTableMap.get("foreignKey")
                        .toString().trim());
                deleteAllSql.append("# )");
            } else {
                String temp_insertColoumnSql = insertColoumnSql.toString();
                if (temp_insertColoumnSql.indexOf(thisTableMap.get("foreignKey").toString().trim()) == -1) {
                    insertValueSql.append(",#");
                    insertValueSql.append(thisTableMap.get("primaryKey")
                            .toString().trim());
                    insertValueSql.append("#");
                    insertColoumnSql.append(",");
                    insertColoumnSql.append(thisTableMap.get("foreignKey")
                            .toString().trim());
                }
                if (thisTableMap.get("primaryKey").toString() == "iid") {
                    // selectSql.append("#iid#");

                    updateSql.append("( #iid# )");

                    deleteAllSql.append("( #iid# )");
                    deleteSingleSql.append("( #iid# )");

                } else {
                    // 找到主键 关联字段
                    StringBuffer sql = new StringBuffer();
                    sql
                            .append("select foreignKey,case when (primaryKey is null or primaryKey='null' or primaryKey='') then foreignKey else primaryKey end primaryKey ");
                    sql
                            .append(" from ac_tableRelationship where  ctable='");
                    sql.append(thisTableMap.get("ctable2"));
                    sql.append("' and ifuncregedit=");
                    sql.append(thisTableMap.get("ifuncregedit").toString());
                    // sql.append(" union all ");
                    // sql.append(" select foreignKey from ac_tableRelationship where ctable  in ( ");
                    // sql.append(" select ctable2 from ac_tableRelationship where bMain=0 and ctable='");
                    // sql.append(tableMap.get("ctable2"));
                    // sql.append("' and ifuncregedit=");
                    // sql.append(tableMap.get("ifuncregedit").toString());
                    // sql.append(" ) ");
                    // sql.append(" and ifuncregedit=");
                    // sql.append(tableMap.get("ifuncregedit").toString());
                    List foreignKeyList = this.assemblyQuerySql(sql
                            .toString());
                    if (foreignKeyList != null
                            && foreignKeyList.size() > 0) {
                        HashMap foreignKeyMap = (HashMap) foreignKeyList
                                .get(0);

                        // 查询
                        selectSql.append("(select iid from ");
                        selectSql.append(thisTableMap.get("ctable2")
                                .toString().trim());
                        selectSql.append(" where ");
                        selectSql.append(thisTableMap.get("ctable2")
                                .toString().trim()
                                + ".");
                        selectSql.append(foreignKeyMap
                                .get("foreignKey").toString().trim());
                        selectSql.append("=");
                        selectSql.append("#");
                        selectSql.append(foreignKeyMap
                                .get("primaryKey").toString().trim());
                        selectSql.append("#");
                        selectSql.append(")");

                        deleteSingleSql.append("(select iid from ");
                        deleteSingleSql.append(thisTableMap.get("ctable2")
                                .toString().trim());
                        deleteSingleSql.append(" where ");
                        deleteSingleSql.append(thisTableMap.get("ctable2")
                                .toString().trim()
                                + ".");
                        deleteSingleSql.append(foreignKeyMap.get(
                                "foreignKey").toString().trim());
                        deleteSingleSql.append("=");
                        deleteSingleSql.append("#");
                        deleteSingleSql.append(foreignKeyMap.get(
                                "primaryKey").toString().trim());
                        deleteSingleSql.append("#");
                        deleteSingleSql.append(")");

                        // 修改
                        updateSql.append("(select iid from ");
                        updateSql.append(thisTableMap.get("ctable2"));
                        updateSql.append(" where ");
                        updateSql.append(foreignKeyMap
                                .get("foreignKey").toString().trim());
                        updateSql.append("=");
                        updateSql.append("#");
                        updateSql.append(foreignKeyMap
                                .get("primaryKey").toString().trim());
                        updateSql.append("#");
                        updateSql.append(")");

                        // 删除
                        deleteAllSql.append("(select iid from ");
                        deleteAllSql.append(thisTableMap.get("ctable2"));
                        deleteAllSql.append(" where ");
                        deleteAllSql.append(foreignKeyMap.get(
                                "foreignKey").toString().trim());
                        deleteAllSql.append("=");
                        deleteAllSql.append("#");
                        deleteAllSql.append(foreignKeyMap.get(
                                "primaryKey").toString().trim());
                        deleteAllSql.append("#");
                        deleteAllSql.append(")");
                    }
                }
            }


            // 新增sql
            insertSql.append(ctable);
            insertSql.append("(");
            String colo = insertColoumnSql.toString().replace(",,", ",");
            insertSql.append(colo);
            insertSql.append(") values(");
            String valueSql = insertValueSql.toString().replace(",,", ",");
            insertSql.append(valueSql);
            insertSql.append(")");


            // 查询sql
            result.put("selectSql", selectSql.toString());

            if (!bmain) {
                result.put("deleteSingleSql", deleteSingleSql.toString().trim());
            }
            // 修改
            result.put("updateSql", updateSql.toString());
            // 新增sql
            result.put("insertSql", insertSql.toString());
            // 删除语句
            result.put("deleteAllSql", deleteAllSql.toString());

            // 所有列
            result.put("coloumnList", coloumnList);
            // 表名
            result.put("ctable", ctable);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return result;
    }

    public List queryVouchForm(HashMap paramObj) {
        List newvouchFormList = new ArrayList();
        // 找出所有分组
        List vouchFormList = this.queryForList("query_vouchFormGroup", Integer
                .valueOf(paramObj.get("ivouch").toString()));
        for (Object object : vouchFormList) {
            HashMap vouchFormMap = (HashMap) object;
            HashMap paramMap = new HashMap();
            paramMap.put("ivouch", paramObj.get("ivouch"));
            paramMap.put("ipgroup", vouchFormMap.get("iid").toString());
            // 找出分组中的信息项
            List childList = this.queryForList("query_vouchForm_child",
                    paramMap);

            // 首先判断是否存在子节点
            if (childList.size() == 1) {
                HashMap childMap = (HashMap) childList.get(0);
                // 判断是否是表格,如果是表格,则查询出表体信息
                if (childMap.get("objecttype").toString().equals("DataGrid")) {
                    HashMap childTableMap = new HashMap();
                    childTableMap.put("ivouch", paramObj.get("ivouch"));
                    childTableMap.put("ipgroup", childMap.get("iid"));
                    List childtableList = this.queryForList(
                            "query_vouchForm_child", childTableMap);

                    childMap.put("taleChild", childtableList);
                    vouchFormMap.put("childMap", childMap);
                } else if (childList != null) {
                    vouchFormMap.put("childMap", childList);
                }
            } else {
                vouchFormMap.put("childMap", childList);
            }
            newvouchFormList.add(vouchFormMap);
        }
        return newvouchFormList;
    }

    /**
     * 作者：XZQWJ 功能：判断当前表是否存在子表 ,并保存相关数据 时间：2013-01-14
     *
     * @param currTableName   当前表名
     * @param tableMessage    表关系
     * @param childsqlObjList 表SQL
     * @param valueMap        表数据
     * @param count
     */
    public String isExistChildTable(String currTableName, List tableMessage,
                                    List childsqlObjList, HashMap valueMap, int count) {

        Boolean bool = false;
        // String childupdateSql="";
        String childTableName = "";
        String foreignKey = "";
        String primaryKey = "";
        for (int i = 0; i < tableMessage.size(); i++) {
            HashMap tableRelationship = (HashMap) tableMessage.get(i);
            if (currTableName.equals(tableRelationship.get("ctable2") + "")) {
                childTableName = tableRelationship.get("ctable").toString();
                foreignKey = tableRelationship.get("foreignKey").toString();
                primaryKey = tableRelationship.get("primaryKey").toString();
                bool = true;
                break;
            }
        }
        if (!bool) {// 不存在子表返回
            return childTableName;
        }
        // 当前表格数据
        List valueList = (List) valueMap.get(currTableName.toLowerCase());

        // 子表数据
        List valueChildList = (List) valueMap.get(childTableName.toLowerCase());

        String insertsql = "";

        String child_insertsql = "";

        for (int i = 0; i < childsqlObjList.size(); i++) {
            HashMap childsqlObjMap = (HashMap) childsqlObjList.get(i);
            if (childsqlObjMap.get(currTableName) != null) {
                insertsql = ((HashMap) childsqlObjMap.get(currTableName)).get(
                        "insertSql").toString();
                break;
            }

        }

        for (int i = 0; i < childsqlObjList.size(); i++) {
            HashMap childsqlObjMap = (HashMap) childsqlObjList.get(i);
            if (childsqlObjMap.get(childTableName) != null) {
                child_insertsql = ((HashMap) childsqlObjMap.get(childTableName))
                        .get("insertSql").toString();
//				child_insertsql = child_insertsql.replace(
//						",#" + foreignKey + "#,", ",").replace(
//						"," + foreignKey + ",", ",");
                child_insertsql = child_insertsql.replace("#" + foreignKey + "#", "#" + primaryKey + "#");
                break;
            }
        }

        for (int i = 0; i < valueList.size(); i++) {
            HashMap valueListMap = (HashMap) valueList.get(i);// 当前表格的第i行数据

            Object primaryKey_value = valueListMap.get(primaryKey);
            valueListMap.remove(primaryKey);

            HashMap<String, String> headparam = new HashMap<String, String>();

            String s = getSql(valueListMap, insertsql, count);
            String sql = getSql(valueMap, s, count);

            if (!sql.equals("")) {
                HashMap<String, Object> paraMap = new HashMap<String, Object>();
                sql = replaceJing(sql);
                headparam.put("sql", sql);
            }
            Object obj = this.insert("add_pm", headparam);
            valueMap.put("child_iid", Integer.valueOf(obj.toString()));
            String childupdateSql = "";
            for (int j = 0; j < valueChildList.size(); j++) {
                String temp_value = ((HashMap) valueChildList.get(j)).get(
                        foreignKey).toString();
                if (temp_value.equals(primaryKey_value.toString())) {
                    HashMap valueListChildMap = (HashMap) valueChildList.get(j);// 得到子表的第i行数据
                    String ss = getSql(valueListChildMap, child_insertsql,
                            count);
                    childupdateSql += getSql(valueMap, ss, count);
                }
            }
            valueMap.remove("child_iid");
            if (!childupdateSql.equals("")) {
                HashMap<String, Object> paraMap = new HashMap<String, Object>();
                paraMap.put("sqlValue", childupdateSql);
                this.update("DatadictionaryDest.updateDataList", paraMap);
            }
        }
        return childTableName;

    }

    // 保存录入信息
    // 修改人：王炫皓
    // 修改时间：20121124
    public String addPm(HashMap param) {
    	try
    	{
        List oldList = null;
        // 判断是否是引入操作
        boolean flag = true;
        String result = "";
        int iid = 0;
        // 找到新增语句
        HashMap mainSqlMap = (HashMap) param.get("mainSqlObj");
        String insertSql = mainSqlMap.get("insertSql").toString();

        // 找到记录集
        HashMap valueMap = (HashMap) param.get("value");

        // XZQWJ 表之间关系
        List tableMessage = (List) param.get("tableMessage");
        // XZQWJ 单据的主表名称
        String ctable = mainSqlMap.get("ctable").toString();
        // XZQWJ 子表表名
        String childTableName = "";
        List<String> cTableNameList = new ArrayList();
        Boolean ischild = false;

        // lzx富文本替换临时图片名
        if (param.get("hasRichTextEditor") != null) {
            String userId = param.get("hasRichTextEditor").toString();
            String cfield = param.get("cfield").toString();
            valueMap.put(cfield, valueMap.get(cfield).toString().replaceAll(
                    userId + "_temp_", "img_"));
        }

        List<String> keys = getHashMapKeys(valueMap);
        HashMap<String, String> headparam = new HashMap<String, String>();
        if (param.containsKey("count")) {
            headparam.put("sql", getSql(valueMap, insertSql, Integer
                    .valueOf(param.get("count").toString())));
        } else {
            headparam.put("sql", getSql(valueMap, insertSql, 0));
        }

        String insertSqlMain = headparam.get("sql");
        if (!insertSqlMain.equals("")) {
            //替换还存在的#字段#字样 为空字符串
//            while (insertSqlMain.split(",#[^#]+#,").length > 1) {
//                insertSqlMain = insertSqlMain.replaceAll(",#[^#]+#,", ",'',");
//            }
        	insertSqlMain = replaceJing(insertSqlMain);
            headparam.put("sql", insertSqlMain);
        }

        Object obj = this.insert("add_pm", headparam);
        // 获取表头iid
        iid = Integer.valueOf(obj.toString());

        valueMap.put("iid", iid);
        String childupdateSql = "";
        if (param.containsKey("childSqlObj")) {
            List childsqlObjList = (List) param.get("childSqlObj");
            for (int i = 0; i < childsqlObjList.size(); i++) {
                HashMap childsqlObjMap = (HashMap) childsqlObjList.get(i);
                List<String> childsqlkeys = getHashMapKeys(childsqlObjMap);
                String cta = "";
                for (int u = 0; u < childsqlkeys.size(); u++) {
                    String childsql = childsqlkeys.get(u).toString();
                    if (!childsql.equals("cresfunctionreadMap")) {
                        cta = childsql;
                    }
                }
                int count = 0;
                if (param.containsKey("count")) {
                    count = Integer.valueOf(param.get("count").toString());
                }

                if (cTableNameList != null && cTableNameList.size() > 0) {
                    for (int size = 0; size < cTableNameList.size(); size++) {
                        if (cTableNameList.get(size).equals(cta)) {
                            ischild = true;
                            break;
                        }
                    }

                }
                if (ischild) {
                    continue;
                }
                childTableName = isExistChildTable(cta, tableMessage,
                        childsqlObjList, valueMap, count);
                if (childTableName != "") {
                    cTableNameList.add(childTableName);
                    continue;
                }

                HashMap paramObj = (HashMap) childsqlObjMap.get(cta);
                String insertsql = paramObj.get("insertSql").toString();
                // 表体
                List valueList = (List) valueMap.get(cta.toLowerCase());
                // wxh add
                oldList = valueList;

                if (valueList != null) {
                    for (int j = 0; j < valueList.size(); j++) {
                        // 获取表体中的一行记录
                        HashMap valueListMap = (HashMap) valueList.get(j);
                        /*
                         * importswxh add
						 */
                        if ("imports".equals(param.get("imports"))) {
                            flag = false;
                            // 获取旧的分组
                            if (valueListMap.get("ctable").toString()
                                    .equalsIgnoreCase("null")) {
                                String ipgroupiid = valueListMap.get("iid")
                                        .toString();
                            }
                            // 获取业务字典的信息 ifun = ifuncregedit
                            // 业务字典配置后，所有新表单中的字段就以存在
                            String sql = "select iid,cfield,ctable from ac_datadictionary where ifuncregedit ="
                                    + param.get("ifun");
                            List<HashMap> datadictionaryList = this
                                    .assemblyQuerySql(sql);

                            for (int c = 0; c < datadictionaryList.size(); c++) {
                                HashMap filed = datadictionaryList.get(c);
                                String filedName = filed.get("cfield")
                                        .toString().trim();
                                String table = filed.get("ctable").toString()
                                        .trim();
                                String str = "ui_" + table + "_" + filedName;
                                String objname = valueListMap
                                        .get("cobjectname").toString();
                                if (str.equalsIgnoreCase(objname)) {
                                    valueListMap.put("idatadictionary", filed
                                            .get("iid"));
                                }
                            }
                            // 强制修改ivouch = 表头的iid
                            valueListMap.put("iid", iid);
                        }
                        if (param.containsKey("count")) {
                            String s = getSql(valueListMap, insertsql, Integer
                                    .valueOf(param.get("count").toString()));
                            childupdateSql += getSql(valueMap, s, Integer
                                    .valueOf(param.get("count").toString()));
                        } else {
                            String s = getSql(valueListMap, insertsql, 0);
                            childupdateSql += getSql(valueMap, s, 0) + ";";
                        }
                    }
                }
            }
        }

        if (!childupdateSql.equals("")) {
            HashMap<String, Object> paraMap = new HashMap<String, Object>();
            //替换还存在的#字段#字样 为空字符串
//            while (childupdateSql.split(",#[^#]+#,").length > 1) {
//                childupdateSql = childupdateSql.replaceAll(",#[^#]+#,", ",'',");
//            }
            childupdateSql = replaceJing(childupdateSql);
            paraMap.put("sqlValue", childupdateSql);
            this.update("DatadictionaryDest.updateDataList", paraMap);
        }

        writeBack(param);

        HashMap paramStr = new HashMap();
        paramStr.put("ifuncregedit", valueMap.get("iifuncregedit").toString());
        // 插入
        paramStr.put("iinvoice", String.valueOf(iid));
        paramStr.put("iperson", param.get("iperson"));
        paramStr.put("icorp", param.get("icorp"));
        paramStr.put("idepartment", param.get("idepartment"));
        i_ab_invoiceuserService.add_ab_invoiceuser(paramStr);
        updateStatus(paramStr);
        result = String.valueOf(iid);
		/*
		 * wxh add 保存后对应分组
		 */
        List groupList = new ArrayList(); // 被引用表单table类型的分组
        List objList = new ArrayList(); // 新表单table类型分组
        if (!flag) {
            String sql = "select iid,ctable,cobjectname,iobjecttype,ivouch,isNull(ipgroup,0)  as ipgroup from ac_vouchform where ivouch = (select iid from ac_vouch  where ifuncregedit = "
                    + param.get("ifun") + ")   ";
            List<HashMap> newList = this.assemblyQuerySql(sql);
            // int iid_tem=0;
            for (int i = 0; i < newList.size(); i++) {
                HashMap newMap = newList.get(i);
                if (Integer.parseInt(newMap.get("iobjecttype").toString()) == 8) {
                    objList.add(newList.get(i));
                }
                if (Integer.parseInt(newMap.get("ipgroup").toString()) > 0) {
                    String selectSql = "select iid,iobjecttype,cobjectname from ac_vouchform where iid =  "
                            + newMap.get("ipgroup");
                    List objs = this.assemblyQuerySql(selectSql);
                    if (objs != null) {
                        HashMap hm = (HashMap) objs.get(0);

                        if (Integer.parseInt(hm.get("iobjecttype").toString()) == 8) {
                            groupList.add(hm);

                        }
                    }
                }
            }
            for (int i = 0; i < newList.size(); i++) {
                HashMap map = newList.get(i);
                // oldList传进来的参数数据
                HashMap oldmap = (HashMap) oldList.get(i);
                try {
                    int newIpgroup = Integer.parseInt(map.get("ipgroup")
                            .toString());
                    int oldIpgroup = Integer.parseInt(oldmap.get("ipgroup")
                            .toString());
                    if (Integer.parseInt(map.get("iobjecttype").toString()) != 1) {
                        // 判断原始数据是否和复制后的数据是否属于同一分组
                        if (newIpgroup == oldIpgroup
                                && map.get("cobjectname").toString().equals(
                                oldmap.get("cobjectname").toString())) {
							/*
							 * 更新table类型的分组
							 */
                            boolean bool = false;
                            for (int j = 0; j < groupList.size(); j++) {
                                if (bool) {
                                    break;
                                }
                                HashMap tableGroup = (HashMap) groupList.get(j);
                                // 获取原来table分组的iid
                                int tableGroupId = (Integer) tableGroup
                                        .get("iid");
                                // 获取原来table分组的类型名
                                String tableName = tableGroup
                                        .get("cobjectname").toString();
                                String updateSql = "";
                                if (tableGroupId == Integer.parseInt(map.get(
                                        "ipgroup").toString())) {
                                    for (int k = 0; k < objList.size(); k++) {
                                        if (bool) {
                                            break;
                                        }
                                        String cobjName = ((HashMap) objList
                                                .get(k)).get("cobjectname")
                                                .toString();
                                        if (tableName.equals(cobjName)) {
                                            bool = true;
                                            updateSql = "update ac_vouchform set ipgroup = "
                                                    + ((HashMap) objList.get(k))
                                                    .get("iid")
                                                    + "  where iid = "
                                                    + map.get("iid");
                                            System.out.println();
                                            this.assemblyQuerySql(updateSql);
                                        }
                                    }
                                }

                            }
							/*
							 * 获取当前分组的id 更新所有group类型的分组
							 */
                            String mysql = "select iid from ac_vouchform where iobjecttype =  1  and  ivouch = "
                                    + map.get("ivouch").toString()
                                    + " and cobjectname = (select cobjectname from ac_vouchform where iobjecttype =  1 and iid = "
                                    + newIpgroup + ")";
                            List groupiids = this.assemblyQuerySql(mysql);
                            if (groupiids.size() > 0) {
                                HashMap hm = (HashMap) groupiids.get(0);
                                int id = (Integer) hm.get("iid");
                                String update = "update ac_vouchform set ipgroup = "
                                        + id
                                        + "  where iid = "
                                        + map.get("iid");
                                HashMap<String, Object> parMap = new HashMap<String, Object>();
                                parMap.put("sqlValue", update);
                                this.update(
                                        "DatadictionaryDest.updateDataList",
                                        parMap);
                            }

                        }
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }

            }
        }
    	
        /**
         * 添加系统操作日志
         */
        HashMap<String, Serializable> map = new HashMap<String, Serializable>();
        map.put("operate", "add");
        map.put("result", result);
        map.put("iinvoice", iid);
        map.put("params", (HashMap) param.get("value"));
        LogOperateUtil.insertLog(map);
        return result;
    	}
    	catch(Exception e)
    	{
    		e.printStackTrace();
    		return "";
    	}
    
    	
    }
    //lhl---20150724多选##翻译问题,重写翻译
    private String replaceJing(String childSql) {
        while (childSql.split(",#[^#]+#,").length > 1) {
        	childSql = childSql.replaceAll(",#[^#]+#,", ",'',");
        }
        while (childSql.split("\\(#[^#]+#,").length > 1) {
        	childSql = childSql.replaceAll("\\(#[^#]+#,", "('',");
        }
        return childSql;
    }
    // 替换sql
    private String getSql(HashMap valueMap, String sql, int count) {
        sql = sql.replace("@cconsultedit", "");
        List<String> keys = getHashMapKeys(valueMap);
        for (int i = 0; i < keys.size(); i++) {
            String key = keys.get(i).trim();
            String cfield = "#" + key + "#";
            if (sql.indexOf("#ifuncregedit#") != -1
                    || sql.indexOf(cfield) != -1) {
                if (valueMap.get(key) == null
                        || valueMap.get(key).toString().trim() == "") {
                    String value = "null";
                    sql = sql.replace(cfield, value);
                } else if (valueMap.get(key).toString().trim().indexOf(
                        "服务器当前时间") != -1
                        && count == 0) {
                    sql = sql.replace(cfield, "getdate()");
                } else if (valueMap.get(key).toString().trim().indexOf(
                        "服务器当前日期") != -1
                        && count == 0) {
                    sql = sql.replace(cfield,
                            "CONVERT(varchar(10), getdate(), 120)");
                } else if (valueMap.get(key) instanceof Boolean) {
                    boolean isFand = Boolean.valueOf(valueMap.get(key)
                            .toString().trim());
                    if (isFand) {

                        sql = sql.replace(cfield, "'1'");
                    } else {
                        sql = sql.replace(cfield, "'0'");
                    }
                } else {
                    if (valueMap.containsKey("child_iid")) {
                        sql = sql.replace("#iid#", valueMap.get("child_iid")
                                .toString());
                    }
                    String value = "";
                    value = "'"
                            + valueMap.get(key).toString().trim().replace("'",
                            "''") + "'";
                    sql = sql.replace(cfield, value);

                }
            }
        }
        // 对应ivouch
        if (valueMap.containsKey("child_iid")) {
            sql = sql.replace("#iid#", valueMap.get("child_iid").toString());
            return sql;
        }
        if (valueMap.containsKey("iid")) {
            sql = sql.replace("#iid#", valueMap.get("iid").toString());
        }
        return sql;
    }

    // 判断唯一性约束
    public String isUnique(HashMap param) throws Exception {
        // 获得规则
        List vouchFormArr = (List) param.get("ruleObj");

        // 获得记录值
        HashMap paramObj = (HashMap) param.get("value");

        List tableMessage = (List) param.get("tableMessage");

        // 先在找到最外面的组
        for (int i = 0; i < vouchFormArr.size(); i++) {
            HashMap vouchFormMap = (HashMap) vouchFormArr.get(i);
            // 验证子表中的记录
            if (vouchFormMap.get("childMap") instanceof HashMap) {
                HashMap childMap = (HashMap) vouchFormMap.get("childMap");
                List childMapList = (List) childMap.get("taleChild");
                for (int j = 0; j < childMapList.size(); j++) {
                    HashMap childMapListMap = (HashMap) childMapList.get(j);
                    // 找到表体中的内容
                    List childList = (List) paramObj.get(childMapListMap.get("ctable"));
                    String foreignKey = "";
                    String primaryKey = "";
                    String primaryTable = "";
                    for (int l = 0; l < tableMessage.size(); l++) {
                        HashMap tableMessageMap = (HashMap) tableMessage.get(l);
                        if (tableMessageMap.get("ctable").toString().equals(childMapListMap.get("ctable"))) {
                            primaryKey = tableMessageMap.get("primaryKey").toString();
                            foreignKey = tableMessageMap.get("foreignKey").toString();
                            primaryTable = tableMessageMap.get("ctable2").toString();
                            break;
                        }
                    }
                    if (null != childMapListMap.get("cunique") && !"".equals(childMapListMap.get("cunique").toString().trim())) {
                        for (int k = 0; k < childList.size(); k++) {
                            HashMap childObj = (HashMap) childList.get(k);
                            String cfield = childMapListMap.get("cfield")
                                    + "_enabled";
                            String cfield1 = childMapListMap.get("cfield")
                                    + "_Name_enabled";

//							if ((childObj.containsKey(cfield) && childObj.get(cfield).toString() != "-1")
//									|| (childObj.containsKey(cfield1) && childObj.get(cfield1).toString() != "-1")) {
//								continue;
//							}
                            Boolean bunique = (Boolean) childMapListMap.get("bunique");
                            if (!isChildUnique(childMapListMap.get("cunique").toString().trim(), childList, paramObj)) {
                                return "子张表体中的，"+ childMapListMap.get("ccaption") + "已存在，请重新输入";
                            } else if (!bunique) {
                                // 先从数据库中查询
                                boolean unique = isSingUnique(childMapListMap.get( "cunique").toString().trim(), childObj,
                                        childMapListMap.get("ctable").toString().trim(),
                                        Integer.valueOf(paramObj.get(primaryKey).toString().trim()), foreignKey, param.get("curButtonStatus").toString(), (Boolean) childMapListMap.get("bunique"), paramObj, primaryTable);
                                if (!unique) {
                                    return "子表体中的，" + childMapListMap.get("ccaption")+ "已存在，请重新输入";
                                }
                            }
                        }
                    }
                }
            }
            // 验证主表中的记录
            else {
                List vouchValueList = (List) vouchFormMap.get("childMap");
                for (Object object : vouchValueList) {
                    HashMap vouchValueMap = (HashMap) object;
                    if (null != vouchValueMap.get("cunique")&& !"".equals(vouchValueMap.get("cunique").toString().trim())) {
                        boolean unique = false;
                        //wxh modify 如何字段值为空就不走验证
                        if (Boolean.valueOf(vouchValueMap.get("bmain").toString())) {
                            if( null == paramObj.get(vouchValueMap.get("cfield")) || "".equals(paramObj.get(vouchValueMap.get("cfield").toString()))){
                                unique = true;
                            }else{
                                unique = isSingUnique(vouchValueMap.get("cunique").toString().trim(), paramObj,vouchValueMap.get("ctable").toString().trim(),0, null, param.get("curButtonStatus").toString(), (Boolean) vouchValueMap.get("bunique"), paramObj, null);
                            }
                        } else {
                            List childObjList = (List) paramObj.get(vouchValueMap.get("ctable").toString().trim());
                            if (childObjList.size() > 0) {
                                String foreignKey = "";
                                String primaryKey = "";
                                String primaryTable = "";
                                for (int l = 0; l < tableMessage.size(); l++) {
                                    HashMap tableMessageMap = (HashMap) tableMessage.get(l);
                                    if (tableMessageMap.get("ctable").toString().equals(
                                            vouchValueMap.get("ctable"))) {
                                        primaryKey = tableMessageMap.get("primaryKey").toString();
                                        foreignKey = tableMessageMap.get("foreignKey").toString();
                                        primaryTable = tableMessageMap.get("ctable2").toString();
                                        break;
                                    }
                                }
                                // 先从数据库中查询
                                unique = isSingUnique(vouchValueMap.get( "cunique").toString().trim(), (HashMap) childObjList.get(0),
                                        vouchValueMap.get("ctable").toString().trim(),
                                        Integer.valueOf(paramObj.get(primaryKey) .toString().trim()), foreignKey,
                                        param.get("curButtonStatus").toString(),
                                        (Boolean) vouchValueMap.get("bunique"), paramObj,
                                        primaryTable);
                            } else {
                                unique = true;
                            }

                        }
                        if (!unique) {
                            return vouchValueMap.get("ccaption") + "已存在，请重新输入";
                        }
                    }
                }
            }
        }
        return null;
    }

    // 拼装约束sql
    private String getUniqueConditionSql(String cfield, HashMap param, String ctable, HashMap paramValue) {
        String[] cfields = cfield.split(",");
        StringBuffer sql = new StringBuffer();
        for (String str : cfields) {
            if (null != str.trim() && !"".equals(str.trim())) {

                sql.append(" and ");
                String strs = "";
                String ctable2 = "";
                //判断是否带表名
                if (str.indexOf(".") != -1) {
                    strs = str.substring(str.indexOf(".") + 1, str.length());
                    ctable2 = str.substring(0, str.indexOf("."));
                }
                sql.append(str);
                sql.append("=");
                sql.append("'");
                // ----------LL 空值处理开始----------//
                String value = "";
                //是主表
                if (strs != "" && ctable2 != "" && !paramValue.containsKey(ctable2)) {
                    if (paramValue.get(strs) != null) {
                        value = paramValue.get(strs).toString();
                    } else {
                        value = "";
                    }
                }
                //是子表信息，触发的子表
                else if (strs != "" && ctable2 != "" && ctable.equals(ctable2)) {
                    if (param.get(strs) != null) {
                        value = param.get(strs).toString();
                    } else {
                        value = "";
                    }
                }
                //其他子表信息，分组展示可以子表联合约束
                else if (strs != "" && ctable2 != "" && paramValue.containsKey(ctable2)) {
                    List paramValueList = (List) paramValue.get(ctable2);
                    if (paramValueList.size() > 0) {
                        HashMap valueMap = (HashMap) paramValueList.get(0);
                        if (valueMap.get(strs) != null) {
                            value = valueMap.get(strs).toString();
                        } else {
                            value = "";
                        }
                    }
                } else if (param.get(str) != null) {
                    if (param.get(str) != null) {
                        value = param.get(str).toString();
                    } else {
                        value = "";
                    }
                }
                // ----------LL 空值处理结束----------//
                sql.append(value);
                sql.append("'");
            }
        }
        return sql.toString();
    }

    // 查询本条记录是否存在
    private Boolean isSingUnique(String cfield, HashMap param, String ctable,int iid, String foreignKey, String curButtonStatus, Boolean bunique, HashMap paramValue, String maintable) throws Exception {
        String sql = getUniqueSql(cfield, param, ctable, iid, foreignKey, bunique, paramValue, maintable);
        if (null != sql && !"".equals(sql)) {
            List list = this.assemblyQuerySql(sql);
            if (curButtonStatus.equals("onNew")) {
                if (list.size() > 0) {
                    return false;
                }
            } else {
                if (list.size() > 1) {
                    return false;
                } else if (list.size() == 1) {
                    HashMap map = (HashMap) list.get(0);
                    if (!map.get("iid").toString().equals(param.get("iid").toString())) {
                        return false;
                    }
                }
            }
        }
        return true;
    }

    // 获得整个验证语句
    private String getUniqueSql(String cfield, HashMap param, String ctable,int iid, String foreignKey, Boolean bunique, HashMap paramValue, String maintable) {
        StringBuffer sql = new StringBuffer();
        sql.append("select * from ");
        sql.append(ctable);
        if (maintable != null) {
            sql.append(" left join ");
            sql.append(maintable);
            sql.append(" on ");
            sql.append(ctable);
            sql.append(".");
            sql.append(foreignKey);
            sql.append("=");
            sql.append(maintable);
            sql.append(".iid");
        }
        sql.append(" where 1=1 ");
        String tjSql = getUniqueConditionSql(cfield, param, ctable, paramValue);
        if (null != tjSql && !"".equals(tjSql)) {
            sql.append(tjSql);
            // update by zhong_jing 单据子表是否唯一
            if (iid != 0 && bunique) {
                sql.append(" and ");
                sql.append(foreignKey);
                sql.append("='");
                sql.append(iid);
                sql.append("'");
            }
            return sql.toString();
        }
        return null;
    }

    // 判断子表中的字段有没有重复
    private boolean isChildUnique(String cfield, List childValue, HashMap paramValue) {
        String[] cfields = cfield.split(",");

        int count = 0;
        StringBuffer oldText = new StringBuffer();
        for (int i = 0; i < childValue.size(); i++) {
            HashMap childValueMap = (HashMap) childValue.get(i);
            StringBuffer str = new StringBuffer();

            for (String obj : cfields) {
                String strs = "";
                if (obj.indexOf(".") != -1) {
                    strs = obj.substring(obj.indexOf(".") + 1, obj.length());
                    str.append(paramValue.get(strs).toString());
                } else {
                    str.append(childValueMap.get(obj).toString());
                }
            }

            if (oldText.toString().equals("")) {
                oldText.append(str.toString());
            } else if (oldText.toString().equals(str.toString())) {
                oldText = new StringBuffer();
                count++;
            }
        }

        if (count >= 1) {
            return false;
        }
        return true;
    }

    /**
     * getHashMapKeys(获得HashMap键值) 创建者：zhong_jing 创建时间：2011-10-13 下午02:33:21
     * 修改者：Lenovo 修改时间：2011-10-13 下午02:33:21 修改备注：
     *
     * @param paramObj
     * @return List<String>
     * @Exception 异常对象
     */
    private List<String> getHashMapKeys(HashMap paramObj) {
        Iterator<String> iterator = paramObj.keySet().iterator();

        List<String> keys = new java.util.ArrayList<String>();
        while (iterator.hasNext()) {
            String key = iterator.next();
            keys.add(key);
        }
        return keys;
    }

    public String updatePm(HashMap param) throws Exception, RuntimeException {

        String result = "";

        writeBack(param);
        // 找到新增语句
        HashMap mainSqlMap = (HashMap) param.get("mainSqlObj");
        String updateSql = mainSqlMap.get("updateSql").toString();
        // 找到记录集
        HashMap valueMap = (HashMap) param.get("value");

        // lzx富文本替换临时图片名
        if (param.get("hasRichTextEditor") != null) {
            String userId = param.get("hasRichTextEditor").toString();
            String cfield = param.get("cfield").toString();
            valueMap.put(cfield, valueMap.get(cfield).toString().replaceAll(
                    userId + "_temp_", "img_"));
        }

        List<String> keys = getHashMapKeys(valueMap);
        String deleteSingleSql = "";
        String childupdateSql = "";
        String childdeleteSql = "";
        HashMap deleteSqlMap = new HashMap();
        if (param.containsKey("childSqlObj")) {
            List childsqlObjList = (List) param.get("childSqlObj");
            for (int i = 0; i < childsqlObjList.size(); i++) {
                HashMap childsqlObjMap = (HashMap) childsqlObjList.get(i);
                List<String> childsqlkeys = getHashMapKeys(childsqlObjMap);

                String cta = "";
                for (int u = 0; u < childsqlkeys.size(); u++) {
                    String childsql = childsqlkeys.get(u).toString();
                    if (!childsql.equals("cresfunctionreadMap")) {
                        cta = childsql;
                    }
                }
                HashMap paramObj = (HashMap) childsqlObjMap.get(cta);
                String childsqlupdateSql = paramObj.get("updateSql").toString();
                String insertsqlupdateSql = paramObj.get("insertSql")
                        .toString();
                String deleteSingSql = paramObj.get("deleteSingleSql")
                        .toString();
                String deleteSql = paramObj.get("deleteAllSql").toString();
                List valueList = (List) valueMap.get(cta.toLowerCase());
                StringBuffer iidSql = new StringBuffer();
                int count = 0;
                if (null != valueList) {
                    if (valueList.size() == 0) {
                        if (param.containsKey("count")) {
                            childupdateSql += getSql(valueMap, deleteSql,
                                    Integer.valueOf(param.get("count")
                                            .toString()));
                            deleteSingSql = "";
                        } else {
                            childupdateSql += getSql(valueMap, deleteSql, 0);
                            deleteSingSql = "";
                        }
                    } else {
                        for (int j = 0; j < valueList.size(); j++) {
                            HashMap valueListMap = (HashMap) valueList.get(j);
                            if (valueListMap.get("iid") == null
                                    || valueListMap.get("iid").toString()
                                    .equals("")) {
                                if (param.containsKey("count")) {
                                    String s = getSql(valueListMap,
                                            insertsqlupdateSql, Integer
                                            .valueOf(param.get("count")
                                                    .toString()));
                                    childupdateSql += getSql(valueMap, s,
                                            Integer.valueOf(param.get("count")
                                                    .toString()));

                                } else {
                                    String s = getSql(valueListMap,
                                            insertsqlupdateSql, 0);
                                    childupdateSql += getSql(valueMap, s, 0)
                                            + ";";
                                }
                            } else {
                                if (count > 0) {
                                    iidSql.append(",");
                                }
                                iidSql.append(valueListMap.get("iid")
                                        .toString());
                                count++;
                                int co = childsqlupdateSql
                                        .lastIndexOf(" where ");
                                if (param.containsKey("count")) {
                                    String updateSqls = getSql(valueListMap,
                                            childsqlupdateSql.substring(0, co),
                                            Integer.valueOf(param.get("count")
                                                    .toString()))
                                            + childsqlupdateSql.substring(co);
                                    childupdateSql += getSql(valueMap,
                                            updateSqls, Integer.valueOf(param
                                            .get("count").toString()))
                                            + " and iid='"
                                            + valueListMap.get("iid")
                                            .toString() + "';";
                                } else {
                                    String updateSqls = getSql(valueListMap,
                                            childsqlupdateSql.substring(0, co),
                                            0)
                                            + childsqlupdateSql.substring(co);
                                    childupdateSql += getSql(valueMap,
                                            updateSqls, 0)
                                            + " and iid='"
                                            + valueListMap.get("iid")
                                            .toString() + "';";
                                }
                            }
                        }
                        if (iidSql.length() > 0) {
                            if (param.containsKey("count")) {
                                deleteSqlMap.put(cta, iidSql);
                                deleteSingleSql += getSql(valueMap,
                                        deleteSingSql.replace("#childiid#",
                                                iidSql), Integer.valueOf(param
                                        .get("count").toString()))
                                        + ";";
                            } else {
                                deleteSingleSql += getSql(valueMap,
                                        deleteSingSql.replace("#childiid#",
                                                iidSql), 0)
                                        + ";";
                            }
                        } else {
                            deleteSingleSql += getSql(valueMap, deleteSql, 0);//修改前： deleteSingleSql = getSql(valueMap, deleteSql, 0);  SZC  modify  子表中有冗余数据未删除
                        }
                    }
                }
            }
        }

        if (param.containsKey("count")) {
            this.update("update_pm", getSql(valueMap, updateSql, Integer
                    .valueOf(param.get("count").toString())));
        } else {
            this.update("update_pm", getSql(valueMap, updateSql, 0));
        }

        if (!childupdateSql.equals("")) {
            //替换还存在的#字段#字样 为空字符串
//            while (childupdateSql.split("#[^#]+#").length > 1) {
//                childupdateSql = childupdateSql.replaceAll("#[^#]+#", "''");
//            }
        	 childupdateSql = replaceJing(childupdateSql);

            HashMap<String, Object> paraMap = new HashMap<String, Object>();

            String a = deleteSingleSql + childupdateSql;
            childupdateSql = a;
            System.out.println(deleteSingleSql);
            paraMap.put("sqlValue", childupdateSql);
            this.update("DatadictionaryDest.updateDataList", paraMap);
        }

        result = "success";

        /**
         * 添加系统操作日志
         */
        HashMap<String, Serializable> map = new HashMap<String, Serializable>();
        map.put("operate", "update");
        map.put("result", result);
        map.put("iinvoice", valueMap.get("iid").toString());
        map.put("params", valueMap);
        LogOperateUtil.insertLog(map);
        return result;
    }

    // 删除信息
    public String deletePm(HashMap paramObj) throws Exception, RuntimeException {
        String result = "";

        writeBack(paramObj);

        // 找到新增语句
        HashMap mainSqlMap = (HashMap) paramObj.get("mainSqlObj");
        String deleteAllSql = mainSqlMap.get("deleteAllSql").toString();

        // 找到记录集
        HashMap valueMap = (HashMap) paramObj.get("value");
        List<String> keys = getHashMapKeys(valueMap);
        String childupdateSql = "";

        if (paramObj.containsKey("count")) {
            childupdateSql = getSql(valueMap, deleteAllSql, Integer
                    .valueOf(paramObj.get("count").toString()))
                    + ";";
        } else {
            childupdateSql = getSql(valueMap, deleteAllSql, 0) + ";";
        }

        String deletSql = "";
        deletSql += "delete from ab_invoiceuser where ifuncregedit='"
                + valueMap.get("iifuncregedit") + "' and iinvoice='"
                + valueMap.get("iid") + "';";

        if (paramObj.containsKey("childSqlObj")) {
            List childsqlObjList = (List) paramObj.get("childSqlObj");

            for (int i = 0; i < childsqlObjList.size(); i++) {
                HashMap childsqlObjMap = (HashMap) childsqlObjList.get(i);
                List<String> childsqlkeys = getHashMapKeys(childsqlObjMap);

                String cta = "";
                for (int u = 0; u < childsqlkeys.size(); u++) {
                    String childsql = childsqlkeys.get(u).toString();
                    if (!childsql.equals("cresfunctionreadMap")) {
                        cta = childsql;
                    }
                }

                HashMap param = (HashMap) childsqlObjMap.get(cta);
                String deleteSql = param.get("deleteAllSql").toString();
                List valueList = (List) valueMap.get(cta.toLowerCase());
                int count = 0;
                if (paramObj.containsKey("count")) {
                    deletSql += getSql(valueMap, deleteSql, Integer
                            .valueOf(paramObj.get("count").toString()))
                            + ";";
                } else {
                    deletSql += getSql(valueMap, deleteSql, 0) + ";";
                }
            }
            if (!childupdateSql.equals("")) {
                HashMap<String, Object> paraMap = new HashMap<String, Object>();
                System.out.println(deletSql);
                deletSql += childupdateSql;
                paraMap.put("sqlValue", deletSql);
                this.update("DatadictionaryDest.updateDataList", paraMap);
            }
        }
        result = "success";

        /**
         * 添加系统操作日志
         */
        HashMap<String, Serializable> map = new HashMap<String, Serializable>();
        map.put("operate", "delete");
        map.put("result", result);
        map.put("iinvoice", valueMap.get("iid").toString());
        map.put("params", valueMap);
        LogOperateUtil.insertLog(map);
        return result;
    }

    // 查询记录
    public HashMap queryPm(HashMap paramObj) throws Exception {
        List<String> keys = getHashMapKeys(paramObj);

        String keyStr = "";
        for (int i = 0; i < keys.size(); i++) {
            String key = keys.get(i);
            if (key.equals("childSql")) {
                continue;
            } else if (key.equals("selectSql")) {
                continue;
            } else {
                keyStr = key;
                break;
            }
        }
        String selectSql = "";
        // 表头的查询语句
        selectSql = paramObj.get("selectSql").toString().replace(
                "#" + keyStr + "#", paramObj.get(keyStr).toString()).replace(
                "`", "'");
//		selectSql=paramObj.get("selectSql").toString().replace("`", "'");
        // 查询表体信息
        HashMap resultMap = new HashMap();

        List selectSqlList = (List) this.assemblyQuerySql(selectSql);
        HashMap selectSqlMap = null;
        if (selectSqlList == null || selectSqlList.size() == 0) {
            resultMap.put("mainValue", null);
        } else {
            selectSqlMap = (HashMap) selectSqlList.get(0);
            for (Iterator iter = selectSqlMap.entrySet().iterator(); iter
                    .hasNext(); ) {
                Map.Entry entry = (Map.Entry) iter.next(); // map.entry 同时取出键值对
                Object key = entry.getKey();
                if (entry.getValue() instanceof net.sourceforge.jtds.jdbc.ClobImpl) {
                    net.sourceforge.jtds.jdbc.ClobImpl clob = (net.sourceforge.jtds.jdbc.ClobImpl) entry
                            .getValue();
                    selectSqlMap.put(key, convertStreamToString(clob));
                }
            }
            resultMap.put("mainValue", selectSqlMap);
        }
        List tableMapList = (List) paramObj.get("childSql");
        if (null != tableMapList) {
            for (Object tableMapobject : tableMapList) {
                HashMap tableMap = (HashMap) tableMapobject;
                List<String> childsqlkeys = getHashMapKeys(tableMap);

                String cta = "";
                for (int u = 0; u < childsqlkeys.size(); u++) {
                    String childsql = childsqlkeys.get(u).toString();
                    if (!childsql.equals("cresfunctionreadMap")) {
                        cta = childsql;
                    }
                }
                HashMap ctable = (HashMap) tableMap.get(cta);
                String tableName = cta;
                if (null == selectSqlMap) {
                    resultMap.put(tableName, new ArrayList());
                    continue;
                }
                String tableSql = getSql(selectSqlMap, (ctable.get("selectSql")
                        .toString().replace("#" + keyStr + "#",
                                paramObj.get(keyStr).toString()).replace("`",
                                "'")), 0);

                List tableList = this.assemblyQuerySql(tableSql);
                
                if(tableList == null || tableList.size()==0)
                	System.out.println("YJ Start!~~~~~~~~~~~~~~~~~~~");

                List cresfunctionreadList = (List) tableMap
                        .get("cresfunctionreadMap");

                for (int i = 0; i < cresfunctionreadList.size(); i++) {
                    HashMap cresfunctionreadMap = (HashMap) cresfunctionreadList
                            .get(i);
                    String cfield = cresfunctionreadMap.get("cfield")
                            .toString().trim();
                    for (int j = 0; j < tableList.size(); j++) {
                        HashMap tableListMap = (HashMap) tableList.get(j);
                        String value = tableListMap.get(cfield).toString()
                                .trim();
                        String cresfunctionread = "select dbo."
                                + cresfunctionreadMap.get("cresfunctionread")
                                .toString().trim().replace(
                                        "@" + cfield + "@", value)
                                + " value";
                        List coloumnList = this
                                .assemblyQuerySql(cresfunctionread);
                        if (null != coloumnList && coloumnList.size() > 0) {
                            HashMap coloumnMap = (HashMap) coloumnList.get(0);
                            String valueStr = coloumnMap.get("value")
                                    .toString();
                            String[] newColoumnList = valueStr.split(",");
                            for (int k = 0; k < newColoumnList.length; k++) {
                                String col = newColoumnList[k] + "_enabled";
                                String col1 = newColoumnList[k]
                                        + "_Name_enabled";

                                if (tableListMap.containsKey(col)) {
                                    tableListMap.put(col, -1);
                                }

                                if (tableListMap.containsKey(col1)) {
                                    tableListMap.put(col1, -1);
                                }
                            }
                        }
                    }
                }

                // 查询表头信息
                resultMap.put(tableName, tableList);
            }
        }
        return resultMap;
    }

    // LL 输入流转为字符串（主要用与数据库中text数据类型转为String）
    private String convertStreamToString(net.sourceforge.jtds.jdbc.ClobImpl clob)
            throws SQLException, IOException {
        Reader instream = null;
        StringBuffer sb = null;
        try {
            instream = clob.getCharacterStream();
            long len = clob.length();
            sb = new StringBuffer((int) len);
            char[] buffer = new char[(int) len];
            int length = 0;
            while ((length = instream.read(buffer)) != -1) {
                sb.append(buffer);
            }
        } catch (Exception ex) {
            ex.printStackTrace();
        } finally {
            try {
                if (instream != null)
                    instream.close();
            } catch (Exception dx) {
                instream = null;
            }
            return sb.toString();
        }
    }

    public List queryChild(HashMap param) {
        return this.queryForList("query_vouchForm_child", param);
    }

    public HashMap queryFun(HashMap paramMap) {
        return (HashMap) this.queryForObject("query_AS_funcregedit", paramMap);
    }

    public List automaticallyGenerated(int ifuncregedit) {
        return this.queryForList("automatically_generated", ifuncregedit);
    }

    public List queryFunTree() {
        return this.queryForList("query_tree");
    }

    // 查询参照赋值公式
    public List queryRelationship(HashMap param) {
        return this.queryForList("query_relationship_sing", param);
    }

    // 查询参照赋值公式
    public HashMap queryRelationshipByifuncregedit2(HashMap param) {
        return (HashMap) this.queryForObject(
                "query_relationship_ifuncregedit2", param);
    }

    public List querycfieldRelationship(int irelationship) {
        return this.queryForList("query_cfieldrelationship", irelationship);
    }

    public List queryTriggerbodyconsult(int iconsultConfiguration) {
        return this.queryForList("query_Ac_triggerbodyconsult",
                iconsultConfiguration);
    }

    // 计算公式
    public HashMap formula(HashMap funMap) {
        List cfunctionObjArr = (List) funMap.get("cfunctionObjArr");
        // 表单所有值
        HashMap objMap = (HashMap) funMap.get("value");
        // 表格的单行记录值
        HashMap dataObj = (HashMap) funMap.get("dataObj");

        for (int i = 0; i < cfunctionObjArr.size(); i++) {
            HashMap cfunctionObjMap = (HashMap) cfunctionObjArr.get(i);
            String triggerfield = cfunctionObjMap.get("triggerfield")
                    .toString();
            // 获取当前的公式
            String cfunction = cfunctionObjMap.get("cfunction").toString();
            // 获得所有参与运算的列
            List cfields = (List) cfunctionObjMap.get("cfields");

            // 获得结果集
            String resultCfield = cfunctionObjMap.get("cfield").toString().trim();
            String resultCtable = cfunctionObjMap.get("ctable").toString().trim();

            // 动态取得所有列的值
            for (int j = 0; j < cfields.size(); j++) {
                // 获得单个列
                HashMap cfieldMap = (HashMap) cfields.get(j);
                // 获得列的表名
                String ctable = cfieldMap.get("ctable").toString();
                // 获得字段名
                String cfield = cfieldMap.get("cfield").toString();
                // 获得字段类型
                String ctype = cfieldMap.get("ctype").toString();
                String cfieldValue = null;
                if (null != cfieldMap.get("value")) {
                    cfieldValue = cfieldMap.get("value").toString();
                }

                // 表体触发公式
                if (null != dataObj) {
                    if (triggerfield.equals(cfield)) {
                        if (ctype.equals("datetime")
                                || ctype.equals("nvarchar")) {
                            if (null == cfieldValue || "".equals(cfieldValue)) {
                                if (cfunction.indexOf("@" + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + cfield
                                            + "@", "null");
                                } else if (cfunction.indexOf("@" + ctable + "." + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + ctable + "." + cfield + "@", "null");
                                }
                            } else {
                                if (cfunction.indexOf("@" + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + cfield
                                            + "@", "'" + cfieldValue + "'");
                                } else if (cfunction.indexOf("@" + ctable + "." + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + ctable + "." + cfield + "@", "'" + cfieldValue + "'");
                                }
                            }
                        } else {
                            if (null == cfieldValue || "".equals(cfieldValue)) {
                                if (cfunction.indexOf("@" + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + cfield
                                            + "@", "0");
                                } else if (cfunction.indexOf("@" + ctable + "." + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + ctable + "." + cfield + "@", "0");
                                }
                            } else {
                                if (cfunction.indexOf("@" + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + cfield
                                            + "@", cfieldValue);
                                } else if (cfunction.indexOf("@" + ctable + "." + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + ctable + "." + cfield + "@", cfieldValue);
                                }
                            }
                        }
                    }
                    // 判断值不是计算表体聚集公式
                    else if (cfunction.indexOf("getcol") != -1) {
                        while (true) {
                            if (cfunction.indexOf("getcol") != -1) {
                                String newCfield = cfunction.substring(
                                        cfunction.indexOf("(") + 1, cfunction
                                        .indexOf(")"));
                                List tableList = (List) objMap.get(cfieldMap
                                        .get("ctable").toString());

                                float num = onGetColValue(tableList, newCfield,
                                        cfunction);
                                String numStr = "";
                                if (num != 0 && num == (int) num) {
                                    numStr = String.valueOf((int) num);
                                } else {
                                    numStr = String.valueOf(num);
                                }
                                cfunction = cfunction.replace(cfunction
                                        .substring(cfunction.indexOf("getcol"),
                                                cfunction.indexOf(")") + 1),
                                        numStr);
                            } else {
                                break;
                            }
                        }

                    }
                    // 说明是获得表头的值参与运算
                    else if (null != ctable && !"".equals(ctable)
                            && !objMap.containsKey(cfield)
                            && null != objMap.get(cfield)) {
                        String value = objMap.get(cfield).toString();
                        if (ctype.equals("datetime")
                                || ctype.equals("nvarchar")) {
                            if (null == value || "".equals(value)) {
                                if (cfunction.indexOf("@" + ctable
                                        + "." + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + ctable
                                            + "." + cfield + "@", "null");
                                } else if (cfunction.indexOf("@" + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + cfield + "@", "null");
                                }
                            } else {
                                if (cfunction.indexOf("@" + ctable
                                        + "." + cfield + "@") != -1) {
                                    cfunction = cfunction
                                            .replace("@" + ctable + "." + cfield
                                                    + "@", "'" + value + "'");
                                } else if (cfunction.indexOf("@" + cfield + "@") != -1) {
                                    cfunction = cfunction
                                            .replace("@" + cfield + "@", "'" + value + "'");
                                }
                            }
                        } else {
                            if (null == value || "".equals(value)) {
                                if (cfunction.indexOf("@" + ctable + "." + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + ctable + "." + cfield + "@", "0");
                                } else if (cfunction.indexOf("@" + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + cfield + "@", "0");
                                }
                            } else {
                                if (cfunction.indexOf("@" + ctable + "." + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + ctable
                                            + "." + cfield + "@", value);
                                } else if (cfunction.indexOf("@" + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + cfield + "@", value);
                                }
                            }
                        }
                    }
                    // 单行的字段
                    else if (dataObj.containsKey(cfield)
                            && null != dataObj.get(cfield)
                            && !"".equals(dataObj.get(cfield))) {
                        String value = dataObj.get(cfield).toString();
                        if (ctype.equals("datetime")
                                || ctype.equals("nvarchar")) {
                            if (null == cfieldValue || "".equals(value)) {
                                if (cfunction.indexOf("@" + ctable + "." + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + ctable
                                            + "." + cfield
                                            + "@", "null");
                                } else if (cfunction.indexOf("@" + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + cfield
                                            + "@", "null");
                                }
                            } else {
                                cfunction = cfunction.replace("@" + ctable
                                        + "." + cfield
                                        + "@", "'" + value + "'");
                            }
                        } else {
                            if (null == value || "".equals(value)) {
                                if (cfunction.indexOf("@" + ctable + "." + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + ctable
                                            + "." + cfield
                                            + "@", "0");
                                } else if (cfunction.indexOf("@" + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + cfield
                                            + "@", "0");
                                }
                            } else {
                                if (cfunction.indexOf("@" + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + cfield
                                            + "@", value);
                                } else if (cfunction.indexOf("@" + ctable + "." + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + ctable
                                            + "." + cfield
                                            + "@", "0");
                                }
                            }
                        }
                    } else {
                        if (ctype.equals("int") || ctype.equals("float")) {
                            if (null != ctable && !"".equals(ctable)) {
                                if (cfunction.indexOf("@" + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + cfield + "@", "0");
                                } else if (cfunction.indexOf("@" + ctable + "." + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + ctable + "." + cfield + "@", "0");
                                }
                            } else {
                                if (cfunction.indexOf("@" + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + cfield + "@", "0");
                                } else if (cfunction.indexOf("@" + ctable + "." + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + ctable + "." + cfield
                                            + "@", "0");
                                }
                            }
                        } else if (ctype.equals("nvarchar")) {
                            if (null != ctable && !"".equals(ctable)) {
                                if (cfunction.indexOf("@" + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + cfield + "@", "null");
                                } else if (cfunction.indexOf("@" + ctable + "." + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + ctable
                                            + "." + cfield + "@", "null");
                                }
                            } else {
                                if (cfunction.indexOf("@" + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + cfield
                                            + "@", "null");
                                } else if (cfunction.indexOf("@" + ctable + "." + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + ctable + "." + cfield + "@", "null");
                                }
                            }
                        } else if (ctype.equals("datetime")) {
                            cfunction = null;
                        }
                    }
                } else {
                    if (cfunction.indexOf("getcol") != -1) {
                        List tableList = (List) objMap.get(cfieldMap.get(
                                "ctable").toString());
                        while (cfunction.indexOf("getcol") != -1) {
                            if (cfunction.indexOf("getcol") != -1) {
                                String newCfield = cfunction.substring(
                                        cfunction.indexOf("(") + 1, cfunction
                                        .indexOf(")"));
                                float num = onGetColValue(tableList, newCfield,
                                        cfunction);
                                cfunction = cfunction.replace(cfunction
                                        .substring(cfunction.indexOf("getcol"),
                                                cfunction.indexOf(")") + 1),
                                        String.valueOf(num));
                            } else {
                                break;
                            }
                        }

                    } else if (triggerfield.equals(cfield)) {
                        if (ctype.equals("datetime")
                                || ctype.equals("nvarchar")) {
                            if (null == cfieldValue || "".equals(cfieldValue)) {
                                if (cfunction.indexOf("@" + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + cfield
                                            + "@", "null");
                                } else if (cfunction.indexOf("@" + ctable + "." + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + ctable + "." + cfield + "@", "null");
                                }
                            } else {
                                if (cfunction.indexOf("@" + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + cfield
                                            + "@", "'" + cfieldValue + "'");
                                } else if (cfunction.indexOf("@" + ctable + "." + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + ctable + "." + cfield + "@", "'" + cfieldValue + "'");
                                }
                            }
                        } else {
                            if (null == cfieldValue || "".equals(cfieldValue)) {
                                if (cfunction.indexOf("@" + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + cfield
                                            + "@", "0");
                                } else if (cfunction.indexOf("@" + ctable + "." + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + ctable + "." + cfield + "@", "0");
                                }
                            } else {
                                if (cfunction.indexOf("@" + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + cfield
                                            + "@", cfieldValue);
                                } else if (cfunction.indexOf("@" + ctable + "." + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + ctable + "." + cfield + "@", cfieldValue);
                                }
                            }
                        }
                    } else if (null != ctable && !"".equals(ctable)
                            && cfieldMap.containsKey(ctable)) {
                        if (ctype.equals("datetime")
                                || ctype.equals("nvarchar")) {
                            if (null == cfieldValue || "".equals(cfieldValue)) {
                                if (cfunction.indexOf("@" + ctable + "." + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + ctable
                                            + "." + cfield + "@", "null");
                                } else if (cfunction.indexOf("@" + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + cfield + "@", "null");
                                }
                            } else {
                                if (cfunction.indexOf("@" + ctable + "." + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + ctable
                                            + "." + cfield + "@", "'" + cfieldValue
                                            + "'");
                                } else if (cfunction.indexOf("@" + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + cfield + "@", "'" + cfieldValue
                                            + "'");
                                }
                            }
                        } else {
                            if (null == cfieldValue || "".equals(cfieldValue)) {
                                if (cfunction.indexOf("@" + ctable + "." + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + ctable
                                            + "." + cfield + "@", "0");
                                } else if (cfunction.indexOf("@" + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + cfield + "@", "0");
                                }
                            } else {
                                if (cfunction.indexOf("@" + ctable + "." + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + ctable
                                            + "." + cfield + "@", cfieldValue);
                                } else if (cfunction.indexOf("@" + cfield + "@") != -1) {
                                    cfunction = cfunction.replace("@" + cfield + "@", cfieldValue);
                                }
                            }
                        }
                    } else if (objMap.containsKey(cfield)
                            && null != objMap.get(cfield)
                            && !"".equals(objMap.get(cfield))) {
                        if (ctype.equals("datetime")
                                || ctype.equals("nvarchar")) {
                            if (null == objMap.get(cfield)
                                    || "".equals(objMap.get(cfield).toString())) {
                                cfunction = cfunction.replace("@" + cfield
                                        + "@", "null");
                            } else {
                                cfunction = cfunction.replace("@" + cfield
                                        + "@", "'"
                                        + objMap.get(cfield).toString() + "'");
                            }
                        } else {
                            if (null == objMap.get(cfield)
                                    || "".equals(objMap.get(cfield).toString())) {
                                cfunction = cfunction.replace("@" + cfield
                                        + "@", "0");
                            } else {
                                cfunction = cfunction.replace("@" + cfield
                                        + "@", objMap.get(cfield).toString());
                            }
                        }
                    } else {
                        if (ctype.equals("int") || ctype.equals("float")) {
                            if (null != ctable && !"".equals(ctable)) {
                                cfunction = cfunction.replace("@" + ctable
                                        + "." + cfield + "@", "0");
                            } else {
                                cfunction = cfunction.replace("@" + cfield
                                        + "@", "0");
                            }
                        } else if (ctype.equals("nvarchar")) {
                            if (null != ctable && !"".equals(ctable)) {
                                cfunction = cfunction.replace("@" + ctable
                                        + "." + cfield + "@", "null");
                            } else {
                                cfunction = cfunction.replace("@" + cfield
                                        + "@", "null");
                            }
                        } else if (ctype.equals("datetime")) {
                            cfunction = cfunction.replace("@" + cfield + "@",
                                    "null");
                        }
                    }
                }
            }

            String sql = "select " + cfunction + " as value";
            try {
                List lis = this.assemblyQuerySql(sql);
                HashMap lisValue = (HashMap) lis.get(0);
                String val = null;
                if (null != lisValue.get("value")) {
                    val = lisValue.get("value").toString();
                }

                if (objMap.containsKey(resultCtable.toLowerCase())) {
                    List tablArr = (List) objMap.get(resultCtable);
                    if (null == tablArr) {
                        tablArr = new ArrayList();
                    }
                    if (tablArr.size() > 0) {
                        int count = tablArr.indexOf(dataObj);
                        tablArr.remove(count);
                        dataObj.put(resultCfield, val);
                        tablArr.add(count, dataObj);
                    } else {
                        dataObj.put(resultCfield, val);
                        tablArr.add(dataObj);
                    }
                    objMap.put(resultCtable, tablArr);
                } else {
                    objMap.put(resultCfield, val);
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        objMap.put("all_tableList", funMap.get("all_tableList"));
        return objMap;
    }

    // 计算聚合函数
    private float onGetColValue(List tableList, String cfield, String cfunction) {
        float num = 0;
        float cfieldNum = 0;
        for (int i = 0; i < tableList.size(); i++) {
            HashMap tableMap = (HashMap) tableList.get(i);

            if (null == tableMap.get(cfield)
                    || tableMap.get(cfield).toString().trim().equals("")) {
                cfieldNum = 0;
            } else {
                cfieldNum = Float.valueOf(tableMap.get(cfield).toString());
            }
            if (cfunction.indexOf("getcolsum") != -1
                    || cfunction.indexOf("getcolavg") != -1) {
                num += cfieldNum;
            } else if (cfunction.indexOf("getcolmax") != -1) {
                if (num == 0 || cfieldNum > num) {
                    num = cfieldNum;
                }
            } else if (cfunction.indexOf("getcolmin") != -1) {
                if (num == 0 || cfieldNum < num) {
                    num = cfieldNum;
                }
            }
        }
        if (cfunction.indexOf("getcolavg") != -1) {
            num = num / tableList.size();
        }
        return num;
    }

    // 查询回写记录
    public List queryWrite(int ifuncregedit) {
        return this.queryForList("query_AC_Write", ifuncregedit);
    }

    // 拼装更新sql
    public HashMap getWriteSql(List writeLit) {
        HashMap sqlMap = new HashMap();

        // 先找出相同表里面的所有要更新的字段
        String ctable = "";
        String ctable2 = "";
        // 修改语句
        StringBuffer updateSql = new StringBuffer();
        int count = 0;
        int bMain = 0;
        int size = 0;
        int ifuncregedit2 = 0;
        StringBuffer writeBackSql = new StringBuffer();
        HashMap updateSqlMap = new HashMap();
        HashMap ifuncregeditMap = new HashMap();
        StringBuffer deleteSql = new StringBuffer();
        for (int i = 0; i < writeLit.size(); i++) {
            HashMap writeMap = (HashMap) writeLit.get(i);
            if (ifuncregedit2 != Integer.valueOf(writeMap.get("ifuncregedit2")
                    .toString())) {
                writeBackSql = new StringBuffer();
                ifuncregeditMap = new HashMap();
                deleteSql = new StringBuffer();
                updateSql = new StringBuffer();
                ifuncregedit2 = Integer.valueOf(writeMap.get("ifuncregedit2")
                        .toString());
                count = 0;
                size = 0;
                ctable = "";
                ctable2 = "";
                sqlMap.put(ifuncregedit2, ifuncregeditMap);
            } else {
                continue;
            }
            for (int j = i; j < writeLit.size(); j++) {
                HashMap writeMap2 = (HashMap) writeLit.get(j);
                if (writeMap.get("ifuncregedit2").toString().equals(
                        writeMap2.get("ifuncregedit2").toString())) {
                    // 如果是相同的表名,
                    if (ctable.equals("")
                            || !ctable.equals(writeMap2.get("ctable2")
                            .toString())
                            || ifuncregedit2 != Integer.valueOf(writeMap2.get(
                            "ifuncregedit2").toString())) {
                        if (!ctable.equals("")) {
                            if (writeBackSql.length() > 0) {
                                if (bMain == 1) {
                                    writeBackSql
                                            .append(" where iid=#iinvoice#;");
                                } else {
                                    writeBackSql
                                            .append(" where iid=#iinvoices#;");
                                }
                            }
                            if (deleteSql.length() > 0) {
                                if (bMain == 1) {
                                    deleteSql.append(" where iid=#iinvoice#;");
                                } else {
                                    deleteSql.append(" where iid=#iinvoices#;");
                                }
                            }
                            if (bMain == 1) {
                                updateSql.append(" where iid=#iinvoice#;");
                            } else {
                                updateSql.append(" where iid=#iinvoices#;");
                            }
                            updateSqlMap = new HashMap();
                            updateSqlMap.put("updateSql", updateSql.toString());
                            if (writeBackSql.length() > 0) {
                                updateSqlMap.put("writeBackSql", writeBackSql
                                        .toString());
                                updateSqlMap.put("deleteSql", deleteSql
                                        .toString());
                            }
                            ifuncregeditMap.put(ctable2, updateSqlMap);
                        }
                        ctable2 = writeMap2.get("ctable").toString();
                        ctable = writeMap2.get("ctable2").toString();
                        bMain = Integer.valueOf(writeMap2.get("bMain")
                                .toString());
                        updateSql = new StringBuffer();
                        writeBackSql = new StringBuffer();
                        deleteSql = new StringBuffer();
                        updateSql.append("update ");
                        updateSql.append(ctable);
                        updateSql.append(" set ");
                        count = 0;
                        size = 0;
                    }
                    if (count > 0) {
                        updateSql.append(",");
                    }
                    count++;
                    updateSql
                            .append(writeMap2.get("cfield2").toString().trim());
                    updateSql.append("=");
                    if (null != writeMap2.get("cpushfunction")
                            && !"".equals(writeMap2.get("cpushfunction")
                            .toString().trim())) {
                        // 反写
                        if (size == 0) {
                            writeBackSql.append("update ");
                            writeBackSql.append(ctable);
                            writeBackSql.append(" set ");
                            deleteSql.append("update ");
                            deleteSql.append(ctable);
                            deleteSql.append(" set ");
                        }
                        String cpullfunction = writeMap2.get("cpushfunction")
                                .toString().trim().replace(
                                        "@"
                                                + writeMap2.get("cfield2")
                                                .toString().trim()
                                                + "@",
                                        "isnull("
                                                + writeMap2.get("cfield2")
                                                .toString().trim()
                                                + ",0)").replace(
                                        "@"
                                                + writeMap2.get("cfield")
                                                .toString().toString()
                                                .trim() + "@",
                                        "#"
                                                + writeMap2.get("cfield")
                                                .toString().toString()
                                                .trim() + "#");
                        updateSql.append(cpullfunction);
                        // 反写
                        writeBackSql.append(writeMap2.get("cfield2").toString()
                                .trim());
                        writeBackSql.append("=");
                        writeBackSql.append(writeMap2.get("cfield2").toString()
                                .trim()
                                + "-");
                        writeBackSql.append(("(select "));
                        writeBackSql.append(writeMap2.get("cfield").toString()
                                .trim()
                                + " from ");
                        writeBackSql.append(writeMap2.get("ctable").toString()
                                + " where iid=#iid#)");
                        String cfieldSql = "isnull("
                                + writeMap2.get("cfield2").toString().trim()
                                + ",0)";
                        writeBackSql.append(cpullfunction.substring(cfieldSql
                                .length()));

                        deleteSql.append(writeMap2.get("cfield2").toString()
                                .trim());
                        deleteSql.append("=");
                        deleteSql.append(writeMap2.get("cfield2").toString()
                                .trim());
                        deleteSql.append("-");
                        deleteSql.append(("(select "));
                        deleteSql.append(writeMap2.get("cfield").toString()
                                .trim()
                                + " from ");
                        deleteSql.append(writeMap2.get("ctable").toString()
                                + " where iid=#iid#)");
                    } else {
                        updateSql.append("#"
                                + writeMap2.get("cfield").toString() + "#");
                    }
                    if (j == writeLit.size() - 1) {
                        if (writeBackSql.length() > 0) {
                            if (bMain == 1) {
                                writeBackSql.append(" where iid=#iinvoice#;");
                            } else {
                                writeBackSql.append(" where iid=#iinvoices#;");
                            }
                        }
                        if (deleteSql.length() > 0) {
                            if (bMain == 1) {
                                deleteSql.append(" where iid=#iinvoice#;");
                            } else {
                                deleteSql.append(" where iid=#iinvoices#;");
                            }
                        }
                        if (bMain == 1) {
                            updateSql.append(" where iid=#iinvoice#;");
                        } else {
                            updateSql.append(" where iid=#iinvoices#;");
                        }
                        updateSqlMap = new HashMap();
                        updateSqlMap.put("updateSql", updateSql.toString());
                        if (writeBackSql.length() > 0) {
                            updateSqlMap.put("writeBackSql", writeBackSql
                                    .toString());
                            updateSqlMap.put("deleteSql", deleteSql.toString());
                        }
                        ifuncregeditMap.put(ctable2, updateSqlMap);
                    }
                } else if (ifuncregedit2 == Integer.valueOf(writeMap.get(
                        "ifuncregedit2").toString())) {
                    if (writeBackSql.length() > 0) {
                        if (bMain == 1) {
                            writeBackSql.append(" where iid=#iinvoice#;");
                        } else {
                            writeBackSql.append(" where iid=#iinvoices#;");
                        }
                    }
                    if (deleteSql.length() > 0) {
                        if (bMain == 1) {
                            deleteSql.append(" where iid=#iinvoice#;");
                        } else {
                            deleteSql.append(" where iid=#iinvoices#;");
                        }
                    }
                    if (bMain == 1) {
                        updateSql.append(" where iid=#iinvoice#;");
                    } else {
                        updateSql.append(" where iid=#iinvoices#;");
                    }
                    updateSqlMap = new HashMap();
                    updateSqlMap.put("updateSql", updateSql.toString());
                    if (writeBackSql.length() > 0) {
                        updateSqlMap.put("writeBackSql", writeBackSql
                                .toString());
                        updateSqlMap.put("deleteSql", deleteSql.toString());
                    }
                    ifuncregeditMap.put(ctable2, updateSqlMap);
                    break;
                }
            }
        }
        return sqlMap;
    }

    // 回写
    public void writeBack(HashMap paramMap) throws Exception, RuntimeException {
        if (paramMap.containsKey("writeMap")) {
            HashMap valueMap = (HashMap) paramMap.get("value");
            HashMap writeMap = (HashMap) paramMap.get("writeMap");
            HashMap ifuncregeditMap = (HashMap) writeMap.get(valueMap.get("ifuncregedit"));
            if (null != ifuncregeditMap) {
                List<String> keys = getHashMapKeys(ifuncregeditMap);

                HashMap deleteObj = (HashMap) paramMap.get("deleteObj");
                String sql = "";
                for (int u = 0; u < keys.size(); u++) {
                    String childsql = keys.get(u).toString();
                    HashMap writeChildMap = (HashMap) ifuncregeditMap
                            .get(childsql);
                    // 子表
                    if (valueMap.containsKey(childsql)) {
                        List childList = (List) valueMap.get(childsql);
                        // 判断子表中是否有记录
                        if (null != childList && childList.size() > 0) {
                            for (int i = 0; i < childList.size(); i++) {

                                HashMap childMap = (HashMap) childList.get(i);
                                if (paramMap.get("curButtonStatus").equals(
                                        "onEdit")) {
                                    if (null != writeChildMap
                                            .get("writeBackSql")
                                            && null != childMap.get("iid")
                                            && !"".equals(childMap.get("iid"))
                                            && !"0".equals(childMap.get("iid"))) {
                                        String writeBackSql = writeChildMap
                                                .get("writeBackSql").toString();
                                        sql += getSql(childMap, writeBackSql, 0);
                                    }
                                    //tb  修改  回写  add
                                    else{

                                        String updateSql = writeChildMap.get(
                                                "updateSql").toString();
                                        sql += getSql(childMap, updateSql, 0);
                                    }

                                }
                                //tb add 新增 回写 修改
                                else if(paramMap.get("curButtonStatus").equals(
                                        "onNew")){
                                    String updateSql = writeChildMap.get(
                                            "updateSql").toString();
                                    sql += getSql(childMap, updateSql, 0);
                                }
                            }
                        }
                        // 删除反写记录
                        if (paramMap.get("curButtonStatus").equals("onEdit")
                                || paramMap.get("curButtonStatus").equals(
                                "onDelete")) {
                            List deleteSqlList = (List) deleteObj.get(childsql);
                            if (deleteSqlList.size() > 0) {
                                for (int i = 0; i < deleteSqlList.size(); i++) {
                                    HashMap deleteMap = (HashMap) deleteSqlList
                                            .get(i);
                                    String deleteSql = writeChildMap.get(
                                            "deleteSql").toString();
                                    sql += getSql(deleteMap, deleteSql, 0);
                                }
                            }
                        }
                    } else {
                        if (paramMap.get("curButtonStatus").equals("onDelete")) {
                            if (null != writeChildMap.get("deleteSql")) {
                                String deleteSql = writeChildMap.get(
                                        "deleteSql").toString();
                                sql += getSql(valueMap, deleteSql, 0);
                            }
                        } else if (paramMap.get("curButtonStatus").equals(
                                "onEdit")) {
                            String writeBackSql = writeChildMap.get(
                                    "writeBackSql").toString();
                            sql += getSql(valueMap, writeBackSql, 0);
                        } else {
                            String updateSql = writeChildMap.get("updateSql")
                                    .toString();
                            sql += getSql(valueMap, updateSql, 0);
                        }
                    }
                }

                if (!sql.equals("")) {
                    HashMap<String, Object> paraMap = new HashMap<String, Object>();
                    paraMap.put("sqlValue", sql);
                    this.update("DatadictionaryDest.updateDataList", paraMap);
                }
            }
        }
    }

    public List queryStatement(String sql) {
        HashMap param = new HashMap();
        param.put("csql", sql);
        try {
            return this.queryForList("get_statements_sql", param);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public List queryKnowledge() {
        return this.queryForList("query_sr_knowledge");
    }

    public List queryKnowledgeByCModer(HashMap param) {
        return this.queryForList("query_sr_knowledgeByCModer", param);
    }

    public void updateSql(String sql) {
        HashMap<String, Object> paraMap = new HashMap<String, Object>();
        paraMap.put("sqlValue", sql);
        this.update("DatadictionaryDest.updateDataList", paraMap);
    }

    public Object executeSqlList(HashMap param) throws Exception {
        // TODO Auto-generated method stub

        HashMap<String, Object> hs = new HashMap<String, Object>();
        HashMap<String, Object> hs_temp = new HashMap<String, Object>();
        hs_temp = initSql(param);
        hs.put("sqlValue", hs_temp.get("sqlValue"));

        this.update("DatadictionaryDest.updateDataList", hs);
        return hs_temp.get("table_id");
    }

    public HashMap<String, Object> initSql(HashMap param) {

        String tableName = param.get("tablename").toString();
        String tableNamecn = String.valueOf(param.get("tablenamecn"));
        String vmeno = String.valueOf(param.get("vmeno"));
        String sel_sql = "select id from sysobjects where id = object_id(N'" + tableName + "') and objectproperty(id,'IsTable')=1";
        String table_id = "";
        try {
            HashMap p = (HashMap) this.assemblyQuerySql(
                    sel_sql).get(0);
            table_id = String.valueOf(p.get("id"));
        } catch (Exception e) {
            // TODO Auto-generated catch block
            e.printStackTrace();
        }
        String insertSql = param.get("insertSql").toString();
        insertSql = insertSql + ";insert into ac_table values(" + table_id + ",'" + tableName + "','" + tableNamecn + "','" + vmeno + "')";
        ArrayCollection arr = (ArrayCollection) param.get("value");
        String childInsertSql = "";
        for (int i = 0; i < arr.size(); i++) {
            HashMap hs = (HashMap) arr.get(i);
            String sql = "insert into ac_fields values( " + table_id + ",'" + String.valueOf(hs.get("cfield")) + "','" + String.valueOf(hs.get("ccaption")) + "'," + String.valueOf(hs.get("cmemo")) + "," + hs.get("idatatype") + "," + hs.get("ilength") + ",";
            String bempty = "0";
            if ((Boolean) hs.get("bempty")) {
                bempty = "1";
            }
            String bkey = "0";
            if ((Boolean) hs.get("bkey")) {
                bkey = "1";
            }
            sql = sql + bempty + "," + bkey + ")";
            childInsertSql = childInsertSql + sql + ";";
        }
        insertSql = insertSql + ";" + childInsertSql;
        HashMap<String, Object> paraMap = new HashMap<String, Object>();

        paraMap.put("sqlValue", insertSql);
        paraMap.put("table_id", table_id);
        return paraMap;
    }

    public String convertToIdataType(String str) {
        if (str.equals("nvarchar")) {
            return "0";
        } else if (str.equals("int")) {
            return "1";
        } else if (str.equals("float")) {
            return "2";
        } else if (str.equals("datetime")) {
            return "3";
        } else if (str.equals("bit")) {
            return "4";
        } else if (str.equals("text")) {
            return "5";
        }
        return null;
    }

    public int addSql(HashMap param)
    {
        Object obj = this.insert("add_pm", param);
        int iid = Integer.valueOf(obj.toString());
        return iid;
    }

    public void addinvoiceuser(HashMap param)
    {
        try {
            i_ab_invoiceuserService.add_ab_invoiceuser(param);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @Override
    public boolean updateListStatus(List<HashMap> list) throws Exception {
        if (list == null || list.size() == 0)
            return false;

        HashMap hm = list.get(0);
        int ifuncregedit = (Integer) hm.get("ifuncregedit");
        List<HashMap> statusList = this.utilservice.getStatusList(ifuncregedit);
        String ctable = this.utilservice.getTableNameByifuncregedit(ifuncregedit);
        if (statusList == null || statusList.size() == 0) {
            System.out.println("该功能未启用状态方案。");
            return false;
        }

        for (HashMap hashMap : list) {
            hashMap.put("ctable", ctable);
            hashMap.put("statusList", statusList);
            updateStatus(hashMap);
        }

        return true;
    }


    @Override
    public boolean updateStatus(HashMap hm) throws Exception {
        int ifuncregedit = Integer.parseInt(hm.get("ifuncregedit").toString());
        int iperson = Integer.parseInt(hm.get("iperson").toString());
        String csubject = hm.containsKey("csubject") ? hm.get("csubject").toString() : "";
        int itype = hm.containsKey("itype") ? Integer.parseInt(hm.get("itype").toString()) : 0;
        List<HashMap> list;
        if (hm.containsKey("statusList"))
            list = (List<HashMap>) hm.get("statusList");
        else
            list = this.utilservice.getStatusList(ifuncregedit);

        if (list == null || list.size() == 0) {
            System.out.println("该功能未启用状态方案。");
            return false;
        }

        int iinvoice = Integer.parseInt(hm.get("iinvoice").toString());
        int istatus = 0;
        if (hm.containsKey("istatus"))
            istatus = Integer.parseInt(hm.get("istatus").toString());

        String ctable = hm.containsKey("ctable") ?  hm.get("ctable") instanceof ASObject ? null:(String)hm.get("ctable") : null;

        if (ctable == null)
            ctable = this.utilservice.getTableNameByifuncregedit(ifuncregedit);

        if (istatus == 0)
            istatus = Integer.parseInt(list.get(0).get("istatus").toString());//传0，取初始值

        //else if (istatus == 65536)
        //    istatus = Integer.parseInt(list.get(list.size() - 1).get("istatus").toString());//传-1，取最终值

        String sql = "update " + ctable + " set istatus=" + istatus;

        if (istatus > 0 && itype != 3) // 3 是撤销 4 是关联更新状态
            sql += " ,istatusp=" + iperson + " ,dstatus = '" + ToolUtil.formatDay(new Date(), null) + "' ";

        if (itype == 3) {
            HashMap hashMap = new HashMap();
            hashMap.put("ifuncregedit", ifuncregedit);
            hashMap.put("iinvoice", iinvoice);
            hashMap.put("istatus", istatus);
            List<HashMap> mapList = this.queryForList("getLasStatusPositive", hashMap);
            if (mapList != null && mapList.size() > 0) {
                HashMap last = mapList.get(0);
                sql += " ,istatusp=" + last.get("imaker") + " ,dstatus = '" + last.get("dmaker") + "' ";
            }
        }


        sql += " where iid = " + iinvoice;

        this.utilservice.exeSql(sql);

        HashMap insertParam = new HashMap();
        insertParam.put("ifuncregedit", ifuncregedit);
        insertParam.put("iinvoice", iinvoice);
        insertParam.put("istatus", istatus);
        insertParam.put("imaker", iperson);
        insertParam.put("csubject", csubject);
        insertParam.put("itype", itype);
        insertParam.put("dmaker", ToolUtil.formatDay(new Date(), null));
        this.insert("insertInvoicestatus", insertParam);

        checkRelationFormStatus(insertParam);

        return true;
    }
    private void checkRelationFormStatus(HashMap param) throws Exception {
        List<HashMap> statusrls = this.queryForList("getStatusrls", param);
        if (statusrls.size() > 0) {
            for (HashMap _statusrls : statusrls) {
                _statusrls.put("iinvoice", param.get("iinvoice"));
                String sql = "select iinvoice from " + _statusrls.get("ctable") + " where "
                        + _statusrls.get("cfield") + "=" + _statusrls.get("iinvoice") + " and ifuncregedit=" + _statusrls.get("ifuncregedit");
                List<HashMap> relationFormList = this.utilservice.exeSql(sql);
                if (relationFormList.size() > 0) {
                    for (HashMap _iid : relationFormList) {
                        int iinvoice = _iid.get("iinvoice") != null ? Integer.parseInt(_iid.get("iinvoice").toString()) : 0;
                        if (iinvoice > 0) {
                            HashMap insertParam = new HashMap();
                            insertParam.put("ifuncregedit", _statusrls.get("ifuncregedit"));
                            insertParam.put("iinvoice", iinvoice);
                            insertParam.put("istatus", _statusrls.get("icstatus"));
                            insertParam.put("iperson", param.get("imaker"));
                            insertParam.put("csubject", param.get("csubject") + "__通过状态关系绑定，进入到当前状态。");
                            insertParam.put("itype", 4);
                            insertParam.put("dmaker", ToolUtil.formatDay(new Date(), null));
                            updateStatus(insertParam);
                        }
                    }

                }
            }
        }
    }

    @Override
    public HashMap getStatus(HashMap hm) throws Exception {
        HashMap result = new HashMap();
        int ifuncregedit = Integer.parseInt(hm.get("ifuncregedit").toString());

        List<HashMap> list = this.utilservice.getStatusList(ifuncregedit);
        if (list == null || list.size() == 0) {
            System.out.println("该功能未启用状态方案。");
            result.put("list", null);
        } else {
            result.put("list", list);
            int iinvoice = hm.containsKey("iinvoice") ? Integer.parseInt(hm.get("iinvoice").toString()) : 0;
            if (iinvoice > 0) {
                String ctable = hm.containsKey("ctable") ? (String) hm.get("ctable") : null;

                if (ctable == null)
                    ctable = this.utilservice.getTableNameByifuncregedit(ifuncregedit);

                String sql = "select  istatus,istatusp,convert(varchar(19),dstatus,120) as dstatus from " + ctable + "  where iid = " + iinvoice;
                List<HashMap> form = this.utilservice.exeSql(sql);
                if (form == null || form.size() == 0) {
                    System.out.println("单据未找到。");
                    result.put("list", null);
                } else {
                    result.put("istatus", form.get(0).get("istatus"));
                    result.put("dstatus", form.get(0).get("dstatus"));
                    result.put("istatusp", form.get(0).get("istatusp"));
                }
            }
        }

        return result;
    }


}
