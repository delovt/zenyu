package yssoft.services;
/**
 * 
 * 项目名称：yssoft 
 * 类名称：IAC_tableService
 * 类描述：IAC_tableService接口 
 * 创建人：刘磊
 * 创建时间：2012-2-9 16:39:15
 * 修改人：刘磊
 * 修改时间：2012-2-9 16:39:15
 * 修改备注：无
 * @version 1.0
 * 
 */

import java.util.HashMap;
import java.util.List;
public interface IAC_tableService {
	     public boolean pr_updatedatadic() throws Exception;
         public List<HashMap> get_bywhere_AC_table(String condition) throws Exception;
         public int add_AC_table(HashMap vo_AC_table) throws Exception;
         public int update_AC_table(HashMap vo_AC_table) throws Exception;
         public int delete_bywhere_AC_table(String condition) throws Exception;
}