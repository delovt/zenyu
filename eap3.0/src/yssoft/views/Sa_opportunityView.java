package yssoft.views;
/**
 * 
* 项目名称：yssoft
 * 创建人：孙东亚
 * 创建时间：2011-9-26
 * @version 1.0
 * 
 */

import yssoft.impls.ChildrenDataHandle;
import yssoft.services.ISa_opportunityService;

import java.util.HashMap;
import java.util.List;
public class Sa_opportunityView {
	private ISa_opportunityService i_Sa_opportunityService;
	public void seti_Sa_opportunityService(ISa_opportunityService i_Sa_opportunityService) {
		this.i_Sa_opportunityService = i_Sa_opportunityService;
	}
         public List<HashMap> get_bywhere_Sa_opportunity(String condition)
         {
               try
       		   {
        		   return this.i_Sa_opportunityService.get_bywhere_Sa_opportunity(condition);
		       }
		       catch(Exception e)
		       {
		    	   e.printStackTrace();
		           return null; 
		       }         
         }
         
         public String add_Sa_opportunity(HashMap vo_Sa_opportunity)
         {
               String result = "sucess";
               try
       		   {
        		  Object resultObj = this.i_Sa_opportunityService.add_Sa_opportunity(vo_Sa_opportunity);
        		  
        		//子表操作
        	    int iid = Integer.parseInt(resultObj.toString());
        		new ChildrenDataHandle().ChildData(vo_Sa_opportunity, iid);
        		  
        		  result = resultObj.toString();
		       }
		       catch(Exception e)
		       {
		          result = "fail";
		       }         
		       return result;
         }
         
         
         @SuppressWarnings("unchecked")
		public String update_Sa_opportunity(HashMap vo_Sa_opportunity)
         {
               String result = "sucess";
               try
       		   {
        		   int count = 0;
        		   int iid = Integer.parseInt(vo_Sa_opportunity.get("iid").toString());

        		   count = this.i_Sa_opportunityService.update_Sa_opportunity(vo_Sa_opportunity);

        			new ChildrenDataHandle().ChildData(vo_Sa_opportunity, iid);

        		   
        		   if(count!=1)
			       {
				       result = "fail";
                   }
		       }
		       catch(Exception e)
		       {
		           result = "fail";
		       }
		       return result;
         }
         
         
         public String delete_bywhere_Sa_opportunity(String condition)
         {
               String result = "sucess";
               try
       		   {
         			
         			int count = 0;
         			//  删除主表信息
         			count = i_Sa_opportunityService.delete_bywhere_Sa_opportunity(condition);
  
         			//  删除子表信息
         			StringBuilder strsql = new StringBuilder("");
         			String sqlcondition = condition.substring(condition.indexOf("in"),condition.length());
         			strsql.append(" delete sa_opcompetitor where iopportunity "+	sqlcondition);
         			strsql.append(" delete sa_opteam where iopportunity "+ sqlcondition);
  
         			HashMap<String,Object> paramMap = new HashMap<String,Object>();
         			paramMap.put("sqlValue", strsql.toString());
         			i_Sa_opportunityService.db_delete("CompetitorDest.del",paramMap);
       			
         		   if(count !=1)
  			       {
  				       result = "fail";
                    }
		       }
		       catch(Exception e)
		       {
		           result = "fail";
		       }
		       return result;
         }
}