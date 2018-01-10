package yssoft.impls;
/**
 * 
 * 项目名称：yssoft
 * 类名称：OA_workplanImpl
 * 类描述：OA_workplanImpl实现 
 * 创建人：刘磊
 * 创建时间：2012-3-30 16:35:00
 * 修改人：刘磊
 * 修改时间：2012-3-30 16:35:00
 * 修改备注：无
 * @version 1.0
 * 
 */

import yssoft.daos.BaseDao;
import yssoft.services.IOA_workplanService;

import java.util.HashMap;
import java.util.List;
public class OA_workplanImpl extends BaseDao implements IOA_workplanService {
         public List<HashMap> get_bywhere_OA_workplan(String condition)
         {
                return this.queryForList("get_bywhere_OA_workplan",condition);
         }
         public int add_OA_workplan(HashMap vo_OA_workplan)
         {
                return Integer.valueOf(this.insert("add_OA_workplan",vo_OA_workplan).toString());
         }
         public int update_OA_workplan(HashMap vo_OA_workplan)
         {
                return this.update("update_OA_workplan",vo_OA_workplan);
         }
         public int delete_bywhere_OA_workplan(String condition)
         {
                return this.delete("delete_bywhere_OA_workplan",condition);
         }
}