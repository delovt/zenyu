package yssoft.views;
/**
 * 
 * 项目名称：yssoft
 * 类名称：OA_workdiaryView
 * 类描述：OA_workdiaryView视图 
 * 创建人：刘磊
 * 创建时间：2012-3-30 16:35:06
 * 修改人：刘磊
 * 修改时间：2012-3-30 16:35:06
 * 修改备注：无
 * @version 1.0
 * 
 */

import yssoft.services.IOA_workdiaryService;

import java.util.HashMap;
import java.util.List;
public class OA_workdiaryView {
	private IOA_workdiaryService i_OA_workdiaryService;
	public void seti_OA_workdiaryService(IOA_workdiaryService i_OA_workdiaryService) {
		this.i_OA_workdiaryService = i_OA_workdiaryService;
	}
         public List<HashMap> get_bywhere_OA_workdiary(String condition)
         {
               try
       		   {
        		   return this.i_OA_workdiaryService.get_bywhere_OA_workdiary(condition);
		       }
		       catch(Exception e)
		       {
		           return null;
		       }         
         }
         public String add_OA_workdiary(HashMap vo_OA_workdiary)
         {
               String result = "sucess";
               try
       		   {
        		  Object resultObj = this.i_OA_workdiaryService.add_OA_workdiary(vo_OA_workdiary);
        		  result = resultObj.toString();
		       }
		       catch(Exception e)
		       {
		          result = "fail";
		       }         
		       return result;
         }
         public String update_OA_workdiary(HashMap vo_OA_workdiary)
         {
               String result = "sucess";
               try
       		   {
        		   int count = this.i_OA_workdiaryService.update_OA_workdiary(vo_OA_workdiary);
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
         public String delete_bywhere_OA_workdiary(String condition)
         {
               String result = "sucess";
               try
       		   {
        		   int count = this.i_OA_workdiaryService.delete_bywhere_OA_workdiary(condition);
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