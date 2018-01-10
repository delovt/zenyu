package yssoft.services;
/**
 * 
 * 项目名称：yssoft 
 * 类名称：Ioa_expenseService
 * 类描述：Ioa_expenseService接口 
 * 创建人：孙东亚
 * @version 1.0
 * 
 */

import java.util.HashMap;
import java.util.List;
public interface Ioa_expenseService {
         public List<HashMap> get_bywhere_oa_expense(String condition) throws Exception;
         public int add_oa_expense(HashMap vo_oa_expense) throws Exception;
         public int update_oa_expense(HashMap vo_oa_expense) throws Exception;
         public int delete_bywhere_oa_expense(String condition) throws Exception;
}