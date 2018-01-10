package yssoft.views;
/**
 * 
 * 项目名称：yssoft
 * 类名称：AC_fieldsView
 * 类描述：AC_fieldsView视图 
 * 创建人：刘磊
 * 创建时间：2012-2-9 11:48:30
 * 修改人：刘磊
 * 修改时间：2012-2-9 11:48:30
 * 修改备注：无
 * @version 1.0
 * 
 */

import yssoft.services.IAC_fieldsService;

import java.util.HashMap;
import java.util.List;
public class AC_fieldsView {
	private IAC_fieldsService i_AC_fieldsService;
	public void seti_AC_fieldsService(IAC_fieldsService i_AC_fieldsService) {
		this.i_AC_fieldsService = i_AC_fieldsService;
	}
         public List<HashMap> get_bywhere_AC_fields(String condition)
         {
               try
       		   {
        		   return this.i_AC_fieldsService.get_bywhere_AC_fields(condition);
		       }
		       catch(Exception e)
		       {
		           return null;
		       }         
         }
         public String add_AC_fields(HashMap vo_AC_fields)
         {
               String result = "sucess";
               try
       		   {
        		  Object resultObj = this.i_AC_fieldsService.add_AC_fields(vo_AC_fields);
        		  result = resultObj.toString();
		       }
		       catch(Exception e)
		       {
		          result = "fail";
		       }         
		       return result;
         }
         public String update_AC_fields(HashMap vo_AC_fields)
         {
               String result = "sucess";
               try
       		   {
        		   int count = this.i_AC_fieldsService.update_AC_fields(vo_AC_fields);
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
         public String delete_bywhere_AC_fields(String condition)
         {
               String result = "sucess";
               try
       		   {
        		   int count = this.i_AC_fieldsService.delete_bywhere_AC_fields(condition);
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