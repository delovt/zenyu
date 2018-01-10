package yssoft.impls;

import java.util.HashMap;
import java.util.List;

import yssoft.daos.BaseDao;
import yssoft.services.UtilService;
import yssoft.utils.SwitchBaiduAddree;
import yssoft.utils.SwitchBaiduLocation;

public class UtilServiceImpl extends BaseDao implements UtilService{

	@Override
     public void updateRdrecords(HashMap condition) throws Exception {
        // TODO Auto-generated method stub
        this.update("updateRdrecords",condition);
    }

    @Override
    public List getTableMessageByifuncregedit(HashMap condition) throws Exception {
        // TODO Auto-generated method stub
        return  this.queryForList("getTableMessageByifuncregedit",condition);
    }

    @Override
    public List getRelationshipByiid(HashMap condition) throws Exception {
        // TODO Auto-generated method stub
        return  this.queryForList("getRelationshipByiid",condition);
    }

    @Override
    public List getRelationshipsByirelationship(HashMap condition) throws Exception {
        // TODO Auto-generated method stub
        return  this.queryForList("getRelationshipsByirelationship",condition);
    }

    @Override
    public List getConsultSet(String iid) throws Exception {
        // TODO Auto-generated method stub
        return  this.queryForList("getConsultSet",iid);
    }

    @Override
    public List exeSql(String sql) {
        // TODO Auto-generated method stub
        return this.queryForList("assembly_query_sql",sql);
    }
    
    
    /**
     * 查询该条记录是否被引用
     * @param ifuncregedit 引用注册码
     * @param iinvoice 引用单据编码
     * @param cfield 字段名
     * @return
     */
    @SuppressWarnings("rawtypes")
	public boolean isRepeatedly(HashMap param)
    {
    	int iinvoice = Integer.valueOf(param.get("iinvoice").toString()).intValue();    	
    	int oldifuncregedit =Integer.valueOf(param.get("ifuncregedit").toString()).intValue();
    	String cfield = param.get("cfield")+"";
    	
    	//YJ Add 用于分析产品档案数据删除前是否被引用，从合同、产品出入库单查询,目前暂考虑比较单一,只有在删除时判定
    	if(oldifuncregedit == 43 && cfield.equals("bdelete")){//产品档案
    		
    		List isquoteList = this.queryForList("getIsQuote",param);
    		if(isquoteList.size()>0) return false;
    		
    	}
    	else if(oldifuncregedit == 213 && cfield.equals("bdelete")){
    		List isquoteList = this.queryForList("getBomIsQuote",param);
    		if(isquoteList.size()>0) return false;
    	}
    	//SZC Add 用于客商是否被右侧的关联数据关联
    	else if(oldifuncregedit == 44 && cfield.equals("bdelete")){
    		List isquoteList = this.queryForList("getCScustomerIsQuote",param);
    		if(isquoteList.size()>0) return false;
    	}
    	else{//其他业务分析
	    	//先找出该单子是否被其他单子引用
	    	List repeatedlyList = this.queryForList("getRelationshipByifuncregedit",param);
			for(int i=0;i<repeatedlyList.size();i++)
			{
				HashMap repeatedlyMap=(HashMap)repeatedlyList.get(i);
				
				//找到引用这张单据的单据表名
				int ifuncregedit = Integer.valueOf(repeatedlyMap.get("ifuncregedit").toString()).intValue();
				
				HashMap newParm=new HashMap();
				newParm.put("iid", ifuncregedit);
				List tableList = this.queryForList("getTableNamByIid",newParm);
				if(param.containsKey("ifuncregedit2"))
				{
					int oldifuncregedit2 = Integer.valueOf(param.get("ifuncregedit2").toString()).intValue();
					if(oldifuncregedit2==ifuncregedit)
					{
						if(tableList.size()>0)
						{
							HashMap tableMap = (HashMap)tableList.get(0);
			
							
								if(tableMap.get("ctable")!=null&&!tableMap.get("ctable").equals(""))
								{
									String table =tableMap.get("ctable").toString();
									String sql ="select * from "+table+" where ifuncregedit="+oldifuncregedit+" and iinvoice="+iinvoice+" and iifuncregedit="+ifuncregedit;
					    			List vouchFormList = this.queryForList("assembly_query_sql",sql);
					    			if(vouchFormList.size()>0)
					    			{
					    				return false;
					    			}
								}
						}
					}
				}
				else
				{
					if(tableList.size()>0)
					{
						HashMap tableMap = (HashMap)tableList.get(0);
		
						
							if(tableMap.get("ctable")!=null&&!tableMap.get("ctable").equals(""))
							{
								String table =tableMap.get("ctable").toString();
								String sql ="select * from "+table+" where ifuncregedit="+oldifuncregedit+" and iinvoice="+iinvoice+" and iifuncregedit="+ifuncregedit;
				    			List vouchFormList = this.queryForList("assembly_query_sql",sql);
				    			if(vouchFormList.size()>0)
				    			{
				    				return false;
				    			}
							}
					}
				}
			}
    	}
    	return true;
    }

    public HashMap changeLocation(HashMap param)
    {
        String longitude = param.get("longitude").toString();
        String latitude = param.get("latitude").toString();
        HashMap map = new HashMap();
        /*//转换百度的GPS

        SwitchBaiduLocation sw = new SwitchBaiduLocation(longitude, latitude);
        sw.changeLocation();
        String blatitude = sw.lat != 0 ? (sw.lat + "") : "";
        String blongitude = sw.lng != 0 ? (sw.lng + "") : "";

        map.put("blatitude",blatitude);
        map.put("blongitude",blongitude);*/

        //获得地址
        SwitchBaiduAddree sw1 = new SwitchBaiduAddree(latitude,longitude);
        sw1.changeLocation();
        String address = sw1.address;
        map.put("address",address);
        return map;
    }

    @Override
    public String getTableNameByifuncregedit(int i) {
        return (String) this.queryForObject("getTableNameByifuncregedit", i);
    }


    @Override
    public List<HashMap> getStatusList(int i) throws Exception {
        return this.queryForList("getStatusList", i);
    }

    @Override
    public int insertTasks(HashMap paramObj) throws Exception {
        // TODO Auto-generated method stub
        int iid=Integer.parseInt(this.insert("insertTasks", paramObj).toString());
        return iid;
    }
    @Override
    public int updateOrderFsum(HashMap paramObj) throws Exception {
        // TODO Auto-generated method stub
        int iid=this.update("updateOrderFsum", paramObj);
        return iid;
    }
    @Override
    public int updateOrderfbackprofit(HashMap paramObj) throws Exception {
        // TODO Auto-generated method stub
        int iid=this.update("updateOrderfbackprofit", paramObj);
        return iid;
    }
    @Override
    public int updateOrderfcost(HashMap paramObj) throws Exception {
        // TODO Auto-generated method stub
        int iid=this.update("updateOrderfcost", paramObj);
        return iid;
    }
    @Override
    public int updateOrderFcostForCsn(HashMap paramObj) throws Exception {
        // TODO Auto-generated method stub
        int iid=this.update("updateOrderFcostForCsn", paramObj);
        return iid;
    }
    @Override
    public int setRdrecord(HashMap paramObj) throws Exception {
        // TODO Auto-generated method stub
        int iid=Integer.parseInt(this.insert("setRdrecord", paramObj)+"");
        return iid;
    }
    @Override
    public int setRdrecords(HashMap paramObj) throws Exception {
        // TODO Auto-generated method stub
        int iid=Integer.parseInt(this.insert("setRdrecords", paramObj)+"");
        return iid;
    }
    @Override
    public int setRdrecordsin(HashMap paramObj) throws Exception {
        // TODO Auto-generated method stub
        int iid=Integer.parseInt(this.insert("setRdrecordsin", paramObj)+"");
        return iid;
    }
    @Override
    public int setRdrecordsbom(HashMap paramObj) throws Exception {
        // TODO Auto-generated method stub
        int iid=Integer.parseInt(this.insert("setRdrecordsbom", paramObj)+"");
        return iid;
    }
    @Override
    public int setInvoiceprocess(HashMap paramObj) throws Exception {
        // TODO Auto-generated method stub
        int iid=Integer.parseInt(this.insert("setInvoiceprocess", paramObj)+"");
        return iid;
    }

    @Override
    public void insertInvoiceuser(HashMap param) {
        this.insert("add_ab_invoiceuser2", param);
    }
    @Override
    public int InsertSql(String sql) throws Exception {
        // TODO Auto-generated method stub
    	HashMap h=new HashMap();
    	h.put("sql", sql);
        int iid=Integer.parseInt(this.insert("InsertSqls", h)+"");
        return iid;
    }
    @Override
    public List selectNum(String sql) throws Exception {
        // TODO Auto-generated method stub
    	HashMap h=new HashMap();
    	h.put("sql", sql);
        return  this.queryForList("selectNum",h);
    }
}
