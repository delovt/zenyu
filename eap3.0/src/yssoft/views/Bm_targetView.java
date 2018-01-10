package yssoft.views;
/**
 * 
 * 项目名称：yssoft
 * 类名称：AC_fieldsView
 * 类描述：AC_fieldsView视图 
 * 创建人：刘磊
 * 创建时间：2012-2-9 11:48:30
 * 修改人：刘磊
 * 修改时间：2012-2-9 11:48:30
 * 修改备注：无
 * @version 1.0
 * 
 */

import yssoft.services.Ibm_targetService;
import yssoft.utils.ToXMLUtil;
import yssoft.vos.BmTargetVO;

import java.util.List;

public class Bm_targetView {
	private Ibm_targetService ibm_targetService;
	
    public void setIbm_targetService(Ibm_targetService ibm_targetService) {
		this.ibm_targetService = ibm_targetService;
	}
	
    public String get_all_bm_target(){
		
    	List funLi1st = this.ibm_targetService.get_all_bm_target();
		if(funLi1st!=null&&funLi1st.size()>0)
		{
			 return ToXMLUtil.createTree(funLi1st, "iid", "ipid", "-1");
		}
		return null;
	}
    
    public String add_bm_target(BmTargetVO bmTargetVO){
		String result ="sucess";
		try{
			
			//保存功能注册信息
			Object resultObj = this.ibm_targetService.add_bm_target(bmTargetVO);
			result = resultObj.toString();
		}
		catch(Exception ex){
			result ="fail";
		}
		
		return result;
	}
    
    public String update_bm_target(BmTargetVO bmTargetVO){
		String result ="sucess！";
		try{
			
			//保存功能注册信息
			@SuppressWarnings("unused")
			Object resultObj = this.ibm_targetService.update_bm_target(bmTargetVO);
		}
		catch(Exception ex){
			result ="fail";
		}
		
		return result;
	}
    
    public String delete_bm_target_byiid(int iid){
		String result ="sucess";
		try{
			
			//保存功能注册信息
			@SuppressWarnings("unused")
			Object resultObj = this.ibm_targetService.delete_bm_target_byiid(iid);
		}
		catch(Exception ex){
			result ="fail";
		}
		
		return result;
	}
    
}