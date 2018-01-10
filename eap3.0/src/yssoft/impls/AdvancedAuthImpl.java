package yssoft.impls;

import java.util.HashMap;
import java.util.List;
import yssoft.daos.BaseDao;
import yssoft.utils.ToXMLUtil;

@SuppressWarnings("serial")
public class AdvancedAuthImpl extends BaseDao{

	public AdvancedAuthImpl(){}
	
	@SuppressWarnings("rawtypes")
	public HashMap<String,Object> getAllData(){
		
		HashMap<String,Object> rhm = new HashMap<String,Object>();
		HashMap<String,Object> phm = new HashMap<String,Object>();
		String strsql = "";
		
		//获取部门列表
		strsql = "select iid,ipid,ccode,cname from hr_department where isnull(istatus,0)<>2 order by ccode";
		phm.put("sqlValue", strsql);
		List depart = this.queryForList("AdvancedAuthDest.getAllData", phm);
		
		//获取人员
		strsql = "select iid,ccode,cname,idepartment,dbo.FUN_FINDROLEBYPERSON(0,iid) roleid,dbo.FUN_FINDROLEBYPERSON(1,iid) rolename from hr_person ";
		phm.put("sqlValue", strsql);
		List person = this.queryForList("AdvancedAuthDest.getAllData", phm);
		
		rhm.put("departXml", yssoft.utils.ToXMLUtil.createTree(depart, "iid", "ipid", "-1"));
		rhm.put("personXml", ToXMLUtil.createTreeFromList(person));
		
		return rhm;
		
	}
	
	//依据sql查询数据
	@SuppressWarnings("rawtypes")
	public List onGetDataBySql(HashMap pm){
		
		HashMap<String,Object> phm = new HashMap<String,Object>();
		
		String psql = pm.get("csql")+"";
		int outifuncregedit = Integer.parseInt(pm.get("outifuncregedit")+"");
		int iperson = Integer.parseInt(pm.get("iperson")+"");
		String ctable = pm.get("ctable")+"";
		
		String tsql = psql.substring(6, psql.length());
		String sql = "select DBO.FUN_FINDDATAAUTHINFO(0,"+outifuncregedit+","+iperson+","+ctable+".IID) fzperson," +
					 "DBO.FUN_FINDDATAAUTHINFO(1,"+outifuncregedit+","+iperson+","+ctable+".IID) xgperson,"+tsql;
		
		
		phm.put("sqlValue", sql);
		
		List rlist = this.queryForList("AdvancedAuthDest.getAllData", phm);
		
		return rlist;
		
	}
	
	//依据角色获取数据权限信息,主要是取查询、删除、修改的启用权限是什么
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public HashMap onGetDataAuthByIrole(HashMap param){
		
		HashMap phm = new HashMap();
		String strsql = "select '查询：'+dbo.FUN_FINDATAAUTHBYITYPE(substring(as_dataauth.cdatavalue,2,1))+' | '+" +
							   "'修改：'+dbo.FUN_FINDATAAUTHBYITYPE(substring(as_dataauth.cdatavalue,3,1))+' | '+" +
							   "'删除：'+dbo.FUN_FINDATAAUTHBYITYPE(substring(as_dataauth.cdatavalue,4,1)) info from as_dataauth " +
							   " where irole="+param.get("irole")+" and ifuncregedit="+param.get("ifun");
		
		phm.put("sqlValue", strsql);
		
		return (HashMap)this.queryForObject("AdvancedAuthDest.getAllData", phm);
		
	}
	
}
