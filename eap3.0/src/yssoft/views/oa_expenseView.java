package yssoft.views;
/**
 * 
* 项目名称：yssoft
 * 创建人：孙东亚
 * 创建时间：2011-9-26
 * @version 1.0
 * 
 */

import yssoft.services.Ioa_expenseService;

import java.util.HashMap;
import java.util.List;
public class oa_expenseView {
	private Ioa_expenseService i_oa_expensetService;
	public void seti_oa_expensetService(Ioa_expenseService i_oa_expensetService) {
		this.i_oa_expensetService = i_oa_expensetService;
	}
         public List<HashMap> get_bywhere_oa_expenset(String condition)
         {
               try
       		   {
        		   return this.i_oa_expensetService.get_bywhere_oa_expense(condition);
		       }
		       catch(Exception e)
		       {
		    	   e.printStackTrace();
		           return null; 
		       }         
         }
         public String add_oa_expenset(HashMap vo_oa_expenset)
         {
               String result = "sucess";
               try
       		   {
        		  Object resultObj = this.i_oa_expensetService.add_oa_expense(vo_oa_expenset);
        		  result = resultObj.toString();
		       }
		       catch(Exception e)
		       {
		          result = "fail";
		       }         
		       return result;
         }
         public String update_oa_expenset(HashMap vo_oa_expenset)
         {
               String result = "sucess";
               try
       		   {
        		   int count = this.i_oa_expensetService.update_oa_expense(vo_oa_expenset);
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
         public String delete_bywhere_oa_expenset(String condition)
         {
               String result = "sucess";
               try
       		   {
        		   int count = this.i_oa_expensetService.delete_bywhere_oa_expense(condition);
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
}