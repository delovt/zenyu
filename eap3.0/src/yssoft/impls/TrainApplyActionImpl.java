package yssoft.impls;

import yssoft.daos.BaseDao;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Set;

@SuppressWarnings("serial")
public class TrainApplyActionImpl extends BaseDao{
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public HashMap query(HashMap param){
		HashMap result = new HashMap();
		List list = new ArrayList();
		list = this.queryForList("queryForTrainRegist",param);
		List setList = new ArrayList();
		if(list.size()>0){
			HashMap hm = (HashMap) list.get(0);
			Set  set = hm.keySet();
			setList.addAll(set);
			
		}
		result.put("result", list);
		result.put("title", setList);
		return result;
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public Object insertIntoSr_Trains(HashMap param){
		List list = (List) param.get("selectedDatas");
		int iid= Integer.parseInt(param.get("iid")+"");
		String sqlStart="insert into sr_trains(itrains,iinvoices,icustomer,icustperson,cdepartment,cpost,cmobile,ctel,cemail,cmemo) values(";
		StringBuffer sqlValue=new StringBuffer();
		HashMap hm =null;
		String ssiid = "";
		String icustomer = "";
		String icustperson = "";
		String cdepartment = "";
		String cpost = "";
		String cmobile = "";
		String ctel = "";
		String cemail = "";
		String cmemo = "";
		for (int i = 0; i < list.size(); i++) {
			hm = (HashMap) list.get(i);
			if(hm.get("ssiid") != null) {
				ssiid = hm.get("ssiid").toString();
			}
			if(hm.get("icustomer") != null) {
				icustomer = hm.get("icustomer").toString();
			}
			if(hm.get("icustperson") != null) {
				icustperson = hm.get("icustperson").toString();
			}
			if(hm.get("客户部门") != null) {
				cdepartment = hm.get("客户部门").toString();
			}
			if(hm.get("客户职务") != null) {
				cpost = hm.get("客户职务").toString();
			}
			if(hm.get("客户手机") != null) {
				cmobile = hm.get("客户手机").toString();
			}
			if(hm.get("客户电话") != null) {
				ctel = hm.get("客户电话").toString();
			}
			if(hm.get("客户邮件") != null) {
				cemail = hm.get("客户邮件").toString();
			}
			if(hm.get("客户备注") != null) {
				cmemo = hm.get("客户备注").toString();
			}
			sqlValue.append(sqlStart).append(iid+",").append(ssiid+",").append(icustomer+",").append(icustperson+",'").append(cdepartment+"','").append(cpost+"','").append(cmobile+"','").append(ctel+"','").append(cemail+"','").append(cmemo+"'").append(");");
		
		}
		HashMap sql = new HashMap();
		sql.put("sql", sqlValue.toString());
		try {
			this.insert("insertIntoSr_Trains", sqlValue.toString());
		} catch (Exception e) {
			return e;
		}
		return true;
	}
	

}
