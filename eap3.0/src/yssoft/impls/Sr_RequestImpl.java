package yssoft.impls;
/**
 * 
 * 项目名称：yssoft
 * 类名称：Sr_RequestImpl
 * 类描述：Sr_RequestImpl实现 
 * 创建人：孙东亚
 * 创建时间：2011-9-22 15:13:28
 * 修改人：孙东亚
 * 修改时间：2011-9-22 15:13:28
 * 修改备注：无
 * @version 1.0
 * 
 */

import yssoft.daos.BaseDao;
import yssoft.services.ISr_RequestService;

import java.util.HashMap;
import java.util.List;
public class Sr_RequestImpl extends BaseDao implements ISr_RequestService {
         @SuppressWarnings("unchecked")
		public List<HashMap> get_bywhere_Sr_Request(String condition){
                return this.queryForList("get_bywhere_sr_request",condition);
         }
         public int add_Sr_Request(HashMap vo_Sr_Request)
         {
                return Integer.valueOf(this.insert("add_sr_request",vo_Sr_Request).toString());
         }
         public int update_Sr_Request(HashMap vo_Sr_Request)
         {
                return this.update("update_sr_request",vo_Sr_Request);
         }
         public int delete_bywhere_Sr_Request(String condition)
         {
                return this.delete("delete_bywhere_sr_request",condition);
         }
         
         //终止服务请求 YJ Add 
         public String onStopSrRequest(int iid){
        	 
        	 String rvalue = "suc";
        	 String strsql = "";
        	 HashMap<String,Object> hm = new HashMap<String,Object>();
        	 
        	 try{
        		 
        		 strsql = "update sr_request set istatus=2 where iid="+iid;
        		 strsql += " update sr_bill set iresult=4 where iinvoice="+iid;
        		 
        		 hm.put("sqlValue", strsql);
        		 this.queryForList("Sr_RequestDest.StopRequest",hm);
        		 
        	 }catch(Exception ex){
        		 ex.printStackTrace();
        		 rvalue = "fail";
        	 }
        	 
        	 return rvalue;
        	 
         }
}