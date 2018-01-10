/**    
 *
 * 文件名：Test.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-9-24    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.views;

import yssoft.utils.ToolUtil;
import yssoft.vos.HrPersonVo;

import java.util.Date;
import java.util.HashMap;
import java.util.List;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：Test    
 * 类描述：    
 * 创建人：朱毛毛 
 * 创建时间：2011-2011-9-24 下午02:38:50        
 *     
 */
public class Test {

	/**    
	 *  
	 * main(这里用一句话描述这个方法的作用)
	 * 创建者：Administrator
	 * 创建时间：2011-2011-9-24 下午02:38:50
	 * 修改者：Administrator
	 * 修改时间：2011-2011-9-24 下午02:38:50
	 * 修改备注：   
	 * @param   name       
	 * @return void
	 * @Exception 异常对象    
	 * 
	 */
	
	public String combiSql(List list,String table,String value,String key){
		if(key==null){
			key="iid";
		}
		if(list == null || list.size()==0){
			return "";
		}
		String sql="";
		int len=list.size();
		for (int i=0;i<len;i++){
			HashMap map=(HashMap) list.get(i);
			String candor=(String) map.get("candor");
			String cleftbk=(String) map.get("cleftbk");
			String cfield=(String) map.get("cfield");
			String coperator=(String) map.get("coperator");
			String cvalue=(String) map.get("cvalue");
			String crightbk=(String) map.get("crightbk");
			
			if("like".equals(coperator)){
				cvalue = "'%"+cvalue+"%'";
			}
			
			String str= candor+" "+cleftbk+" "+cfield+" "+coperator+" '"+cvalue+"' "+crightbk;
			sql +=str;
		}
		sql = "select count(*) from "+table+" where "+key+"='"+value+"' "+sql;
		return sql;
	}
	public String combiEntrySql(List list,String table,String value,String other,String key){
		if(key==null){
			key="iid";
		}
		if(list == null || list.size()==0){
			return "";
		}
		String sql="";
		
		int len=list.size();
		for (int i=0;i<len;i++){
			HashMap map=(HashMap) list.get(i);
			String cfield=(String) map.get("cfield");
			String cvalue=(String) map.get("cvalue");
			
			sql +=" "+cfield+"='"+setFieldValue(cvalue,other)+"',";
		}
		// 除去最后一个 逗号
		sql=sql.substring(0,sql.lastIndexOf(","));
		sql = "update "+table+" set "+sql+" where "+key+"='"+value+"'";
		return sql;
	}
	// 字段赋值
	public String setFieldValue(String valueType,String other){
		HrPersonVo person=new HrPersonVo();
		String val="";
		if("kong".equals(valueType)){
			val="";
		}else if("iperson".equals(valueType)){
			val=""+person.getIid();
		}else if("idepartment".equals(valueType)){
			val=""+person.getIdepartment();
		}else if("cperson".equals(valueType)){
			val=person.getCname();
		}else if("cdepartment".equals(valueType)){
			val=person.getDepartcname();
		}else if("cmessage".equals(valueType)){
			val=other;
		}else if("cresult".equals(valueType)){
			val=other;
		}else if("hand".equals(valueType)){
			val=other;
		}else if("ddate".equals(valueType)){
			val=ToolUtil.formatDay(new Date(),null);
		}else if("booltrue".equals(valueType)){
			val="true";
		}else if("boolfalse".equals(valueType)){
			val="false";
		}
		return val;
	}
	
	
	public static void main(String[] args) {
		System.out.println((new Date()).getTime());
	}

}
