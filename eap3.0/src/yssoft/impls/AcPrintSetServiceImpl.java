/**
 * 模块名称：AcPrintSetServiceImpl
 * 模块说明：业务数据访问类
 * 创建人：	YJ
 * 创建日期：20110810
 * 修改人：
 * 修改日期：
 * 
 */

package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IAcPrintSetService;
import yssoft.vos.AcPrintSetVO;

import java.io.File;
import java.util.HashMap;
import java.util.List;

@SuppressWarnings("serial")
public class AcPrintSetServiceImpl extends BaseDao implements IAcPrintSetService {

	@Override
	public Object addAcPrintSet(AcPrintSetVO acprintsetvo) throws Exception {
		
		return this.insert("AcPrintSetDest.addPrintSet", acprintsetvo);
	}

	@Override
	public Object deleteAcPrintSet(int iid) throws Exception {
		
		return this.delete("AcPrintSetDest.deletePrintSet", iid);
	}

	@SuppressWarnings({ "rawtypes" })
	@Override
	public List getDataByIfuncregedit(int condition) {

		return this.queryForList("AcPrintSetDest.getListByIfuncregeit", condition);
	}

	@SuppressWarnings({ "unchecked", "rawtypes" })
	@Override
	public List<HashMap> getMenuList() {
		
		return this.queryForList("AcPrintSetDest.getMenuList");
	}

	@Override
	public Object updateAcPrintSet(AcPrintSetVO acprintsetvo) throws Exception {

		return this.update("AcPrintSetDest.updatePrintSet", acprintsetvo);
	}

    @SuppressWarnings({ "unchecked", "rawtypes" })
	public List<HashMap> get_bywhere_ac_printsets(String condition)
    {
           return this.queryForList("get_bywhere_ac_printsets",condition);
    }
    @SuppressWarnings("rawtypes")
	public int add_ac_printsets(HashMap vo_ac_printsets)
    {
           return Integer.valueOf(this.insert("add_ac_printsets",vo_ac_printsets).toString());
    }
    @SuppressWarnings("rawtypes")
	public int update_ac_printsets(HashMap vo_ac_printsets)
    {
           return this.update("update_ac_printsets",vo_ac_printsets);
    }
    public int delete_bywhere_ac_printsets(String condition)
    {
           return this.delete("delete_bywhere_ac_printsets",condition);
    }
    
    @SuppressWarnings({ "rawtypes", "unchecked" })
	public List<HashMap> get_bywhere_ac_printclm(String condition)
    {
           return this.queryForList("get_bywhere_ac_printclm",condition);
    }
    @SuppressWarnings("rawtypes")
	public int add_ac_printclm(HashMap vo_ac_printclm)
    {
           return Integer.valueOf(this.insert("add_ac_printclm",vo_ac_printclm).toString());
    }
    @SuppressWarnings("rawtypes")
	public int update_ac_printclm(HashMap vo_ac_printclm)
    {
           return this.update("update_ac_printclm",vo_ac_printclm);
    }
    public int delete_bywhere_ac_printclm(String condition)
    {
           return this.delete("delete_bywhere_ac_printclm",condition);
    }
    
    @SuppressWarnings({ "rawtypes", "unused" })
	public Boolean mathFile(HashMap param){
    	String fileName = param.get("fileName")+"";
    	String oldFileName = param.get("oldFileName")+"";
    	
    	//YJ Modify 20120806 获取上传路径
    	String filePath = this.getClass().getResource("").getFile();
    	filePath = filePath.substring(0, filePath.indexOf("webapps"))+"webapps/printmodel";
        //filePath = "D:\\apache-tomcat-7.0.26\\webapps\\printmodel";
    	filePath = filePath.replaceAll("%20", " ");
		
    	String realFile = filePath+"/"+fileName;
    	List list = query_ac_printset_ctemplate();
    	java.util.Iterator it = list.iterator();
    	String outFileName = "";
    	// wtf modify 直接删除
    	try{
	    	File file = new File(realFile);
	    	file.delete();
    	}catch (Exception e) {
			return true;
		}
    	//wtf end;
//    	while(it.hasNext()){
//    		HashMap file = (HashMap) it.next();
//    		String name = file.get("ctemplate")+"";
//    		if(name.equals(fileName)){
//    			outFileName = name;
//    		}
//    		if(name.equals(fileName) && (!name.equals(oldFileName))) {
//    		
////    			return false;
//    			File file1 = new File(realFile);
//               	file1.delete();
//               	return true;
//    		}
//    	}
//    	if(!"".equals(outFileName)){
//    		File file = new File(realFile);
//           	file.delete();
//    	}
    	
    	return true;
    }
    
    @SuppressWarnings("rawtypes")
	public List query_ac_printset_ctemplate(){
    	
    	return this.queryForList("query_ac_printset_ctemplate");
    }
}
