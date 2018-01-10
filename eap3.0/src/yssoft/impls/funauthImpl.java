package yssoft.impls;
/**
 * 
 * 项目名称：yssoft
 * 类名称：funauthImpl
 * 类描述：funauthImpl实现 
 * 创建人：刘磊
 * 创建时间：2011-10-13 9:41:11
 * 修改人：刘磊
 * 修改时间：2011-10-13 9:41:11
 * 修改备注：无
 * @version 1.0
 * 
 */

import yssoft.daos.BaseDao;
import yssoft.services.IfunauthService;

import java.util.HashMap;
import java.util.List;
public class funauthImpl extends BaseDao implements IfunauthService {

	public List<HashMap> get_funoperauth(HashMap params) throws Exception {
		return this.queryForList("get_funoperauth",params);
	}

	public List<HashMap> get_fundataauth(HashMap params) throws Exception {
		return this.queryForList("get_fundataauth",params);
	}
	
	public int get_ifuncregedit(int iid)
	{
		return Integer.valueOf(this.queryForObject("get_ifuncregedit",iid).toString());
	}
	
	public int get_editinvoice(HashMap params)
	{
		return Integer.valueOf(this.queryForObject("get_editinvoice",params).toString());
	}
	
	public int get_delinvoice(HashMap params)
	{
		return Integer.valueOf(this.queryForObject("get_delinvoice",params).toString());
	}
	
	public List<HashMap> get_sqldata(String sql) throws Exception {
		return this.queryForList("get_sqldata",sql);
	}

    @Override
    public List<HashMap> get_funoperauthPerson(HashMap params) throws Exception {
        return this.queryForList("get_funoperauthPerson",params);
    }

    @Override
    public List<HashMap> get_fundataauths(HashMap params) throws Exception {
        return this.queryForList("get_fundataauths",params);
    }
}