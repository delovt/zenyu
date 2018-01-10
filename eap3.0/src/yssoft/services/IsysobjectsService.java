package yssoft.services;
/**
 * 
 * 项目名称：yssoft 
 * 类名称：IsysobjectsService
 * 类描述：IsysobjectsService接口 
 * 创建人：刘磊
 * 创建时间：2012-2-8 16:40:17
 * 修改人：刘磊
 * 修改时间：2012-2-8 16:40:17
 * 修改备注：无
 * @version 1.0
 * 
 */

import java.util.HashMap;
import java.util.List;
public interface IsysobjectsService {
         public List<HashMap> get_bywhere_sysobjects(String condition) throws Exception;
}