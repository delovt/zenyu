package yssoft.views;
/**
 * 
* 项目名称：yssoft
 * 创建人：孙东亚
 * 创建时间：2011-9-26
 * @version 1.0
 * 
 */

import yssoft.services.ISr_RequestService;

import java.util.HashMap;
import java.util.List;
public class Sr_RequestView {
	private ISr_RequestService i_Sr_RequestService;
	public void seti_Sr_RequestService(ISr_RequestService i_Sr_RequestService) {
		this.i_Sr_RequestService = i_Sr_RequestService;
	}
         public List<HashMap> get_bywhere_Sr_Request(String condition)
         {
               try
       		   {
        		   return this.i_Sr_RequestService.get_bywhere_Sr_Request(condition);
		       }
		       catch(Exception e)
		       {
		    	   e.printStackTrace();
		           return null; 
		       }         
         }
         public String add_Sr_Request(HashMap vo_Sr_Request)
         {
               String result = "sucess";
               try
       		   {
        		  Object resultObj = this.i_Sr_RequestService.add_Sr_Request(vo_Sr_Request);
        		  result = resultObj.toString();
		       }
		       catch(Exception e)
		       {
		          result = "fail";
		       }         
		       return result;
         }
         public String update_Sr_Request(HashMap vo_Sr_Request)
         {
               String result = "sucess";
               try
       		   {
        		   int count = this.i_Sr_RequestService.update_Sr_Request(vo_Sr_Request);
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
         public String delete_bywhere_Sr_Request(String condition)
         {
               String result = "sucess";
               try
       		   {
        		   int count = this.i_Sr_RequestService.delete_bywhere_Sr_Request(condition);
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