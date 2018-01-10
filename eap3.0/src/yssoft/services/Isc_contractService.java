package yssoft.services;
/**
 * 
 * 项目名称： 
 * 类名称：Isc_contractService
 * 类描述：Isc_contractService接口 
 * 创建人：刘磊
 * 创建时间：2011-10-4 9:24:14
 * 修改人：刘磊
 * 修改时间：2011-10-4 9:24:14
 * 修改备注：无
 * @version 1.0
 * 
 */

import java.util.HashMap;
import java.util.List;
public interface Isc_contractService {
         public List<HashMap> get_bywhere_sc_contract(String condition) throws Exception;
         public int add_sc_contract(HashMap vo_sc_contract) throws Exception;
         public int update_sc_contract(HashMap vo_sc_contract) throws Exception;
         public int delete_bywhere_sc_contract(String condition) throws Exception;
         public List<HashMap> get_bywhere_sc_contracts(String condition) throws Exception;
         public int add_sc_contracts(HashMap vo_sc_contracts) throws Exception;
         public int update_sc_contracts(HashMap vo_sc_contracts) throws Exception;
         public int delete_bywhere_sc_contracts(String condition) throws Exception;
         public List<HashMap> get_bywhere_sc_ctrarticle(String condition) throws Exception;
         public int add_sc_ctrarticle(HashMap vo_sc_ctrarticle) throws Exception;
         public int update_sc_ctrarticle(HashMap vo_sc_ctrarticle) throws Exception;
         public int delete_bywhere_sc_ctrarticle(String condition) throws Exception;
         public Boolean check_cusnb_notnull(int iid) throws Exception;
         public Boolean check_pernb_notnull(int iid) throws Exception;
         public Boolean check_xsqynb_notnull(int iid) throws Exception;
         public Boolean check_hylxnb_notnull(int iid) throws Exception;
         public Boolean check_cplbnb_notnull(int iid) throws Exception;
}