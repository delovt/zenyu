package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.ICustomerService;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

public class CustomerImpl extends BaseDao implements ICustomerService {

    public void updateCsProduct(HashMap paramObj) throws Exception {
        if (paramObj.containsKey("fsum") && paramObj.containsKey("irefuse")) {//服务费合同更新
            String ddate=this.queryForObject("queryDate",paramObj).toString();
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
            Date date = sdf.parse(ddate);
            Date dsend=sdf.parse(paramObj.get("dsend").toString());
            boolean flag = dsend.before(date);
            if(flag==true){
                this.update("updateCsProductWithOrderNoDate", paramObj);
            }
            else{
                this.update("updateCsProductWithOrder", paramObj);
            }

        } else if (paramObj.containsKey("iorder")) {//升级合同更新
            this.update("updateCsproductIcontract", paramObj);
        }
    }

    @Override
    public List<HashMap> getCustMainPerson(int icustomer) throws Exception {
        return this.queryForList("getCustMainPerson", icustomer);
    }

    @Override
    public int updateCustperson(HashMap paramObj) throws Exception {
        return this.update("updateCustperson", paramObj);
    }

    @Override
    public int updateCustomer(HashMap paramObj) throws Exception {
        return this.update("updateCustomer", paramObj);
    }

    @Override
    public int updateCustproductsFquantity(HashMap paramObj) throws Exception {
        return this.update("updateCustproductsFquantity", paramObj);
    }

    @Override
    public int updateCsProductFsum(HashMap paramObj) throws Exception {
        if (paramObj.containsKey("istate"))
            return this.update("addCsProductFsum", paramObj);
        else
            return this.update("minusCsProductFsum", paramObj);
    }

    @Override
    public Object addCsProduct(HashMap paramObj) throws Exception {
        Object iidObj = this.insert("addCsProduct", paramObj);
        int iid = Integer.parseInt(iidObj.toString());

        HashMap invocieuser = new HashMap();
        invocieuser.put("iinvoice", iid);
        invocieuser.put("ifuncregedit", 216);
        invocieuser.put("irole", 1);
        int imaker = Integer.parseInt(paramObj.get("imaker").toString());
        invocieuser.put("iperson", imaker);
        this.insert("add_ab_invoiceuser", invocieuser);

        return iidObj;
    }

    @Override
    public Object addCsProducts(HashMap paramObj) throws Exception {
        return this.insert("addCsProducts", paramObj);
    }

    @Override
    public List<HashMap> getCsProductWithScRdrecord(HashMap paramObj)
            throws Exception {
        return this.queryForList("getCsProductWithScRdrecord", paramObj);
    }

    @Override
    public List<HashMap> getCsProductWithCsn(HashMap paramObj)
            throws Exception {
        return this.queryForList("getCsProductWithCsn", paramObj);
    }

    @Override
    public List<HashMap> getCsProductbomWithIcsproductAndBomiproduct(HashMap paramObj)
            throws Exception {
        return this.queryForList("getCsProductbomWithIcsproductAndBomiproduct", paramObj);
    }

    @Override
    public List<HashMap> getCsProductbomWithIrdrecordsbom(HashMap paramObj)
            throws Exception {
        return this.queryForList("getCsProductbomWithIrdrecordsbom", paramObj);
    }

    @Override
    public List<HashMap> getCsProductbomWithIcsproduct(HashMap paramObj)
            throws Exception {
        return this.queryForList("getCsProductbomWithIcsproduct", paramObj);
    }

    @Override
    public List<HashMap> getFunnelDate(HashMap paramObj)
            throws Exception {
        return this.queryForList("getFunnelDate", paramObj);
    }

    @Override
    public List<HashMap> getJieduan(HashMap paramObj)
            throws Exception {
        return this.queryForList("getJieduan", paramObj);
    }
    @Override
    public List<HashMap> getWorkdiaryDate(HashMap paramObj) { return this.queryForList("getWorkdiaryDate", paramObj);}

    @Override
    public void delCsProductWithScRdrecord(HashMap paramObj) throws Exception {
        this.delete("delCsProductWithScRdrecord", paramObj);
    }

    @Override
    public void delCsProducBomtWithIrdrecordsbom(HashMap paramObj) throws Exception {
        this.delete("delCsProducBomtWithIrdrecordsbom", paramObj);
    }

    @Override
    public void delCsProductWithiid(HashMap paramObj) throws Exception {
        this.delete("delCsProductWithiid", paramObj);
    }

    @Override
    public void deletesc_orderapportionsByiorder(HashMap paramObj) throws Exception {
        this.delete("deletesc_orderapportionsByiorder", paramObj);
    }


    @Override
    public void updateOpportunity(HashMap h) {
        this.update("updateOpportunity", h);
    }

    public void updateOpportunityIstatusAndIphase(HashMap paramObj) throws Exception {
        this.update("updateOpportunityIstatusAndIphase", paramObj);
    }

    public void updateOrderSaveUpdateOpportunity(HashMap paramObj) throws Exception {
        this.update("updateOrderSaveUpdateOpportunity", paramObj);
    }
    
    public boolean isOpportunityIphaseLast(HashMap paramObj) throws Exception {
        List<HashMap> list = this.queryForList("getOpportunityIphase", paramObj);
        List<HashMap> list2 = this.queryForList("getLastIphase", paramObj);
        if (list.size() > 0 && list2.size() > 0) {
            String iphase = list.get(0).get("iphase").toString();
            String iid = list2.get(0).get("iid").toString();
            if (iphase.equals(iid))
                return true;
        }
        return false;
    }

    public Object addAbinvoiceprocess(HashMap paramObj) throws Exception {
        Object iidObj = this.insert("addAbinvoiceprocess", paramObj);
        int iid = Integer.parseInt(iidObj.toString());

        HashMap invocieuser = new HashMap();
        invocieuser.put("iinvoice", iid);
        invocieuser.put("ifuncregedit", 258);
        invocieuser.put("irole", 1);
        int imaker = Integer.parseInt(paramObj.get("imaker").toString());
        invocieuser.put("iperson", imaker);
        this.insert("add_ab_invoiceuser", invocieuser);

        return iidObj;
    }

    public Object addsc_orderapportions(HashMap paramObj) throws Exception {
        Object iidObj = this.insert("addsc_orderapportions", paramObj);
        return iidObj;
    }

    @Override
    public boolean checkCsnIn(HashMap paramObj) throws Exception {
        List l = this.queryForList("checkCsnIn", paramObj);
        if (l.size() > 0)
            return true;
        else
            return false;
    }

    @Override
    public boolean checkCsnUse(HashMap paramObj) throws Exception {
        List l = this.queryForList("checkCsnUse", paramObj);
        if (l.size() > 0)
            return true;
        else
            return false;
    }

    @Override
    public HashMap checkIsSelf(HashMap paramObj) throws Exception {
        List<HashMap> list = null;
        if (paramObj.get("iid") != null) {
            list = this.queryForList("checkIsSelf", paramObj);
            return list.get(0);
        } else {
            return null;
        }
    }

    /**
     * 用来检查库存量
     *
     * @param param 页面参数
     * @return 是否能出库
     */
    public String checkStock(HashMap param) {
        //先判断是否支持零库存出库
        String cvalue = this.queryForObject("queryCvalue").toString();
        //不支持零库存出库
        if (cvalue.equals("0")) {
            //再判断一下是否是新增
            List arrRdrecords = (List) param.get("sc_rdrecords");

            if (arrRdrecords == null || arrRdrecords.size() == 0) {
                return "请选择产品，再进行出库";
            }

            int iid = Integer.valueOf(param.get("iid").toString()).intValue();
            List oldarrRdrecords = null;
            //如果编码不为0，说明是再次进行修改
            if (iid > 0) {
                //查询原始记录，进行对比。
                oldarrRdrecords = this.queryForList("checkIsSelf", iid);
            }

            List newProductList = new ArrayList();

            //重新封装产品
            for (int i = 0; i < arrRdrecords.size(); i++) {
                HashMap drecordsMap = (HashMap) arrRdrecords.get(i);
                //判断是否是重复记录
                int count = 0;
                if (null == drecordsMap.get("iproduct") || drecordsMap.get("iproduct").toString().equals("")) {
                    return "请选择产品后，在进行出库！";
                }
                if (null == drecordsMap.get("fquantity") || drecordsMap.get("fquantity").toString().equals("")) {
                    return "请输入数量，在进行出库！";
                }
                //找到产品
                int iproduct = Integer.valueOf(drecordsMap.get("iproduct").toString()).intValue();
                float fquantity = Float.valueOf(drecordsMap.get("fquantity").toString()).floatValue();
                HashMap newProduct = new HashMap();
                newProduct.put("iproduct", iproduct);
                newProduct.put("iproductName", drecordsMap.get("iproduct_Name").toString());
                newProduct.put("fquantity", fquantity);
                //跟原始记录进行比较。
                if (null != oldarrRdrecords) {
                    for (int j = 0; j < oldarrRdrecords.size(); j++) {
                        HashMap olddrecordsMap = (HashMap) oldarrRdrecords.get(j);
                        int oldiproduct = Integer.valueOf(olddrecordsMap.get("iproduct").toString()).intValue();
                        if (oldiproduct == iproduct) {
                            float oldfquantity = Float.valueOf(olddrecordsMap.get("fquantity").toString()).floatValue();
                            newProduct.put("oldfquantity", oldfquantity);
                            break;
                        } else {
                            count++;
                        }
                    }

                    if (count == oldarrRdrecords.size()) {
                        newProduct.put("oldfquantity", 0);
                    }
                } else {
                    newProduct.put("oldfquantity", 0);
                }
                newProductList.add(newProduct);
            }

            StringBuffer iproductStringBuffer = new StringBuffer();
            for (int i = 0; i < newProductList.size(); i++) {
                HashMap newProduct = (HashMap) newProductList.get(i);
                if (i > 0) {
                    iproductStringBuffer.append(",");
                }
                iproductStringBuffer.append(newProduct.get("iproduct").toString());
            }

            HashMap paramObj = new HashMap();
            paramObj.put("iwarehouse", param.get("iwarehouse"));
            paramObj.put("iproducts", iproductStringBuffer.toString());

            List StockList = this.queryForList("queryStock", paramObj);

            if (StockList.size() == 0) {
                return "所选出库产品在所选择的仓库中不存在，请确认!";
            }

            for (int i = 0; i < newProductList.size(); i++) {
                HashMap newProduct = (HashMap) newProductList.get(i);
                float fquantity = Float.valueOf(newProduct.get("fquantity").toString()).floatValue();
                float oldfquantity = Float.valueOf(newProduct.get("oldfquantity").toString()).floatValue();
                int iproduct = Integer.valueOf(newProduct.get("iproduct").toString()).intValue();
                boolean isIn = false;
                for (int j = 0; j < StockList.size(); j++) {
                    HashMap StockMap = (HashMap) StockList.get(j);
                    int stockiproduct = Integer.valueOf(StockMap.get("iproduct").toString()).intValue();
                    if (stockiproduct == iproduct) {
                        isIn = true;
                        float fnet = Float.valueOf(StockMap.get("fnet").toString()).floatValue() + oldfquantity;
                        if (fnet <= 0) {
                            return StockMap.get("cwname").toString() + "中，产品【" + newProduct.get("iproductName").toString() + "】，库存缺货！";
                        } else if (fnet < fquantity) {
                            return StockMap.get("cwname").toString() + "中，产品【" + newProduct.get("iproductName").toString() + "】，库存只剩下："
                                    + fnet + ",不足以出库";
                        }
                        break;
                    }
                }
                if (!isIn) {
                    return "产品【" + newProduct.get("iproductName").toString() + "】，仓库中不存在，请确认!";
                }
            }

        }
        return null;
    }
}
