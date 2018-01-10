package yssoft.services;
/**
 * 
 * 项目名称：yssoft 
 * 类名称：Iab_invoiceuserService
 * 类描述：Iab_invoiceuserService接口 
 * 创建人：刘磊
 * 创建时间：2011-10-13 9:41:11
 * 修改人：刘磊
 * 修改时间：2011-10-13 9:41:11
 * 修改备注：无
 * @version 1.0
 * 
 */

import java.util.HashMap;
import java.util.List;
public interface Iab_invoiceuserService {
         public List<HashMap> get_bywhere_ab_invoiceuser(String condition) throws Exception;
         public boolean pr_execdellinktable(HashMap param) throws Exception;
         public boolean pr_invoiceuser_custperson(HashMap param) throws Exception;
         public void add_ab_invoiceuser(HashMap vo_ab_invoiceuser) throws Exception,RuntimeException;
         public int update_ab_invoiceuser(HashMap vo_ab_invoiceuser) throws Exception,RuntimeException;
         public int delete_bywhere_ab_invoiceuser(String condition) throws Exception,RuntimeException;
         public int isExist_invoice(HashMap param);
}