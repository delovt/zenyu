package yssoft.services;
/**
 * 
 * 项目名称：yssoft 
 * 类名称：Ias_dataauthService
 * 类描述：Ias_dataauthService接口 
 * 创建人：刘磊
 * 创建时间：2011-10-12 17:45:26
 * 修改人：刘磊
 * 修改时间：2011-10-12 17:45:26
 * 修改备注：无
 * @version 1.0
 * 
 */

import java.util.HashMap;
import java.util.List;
public interface Ias_dataauthService {
    public boolean add_Initdata(int irole) throws Exception;
    public boolean update_Initdata(int ifuncregedit) throws Exception;
    public List<HashMap> get_bywhere_as_dataauth(String condition) throws Exception;
    public int add_as_dataauth(HashMap vo_as_dataauth) throws Exception;
    public int update_as_dataauth(HashMap vo_as_dataauth) throws Exception;
    public int delete_bywhere_as_dataauth(String condition) throws Exception;
    public boolean add_Initdata1(int iperson) throws Exception;
    public List<HashMap> get_bywhere_as_dataauths(String condition) throws Exception;
    public int update_as_dataauths(HashMap vo_as_dataauths) throws Exception;
}