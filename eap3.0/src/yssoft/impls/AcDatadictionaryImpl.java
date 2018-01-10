/**
 * 		备注信息:select 表头物理表名.字段1 as 字段1_UI字段内码,表头物理表名.字段2 as 字段2_UI字段内码，……,
 * 				参照表1_UI字段内码.参照显示字段名 as 参照表1_UI字段内码_参照显示字段名,参照表2_UI字段内码.参照显示字段名 as 参照表2_UI字段内码_参照显示字段名,…… 
 * 				from 表头物理表名 left join 参照表1 参照表1_UI字段内码 on 表头物理表名.引用参照字段名1=参照表1_UI字段内码.参照写入字段名 
 * 				left join 参照表2 参照表2_UI字段内码 on 表头物理表名.引用参照字段名2=参照表2_UI字段内码.参照写入字段名 left join …… 
 */
package yssoft.impls;

import yssoft.daos.BaseDao;

import java.util.HashMap;
import java.util.List;

@SuppressWarnings("serial")
public class AcDatadictionaryImpl extends BaseDao{
	
	public AcDatadictionaryImpl(){}
	
	/**
	 * 	函数名称:	onCreateListSql
	 *  函数说明:	动态创建列表配置中的sql
	 *  创建人  :	YJ
	 *  创建日期:	2012-02-07
	 *  @param 		ifuncregedit 功能注册码
	 *  @return 	创建后的完整sql
	 */
	@SuppressWarnings("unchecked")
	public String createListSql(HashMap params){
		String rstr = "";
		String strsql = "";
		HashMap<String, Object> hmparam = new HashMap<String,Object>();
		
		try{
			
			strsql = "select AC_datadictionary.iid,ifuncregedit,ctable,cfield,ccaption,as_datatype.ctype idatatype,ilength,"+
					"Ac_consultConfiguration.cconsulttable,Ac_consultConfiguration.cconsultswfld,Ac_consultConfiguration.cconsultbkfld,Ac_consultConfiguration.iconsult from AC_datadictionary"+
					" left join as_datatype on AC_datadictionary.idatatype=as_datatype.iid"+
					" left join Ac_consultConfiguration on AC_datadictionary.iid=Ac_consultConfiguration.idatadictionary"+
					" where ctable='"+params.get("ctable")+"' and ifuncregedit="+params.get("ifuncregedit");
			
			hmparam.put("sqlValue", strsql);
			List<?> list = this.queryForList("AcDatadictionaryDest.getList", hmparam);
			
			if(list.size() == 0) return "";
			
			rstr = onGetSql(list);
			
		}
		catch(Exception ex){
			ex.printStackTrace();
		}
		finally{
			hmparam.clear();
		}
				
		return rstr;
	}
	
	
	/**
	 * 	函数名称:	onGetSql
	 *  函数说明:	依据传入的数据字典List拼接sql
	 *  创建人  :	YJ
	 *  创建日期:	2012-02-07
	 *  @param 		list 读取数据字典的List
	 *  @return 	拼接后的sql
	 */
	@SuppressWarnings("rawtypes")
	private String onGetSql(List<?> list){
		String rstr = "";
		int tableNumber = 1;//参照表个数
		String sql = "select ";//临时记载SQL
		String rsql = "";//承载SQL右边部分
		String tsql = " from ";//承载主表表名
		
		try{
			for(int i=0;i<list.size();i++){
				
				@SuppressWarnings("unchecked")
				HashMap<Object,Object> record = (HashMap<Object, Object>)list.get(i);//获取一条记录
				
				String iid	  		= record.get("iid").toString();//主键
				String ctable 		= record.get("ctable").toString();//表名
				String cfield 		= record.get("cfield").toString();//字段名
				String consulttable = record.get("cconsulttable")==null?"":record.get("cconsulttable").toString();//参照表名
				String consultswfld = record.get("cconsultswfld")==null?"":record.get("cconsultswfld").toString();//参照返回显示字段
				String consultbkfld = record.get("cconsultbkfld")==null?"":record.get("cconsultbkfld").toString();//参照返回存入字段
				String iconsult		= record.get("iconsult")==null?"":record.get("iconsult").toString();//参照内码
				
				
				if(!consulttable.equals("")){
					
					//查询参照对应的参照字段
					List<?> cflist = onGetConsultFieldList(Integer.parseInt(iconsult));
					
					if(null != cflist && cflist.size() >0){
						
						for(int j=0;j<cflist.size();j++){
							
							HashMap item = (HashMap) cflist.get(j);
							String confield = item.get("cfield")+"";//参照字段
							
							//参照表1_UI字段内码.参照显示字段名 as 参照表1_UI字段内码_参照显示字段名
							//sql +=  consulttable+tableNumber+"_UI"+iid+"."+confield +" as "+consulttable+tableNumber+"_UI"+iid+"_"+confield+",";
							sql +=  consulttable+tableNumber+iid+"."+confield +" as "+consulttable+tableNumber+iid+"_"+confield+",";
							
						}
						
					}
					else{
						//sql +=  consulttable+tableNumber+"_UI"+iid+"."+consultswfld +" as "+consulttable+tableNumber+"_UI"+iid+"_"+consultswfld+",";
						sql +=  consulttable+tableNumber+iid+"."+consultswfld +" as "+consulttable+tableNumber+iid+"_"+consultswfld+",";
					}
					
//					rsql += " left join " + consulttable + " "+consulttable+tableNumber+"_UI"+iid;
//					rsql += " on " + ctable +"."+cfield+"="+consulttable+tableNumber+"_UI"+iid+"."+consultbkfld;
					rsql += " left join " + consulttable + " "+consulttable+tableNumber+iid;
					rsql += " on " + ctable +"."+cfield+"="+consulttable+tableNumber+iid+"."+consultbkfld;
					
					tableNumber++;
				}
				
//				sql += ctable+"."+cfield+" as "+cfield+"_UI"+iid+",";
				sql += ctable+"."+cfield+" as "+cfield+iid+",";
				if(i==0) tsql += ctable;
				
			}
			sql = sql.substring(0, sql.lastIndexOf(",")) + tsql;
			sql += rsql;
			rstr = sql;
			
			//System.out.println(rstr);
		}
		catch(Exception ex){
			ex.printStackTrace();
		}
		
		return rstr;
		
	}
	
	
	/**
	 * 	函数名称:	onAnalysisFixValue
	 *  函数说明:	解析固定枚举值
	 *  创建人  :	YJ
	 *  创建日期:	2012-02-07
	 *  @param 		fixvalue 固定枚举值(0:男,1:女,2:未知)
	 *  @return    拼接后的Sql(case sex when 0 then '男')
	 */
	@SuppressWarnings("unused")
	private String onAnalysisFixValue(String cfield,String fixvalue){
		String rstr = "";
		
		try{
			rstr = " case "+cfield+" when ";
			
			String[] s = fixvalue.split(",");
			for(int i=0;i<s.length;i++){
				String[] s2 = s[i].split(":");
				String key 	 = s2[0];
				String value = s2[1];
				
				rstr += key +" then '"+value+"'";
			}
			rstr += " end "+cfield+",";
			
			
		}catch(Exception ex){
			ex.printStackTrace();
		}
		
		return rstr;
	}
	
	/**
	 * 获取参照对应的显示字段信息
	 * @param iconsult	参照内码
	 * @return List
	 */
	@SuppressWarnings("rawtypes")
	private List onGetConsultFieldList(int iconsult){
		
		List rlist = null;
		String strsql = "";
		HashMap<String,Object> hm = new HashMap<String,Object>();
		
		try{
			
			strsql = "select iid,iconsult,cfield,cnewcaption from ac_consultclm where iconsult="+iconsult+" and bshow=1";
			hm.put("sqlValue", strsql);
			rlist = this.queryForList("AcDatadictionaryDest.getList",hm);
			
		}catch(Exception ex){
			ex.printStackTrace();
		}finally{
			hm.clear();
			strsql = "";
		}
		
		return rlist;
		
	}
	
//	public static void main(String args[]){
//		HashMap hm = new HashMap();
//		hm.put("ctable", "cs_customer");
//		hm.put("ifuncregedit", 44);
//		AcDatadictionaryImpl ai = new AcDatadictionaryImpl();
//		System.out.println(ai.createListSql(hm));
//	}
	
}
