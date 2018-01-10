package yssoft.services;
/**
 * 
 * 项目名称：yssoft 
 * 类名称：Ioa_loanService
 * 类描述：Ioa_loanService接口 
 * 创建人：刘磊
 * 创建时间：2011-9-22 15:11:25
 * 修改人：刘磊
 * 修改时间：2011-9-22 15:11:25
 * 修改备注：无
 * @version 1.0
 * 
 */

import java.util.HashMap;
import java.util.List;
public interface Ioa_loanService {
         public List<HashMap> get_bywhere_oa_loan(String condition) throws Exception;
         public int add_oa_loan(HashMap vo_oa_loan) throws Exception;
         public int update_oa_loan(HashMap vo_oa_loan) throws Exception;
         public int delete_bywhere_oa_loan(String condition) throws Exception;
}