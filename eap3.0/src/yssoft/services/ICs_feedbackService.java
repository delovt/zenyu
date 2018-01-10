package yssoft.services;
/**
 * 
 * 项目名称：yssoft 
 * 类名称：ICs_feedbackService
 * 类描述：ICs_feedbackService接口 
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
public interface ICs_feedbackService {
         public List<HashMap> get_bywhere_Cs_feedback(String condition) throws Exception;
         public int add_Cs_feedback(HashMap vo_Cs_feedback) throws Exception;
         public int update_Cs_feedback(HashMap vo_Cs_feedback) throws Exception;
         public int delete_bywhere_Cs_feedback(String condition) throws Exception;
}