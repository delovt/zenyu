package yssoft.impls;
/**
 * 
 * 项目名称：yssoft
 * 类名称：as_dataauthImpl
 * 类描述：as_dataauthImpl实现 
 * 创建人：刘磊
 * 创建时间：2011-10-12 17:45:26
 * 修改人：刘磊
 * 修改时间：2011-10-12 17:45:26
 * 修改备注：无
 * @version 1.0
 * 
 */

import yssoft.daos.BaseDao;
import yssoft.services.Ias_dataauthService;

import java.util.HashMap;
import java.util.List;

public class as_dataauthImpl extends BaseDao implements Ias_dataauthService {
	
     public boolean add_Initdata(int irole)
     {
         try
         {
            HashMap map=new HashMap();
            map.put("irole", irole);
            this.queryForList("pr_initdataright",map);
            return true;
         }
         catch(Exception err)
         {
            return false;
         }
     }

     public boolean update_Initdata(int ifuncregedit)
     {
         try
         {
            HashMap map=new HashMap();
            map.put("ifuncregedit", ifuncregedit);
            this.queryForList("pr_initdatarightup",map);
            return true;
         }
         catch(Exception err)
         {
            return false;
         }
     }

     public List<HashMap> get_bywhere_as_dataauth(String condition)
     {
            return this.queryForList("get_bywhere_as_dataauth",condition);
     }
     public int add_as_dataauth(HashMap vo_as_dataauth)
     {
            return Integer.valueOf(this.insert("add_as_dataauth",vo_as_dataauth).toString());
     }
     public int update_as_dataauth(HashMap vo_as_dataauth) {
         return this.update("update_as_dataauth",vo_as_dataauth);
     }
     public int delete_bywhere_as_dataauth(String condition)
     {
            return this.delete("delete_bywhere_as_dataauth",condition);
     }

    @Override
    public boolean add_Initdata1(int iperson) throws Exception {
        try {
            HashMap map=new HashMap();
            map.put("iperson", iperson);
            this.queryForList("pr_initdatarights",map);
            return true;
        }
        catch(Exception err) {
            return false;
        }
    }

    @Override
    public List<HashMap> get_bywhere_as_dataauths(String condition) throws Exception {
        return this.queryForList("get_bywhere_as_dataauths",condition);
    }

    @Override
    public int update_as_dataauths(HashMap vo_as_dataauths) throws Exception {
        return this.update("update_as_dataauths",vo_as_dataauths);
    }


}