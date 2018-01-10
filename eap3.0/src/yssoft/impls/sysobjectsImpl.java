package yssoft.impls;
/**
 * 
 * 项目名称：yssoft
 * 类名称：sysobjectsImpl
 * 类描述：sysobjectsImpl实现 
 * 创建人：刘磊
 * 创建时间：2012-2-8 16:40:16
 * 修改人：刘磊
 * 修改时间：2012-2-8 16:40:16
 * 修改备注：无
 * @version 1.0
 * 
 */

import yssoft.daos.BaseDao;
import yssoft.services.IsysobjectsService;

import java.util.HashMap;
import java.util.List;
public class sysobjectsImpl extends BaseDao implements IsysobjectsService {
         public List<HashMap> get_bywhere_sysobjects(String condition)
         {
                return this.queryForList("get_bywhere_sysobjects",condition);
         }
}