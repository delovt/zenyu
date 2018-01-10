package yssoft.views;
/**
 * 
 * 项目名称：yssoft
 * 类名称：ab_invoiceuserView
 * 类描述：ab_invoiceuserView视图 
 * 创建人：刘磊
 * 创建时间：2011-10-13 9:41:13
 * 修改人：刘磊
 * 修改时间：2011-10-13 9:41:13
 * 修改备注：无
 * @version 1.0
 * 
 */

import yssoft.services.Iab_invoiceuserService;

import java.util.HashMap;
import java.util.List;
public class ab_invoiceuserView {
	private Iab_invoiceuserService i_ab_invoiceuserService;
	public void seti_ab_invoiceuserService(Iab_invoiceuserService i_ab_invoiceuserService) {
		this.i_ab_invoiceuserService = i_ab_invoiceuserService;
	}
         public List<HashMap> get_bywhere_ab_invoiceuser(String condition)
         {
               try
       		   {
        		   return this.i_ab_invoiceuserService.get_bywhere_ab_invoiceuser(condition);
		       }
		       catch(Exception e)
		       {
		           return null;
		       }         
         }
         public String add_ab_invoiceuser(HashMap vo_ab_invoiceuser)
         {
               String result = "sucess";
               try
       		   {
        		  this.i_ab_invoiceuserService.add_ab_invoiceuser(vo_ab_invoiceuser);
		       }
		       catch(Exception e)
		       {
		          result = "fail";
		       }         
		       return result;
         }
         public String update_ab_invoiceuser(HashMap vo_ab_invoiceuser)
         {
               String result = "sucess";
               try
       		   {
        		   int count = this.i_ab_invoiceuserService.update_ab_invoiceuser(vo_ab_invoiceuser);
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
         public String delete_bywhere_ab_invoiceuser(String condition)
         {
               String result = "sucess";
               try
       		   {
        		   int count = this.i_ab_invoiceuserService.delete_bywhere_ab_invoiceuser(condition);
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
         
         @SuppressWarnings("unchecked")
		public HashMap isExist_invoice(HashMap param)
         {
        	 HashMap params = new HashMap();
        	 params.put("flag","ok");
        	 
        	  int count = this.i_ab_invoiceuserService.isExist_invoice(param);
      		  if( count > 0){
      			params.put("flag","no");
      		  } 
      		  
      		  params.put("invoice",param);
		      return params;
         }
         public String pr_execdellinktable(HashMap param)
         {
             String result = "sucess";
        	 try
        	 {
        	     if (!this.i_ab_invoiceuserService.pr_execdellinktable(param))
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
         
		 public String pr_invoiceuser_custperson(HashMap param)
         {
			     String result = "sucess";
	        	 try
	        	 {
	        	     if (!this.i_ab_invoiceuserService.pr_invoiceuser_custperson(param))
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