package yssoft.services;
/**
 * 
 * 项目名称：yssoft 
 * 类名称：Isa_clueService
 * 类描述：Isa_clueService接口 
 * 创建人：刘磊
 * 创建时间：2011-9-26 16:40:00
 * 修改人：刘磊
 * 修改时间：2011-9-26 16:40:00
 * 修改备注：无
 * @version 1.0
 * 
 */

import java.util.HashMap;
import java.util.List;
public interface Isa_clueService {
         public List<HashMap> get_bywhere_sa_clue(String condition) throws Exception;
         public int add_sa_clue(HashMap vo_sa_clue) throws Exception;
         public int update_sa_clue(HashMap vo_sa_clue) throws Exception;
         public int delete_bywhere_sa_clue(String condition) throws Exception;
}