package yssoft.services;

import java.util.HashMap;
import java.util.List;

public interface ICustomerService {

	public void updateCsProduct(HashMap paramObj)throws Exception;
	
	public Object addCsProduct(HashMap paramObj)throws Exception;
	public Object addCsProducts(HashMap paramObj)throws Exception;
	public List<HashMap> getCsProductWithScRdrecord(HashMap paramObj) throws Exception;
	public List<HashMap> getCsProductWithCsn(HashMap paramObj) throws Exception;
	public List<HashMap> getCsProductbomWithIcsproductAndBomiproduct(HashMap paramObj) throws Exception;
	public List<HashMap> getCsProductbomWithIrdrecordsbom(HashMap paramObj) throws Exception;
	public List<HashMap> getCsProductbomWithIcsproduct(HashMap paramObj) throws Exception;
	
	public void delCsProductWithScRdrecord(HashMap paramObj) throws Exception;
	public void delCsProducBomtWithIrdrecordsbom(HashMap paramObj) throws Exception;
	public void delCsProductWithiid(HashMap paramObj) throws Exception;

    public void deletesc_orderapportionsByiorder(HashMap paramObj) throws Exception;
	
	
	public int updateCustproductsFquantity(HashMap paramObj)throws Exception;
	public int updateCustperson(HashMap paramObj)throws Exception;
	public int updateCsProductFsum(HashMap paramObj)throws Exception;
	public int updateCustomer(HashMap paramObj)throws Exception;
	
	public List<HashMap> getCustMainPerson(int icustomer) throws Exception;
	public List<HashMap> getFunnelDate(HashMap paramObj) throws Exception;
	public List<HashMap> getJieduan(HashMap paramObj) throws Exception;
    public List<HashMap> getWorkdiaryDate(HashMap paramObj) throws Exception;

	public void updateOpportunity(HashMap h);
	public void updateOpportunityIstatusAndIphase(HashMap paramObj)throws Exception;
	public void updateOrderSaveUpdateOpportunity(HashMap paramObj)throws Exception;
	
	public boolean isOpportunityIphaseLast(HashMap paramObj) throws Exception;
	
	public boolean checkCsnIn(HashMap paramObj) throws Exception;
	public boolean checkCsnUse(HashMap paramObj) throws Exception;
	
	public Object addAbinvoiceprocess(HashMap paramObj)throws Exception;
    public Object addsc_orderapportions(HashMap paramObj)throws Exception;

    public HashMap checkIsSelf(HashMap paramObj) throws Exception;
    
    public String checkStock(HashMap param);
}
