package yssoft.services;
/**
 * 
 * 项目名称：yssoft 
 * 类名称：ISa_opportunityService
 * 类描述：ISa_opportunityService接口 
 * 创建人：孙东亚
 * 创建时间：2011-9-22 15:11:25
 * 修改人：孙东亚
 * 修改时间：2011-9-22 15:11:25
 * 修改备注：无
 * @version 1.0
 * 
 */

import java.util.HashMap;
import java.util.List;

public interface ISa_opportunityService {
         public List<HashMap> get_bywhere_Sa_opportunity(String condition) throws Exception;
         public int add_Sa_opportunity(HashMap vo_Sa_opportunity) throws Exception;
         public int update_Sa_opportunity(HashMap vo_Sa_opportunity) throws Exception;
         public int delete_bywhere_Sa_opportunity(String condition) throws Exception;
         
         public int db_delete(String sqlName,Object obj);
         public int db_update(String sqlName,Object obj);
}