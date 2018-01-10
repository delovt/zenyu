package yssoft.impls;

import yssoft.daos.BaseDao;

import java.util.HashMap;

public class ForListHandle extends BaseDao {
	public String onRefreshState(){
		
		HashMap hm = new HashMap();
		//hm.put("sqlValue","update cs_custproduct set iscstatus = 511 where ((iscstatus=509 or iscstatus=510) and dsend<getdate())");
		//只更新状态为新购的
        /**修改
         * LKH 20160226
         * 客户资产点击更新状态，信息不变
         */
		hm.put("sqlValue"," update cs_custproduct set iscstatus = case when   dsend < getdate()  then 511 when  dsend > getdate()  then  510  end where istatus = 1 ");
		int i=0;
		try{
			 i = this.update("wtf.forListHandle",hm);
             if(i==0){
                 return "状态为最新，无须更新";
             }else if(i<0){
                 return "更新失败";
             }else{
                 return "更新成功"+i+"条信息";
             }
		}catch (Exception e) {
			return "更新失败";
		}
		
	}
}
