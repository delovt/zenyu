package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IMrCompetitorService;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

@SuppressWarnings("serial")
public class MrCompetitorServiceImpl extends BaseDao implements IMrCompetitorService{

	@SuppressWarnings("unchecked")
	@Override
	//增加竞争对手
	public Object addMrCopetitor(HashMap paramMap) throws Exception {

		Object objiid = this.insert("CompetitorDest.addCompetitor", paramMap);

		int iid = Integer.parseInt(objiid.toString());//主键
		
		//子表操作
		new ChildrenDataHandle().ChildData(paramMap, iid);
		
		return objiid;
	}

	@Override
	//删除竞争对手
	public Object deleteMrCopetitor(String condition) throws Exception {
		Object obj = null;
		//删除主表信息
		obj = this.delete("CompetitorDest.delCompetitor", condition);

		//删除子表信息
		StringBuilder strsql = new StringBuilder("");
		String sqlcondition = condition.substring(condition.indexOf("in"),condition.length());
		strsql.append(" delete MR_competitorps where icompetitor "+	sqlcondition);
		strsql.append(" delete MR_competitorpd where icompetitor "+ sqlcondition);

		HashMap<String,Object> paramMap = new HashMap<String,Object>();
		paramMap.put("sqlValue", strsql.toString());
		this.delete("CompetitorDest.del",paramMap);

		return obj;

	}

	@SuppressWarnings("unchecked")
	@Override
	//获取竞争对手列表
	public List getMrCopetitorList(String condition) {
		return this.queryForList("CompetitorDest.getCompetitor",condition);
	}

	@SuppressWarnings("unchecked")
	@Override
	//更新竞争对手信息
	public Object updateMrCopetitor(HashMap paramMap) throws Exception {
		Object obj = null;
		int iid = Integer.parseInt(paramMap.get("iid").toString());

		obj = this.update("CompetitorDest.updateCompetitor", paramMap);

		new ChildrenDataHandle().ChildData(paramMap, iid);

		return obj;
	}


	@SuppressWarnings("unchecked")
	//获取子表信息
	public HashMap getSublistInfo(HashMap paramMap) throws Exception{

		HashMap<String, Object> returnMap = new HashMap<String, Object>();
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		HashMap<String, Object> temp = new HashMap<String, Object>();
		StringBuilder strsql = new StringBuilder("select ");

		//从数据字典获取子表表结构信息
		List table_formation = this.queryForList("CompetitorDest.getTableFormation", paramMap.get("tablename"));

		//数据字典为空，直接返回
		if(table_formation.size() == 0) return null;

		returnMap.put("tablelist", table_formation);

		for(int i=0;i<table_formation.size();i++){
			HashMap hmrecord = (HashMap)table_formation.get(i);//获取一条记录

			String cfield = hmrecord.get("cfield").toString();//字段名称
			String cfieldtype = hmrecord.get("idatatype").toString();//字段类型


			if(cfieldtype.equals("datetime")){//日期类型
				strsql.append("convert(nvarchar(10),"+cfield+",120) "+cfield+",");
			}
			else{			
				strsql.append(cfield+",");
			}

			temp.put(cfield, null);
		}

		//格式化sql
		strsql.replace(strsql.lastIndexOf(","), strsql.length(), "");
		strsql.append(" from "+ paramMap.get("tablename") +" where 1=1 ");
		if(paramMap.get("condition") != null && !paramMap.get("condition").toString().equals(""))
			strsql.append(" and " + paramMap.get("condition").toString());

		resultMap.put("sqlValue", strsql);

		List data_list = this.queryForList("CompetitorDest.getDataInfo", resultMap);

		returnMap.put("datalist", data_list);
		
		//获取服务器时间(子表新增默认值时功能中有可能会使用)
		Date dt = new Date();
		SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd hh:mm:ss"); 
		
		returnMap.put("serverdate", format.format(dt));
		
		return returnMap;

	}

	//YJ Add 20110928 根据字符串式的固定枚举值，简单处理返回带有固定枚举值的数组
	@SuppressWarnings("unchecked")
	private List convertFixValue(String fixvalue){
		List list = new ArrayList();
		String[] arr = fixvalue.split(",");

		for(int i=0;i<arr.length;i++){

			String value = arr[i];
			String[] arrvalue = value.split(":");
			HashMap<String, String> returnMap = new HashMap<String, String>();
			returnMap.put("value", arrvalue[0]);
			returnMap.put("name", arrvalue[1]);
			list.add(returnMap);
		}

		return list;
	}
	
	
	//YJ Add 20111008 依据主表主键重新获取子表信息
	@SuppressWarnings("unchecked")
	public List reGetChildrenData(HashMap paramMap){
		
		List collect_arr = new ArrayList();
		List dg_arr=null;
		List arr = (List)paramMap.get("param_arr");//前台传入的汇总集合
		
		for(int i=0;i<arr.size();i++){
			
			HashMap<String,Object> hm = new HashMap<String,Object>();
			
			HashMap record = (HashMap)arr.get(i);//获取一条记录
			
			try {
				
				dg_arr = (List)getSublistInfo(record).get("datalist");//查询子表信息
				
			} catch (Exception e) {
				e.printStackTrace();
			}
			
			hm.put("tablename", record.get("tablename"));
			hm.put("condition", record.get("condition"));
			hm.put("childrenlist", dg_arr);//载入新元素
			
			collect_arr.add(hm);
			
		}
		
		return collect_arr;
	}
	
	
	@SuppressWarnings({ "unchecked" })
	public HashMap onGetResult(HashMap paramMap){
		
		String strsql = "";
		
		List list = (List)paramMap.get("exparr");
		List rlist = new ArrayList();//返回值
		HashMap rhm = new HashMap();
		
		try{
			
			if(list.size()>0){				
				
				for(int i=0;i<list.size();i++){
					Object obj = new Object();
					HashMap item = (HashMap)list.get(i);
					strsql = "select "+item.get("expression")+" as value";
					
					paramMap.put("sqlValue", strsql);
					obj = this.queryForObject("CompetitorDest.getDataInfo",paramMap);
					
					item.put("rvalue", obj);
					
					rlist.add(item);
				}
				
			}
			
			rhm.put("rlist", rlist);
		}
		catch(Exception ex){
			System.out.println(ex.getMessage());
		}
		return rhm;
	}
	
	//获取约束表达式返回值
	@SuppressWarnings({ "unchecked" })
	public HashMap onGetResFunValue(HashMap paraMap){
		String strsql = "";
		HashMap rhm = new HashMap();
		
		strsql = "select case when "+paraMap.get("cresfun")+" then 1 else 0 end as value";
		paraMap.put("sqlValue", strsql);
		
		try{
			
			rhm.put("rvalue", this.queryForObject("CompetitorDest.getDataInfo",paraMap));
			
		}
		catch(Exception ex){
			System.out.println(ex.getMessage());
		}
		
		return rhm;
	}
	
	@SuppressWarnings({ "unchecked" })
	public String onGetResFunValue2(HashMap paraMap){
		String strsql = "";
		String rmesg = "";
		try{
			List resArr = (List)paraMap.get("resArr");
			if(resArr.size()==0) return "";

			for(int i=0;i<resArr.size();i++){
				HashMap item = (HashMap) resArr.get(i);

				String gridname = item.get("gridname")==null?"":item.get("gridname")+"";

				//获取约束信息
				List resfun = (List)item.get("restrainArr");
				List dgdata = (List)item.get("dgdata");
				if(resfun.size() == 0)return "";
				if(dgdata.size() == 0)return "";
				for(int j=0;j<resfun.size();j++){
					HashMap hmresfun = (HashMap)resfun.get(j);

					String resfield = hmresfun.get("cfield")+"";//字段
//					String resfname = hmresfun.get("fname")+"";//字段名称
					String sresfun  = hmresfun.get("cresfun")+"";//约束公式
					String resmes   = hmresfun.get("cresmes")+"";//约束提示信息

					for(int k=0;k<dgdata.size();k++){
						HashMap hmdgdata = (HashMap)dgdata.get(k);
						Object objvalue = hmdgdata.get(resfield);//约束字段对应的值

						//值带入
						String fun = sresfun.replaceAll(resfield, objvalue+"");
						
						//调用后台
						strsql = "select case when "+fun+" then 1 else 0 end as value";
						paraMap.put("sqlValue", strsql);
						
						Object obj = this.queryForObject("CompetitorDest.getDataInfo",paraMap);
						HashMap hmobj = (HashMap)obj;
						if((Integer)hmobj.get("value") == 0){
							rmesg = gridname+" 中的 "+resmes;
							return rmesg;
						}
							
					}
				}
			}

		}
		catch(Exception ex){
			System.out.println(ex.getMessage());
		}

		return rmesg;
	}
}
