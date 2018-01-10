package yssoft.views;

import yssoft.services.ICalculateMaterielService;
import yssoft.utils.ToXMLUtil;
import yssoft.vos.ScProduct;

import java.util.HashMap;
import java.util.List;


/**
 * 	计量分组类
 * @author sdy
 *
 */
public class CalculateMaterielView {
	
	private ICalculateMaterielService iCalculateMaterielService;

	public void setiCalculateMaterielService(ICalculateMaterielService iCalculateMaterielService) {
		this.iCalculateMaterielService = iCalculateMaterielService;
	}
	
	
	public String getScUnitClassList(){
		String result = ToXMLUtil.createTree( iCalculateMaterielService.getSc_UnitclassList(null), "iid","ipid","-1");
		return result;
	}
	
	
	public List<HashMap> getScUnitList(HashMap param){
		return iCalculateMaterielService.getSc_UnitList(param);
	}
	
	//物料分组
	public String  getSc_productGroupList(){
		List list=iCalculateMaterielService.getSc_productgroup();
		if(list.size()>0)
		{
			return ToXMLUtil.createTree( list, "iid","ipid","-1");
		}
		return null;
	}
	
	//物料类别
	public String  getSc_productClassList(){
		List list=iCalculateMaterielService.getSc_productclassList();
		if(list.size()>0)
		{
			return ToXMLUtil.createTree( list, "iid","ipid","-1");
		}
		return null;
	}
	
	//获取物料档案
	public String getSc_productList(){
		String result = ToXMLUtil.createTree( iCalculateMaterielService.getSc_productList(null), "iid","ipid","-1");
		return result;
	}
	
	
	
	
	//新增
	public String addScUnit(HashMap map){
		String flag = "success";
		
		try {
			iCalculateMaterielService.add_unit(map);
		} catch (Exception e) {
			e.printStackTrace();
			flag = "fail";
		}
		return flag;
	}
	
	@SuppressWarnings("unchecked")
	public HashMap addScUnitClass(HashMap map){
		HashMap hm = new HashMap();
		String iid = "";
		String flag = "success";
		
		try {
			iid = iCalculateMaterielService.add_unitclass(map);
		} catch (Exception e) {
			e.printStackTrace();
			flag = "fail";
		}
		hm.put("iid",iid );
		hm.put("flag",flag );
		return hm;
	}
	
	@SuppressWarnings("unchecked")
	public HashMap addScProductGroup(HashMap map){
		HashMap hm = new HashMap();
		String iid = "";
		String flag = "success";
		
		try {
			iid =iCalculateMaterielService.add_Sc_productgroup(map);
		} catch (Exception e) {
			e.printStackTrace();
			flag = "fail";
		}
		hm.put("iid",iid );
		hm.put("flag",flag );
		return hm;
	}
	
	@SuppressWarnings("unchecked")
	public HashMap addScProductClass(HashMap map){
		HashMap hm = new HashMap();
		String iid = "";
		String flag = "success";
		
		try {
			iid =iCalculateMaterielService.add_Sc_productclass(map);
		} catch (Exception e) {
			e.printStackTrace();
			flag = "fail";
		}
		hm.put("iid",iid );
		hm.put("flag",flag );
		return hm;
	}
	
	public String addScProduct(ScProduct sp){
		String flag = "success";
		
		try {
			iCalculateMaterielService.add_Sc_product(sp);
		} catch (Exception e) {
			e.printStackTrace();
			flag = "fail";
		}
		return flag;
	}
	
	
	
	
	
	
	//更新
	public String updateScUnit(HashMap map){
		String flag = "success";
		
		try {
			iCalculateMaterielService.update_unit(map);
		} catch (Exception e) {
			e.printStackTrace();
			flag = "fail";
		}
		return flag;
	}
	
	public String updateScUnitClass(HashMap map){
		String flag = "success";
		
		try {
			iCalculateMaterielService.update_unitclass(map);
		} catch (Exception e) {
			e.printStackTrace();
			flag = "fail";
		}
		return flag;
	}
	
	public String updateScProductGroup(HashMap map){
		String flag = "success";
		
		try {
			iCalculateMaterielService.update_Sc_productgroup(map);
		} catch (Exception e) {
			e.printStackTrace();
			flag = "fail";
		}
		return flag;
	}
	
	public String updateScProductClass(HashMap map){
		String flag = "success";
		
		try {
			iCalculateMaterielService.update_Sc_productclass(map);
		} catch (Exception e) {
			e.printStackTrace();
			flag = "fail";
		}
		return flag;
	}
		
	public String updateScProduct(ScProduct sp){
		String flag = "success";
		try {
			iCalculateMaterielService.update_Sc_product(sp);
		} catch (Exception e) {
			e.printStackTrace();
			flag = "fail";
		}
		return flag;
	}
	
		
	
	
   //删除
	public String delScUnit(HashMap map){
		String flag = "success";
		
		try {
			iCalculateMaterielService.del_unit(map);
		} catch (Exception e) {
			e.printStackTrace();
			flag = "fail";
		}
		return flag;
	}
	
	public String delScUnitClass(HashMap map){
		String flag = "success";
		
		try {
			iCalculateMaterielService.del_unitclass(map);
		} catch (Exception e) {
			e.printStackTrace();
			flag = "fail";
		}
		return flag;
	}
	
	public String delScProductGroup(HashMap map){
		String flag = "success";
		
		try {
			iCalculateMaterielService.del_Sc_productgroup(map);
		} catch (Exception e) {
			e.printStackTrace();
			flag = "fail";
		}
		return flag;
	}
	
	public String delScProductClass(HashMap map){
		String flag = "success";
		
		try {
			iCalculateMaterielService.del_Sc_productclass(map);
		} catch (Exception e) {
			e.printStackTrace();
			flag = "fail";
		}
		return flag;
	}
	
	
	public String delScProduct(HashMap map){
		String flag = "success";
		
		try {
			iCalculateMaterielService.del_Sc_product (map);
		} catch (Exception e) {
			e.printStackTrace();
			flag = "fail";
		}
		return flag;
	}
	
}
