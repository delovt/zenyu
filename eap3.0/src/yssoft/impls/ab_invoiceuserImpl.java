package yssoft.impls;
/**
 * 
 * 项目名称：yssoft
 * 类名称：ab_invoiceuserImpl
 * 类描述：ab_invoiceuserImpl实现 
 * 创建人：刘磊
 * 创建时间：2011-10-13 9:41:11
 * 修改人：刘磊
 * 修改时间：2011-10-13 9:41:11
 * 修改备注：无
 * @version 1.0
 * 
 */

import yssoft.daos.BaseDao;
import yssoft.services.Iab_invoiceuserService;
import yssoft.vos.HrPersonVo;

import java.util.HashMap;
import java.util.List;
public class ab_invoiceuserImpl extends BaseDao implements Iab_invoiceuserService {
         public List<HashMap> get_bywhere_ab_invoiceuser(String condition)
         {
                return this.queryForList("get_bywhere_ab_invoiceuser",condition);
         }
         public void add_ab_invoiceuser(HashMap vo_ab_invoiceuser)throws Exception,RuntimeException
         {
        	 if(!vo_ab_invoiceuser.containsKey("iperson")) 
        	 {
        		HrPersonVo hrperson=(HrPersonVo) this.getAttributeFromSession("HrPerson");
        		vo_ab_invoiceuser.put("iperson", hrperson.getIid());
        	 }
                this.insert("add_ab_invoiceuser",vo_ab_invoiceuser);
         }
         public int update_ab_invoiceuser(HashMap vo_ab_invoiceuser) throws Exception,RuntimeException
         {
                return this.update("update_ab_invoiceuser",vo_ab_invoiceuser);
         }
         public int delete_bywhere_ab_invoiceuser(String condition) throws Exception,RuntimeException
         {
                return this.delete("delete_bywhere_ab_invoiceuser",condition);
         }
		@Override
		public int isExist_invoice(HashMap param) {
			return Integer.parseInt(this.queryForObject("select_isexist_invoice",param)+"");
		}
		
		 public boolean pr_execdellinktable(HashMap param)
         {
        	 try
        	 {
          		 this.queryForList("pr_execdellinktable",param);
                 return true;
        	 }
        	 catch(Exception err)
        	 {
        		return false; 
        	 }
         }
		 
		 public boolean pr_invoiceuser_custperson(HashMap param)
         {
        	 try
        	 {
          		 this.queryForList("pr_invoiceuser_custperson",param);
                 return true;
        	 }
        	 catch(Exception err)
        	 {
        		return false; 
        	 }
         }
}