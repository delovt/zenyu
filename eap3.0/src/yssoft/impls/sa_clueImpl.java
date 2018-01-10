package yssoft.impls;
/**
 * 
 * 项目名称：yssoft
 * 类名称：sa_clueImpl
 * 类描述：sa_clueImpl实现 
 * 创建人：刘磊
 * 创建时间：2011-9-26 16:39:59
 * 修改人：刘磊
 * 修改时间：2011-9-26 16:39:59
 * 修改备注：无
 * @version 1.0
 * 
 */

import yssoft.daos.BaseDao;
import yssoft.services.Isa_clueService;

import java.util.HashMap;
import java.util.List;
public class sa_clueImpl extends BaseDao implements Isa_clueService {
         public List<HashMap> get_bywhere_sa_clue(String condition)
         {
                return this.queryForList("get_bywhere_sa_clue",condition);
         }
         public int add_sa_clue(HashMap vo_sa_clue)
         {
                return Integer.valueOf(this.insert("add_sa_clue",vo_sa_clue).toString());
         }
         public int update_sa_clue(HashMap vo_sa_clue)
         {
                return this.update("update_sa_clue",vo_sa_clue);
         }
         public int delete_bywhere_sa_clue(String condition)
         {
                return this.delete("delete_bywhere_sa_clue",condition);
         }
}