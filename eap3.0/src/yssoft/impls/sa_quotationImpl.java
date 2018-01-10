package yssoft.impls;
/**
 * 
 * 项目名称：yssoft
 * 类名称：sa_quotationImpl
 * 类描述：sa_quotationImpl实现 
 * 创建人：刘磊
 * 创建时间：2011-10-8 9:37:36
 * 修改人：刘磊
 * 修改时间：2011-10-8 9:37:36
 * 修改备注：无
 * @version 1.0
 * 
 */

import yssoft.daos.BaseDao;
import yssoft.services.Isa_quotationService;

import java.util.HashMap;
import java.util.List;
public class sa_quotationImpl extends BaseDao implements Isa_quotationService {
         public List<HashMap> get_bywhere_sa_quotation(String condition)
         {
                return this.queryForList("get_bywhere_sa_quotation",condition);
         }
         public int add_sa_quotation(HashMap vo_sa_quotation)
         {
                return Integer.valueOf(this.insert("add_sa_quotation",vo_sa_quotation).toString());
         }
         public int update_sa_quotation(HashMap vo_sa_quotation)
         {
                return this.update("update_sa_quotation",vo_sa_quotation);
         }
         public int delete_bywhere_sa_quotation(String condition)
         {
                return this.delete("delete_bywhere_sa_quotation",condition);
         }
         public List<HashMap> get_bywhere_sa_quotations(String condition)
         {
                return this.queryForList("get_bywhere_sa_quotations",condition);
         }
         public int add_sa_quotations(HashMap vo_sa_quotations)
         {
                return Integer.valueOf(this.insert("add_sa_quotations",vo_sa_quotations).toString());
         }
         public int update_sa_quotations(HashMap vo_sa_quotations)
         {
                return this.update("update_sa_quotations",vo_sa_quotations);
         }
         public int delete_bywhere_sa_quotations(String condition)
         {
                return this.delete("delete_bywhere_sa_quotations",condition);
         }
}