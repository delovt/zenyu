package yssoft.services;

import yssoft.vos.ScProduct;

import java.util.HashMap;
import java.util.List;

public  interface  ICalculateMaterielService {
	
	/**
	 * 获取计数单位组
	 * @param map
	 * @return
	 */
	public  List<HashMap> getSc_UnitclassList ( HashMap<String,Object> map);
	
	/**
	 * 获取计数单位
	 * @param map
	 * @return
	 */
	public  List<HashMap> getSc_UnitList ( HashMap<String,Object> map);
	
	public void add_unit (HashMap map);
	
	public String add_unitclass (HashMap map);
	
	public void update_unit(HashMap map);
	
	public void update_unitclass(HashMap map);
	
	public void del_unit(HashMap map);
	
	public void del_unitclass(HashMap map);
	
	
	
	/**
	 * 获取物料分类组
	 * @param map
	 * @return
	 */
	public  List<HashMap> getSc_productclassList ();
	
	/**
	 * 获取物料分类
	 * @param map
	 * @return
	 */
	public  List<HashMap> getSc_productgroup ();
	
	public String add_Sc_productclass (HashMap map);
	
	public String add_Sc_productgroup (HashMap map);
	
	public void update_Sc_productclass(HashMap map);
	
	public void update_Sc_productgroup(HashMap map);
	
	public void del_Sc_productclass(HashMap map);
	
	public void del_Sc_productgroup(HashMap map);
	
	
	/**
	 * 获取存货档案列表
	 * @param map
	 * @return
	 */
	public  List<HashMap> getSc_productList ( HashMap<String,Object> map);
	
	public void add_Sc_product (ScProduct sp);
	
	public void update_Sc_product(ScProduct sp);
	
	public void del_Sc_product(HashMap map);
	
	
	
}
