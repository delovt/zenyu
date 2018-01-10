package yssoft.views;
/**
 * 
 * 项目名称：
 * 类名称：sc_contractView
 * 类描述：sc_contractView视图 
 * 创建人：刘磊
 * 创建时间：2011-10-4 9:24:16
 * 修改人：刘磊
 * 修改时间：2011-10-4 9:24:16
 * 修改备注：无
 * @version 1.0
 * 
 */

import yssoft.services.Isc_contractService;

import java.util.HashMap;
import java.util.List;
public class sc_contractView {
	private Isc_contractService i_sc_contractService;
	public void seti_sc_contractService(Isc_contractService i_sc_contractService) {
		this.i_sc_contractService = i_sc_contractService;
	}
         public List<HashMap> get_bywhere_sc_contract(String condition)
         {
               try
       		   {
        		   return this.i_sc_contractService.get_bywhere_sc_contract(condition);
		       }
		       catch(Exception e)
		       {
		           return null;
		       }         
         }
         public String add_sc_contract(HashMap vo_sc_contract)
         {
               String result = "sucess";
               try
       		   {
        		  Object resultObj = this.i_sc_contractService.add_sc_contract(vo_sc_contract);
        		  result = resultObj.toString();
		       }
		       catch(Exception e)
		       {
		          result = "fail";
		       }         
		       return result;
         }
         public String update_sc_contract(HashMap vo_sc_contract)
         {
               String result = "sucess";
               try
       		   {
        		   int count = this.i_sc_contractService.update_sc_contract(vo_sc_contract);
        		   if(count!=1)
			       {
				       result = "fail";
                   }
		       }
		       catch(Exception e)
		       {
		           result = "fail";
		       }
		       return result;
         }
         public String delete_bywhere_sc_contract(String condition)
         {
               String result = "sucess";
               try
       		   {
        		   int count = this.i_sc_contractService.delete_bywhere_sc_contract(condition);
        		   if(count!=1)
			       {
				       result = "fail";
                   }
		       }
		       catch(Exception e)
		       {
		           result = "fail";
		       }
		       return result;
         }
      	// -------------------------------------------------主子表上下分隔-------------------------------------------------//
         public List<HashMap> get_bywhere_sc_contracts(String condition)
         {
               try
       		   {
        		   return this.i_sc_contractService.get_bywhere_sc_contracts(condition);
		       }
		       catch(Exception e)
		       {
		           return null;
		       }         
         }
         public String add_sc_contracts(HashMap vo_sc_contracts)
         {
               String result = "sucess";
               try
       		   {
        		  Object resultObj = this.i_sc_contractService.add_sc_contracts(vo_sc_contracts);
        		  result = resultObj.toString();
		       }
		       catch(Exception e)
		       {
		          result = "fail";
		       }         
		       return result;
         }
         public String update_sc_contracts(HashMap vo_sc_contracts)
         {
               String result = "sucess";
               try
       		   {
        		   int count = this.i_sc_contractService.update_sc_contracts(vo_sc_contracts);
        		   if(count!=1)
			       {
				       result = "fail";
                   }
		       }
		       catch(Exception e)
		       {
		           result = "fail";
		       }
		       return result;
         }
         public String delete_bywhere_sc_contracts(String condition)
         {
               String result = "sucess";
               try
       		   {
        		   int count = this.i_sc_contractService.delete_bywhere_sc_contracts(condition);
        		   if(count!=1)
			       {
				       result = "fail";
                   }
		       }
		       catch(Exception e)
		       {
		           result = "fail";
		       }
		       return result;
         }
         public List<HashMap> get_bywhere_sc_ctrarticle(String condition)
         {
               try
       		   {
        		   return this.i_sc_contractService.get_bywhere_sc_ctrarticle(condition);
		       }
		       catch(Exception e)
		       {
		           return null;
		       }         
         }
         public String add_sc_ctrarticle(HashMap vo_sc_ctrarticle)
         {
               String result = "sucess";
               try
       		   {
        		  Object resultObj = this.i_sc_contractService.add_sc_ctrarticle(vo_sc_ctrarticle);
        		  result = resultObj.toString();
		       }
		       catch(Exception e)
		       {
		          result = "fail";
		       }         
		       return result;
         }
         public String update_sc_ctrarticle(HashMap vo_sc_ctrarticle)
         {
               String result = "sucess";
               try
       		   {
        		   int count = this.i_sc_contractService.update_sc_ctrarticle(vo_sc_ctrarticle);
        		   if(count!=1)
			       {
				       result = "fail";
                   }
		       }
		       catch(Exception e)
		       {
		           result = "fail";
		       }
		       return result;
         }
         public String delete_bywhere_sc_ctrarticle(String condition)
         {
               String result = "sucess";
               try
       		   {
        		   int count = this.i_sc_contractService.delete_bywhere_sc_ctrarticle(condition);
        		   if(count!=1)
			       {
				       result = "fail";
                   }
		       }
		       catch(Exception e)
		       {
		           result = "fail";
		       }
		       return result;
         }
         
         public Boolean check_cusnb_notnull(int iid)
         {
        	   try
       		   {
        		   return this.i_sc_contractService.check_cusnb_notnull(iid);
		       }
		       catch(Exception e)
		       {
                   return false;
		       }
         }
         public Boolean check_pernb_notnull(int iid)
         {
        	   try
       		   {
        		   return this.i_sc_contractService.check_pernb_notnull(iid);
		       }
		       catch(Exception e)
		       {
                   return false;
		       }
         }
         public Boolean check_xsqynb_notnull(int iid)
         {
        	   try
       		   {
        		   return this.i_sc_contractService.check_xsqynb_notnull(iid);
		       }
		       catch(Exception e)
		       {
                   return false;
		       }
         }
         public Boolean check_hylxnb_notnull(int iid)
         {
        	   try
       		   {
        		   return this.i_sc_contractService.check_hylxnb_notnull(iid);
		       }
		       catch(Exception e)
		       {
                   return false;
		       }
         }
         public Boolean check_cplbnb_notnull(int iid)
         {
        	   try
       		   {
        		   return this.i_sc_contractService.check_cplbnb_notnull(iid);
		       }
		       catch(Exception e)
		       {
                   return false;
		       }
         }
         
         public String checkall(HashMap obj)
         {
        	 int icustomer=Integer.valueOf(obj.get("icustomer").toString());
        	 if (!this.check_cusnb_notnull(icustomer))
        	 {
        		return "请先在客商档案中维护订货单位的外部系统内码。"; 
        	 }
        	 int icorp=Integer.valueOf(obj.get("icorp").toString());
        	 if (!this.check_cusnb_notnull(icorp))
        	 {
        		return "请先在客商档案中维护签订单位的外部系统内码。"; 
        	 }
        	 int imaker=Integer.valueOf(obj.get("imaker").toString());
        	 if (!this.check_pernb_notnull(imaker))
        	 {
        		return "请先在人员档案中维护制单人的外部系统内码。"; 
        	 }
        	 int iperson=Integer.valueOf(obj.get("iperson").toString());
        	 if (!this.check_pernb_notnull(iperson))
        	 {
        		return "请先在人员档案中维护销售人员的外部系统内码。"; 
        	 }
        	 int isalegap=Integer.valueOf(obj.get("isalegap").toString());
        	 if (!this.check_xsqynb_notnull(isalegap))
        	 {
        		return "请先在基础档案中维护销售区域的外部系统内码。"; 
        	 }
        	 int icalling=Integer.valueOf(obj.get("icalling").toString());
        	 if (!this.check_hylxnb_notnull(icalling))
        	 {
        		return "请先在基础档案中维护行业类型的外部系统内码。"; 
        	 }
        	 int iinvclass=Integer.valueOf(obj.get("iinvclass").toString());
        	 if (!this.check_cplbnb_notnull(iinvclass))
        	 {
        		return "请先在基础档案中维护产品类别的外部系统内码。"; 
        	 }
       	 return "";
         }
}