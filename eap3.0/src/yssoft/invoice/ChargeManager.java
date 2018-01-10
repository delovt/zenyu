package yssoft.invoice;

import yssoft.services.UtilService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * Created by Administrator on 2014/3/31
 */
public class ChargeManager {
    private Handle handle;

    public void setHandle(Handle handle) {
        this.handle = handle;
    }

    /**
     * 收费单审核
     */
    public String verifyCont(HashMap param){
        int newStatus = Integer.parseInt(param.get("newStatus")+"");
        int iid = Integer.parseInt(param.get("iid")+"");
        String operate = param.get("operate")+"";
        int userId = Integer.parseInt(param.get("userId")+"");
        String sql = "update tr_charge set istatus = "+ newStatus +",iverify = " + userId + ",dverify = getdate() where iid = " + iid +";";
        //审核
        if(newStatus == 2){
            sql += "update tr_invoice set istatus = 3 where iid= (select iinvoice from tr_charge where iid = " + iid + ") and istatus = 2;" +
                    "insert into tr_invoices select a.iinvoice,a.iid,3,a.iperson,b.icustomer,b.iverify,b.dverify,a.cmemo from tr_invoice a,tr_charge b where a.iid = b.iinvoice and b.iid = " + iid +
                    ";update CS_customer set " +
                    	"dscontdate = (case when isnull(t.dmscontdate,'')='' then (case when t.dscontdate>cs_customer.dscontdate then t.dscontdate else cs_customer.dscontdate end) "+
										"else (case when t.dmscontdate>cs_customer.dscontdate then t.dmscontdate else cs_customer.dscontdate end) end), "+
						"decontdate = (case when isnull(t.dmecontdate,'')='' then (case when t.decontdate>cs_customer.decontdate then t.decontdate else cs_customer.decontdate end) "+ 
										"else (case when t.dmecontdate>cs_customer.decontdate then t.dmecontdate else cs_customer.decontdate end) end) " +
                    "from tr_charge t where t.icustomer = CS_customer.iid and t.istatus = 2 and t.iid = " +iid;
        }
        //退审
        if(newStatus == 0){
            sql += "update tr_invoice set istatus = 2 where iid= (select iinvoice from tr_charge where iid = " + iid + ") and istatus = 3;" +
                    "insert into tr_invoices select a.iinvoice,a.iid,2,a.iperson,b.icustomer,b.iverify,b.dverify,isnull(a.cmemo,'')+'(被退审)' from tr_invoice a,tr_charge b where a.iid = b.iinvoice and b.iid = "+ iid +
                    ";update cs_customer set dscontdate = a.dscontdate,decontdate = a.decontdate from "+
							"(select max(iid) iid,case when dmscontdate is null then dscontdate else dmscontdate end dscontdate, "+ 
							"case when dmecontdate is null then decontdate else dmecontdate end decontdate,icustomer "+
							"from tr_charge where istatus > 1 and iid <> " + iid +
							"group by dscontdate,decontdate,dmscontdate,dmecontdate,icustomer) a "+ 
					"where cs_customer.iid = a.icustomer ";
        }
        try{
            this.handle.utilService.exeSql(sql);
            return operate;
        }catch (Exception e){
            System.out.println(e.getMessage());
            return e.toString();
        }

    }
    /**
     * 生成交割单
     */
    @SuppressWarnings({ "unused", "rawtypes" })
	public String toNewDelivery(HashMap param){
        int newStatus = Integer.parseInt(param.get("newStatus")+"");
        int iid = Integer.parseInt(param.get("iid")+"");
        int icus = Integer.parseInt(param.get("icustomer")+"");
        int iecstatus = Integer.parseInt(param.get("iecstatus")+"");
        String operate = param.get("operate")+"";
        int userId = Integer.parseInt(param.get("userId")+"");
        String sql = "update tr_charge set istatus = "+ newStatus +",ddelivery = getdate(),cdelivery = convert(varchar(10),getdate(),112)+'"+iid+"' where iid = " + iid+
        			 ";update CS_customer set iskstatus=(select top 1 iecstatus from tr_charge where icustomer="+
        			 icus+" order by iid desc)";
        try{
            this.handle.utilService.exeSql(sql);
            return operate;
        }catch (Exception e){
            System.out.println(e.getMessage());
            return e.toString();
        }
    }
    /**
     * 批量审核收费单
     */
    public String bathVerifyCont(HashMap param){
        List billsList = (ArrayList)param.get("billsList");//所选单据信息
        String tableName = param.get("tableName")+"";//当前表名
        int checkStatus = Integer.parseInt(param.get("checkStatus")+"");//是否可以操作
        int newStatus = Integer.parseInt(param.get("newStatus")+"");//审核后单据状态
        String operate = param.get("operate")+"";//操作名
        int userId = Integer.parseInt(param.get("userId")+"");//审核人

        HashMap<String,String> resultMap = new HashMap<String,String>();//存放失败信息
        int sum = billsList.size();//总记录数
        int count = 0;//记录成功的条数
        for(int i = 0;i<billsList.size();i++){
            HashMap bills = (HashMap)billsList.get(i);//每条单据的信息
            int iid = Integer.parseInt(bills.get("iid")+"");//单据iid
            String ccode = bills.get("iinvoice")+"";//发票编号
            //先判断单据是否可操作
            if(this.handle.onIsCheck(tableName,iid) == -1){
                resultMap.put(ccode,"数据库连接发生异常！");
            }else if(this.handle.onIsCheck(tableName,iid) != checkStatus){
                resultMap.put(ccode,"单据状态不正确，不能进行操作！");
            }else{
                bills.put("newStatus",newStatus);
                bills.put("operate",operate);
                bills.put("userId",userId);
                String result = verifyCont(bills);//得到结果
                if(result.equals(operate)){
                    count++;
                }else{
                    //当失败时，存放发票编号和错误原因
                    resultMap.put(ccode,result);
                }
            }
        }
        return this.handle.showResult(sum,count,operate,resultMap);
    }
    /**
     * 批量生成交割单
     */
    public String bathToNewDelivery(HashMap param){
        List billsList = (ArrayList)param.get("billsList");//所选单据信息
        String tableName = param.get("tableName")+"";//当前表名
        int checkStatus = Integer.parseInt(param.get("checkStatus")+"");//是否可以操作
        int newStatus = Integer.parseInt(param.get("newStatus")+"");//审核后单据状态
        String operate = param.get("operate")+"";//操作名
        int userId = Integer.parseInt(param.get("userId")+"");//审核人

        HashMap<String,String> resultMap = new HashMap<String,String>();//存放失败信息
        int sum = billsList.size();//总记录数
        int count = 0;//记录成功的条数
        for(int i = 0;i<billsList.size();i++){
            HashMap bills = (HashMap)billsList.get(i);//每条单据的信息
            bills.put("newStatus",newStatus);
            int iid = Integer.parseInt(bills.get("iid")+"");//单据iid
            String ccode = bills.get("iinvoice")+"";//发票编号
            String bustype = bills.get("ibustype")+"";//收款方式
            if(operate.equals("批量退审")){
                if(bustype.equals("转账未到")){
                    checkStatus = 1;
                }else{
                    checkStatus = 2;
                }
            }
            //先判断单据是否可操作
            if(this.handle.onIsCheck(tableName,iid) == -1){
                resultMap.put(ccode,"数据库连接发生异常！");
            }else if(this.handle.onIsCheck(tableName,iid) != checkStatus){
                resultMap.put(ccode,"单据状态不正确，不能进行操作！");
            }else{
                bills.put("newStatus",newStatus);
                bills.put("operate",operate);
                bills.put("userId",userId);
                String result = toNewDelivery(bills);//得到结果
                if(result.equals(operate)){
                    count++;
                }else{
                    //当失败时，存放发票编号和错误原因
                    resultMap.put(ccode,result);
                }
            }
        }
        return this.handle.showResult(sum,count,operate,resultMap);
    }

}
