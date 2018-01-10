package yssoft.impls;
/**
 * 
 * 项目名称：yssoft
 * 类名称：AC_fieldsImpl
 * 类描述：AC_fieldsImpl实现 
 * 创建人：刘磊
 * 创建时间：2012-2-9 11:48:28
 * 修改人：刘磊
 * 修改时间：2012-2-9 11:48:28
 * 修改备注：无
 * @version 1.0
 * 
 */

import yssoft.daos.BaseDao;
import yssoft.services.IAC_fieldsService;

import java.util.HashMap;
import java.util.List;
public class AC_fieldsImpl extends BaseDao implements IAC_fieldsService {
         public List<HashMap> get_bywhere_AC_fields(String condition)
         {
                return this.queryForList("get_bywhere_AC_fields",condition);
         }
         public int add_AC_fields(HashMap vo_AC_fields)
         {
                return Integer.valueOf(this.insert("add_AC_fields",vo_AC_fields).toString());
         }
         public int update_AC_fields(HashMap vo_AC_fields)
         {
                return this.update("update_AC_fields",vo_AC_fields);
         }
         public int delete_bywhere_AC_fields(String condition)
         {
                return this.delete("delete_bywhere_AC_fields",condition);
         }
		@Override
		public void executeSqlList(HashMap param) throws Exception {
			// TODO Auto-generated method stub
			this.update("DatadictionaryDest.updateDataList", param);
		}
}