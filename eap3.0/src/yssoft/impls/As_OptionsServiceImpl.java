package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IAs_OptionsService;

import java.util.HashMap;
import java.util.List;

/**
 * 系统选项实现类
 * @author sdy
 *
 */
public class As_OptionsServiceImpl extends BaseDao implements IAs_OptionsService {

	/**
	 * 安全策略
	 */
	@Override
	public List getOptionsByCclass(HashMap map) {
//		Object list = this.queryForObject("get_as_options_aqcl",map);
		return this.queryForList("get_as_options_aqcl",map);
		
	}
	
	/**
	 * 循环更新系统参数
	 */
	@Override
	public void updateOptions(HashMap map) {
		
		for( Object key : map.keySet())
		{
			HashMap<String,Object> _map = new HashMap<String,Object>();
			
			if(null != key && key.toString().indexOf("_")!=-1){
				String keyStr = key.toString().split("_")[1];
				_map.put("iid",keyStr);
				_map.put("cvalue",map.get("_"+keyStr));
			}
			this.update("update_as_options_aqcl",_map);
		}
	}
	
	
	/**
	 * 获取系统参数根据iid
	 * @param iid
	 * @return
	 */
	public String getSysParamterByiid(int iid){
		return this.queryForObject("select_init_paramter",iid).toString();
	}

	@Override
	public List getOptionAc() {
		return this.queryForList("get_as_options_ac");
	}
	
	
	@Override
	public int InsertCommSessionid(String sql){
	        // TODO Auto-generated method stub
	    	HashMap h=new HashMap();
	    	h.put("sql", sql);
	        int iid=Integer.parseInt(this.insert("commSessionId", h)+"");
	        return iid;
	    }

}
