package yssoft.impls;
/**
 * 
 * 项目名称：yssoft
 * 类名称：AC_tableImpl
 * 类描述：AC_tableImpl实现 
 * 创建人：刘磊
 * 创建时间：2012-2-9 16:39:14
 * 修改人：刘磊
 * 修改时间：2012-2-9 16:39:14
 * 修改备注：无
 * @version 1.0
 * 
 */

import yssoft.daos.BaseDao;
import yssoft.services.IAC_tableService;

import java.util.HashMap;
import java.util.List;
public class AC_tableImpl extends BaseDao implements IAC_tableService {
         public List<HashMap> get_bywhere_AC_table(String condition)
         {
                return this.queryForList("get_bywhere_AC_table",condition);
         }
         public int add_AC_table(HashMap vo_AC_table)
         {
                return Integer.valueOf(this.insert("add_AC_table",vo_AC_table).toString());
         }
         public int update_AC_table(HashMap vo_AC_table)
         {
                return this.update("update_AC_table",vo_AC_table);
         }
         public int delete_bywhere_AC_table(String condition)
         {
                return this.delete("delete_bywhere_AC_table",condition);
         }
         public boolean pr_updatedatadic()
         {
        	 try
        	 {
        		this.queryForList("pr_updatedatadic");
                return true;
        	 }
        	 catch(Exception err)
        	 {
        		return false; 
        	 }
         }
}