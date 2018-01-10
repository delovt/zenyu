package yssoft.views;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.regex.Pattern;

import yssoft.services.ICommonalityService;
import yssoft.utils.ToXMLUtil;
import yssoft.utils.ToolUtil;
import yssoft.vos.AcConsultsetVo;
import flex.messaging.io.ArrayList;

/**
 * 公共框架所需的视图层
 *
 * @author zhong_jing
 */
public class CommonalityView {

    // 公共框架的接口
    private ICommonalityService iCommonalityService;

    public void setiCommonalityService(ICommonalityService iCommonalityService) {
        this.iCommonalityService = iCommonalityService;
    }


    /**
     * 参照/文本框初始化记录,参照翻译
     *
     * @throws Exception
     */
    @SuppressWarnings({ "rawtypes", "unchecked", "unused" })
	public HashMap consultInit(HashMap paramMap) throws Exception {
        HashMap result = new HashMap();
        int iconsult = Integer.valueOf((paramMap.get("iconsult")+"").trim());

        if (iconsult > 0) {
            // 参照sql
            String consultSql = paramMap.get("consultSql")+"";
            String cconsulttable = paramMap.get("cconsulttable")+"".trim();
            // 获得存入字段类型
            String[] cconsultbkfldfields = (paramMap.get("cconsultbkfld")+"").trim().split(",");
            List typeList = queryTypes(iconsult, cconsultbkfldfields);
            result.put("cconsultbkfldTypeList", typeList);

            // 获得验证字段类型
            String[] cconsultipvffields = (paramMap.get("cconsultipvf")+"").trim().split(",");
            List typeList2 = queryTypes(iconsult, cconsultipvffields);
            result.put("typeList", typeList2);

            String value = null;
            if (null != paramMap.get("value")) {
                value = (paramMap.get("value")+"").trim();
            }

            // 是否执行校验
            boolean bconsultcheck = Boolean.valueOf(paramMap.get("bconsultcheck")+"");


            if ((null != value && !"".equals(value)) || (paramMap.containsKey("objecttype") && ((paramMap.get("objecttype")+"").equals("RadioButtonGroup")
                    || (paramMap.get("objecttype")+"").equals("ComboBox")))) {

                // 是否执行校验
                if (bconsultcheck) {
                    paramMap.put("type", 0);
                    // 参照翻译
                    paramMap.put("typeList", typeList);
                    String sql = getSql(paramMap);
                    sql = sql.replace("@cconsultedit", "");
                    String cordersql = paramMap.get("cordersql") != null ? paramMap.get("cordersql")+"" : "";
                    result.put("consultList", assemblyQuerySql(sql + " " + cordersql));
                }
            }
        }
        //查询参照赋值
        List relationshipList = iCommonalityService.queryRelationship(paramMap);
        if (null != relationshipList && relationshipList.size() > 0) {
            List newRelationshipList = new ArrayList();
            for (int i = 0; i < relationshipList.size(); i++) {
                HashMap newRelationship = new HashMap();
                HashMap relationshipMap = (HashMap) relationshipList.get(i);
                newRelationship.put("relationshipMap", relationshipMap);
                int irelationship = Integer.valueOf(relationshipMap.get("iid")+"");
                List cfieldRelationshipList = this.iCommonalityService.querycfieldRelationship(irelationship);
                newRelationship.put("cfieldRelationshipList", cfieldRelationshipList);
                newRelationshipList.add(newRelationship);
            }

            result.put("newRelationshipList", newRelationshipList);

        }

        //(参照iid)表头触发表体
        int iconsultConfiguration = Integer.valueOf(paramMap.get("iconsultConfiguration")+"");
        List triggerbodyconsult = iCommonalityService.queryTriggerbodyconsult(iconsultConfiguration);
        if (null != triggerbodyconsult && triggerbodyconsult.size() > 0) {
            result.put("triggerbodyconsult", triggerbodyconsult);
        }
        return result;
    }

    // 拼装sql
    @SuppressWarnings("rawtypes")
	private String getSql(HashMap paramMap) {
        // 定义sql
        StringBuffer sql = new StringBuffer();

        try{
        sql.append("select * from (");
        /********************** 第一步 :获得参照sql ***********************************/
        String consultSql = paramMap.get("consultSql")+"";

        if (null == consultSql || "".equals(consultSql)) {
            return "";
        }
        String cconsultconfSql = "";
        if (null != paramMap.get("cconsultconfSql") && !"".equals(paramMap.get("cconsultconfSql")+"")) {
            cconsultconfSql = paramMap.get("cconsultconfSql")+"";
        }

        if (paramMap.get("consultAuthSql") != null) {
            cconsultconfSql = cconsultconfSql + " " + paramMap.get("consultAuthSql");
        }

        // 参照条件sql
        consultSql = consultSql.replace("@childsql", cconsultconfSql);

        consultSql = consultSql.replace("`", "'");

        int type = Integer.valueOf(paramMap.get("type")+"");
        String cconsultcondition = "";
        if (null != paramMap.get("cconsultcondition") && !"".equals(paramMap.get("cconsultcondition")+"")) {
            cconsultcondition = paramMap.get("cconsultcondition")+"";
        }
        switch (type) {
            case 0: {
                //lr modify 必须执行拼条件 如果想要条件在浏览状态下不起作用 需要使用cconsultedit 属性
                //consultSql = consultSql.replace("@condition", "");
                consultSql = consultSql.replace("@condition", cconsultcondition.replace("`", "'"));
                break;
            }
            case 1: {
                consultSql = consultSql.replace("@condition", cconsultcondition.replace("`", "'"));
                break;
            }
        }
        sql.append(consultSql);
        sql.append(") ");
        sql.append(paramMap.get("cconsulttable")+"");
        /********************** 第一步 :获得参照sql ***********************************/

        /********************** 第二步 :获得字段类型 ***********************************/
        List typeList = (List) paramMap.get("typeList");
        /********************** 第二步 :获得字段类型 ***********************************/

        /********************** 第二步 :获得条件sql语句 ***********************************/
        if (paramMap.containsKey("value")) {

            if (null == paramMap.get("value") || (paramMap.get("value")+"").equals("")) {
                sql.append(" where ");
                sql.append(getconditionSql(null, typeList,
                        type));
            } else if (!(getconditionSql(paramMap.get("value")+"", typeList, type)+"").equals("")) {
                sql.append(" where ");
                sql.append(getconditionSql(paramMap.get("value")+"", typeList,
                        type));
            }
        }
        }
        catch(Exception ex){
        	System.out.println(ex.getMessage());
        }
        /********************** 第二步 :获得条件sql语句 ***********************************/

        return sql+"";
    }

    // 条件sql
    @SuppressWarnings("rawtypes")
	private String getconditionSql(String value, List typeList, int itype) {
        StringBuffer sql = new StringBuffer();
        HashMap typeMap = new HashMap();        
        int count = 0;
        String type = "";
        String cfield = "";
        
        if(typeList == null || typeList.size() ==0) return "";
        
        for (int i = 0; i < typeList.size(); i++) {
            if (count > 0) sql.append(" or ");
            
            typeMap = (HashMap) typeList.get(i);
            type = typeMap.get("type")+"";
            cfield = typeMap.get("cfield")+"";
            
            switch (itype) {
                case 0: {
                    sql.append(cfield);
                    if (type.equals("float") || type.equals("int")) {
                        sql.append("="+value);
                    } else {
                        sql.append("='"+value+"'");
                    }
                    break;
                }
                case 1: {
                    if (type.equals("int")) {
                        if (!regularExpression(value, "^[-\\+]?[\\d]*$")) {
                            continue;
                        }
                    } else if (type.equals("float")) {
                        if (!regularExpression(value, "^[-\\+]?[.\\d]*$")) {
                            continue;
                        }
                    }
                    sql.append(cfield+" like '%"+value+"%'");
                    count++;
                    break;
                }
            }
        }
        
        return sql+"";
    }

    /**
     * 正则表达式
     *
     * @param str
     * @return
     */
    private boolean regularExpression(String str, String regularExpressionStr) {
        Pattern pattern = Pattern.compile(regularExpressionStr);
        return pattern.matcher(str).matches();
    }

    // 获得参照sql
    @SuppressWarnings("unused")
	private String getConsultSql(AcConsultsetVo acConsultsetVo) {
        StringBuffer sql = new StringBuffer();
        // 根据参照类型，判断该执行那条语句
        if (acConsultsetVo.itype.equals("0")) {
            sql.append(acConsultsetVo.ctreesql.trim());
        } else if (acConsultsetVo.itype.equals("1")) {
            sql.append(acConsultsetVo.cgridsql.trim());
        } else if (acConsultsetVo.itype.equals("2")) {
            sql.append(acConsultsetVo.cgridsql.replace("@join", "").trim());
        }
        return sql+"";
    }

    // 获得字段类型
    @SuppressWarnings({ "rawtypes", "unchecked" })
	private List queryTypes(int iconsult, String[] cfields) {
    	
        if(cfields.length == 0) return null;
        
        StringBuffer cfieldSql = new StringBuffer();
        HashMap paramMap = new HashMap();
        
        for (int i = 0; i < cfields.length; i++) {
            if (i > 0) {
                cfieldSql.append(",");
            }
            cfieldSql.append("'"+cfields[i]+"'");
        }

        // 表名
        paramMap.put("iconsult", iconsult);
        // 参照字段集合
        paramMap.put("cfieldSql", cfieldSql);
        // 查询字段类型。
        return this.iCommonalityService.getItype(paramMap);
    }

    /**
     * 动态拼装查询语句 创建者：zhong_jing 创建时间：2011-8-16 下午05:26:43 修改者： 修改时间： 修改备注：
     *
     * @param sql SQL语句
     * @return 查询值
     * @throws Exception List<HashMap>
     * @Exception 异常对象
     */
    @SuppressWarnings({ "rawtypes"})
	public List assemblyQuerySql(String sql){
    	List list = null;
    	try{
    		
	        if (sql.trim().equals("")) return null;
	
	        while (sql.indexOf("#nowDate#") > -1) {
	            sql = sql.replaceAll("#nowDate#", ToolUtil.formatDay(new Date(), null));
	        }
	        	list = this.iCommonalityService.assemblyQuerySql(sql);
        }
    	catch(Exception ex){
    		System.out.println(ex.getMessage());
    	}
        return list;
    }

    /**
     * 作者：XZQWJ
     * 时间：2013-01-30
     * 功能：批量执行SQL
     *
     * @param paramMap
     * @throws Exception
     */
    @SuppressWarnings("rawtypes")
	public Object executeSqlList(HashMap paramMap) throws Exception {
        return this.iCommonalityService.executeSqlList(paramMap);
    }

    /**
     * 参照翻译
     *
     * @param paramMap
     * @return
     * @throws Exception
     */
    @SuppressWarnings({ "rawtypes", "unchecked" })
	public HashMap queryconsult(HashMap paramMap) throws Exception {
        HashMap resultMap = new HashMap();
        try{
        // 参照翻译
        resultMap.put("consultList", assemblyQuerySql(getSql(paramMap)));

        List typeList = (List) paramMap.get("typeList");
        int type = Integer.valueOf(paramMap.get("type")+"");
        if (paramMap.containsKey("value")) {
            resultMap.put("conditionSql", getconditionSql(paramMap.get("value")+"", typeList,
                    type));
        }
        }catch(Exception ex){
        	System.out.println(ex.getMessage());
        }
        return resultMap;
    }

    /**
     * 表头触发表体参照信息
     *
     * @param paramMap 条件
     * @return
     * @throws Exception
     */
    @SuppressWarnings("rawtypes")
	public List queryconsultToBody(HashMap paramMap) throws Exception {
        return assemblyQuerySql(paramMap
                .get("consultSql2")+""
                .replace("@childsql",
                        paramMap.get("cconsultconfSql2")+"".trim())
                .replace("@condition",
                        paramMap.get("cconsultcondition2")+"".trim().replace("`", "'")));
    }

    /**
     * 查询单据信息
     *
     * @param param 注册码信息
     * @return 单据信息
     * @throws Exception
     */
    @SuppressWarnings("rawtypes")
	public HashMap queryVouch(HashMap param) throws Exception {
        return this.iCommonalityService.queryVouch(param);
    }


    @SuppressWarnings({ "rawtypes", "unchecked" })
	public HashMap calculateFunction(HashMap paramMap) throws Exception {
        HashMap result = new HashMap();
        List cfunctionSqlArr = (List) paramMap.get("cfunctionSqlArr");
        
        if(null == cfunctionSqlArr || cfunctionSqlArr.size() == 0) return null;
        
        HashMap cfunctionSqlArrMap = new HashMap();
        List valueList = null;
        
        for (int i = 0; i < cfunctionSqlArr.size(); i++) {
            cfunctionSqlArrMap = (HashMap) cfunctionSqlArr.get(i);
            valueList = assemblyQuerySql(cfunctionSqlArrMap.get("sql")+"");
            result.put("resultTable", cfunctionSqlArrMap.get("table")+"");
            result.put("functionvalue", valueList.get(0));
        }
        
        return result;
    }

    // 判断唯一性约束
    @SuppressWarnings("rawtypes")
	public String isUnique(HashMap param) throws Exception {
        return this.iCommonalityService.isUnique(param);
    }

    //保存录入信息
    @SuppressWarnings("rawtypes")
	public String addPm(HashMap param) throws Exception, RuntimeException {
        return this.iCommonalityService.addPm(param);
    }

    //修改录入信息
    @SuppressWarnings("rawtypes")
	public String updatePm(HashMap param) throws Exception, RuntimeException {
        return this.iCommonalityService.updatePm(param);
    }

    //删除信息
    public String deletePm(HashMap paramObj) throws Exception, RuntimeException {
        return this.iCommonalityService.deletePm(paramObj);
    }

    //查询记录
    public HashMap queryPm(HashMap paramObj) throws Exception {
        return this.iCommonalityService.queryPm(paramObj);
    }

    public List queryChild(HashMap param) {
        return this.iCommonalityService.queryChild(param);
    }

    public HashMap queryFun(HashMap paramMap) {
        return this.iCommonalityService.queryFun(paramMap);
    }

    public List automaticallyGenerated(int ifuncregedit) {
        return this.iCommonalityService.automaticallyGenerated(ifuncregedit);
    }

    @SuppressWarnings("rawtypes")
	public String queryFunTree() {
        List funLi1st = this.iCommonalityService.queryFunTree();
        
        if(funLi1st == null || funLi1st.size() == 0) return null;
        
        return ToXMLUtil.createTree(funLi1st, "iid", "ipid", "-1");
        
    }

    //计算公式
    public HashMap formula(HashMap funMap) {
        return this.iCommonalityService.formula(funMap);
    }

    //查询参照赋值公式
    @SuppressWarnings({ "rawtypes", "unchecked" })
	public HashMap queryRelationshipByifuncregedit2(HashMap param) {
        HashMap result = new HashMap();
        //查询参照赋值
        HashMap relationshipMap = iCommonalityService.queryRelationshipByifuncregedit2(param);
        if (null != relationshipMap) {
            int irelationship = Integer.valueOf(relationshipMap.get("iid")+"");
            List cfieldRelationshipList = this.iCommonalityService.querycfieldRelationship(irelationship);
            result.put("relationshipMap", relationshipMap);
            result.put("cfieldRelationshipList", cfieldRelationshipList);
        }
        //(参照iid)表头触发表体
        int iconsultConfiguration = Integer.valueOf(param.get("iconsultConfiguration")+"");
        List triggerbodyconsult = iCommonalityService.queryTriggerbodyconsult(iconsultConfiguration);
        if (null != triggerbodyconsult && triggerbodyconsult.size() > 0) {
            result.put("triggerbodyconsult", triggerbodyconsult);
        }
        return result;
    }

    public List queryStatement(String sql) {
        return this.iCommonalityService.queryStatement(sql);
    }

    @SuppressWarnings({ "unchecked", "rawtypes" })
	public HashMap getTepeList(HashMap paramMap) {
        // 获得存入字段类型
        String[] cconsultipvffields = (paramMap.get("cconsultipvf")+"").trim().split(",");
        HashMap resultMap = new HashMap();
        // 获得验证字段类型
        resultMap.put("typeList", queryTypes(Integer.valueOf(paramMap.get("iconsult")+""), cconsultipvffields));

        // 获得存入字段类型
        String[] cconsultbkfldfields = (paramMap.get("cconsultbkfld")+"").trim().split(",");
        List typeList = queryTypes(Integer.valueOf(paramMap.get("iconsult")+""), cconsultbkfldfields);
        // 获得验证字段类型
        resultMap.put("cconsultbkfldTypeList", typeList);
        return resultMap;

    }


    public String queryKnowledge() {
        if (this.iCommonalityService.queryKnowledge().size() > 0) {
            return ToXMLUtil.createTree(this.iCommonalityService.queryKnowledge(), "cVer", "ipid", "-1");
        }
        return null;
    }

    @SuppressWarnings("rawtypes")
	public String queryKnowledgeByCModer(HashMap param) {
        if ((param.get("ipid")+"").equals("-1")) {
        	List resultList  = this.iCommonalityService.queryKnowledgeByCModer(param);
            if (resultList.size() > 0) {
                String resultStr = ToXMLUtil.createTree(resultList, "cModule", "ipid", param.get("cVer")+"");
                return resultStr.substring(resultStr.indexOf("<root>") + 6, resultStr.indexOf("</root>"));
            } else {
                return null;
            }
        }
        return null;
    }

    public String updateSql(String sql) {
        try {
            this.iCommonalityService.updateSql(sql);
            return "sucess";
        } catch (Exception e) {
            e.printStackTrace();
            return "fail";
        }
    }

    public void addinvoiceuser(HashMap param)
    {
        this.iCommonalityService.addinvoiceuser(param);
    }

    public int addSql(HashMap param)
    {
        return this.iCommonalityService.addSql(param);
    }


    public HashMap getStatus(HashMap param) throws Exception {
        return this.iCommonalityService.getStatus(param);
    }
    public Boolean updateStatus(HashMap param) throws Exception {
        return this.iCommonalityService.updateStatus(param);
    }

    public Boolean updateListStatus(List<HashMap> list) throws Exception {
        return this.iCommonalityService.updateListStatus(list);
    }

}
