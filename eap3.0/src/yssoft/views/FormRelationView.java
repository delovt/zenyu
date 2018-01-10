package yssoft.views;

import org.apache.log4j.Logger;
import org.jfree.util.Log;
import yssoft.services.IFormRelationService;
import yssoft.utils.ToXMLUtil;

import java.util.HashMap;
import java.util.List;

public class FormRelationView {
	
	private Logger logger=Logger.getLogger(FormRelationView.class);
	
	private IFormRelationService iFormRelationService;

	public void setiFormRelationService(IFormRelationService iFormRelationService) {
		this.iFormRelationService = iFormRelationService;
	}
	
	
	public String getTables(){
		List list = this.iFormRelationService.getTables();
		return ToXMLUtil.createTree(list,"iid","ipid","-1");
	}
	public List<?> getTableFields(HashMap<?, ?> params){
		logger.info("---获取表对应的字段信息，执行[getTableFields]---");
		return this.iFormRelationService.getTableFields(params);
	}
	
	public String addFormRaletion(List<HashMap<?,?>> list){
		try{
			for(HashMap<?,?> item : list){
				
				Log.info(""+item.get("ifuniid1").toString());
				Log.info(""+item.get("ifuniid2").toString());
				Log.info(""+item.get("bpush").toString());
				Log.info(""+item.get("bpull").toString());
				Log.info(""+item.get("cmemo").toString());
				
				List<HashMap<?,?>> fieldList = (List<HashMap<?,?>>) item.get("fildlist");
				int irsiid=this.iFormRelationService.insertFormRelation(item);
				if(fieldList != null && fieldList.size() !=0){
					for(HashMap frfield : fieldList){
						frfield.put("irsiid",irsiid);
						this.iFormRelationService.insertFormFields(frfield);
					}
				}
			}
			return "suc";
		}catch(Exception e){
			e.printStackTrace();
			Log.error("添加单据与单据对应关系出错");
			return "保存失败，写入数据出错";
		}
		//return "保存失败，传入参数出错";
	}
	
}
