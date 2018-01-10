package yssoft.services;
/**
 * 
 * 项目名称：yssoft 
 * 类名称：Ibm_targetService
 * 类描述：Ibm_targetService接口 
 * 创建人：lzx
 * 创建时间：2012-9-28 
 * 修改人：
 * 修改时间：
 * 修改备注：无
 * @version 1.0
 * 
 */

import yssoft.vos.BmTargetVO;

import java.util.HashMap;
import java.util.List;
public interface Ibm_targetService {
         public HashMap get_bm_target_byiid(int iid);
         public List<HashMap> get_all_bm_target();
         public Object add_bm_target(BmTargetVO bmTargetVO);
         public Object update_bm_target(BmTargetVO bmTargetVO);
         public Object delete_bm_target_byiid(int iid) ;
         public List getFieldsByTable(String tablename) ;
}