package yssoft.services;
/**
 * 
 * 项目名称：yssoft 
 * 类名称：IAC_fieldsService
 * 类描述：IAC_fieldsService接口 
 * 创建人：刘磊
 * 创建时间：2012-2-9 11:48:28
 * 修改人：刘磊
 * 修改时间：2012-2-9 11:48:28
 * 修改备注：无
 * @version 1.0
 * 
 */

import java.util.HashMap;
import java.util.List;
public interface IAC_fieldsService {
         public List<HashMap> get_bywhere_AC_fields(String condition) throws Exception;
         public int add_AC_fields(HashMap vo_AC_fields) throws Exception;
         public int update_AC_fields(HashMap vo_AC_fields) throws Exception;
         public int delete_bywhere_AC_fields(String condition) throws Exception;
         
         /**
          * 作者：XZQWJ
          * 时间：2013-02-02
          * 功能：批量执行修改物理表sql
          * @param param
          * @throws Exception
          */
         public void executeSqlList(HashMap param) throws Exception;
}