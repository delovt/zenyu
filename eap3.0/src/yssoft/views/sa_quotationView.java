package yssoft.views;
/**
 * 
 * 项目名称：yssoft
 * 类名称：sa_quotationView
 * 类描述：sa_quotationView视图 
 * 创建人：刘磊
 * 创建时间：2011-10-8 9:37:37
 * 修改人：刘磊
 * 修改时间：2011-10-8 9:37:37
 * 修改备注：无
 * @version 1.0
 * 
 */

import yssoft.services.Isa_quotationService;

import java.util.HashMap;
import java.util.List;
public class sa_quotationView {
	private Isa_quotationService i_sa_quotationService;
	public void seti_sa_quotationService(Isa_quotationService i_sa_quotationService) {
		this.i_sa_quotationService = i_sa_quotationService;
	}
         public List<HashMap> get_bywhere_sa_quotation(String condition)
         {
               try
       		   {
        		   return this.i_sa_quotationService.get_bywhere_sa_quotation(condition);
		       }
		       catch(Exception e)
		       {
		           return null;
		       }         
         }
         public String add_sa_quotation(HashMap vo_sa_quotation)
         {
               String result = "sucess";
               try
       		   {
        		  Object resultObj = this.i_sa_quotationService.add_sa_quotation(vo_sa_quotation);
        		  result = resultObj.toString();
		       }
		       catch(Exception e)
		       {
		          result = "fail";
		       }         
		       return result;
         }
         public String update_sa_quotation(HashMap vo_sa_quotation)
         {
               String result = "sucess";
               try
       		   {
        		   int count = this.i_sa_quotationService.update_sa_quotation(vo_sa_quotation);
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
         public String delete_bywhere_sa_quotation(String condition)
         {
               String result = "sucess";
               try
       		   {
        		   int count = this.i_sa_quotationService.delete_bywhere_sa_quotation(condition);
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
       	// -------------------------------------------------主子表上下分隔-------------------------------------------------//
         public List<HashMap> get_bywhere_sa_quotations(String condition)
         {
               try
       		   {
        		   return this.i_sa_quotationService.get_bywhere_sa_quotations(condition);
		       }
		       catch(Exception e)
		       {
		           return null;
		       }         
         }
         public String add_sa_quotations(HashMap vo_sa_quotations)
         {
               String result = "sucess";
               try
       		   {
        		  Object resultObj = this.i_sa_quotationService.add_sa_quotations(vo_sa_quotations);
        		  result = resultObj.toString();
		       }
		       catch(Exception e)
		       {
		          result = "fail";
		       }         
		       return result;
         }
         public String update_sa_quotations(HashMap vo_sa_quotations)
         {
               String result = "sucess";
               try
       		   {
        		   int count = this.i_sa_quotationService.update_sa_quotations(vo_sa_quotations);
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
         public String delete_bywhere_sa_quotations(String condition)
         {
               String result = "sucess";
               try
       		   {
        		   int count = this.i_sa_quotationService.delete_bywhere_sa_quotations(condition);
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