package yssoft.services;

import java.util.HashMap;
import java.util.List;

public interface UtilService {
	public void updateRdrecords(HashMap condition) throws Exception;
    public List<HashMap> getRelationshipByiid(HashMap paramObj) throws Exception;
    public List<HashMap> getTableMessageByifuncregedit(HashMap paramObj) throws Exception;
    public List<HashMap> getRelationshipsByirelationship(HashMap paramObj) throws Exception;
    public List<HashMap> getConsultSet(String iid) throws Exception;
    public List<HashMap> exeSql(String sql) throws Exception;
    public int insertTasks(HashMap paramObj) throws Exception;
    public int updateOrderFsum(HashMap paramObj) throws Exception;
    public int updateOrderfbackprofit(HashMap paramObj) throws Exception;
    public int updateOrderfcost(HashMap paramObj) throws Exception;
    public int updateOrderFcostForCsn(HashMap paramObj) throws Exception;
    public int setRdrecord(HashMap paramObj) throws Exception;
    public int setRdrecords(HashMap paramObj) throws Exception;
    public int setRdrecordsin(HashMap paramObj) throws Exception;
    public int setRdrecordsbom(HashMap paramObj) throws Exception;
    public int setInvoiceprocess(HashMap paramObj) throws Exception;
    public int InsertSql(String sql) throws Exception;
    public List<HashMap> selectNum(String sql) throws Exception;
    
    
    
    
    /**
     * 查询该条记录是否被引用
     * @param ifuncregedit 引用注册码
     * @param iinvoice 引用单据编码
     * @param cfield 字段名
     * @return
     */
    public boolean isRepeatedly(HashMap param);

    public HashMap changeLocation(HashMap param);


    public String getTableNameByifuncregedit(int i);

    public List<HashMap> getStatusList(int i) throws Exception;

    //            //插入权限
    public void insertInvoiceuser(HashMap param);
}
