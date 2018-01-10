package yssoft.views;
/**
 * 
* 项目名称：yssoft
 * 创建人：孙东亚
 * 创建时间：2011-9-26
 * @version 1.0
 * 
 */

import yssoft.services.ICs_feedbackService;

import java.util.HashMap;
import java.util.List;
public class Cs_feedbackView {
	private ICs_feedbackService i_Cs_feedbackService;
	public void seti_Cs_feedbackService(ICs_feedbackService i_Cs_feedbackService) {
		this.i_Cs_feedbackService = i_Cs_feedbackService;
	}
         public List<HashMap> get_bywhere_Cs_feedback(String condition)
         {
               try
       		   {
        		   return this.i_Cs_feedbackService.get_bywhere_Cs_feedback(condition);
		       }
		       catch(Exception e)
		       {
		           return null; 
		       }         
         }
         public String add_Cs_feedback(HashMap vo_Cs_feedback)
         {
               String result = "sucess";
               try
       		   {
        		  Object resultObj = this.i_Cs_feedbackService.add_Cs_feedback(vo_Cs_feedback);
        		  result = resultObj.toString();
		       }
		       catch(Exception e)
		       {
		          result = "fail";
		       }         
		       return result;
         }
         public String update_Cs_feedback(HashMap vo_Cs_feedback)
         {
               String result = "sucess";
               try
       		   {
        		   int count = this.i_Cs_feedbackService.update_Cs_feedback(vo_Cs_feedback);
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
         public String delete_bywhere_Cs_feedback(String condition)
         {
               String result = "sucess";
               try
       		   {
        		   int count = this.i_Cs_feedbackService.delete_bywhere_Cs_feedback(condition);
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