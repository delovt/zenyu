package yssoft.impls;

import yssoft.daos.BaseDao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * 服务工单业务操作
 * @author Administrator
 *
 */

@SuppressWarnings("serial")
public class Sr_BillImpl extends BaseDao{
	
	public List<?> getSRfeedbackoniinvoice(HashMap<?,?> param){
		return this.queryForList("getSRfeedbackoniinvoice", param);
	}

	/**
	 * 更新服务申请单的状态
	 * @param params 
	 * @return
	 */
	public void onUpdateSrRequestStatus(HashMap<String,Object> params){

		String strsql = "";
		HashMap<String,Object> hm = new HashMap<String,Object>();

		try{

			strsql = "update sr_request set istatus="+params.get("istatus")+" where iid="+params.get("iid");
			hm.put("sqlValue", strsql);
			this.update("SrBillDest.UpdateData",hm);

		}catch(Exception ex){
			ex.printStackTrace();
		}

	}

	public void onUpdateSrBillStatus(HashMap<String,Object> params){

		try{			
			this.update("SrBillDest.UpdateDataForStatus",params);			
		}catch(Exception ex){
			ex.printStackTrace();
		}	

	}
	
	//手工关闭服务工单，关闭跟踪时，修改cclose
	public void onCloseSrBillStatus(HashMap<String,Object> params){

		try{			
			this.update("SrBillDest.CloseDataForStatus",params);			
		}catch(Exception ex){
			ex.printStackTrace();
		}	

	}

	public void updateDataForStatus2(HashMap params){

		try{			
			this.update("SrBillDest.UpdateDataForStatus2",params);			
		}catch(Exception ex){
			ex.printStackTrace();
		}		
	}
	
	public void updateDataForClose(HashMap params){

		try{			
			this.update("SrBillDest.UpdateDataForClose",params);			
		}catch(Exception ex){
			ex.printStackTrace();
		}		
	}

	public boolean updateSrProject(HashMap params){

		try{			
			this.update("updateSrProject",params);		
			this.update("updateChangeSrProject",params);		
			return true;
		}catch(Exception ex){
			ex.printStackTrace();
			return false;
		}		
	}
	
	public boolean updateDataForPerson(ArrayList<HashMap> al){

		try{			
			for(HashMap h:al){
				if(h.get("daskprocess")==null){
					this.update("updateDataForPerson",h);				
				}else{
					this.update("updateDataForPersonAndDaskprocess",h);			
				}
					
			}		
			return true;
		}catch(Exception ex){
			ex.printStackTrace();
			return false;
		}		
	}
}
