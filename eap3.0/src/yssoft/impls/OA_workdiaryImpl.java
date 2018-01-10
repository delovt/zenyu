package yssoft.impls;

/**
 * 
 * 项目名称：yssoft
 * 类名称：OA_workdiaryImpl
 * 类描述：OA_workdiaryImpl实现 
 * 创建人：刘磊
 * 创建时间：2012-3-30 16:35:04
 * 修改人：刘磊
 * 修改时间：2012-3-30 16:35:04
 * 修改备注：无
 * @version 1.0
 * 
 */

import yssoft.daos.BaseDao;
import yssoft.services.IOA_workdiaryService;

import java.util.HashMap;
import java.util.List;
public class OA_workdiaryImpl extends BaseDao implements IOA_workdiaryService {
         public List<HashMap> get_bywhere_OA_workdiary(String condition)
         {
                return this.queryForList("get_bywhere_OA_workdiary",condition);
         }
         public int add_OA_workdiary(HashMap vo_OA_workdiary)
         {
                return Integer.valueOf(this.insert("add_OA_workdiary",vo_OA_workdiary).toString());
         }
         public int update_OA_workdiary(HashMap vo_OA_workdiary)
         {
                return this.update("update_OA_workdiary",vo_OA_workdiary);
         }
         public int delete_bywhere_OA_workdiary(String condition)
         {
                return this.delete("delete_bywhere_OA_workdiary",condition);
         }
}