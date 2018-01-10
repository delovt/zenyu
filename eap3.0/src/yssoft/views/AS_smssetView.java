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
import java.util.HashMap;
import java.util.List;

import yssoft.services.Ias_smssetService;
import yssoft.utils.DesEncryptUtil;
import yssoft.utils.ToXMLUtil;
import yssoft.vos.AsSmssetVO;

public class AS_smssetView {
	private Ias_smssetService ias_smssetService;
	
    public void setias_smssetService(Ias_smssetService ias_smssetService) {
		this.ias_smssetService = ias_smssetService;
	}
	
    public String get_all_as_smsset(){
		
    	List<HashMap> funLi1st = this.ias_smssetService.get_all_as_smsset();
		if(funLi1st!=null&&funLi1st.size()>0)
		{
			for(int i=0; i < funLi1st.size(); i++) {
				funLi1st.get(i).put("cpassword", DesEncryptUtil.decodeDes(funLi1st.get(i).get("cpassword").toString(), DesEncryptUtil.DEFAULT_KEY));
			}
			return ToXMLUtil.createTree(funLi1st, "iid", "ipid", "-1");
		}
		return null;
	}
    
    public String add_as_smsset(AsSmssetVO asSmssetVO){
		String result ="sucess";
		asSmssetVO.cpassword = DesEncryptUtil.encodeDes(asSmssetVO.cpassword, DesEncryptUtil.DEFAULT_KEY);
		try{
			
			//保存功能注册信息
			Object resultObj = this.ias_smssetService.add_as_smsset(asSmssetVO);
			result = resultObj.toString();
		}
		catch(Exception ex){
			result ="fail";
		}
		
		return result;
	}
    
    public String update_as_smsset(AsSmssetVO asSmssetVO){
		String result ="sucess！";
		asSmssetVO.cpassword = DesEncryptUtil.encodeDes(asSmssetVO.cpassword, DesEncryptUtil.DEFAULT_KEY);
		try{
			
			//保存功能注册信息
			@SuppressWarnings("unused")	
			Object resultObj = this.ias_smssetService.update_as_smsset(asSmssetVO);

		}
		catch(Exception ex){
			result ="fail";
		}
		
		return result;
	}
    
    public String delete_as_smsset_byiid(int iid){
		String result ="sucess";
		try{
			
			//保存功能注册信息
			@SuppressWarnings("unused")
			Object resultObj = this.ias_smssetService.delete_as_smsset_byiid(iid);

		}
		catch(Exception ex){
			result ="fail";
		}
		
		return result;
	}
    
}