package yssoft.views;
/**
 * 
 * 项目名称：yssoft
 * 类名称：sysobjectsView
 * 类描述：sysobjectsView视图 
 * 创建人：刘磊
 * 创建时间：2012-2-8 16:40:23
 * 修改人：刘磊
 * 修改时间：2012-2-8 16:40:23
 * 修改备注：无
 * @version 1.0
 * 
 */

import yssoft.services.IsysobjectsService;

import java.util.HashMap;
import java.util.List;
public class sysobjectsView {
	private IsysobjectsService i_sysobjectsService;
	public void seti_sysobjectsService(IsysobjectsService i_sysobjectsService) {
		this.i_sysobjectsService = i_sysobjectsService;
	}
         public List<HashMap> get_bywhere_sysobjects()
         {
               try
       		   {
        		   return this.i_sysobjectsService.get_bywhere_sysobjects(" and A.xtype='U'");
		       }
		       catch(Exception e)
		       {
		           return null;
		       }         
         }
}