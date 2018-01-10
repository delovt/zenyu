package yssoft.invoice;

import yssoft.services.UtilService;

import java.util.HashMap;

/**
 * Created by Administrator on 2014/3/31.
 */
public class Handle {
    public UtilService utilService;

    public void setUtilService(UtilService utilService) {
        this.utilService = utilService;
    }
    /**
     * 分析当前单据是否可以操作
     * @param tableName     表名
     * @param iid           单据iid
     * @return
     */
    public int onIsCheck(String tableName,int iid){
        int istatus = -1;
        String sql = "select istatus from " + tableName +" where iid=" + iid;
        try{
            HashMap rhm = this.utilService.exeSql(sql).get(0);
            istatus = Integer.parseInt(rhm.get("istatus")+"");
        }catch (Exception e){
            System.out.println(e.getMessage());
        }
        return istatus;
    }

    /**
     * 批量处理结果
     * @param sum               总记录数
     * @param count             记录成功的条数
     * @param operate           操作名
     * @param resultMap         结果集
     * @return
     */
    public String showResult(int sum,int count,String operate,HashMap<String,String> resultMap){
        if(resultMap.size()==0){
            return "共计"+sum+"条，全部"+operate+"成功！";
        }else{
            String resultStr = "";
            int sign = 1;
            for(String str:resultMap.keySet()){
                resultStr += sign +"、 单据编码："+str+" 原因："+resultMap.get(str)+"\n";
                sign++;
            }
            return "共计"+sum+"条，"+operate+"成功"+count+"条，失败"+(sum-count)+"条"+"\n具体失败原因如下：\n"+resultStr+"";
        }
    }
}
