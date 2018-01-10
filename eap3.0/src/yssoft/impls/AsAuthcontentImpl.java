/**
 * 模块名称：AsAuthcontentImpl
 * 模块说明：权限设置业务操作
 * 创建人：	YJ
 * 创建日期：20111005
 * 修改人：
 * 修改日期：
 * 
 */

package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.utils.ToXMLUtil;

import java.util.HashMap;
import java.util.List;

@SuppressWarnings("serial")
public class AsAuthcontentImpl extends BaseDao {

	
	/**
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public String getTreeMenuList(){
		
		List<HashMap> list = this.queryForList("AuthcontentDest.getTreeMenu");
		String treeXml = "";
		
		//转换为树结构
		if(list.size()>0){
			treeXml = ToXMLUtil.createTree(list, "iid", "ipid", "-1");
		}
		return treeXml;
	}
	
	
	@SuppressWarnings("unchecked")
	public List getDataList(HashMap paramMap){
		List list = null;
		
		try{
			
			list = this.queryForList("AuthcontentDest.getDataList", paramMap);
			
		}
		catch(Exception ex){
			ex.printStackTrace();
		}
		
		return list;
		
	}
	
	@SuppressWarnings("unchecked")
	public List getLikeList(HashMap paramMap){
		List list = null;
		try{
			list = this.queryForList("AuthcontentDest.getLikeList", paramMap);
		}
		catch(Exception ex){
			ex.printStackTrace();
		}
		
		return list;
		
	}

    /*
    lc add 20170803
    按人员获取权限内容
     */
    @SuppressWarnings("unchecked")
    public List getLikeListPerson(HashMap paramMap){
        List list = null;
        try{
            list = this.queryForList("AuthcontentDest.getLikeListPerson", paramMap);
        }
        catch(Exception ex){
            ex.printStackTrace();
        }

        return list;

    }
	
	
	@SuppressWarnings("unchecked")
	public String saveAsAuthcontent(HashMap paramMap){
		
		String result = "保存成功！";
		String sql = "";
		
		try{
			
			List datalist = (List)paramMap.get("datalist");
			
			if(datalist.size() >0){
				for (Object dataItem : datalist) {
					HashMap record = (HashMap) dataItem;
					
					sql +=" update as_authcontent set "+					
					" buse="+(((Boolean)record.get("buse")==false)?0:1)+
					", ccaption='"+((record.get("ccaption")==null)?"":record.get("ccaption").toString().trim())+
					"', cmemo='"+((record.get("cmemo")==null)?"":record.get("cmemo").toString().trim())+
					"', cfunction='"+((record.get("cfunction")==null)?"":record.get("cfunction").toString().trim())+
					"', cform='"+((record.get("cform")==null)?"":record.get("cform").toString().trim())+
					"' where  iid="+record.get("iid");
					
				}
			}
			
			System.out.println(sql);
			
			paramMap.put("sqlValue", sql);
			
			this.update("AuthcontentDest.updateAuthcontent", paramMap);
		}
		catch(Exception ex){
			result = "保存失败！";
			ex.printStackTrace();
		} finally {
			
		}
		
		return result;
	}
	
	public String updateAsAuthcontent(){
		
		String result = "写入成功！";
		
		try{
			
			this.queryForList("AuthcontentDest.writeAuthcontent");
		}
		catch(Exception ex){
			result = "写入失败！";
			ex.printStackTrace();
		} finally {
			
		}
		
		return result;
	}
	
	//YJ Add 更多操作中的特殊查询
	public List getListByIfuncregedit(int ifuncregedit){
		
		List list = null;
		
		try{
			
			list = this.queryForList("AuthcontentDest.getListByIfuncregedit", ifuncregedit);
		}
		catch(Exception ex){
			System.out.println(ex.getMessage());
		}
		
		return list;
	}
}
