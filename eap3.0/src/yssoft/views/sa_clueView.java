package yssoft.views;
/**
 * 
 * 项目名称：yssoft
 * 类名称：sa_clueView
 * 类描述：sa_clueView视图 
 * 创建人：刘磊
 * 创建时间：2011-9-26 16:40:03
 * 修改人：刘磊
 * 修改时间：2011-9-26 16:40:03
 * 修改备注：无
 * @version 1.0
 * 
 */

import yssoft.services.Isa_clueService;

import java.util.HashMap;
import java.util.List;
public class sa_clueView {
	private Isa_clueService i_sa_clueService;
	public void seti_sa_clueService(Isa_clueService i_sa_clueService) {
		this.i_sa_clueService = i_sa_clueService;
	}
         public List<HashMap> get_bywhere_sa_clue(String condition)
         {
               try
       		   {
        		   return this.i_sa_clueService.get_bywhere_sa_clue(condition);
		       }
		       catch(Exception e)
		       {
		           return null;
		       }         
         }
         public String add_sa_clue(HashMap vo_sa_clue)
         {
               String result = "sucess";
               try
       		   {
        		  Object resultObj = this.i_sa_clueService.add_sa_clue(vo_sa_clue);
        		  result = resultObj.toString();
		       }
		       catch(Exception e)
		       {
		          result = "fail";
		       }         
		       return result;
         }
         public String update_sa_clue(HashMap vo_sa_clue)
         {
               String result = "sucess";
               try
       		   {
        		   int count = this.i_sa_clueService.update_sa_clue(vo_sa_clue);
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
         public String delete_bywhere_sa_clue(String condition)
         {
               String result = "sucess";
               try
       		   {
        		   int count = this.i_sa_clueService.delete_bywhere_sa_clue(condition);
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