package yssoft.impls;

import yssoft.daos.BaseDao;

import java.util.HashMap;
import java.util.List;

@SuppressWarnings("serial")
public class BatchAccreditImpl extends BaseDao{

	public BatchAccreditImpl(){}
	
	
	/**
	 * 获取参照信息
	 * @return
	 */
	@SuppressWarnings({"unchecked", "rawtypes" })
	public HashMap queryConsult(HashMap param){
		
		HashMap rhm = new HashMap();
		HashMap phm = new HashMap();
		String strsql = "";
		
		try{
			
			int ifuncregedit = Integer.parseInt(param.get("ifuncregedit")+"");
			List tlist = (List)param.get("datalist");
			
			for(int i=0;i<tlist.size();i++){
				
				HashMap hm = (HashMap) tlist.get(i);
				String fname = "";
				String fiid = "";
				String xname = "";
				String xiid = "";
				
				int iid = Integer.parseInt(hm.get("iid")+"");
				
				strsql = "select DBO.FUN_CONVERTSTR("+iid+","+ifuncregedit+") as result";
				phm.put("sqlValue", strsql);
				HashMap temp = (HashMap)this.queryForObject("BatchAccreditDest.Search", phm);
				String result = temp.get("result")+"";
				
				if(result.trim().equals(":")) continue;
				
				if(result.indexOf("*") != -1){
					
					String[] str = result.split("[*]");
					fname = ((HashMap)onResolveStr(str[0])).get("svalue")+"";
					fiid  = ((HashMap)onResolveStr(str[0])).get("ivalue")+"";
					xname = ((HashMap)onResolveStr(str[1])).get("svalue")+"";
					xiid  = ((HashMap)onResolveStr(str[1])).get("ivalue")+"";
				}
				else{
					
					fname = ((HashMap)onResolveStr(result)).get("svalue")+"";
					fiid  = ((HashMap)onResolveStr(result)).get("ivalue")+"";
					
				}
				
				hm.put("fcperson", fname);
				hm.put("fiperson", fiid);
				hm.put("xcperson", xname);
				hm.put("xiperson", xiid);
				
			}
			
			rhm.put("datalist", tlist);
			rhm.put("consultobj", this.queryForObject("BatchAccreditDest.queryConsult"));
			
		}catch(Exception ex){
			ex.printStackTrace();
		}
		
		return rhm;
	}
	
	//分解
	@SuppressWarnings({"unchecked", "rawtypes" })
	private HashMap onResolveStr(String param){
		
		HashMap rhm = new HashMap();
		String[] str = param.split(":");
		
		if(str.length == 0){
			rhm.put("svalue", "");
			rhm.put("ivalue", "");
		}
		else{
			rhm.put("svalue", str[0]);
			rhm.put("ivalue", str[1]);
		}
		return rhm;
		
	}
	
	//执行批量授权
	@SuppressWarnings({"unchecked", "rawtypes" })
	public String onBatchAccredit(HashMap param)
	{
		
		String rvalue = "suc";
//		String strsql = "";
		HashMap hm = new HashMap();
		StringBuilder  sql = new StringBuilder("");
		StringBuilder  sql2 = new StringBuilder("");
		
		try{
			
			//拆分表单ID记录集
			if((param.get("cinvoice")+"").equals(""))  return rvalue;
			
			String striid[] = (param.get("cinvoice")+"").split(",");
			int itype = Integer.parseInt(param.get("itype")+"");//类型
			
			
			for(int i=0,len=striid.length;i<len;i++){
				
				switch(itype){
				
					case 0://0分配负责人，先删除当前人员全部权限，再插入该人员全部权限
						
						if(i==0) {
							sql.append("delete from ab_invoiceuser where  iperson='"+param.get("iperson")+"' and ifuncregedit='"+param.get("ifuncregedit")+"' " +
									"and iinvoice in ("+param.get("cinvoice")+")");
						}
						
						sql2.append(" insert into ab_invoiceuser (ifuncregedit,iinvoice,idepartment,iperson,irole) " +
								" values("+param.get("ifuncregedit")+","+striid[i]+","+param.get("idepartment")+","+param.get("iperson")+",1)");
						
						break;
						
					case 1://1分配相关人，插入该人员对应的不存在的记录集
						
						sql = onGetSql(striid,param);
						
						break;
						
					case 2://2收回人员，相关人员可以直接回收，如果某单据只有一个负责人，且收回人为此负责人，则不收回此负责人权限
						
						sql.append("delete from ab_invoiceuser where  iperson='"+param.get("iperson")+"' and ifuncregedit='"+param.get("ifuncregedit")+"' and irole=2 and iinvoice in ("+param.get("cinvoice")+") ");
						sql.append("delete from ab_invoiceuser where  iperson='"+param.get("iperson")+"' and ifuncregedit='"+param.get("ifuncregedit")+"' and irole=1 and iinvoice in " +
								"(select iinvoice from ab_invoiceuser  group by ifuncregedit,iinvoice,irole having ifuncregedit= '"+param.get("ifuncregedit")+"' " +
								"and irole=1 and count(iinvoice) >1 and iinvoice in ("+param.get("cinvoice")+"))");	   
						
						break;
						
					case 3:
						if(i==0) {
							sql.append("delete from ab_invoiceuser where  iperson='"+param.get("iperson")+"' and ifuncregedit='"+param.get("ifuncregedit")+"' " +
									"and iinvoice in ("+param.get("cinvoice")+")");
						}
						break;
					default:
						break;
				
				}
				
				if(itype==1 || itype==2 || itype==3) break;//跳出循环
			}
			
			if(!sql.toString().equals("")){
				hm.put("sqlValue", sql.append(sql2).toString());
				this.queryForList("BatchAccreditDest.Search",hm);
			}
			
		}catch(Exception ex){
			ex.printStackTrace();
			rvalue = "fail";
		}
		finally{
			sql.setLength(0);
			sql2.setLength(0);
		}
		
		return rvalue;
		
	}
	
	@SuppressWarnings({ "rawtypes", "unchecked" })
	private StringBuilder onGetSql(String[] str,HashMap param){
		
		String strsql = "";
		HashMap hm = new HashMap();
		String strtemp = "";
		String temp[] = null;
		StringBuilder sql = new StringBuilder("");
		
		//获取分配人对应的原始单据集合
		strsql = "select iinvoice from ab_invoiceuser where iperson='"+param.get("iperson")+"' and ifuncregedit='"+param.get("ifuncregedit")+"' and iinvoice in ("+param.get("cinvoice")+") and irole=2";
		hm.put("sqlValue", strsql);
		List list = this.queryForList("BatchAccreditDest.Search",hm);
		
		if(list.size()>0){
			
			for(int i=0;i<str.length;i++){

				for(int j=0;j<list.size();j++){
					
					String item = ((HashMap)list.get(j)).get("iinvoice")+"";
					
					if(str[i].equals(item)){
						str[i] = null;
						break;
					}
				}
				
			}
			
			for(int k=0;k<str.length;k++){
				if(str[k] != null)
					strtemp+=str[k]+",";
			}
			
			if(!strtemp.equals(""))
				temp = strtemp.substring(0, strtemp.lastIndexOf(",")).split(",");
		}
		else
			temp = str;
		
		if(temp != null){
			for(int m=0;m<temp.length;m++){
				
				sql.append(" insert into ab_invoiceuser (ifuncregedit,iinvoice,idepartment,iperson,irole) values " +
						"("+param.get("ifuncregedit")+","+temp[m]+","+param.get("idepartment")+","+param.get("iperson")+",2)");
				
			}
		}
		
		return sql;
		
	}
	
	/*
	 * 	获取客商热度参照列表信息
	 */
	@SuppressWarnings({"unchecked", "rawtypes" })
	public List onGetHeatList(){
		
		List list = null;
		HashMap hm 	= new HashMap();
		String strsql = "";
		
		try{
			
			strsql = "select iid,cname from aa_data where iclass=(select iid from aa_dataclass where cname like '%热度%')";
			hm.put("sqlValue", strsql);
			list = this.queryForList("BatchAccreditDest.Search",hm);
			
		}catch(Exception ex){
			ex.printStackTrace();
		}
		
		return list;
	}
	
	/*
	 * 更新客商档案中的热度(批量热度设置)
	 */
	@SuppressWarnings({"unchecked", "rawtypes" })
	public String onUpdateIfieryForCustomer(HashMap param){
		
		String rvalue = "suc";
		String strsql = "";
		HashMap hm = new HashMap();
		
		try{
			
			strsql = "update cs_customer set ifiery="+param.get("ifiery")+" where iid in ("+param.get("cusiids")+")";
			hm.put("sqlValue", strsql);
			this.update("BatchAccreditDest.Update", hm);
			
		}catch(Exception ex){
			ex.printStackTrace();
			rvalue = "fail";
		}
		
		return rvalue;
		
	}
	
	//分支执行，用于高级授权
	@SuppressWarnings({ "unchecked", "rawtypes" })
	public String onBranchExe(HashMap pm){
		
		String rstr = "";
		HashMap param = new HashMap();
		
		param.put("ifuncregedit", pm.get("ifuncregedit"));
		param.put("iperson", pm.get("iperson"));
		param.put("idepartment", pm.get("idepartment"));
		
		//先批量删除原来的授权负责人
		param.put("cinvoice", pm.get("fzperson"));
		param.put("itype", 3);
		rstr = onBatchAccredit(param);
		
		//先批量删除原来的授权相关人
		param.put("cinvoice", pm.get("xgperson"));
		param.put("itype", 3);
		rstr = onBatchAccredit(param);
		
		//批量授权负责人
		param.put("cinvoice", pm.get("fzcinvoice"));
		param.put("itype", 0);
		rstr = onBatchAccredit(param);
		
		//批量授权相关人
		param.put("cinvoice", pm.get("xgcinvoice"));
		param.put("itype", 1);
		rstr = onBatchAccredit(param);
		
		return rstr;
	}
	
}
