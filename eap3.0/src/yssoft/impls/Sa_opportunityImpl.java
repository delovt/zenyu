package yssoft.impls;
/**
 * 
 * 项目名称：yssoft
 * 类名称：Sa_opportunityImpl
 * 类描述：Sa_opportunityImpl实现 
 * 创建人：孙东亚
 * 创建时间：2011-9-22 15:13:28
 * 修改人：孙东亚
 * 修改时间：2011-9-22 15:13:28
 * 修改备注：无
 * @version 1.0
 * 
 */

import yssoft.daos.BaseDao;
import yssoft.services.ISa_opportunityService;

import java.util.HashMap;
import java.util.List;
public class Sa_opportunityImpl extends BaseDao implements ISa_opportunityService {

    @SuppressWarnings("unchecked")
	public List<HashMap> get_bywhere_Sa_opportunity(String condition){
            return this.queryForList("get_bywhere_sa_opportunity",condition);
     }
     public int add_Sa_opportunity(HashMap paramMap)
     {
    	 int iid  = 0;
         Object resultObj = Integer.valueOf(this.insert("add_sa_opportunity",paramMap).toString());
		 iid = Integer.parseInt(resultObj.toString());//主键
		return iid; 
     } 
            
     public int update_Sa_opportunity(HashMap vo_Sa_opportunity)
     {
            return this.update("update_sa_opportunity",vo_Sa_opportunity);
     }
    
     public int delete_bywhere_Sa_opportunity(String condition)
     {
            return this.delete("delete_bywhere_sa_opportunity",condition);
     }
     
     public int db_delete(String sqlName,Object obj)
     {
    	 return this.delete(sqlName,obj);
     }
     
	@Override
	public int db_update(String sqlName, Object obj) {
		return this.update(sqlName, obj);
	}
}