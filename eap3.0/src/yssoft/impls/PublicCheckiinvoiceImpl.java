package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IPublicCheckiinvoiceService;

import java.util.HashMap;

public class PublicCheckiinvoiceImpl extends BaseDao implements
		IPublicCheckiinvoiceService {

	@Override
	public boolean isHave(HashMap paramObj)
			throws Exception {
		//System.out.println(paramObj.toString());
		//return this.queryForList("getDatabyiinvoiceInTable", paramObj);	
		HashMap<String,Object> hm = new HashMap<String,Object>();

		//select * from sa_opportunity where iinvoice = #iinvoice#
		String strsql = "select iid from "+paramObj.get("tablename")+" where iinvoice="+paramObj.get("iinvoice")+" and ifuncregedit="+paramObj.get("ifuncregedit");
		System.out.println(strsql);
		hm.put("sqlValue", strsql);
		if(this.queryForList("getDatabyiinvoiceInTable",hm).size()>0)
			return true;
		else return false;
					

	}

}
