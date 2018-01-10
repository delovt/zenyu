

package yssoft.impls;

import yssoft.daos.BaseDao;

import java.util.HashMap;
import java.util.List;

@SuppressWarnings("serial")
public class DataCorrectImpl extends BaseDao {

	public DataCorrectImpl(){}
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public List onGetControlsPropertys(HashMap param){
		
		List list = null;
		String sql = "";
		HashMap hm = new HashMap();
		
		try{
			
			sql = "select ac_datadictionary.iid,ccaption,as_datatype.ctype,cfield,ac_consultconfiguration.* from "+
				  "(select iid,ccaption,idatatype,cfield from ac_datadictionary where ifuncregedit="+param.get("ifuncregedit")+" and ctable='"+param.get("ctable")+"' and bbatchupdate=1) ac_datadictionary "+
				  "left join (select iid,ctype from as_datatype) as_datatype on ac_datadictionary.idatatype=as_datatype.iid "+
				  "left join "+
				  "(select idatadictionary,iconsult,lower(cconsulttable) cconsulttable,cconsultbkfld,cconsultswfld,cconsultipvf,bconsultmtbk,"+
				  "bconsultendbk,bconsultcheck,benabled,cconsultcondition,consultSql from ac_consultconfiguration "+
				  "left join (select iid,case when ac_consultset.itype=0 then ac_consultset.ctreesql else REPLACE(ac_consultset.cgridsql,'@join','') end consultSql from ac_consultset) ac_consultset "+
				  "on ac_consultConfiguration.iconsult = ac_consultset.iid where iconsult>0) ac_consultconfiguration "+
				  "on ac_datadictionary.iid = ac_consultconfiguration.idatadictionary";
			
			hm.put("sqlvalue", sql);
			list = this.queryForList("DataCorrectDest.search",hm);
			
		}catch(Exception ex){
			ex.printStackTrace();
		}
		finally{
			
		}
		
		return list;
		
	}
	
	
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public String onUpdate(HashMap param){
		
		String rstr = "suc";
		String strsql = "update " +param.get("ctable")+" set ";
		
		List list = (List)param.get("dataArr");
        List<HashMap> iidsList = (List<HashMap>) param.get("iidsList");

		for(int i=0;i<list.size();i++){
			
			HashMap item = (HashMap)list.get(i);
			
			strsql += item.get("cfield")+"="+item.get("cvalue")+",";
		}
		
		strsql = strsql.substring(0,strsql.lastIndexOf(",")) +" where ";



        int i = 0;
        for (HashMap iidsitem : iidsList) {
            String iids = iidsitem.get("iids").toString();
            if (i == 0) {
                strsql = strsql  + " iid in(" + iids + ") ";
            } else {
                strsql = strsql + " or iid in(" + iids + ") ";
            }

            i++;
        }

        HashMap updateParam = new HashMap();
        updateParam.put("sqlvalue", strsql);
		
		try{
			
			this.update("DataCorrectDest.update",updateParam);
			
		}catch(Exception ex){
			rstr = "fail";
			ex.printStackTrace();
		}finally{
			list.clear();
			param.clear();
			strsql = "";
		}
		
		return rstr;
	}
	
}
