package yssoft.views;
/**
 * 
* 项目名称：yssoft
 * 类名称：oa_paymentView
 * 类描述：oa_loanView视图 
 * 创建人：孙东亚
 * 创建时间：2011-9-26
 * @version 1.0
 * 
 */

import yssoft.services.Ioa_paymentService;

import java.util.HashMap;
import java.util.List;
public class oa_paymentView {
	private Ioa_paymentService i_oa_paymentService;
	public void seti_oa_paymentService(Ioa_paymentService i_oa_paymentService) {
		this.i_oa_paymentService = i_oa_paymentService;
	}
         public List<HashMap> get_bywhere_oa_payment(String condition)
         {
               try
       		   {
        		   return this.i_oa_paymentService.get_bywhere_oa_payment(condition);
		       }
		       catch(Exception e)
		       {
		           return null;
		       }         
         }
         public String add_oa_payment(HashMap vo_oa_payment)
         {
               String result = "sucess";
               try
       		   {
        		  Object resultObj = this.i_oa_paymentService.add_oa_payment(vo_oa_payment);
        		  result = resultObj.toString();
		       }
		       catch(Exception e)
		       {
		          result = "fail";
		       }         
		       return result;
         }
         public String update_oa_payment(HashMap vo_oa_payment)
         {
               String result = "sucess";
               try
       		   {
        		   int count = this.i_oa_paymentService.update_oa_payment(vo_oa_payment);
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
         public String delete_bywhere_oa_payment(String condition)
         {
               String result = "sucess";
               try
       		   {
        		   int count = this.i_oa_paymentService.delete_bywhere_oa_payment(condition);
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