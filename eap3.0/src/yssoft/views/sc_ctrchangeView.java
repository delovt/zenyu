package yssoft.views;
/**
 * 
 * 项目名称：yssoft
 * 类名称：sc_ctrchangeView
 * 类描述：sc_ctrchangeView视图 
 * 创建人：刘磊
 * 创建时间：2011-9-29 9:32:38
 * 修改人：刘磊
 * 修改时间：2011-9-29 9:32:38
 * 修改备注：无
 * @version 1.0
 * 
 */

import yssoft.services.Isc_ctrchangeService;

import java.util.HashMap;
import java.util.List;
public class sc_ctrchangeView {
	private Isc_ctrchangeService i_sc_ctrchangeService;
	public void seti_sc_ctrchangeService(Isc_ctrchangeService i_sc_ctrchangeService) {
		this.i_sc_ctrchangeService = i_sc_ctrchangeService;
	}
         public List<HashMap> get_bywhere_sc_ctrchange(String condition)
         {
               try
       		   {
        		   return this.i_sc_ctrchangeService.get_bywhere_sc_ctrchange(condition);
		       }
		       catch(Exception e)
		       {
		           return null;
		       }         
         }
         public String add_sc_ctrchange(HashMap vo_sc_ctrchange)
         {
               String result = "sucess";
               try
       		   {
        		  Object resultObj = this.i_sc_ctrchangeService.add_sc_ctrchange(vo_sc_ctrchange);
        		  result = resultObj.toString();
		       }
		       catch(Exception e)
		       {
		          result = "fail";
		       }         
		       return result;
         }
         public String update_sc_ctrchange(HashMap vo_sc_ctrchange)
         {
               String result = "sucess";
               try
       		   {
        		   int count = this.i_sc_ctrchangeService.update_sc_ctrchange(vo_sc_ctrchange);
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
         public String delete_bywhere_sc_ctrchange(String condition)
         {
               String result = "sucess";
               try
       		   {
        		   int count = this.i_sc_ctrchangeService.delete_bywhere_sc_ctrchange(condition);
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