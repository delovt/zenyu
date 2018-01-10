package yssoft.views;


import yssoft.services.IAC_fieldsService;
import yssoft.services.IAC_tableService;

import java.util.HashMap;
import java.util.List;
public class AC_tableView {
	private IAC_tableService i_AC_tableService;
	public void seti_AC_tableService(IAC_tableService i_AC_tableService) {
		this.i_AC_tableService = i_AC_tableService;
	}
	
	private IAC_fieldsService i_AC_fieldsService;
	public void seti_AC_fieldsService(IAC_fieldsService i_AC_fieldsService) {
		this.i_AC_fieldsService = i_AC_fieldsService;
	}
         public List<HashMap> get_bywhere_AC_table(String condition)
         {
               try
       		   {
        		   return this.i_AC_tableService.get_bywhere_AC_table(condition);
		       }
		       catch(Exception e)
		       {
		           return null;
		       }         
         }
         //添加表头表体
         public String Add_All(HashMap obj)
         {
        	 try {
        		    HashMap head=(HashMap)obj.get("head");
        			this.i_AC_tableService.add_AC_table(head);
        			
        			return "sucess";
        	 }
        	 catch (Exception e) {
     			return "false";
     		}
         }
         //更新表头表体
         public String Update_All(HashMap obj)
         {
        	 try {
        		 	Object o_sql=obj.get("sql");
        		 	if(o_sql!=""){
        		 		HashMap<String, Object> hs = new HashMap<String, Object>();
        		 		hs.put("sqlValue", String.valueOf(o_sql));
        		 		this.i_AC_fieldsService.executeSqlList(hs);
        		 	}
        		    HashMap headobj=(HashMap)obj.get("head");
        		    Object itable=headobj.get("iid");
        		    HashMap head=new HashMap();
        		    head.put("ctable",headobj.get("name"));
        		    head.put("ccaption",headobj.get("ccaption"));
        		    head.put("cmemo",headobj.get("cmemo"));
        		    List<HashMap> bodyobj=(List<HashMap>)obj.get("body");
        		    List<HashMap> old_bodyobj=(List<HashMap>)obj.get("old_body");
        		    List<HashMap> del_bodyobj=(List<HashMap>)obj.get("delfieldArr");
        		    String childInsertSql="";
        		    //更新表头
        			if (this.update_AC_table(head)=="sucess")
        			{
        				//更新表体
        				for (HashMap body : bodyobj) {
        					if(body.get("iid")!=""){
        						this.i_AC_fieldsService.update_AC_fields(body);
        					}else{
        						String sql="insert into ac_fields values( "+itable+",'"+String.valueOf(body.get("cfield"))+"','"+String.valueOf(body.get("ccaption"))+"',"+String.valueOf(body.get("cmemo"))+","+body.get("idatatype")+","+body.get("ilength")+",";
        						String bempty="0";
        						if((Boolean)body.get("bempty")){
        							bempty="1";
        						}
        						String bkey="0";
        						if((Boolean)body.get("bkey")){
        							bkey="1";
        						}
        						sql=sql+bempty+","+bkey+")";
        						childInsertSql=childInsertSql+sql+";";
        						HashMap<String, Object> hs = new HashMap<String, Object>();
        						hs.put("sqlValue",childInsertSql);
        						this.i_AC_fieldsService.executeSqlList(hs);
        					}
                           
						}
        				HashMap<String, Object> hs = new HashMap<String, Object>();
        				hs=createChangeSql(String.valueOf(headobj.get("name")),old_bodyobj,bodyobj);
        				this.i_AC_fieldsService.executeSqlList(hs);
        				
        				if(del_bodyobj.size()>0){
	        				HashMap<String, Object> hs_drop = new HashMap<String, Object>();
	        				hs_drop=dropColumnSql(String.valueOf(headobj.get("name")),del_bodyobj);
	        				this.i_AC_fieldsService.executeSqlList(hs_drop);
        				}
        			}
        			else
        			{
             			return "false";
        			}
        			
        			return "sucess";
        	 }
        	 catch (Exception e) {
     			return "false";
     		}
         }
         
         /**
          * 功能：生成删除表字段的sql
          * 作者:XZQWj
          * 时间:2013-02-03
          * @param tablename
          * @param del_body
          * @return
          */
         public HashMap<String, Object> dropColumnSql(String tablename,List<HashMap> del_body){
        	 HashMap<String, Object> hs = new HashMap<String, Object>();
        	 String exec_sql="";
        	 for (HashMap body : del_body) {
        		 String sql="Alter table "+tablename+" drop column "+body.get("cfield");
        		 String del_sql="delete ac_fields where iid="+body.get("iid");
    			 exec_sql=exec_sql+sql+";"+del_sql+";";
        	 }
        	 hs.put("sqlValue", exec_sql);
        	 return hs;
         }
         /**
          * 功能：生成修改物理表属性的sql
          * 作者：XZQWJ
          * 时间:2013-02-02
          * @param tablename 新表名
          * @param old_body 修改前数据
          * @param new_body 修改后数据
          * @return
          */
         public HashMap<String, Object> createChangeSql(String tablename,List<HashMap> old_body,List<HashMap> new_body){
        	 HashMap<String, Object> hs = new HashMap<String, Object>();
        	 String exec_sql="";
        	 for (HashMap body : new_body) {
        		 String datatype=getdatatype(String.valueOf(body.get("idatatype")));
        		 if(body.get("iid")==""){
        			 String sql="Alter table "+tablename+" add "+body.get("cfield")+" "+datatype;
        			 if(!datatype.equals("int")&&!datatype.equals("bit")&&!datatype.equals("datetime")){
	        				sql=sql+"("+body.get("ilength")+") ";
	        			}
        			 if((Boolean)body.get("bempty")){
	        				sql=sql+" null";
	        			}else{
	        				sql=sql+" not null";
	        			}
        			 exec_sql=exec_sql+sql+";";
//        			 continue;
        		 }
        		 for (HashMap hs_old : old_body) {
	        		if(String.valueOf(body.get("iid")).equals(String.valueOf(hs_old.get("iid")))&&String.valueOf(body.get("cfield"))!="iid"){
	        			if(!String.valueOf(body.get("cfield")).equals(String.valueOf(hs_old.get("cfield")))){
	        				String sql="exec sp_rename '"+tablename+"."+hs_old.get("cfield")+"','"+body.get("cfield")+"'";
	        				exec_sql=exec_sql+sql+";";
	        			}
	        			
	        			
	        			String sql="Alter table "+tablename+" alter column "+body.get("cfield")+" "+datatype;
	        			if(!datatype.equals("int")&&!datatype.equals("bit")&&!datatype.equals("datetime")){
	        				sql=sql+"("+body.get("ilength")+") ";
	        			}
	        			
	        			if((Boolean)body.get("bempty")){
	        				sql=sql+" null";
	        			}else{
	        				sql=sql+" not null";
	        			}
	        			exec_sql=exec_sql+sql+";";
	        		}
        		 }
        	 }
        	 
        	 hs.put("sqlValue", exec_sql);
        	 return hs;
         }
         
         public String getdatatype(String cdatatype){
        	 String datatype="";
        	 switch(Integer.parseInt(cdatatype)){
        	 case 0:
        		 datatype="nvarchar";
        		 break;
        	 case 1:
        		 datatype="int";
        		 break;
        	 case 2:
        		 datatype="float";
        		 break;
        	 case 3:
        		 datatype="datetime";
        		 break;
        	 case 4:
        		 datatype="bit";
        		 break;
        	 case 5:
        		 datatype="text";
        		 break;
        	 }
        	 return datatype;
         }
         
         public String del_AC_table(HashMap hs){
        	 String result = "sucess"; 
        	 try {
				this.i_AC_fieldsService.executeSqlList(hs);
			} catch (Exception e) {
				// TODO Auto-generated catch block
				result = "fail";
			}
        	 return result;
         }
         public String add_AC_table(HashMap vo_AC_table)
         {
               String result = "sucess";
               try
       		   {
        		  Object resultObj = this.i_AC_tableService.add_AC_table(vo_AC_table);
        		  result = resultObj.toString();
		       }
		       catch(Exception e)
		       {
		          result = "fail";
		       }         
		       return result;
         }
         public String update_AC_table(HashMap vo_AC_table)
         {
               String result = "sucess";
               try
       		   {
        		   int count = this.i_AC_tableService.update_AC_table(vo_AC_table);
//        		   if(count!=1)
//			       {
//				       result = "fail";
//                   }
		       }
		       catch(Exception e)
		       {
		           result = "fail";
		       }
		       return result;
         }
         public String delete_bywhere_AC_table(String condition)
         {
               String result = "sucess";
               try
       		   {
        		   int count = this.i_AC_tableService.delete_bywhere_AC_table(condition);
        		   if(count!=1)
			       {
				       result = "fail";
                   }
		       }
		       catch(Exception e)
		       {
		           result = "fail";
		       }
		       return result;
         }
         public String pr_updatedatadic()
         {
             String result = "sucess";
        	 try
        	 {
        	     if (!this.i_AC_tableService.pr_updatedatadic())
        	     {
        	         result = "fail"; 
        	     }
        	 }
        	 catch(Exception e)
		     {
        	     result = "fail";
		     }
        	 return result;
         }
}