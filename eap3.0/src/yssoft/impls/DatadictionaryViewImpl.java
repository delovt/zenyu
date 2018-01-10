/**
 * 模块名称：DatadictionaryViewImpl
 * 模块说明：接口实现类、数据访问类
 * 创建人：	YJ
 * 创建日期：20110810
 * 修改人：
 * 修改日期：
 *
 */

package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IDatadictionaryService;
import yssoft.utils.ToXMLUtil;

import java.util.HashMap;
import java.util.List;
import java.util.regex.Pattern;

public class DatadictionaryViewImpl extends BaseDao implements IDatadictionaryService {

    @SuppressWarnings("unchecked")
    public List<HashMap> getTreeMenuList(HashMap paramMap) {
        List<HashMap> list = this.queryForList("DatadictionaryDest.getTreeMenu2", paramMap);
        return list;
    }

    public List<HashMap> getTable(HashMap paramMap) {
        return this.queryForList("DatadictionaryDest.getTable", paramMap);
    }

    @SuppressWarnings("unchecked")
    public List<HashMap> getDataList(HashMap param) {
        return this.queryForList("DatadictionaryDest.getDataList", param);
    }

    //更新数据字典
    @SuppressWarnings("unchecked")
    public HashMap updateDatadictonary() {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();
        HashMap<String, Object> paraMap = new HashMap<String, Object>();
        String sql = "";


        sql = sql + " delete from ac_datadictionary where ctable not in (select ctable from AC_table);";

        //删除表中不存在的字段字典
        sql = sql + " delete from ac_datadictionary where ctable+cfield not in (SELECT t.ctable+f.cfield" +
                " from AC_fields f left join AC_table t on f.itable=t.iid);";


        //更新子表的字段类型、字段长度
        sql = sql + " update ac_datadictionary set idatatype=a.idatatype,ilength=a.ilength " +
                " from ac_datadictionary, " +
                "(SELECT t.ctable,f.cfield,ilength,idatatype from AC_fields f left join AC_table t on f.itable=t.iid)" +
                " a where a.ctable+a.cfield=ac_datadictionary.ctable+ac_datadictionary.cfield ;";

        sql = sql + "insert into ac_datadictionary(ifuncregedit,ctable,cfield,idatatype,ilength,ccaption)" +
                "select d.ifuncregedit,a.* from ( select t.ctable,f.cfield, f.idatatype,f.ilength,f.ccaption " +
                "from AC_fields f  left join AC_table t on t.iid=f.itable where t.ctable in " +
                "(select ctable from ac_tableRelationship) and f.cfield not in " +
                "(select cfield from ac_datadictionary where ctable=t.ctable)) a left join ac_tableRelationship d on a.ctable=d.ctable;";

        paraMap.put("sqlValue", sql);
        try {
            this.update("DatadictionaryDest.updateDataList", paraMap);
            resultMap.put("message", "写入成功!");
        } catch (Exception ex) {
            ex.printStackTrace();
            resultMap.put("message", "写入失败!");
        } finally {
            paraMap.clear();
            sql = "";
        }
        return resultMap;
    }

    public HashMap adddDatadictonary(HashMap paramMap) {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();
        HashMap<String, Object> paraMap = new HashMap<String, Object>();
        String sql = "";
        int ifuncregedit = Integer.valueOf(paramMap.get("ifuncregedit").toString());
        String tableName = paramMap.get("ctable").toString();

        HashMap param = new HashMap();
        param.put("ifuncregedit", ifuncregedit);
        param.put("tablename", tableName);
        List list = this.queryForList("DatadictionaryDest.getTable", param);
        if (list.size() > 0) {
            resultMap.put("message", "表已存在!");
        } else {
            sql += " insert into AC_datadictionary(ifuncregedit," +
                    "ctable,cfield,ccaption,idatatype,ilength)  " +
                    " select " + ifuncregedit + ",t.ctable,fi.cfield,fi.ccaption," +
                    "fi.idatatype,fi.ilength from AC_fields fi " +
                    "left join AC_table t on fi.itable=t.iid " +
                    " where t.ctable='" + tableName + "'";
            try {
                paraMap.put("sqlValue", sql);
                int count = this.update("DatadictionaryDest.updateDataList", paraMap);

                if (count <= 0) {
                    resultMap.put("message", "表不存在!");
                } else {
                    Object obj = this.addTableRelationship(paramMap);
                    resultMap.put("message", "新增成功!");
                    resultMap.put("iid", obj);
                }
            } catch (Exception ex) {
                ex.printStackTrace();
                resultMap.put("message", "新增失败!");
            } finally {
                paraMap.clear();
                sql = "";
            }
        }
        return resultMap;
    }

    /**
     * 函数名称：saveDatadictonary
     * 函数说明：保存数据字典
     * 函数参数：Array
     * 函数返回：HashMap
     * 创建人：	YJ
     * 创建日期：20110810
     * 修改人：
     * 修改日期：
     */
    @SuppressWarnings("unchecked")
    public HashMap saveDatadictonary(HashMap paramMap) {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();
        HashMap<String, Object> paraMap = new HashMap<String, Object>();
        String sql = "";

        System.out.println(paramMap.get("ifuncregedit").toString());

        List datalist = (List) paramMap.get("datalist");

        HashMap mainValue = (HashMap) paramMap.get("mainValue");
        sql += "update ac_tableRelationship set ccode='" + mainValue.get("ccode").toString() + "',ctable='"
                + mainValue.get("ctable") + "',ctable2='" + mainValue.get("ctable2") + "',foreignKey='" + mainValue.get("foreignKey")
                + "',primaryKey='" + mainValue.get("primaryKey") + "', cfunction='" + mainValue.get("cfunction") + "',bMain='" +
                mainValue.get("bMain").toString() + "' where ifuncregedit=" + paramMap.get("ifuncregedit")
                + " and ctable='" + mainValue.get("ctable") + "';";
        for (Object dataItem : datalist) {
            HashMap record = (HashMap) dataItem;

            //YJ Add 20120912 数据批改字段
            int bbatchupdate = 0;
            if (record.get("bbatchupdate") == null || (Boolean) record.get("bbatchupdate") == false) bbatchupdate = 0;
            else bbatchupdate = 1;

            sql += "update AC_datadictionary set " +
                    "ccaption=" + ((record.get("ccaption") == null) ? null : "'" + record.get("ccaption").toString().trim() + "'") + "," +
                    "bprefix=" + (((Boolean) record.get("bprefix") == false) ? 0 : 1) + "," +
                    "bwfentry=" + (((Boolean) record.get("bwfentry") == false) ? 0 : 1) + "," +
                    "bsystem=" + (((Boolean) record.get("bsystem") == false) ? 0 : 1) + "," +
                    "bwfcd=" + (((Boolean) record.get("bwfcd") == false) ? 0 : 1) + "," +
                    "cregularfunction=" + ((record.get("cregularfunction") == null) ? null : "'" + record.get("cregularfunction").toString().trim() + "'") + "," +
                    "cregularmessage=" + ((record.get("cregularmessage") == null) ? null : "'" + record.get("cregularmessage").toString().trim() + "'") + "," +
                    "cunique=" + ((record.get("cunique") == null) ? null : "'" + record.get("cunique").toString().trim() + "'") + "," +
                    "cfunction=" + ((record.get("cfunction") == null) ? null : "'" + record.get("cfunction").toString().trim().replace("'", "`") + "'") + "," +
                    "cresfunction=" + ((record.get("cresfunction") == null) ? null : "'" + record.get("cresfunction").toString().trim().replace("'", "`") + "'") + "," +
                    "cresmessage=" + ((record.get("cresmessage") == null) ? null : "'" + record.get("cresmessage").toString().trim() + "'") + "," +
                    "binvoiceuser=" + (((Boolean) record.get("binvoiceuser") == false) ? 0 : 1) +
                    ",cresfunctionread=" + ((record.get("cresfunctionread") == null) ? null : "'" + record.get("cresfunctionread").toString().trim() + "'") +
                    ",bintitle=" + (((Boolean) record.get("bintitle") == false) ? 0 : 1) +
                    ",bbatchupdate=" + bbatchupdate +
                    ",bunique=" + (((Boolean) record.get("bunique") == false) ? 0 : 1) +
                    " where ifuncregedit=" + paramMap.get("ifuncregedit") + " and ctable='" + record.get("ctable").toString().trim() + "' and cfield='" + record.get("cfield").toString().trim() + "';";

            String querySql = "select * from Ac_consultConfiguration where idatadictionary="
                    + "(select iid from AC_datadictionary where ifuncregedit='"
                    + paramMap.get("ifuncregedit") + "'  and ctable='" + record.get("ctable")
                    + "' and cfield='" + record.get("cfield") + "')";
            int count = this.queryForList("assembly_query_sql", querySql).size();
            if ((record.get("iconsult") != null && Integer.valueOf(record.get("iconsult").toString()) > 0) || (null != record.get("cconsultfunction") && !"".equals(record.get("cconsultfunction").toString()))) {
                if (count > 0) {
                    sql += "update Ac_consultConfiguration set iconsult=" +
                            ((record.get("iconsult") == null) ? 0 : record.get("iconsult").toString().trim())
                            + ",cconsulttable=" + ((record.get("cconsulttable") == null) ? null : "'" + record.get("cconsulttable").toString().trim() + "'")
                            + ",cconsultbkfld=" + ((record.get("cconsultbkfld") == null) ? null : "'" + record.get("cconsultbkfld").toString().trim() + "'") + ",cconsultswfld=" +
                            ((record.get("cconsultswfld") == null) ? null : "'" + record.get("cconsultswfld").toString().trim() + "'") + ",cconsultipvf=" +
                            ((record.get("cconsultipvf") == null) ? null : "'" + record.get("cconsultipvf").toString().trim() + "'") + ",bconsultmtbk=" +
                            (((Boolean) record.get("bconsultmtbk") == false) ? 0 : 1) + ",bconsultendbk=" +
                            (((Boolean) record.get("bconsultendbk") == false) ? 0 : 1) + ",bconsultcheck=" +
                            (((Boolean) record.get("bconsultcheck") == false) ? 0 : 1) + ",cconsultconfld=" +
                            ((record.get("cconsultconfld") == null) ? null : "'" + record.get("cconsultconfld").toString().trim() + "'") + ",benabled=" +
                            (((Boolean) record.get("benabled") == false) ? 0 : 1) + ",cconsultcondition=" +
                            ((record.get("cconsultcondition") == null) ? null : "'" + record.get("cconsultcondition").toString().trim().replace("'", "`") + "'") + ",cconsultfunction=" +
                            ((record.get("cconsultfunction") == null) ? null : "'" + record.get("cconsultfunction").toString().trim() + "'") + ",cconsultedit=" +
                            ((record.get("cconsultedit") == null) ? null : "'" + record.get("cconsultedit").toString().trim() + "'") +
                            ", cclassviewcondition=" + ((record.get("cclassviewcondition") == null) ? null : "'" + record.get("cclassviewcondition").toString().trim() + "'") +
                            ", bclassview=" + (((Boolean) record.get("bclassview") == false) ? 0 : 1) +
                            ", cclasstitle=" + ((record.get("cclasstitle") == null) ? null : "'" + record.get("cclasstitle").toString().trim() + "'") +
                            " where idatadictionary=(select iid from AC_datadictionary where ifuncregedit='" +
                            paramMap.get("ifuncregedit").toString().trim() + "'  and ctable='" +
                            record.get("ctable").toString().trim() + "' and cfield='" + record.get("cfield").toString().trim() + "');";
                } else {
                    sql += "insert into Ac_consultConfiguration(idatadictionary,cconsultcondition,iconsult,cconsulttable,cconsultbkfld,cconsultswfld," +
                            "cconsultipvf,bconsultmtbk,bconsultendbk,bconsultcheck,cconsultconfld," +
                            "benabled,cconsultfunction,cclassviewcondition,cconsultedit,bclassview,cclasstitle) select iid," +
                            ((record.get("cconsultcondition") == null) ? null : "'" + record.get("Cconsultcondition").toString().trim().replace("'", "`") + "'") + "," +
                            ((record.get("iconsult") == null) ? 0 : record.get("iconsult").toString().trim()) + "," +
                            ((record.get("cconsulttable") == null) ? null : "'" + record.get("cconsulttable").toString().trim() + "'") + "," +
                            ((record.get("cconsultbkfld") == null) ? null : "'" + record.get("cconsultbkfld").toString().trim() + "'") + "," +
                            ((record.get("cconsultswfld") == null) ? null : "'" + record.get("cconsultswfld").toString().trim() + "'") + "," +
                            ((record.get("cconsultipvf") == null) ? null : "'" + record.get("cconsultipvf").toString().trim() + "'") + "," +
                            (((Boolean) record.get("bconsultmtbk") == false) ? 0 : 1) + "," +
                            (((Boolean) record.get("bconsultendbk") == false) ? 0 : 1) + "," +
                            (((Boolean) record.get("bconsultcheck") == false) ? 0 : 1) + "," +
                            ((record.get("cconsultconfld") == null) ? null : "'" + record.get("cconsultconfld").toString().trim() + "'") + "," +
                            (((Boolean) record.get("benabled") == false) ? 0 : 1) + "," +
                            ((record.get("cconsultfunction") == null) ? null : "'" + record.get("cconsultfunction").toString().trim() + "'") +
                            ", cclassviewcondition=" + ((record.get("cclassviewcondition") == null) ? null : "'" + record.get("cclassviewcondition").toString().trim() + "'") +
                            ", cconsultedit=" + ((record.get("cconsultedit") == null) ? null : "'" + record.get("cconsultedit").toString().trim() + "'") +
                            ", bclassview=" + (((Boolean) record.get("bclassview") == false) ? 0 : 1) +
                            ", cclasstitle=" + ((record.get("cclasstitle") == null) ? null : "'" + record.get("cclasstitle").toString().trim() + "'") +
                            " from AC_datadictionary where ifuncregedit='" + paramMap.get("ifuncregedit").toString().trim() + "' and ctable='"
                            + record.get("ctable").toString().trim() + "' and cfield='" + record.get("cfield").toString().trim() + "';";
                }
            } else if (count > 0) {
                sql += "delete from Ac_consultConfiguration where idatadictionary="
                        + "(select iid from AC_datadictionary where ifuncregedit='"
                        + paramMap.get("ifuncregedit").toString().trim() + "'  and ctable='" + record.get("ctable").toString().trim()
                        + "' and cfield='" + record.get("cfield").toString().trim() + "')";
            }
        }

        List bodyConsultArr = (List) paramMap.get("bodyConsultArr");
        String deletSqlIId = "";
        String sqlStr = "";
        int co = 0;
        for (Object dataItem : bodyConsultArr) {
            HashMap record = (HashMap) dataItem;
            if (null == record.get("iid") || record.get("iid").toString().equals("0")) {
//				if(co>0)
//				{
//					deletSqlIId+=",";
//				}
//				deletSqlIId+=record.get("iid");
                sqlStr += "insert into Ac_triggerbodyconsult(iconsultConfiguration,iconsult,"
                        + "cconsulttable,cconsultconfld,btouchrefshow,Cconsultcondition,"
                        + "bconsultmtbk,bconsultendbk,iRemoveBody,cassignmenttable) values(" +
                        ((record.get("iconsultConfiguration") == null) ? 0 : record.get("iconsultConfiguration").toString().trim()) + "," +
                        ((record.get("iconsult") == null) ? 0 : record.get("iconsult").toString().trim()) + "," +
                        ((record.get("cconsulttable") == null) ? null : "'" + record.get("cconsulttable").toString().trim() + "'") + "," +
                        ((record.get("cconsultconfld") == null) ? null : "'" + record.get("cconsultconfld").toString().trim() + "'") + "," +
                        (((Boolean) record.get("btouchrefshow") == false) ? 0 : 1) + "," +
                        ((record.get("Cconsultcondition") == null) ? null : "'" + record.get("Cconsultcondition").toString().trim().replace("'", "`").replace("'", "`") + "'") + "," +
                        (((Boolean) record.get("bconsultmtbk") == false) ? 0 : 1) + "," +
                        (((Boolean) record.get("bconsultendbk") == false) ? 0 : 1) + "," +
                        ((record.get("iRemoveBody") == null) ? 0 : record.get("iRemoveBody").toString().trim()) + "," +
                        ((record.get("cassignmenttable") == null) ? null : "'" + record.get("cassignmenttable").toString().trim() + "'") +
                        ")";
            } else {
                sqlStr += "update Ac_triggerbodyconsult set iconsult=" +
                        ((record.get("iconsult") == null) ? 0 : record.get("iconsult").toString().trim()) + ",cconsulttable=" +
                        ((record.get("cconsulttable") == null) ? null : "'" + record.get("cconsulttable").toString().trim() + "'") + ",cconsultconfld=" +
                        ((record.get("cconsultconfld") == null) ? null : "'" + record.get("cconsultconfld").toString().trim() + "'") + ",btouchrefshow=" +
                        (((Boolean) record.get("btouchrefshow") == false) ? 0 : 1) + ",Cconsultcondition=" +
                        ((record.get("Cconsultcondition") == null) ? null : "'" + record.get("Cconsultcondition").toString().trim().replace("'", "`") + "'") + ",bconsultmtbk=" +
                        (((Boolean) record.get("bconsultmtbk") == false) ? 0 : 1) + ",bconsultendbk=" +
                        (((Boolean) record.get("bconsultendbk") == false) ? 0 : 1) + ",iRemoveBody=" +
                        ((record.get("iRemoveBody") == null) ? 0 : record.get("iRemoveBody").toString().trim()) + ",cassignmenttable=" +
                        ((record.get("cassignmenttable") == null) ? null : "'" + record.get("cassignmenttable").toString().trim() + "'") +
                        " where iid=" + record.get("iid");
            }
        }
        List deleteArr = (List) paramMap.get("deleteCosultArr");
        if (deleteArr.size() > 0) {
            for (Object dataItem : deleteArr) {
                HashMap record = (HashMap) dataItem;
                if (co > 0) {
                    deletSqlIId += ",";
                }
                deletSqlIId += record.get("iid");
            }
            sql += "delete from Ac_triggerbodyconsult where iid in(" + deletSqlIId + ")";
        }
        sql += sqlStr;
        System.out.println("XZQWJ" + sql);

        paraMap.put("sqlValue", sql);

        try {
            this.update("DatadictionaryDest.updateDataList", paraMap);
            resultMap.put("message", "保存成功!");
        } catch (Exception ex) {
            ex.printStackTrace();
            resultMap.put("message", "保存失败!");
        } finally {
            paraMap.clear();
            sql = "";
        }
        return resultMap;
    }

    public Object addTableRelationship(HashMap paramMap) {
        return this.insert("add_tableRelationship", paramMap);
    }

    /**
     * getCrmRefer(查询数据字典)
     * 创建者：zhong_jing
     * 创建时间：2011-8-29 下午03:19:06
     * 修改者：
     * 修改时间：
     * 修改备注：
     *
     * @param iid
     * @return HashMap
     * @Exception 异常对象
     */
    public List getCrmRefer(HashMap iid) {
        List a = this.queryForList("DatadictionaryDest.getDataAndconsultset", iid);
        return a;
    }

    /**
     * getValue(参照转换)
     * 创建者：zhong_jing
     * 创建时间：2011-8-30 下午04:55:36
     * 修改者：
     * 修改时间：
     * 修改备注：
     *
     * @param sql
     * @return List
     */
    public List getValue(String sql) {
        return this.queryForList("getTestSql", sql);
    }


    public List getVouchForm(HashMap paramMap) {
        return this.queryForList("querey_vouchForm", paramMap);
    }

    public HashMap addVouch(HashMap paramMap) {
        String iid = this.insert("add_vouch", paramMap).toString();
        List arrDataList = (List) paramMap.get("arrDataList");
        String sql = "";
        for (Object dataItem : arrDataList) {
            HashMap record = (HashMap) dataItem;
            if (record.get("iobjecttype").toString().equals("0")) {
                sql += "insert into AC_vouchform(bmain,ccaption," +
                        "cobjectname,iobjecttype,igroupno,igrouprow,ipgroup,ichildno," +
                        "bshow,ivouch,iwidth,iheight,idatetype) values(0,";

                if (null != record.get("ccaption") && !"".equals(record.get("ccaption").toString().trim())) {
                    sql += "'" + record.get("ccaption").toString().trim() + "',";
                } else {
                    sql += null + ",";
                }

                if (null != record.get("cobjectname") && !"".equals(record.get("cobjectname").toString().trim())) {
                    sql += "'" + record.get("cobjectname").toString().trim().toUpperCase() + "',";
                } else {
                    sql += null + ",";
                }

                if (null != record.get("iobjecttype") && !"".equals(record.get("iobjecttype").toString().trim())
                        && regularExpression(record.get("iobjecttype").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("iobjecttype").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("igroupno") && !"".equals(record.get("igroupno").toString().trim())
                        && regularExpression(record.get("igroupno").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("igroupno").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("igrouprow") && !"".equals(record.get("igrouprow").toString().trim())
                        && regularExpression(record.get("igrouprow").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("igrouprow").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("ipgroup") && !"".equals(record.get("ipgroup").toString().trim())
                        && regularExpression(record.get("ipgroup").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("ipgroup").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("ichildno") && !"".equals(record.get("ichildno").toString().trim())
                        && regularExpression(record.get("ichildno").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("ichildno").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("bshow") && !"".equals(record.get("bshow").toString().trim())
                        && ("1".equals(record.get("bshow").toString().trim()) || (Boolean) record.get("bshow"))) {
                    sql += "1,";
                } else {
                    sql += "0,";
                }

                sql += iid + ",";

                if (null != record.get("iwidth") && !"".equals(record.get("iwidth").toString().trim())
                        && regularExpression(record.get("iwidth").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("iwidth").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("iheight") && !"".equals(record.get("iheight").toString().trim())
                        && regularExpression(record.get("iheight").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("iheight").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                sql += "3);";

            }
        }

        for (Object dataItem : arrDataList) {
            HashMap record = (HashMap) dataItem;
            if (record.get("iobjecttype").toString().equals("7")) {
                sql += "insert into AC_vouchform(bmain,ccaption,idecimal,bunnull,bread,cnewdefault,cnewdefaultfix" +
                        ",ceditdefault,cobjectname,iobjecttype,ipgroup,ichildno,iwidth," +
                        "iheight,bshow,idatetype,idatadictionary,ctable,ivouch) select ";

                if (null != record.get("bmain") && !"".equals(record.get("bmain").toString().trim())
                        && ("1".equals(record.get("bmain").toString().trim()) || (Boolean) record.get("bmain"))) {
                    sql += "1,";
                } else {
                    sql += "0,";
                }

                if (null != record.get("ccaption") && !"".equals(record.get("ccaption").toString().trim())) {
                    sql += "'" + record.get("ccaption").toString().trim() + "',";
                } else {
                    sql += null + ",";
                }

                if (null != record.get("idecimal") && !"".equals(record.get("idecimal").toString().trim())
                        && regularExpression(record.get("idecimal").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("idecimal").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("bunnull") && !"".equals(record.get("bunnull").toString().trim())
                        && ("1".equals(record.get("bunnull").toString().trim()) || (Boolean) record.get("bunnull"))) {
                    sql += "1,";
                } else {
                    sql += "0,";
                }

                if (null != record.get("bread") && !"".equals(record.get("bread").toString().trim())
                        && ("1".equals(record.get("bread").toString().trim()) || (Boolean) record.get("bread"))) {
                    sql += "1,";
                } else {
                    sql += "0,";
                }

                if (null != record.get("cnewdefault") && !"".equals(record.get("cnewdefault").toString().trim())) {
                    sql += "'" + record.get("cnewdefault").toString().trim() + "',";
                } else {
                    sql += null + ",";
                }

                if (null != record.get("cnewdefaultfix") && !"".equals(record.get("cnewdefaultfix").toString().trim())) {
                    sql += "'" + record.get("cnewdefaultfix").toString().trim() + "',";
                } else {
                    sql += null + ",";
                }

                if (null != record.get("ceditdefault") && !"".equals(record.get("ceditdefault").toString().trim())) {
                    sql += "'" + record.get("ceditdefault").toString().trim() + "',";
                } else {
                    sql += null + ",";
                }

                if (null != record.get("cobjectname") && !"".equals(record.get("cobjectname").toString().trim())) {
                    sql += "'" + record.get("cobjectname").toString().trim().toUpperCase() + "',";
                } else {
                    sql += null + ",";
                }

                if (null != record.get("iobjecttype") && !"".equals(record.get("iobjecttype").toString().trim())
                        && regularExpression(record.get("iobjecttype").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("iobjecttype").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                sql += "v.iid,";

                if (null != record.get("ichildno") && !"".equals(record.get("ichildno").toString().trim())
                        && regularExpression(record.get("ichildno").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("ichildno").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("iwidth") && !"".equals(record.get("iwidth").toString().trim())
                        && regularExpression(record.get("iwidth").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("iwidth").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("iheight") && !"".equals(record.get("iheight").toString().trim())
                        && regularExpression(record.get("iheight").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("iheight").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("bshow") && !"".equals(record.get("bshow").toString().trim())
                        && ("1".equals(record.get("bshow").toString().trim()) || (Boolean) record.get("bshow"))) {
                    sql += "1,";
                } else {
                    sql += "0,";
                }

                if (null != record.get("idatetype") && !"".equals(record.get("idatetype").toString().trim())
                        && regularExpression(record.get("idatetype").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("idatetype").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("idatadictionary") && !"".equals(record.get("idatadictionary").toString().trim())
                        && regularExpression(record.get("idatadictionary").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("idatadictionary").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("ctable") && !"".equals(record.get("ctable").toString().trim())) {
                    sql += "'" + record.get("ctable").toString().trim() + "',";
                } else {
                    sql += null + ",";
                }

                sql += iid;
                sql += " from AC_vouchform v where cobjectname='";
                sql += record.get("ipgroup").toString().toUpperCase().trim() + "' and ivouch=" + iid + ";";
            }
        }

        for (Object dataItem : arrDataList) {
            HashMap record = (HashMap) dataItem;
            if (!record.get("iobjecttype").toString().equals("0") && !record.get("iobjecttype").toString().equals("7")) {
                sql += "insert into AC_vouchform(bmain,ccaption,idecimal,bunnull,bread,cnewdefault,cnewdefaultfix" +
                        ",ceditdefault,cobjectname,iobjecttype,ipgroup,ichildno,iwidth," +
                        "iheight,bshow,idatetype,idatadictionary,ctable,ivouch) select ";

                if (null != record.get("bmain") && !"".equals(record.get("bmain").toString().trim())
                        && ("1".equals(record.get("bmain").toString().trim()) || (Boolean) record.get("bmain"))) {
                    sql += "1,";
                } else {
                    sql += "0,";
                }

                if (null != record.get("ccaption") && !"".equals(record.get("ccaption").toString().trim())) {
                    sql += "'" + record.get("ccaption").toString().trim() + "',";
                } else {
                    sql += null + ",";
                }

                if (null != record.get("idecimal") && !"".equals(record.get("idecimal").toString().trim())
                        && regularExpression(record.get("idecimal").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("idecimal").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("bunnull") && !"".equals(record.get("bunnull").toString().trim())
                        && ("1".equals(record.get("bunnull").toString().trim()) || (Boolean) record.get("bunnull"))) {
                    sql += "1,";
                } else {
                    sql += "0,";
                }

                if (null != record.get("bread") && !"".equals(record.get("bread").toString().trim())
                        && ("1".equals(record.get("bread").toString().trim()) || (Boolean) record.get("bread"))) {
                    sql += "1,";
                } else {
                    sql += "0,";
                }

                if (null != record.get("cnewdefault") && !"".equals(record.get("cnewdefault").toString().trim())) {
                    sql += "'" + record.get("cnewdefault").toString().trim() + "',";
                } else {
                    sql += null + ",";
                }

                if (null != record.get("cnewdefaultfix") && !"".equals(record.get("cnewdefaultfix").toString().trim())) {
                    sql += "'" + record.get("cnewdefaultfix").toString().trim() + "',";
                } else {
                    sql += null + ",";
                }

                if (null != record.get("ceditdefault") && !"".equals(record.get("ceditdefault").toString().trim())) {
                    sql += "'" + record.get("ceditdefault").toString().trim() + "',";
                } else {
                    sql += null + ",";
                }

                if (null != record.get("cobjectname") && !"".equals(record.get("cobjectname").toString().trim())) {
                    sql += "'" + record.get("cobjectname").toString().trim().toUpperCase() + "',";
                } else {
                    sql += null + ",";
                }

                if (null != record.get("iobjecttype") && !"".equals(record.get("iobjecttype").toString().trim())
                        && regularExpression(record.get("iobjecttype").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("iobjecttype").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                sql += "v.iid,";

                if (null != record.get("ichildno") && !"".equals(record.get("ichildno").toString().trim())
                        && regularExpression(record.get("ichildno").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("ichildno").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("iwidth") && !"".equals(record.get("iwidth").toString().trim())
                        && regularExpression(record.get("iwidth").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("iwidth").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("iheight") && !"".equals(record.get("iheight").toString().trim())
                        && regularExpression(record.get("iheight").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("iheight").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("bshow") && !"".equals(record.get("bshow").toString().trim())
                        && ("1".equals(record.get("bshow").toString().trim()) || (Boolean) record.get("bshow"))) {
                    sql += "1,";
                } else {
                    sql += "0,";
                }

                if (null != record.get("idatetype") && !"".equals(record.get("idatetype").toString().trim())
                        && regularExpression(record.get("idatetype").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("idatetype").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("idatadictionary") && !"".equals(record.get("idatadictionary").toString().trim())
                        && regularExpression(record.get("idatadictionary").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("idatadictionary").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("ctable") && !"".equals(record.get("ctable").toString().trim())) {
                    sql += "'" + record.get("ctable").toString().trim() + "',";
                } else {
                    sql += null + ",";
                }

                sql += iid;
                sql += " from AC_vouchform v where cobjectname='";
                sql += record.get("ipgroup").toString().toUpperCase().trim() + "' and ivouch=" + iid + ";";
            }
        }

        HashMap paraMap = new HashMap();
        paraMap.put("sqlValue", sql);
        HashMap<String, Object> resultMap = new HashMap<String, Object>();
        try {
            this.update("DatadictionaryDest.updateDataList", paraMap);
            resultMap.put("message", "新增成功！");
            resultMap.put("iid", iid);
        } catch (Exception ex) {
            ex.printStackTrace();
            resultMap.put("message", "fail");
        } finally {
            paraMap.clear();
            sql = "";
        }
        return paraMap;
    }

    public List getVouch(HashMap paramMap) {
        return this.queryForList("querry_vouch", paramMap);
    }

    public HashMap updateVouch(HashMap paramMap) {
        HashMap<String, Object> resultMap = new HashMap<String, Object>();
        HashMap<String, Object> paraMap = new HashMap<String, Object>();
        String sql = "";


        sql += "update AC_vouch set ccode='" + paramMap.get("ccode") + "',cname='" + paramMap.get("cname")
                + "' where iid='" + paramMap.get("ivouch") + "';";
        sql += "delete from AC_vouchform where ivouch=" + paramMap.get("ivouch") + ";";
        List arrDataList = (List) paramMap.get("arrDataList");
        for (int i = 0; i < arrDataList.size(); i++) {
            HashMap record = (HashMap) arrDataList.get(i);
            if (record.get("iobjecttype").toString().equals("0") && (null == record.get("ipgroup") || "0".equals(record.get("ipgroup").toString()))) {
                sql += "insert into AC_vouchform(bmain,ccaption," +
                        "cobjectname,iobjecttype,igroupno,igrouprow,ipgroup,ichildno," +
                        "bshow,ivouch,iwidth,iheight,idatetype) values(0,";

                if (null != record.get("ccaption") && !"".equals(record.get("ccaption").toString().trim())) {
                    sql += "'" + record.get("ccaption").toString().trim() + "',";
                } else {
                    sql += null + ",";
                }

                if (null != record.get("cobjectname") && !"".equals(record.get("cobjectname").toString().trim())) {
                    sql += "'" + record.get("cobjectname").toString().trim().toUpperCase() + "',";
                } else {
                    sql += null + ",";
                }

                if (null != record.get("iobjecttype") && !"".equals(record.get("iobjecttype").toString().trim())
                        && regularExpression(record.get("iobjecttype").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("iobjecttype").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("igroupno") && !"".equals(record.get("igroupno").toString().trim())
                        && regularExpression(record.get("igroupno").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("igroupno").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("igrouprow") && !"".equals(record.get("igrouprow").toString().trim())
                        && regularExpression(record.get("igrouprow").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("igrouprow").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("ipgroup") && !"".equals(record.get("ipgroup").toString().trim())
                        && regularExpression(record.get("ipgroup").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("ipgroup").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("ichildno") && !"".equals(record.get("ichildno").toString().trim())
                        && regularExpression(record.get("ichildno").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("ichildno").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("bshow") && !"".equals(record.get("bshow").toString().trim())
                        && ("1".equals(record.get("bshow").toString().trim()) || (Boolean) record.get("bshow"))) {
                    sql += "1,";
                } else {
                    sql += "0,";
                }

                sql += paramMap.get("ivouch") + ",";

                if (null != record.get("iwidth") && !"".equals(record.get("iwidth").toString().trim())
                        && regularExpression(record.get("iwidth").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("iwidth").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("iheight") && !"".equals(record.get("iheight").toString().trim())
                        && regularExpression(record.get("iheight").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("iheight").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                sql += "3);";

            }
        }

        for (int i = 0; i < arrDataList.size(); i++) {
            HashMap record = (HashMap) arrDataList.get(i);
            if (record.get("iobjecttype").toString().equals("0") && null != record.get("ipgroup") && !"0".equals(record.get("ipgroup").toString())) {
                sql += "insert into AC_vouchform(bmain,ccaption," +
                        "cobjectname,iobjecttype,igroupno,igrouprow,ipgroup,ichildno," +
                        "bshow,ivouch,iwidth,iheight,idatetype) values(0,";

                if (null != record.get("ccaption") && !"".equals(record.get("ccaption").toString().trim())) {
                    sql += "'" + record.get("ccaption").toString().trim() + "',";
                } else {
                    sql += null + ",";
                }

                if (null != record.get("cobjectname") && !"".equals(record.get("cobjectname").toString().trim())) {
                    sql += "'" + record.get("cobjectname").toString().trim().toUpperCase() + "',";
                } else {
                    sql += null + ",";
                }

                if (null != record.get("iobjecttype") && !"".equals(record.get("iobjecttype").toString().trim())
                        && regularExpression(record.get("iobjecttype").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("iobjecttype").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("igroupno") && !"".equals(record.get("igroupno").toString().trim())
                        && regularExpression(record.get("igroupno").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("igroupno").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("igrouprow") && !"".equals(record.get("igrouprow").toString().trim())
                        && regularExpression(record.get("igrouprow").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("igrouprow").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("ipgroup") && !"".equals(record.get("ipgroup").toString().trim())
                        && regularExpression(record.get("ipgroup").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("ipgroup").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("ichildno") && !"".equals(record.get("ichildno").toString().trim())
                        && regularExpression(record.get("ichildno").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("ichildno").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("bshow") && !"".equals(record.get("bshow").toString().trim())
                        && ("1".equals(record.get("bshow").toString().trim()) || (Boolean) record.get("bshow"))) {
                    sql += "1,";
                } else {
                    sql += "0,";
                }

                sql += paramMap.get("ivouch") + ",";

                if (null != record.get("iwidth") && !"".equals(record.get("iwidth").toString().trim())
                        && regularExpression(record.get("iwidth").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("iwidth").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("iheight") && !"".equals(record.get("iheight").toString().trim())
                        && regularExpression(record.get("iheight").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("iheight").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                sql += "3);";

            }
        }

        for (int i = 0; i < arrDataList.size(); i++) {
            HashMap record = (HashMap) arrDataList.get(i);
            if (null != record.get("iobjecttype") && record.get("iobjecttype").toString().equals("7")) {
                sql += "insert into AC_vouchform(bmain,ccaption,idecimal,bunnull,bread,cnewdefault,cnewdefaultfix" +
                        ",ceditdefault,cobjectname,iobjecttype,ipgroup,ichildno,iwidth," +
                        "iheight,bshow,idatetype,idatadictionary,ctable,ivouch) select ";

                if (null != record.get("bmain") && !"".equals(record.get("bmain").toString().trim())
                        && ("1".equals(record.get("bmain").toString().trim()) || (Boolean) record.get("bmain"))) {
                    sql += "1,";
                } else {
                    sql += "0,";
                }

                if (null != record.get("ccaption") && !"".equals(record.get("ccaption").toString().trim())) {
                    sql += "'" + record.get("ccaption").toString().trim() + "',";
                } else {
                    sql += null + ",";
                }

                if (null != record.get("idecimal") && !"".equals(record.get("idecimal").toString().trim())
                        && regularExpression(record.get("idecimal").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("idecimal").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("bunnull") && !"".equals(record.get("bunnull").toString().trim())
                        && ("1".equals(record.get("bunnull").toString().trim()) || (Boolean) record.get("bunnull"))) {
                    sql += "1,";
                } else {
                    sql += "0,";
                }

                if (null != record.get("bread") && !"".equals(record.get("bread").toString().trim())
                        && ("1".equals(record.get("bread").toString().trim()) || (Boolean) record.get("bread"))) {
                    sql += "1,";
                } else {
                    sql += "0,";
                }

                if (null != record.get("cnewdefault") && !"".equals(record.get("cnewdefault").toString().trim())) {
                    sql += "'" + record.get("cnewdefault").toString().trim() + "',";
                } else {
                    sql += null + ",";
                }

                if (null != record.get("cnewdefaultfix") && !"".equals(record.get("cnewdefaultfix").toString().trim())) {
                    sql += "'" + record.get("cnewdefaultfix").toString().trim() + "',";
                } else {
                    sql += null + ",";
                }

                if (null != record.get("ceditdefault") && !"".equals(record.get("ceditdefault").toString().trim())) {
                    sql += "'" + record.get("ceditdefault").toString().trim() + "',";
                } else {
                    sql += null + ",";
                }

                if (null != record.get("cobjectname") && !"".equals(record.get("cobjectname").toString().trim())) {
                    sql += "'" + record.get("cobjectname").toString().trim().toUpperCase() + "',";
                } else {
                    sql += null + ",";
                }

                if (null != record.get("iobjecttype") && !"".equals(record.get("iobjecttype").toString().trim())
                        && regularExpression(record.get("iobjecttype").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("iobjecttype").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                sql += "case when (select iid from AC_vouchform where ivouch=" +
                        paramMap.get("ivouch") + " and cobjectname='" + record.get("ipgroup") + "') is null" +
                        " then '0' else " + "(select iid from AC_vouchform where ivouch=" +
                        paramMap.get("ivouch") + " and cobjectname='" + record.get("ipgroup").toString().trim().toUpperCase() + "')" +
                        " end,";

                if (null != record.get("ichildno") && !"".equals(record.get("ichildno").toString().trim())
                        && regularExpression(record.get("ichildno").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("ichildno").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("iwidth") && !"".equals(record.get("iwidth").toString().trim())
                        && regularExpression(record.get("iwidth").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("iwidth").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("iheight") && !"".equals(record.get("iheight").toString().trim())
                        && regularExpression(record.get("iheight").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("iheight").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("bshow") && !"".equals(record.get("bshow").toString().trim())
                        && ("1".equals(record.get("bshow").toString().trim()) || (Boolean) record.get("bshow"))) {
                    sql += "1,";
                } else {
                    sql += "0,";
                }

                if (null != record.get("idatetype") && !"".equals(record.get("idatetype").toString().trim())
                        && regularExpression(record.get("idatetype").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("idatetype").toString().trim() + ",";
                } else {
                    sql += "0,";
                }
                if (null != record.get("cfield") && !"".equals(record.get("cfield").toString())) {
                    sql += "d.iid,";
                } else {
                    sql += null + ",";
                }

                if (null != record.get("ctable") && !"".equals(record.get("ctable").toString().trim())) {
                    sql += "'" + record.get("ctable").toString().trim() + "',";
                } else {
                    sql += null + ",";
                }

                if (null != record.get("cfield") && !"".equals(record.get("cfield").toString())) {
                    sql += "v.iid from AC_datadictionary d left join AC_vouch v " +
                            "on d.ifuncregedit= v.ifuncregedit" +
                            " where v.ifuncregedit=" + paramMap.get("ifuncregedit")
                            + " and d.cfield='" + record.get("cfield") + "' and d.ctable='" + record.get("ctable") + "'";
                    ;
                } else {
                    sql += "iid from AC_vouch v where ifuncregedit=" + paramMap.get("ifuncregedit");
                }
            }
        }

        for (int i = 0; i < arrDataList.size(); i++) {
            HashMap record = (HashMap) arrDataList.get(i);
            if (!record.get("iobjecttype").toString().equals("0") && !record.get("iobjecttype").toString().equals("7")) {
                sql += "insert into AC_vouchform(bmain,ccaption,idecimal,bunnull,bread,cnewdefault,cnewdefaultfix" +
                        ",ceditdefault,cobjectname,iobjecttype,ipgroup,ichildno,iwidth," +
                        "iheight,bshow,idatetype,idatadictionary,ctable,ivouch) select ";

                if (null != record.get("bmain") && !"".equals(record.get("bmain").toString().trim())
                        && ("1".equals(record.get("bmain").toString().trim()) || (Boolean) record.get("bmain"))) {
                    sql += "1,";
                } else {
                    sql += "0,";
                }

                if (null != record.get("ccaption") && !"".equals(record.get("ccaption").toString().trim())) {
                    sql += "'" + record.get("ccaption").toString().trim() + "',";
                } else {
                    sql += null + ",";
                }

                if (null != record.get("idecimal") && !"".equals(record.get("idecimal").toString().trim())
                        && regularExpression(record.get("idecimal").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("idecimal").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("bunnull") && !"".equals(record.get("bunnull").toString().trim())
                        && ("1".equals(record.get("bunnull").toString().trim()) || (Boolean) record.get("bunnull"))) {
                    sql += "1,";
                } else {
                    sql += "0,";
                }

                if (null != record.get("bread") && !"".equals(record.get("bread").toString().trim())
                        && ("1".equals(record.get("bread").toString().trim()) || (Boolean) record.get("bread"))) {
                    sql += "1,";
                } else {
                    sql += "0,";
                }

                if (null != record.get("cnewdefault") && !"".equals(record.get("cnewdefault").toString().trim())) {
                    sql += "'" + record.get("cnewdefault").toString().trim() + "',";
                } else {
                    sql += null + ",";
                }

                if (null != record.get("cnewdefaultfix") && !"".equals(record.get("cnewdefaultfix").toString().trim())) {
                    sql += "'" + record.get("cnewdefaultfix").toString().trim() + "',";
                } else {
                    sql += null + ",";
                }

                if (null != record.get("ceditdefault") && !"".equals(record.get("ceditdefault").toString().trim())) {
                    sql += "'" + record.get("ceditdefault").toString().trim() + "',";
                } else {
                    sql += null + ",";
                }

                if (null != record.get("cobjectname") && !"".equals(record.get("cobjectname").toString().trim())) {
                    sql += "'" + record.get("cobjectname").toString().trim().toUpperCase() + "',";
                } else {
                    sql += null + ",";
                }

                if (null != record.get("iobjecttype") && !"".equals(record.get("iobjecttype").toString().trim())
                        && regularExpression(record.get("iobjecttype").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("iobjecttype").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                sql += "case when (select iid from AC_vouchform where ivouch=" +
                        paramMap.get("ivouch") + " and cobjectname='" + record.get("ipgroup") + "') is null" +
                        " then '0' else " + "(select iid from AC_vouchform where ivouch=" +
                        paramMap.get("ivouch") + " and cobjectname='" + record.get("ipgroup").toString().trim().toUpperCase() + "')" +
                        " end,";

                if (null != record.get("ichildno") && !"".equals(record.get("ichildno").toString().trim())
                        && regularExpression(record.get("ichildno").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("ichildno").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("iwidth") && !"".equals(record.get("iwidth").toString().trim())
                        && regularExpression(record.get("iwidth").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("iwidth").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("iheight") && !"".equals(record.get("iheight").toString().trim())
                        && regularExpression(record.get("iheight").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("iheight").toString().trim() + ",";
                } else {
                    sql += "0,";
                }

                if (null != record.get("bshow") && !"".equals(record.get("bshow").toString().trim())
                        && ("1".equals(record.get("bshow").toString().trim()) || (Boolean) record.get("bshow"))) {
                    sql += "1,";
                } else {
                    sql += "0,";
                }

                if (null != record.get("idatetype") && !"".equals(record.get("idatetype").toString().trim())
                        && regularExpression(record.get("idatetype").toString().trim(), "^-?\\d+$")) {
                    sql += record.get("idatetype").toString().trim() + ",";
                } else {
                    sql += "0,";
                }
                if (null != record.get("cfield") && !"".equals(record.get("cfield").toString())) {
                    sql += "d.iid,";
                } else {
                    sql += null + ",";
                }

                if (null != record.get("ctable") && !"".equals(record.get("ctable").toString().trim())) {
                    sql += "'" + record.get("ctable").toString().trim() + "',";
                } else {
                    sql += null + ",";
                }

                if (null != record.get("cfield") && !"".equals(record.get("cfield").toString())) {
                    sql += "v.iid from AC_datadictionary d left join AC_vouch v " +
                            "on d.ifuncregedit= v.ifuncregedit" +
                            " where v.ifuncregedit=" + paramMap.get("ifuncregedit")
                            + " and d.cfield='" + record.get("cfield") + "' and d.ctable='" + record.get("ctable") + "'";
                    ;
                } else {
                    sql += "iid from AC_vouch v where ifuncregedit=" + paramMap.get("ifuncregedit");
                }
            }
        }
        System.out.println(sql);
        paraMap.put("sqlValue", sql);
        try {
            this.update("DatadictionaryDest.updateDataList", paraMap);
            resultMap.put("message", "修改成功！");
        } catch (Exception ex) {
            ex.printStackTrace();
            resultMap.put("message", "修改失败!");
        } finally {
            paraMap.clear();
            sql = "";
        }
        return resultMap;
    }


    public void removeVouch(int ifuncregedit) throws Exception {
        this.delete("remove_vouch", ifuncregedit);
    }

    public List queryNotinData(HashMap paramMap) {
        return this.queryForList("query_notinData", paramMap);
    }

    /**
     * 正则表达式
     *
     * @param str
     * @param regularExpression
     * @return
     */
    private boolean regularExpression(String str, String regularExpressionStr) {
        Pattern pattern = Pattern.compile(regularExpressionStr);
        return pattern.matcher(str).matches();
    }


    public String getDeleteSql(List iids) {

        StringBuffer sqlStr = new StringBuffer();
        StringBuffer iidStr = new StringBuffer();
        if (iids.size() > 0) {
            for (int i = 0; i < iids.size(); i++) {
                if (i == 0) {
                    iidStr.append("(");
                }
                if (i > 0) {
                    iidStr.append(" or ");
                }
                HashMap asRoleUserVo = (HashMap) iids.get(i);
                iidStr.append(" iid=");
                iidStr.append(asRoleUserVo.get("iid"));
            }
            if (iidStr.length() > 0) {
                iidStr.append(")");
            }
            sqlStr.append("delete from AC_vouchform where ");
            sqlStr.append(iidStr.toString());
            sqlStr.append(";");
        }
        return sqlStr.toString();
    }

    public String queryData(int iid) {
        HashMap resultMap = new HashMap();
        List list = this.queryForList("query_dataGrid", iid);
        list.addAll(this.queryForList("query_tableRelationship", iid));
        String treeXml = "";
        //转换为树结构
        if (list.size() > 0) {
            treeXml = ToXMLUtil.createTree(list, "iid", "ipid", "-1");
        }
        return treeXml;
    }

    public String get_funcregeditsqlstr(int iid) {
        return this.queryForObject("get_funcregeditsqlstr", iid).toString();
    }

    public List getBodyConsult(int iid) {
        return this.queryForList("get_bodyConsult", iid);
    }

    @Override
    public Object checkIsTreeDatadic(Object iid) {
        // TODO Auto-generated method stub
        return this.queryForObject("query_checkistreedatadict", iid);
    }

}
