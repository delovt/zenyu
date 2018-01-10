package yssoft.impls;

import yssoft.daos.BaseDao;

import java.util.HashMap;

/**
 * 客户分配业务处理
 * @author Administrator
 *
 */
@SuppressWarnings("serial")
public class AssignCustomerImpl extends BaseDao{

	public AssignCustomerImpl(){}
	
	/**
	 * 客户分配
	 * @param params
	 * 		   1、客户内码字符串
	 * 		   2、新业务人员内码及对应的权限操作
	 * 		   3、新服务人员内码及对应的权限操作
	 */
	public String onAssignCustomer(HashMap<String,Object> params){
		
		String strsql = "";
		String rvalue = "分配成功!";
		HashMap<String,Object> hm = new HashMap<String,Object>();
		
		try{
			
			strsql = "exec p_updatedataauth '"+ params.get("cusiids")+"','"+params.get("busperson")+"','"+params.get("serperson")+"'";
			hm.put("sqlValue", strsql);
			this.queryForList("AssignCustomerDest.Search",hm);
			
		}catch(Exception ex){
			ex.printStackTrace();
			rvalue = "分配失败!";
		}finally{
			hm.clear();
			strsql = "";
		}
		
		return rvalue;
	}
	
	/**
	 * 获取参照信息
	 * @return
	 */
	@SuppressWarnings("rawtypes")
	public HashMap queryConsult(){
		return (HashMap) this.queryForObject("AssignCustomerDest.queryConsult");
	}
}
