package yssoft.impls;

import yssoft.daos.BaseDao;

import java.util.HashMap;

public class ProjectImpl extends BaseDao {
	public void updateSrProjectFfact(HashMap param){
		String iproject = param.get("iproject")+"";
		HashMap sql = new HashMap();
		String sqlValue="update sr_project set ffact=(select sum(fworkday) fworkday from sr_projects where iproject=sr_project.iid group by iproject) where iid="+iproject;
		sql.put("sqlValue", sqlValue);
		try{
			this.update("project_update_ffact",sql);
		}catch(Exception e){
			e.printStackTrace();
		}
	}
	
}
