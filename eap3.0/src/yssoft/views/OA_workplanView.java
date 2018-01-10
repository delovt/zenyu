package yssoft.views;
/**
 * 
 * 项目名称：yssoft
 * 类名称：OA_workplanView
 * 类描述：OA_workplanView视图 
 * 创建人：刘磊
 * 创建时间：2012-3-30 16:35:03
 * 修改人：刘磊
 * 修改时间：2012-3-30 16:35:03
 * 修改备注：无
 * @version 1.0
 * 
 */

import yssoft.services.IOA_workplanService;

import java.util.HashMap;
import java.util.List;
public class OA_workplanView {
	private IOA_workplanService i_OA_workplanService;
	public void seti_OA_workplanService(IOA_workplanService i_OA_workplanService) {
		this.i_OA_workplanService = i_OA_workplanService;
	}
         public List<HashMap> get_bywhere_OA_workplan(String condition)
         {
               try
       		   {
        		   return this.i_OA_workplanService.get_bywhere_OA_workplan(condition);
		       }
		       catch(Exception e)
		       {
		           return null;
		       }         
         }
         public String add_OA_workplan(HashMap vo_OA_workplan)
         {
               String result = "sucess";
               try
       		   {
        		  Object resultObj = this.i_OA_workplanService.add_OA_workplan(vo_OA_workplan);
        		  result = resultObj.toString();
		       }
		       catch(Exception e)
		       {
		          result = "fail";
		       }         
		       return result;
         }
         public String update_OA_workplan(HashMap vo_OA_workplan)
         {
               String result = "sucess";
               try
       		   {
        		   int count = this.i_OA_workplanService.update_OA_workplan(vo_OA_workplan);
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
         public String delete_bywhere_OA_workplan(String condition)
         {
               String result = "sucess";
               try
       		   {
        		   int count = this.i_OA_workplanService.delete_bywhere_OA_workplan(condition);
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