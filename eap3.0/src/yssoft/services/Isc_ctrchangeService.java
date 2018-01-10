package yssoft.services;
/**
 * 
 * 项目名称：yssoft 
 * 类名称：Isc_ctrchangeService
 * 类描述：Isc_ctrchangeService接口 
 * 创建人：刘磊
 * 创建时间：2011-9-29 9:32:37
 * 修改人：刘磊
 * 修改时间：2011-9-29 9:32:37
 * 修改备注：无
 * @version 1.0
 * 
 */

import java.util.HashMap;
import java.util.List;
public interface Isc_ctrchangeService {
         public List<HashMap> get_bywhere_sc_ctrchange(String condition) throws Exception;
         public int add_sc_ctrchange(HashMap vo_sc_ctrchange) throws Exception;
         public int update_sc_ctrchange(HashMap vo_sc_ctrchange) throws Exception;
         public int delete_bywhere_sc_ctrchange(String condition) throws Exception;
}