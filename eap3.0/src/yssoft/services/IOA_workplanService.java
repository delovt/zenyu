package yssoft.services;
/**
 * 
 * 项目名称：yssoft 
 * 类名称：IOA_workplanService
 * 类描述：IOA_workplanService接口 
 * 创建人：刘磊
 * 创建时间：2012-3-30 16:35:01
 * 修改人：刘磊
 * 修改时间：2012-3-30 16:35:01
 * 修改备注：无
 * @version 1.0
 * 
 */

import java.util.HashMap;
import java.util.List;
public interface IOA_workplanService {
         public List<HashMap> get_bywhere_OA_workplan(String condition) throws Exception;
         public int add_OA_workplan(HashMap vo_OA_workplan) throws Exception;
         public int update_OA_workplan(HashMap vo_OA_workplan) throws Exception;
         public int delete_bywhere_OA_workplan(String condition) throws Exception;
}