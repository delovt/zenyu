package yssoft.services;
/**
 * 
 * 项目名称： 
 * 类名称：Ias_operauthService
 * 类描述：Ias_operauthService接口 
 * 创建人：刘磊
 * 创建时间：2011-10-5 16:28:28
 * 修改人：刘磊
 * 修改时间：2011-10-5 16:28:28
 * 修改备注：无
 * @version 1.0
 * 
 */

import yssoft.vos.as_operauthVo;
import yssoft.vos.as_opersauthsVo;

import java.util.List;
public interface Ias_operauthService {
    public boolean get_exists_as_operauth(int key) throws Exception;
    public as_operauthVo get_bykey_as_operauth(int key) throws Exception;
    public List<as_operauthVo> get_bywhere_as_operauth(String condition) throws Exception;
    public int add_as_operauth(as_operauthVo vo_as_operauth) throws Exception;
    public boolean update_as_operauth(as_operauthVo vo_as_operauth) throws Exception;
    public boolean delete_bykey_as_operauth(int key) throws Exception;
    public boolean delete_bywhere_as_operauth(String condition) throws Exception;

    public boolean delete_bywhere_as_opersauths(String condition) throws Exception;
    public List<as_opersauthsVo> get_bywhere_as_opersauths(String condition) throws Exception;
    public int add_as_opersauths(as_opersauthsVo opervos) throws Exception;
}