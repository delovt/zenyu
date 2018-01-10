/**    
 *
 * 文件名：ListsetView.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-8-16    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.views;

import yssoft.services.IAcClasssetService;
import yssoft.utils.ToXMLUtil;

import java.util.HashMap;
import java.util.List;

/**
 * 
 * 项目名称：yscrm 类名称：ClasssetView 类描述： 创建人：XZQWJ 创建时间：2012-10-11
 * 
 */
public class AcClasssetView {
	// private IAcListsetService iAcListsetService;
	private IAcClasssetService iAcClasssetService;

	public void setiAcClasssetService(IAcClasssetService iAcClasssetService) {
		this.iAcClasssetService = iAcClasssetService;
	}


	/**
	 * 
	 * 创建者：XZQWJ 
	 * 创建时间：2012-10-11  
	 * 修改者：
	 * 修改时间：
	 *  修改备注：
	 * 
	 * @return List<HashMap>
	 * @Exception 异常对象
	 * 
	 */
	public String getListcd(HashMap paramObj) {
		List<HashMap> list = this.iAcClasssetService.getListcd(paramObj);
		String treeXml = null;
		if (list.size() > 0) {
			treeXml = ToXMLUtil.createTree(list, "iid", "ipid", "-1");
		}
		return treeXml;
	}
	
	

	/**
	 * 功能：生成分类视图中各个根节点对应的子节点树
	 * 创建者：XZQWJ
	 * 创建日期:2012-10-12
	 * @param iid
	 * @param ipid
	 * @return
	 */
	@SuppressWarnings("unchecked")
	private List<HashMap> getDatadisList(String iid,String ipid){
		
		String[]temp=iid.split("\\.");
		List<HashMap> list = this.iAcClasssetService.getDatadicSql(temp[temp.length-2]);
		String ctreesql = list.get(0).get("ctreesql").toString();
        ctreesql = ctreesql.replace("@cconsultedit", "");

		String tree_sql=null;
		String tree_root=null;
		String tree_child=null;
		String check_sqlString=ctreesql.toString();
		int s_index=check_sqlString.indexOf("cname");
		int l_index=check_sqlString.lastIndexOf("cname");
		if(s_index-l_index!=0){
			String str_cname=check_sqlString.substring(s_index, l_index+5);
			ctreesql=check_sqlString.replace(str_cname, "cname");
		}
		if(check_sqlString.indexOf("where", 0)>0){
//			tree_root=ctreesql.toString().replace("ccode,cname", "\'(\'+ccode+\')\'+cname cname ")+" and ipid=-1";
			tree_root=ctreesql.replace("cname", "1 as def")+" and ipid=-1";
			tree_child=ctreesql.replace("cname", "1 as def")+" and ipid>-1";
		}else{
			tree_root=ctreesql.toString().replace("cname", "1 as def")+" where ipid=-1";
			tree_child=ctreesql.toString().replace("cname", "1 as def")+" where ipid>-1";
		}
		if(check_sqlString.indexOf("*")>0){
			tree_root=tree_root.replace("*", "\'"+iid+".\'"+"+RTrim(LTrim(CAST(iid as char(20)))) iid,"+"\'"+iid+"\'"+" ipid,"+"\'("+"\'+"+"ccode"+"+\')"+"\'+cname cname,");
			tree_child=tree_child.replace("*", "\'"+iid+".\'"+"+RTrim(LTrim(CAST(iid as char(20)))) iid,"+"\'"+iid+".\'"+"+RTrim(LTrim(CAST(ipid as char(20))))ipid,"+"\'("+"\'+"+"ccode"+"+\')"+"\'+cname cname,");
		}else{
			tree_root=tree_root.replace("iid", "\'"+iid+".\'"+"+RTrim(LTrim(CAST(iid as char(20)))) iid").replace("ipid,", "\'"+iid+"\'"+" ipid,"+"\'("+"\'+"+"ccode"+"+\')"+"\'+cname cname,");
			tree_child=tree_child.replace("iid", "\'"+iid+".\'"+"+RTrim(LTrim(CAST(iid as char(20)))) iid").replace("ipid,", "\'"+iid+".\'"+" +RTrim(LTrim(CAST(ipid as char(20))))ipid,"+"\'("+"\'+"+"ccode"+"+\')"+"\'+cname cname,");
		}
		tree_root=tree_root.replace(", from", " from");
		tree_child=tree_child.replace(", from", " from");
		tree_sql="select * from ("+tree_root+" union all " +tree_child+") hr_department order by cname";
		
		HashMap<String, Object> hmparam = new HashMap<String,Object>();
		hmparam.put("sqlValue", tree_sql);
		//得到树型的数据
		List<HashMap> list_child=this.iAcClasssetService.getListcd(hmparam);
		int size=list_child.size();
		Object cgridsql = list.get(0).get("cgridsql");


		Object cconnsql = list.get(0).get("cconnsql");//树和表关联条件
		if(!cgridsql.equals(cconnsql)){
			String str_cgridsql=cgridsql.toString().replace("@join", "").replace("@cconsultedit", "");
			String str_cconnsqlString=cconnsql.toString();
			int like_i=str_cconnsqlString.lastIndexOf("like");
//			int like_i=str_cconnsqlString.lastIndexOf("like");
//			int _i=str_cconnsqlString.lastIndexOf(".");
			String ddString =str_cconnsqlString.substring(0, like_i).replace("ccode", "iid");
			ddString=str_cgridsql+ddString;
			for(int i=0;i<size;i++){
				HashMap<String, Object> hp = new HashMap<String,Object>();
				String l_iid=list_child.get(i).get("iid").toString();
				String[] str_iids=l_iid.split("\\.");
				String p_iid=str_iids[str_iids.length-1];//表的父节点
				String grid_sqlString="";
				grid_sqlString="select "+"\'("+"\'+"+"ccode"+"+\')"+"\'+cname cname,"+"\'"+l_iid+"\'"+" ipid,\'"+l_iid+".\'"+"+RTrim(LTrim(CAST(iid as char(20)))) iid  from ("+ddString+"="+p_iid+" ) aa";
				System.out.println(grid_sqlString);
				hp.put("sqlValue", grid_sqlString);
				List<HashMap> list_grid=this.iAcClasssetService.getListcd(hp);
				if(!list_grid.isEmpty()){
					list_child.addAll(list_grid);
				}
			}
			
		}
		
		list.addAll(list_child);
		return list_child;
	}
	
	
	/**
	 * 功能：构成分类视图树
	 * 创建者：XZQWJ
	 * 创建日期:2012-10-12
	 * @param paramObj
	 * @return
	 */
	public String getListcdList(HashMap paramObj) {
		List<HashMap> list = this.iAcClasssetService.getListcd2(paramObj);
		List<HashMap> treeList = list ;
		if (list != null && list.size() > 0) {
			int size=list.size();
			for (int i = 0; i < size; i++) {
				HashMap parMap = list.get(i);

				String iid=parMap.get("iid").toString();
				String ipid=parMap.get("ipid").toString();
				treeList.addAll(getDatadisList(iid,ipid));
			}

		}

		String treeXml = null;
		if(treeList.size()>0){
			treeXml = ToXMLUtil.createTree(treeList, "iid", "ipid", "-1").replace("<root>", "").replace("</root>", "");
		}

		return treeXml;
	}

}
