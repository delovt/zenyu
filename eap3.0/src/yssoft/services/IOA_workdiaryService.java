package yssoft.services;
/**
 * 
 * 项目名称：yssoft 
 * 类名称：IOA_workdiaryService
 * 类描述：IOA_workdiaryService接口 
 * 创建人：刘磊
 * 创建时间：2012-3-30 16:35:05
 * 修改人：刘磊
 * 修改时间：2012-3-30 16:35:05
 * 修改备注：无
 * @version 1.0
 * 
 */

import java.util.HashMap;
import java.util.List;
public interface IOA_workdiaryService {
         public List<HashMap> get_bywhere_OA_workdiary(String condition) throws Exception;
         public int add_OA_workdiary(HashMap vo_OA_workdiary) throws Exception;
         public int update_OA_workdiary(HashMap vo_OA_workdiary) throws Exception;
         public int delete_bywhere_OA_workdiary(String condition) throws Exception;
}