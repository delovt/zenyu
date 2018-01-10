package yssoft.impls;

import yssoft.daos.BaseDao;

import java.util.HashMap;

@SuppressWarnings("serial")
public class SrFeedBackImpl extends BaseDao{

	public SrFeedBackImpl(){}
	
	/**
	 * 更新服务派工单的状态
	 * @param params 
	 * @return
	 */
	public void onUpdateSrBillStatus(HashMap<String,Object> params){
	
		String strsql = "";
		HashMap<String,Object> hm = new HashMap<String,Object>();
		
		try{
			
			strsql = "update sr_bill set istatus="+params.get("istatus")+" where iid="+params.get("iid");
			hm.put("sqlValue", strsql);
			this.update("SrFeedBackDest.UpdateData",hm);
			
		}catch(Exception ex){
			ex.printStackTrace();
		}
	}
	
}
