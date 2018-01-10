package yssoft.impls;
/**
 * 
 * 项目名称：
 * 类名称：sc_contractImpl
 * 类描述：sc_contractImpl实现 
 * 创建人：刘磊
 * 创建时间：2011-10-4 9:24:13
 * 修改人：刘磊
 * 修改时间：2011-10-4 9:24:13
 * 修改备注：无
 * @version 1.0
 * 
 */

import yssoft.daos.BaseDao;
import yssoft.services.Isc_contractService;

import java.util.HashMap;
import java.util.List;
public class sc_contractImpl extends BaseDao implements Isc_contractService {
         public List<HashMap> get_bywhere_sc_contract(String condition)
         {
                return this.queryForList("get_bywhere_sc_contract",condition);
         }
         public int add_sc_contract(HashMap vo_sc_contract)
         {
        		int iid = Integer.valueOf(this.insert("add_sc_contract",vo_sc_contract).toString());//主键
        		
        		//子表操作
        		new ChildrenDataHandle().ChildData(vo_sc_contract, iid);
        		
        		return iid;
         }
         public int update_sc_contract(HashMap vo_sc_contract)
         {
    		int iid = this.update("update_sc_contract",vo_sc_contract);
    		
    		//子表操作
    		new ChildrenDataHandle().ChildData(vo_sc_contract, iid);
    		
    		return iid;
    		
         }
         public int delete_bywhere_sc_contract(String condition)
         {
                return this.delete("delete_bywhere_sc_contract",condition);
         }
         public List<HashMap> get_bywhere_sc_contracts(String condition)
         {
                return this.queryForList("get_bywhere_sc_contracts",condition);
         }
         public int add_sc_contracts(HashMap vo_sc_contracts)
         {
                return Integer.valueOf(this.insert("add_sc_contracts",vo_sc_contracts).toString());
         }
         public int update_sc_contracts(HashMap vo_sc_contracts)
         {
                return this.update("update_sc_contracts",vo_sc_contracts);
         }
         public int delete_bywhere_sc_contracts(String condition)
         {
                return this.delete("delete_bywhere_sc_contracts",condition);
         }
         public List<HashMap> get_bywhere_sc_ctrarticle(String condition)
         {
                return this.queryForList("get_bywhere_sc_ctrarticle",condition);
         }
         public int add_sc_ctrarticle(HashMap vo_sc_ctrarticle)
         {
                return Integer.valueOf(this.insert("add_sc_ctrarticle",vo_sc_ctrarticle).toString());
         }
         public int update_sc_ctrarticle(HashMap vo_sc_ctrarticle)
         {
                return this.update("update_sc_ctrarticle",vo_sc_ctrarticle);
         }
         public int delete_bywhere_sc_ctrarticle(String condition)
         {
                return this.delete("delete_bywhere_sc_ctrarticle",condition);
         }
         
         public Boolean check_cusnb_notnull(int iid)
         {
                return !this.queryForObject("check_cusnb_notnull",iid).toString().equals("");
         }
         public Boolean check_pernb_notnull(int iid)
         {
                return !this.queryForObject("check_pernb_notnull",iid).toString().equals("");
         }
         public Boolean check_xsqynb_notnull(int iid)
         {
                return !this.queryForObject("check_xsqynb_notnull",iid).toString().equals("");
         }
         public Boolean check_hylxnb_notnull(int iid)
         {
                return !this.queryForObject("check_hylxnb_notnull",iid).toString().equals("");
         }
         public Boolean check_cplbnb_notnull(int iid)
         {
                return !this.queryForObject("check_cplbnb_notnull",iid).toString().equals("");
         }
}