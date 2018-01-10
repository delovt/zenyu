package yssoft.views;

import yssoft.services.IAS_fcrelation;
import yssoft.utils.ToXMLUtil;

import java.util.HashMap;
import java.util.List;
/**
 * 注册表
 * 相关对象
 * @author 孙东亚
 *
 */
public class As_fcrelationView {
	
	private IAS_fcrelation aS_fcrelationService;

	public void setaS_fcrelationService(IAS_fcrelation aS_fcrelationService) {
		this.aS_fcrelationService = aS_fcrelationService;
	}


	public List  getAs_fcrelation(HashMap params)
	{
		return aS_fcrelationService.getAs_fcrelation(params);
		
	}
	//wtf add 为了使右边栏刷新能够正常
	public HashMap getAs_fcrelation1(HashMap params){
		HashMap result = new HashMap();
		result.put("resultList", aS_fcrelationService.getAs_fcrelation(params));
		return result;
	}
	public String addAs_fcrelation(List list)
	{
		 try {
			 for(int i =0;i< list.size();i++){
					HashMap params  = (HashMap)list.get(i);
					aS_fcrelationService.addAs_fcrelation(params);
			 }
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}
		return "success";
		
	}
	
	public String deleteAs_fcrelation(HashMap params)
	{
		 try {
			aS_fcrelationService.deleteAs_fcrelation(params);
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}
		return "success";
	}
	
	@SuppressWarnings("unchecked")
	public String updateAs_fcrelation(List list)
	{
		try {
			
			for(int i =0;i< list.size();i++){
				HashMap params  = (HashMap)list.get(i);
				aS_fcrelationService.updateAs_fcrelation(params);
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}
		return "success";
		
	}
	
	/**
	 * 获取相关对象树
	 * @return
	 */
	public String  getAs_fcrelation_tree() {
		
		String result = ToXMLUtil.createTree(aS_fcrelationService.getAs_fcrelation_tree(), "iid","ipid","-1");
		return result ;
	}
	
	
	public List queryTableField(String ifuncregit){
		return aS_fcrelationService.queryTableField(ifuncregit);
	}
	
}
