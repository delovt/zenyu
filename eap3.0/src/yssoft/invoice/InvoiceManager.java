package yssoft.invoice;

import sun.org.mozilla.javascript.internal.EcmaError;
import yssoft.services.UtilService;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * Created by Administrator on 2014/3/28.
 */
public class InvoiceManager {
    private UtilService utilService;

    public void setUtilService(UtilService utilService) {
        this.utilService = utilService;
    }


    /**
     * 分配发票
     */
    public String allotInvoice(HashMap param){
        int iperson = Integer.parseInt(param.get("iperson")+"");
        int iid = Integer.parseInt(param.get("iid")+"");
        String sql = "update tr_invoice set iperson = " + iperson + ",istatus = 1 where iid = " + iid +
                ";insert into tr_invoices(itrinvoice,itype,imaker,dmaker,cmemo,iperson,itrrule) select iid,istatus,imaker,dmaker,cmemo,iperson,iinvoice from tr_invoice where iid = "+ iid ;
        try{
            this.utilService.exeSql(sql);
            return "分配成功";
        }catch (Exception e){
            System.out.println(e.getMessage());
            return e.toString();
        }

    }
    /**
     * 退领发票
     */
    public String returnInvoice(HashMap param){
        int iid = Integer.parseInt(param.get("iid")+"");
        String sql = "update tr_invoice set iperson = null,istatus = 0 where iid = " + iid ;
        try{
            this.utilService.exeSql(sql);
            return "退领成功";
        }catch (Exception e){
            System.out.println(e.getMessage());
            return e.toString();
        }
    }
    /**
     * 作废、遗失发票
     */
    public String cancelInvoice(HashMap param){
        int iid = Integer.parseInt(param.get("iid")+"");
        int newStatus = Integer.parseInt(param.get("newStatus")+"");
        String sql = "update tr_invoice set istatus = "+ newStatus +" where iid = " + iid;
        try{
            this.utilService.exeSql(sql);
            return "作废或遗失成功";
        }catch (Exception e){
            System.out.println(e.getMessage());
            return e.toString();
        }
    }
    /**
     * 批量分配发票
     */
    public String bathAllotInvoice(HashMap param){
        List billsList = (ArrayList)param.get("billsList");//所选单据信息
        String tableName = param.get("tableName")+"";//当前表名
        int checkStatus = Integer.parseInt(param.get("checkStatus")+"");//需要检验的单据状态
        Object iperson = param.get("iperson");//分配所属人
        HashMap<String,String> resultMap = new HashMap<String,String>();//存放失败信息
        int sum = billsList.size();//总记录数
        int count = 0;//记录成功的条数
        for(int i = 0;i<billsList.size();i++){
            HashMap bills = (HashMap)billsList.get(i);//每条单据的信息
            bills.put("iperson",iperson);
            int iid = Integer.parseInt(bills.get("iid")+"");//单据iid
            String ccode = bills.get("invcode")+"";//发票编号
            //先判断单据是否可操作
            if(!this.onIsCheck(tableName,iid,checkStatus)){
                resultMap.put(ccode,"发票非未使用状态，不允许分配");
            }else{
                String result = allotInvoice(bills);//分配并得到结果
                if(result.equals("分配成功")){
                    count++;
                }else{
                    //当分配失败时，存放发票编号和错误原因
                    resultMap.put(ccode,result);
                }
            }

        }
        //全部分配成功
        if(resultMap.size()==0){
            return "共计"+sum+"条，全部分配成功！";
        }else{
            String resultStr = "";
            int sign = 1;
            for(String str:resultMap.keySet()){
                resultStr += sign +"、 合同编码："+str+" 原因："+resultMap.get(str)+"\n";
                sign++;
            }
            return "共计"+sum+"条，分配成功"+count+"条，失败"+(sum-count)+"条"+"\n具体失败原因如下：\n"+resultStr+"";
        }
    }
    /**
     * 批量退领发票
     */
    public String bathReturnInvoice(HashMap param){
        List billsList = (ArrayList)param.get("billsList");//所选单据信息
        String tableName = param.get("tableName")+"";//当前表名
        int checkStatus = Integer.parseInt(param.get("checkStatus")+"");//需要检验的单据状态

        HashMap<String,String> resultMap = new HashMap<String,String>();//存放失败信息
        int sum = billsList.size();//总记录数
        int count = 0;//记录成功的条数
        for(int i = 0;i<billsList.size();i++){
            HashMap bills = (HashMap)billsList.get(i);//每条单据的信息

            int iid = Integer.parseInt(bills.get("iid")+"");//单据iid
            String ccode = bills.get("invcode")+"";//发票编号
            //先判断单据是否可操作
            if(!this.onIsCheck(tableName,iid,checkStatus)){
                resultMap.put(ccode,"发票非领用状态，不允许退领");
            }else{
                String result = returnInvoice(bills);//退领并得到结果
                if(result.equals("退领成功")){
                    count++;
                }else{
                    //当退领失败时，存放发票编号和错误原因
                    resultMap.put(ccode,result);
                }
            }

        }
        //全部退领成功
        if(resultMap.size()==0){
            return "共计"+sum+"条，全部退领成功！";
        }else{
            String resultStr = "";
            int sign = 1;
            for(String str:resultMap.keySet()){
                resultStr += sign +"、 合同编码："+str+" 原因："+resultMap.get(str)+"\n";
                sign++;
            }
            return "共计"+sum+"条，退领成功"+count+"条，失败"+(sum-count)+"条"+"\n具体失败原因如下：\n"+resultStr+"";
        }
    }
    /**
     * 批量作废或遗失发票
     */
    public String bathCancelInvoice(HashMap param){
        List billsList = (ArrayList)param.get("billsList");//所选单据信息
        String tableName = param.get("tableName")+"";//当前表名
        int newStatus = Integer.parseInt(param.get("newStatus")+"");//需要更新成的单据状态
        String newStatusName = "作废";
        if(newStatus == 5){
            newStatusName = "遗失";
        }
        HashMap<String,String> resultMap = new HashMap<String,String>();//存放失败信息
        int sum = billsList.size();//总记录数
        int count = 0;//记录成功的条数
        for(int i = 0;i<billsList.size();i++){
            HashMap bills = (HashMap)billsList.get(i);//每条单据的信息
            bills.put("newStatus",newStatus);
            int iid = Integer.parseInt(bills.get("iid")+"");//单据iid
            String ccode = bills.get("invcode")+"";//发票编号
            //先判断单据是否可操作
            if(!this.onIsCheck(tableName,iid,0) && !this.onIsCheck(tableName,iid,1)){
                resultMap.put(ccode,"发票非未使用或领用状态，不允许"+newStatusName);
            }else{
                String result = cancelInvoice(bills);//退领并得到结果
                if(result.equals("作废或遗失成功")){
                    count++;
                }else{
                    //当退领失败时，存放发票编号和错误原因
                    resultMap.put(ccode,result);
                }
            }

        }
        //全部成功
        if(resultMap.size()==0){
            return "共计"+sum+"条，全部"+newStatusName+"成功！";
        }else{
            String resultStr = "";
            int sign = 1;
            for(String str:resultMap.keySet()){
                resultStr += sign +"、 合同编码："+str+" 原因："+resultMap.get(str)+"\n";
                sign++;
            }
            return "共计"+sum+"条，"+newStatusName+"成功"+count+"条，失败"+(sum-count)+"条"+"\n具体失败原因如下：\n"+resultStr+"";
        }
    }
    /**
     * 分析当前单据是否可以操作
     * @param tableName     表名
     * @param iid           单据iid
     * @param checkStatus   需要检验的单据状态
     * @return
     */
    public boolean onIsCheck(String tableName,int iid,int checkStatus){
        String sql = "select istatus from " + tableName +" where iid=" + iid;
        try{
            HashMap rhm = this.utilService.exeSql(sql).get(0);
            if(Integer.parseInt(rhm.get("istatus")+"") != checkStatus)
                return false;
        }catch (Exception e){
            System.out.println(e.getMessage());
        }
        return true;
    }
}
