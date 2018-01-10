package yssoft.views;

import yssoft.services.ICustomerService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

public class CustomerView {

	private ICustomerService iCustomerService = null;

	
	//检查出库单，加密狗号情况，1、是否有入库记录  2、是否已经出库
	public ArrayList<HashMap> checkCsProductSN(ArrayList<HashMap> al)throws Exception{		
		for(HashMap h:al){
			String csn = h.get("csn").toString().trim();

			if(this.iCustomerService.checkCsnIn(h)){
				h.put("isIn", true);
				if(this.iCustomerService.checkCsnUse(h)){
					h.put("isUse", true);
				}else{
					h.put("isUse", false);
				}
			}else{
				h.put("isIn", false);
			}


		}		
		
		return al;
	}
	
	public void updateCsProduct(ArrayList<HashMap> al)throws Exception{		
		for(HashMap h:al){
			Integer icustproductInteger = (Integer) h.get("icustproduct");
			if(icustproductInteger!=null){
				int icustproduct = icustproductInteger;
				if(icustproduct!=0){
					this.iCustomerService.updateCsProduct(h);
				}	
			}				
		}		
	}
	
	public String addCsProduct(ArrayList<HashMap> al)throws Exception{		
		try {		
			if(checkAlreadyhaveCsProductOrBom(al)){
				return "alreadyhave";
			}

			for(HashMap h:al){
				List productList =  this.iCustomerService.getCsProductWithCsn(h);
				if(productList.size()==0 || "".equals(h.get("csn")+"")){//2015/04/10 SZC ADD  "".equals(h.get("csn")+""数据多了相同的客户，相同的产品，加密狗号为空，可能productList会存在值
					int icustproduct = Integer.parseInt(this.iCustomerService.addCsProduct(h).toString());
					if(h.containsKey("bomList")){
						ArrayList<HashMap> bomList = (ArrayList<HashMap>) h.get("bomList");
						for(HashMap bom:bomList){
							bom.put("icustproduct", icustproduct);
							bom.put("istate", 1);
							this.iCustomerService.addCsProducts(bom);
						}				
					}							
				}else if(productList.size()==1){
					HashMap product = (HashMap) productList.get(0);
					int icustproduct =(Integer)product.get("iid");
					if(h.containsKey("bomList")){
						ArrayList<HashMap> bomList = (ArrayList<HashMap>) h.get("bomList");
						for(HashMap bom:bomList){
							bom.put("icustproduct", icustproduct);
							bom.put("istate", 2);
							this.iCustomerService.addCsProducts(bom);
							this.iCustomerService.updateCsProductFsum(bom);
							
						}			
					}	
				}else{
					return "muchcsn";
				}									

			}			
			return "ok";			
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}		
	}
	
	public boolean checkAlreadyhaveCsProduct(HashMap h)throws Exception{		
		List list =  this.iCustomerService.getCsProductWithScRdrecord(h);
		if(list.size()>0){
			return true;
		}else {
			return false;
		}
	}
	
	public boolean checkAlreadyhaveCsProductBom(HashMap h)throws Exception{		
		List list =  this.iCustomerService.getCsProductbomWithIrdrecordsbom(h);
		if(list.size()>0){
			return true;
		}else {
			return false;
		}
	}
	
	public boolean checkAlreadyhaveCsProductOrBom(ArrayList<HashMap> al)throws Exception{		
		for(HashMap product:al){
			if(checkAlreadyhaveCsProduct(product)){
				return true;
			}
			
			if(product.containsKey("bomList")){
				ArrayList<HashMap> bomList = (ArrayList<HashMap>) product.get("bomList");
				for(HashMap rdrecordsbom :bomList){
					int irdrecordsbom = (Integer) rdrecordsbom.get("iid");
					rdrecordsbom.put("irdrecordsbom", irdrecordsbom);
					if(checkAlreadyhaveCsProductBom(rdrecordsbom)){
						return true;
					}
				}
			}
		}

		return false;		
	}
	
	public String delCsProduct(ArrayList<HashMap> al)throws Exception{		
		try {		
			if(!checkAlreadyhaveCsProductOrBom(al)){
				return "nohave";
			}
			
			ArrayList<Integer> allowDelCsProductIDList = new ArrayList();//牵扯到的资产 主键 列表。 不一定都删除，还有待验证。
			
			for(HashMap product:al){
				if(product.containsKey("bomList")){
					ArrayList<HashMap> bomList = (ArrayList<HashMap>) product.get("bomList");
					for(HashMap bom:bomList){
						int irdrecordsbom = (Integer) bom.get("iid");
						bom.put("irdrecordsbom", irdrecordsbom);
						List productbomList = this.iCustomerService.getCsProductbomWithIrdrecordsbom(bom);
						
						if(productbomList.size()==1){
							HashMap productBom = (HashMap) productbomList.get(0);
							int icustproduct = (Integer)productBom.get("icustproduct");
							allowDelCsProductIDList.add(icustproduct);	
							
							//lr 2012-08-31  测试 撤销生成资产。
							bom.put("icustproduct", icustproduct);
							this.iCustomerService.delCsProducBomtWithIrdrecordsbom(bom);
							this.iCustomerService.updateCsProductFsum(bom);
						}															
					}
				}else{
					List<HashMap> list =  this.iCustomerService.getCsProductWithScRdrecord(product);
					int icustproduct = (Integer) list.get(0).get("iid");
					allowDelCsProductIDList.add(icustproduct);
				}
			}
			
			for(int icustproduct:allowDelCsProductIDList){
				HashMap custproduct = new HashMap();
				custproduct.put("icustproduct",icustproduct);
				List list = this.iCustomerService.getCsProductbomWithIcsproduct(custproduct);
				if(list.size()==0){
					this.iCustomerService.delCsProductWithiid(custproduct);
				}
			}
			
			//this.iCustomerService.delCsProductWithScRdrecord(h);		
			return "ok";			
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}		
	}
	
	public void updateCsProductWithOrder(HashMap paramObj)throws Exception{
		ArrayList<HashMap> orders2 = (ArrayList<HashMap>) paramObj.get("sc_orders2");
		for(HashMap order2item:orders2){
			Integer icustproductInteger = (Integer) order2item.get("icustproduct");
			if(icustproductInteger!=null){
				int icustproduct = icustproductInteger;
				if(icustproduct!=0){
					HashMap h = new HashMap();
					h.put("icustproduct", icustproduct);
					
					h.put("iscstatus",paramObj.get("iscstatus"));//服务收费状态
					h.put("irefuse", paramObj.get("irefuse"));//超期未交费原因
					
					h.put("ddate", paramObj.get("ddate"));
					h.put("dsend", paramObj.get("dsend"));
					h.put("fsum", order2item.get("ffee"));
					h.put("icustperson", paramObj.get("icustperson"));
					h.put("iperson", paramObj.get("iperson"));
					h.put("iproduct", paramObj.get("iproduct"));	
					h.put("igroupservices", paramObj.get("igroupservices"));
					h.put("dgroupend", paramObj.get("dgroupend"));
					
					this.iCustomerService.updateCsProduct(h);
				}	
			}			
		}
			
	}
	
	
	public List<HashMap> getCustMainPerson(int icustomer) throws Exception {
		return this.iCustomerService.getCustMainPerson(icustomer);
	}
	
	public void updateCustMainPerson(HashMap h)throws Exception {
		this.iCustomerService.updateCustperson(h);
		this.iCustomerService.updateCustomer(h);		
	}
	
	public void updateOpportunity(HashMap h)throws Exception {
		this.iCustomerService.updateOpportunity(h);		
	}

	public void setiCustomerService(ICustomerService iCustomerService) {
		this.iCustomerService = iCustomerService;
	}

	public List<HashMap> getFunnelDate(HashMap paramObj) throws Exception {
		return this.iCustomerService.getFunnelDate(paramObj);
	}
	
	public List<HashMap> getJieduan(HashMap paramObj) throws Exception {
		return this.iCustomerService.getJieduan(paramObj);
	}

    public List<HashMap> getWorkdiaryDate(HashMap paramObj) throws Exception {
        return this.iCustomerService.getWorkdiaryDate(paramObj);
    }
	
	public void orderSaveUpdateOpportunity(HashMap paramObj) throws Exception {
		boolean isIphaseLast = this.iCustomerService.isOpportunityIphaseLast(paramObj);
		this.iCustomerService.updateOpportunityIstatusAndIphase(paramObj);	
		if(!isIphaseLast){
			this.iCustomerService.addAbinvoiceprocess(paramObj);
		}
	}
	//修改合同时，更改商机成交金额
	public void updateOrderSaveUpdateOpportunity(HashMap paramObj) throws Exception {
		this.iCustomerService.updateOpportunityIstatusAndIphase(paramObj);	
	}

    public String checkFout(List<HashMap> param) throws  Exception {
        String iproducts = "";
        List<HashMap> list = new ArrayList<HashMap>();
        for(int i=0; i<param.size(); i++) {
            HashMap hm = this.iCustomerService.checkIsSelf(param.get(i));
            if(hm != null) {
                if (!hm.get("iproduct").toString().equals(param.get(i).get("iproduct").toString()) || Float.parseFloat(hm.get("fquantity").toString()) != Float.parseFloat(param.get(i).get("fquantity").toString())) {
                    list.add(param.get(i));
                }
            }else {
                list.add(param.get(i));
            }
        }
        for (int i=0; i<list.size(); i++) {
            iproducts +=  list.get(i).get("iproduct").toString() + ",";
        }
        list.clear();
        if(iproducts.length() > 0) {
            iproducts = iproducts.substring(0, iproducts.length()-1);
        }
        return iproducts;
    }

    public Object addsc_orderapportions(HashMap hashMap)throws Exception{
        return this.iCustomerService.addsc_orderapportions(hashMap);
    }

    public String addsc_orderapportionsList(List<HashMap> list)throws Exception{
        if(list.size()>0){
            deletesc_orderapportionsByiorder(list.get(0));
        }

        for (HashMap hashMap:list){
            addsc_orderapportions(hashMap);
        }

        return "success";
    }

    public void deletesc_orderapportionsByiorder(HashMap hashMap)throws Exception{
        this.iCustomerService.deletesc_orderapportionsByiorder(hashMap);
    }

    public String checkStock(HashMap param)
    {
    	return this.iCustomerService.checkStock(param);
    }
}
