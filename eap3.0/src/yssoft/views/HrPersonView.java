package yssoft.views;

import java.io.Serializable;
import java.io.UnsupportedEncodingException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import yssoft.impls.ChildrenDataHandle;
import yssoft.services.IAcListsetService;
import yssoft.services.IAs_OptionsService;
import yssoft.services.IDatadictionaryService;
import yssoft.services.IHrPersonService;
import yssoft.services.Iab_invoiceuserService;
import yssoft.utils.CrmMd5Util;
import yssoft.utils.DesEncryptUtil;
import yssoft.utils.LogOperateUtil;
import yssoft.utils.SystemParamter;
import yssoft.utils.ToXMLUtil;

/**
 * Created with IntelliJ IDEA.
 * User: Aruis
 * Date: 12-12-12
 * Time: 上午11:21
 * To change this template use File | Settings | File Templates.
 */
public class HrPersonView {
    private IHrPersonService iHrPersonService = null;

    private IAcListsetService iAcListsetService = null;

    private IDatadictionaryService iDatadictonaryService = null;

    private Iab_invoiceuserService i_ab_invoiceuserService;

    private IAs_OptionsService optionsService = null;

    public void seti_ab_invoiceuserService(
            Iab_invoiceuserService i_ab_invoiceuserService) {
        this.i_ab_invoiceuserService = i_ab_invoiceuserService;
    }

    public void setiDatadictonaryService(
            IDatadictionaryService iDatadictonaryService) {
        this.iDatadictonaryService = iDatadictonaryService;
    }

    public void setiAcListsetService(IAcListsetService iAcListsetService) {
        this.iAcListsetService = iAcListsetService;
    }

    public void setiHrPersonService(IHrPersonService iHrPersonService) {
        this.iHrPersonService = iHrPersonService;
    }

    public void setOptionsService(IAs_OptionsService optionsService) {
        this.optionsService = optionsService;
    }




    /**
     *
     * addPerson(新增人员) 创建者：zhong_jing 创建时间：2011-8-22 上午10:21:10 修改者： 修改时间： 修改备注：
     *
     * @param hrPersonVo
     *            新增类
     * @return Object 是否增加成功
     *
     */
    public String addPerson(HashMap<String, String> hrPersonVo) {
        // 默认声明结果集为成功
        String result = "sucess";
        try {
            // 插入角色

            String md5_pwd = CrmMd5Util.getEncryptedPwd( this.getInitPwd() ); // 加密（默认值）
            hrPersonVo.put("cusepassword", md5_pwd);

            Object resultObj = this.iHrPersonService.addPerson(hrPersonVo);
            result = resultObj.toString();
        } catch (Exception e) {
            e.printStackTrace();
            result = "fail";
        }
        return result;
    }

    /**
     *
     * updatePerson(修改人员) 创建者：zhong_jing 创建时间：2011-8-22 上午10:22:17 修改者： 修改时间：
     * 修改备注：
     *
     * @param hrPersonVo
     *            人员信息
     * @return int 是否新增成功
     * @Exception 异常对象
     *
     */
    public String updatePerson(HashMap hrPersonVo) {
        // 默认声明结果集为成功
        String result = "sucess";
        try {
            //添加验证，账号是不是唯一
            int ret = this.iHrPersonService.check_zh_isonly(hrPersonVo);
            if(ret >=1 ){
                System.out.println("该账号已经被占用了，不予更新");
                return "checkzhisnotonly";
            }
            result = this.iHrPersonService.updatePerson(hrPersonVo);
        } catch (Exception e) {
            e.printStackTrace();
            // 如抛异常，则修改失败
            result = "fail";
        }
        return result;
    }

    /**
     *
     * updatePersonPwd(修改用户密码) 创建者：SunDongYa 创建时间：2011-9-5 上午10:35:16
     * 修改者：Administrator 修改时间：2011-9-5 上午10:35:16 修改备注：
     *
     * @param hrPersonVo
     * @return String
     * @throws UnsupportedEncodingException
     * @throws NoSuchAlgorithmException
     * @Exception 异常对象
     *
     */
    @SuppressWarnings("unchecked")
    public String updatePersonPwd(HashMap<String, String> params) throws NoSuchAlgorithmException, UnsupportedEncodingException {
        String old_pwd = params.get("oldpwd") + "";
        String db_pwd = params.get("dbpwd") + "";
        String result = "11";
//
//		try {
//			result = this.iHrPersonService.updatePersonPwd(params);
//			if("fail".equals(result)){
//				result="repeat";
//			}
//		} catch (Exception e) {
//			e.printStackTrace();
//			result = "fail";
//		}

//		return result;

        if (CrmMd5Util.validPassword(old_pwd, db_pwd)) {
            try {
                String md5_pwd = CrmMd5Util.getEncryptedPwd(params.get("pwd")
                        .toString()); // 加密
                params.put("pwd", md5_pwd);
                result = this.iHrPersonService.updatePersonPwd(params);
            } catch (Exception e) {
                e.printStackTrace();
                result = "fail";
            }
        } else {
            return "repeat";
        }
        return result;
    }

    /**
     * 重置用户密码并修改 (孙东亚)
     *
     * @return
     * @throws Exception
     */
    public String modityResetPwd(HashMap<String, String> params) throws Exception {
        String result = "success";
        try {
            String md5_pwd = "";

            //加密方式已经改变
/*			if(params.containsKey("resetFlag")){

				md5_pwd = CrmMd5Util.getEncryptedPwd(this.getInitPwd()); // 重置加密
			}else{
				md5_pwd = CrmMd5Util.getEncryptedPwd(params.get("pwd")); // 修改加密
			}*/

            if(params.containsKey("resetFlag")){

                md5_pwd = CrmMd5Util.getEncryptedPwd(this.getInitPwd());//重置加密

            }else{
                md5_pwd = params.get("pwd"); // 修改加密
            }

            params.put("pwd", md5_pwd);

            this.iHrPersonService.updatePersonPwd(params);
        } catch (Exception e) {
            result = "fail";
            e.printStackTrace();
        }

        return result;
    }
    
    
    /**
     * 插入clogin
     *
     * @return
     * @throws Exception
     */
    public HashMap insertClogin(HashMap<String, String> params) throws Exception {
    	HashMap returnParam = new HashMap();
        String clogin = params.get("clogin") + "";
        try {
        	//插入clogin加密
        	String key = "12345678";
    		String data =clogin;
    		String enc_data = DesEncryptUtil.encodeDes(data, key);
    		//String dec_data = DesEncryptUtil.decodeDes(enc_data, key);
           
           
            returnParam.put("pwd", enc_data);

        } catch (Exception e) {
            
            e.printStackTrace();
        }
        return returnParam;
        
    }
    
    
    /**
     * 查询可登录手机的人数
     *
     * @return
     * @throws Exception
     */
    public int selectClogin(HashMap params) throws Exception {
    	int perNum=0;
    	List ac = (ArrayList)params.get("ac");
        try {
        	//计算登录手机的人数
        	for(int i = 0; i < ac.size(); i++){
        		HashMap hm1 = new HashMap();
    			HashMap hall = (HashMap) ac.get(i);
    			String clogin=hall.get("clogin")+"";
    			String key = "12345678";
    			String dec_data = DesEncryptUtil.decodeDes(clogin, key);
    			if(Integer.parseInt(dec_data.substring(dec_data.length()-1))==1){
    				perNum=perNum+1;
    			};
        	}

        } catch (Exception e) {
            e.printStackTrace();
            return 0;
        }
        return perNum;
        
    }

    /**
     *
     * deletePerson(删除该人员) 创建者：zhong_jing 创建时间：2011-8-22 上午10:23:49 修改者： 修改时间：
     * 修改备注：
     *
     * @param iid
     *            人员编号
     * @return int
     * @Exception 异常对象
     *
     */
    public String removePerson(String sql) {
        // 默认声明结果集为成功
        String result = "sucess";
        try {
            // if(paramObj.get("iidStr")!=null)
            // {
            // List selectIds = (List)paramObj.get("iidStr");
            // StringBuffer str = new StringBuffer();
            // str.append(" iid in(");
            // for (int i = 0; i < selectIds.size(); i++) {
            // HashMap po = (HashMap)selectIds.get(i);
            // if(i>0)
            // {
            // str.append(",");
            // }
            // str.append("'"+po.get("iid").toString()+"'");
            // }
            // str.append(")");
            // paramObj.put("iidStr", str.toString());
            // }
            this.iHrPersonService.removePerson(sql);
        } catch (Exception e) {
            e.printStackTrace();
            // 如抛异常，则删除失败
            result = "fail";
        }
        return result;
    }

    /**
     *
     * getAcListers(更新列) 创建者：zhong_jing 创建时间：2011-8-16 下午05:07:30 修改者： 修改时间：
     * 修改备注：
     *
     * @param sql
     *            sql语句
     * @return List<AcListclmVo>
     *
     */
    public List<HashMap<String, Object>> verificationSql(String sql) {

        List<HashMap<String, Object>> test = null;
        try {
            test = this.iAcListsetService.verificationSql(sql);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return test;
    }

    /**
     *
     * getPersonVos(查询人员) 创建者：zhong_jing 创建时间：2011-9-2 上午10:11:28 修改者： 修改时间：
     * 修改备注：
     *
     * @param persons
     *            列表传过来的人员编号
     * @return List<HrPersonVo> 结果集
     *
     */
    @SuppressWarnings("unchecked")
    public HashMap<String, Object> getPersonVos(HashMap paramObj) throws Exception,RuntimeException{
        // HashMap<String,String> paramObj = new HashMap<String,String> ();
        //
        // paramObj.put("columns", getColumn());
        // paramObj.put("iid", sql);
        // int count=0;

        // StringBuffer newTj = new StringBuffer();
        // for (HashMap hashMap : persons) {
        // if(count>0)
        // {
        // newTj.append(",");
        // }
        // newTj.append("'"+hashMap.get("iid").toString()+"'");
        // count++;
        // }
        // if(newTj.length()>0)
        // {
        // StringBuffer tjstr = new StringBuffer();
        // tjstr.append("iid in (");
        // tjstr.append(newTj.toString());
        // tjstr.append(")");
        // paramObj.put("iid", tjstr.toString());
        StringBuffer sqlBuffer = new StringBuffer();
        sqlBuffer.append("select ");
        sqlBuffer.append(getColumn(paramObj.get("ctable").toString()));
        sqlBuffer.append(" from ");
        sqlBuffer.append(paramObj.get("ctable").toString());
        sqlBuffer.append(" where ");
        if (paramObj.containsKey("sql")) {
            sqlBuffer.append(paramObj.get("sql").toString());
        } else {
            sqlBuffer.append("iid=" + paramObj.get("iid").toString());
        }

        /**
         * 添加系统操作日志
         */
        HashMap<String, Serializable> map = new HashMap<String, Serializable>();
        map.put("operate", "select");
        map.put("result", "success");
        map.put("params", paramObj);
        LogOperateUtil.insertLog(map);

        return this.iHrPersonService.getPersons(sqlBuffer.toString());

        // }
    }

    /**
     *
     * getColumn(查询列名) 创建者：zhong_jing 创建时间：2011-9-2 下午04:34:40 修改者： 修改时间： 修改备注：
     *
     * @return String
     * @Exception 异常对象
     *
     */
    private String getColumn(String tableName) {
        HashMap<String, String> param = new HashMap<String, String>();
        param.put("tablename", tableName);
        param.put("iid", "0");
        List<HashMap> datadictonary = this.iDatadictonaryService
                .getDataList(param);
        StringBuffer colmnsStr = new StringBuffer();
        int count = 0;
        for (HashMap hashMap : datadictonary) {
            if (count > 0) {
                colmnsStr.append(",");
            }
            colmnsStr.append(hashMap.get("cfield").toString());
            count++;
        }
        return colmnsStr.toString();
    }

    /**
     *
     * get_personplancount(统计人员计划个数) 创建者：刘磊 创建时间：2011-9-10 上午14:58:10 修改者： 修改时间：
     * 修改备注：
     *
     * @param having
     *            查询条件
     * @return List<HashMap>
     *
     */
    public List<HashMap> get_personplancount(String condition) {
        try {
            return this.iHrPersonService.get_personplancount(condition);

        } catch (Exception e) {
            return null;
        }
    }

    public List<HashMap> get_personplannotin(HashMap<String, String> condition) {
        try {
            return this.iHrPersonService.get_personplannotin(condition);

        } catch (Exception e) {
            return null;
        }
    }

    /**
     *
     * get_personlogcount(统计人员日志个数) 创建者：刘磊 创建时间：2011-9-10 上午14:58:10 修改者： 修改时间：
     * 修改备注：
     *
     * @param having
     *            查询条件
     * @return List<HashMap>
     *
     */
    public List<HashMap> get_personlogcount(String condition) {
        try {
            return this.iHrPersonService.get_personlogcount(condition);

        } catch (Exception e) {
            return null;
        }
    }

    public List<HashMap> get_personlognotin(HashMap<String, String> condition) {
        try {
            return this.iHrPersonService.get_personlognotin(condition);

        } catch (Exception e) {
            return null;
        }
    }

    /**
     *
     * addPm(新增) 创建者：zhong_jing 创建时间：2011-10-13 下午02:11:01 修改者：Lenovo
     * 修改时间：2011-10-13 下午02:11:01 修改备注：
     *
     * @param sql
     * @return
     * @throws Exception
     * @throws UnsupportedEncodingException
     * @throws NoSuchAlgorithmException
     * @throws Exception
     *             Object
     * @Exception 异常对象
     *
     */
    @SuppressWarnings("unchecked")
    public HashMap addPm(HashMap paramObj) throws Exception{

        HashMap resultMap = new HashMap();
        String result = "";

        //判断唯一性
        HashMap<String, String> paramStr = new HashMap<String, String>();

        //		if (paramObj.containsKey("operId"))// 如果从列表进入则取相关功能注册内码 刘磊 20111116
        //		{
        paramStr.put("ifuncregedit", paramObj.get("ifuncregedit")
                .toString());
        //		} else {
        //			paramStr.put("ifuncregedit", paramObj.get("ifuncregedit")
        //					.toString());
        //		}

        try {
            List datadictonaryList =iDatadictonaryService.getCrmRefer(paramStr);
            StringBuffer ts=new StringBuffer();
            for(int i=0;i<datadictonaryList.size();i++)
            {
                HashMap map = (HashMap) datadictonaryList.get(i);
                if(map.containsKey("bunique")&&Boolean.valueOf(map.get("bunique").toString())==true)
                {
                    StringBuffer sql=new StringBuffer();
                    sql.append("select * from "+paramObj.get("ctable")+" where " );
                    sql.append(map.get("cfield").toString());
                    sql.append("='");
                    sql.append(paramObj.get(map.get("cfield").toString()));
                    sql.append("'");

                    List<HashMap<String, Object>> test = this.iAcListsetService.verificationSql(sql.toString());
                    if(test.size()>0)
                    {
                        ts.append(map.get("ccaption").toString());
                        ts.append("已存在，请重新输入！！");
                        resultMap.put("value", ts.toString());
                        return resultMap;
                    }
                }
            }

            if(ts.length()==0)
            {
                List<String> keys = getHashMapKeys(paramObj);

                StringBuffer sqlBuffer = new StringBuffer();
                sqlBuffer.append("insert into ");
                sqlBuffer.append(paramObj.get("ctable").toString());
                sqlBuffer.append("(");
                int count = 0;
                StringBuffer paramObjStr = new StringBuffer();
                for (int i = 0; i < keys.size(); i++) {
                    String key = keys.get(i);
                    if (!key.equals("arr_dg") && !key.equals("ctable")
                            && !key.equals("iid")
                            && !key.equals("ifuncregedit")
                            && !key.equals("operId")
                            && !key.equals("userId")) {
                        if (count > 0) {
                            sqlBuffer.append(",");
                            paramObjStr.append(",");
                        }
                        sqlBuffer.append(key);

                        if(paramObj.get(key)==null)
                        {
                            paramObjStr.append(paramObj.get(key));
                        }
                        else if (paramObj.get(key).toString().equals("服务器当前时间")) {
                            paramObjStr.append("getdate()");
                        } else if (paramObj.get(key).toString().equals("服务器当前日期")) {
                            paramObjStr.append("CONVERT(varchar(10), getdate(), 120)");
                        } else {
                            paramObjStr.append("'");
                            paramObjStr.append(paramObj.get(key));
                            paramObjStr.append("'");
                        }

                        count++;
                    }

                }

                sqlBuffer.append(")values(");
                sqlBuffer.append(paramObjStr);
                sqlBuffer.append(")");

                // SDY add 判断如果为新增用户加密 start
                String insertSql = "insert into hr_person(";
                if (null != sqlBuffer && sqlBuffer.toString().toLowerCase().indexOf(insertSql) != -1) {
                    String sql = sqlBuffer.toString();
                    sqlBuffer = new StringBuffer();
                    String[] arrStr_0 = sql.split("values");
                    String str_0 = arrStr_0[0];
                    str_0 = str_0.substring(0, str_0.length() - 1);
                    str_0 = str_0 + ",cusepassword) values ";

                    sqlBuffer.append(str_0);

                    String str_1 = arrStr_0[1];
                    str_1 = str_1.substring(0, str_1.length() - 1);

                    // 分解到最后值添加上
                    String md5_pwd = CrmMd5Util.getEncryptedPwd( this.getInitPwd() ); // 加密（默认值）
                    sqlBuffer.append(str_1 + ",'" + md5_pwd + "')");
                }

                // end

                HashMap<String, String> param = new HashMap<String, String>();
                param.put("sql", sqlBuffer.toString());
                Object obj = this.iHrPersonService.addPm(param);
                // 插入主子表
                if (paramObj.containsKey("arr_dg")) {
                    if (obj != null) {
                        new ChildrenDataHandle().ChildData(paramObj, Integer
                                .valueOf(obj.toString()));
                    }
                }
                // 插入
                paramStr.put("iinvoice", obj.toString());
                i_ab_invoiceuserService.add_ab_invoiceuser(paramStr);

                result = obj.toString();

                StringBuffer sqlstr=new StringBuffer();
                sqlstr.append("select * from "+paramObj.get("ctable")+" where iid=" );
                sqlstr.append(result);
                List<HashMap<String, Object>> test = this.iAcListsetService.verificationSql(sqlstr.toString());
                if(test.size()>0)
                {
                    resultMap.put("value", test.get(0));
                }

                /**
                 * 添加系统操作日志
                 */
                HashMap<String, Serializable> map = new HashMap<String, Serializable>();
                map.put("operate", "add");
                map.put("result", result);
                map.put("params", paramObj);
                LogOperateUtil.insertLog(map);
            }
            else
            {
                resultMap.put("value", ts.toString());
            }
        }
        catch (RuntimeException e) {
            e.printStackTrace();
            resultMap.put("value", "fail");
        }
        return resultMap;


    }

    /**
     *
     * updatePm(修改) 创建者：zhong_jing 创建时间：2011-10-13 下午02:47:19 修改者：Lenovo
     * 修改时间：2011-10-13 下午02:47:19 修改备注：
     *
     * @param paramObj
     * @return String
     * @Exception 异常对象
     *
     */
    @SuppressWarnings("unchecked")
    public String updatePm(HashMap paramObj)throws Exception  {
        String result = "";
        try {
            //判断唯一性
            HashMap<String, String> paramStr = new HashMap<String, String>();

            if (paramObj.containsKey("operId"))// 如果从列表进入则取相关功能注册内码 刘磊 20111116
            {
                paramStr.put("ifuncregedit", paramObj.get("outifuncregedit")
                        .toString());
            } else {
                paramStr.put("ifuncregedit", paramObj.get("ifuncregedit")
                        .toString());
            }
            List datadictonaryList =iDatadictonaryService.getCrmRefer(paramStr);
            StringBuffer ts=new StringBuffer();
            for(int i=0;i<datadictonaryList.size();i++)
            {
                HashMap map = (HashMap) datadictonaryList.get(i);
                if(map.containsKey("bunique")&&Boolean.valueOf(map.get("bunique").toString())==true)
                {
                    StringBuffer sql=new StringBuffer();
                    sql.append("select * from "+paramObj.get("ctable")+" where 1=1 and iid not in ('" );
                    sql.append(paramObj.get("iid").toString());
                    sql.append("') and ");
                    sql.append(map.get("cfield").toString());
                    sql.append("='");
                    sql.append(paramObj.get(map.get("cfield").toString()));
                    sql.append("'");

                    List<HashMap<String, Object>> test = this.iAcListsetService.verificationSql(sql.toString());
                    if(test.size()>0)
                    {
                        ts.append(map.get("ccaption").toString());
                        ts.append("已存在，请重新输入！！");
                        result = ts.toString();
                        return result;
                    }
                }
            }

            if(ts.length()==0)
            {
                List<String> keys = getHashMapKeys(paramObj);

                StringBuffer sqlBuffer = new StringBuffer();

                sqlBuffer.append("update ");
                sqlBuffer.append(paramObj.get("ctable").toString());
                sqlBuffer.append(" set ");

                int count = 0;
                for (int i = 0; i < keys.size(); i++) {
                    String key = keys.get(i);

                    if (!key.equals("iid") && !key.equals("arr_dg")
                            && !key.equals("ctable") && !key.equals("ifuncregedit")
                            && !key.equals("userId")) {
                        if (count > 0) {
                            sqlBuffer.append(",");
                        }
                        sqlBuffer.append(key + "=");
                        if(paramObj.get(key)==null)
                        {
                            sqlBuffer.append(paramObj.get(key));
                        }
                        else if (paramObj.get(key).toString().equals("服务器当前时间")) {
                            sqlBuffer.append("getdate()");
                        } else if (paramObj.get(key).toString().equals("服务器当前日期")) {
                            sqlBuffer.append("CONVERT(varchar(10), getdate(), 120)");
                        } else {
                            sqlBuffer.append("'" + paramObj.get(key) + "'");
                        }

                        count++;
                    }
                }

                sqlBuffer.append(" where iid=");
                sqlBuffer.append(paramObj.get("iid").toString());


                int size = this.iHrPersonService.updatePm(sqlBuffer.toString());
                if (size == 1) {
                    if (paramObj.containsKey("arr_dg")) {
                        new ChildrenDataHandle().ChildData(paramObj, Integer
                                .valueOf(paramObj.get("iid").toString()));
                    }
                    result = "success";
                } else {
                    result = "fail";
                }


                /**
                 * 添加系统操作日志
                 */
                HashMap<String, Serializable> map = new HashMap<String, Serializable>();
                map.put("operate", "update");
                map.put("result", result);
                map.put("iinvoice", "");
                map.put("params", paramObj);
                LogOperateUtil.insertLog(map);
            }
            else
            {
                result = ts.toString();
            }
        } catch (RuntimeException e) {
            e.printStackTrace();
            result = "fail";
        }
        return result;
    }


    public void updatecsubject(HashMap paramObj) throws Exception
    {
        StringBuffer sql = new StringBuffer();
        sql.append("update oa_invoice set csubject=SUBSTRING(csubject,0,case when  CHARINDEX('_',csubject)=0 then len(csubject)+1 else CHARINDEX('_',csubject) end)+'");
        sql.append(paramObj.get("csubject").toString());
        sql.append("' where ifuncregedit=");
        sql.append(paramObj.get("ifuncregedit").toString());
        sql.append(" and iinvoice=");
        sql.append(paramObj.get("iinvoice").toString());
        try {
            this.iHrPersonService.updatePm(sql.toString());
        } catch (RuntimeException e) {
            e.printStackTrace();
        }
    }

    /**
     *
     * removePm(删除表单) 创建者：zhong_jing 创建时间：2011-10-13 下午02:52:45 修改者：Lenovo
     * 修改时间：2011-10-13 下午02:52:45 修改备注：
     *
     * @param paramObj
     * @return String
     * @Exception 异常对象
     *
     */
    public String deletePm(HashMap paramObj)throws Exception {
        String result = "";

        StringBuffer sqlBuffer = new StringBuffer();
        sqlBuffer.append("delete from ");
        sqlBuffer.append(paramObj.get("ctable").toString());
        sqlBuffer.append(" where ");
        sqlBuffer.append(paramObj.get("sql"));
        List items=(List)paramObj.get("iids");
        try {
            this.iHrPersonService.deletePm(sqlBuffer.toString());

            if(paramObj.containsKey("subTabName")&&null!=paramObj.get("subTabName"))
            {
                String subTabNameStr = paramObj.get("subTabName").toString();
                String[] subTabNameArr = subTabNameStr.split("\\|");

                List arr_ag= new ArrayList();
                for(int i=0;i<subTabNameArr.length;i++)
                {
                    HashMap arr_agMap = new HashMap();
                    arr_agMap.put("chidctable", subTabNameArr[i]);
                    arr_agMap.put("condition","");
                    arr_ag.add(arr_agMap);
                }
                paramObj.put("arr_dg", arr_ag);
            }

            //YJ Add 删除子表信息
            new ChildrenDataHandle().delChildData(paramObj);


            String childupdateSql="";

            for(int i=0;i<items.size();i++)
            {
                HashMap itemMap = (HashMap)items.get(i);
                childupdateSql+="delete from ab_invoiceuser where ifuncregedit='"+paramObj.get("ifuncregedit")+"' and iinvoices='"+itemMap.get("iid")+"';";

            }
            this.iHrPersonService.deleteAll(childupdateSql);
            result = "success";
        } catch (RuntimeException e) {
            e.printStackTrace();
            result = "fail";
        }
        /**
         * 添加系统操作日志
         */
        for(int i=0;i<items.size();i++)
        {
            HashMap itemMap = (HashMap)items.get(i);
            HashMap<String, Serializable> map = new HashMap<String, Serializable>();
            map.put("operate", "delete");
            map.put("result", result);
            HashMap params=new HashMap();
            params.put("iinvoice", itemMap.get("iid"));
            params.put("iifuncregedit", paramObj.get("ifuncregedit"));
            map.put("params", params);
            LogOperateUtil.insertLog(map);
        }
        return result;
    }

    public void updateSql(String childupdateSql)
    {
        this.iHrPersonService.deleteAll(childupdateSql);
    }
    /**
     *
     * getHashMapKeys(获得HashMap键值) 创建者：zhong_jing 创建时间：2011-10-13 下午02:33:21
     * 修改者：Lenovo 修改时间：2011-10-13 下午02:33:21 修改备注：
     *
     * @param paramObj
     * @return List<String>
     * @Exception 异常对象
     *
     */
    private List<String> getHashMapKeys(HashMap paramObj) {
        Iterator<String> iterator = paramObj.keySet().iterator();

        List<String> keys = new ArrayList<String>();
        while (iterator.hasNext()) {
            String key = iterator.next();
            keys.add(key);
        }
        return keys;
    }

    /**
     * 修改个人首页显示的注册表IID
     */
    @SuppressWarnings("unchecked")
    public String updateHomePage(HashMap person) {

        try {
            this.iHrPersonService.updateHomePage(person);

        } catch (Exception e) {
            e.printStackTrace();
            return "fail";
        }
        return "success";
    }

    // 保存公告
    public void addComm(HashMap params) {
        this.iHrPersonService.addComm(params);
    }



    /**
     * 根据领导代理部门获取部门
     * @param iperson
     * @return
     */
    public List querydepartment(int iperson){
        return this.iHrPersonService.querydepartment(iperson);
    }
    public List queryPerson(int iperson){
        return this.iHrPersonService.queryPerson(iperson);
    }


    /**
     * 获取领导所属人员XML
     * @return
     */
    @SuppressWarnings("unchecked")
    public HashMap getInitPersonByDepartmentXML(int iperson){
        List departList = querydepartment(iperson);
        List personList = queryPerson(iperson);
        HashMap map= new HashMap();

        if(personList.size() != 0 && personList.size() != 1){

            String xmldepart = ToXMLUtil.createTree(departList, "iid", "ipid","-1");
            String xmlperson = ToXMLUtil.createTreeFromList(personList);

            map.put("dept_xml",xmldepart );
            map.put("person_xml",xmlperson );
        }
        return map;
    }


    /**
     * 获取初始化验证密码
     * @return
     */
    private String getInitPwd(){
        return optionsService.getSysParamterByiid(SystemParamter.INIT_PWD);
    }

    /**
     * 获取个人预警设置列表
     * @param iperson
     * @return
     */
    @SuppressWarnings("unchecked")
    public HashMap selectEmsLists(String iperson){
        HashMap map = new HashMap();
        List list =iHrPersonService.select_ems_lists_by_iperson(iperson);
        map.put("list", list);
        return map;
    }

    /**
     * 保存个人预警
     * @param params
     * @return
     */
    @SuppressWarnings("unchecked")
    public String saveEms(HashMap params){
        String result = "success";

        try {
            List list = (List)params.get("list");
            int iperson = Integer.parseInt(params.get("iperson")+"");
            iHrPersonService.delEmsByperson(iperson);

            HashMap param = new HashMap();

            for (int i = 0; i < list.size(); i++) {
                iHrPersonService.inserEms( getEmsParams((HashMap)list.get(i),iperson ));
            }
        } catch (Exception e) {
            result="fail";
            e.printStackTrace();
        }
        return result;
    }

    @SuppressWarnings("unchecked")
    private HashMap getEmsParams(HashMap map,int iperson){
        HashMap params = new HashMap();
        params.put("ilistcd", map.get("ilistcd"));
        params.put("ccode", map.get("ccode"));
        params.put("cname", map.get("cname"));
        params.put("iperson", iperson);
        params.put("bvisible", map.get("bvisible"));
        return params;
    }


    public List applictionSearch(HashMap params){

        List list =  iHrPersonService.applictionSearch(params);

        return list;
    }

    /*
     * 	YJ Add 2012-05-08
     * 	初始化密码加密后的值 (人员档案初始化密码明码为：111111)
     * 	用于新增人员档案时
     */
    public String onGetIniPwd(){

        String rvalue = "";

        try{

            rvalue = CrmMd5Util.getEncryptedPwd("111111");

        }catch(Exception ex){
            ex.printStackTrace();
        }

        return rvalue;

    }
    
    public String updatePwd(HashMap param){
    	return iHrPersonService.updatePwd(param);
    }

}
