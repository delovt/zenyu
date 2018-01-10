package yssoft.services;
/**
 * 
 * 项目名称：yssoft 
 * 类名称：IfunauthService
 * 类描述：IfunauthService接口 
 * 创建人：刘磊
 * 创建时间：2011-10-14 9:41:11
 * 修改人：刘磊
 * 修改时间：2011-10-14 9:41:11
 * 修改备注：无
 * @version 1.0
 * 
 */

import java.util.HashMap;
import java.util.List;
public interface IfunauthService {
    public List<HashMap> get_funoperauth(HashMap params) throws Exception;
    public List<HashMap> get_fundataauth(HashMap params) throws Exception;
    public int get_ifuncregedit(int iid) throws Exception;
    public int get_editinvoice(HashMap params) throws Exception;
    public int get_delinvoice(HashMap params) throws Exception;
    public List<HashMap> get_sqldata(String sql) throws Exception;
    public List<HashMap> get_funoperauthPerson(HashMap params) throws Exception;
    public List<HashMap> get_fundataauths(HashMap params) throws Exception;
}