package yssoft.impls;
/**
 * 
 * 项目名称：
 * 类名称：as_operauthImpl
 * 类描述：as_operauthImpl实现 
 * 创建人：刘磊
 * 创建时间：2011-10-5 16:28:27
 * 修改人：刘磊
 * 修改时间：2011-10-5 16:28:27
 * 修改备注：无
 * @version 1.0
 * 
 */

import yssoft.daos.BaseDao;
import yssoft.services.Ias_operauthService;
import yssoft.vos.as_operauthVo;
import yssoft.vos.as_opersauthsVo;

import java.util.List;

public class as_operauthImpl extends BaseDao implements Ias_operauthService {

     public boolean get_exists_as_operauth(int key)
     {
            return Integer.valueOf(this.queryForObject("get_exists_as_operauth",key).toString())==1;
     }
     public as_operauthVo get_bykey_as_operauth(int key)
     {
            return (as_operauthVo)this.queryForObject("get_bykey_as_operauth",key);
     }
     public List<as_operauthVo> get_bywhere_as_operauth(String condition)
     {
            return this.queryForList("get_bywhere_as_operauth",condition);
     }
     public int add_as_operauth(as_operauthVo vo_as_operauth)
     {
            return Integer.valueOf(this.insert("add_as_operauth",vo_as_operauth).toString());
     }
     public boolean update_as_operauth(as_operauthVo vo_as_operauth)
     {
            return this.update("update_as_operauth",vo_as_operauth)>0;
     }
     public boolean delete_bykey_as_operauth(int key)
     {
            return this.delete("delete_bykey_as_operauth",key)>0;
     }
     public boolean delete_bywhere_as_operauth(String condition)
     {
            return this.delete("delete_bywhere_as_operauth",condition)>0;
     }

    @Override
    public boolean delete_bywhere_as_opersauths(String condition) throws Exception {
        return this.delete("delete_bywhere_as_opersauths",condition) > 0;
    }

    @Override
    public List<as_opersauthsVo> get_bywhere_as_opersauths(String condition) throws Exception {
        return this.queryForList("get_bywhere_as_opersauths",condition);
    }

    @Override
    public int add_as_opersauths(as_opersauthsVo opervos) throws Exception {
        return Integer.valueOf(this.insert("add_as_opersauths",opervos).toString());
    }
}