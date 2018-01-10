package yssoft.impls;
/**
 * 
 * 项目名称：yssoft
 * 类名称：sc_ctrchangeImpl
 * 类描述：sc_ctrchangeImpl实现 
 * 创建人：刘磊
 * 创建时间：2011-9-29 9:32:36
 * 修改人：刘磊
 * 修改时间：2011-9-29 9:32:36
 * 修改备注：无
 * @version 1.0
 * 
 */

import yssoft.daos.BaseDao;
import yssoft.services.Isc_ctrchangeService;

import java.util.HashMap;
import java.util.List;
public class sc_ctrchangeImpl extends BaseDao implements Isc_ctrchangeService {
         public List<HashMap> get_bywhere_sc_ctrchange(String condition)
         {
                return this.queryForList("get_bywhere_sc_ctrchange",condition);
         }
         public int add_sc_ctrchange(HashMap vo_sc_ctrchange)
         {
                return Integer.valueOf(this.insert("add_sc_ctrchange",vo_sc_ctrchange).toString());
         }
         public int update_sc_ctrchange(HashMap vo_sc_ctrchange)
         {
                return this.update("update_sc_ctrchange",vo_sc_ctrchange);
         }
         public int delete_bywhere_sc_ctrchange(String condition)
         {
                return this.delete("delete_bywhere_sc_ctrchange",condition);
         }
}