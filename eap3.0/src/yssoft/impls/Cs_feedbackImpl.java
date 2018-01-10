package yssoft.impls;
/**
 * 
 * 项目名称：yssoft
 * 类名称：Cs_feedbackImpl
 * 类描述：Cs_feedbackImpl实现 
 * 创建人：孙东亚
 * 创建时间：2011-9-22 15:13:28
 * 修改人：孙东亚
 * 修改时间：2011-9-22 15:13:28
 * 修改备注：无
 * @version 1.0
 * 
 */

import yssoft.daos.BaseDao;
import yssoft.services.ICs_feedbackService;

import java.util.HashMap;
import java.util.List;
public class Cs_feedbackImpl extends BaseDao implements ICs_feedbackService {
         public List<HashMap> get_bywhere_Cs_feedback(String condition)
         {
                return this.queryForList("get_bywhere_cs_feedback",condition);
         }
         public int add_Cs_feedback(HashMap vo_Cs_feedback)
         {
                return Integer.valueOf(this.insert("add_cs_feedback",vo_Cs_feedback).toString());
         }
         public int update_Cs_feedback(HashMap vo_Cs_feedback)
         {
                return this.update("update_cs_feedback",vo_Cs_feedback);
         }
         public int delete_bywhere_Cs_feedback(String condition)
         {
                return this.delete("delete_bywhere_cs_feedback",condition);
         }
}