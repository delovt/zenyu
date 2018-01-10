package yssoft.views;

import flex.messaging.io.ArrayList;
import yssoft.services.IChecksalesService;

import java.util.HashMap;
import java.util.List;

public class CheckSalesView {
	private IChecksalesService iChecksalesService = null;

	public List<HashMap> getOrderAndPlanInfoByIcustomer(int icustomer) throws Exception {
		return  this.iChecksalesService.getOrderAndPlanInfoByIcustomer(icustomer);
	}
	
	public List checkSalesSubmit(HashMap h) throws Exception{
		int irpinvoice = (Integer) h.get("irpinvoice");
		List<HashMap> list = (List<HashMap>) h.get("ac");
		ArrayList arraylist = new ArrayList();
		for(HashMap hash:list)
		{
			//插入新核销明细
			HashMap insertHashMap = new HashMap();
			insertHashMap.put("ictrpplan", hash.get("op_iid"));
			insertHashMap.put("iorder", hash.get("o_iid"));
			insertHashMap.put("irpinvoice", hash.get("irpinvoice"));
			insertHashMap.put("fclosemoney", hash.get("thisfclosemoney"));
			insertHashMap.put("imaker", hash.get("imaker"));
			insertHashMap.put("dmaker", hash.get("dmaker"));
			insertHashMap.put("iifuncregedit", hash.get("iifuncregedit"));
			Object o = this.iChecksalesService.insert_Sc_ctrpclose(insertHashMap);
            int ictrpclose = Integer.parseInt(o.toString());
			arraylist.add(ictrpclose);

            List<HashMap> orderApportionList= (List<HashMap>) hash.get("orderApportionList");
            for(HashMap item:orderApportionList){
                HashMap a = new HashMap();
                a.put("iorder",hash.get("o_iid"));
                a.put("ictrpclose",ictrpclose);
                a.put("idepartment",item.get("idepartment"));
                a.put("iperson",item.get("iperson"));
                a.put("crole",item.get("crole"));
                a.put("cdetail",item.get("cdetail"));

                float fpercent = Float.parseFloat(item.get("fpercent").toString());
                float fclosemoney = Float.parseFloat(hash.get("thisfclosemoney").toString());
                a.put("ddate",h.get("ddate"));
                a.put("fpercent",fpercent);
                a.put("fmoney",fpercent*fclosemoney);
                a.put("imaker",hash.get("imaker"));
                a.put("dmaker",hash.get("dmaker"));

                this.iChecksalesService.insert_sc_orderapportions(a);
            }
			
			//更新收款计划
			HashMap updateHashMap = new HashMap();
			updateHashMap.put("iid", hash.get("op_iid"));
			updateHashMap.put("fclosemoney", hash.get("thisfclosemoney"));			
			this.iChecksalesService.update_Sc_orderrpplan(updateHashMap);		
			
			//更新合同
			HashMap updateOrderMap = new HashMap();
			updateOrderMap.put("iorder", hash.get("o_iid"));
			this.iChecksalesService.update_Sc_order(updateOrderMap);
			
		}
		
		for(HashMap hash:list)
		{			
			//更新合同
			HashMap updateOrderMap = new HashMap();
			updateOrderMap.put("iorder", hash.get("o_iid"));
			this.iChecksalesService.update_Sc_order(updateOrderMap);
			
		}
		
		//更新回款单
		HashMap updateRpinvoiceMap = new HashMap();
		updateRpinvoiceMap.put("irpinvoice", irpinvoice);
		this.iChecksalesService.update_sc_rpinvoice(updateRpinvoiceMap);
		
		
		
		//返回插入的核销记录
		return arraylist;
	}
	
	public void reCheckSalesSubmit(HashMap h) throws Exception{
		int irpinvoice = (Integer) h.get("irpinvoice");
		List<HashMap> list = (List<HashMap>) h.get("needRe");
		for(HashMap hash:list)
		{
			int iid = Integer.parseInt(hash.get("iid")+"");
			this.iChecksalesService.delete_Sc_ctrpcloseByiid(iid);
            this.iChecksalesService.delete_sc_orderapportionsByictrpclose(iid);
			
			HashMap updateHashMap = new HashMap();
			updateHashMap.put("iid", hash.get("ictrpplan"));
			updateHashMap.put("fclosemoney", "-"+hash.get("fclosemoney"));
			
			this.iChecksalesService.update_Sc_orderrpplan(updateHashMap);
		}
		
		for(HashMap hash:list)
		{			
			//更新合同
			HashMap updateOrderMap = new HashMap();
			updateOrderMap.put("iorder", hash.get("iorder"));
			this.iChecksalesService.update_Sc_order(updateOrderMap);
			
		}
		
		//更新回款单
		HashMap updateRpinvoiceMap = new HashMap();
		updateRpinvoiceMap.put("irpinvoice", irpinvoice);
		this.iChecksalesService.update_sc_rpinvoice(updateRpinvoiceMap);
	}
	
	public void setiChecksalesService(IChecksalesService iChecksalesService) {
		this.iChecksalesService = iChecksalesService;
	}
}
