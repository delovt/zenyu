package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.vos.ScProduct;

import java.util.HashMap;
import java.util.List;

public class CalculateMaterielService extends BaseDao implements yssoft.services.ICalculateMaterielService {
	
	/**
	 * 计量单位i实现method
	 */
	@Override
	public List<HashMap> getSc_UnitclassList(HashMap map) {
		List<HashMap> list = super.queryForList("sc_unitclass_select",map);
		return list;
	}

	@Override
	public List<HashMap> getSc_UnitList(HashMap map) {
		List<HashMap> list =  super.queryForList("sc_unit_select", map);
		return	 list;
	}
	
	@Override
	public void add_unit(HashMap map) {
		 super.insert("sc_unit_add",map);
	}

	@Override
	public String add_unitclass(HashMap map) {
		return  super.insert("sc_unitclass_add", map).toString();
	}
	
	@Override
	public void del_unit(HashMap map) {
		String condition =  " and iid in ( "+map.get("iid").toString()+" ) "; 
		super.delete("sc_unit_del", condition);
	}

	@Override
	public void del_unitclass(HashMap map) {
		 super.delete("sc_unitclass_del", map);
	}
	
	@Override
	public void update_unit(HashMap map) {
		 super.update("sc_unit_update", map)	;
	}

	@Override
	public void update_unitclass(HashMap map) {
		 super.update("sc_unitclass_update", map)	;
	}
	
	
	
	/**
	 *  物料分类实现method
	 */
	@Override
	public String add_Sc_productclass(HashMap map) {
		return  super.insert("sc_productclass_add", map)	.toString();
	}

	@Override
	public String add_Sc_productgroup(HashMap map) {
		return super.insert("sc_productgroup_add", map).toString()	;
	}

	@Override
	public void del_Sc_productclass(HashMap map) {
		 super.delete("sc_productclass_del", map);
	}

	@Override
	public void del_Sc_productgroup(HashMap map) {
		 super.delete("sc_productgroup_del", map);
	}

	@Override
	public List<HashMap> getSc_productclassList() {
		return super.queryForList("sc_productclass_select");
	}

	@Override
	public List<HashMap> getSc_productgroup() {
		return super.queryForList("sc_productgroup_select");
	}

	@Override
	public void update_Sc_productclass(HashMap map) {
		super.update("sc_productclass_update", map);
	}

	@Override
	public void update_Sc_productgroup(HashMap map) {
		super.update("sc_productgroup_update", map);
	}

	@Override
	public List<HashMap> getSc_productList(HashMap<String, Object> map) {
		return super.queryForList("sc_product_select",map);
	}

	@Override
	public void add_Sc_product(ScProduct sp) {
		super.insert("sc_product_add",sp);
	}

	@Override
	public void del_Sc_product(HashMap map) {
		String condition =  " and iid in ( "+map.get("iid").toString()+" ) "; 
		super.delete("sc_product_del", condition);
	}

	@Override
	public void update_Sc_product(ScProduct sp) {
		super.update("sc_product_update",sp);
	}

	
}
