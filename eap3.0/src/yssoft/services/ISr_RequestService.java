package yssoft.services;
/**
 * 
 * 项目名称：yssoft 
 * 类名称：ISr_RequestService
 * 类描述：ISr_RequestService接口 
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
public interface ISr_RequestService {
         public List<HashMap> get_bywhere_Sr_Request(String condition) throws Exception;
         public int add_Sr_Request(HashMap vo_Sr_Request) throws Exception;
         public int update_Sr_Request(HashMap vo_Sr_Request) throws Exception;
         public int delete_bywhere_Sr_Request(String condition) throws Exception;
}