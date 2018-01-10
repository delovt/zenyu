package yssoft.impls;

import yssoft.daos.BaseDao;

import java.util.HashMap;
import java.util.List;

@SuppressWarnings("serial")
public class ProductBomsImpl extends BaseDao{

	public ProductBomsImpl(){}
	
	@SuppressWarnings("unchecked")
	public List onGetBomsList(int iproduct){
		
		HashMap phm = new HashMap();
		String strsql 	= "";
		List list = null;
		
		
		try{
			
			strsql = "select sc_product.iid iproduct,sc_product.cname pname,sc_boms.iid,sc_boms.fquantity,sc_boms.ipricetype,"
					+"sc_productbom.cname bomsname,(sc_product.cname+'-'+sc_productbom.cname) linkpname from (select iproduct,iid from sc_bom union select iproduct,ibom as iid from sc_bomp) sc_bom "
					+"left join (select iid,ibom,iproduct,fquantity,ipricetype,iifuncregedit from sc_boms) sc_boms on sc_bom.iid=sc_boms.ibom "
					+"left join (select iid,ccode,cname from sc_product) sc_product on sc_bom.iproduct=sc_product.iid "
					+"left join (select iid,ccode,cname from sc_product) sc_productbom on sc_boms.iproduct=sc_productbom.iid where sc_product.iid="+iproduct;
			
			phm.put("sqlValue", strsql);
			list = this.queryForList("ProductBomsDest.Search", phm);
			
			
		}catch(Exception ex){
			ex.printStackTrace();
		}
		
		return list;
		
	}
	
}
