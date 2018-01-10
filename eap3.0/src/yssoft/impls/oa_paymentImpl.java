package yssoft.impls;
/**
 * 
 * 项目名称：yssoft
 * 类名称：oa_paymentImpl
 * 创建人：孙东亚
 * 
 */

import yssoft.daos.BaseDao;
import yssoft.services.Ioa_paymentService;

import java.util.HashMap;
import java.util.List;
public class oa_paymentImpl extends BaseDao implements Ioa_paymentService {
         public List<HashMap> get_bywhere_oa_payment(String condition)
         {
                return this.queryForList("get_bywhere_oa_payment",condition);
         }
         public int add_oa_payment(HashMap vo_oa_payment)
         {
                return Integer.valueOf(this.insert("add_oa_payment",vo_oa_payment).toString());
         }
         public int update_oa_payment(HashMap vo_oa_payment)
         {
                return this.update("update_oa_payment",vo_oa_payment);
         }
         public int delete_bywhere_oa_payment(String condition)
         {
                return this.delete("delete_bywhere_oa_payment",condition);
         }
}