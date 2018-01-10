package yssoft.services;
/**
 * 
 * 项目名称：yssoft 
 * 类名称：Isa_quotationService
 * 类描述：Isa_quotationService接口 
 * 创建人：刘磊
 * 创建时间：2011-10-8 9:37:36
 * 修改人：刘磊
 * 修改时间：2011-10-8 9:37:36
 * 修改备注：无
 * @version 1.0
 * 
 */

import java.util.HashMap;
import java.util.List;
public interface Isa_quotationService {
         public List<HashMap> get_bywhere_sa_quotation(String condition) throws Exception;
         public int add_sa_quotation(HashMap vo_sa_quotation) throws Exception;
         public int update_sa_quotation(HashMap vo_sa_quotation) throws Exception;
         public int delete_bywhere_sa_quotation(String condition) throws Exception;
         public List<HashMap> get_bywhere_sa_quotations(String condition) throws Exception;
         public int add_sa_quotations(HashMap vo_sa_quotations) throws Exception;
         public int update_sa_quotations(HashMap vo_sa_quotations) throws Exception;
         public int delete_bywhere_sa_quotations(String condition) throws Exception;
}