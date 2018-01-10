package yssoft.impls;
/**
 * 
 * 项目名称：yssoft
 * 类名称：oa_loanImpl
 * 类描述：oa_loanImpl实现 
 * 创建人：刘磊
 * 创建时间：2011-9-22 15:13:28
 * 修改人：刘磊
 * 修改时间：2011-9-22 15:13:28
 * 修改备注：无
 * @version 1.0
 * 
 */

import yssoft.daos.BaseDao;
import yssoft.services.Ioa_expenseService;

import java.util.HashMap;
import java.util.List;
public class oa_expenseImpl extends BaseDao implements Ioa_expenseService {
         public List<HashMap> get_bywhere_oa_expense(String condition)
         {
                return this.queryForList("get_bywhere_oa_expense",condition);
         }
         public int add_oa_expense(HashMap vo_oa_expense)
         {
                return Integer.valueOf(this.insert("add_oa_expense",vo_oa_expense).toString());
         }
         public int update_oa_expense(HashMap vo_oa_expense)
         {
                return this.update("update_oa_expense",vo_oa_expense);
         }
         public int delete_bywhere_oa_expense(String condition)
         {
                return this.delete("delete_bywhere_oa_expense",condition);
         }
}