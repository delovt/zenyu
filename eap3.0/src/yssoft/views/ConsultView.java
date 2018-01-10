/**    
 *
 * 文件名：ConsultView.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-8-12    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.views;

import yssoft.consts.SysConstant;
import yssoft.daos.BaseDao;
import yssoft.services.IAcConsultService;
import yssoft.utils.ToXMLUtil;
import yssoft.vos.AcConsultclmVo;
import yssoft.vos.AcConsultsetVo;

import java.util.HashMap;
import java.util.List;

/**
 * 
 * 项目名称：yscrm 类名称：ConsultView 类描述： 创建人：刘磊 创建时间：2011-2011-8-12 下午03:12:30
 * 
 */
public class ConsultView {
	private static final String HashMap = null;
	private BaseDao mydao;
	public BaseDao getMydao() {
		return mydao;
	}

	public void setMydao(BaseDao mydao) {
		this.mydao = mydao;
	}

	// 视图层的业务层
	private IAcConsultService iAcConsultService;

	public void setiAcConsultService(IAcConsultService iAcConsultService) {
		this.iAcConsultService = iAcConsultService;
	}

	/**
	 * 
	 * @see yssoft.services.IAcConsultService#addAcConsultset(yssoft.vos.AcConsultsetVo)
	 * 
	 */
	public Object addAcConsultset(HashMap obj) {
		try {
			AcConsultsetVo headvo = (AcConsultsetVo) obj.get("head");
			if (!headvo.ctreesql.equals(""))
			{
			   headvo.ctreesql=headvo.ctreesql.replace("'","`");
			}
			if (!headvo.cgridsql.equals(""))
			{
			   headvo.cgridsql=headvo.cgridsql.replace("'","`");
			}
			if (!headvo.cconnsql.equals(""))
			{
			   headvo.cconnsql=headvo.cconnsql.replace("'","`");
			}
			String iid = this.iAcConsultService.addAcConsultset(headvo)
			.toString();

			List<AcConsultclmVo> bodyvos = (List<AcConsultclmVo>) obj
					.get("body");
			addAllAcConsultclms(bodyvos, Integer.valueOf(iid));
			return iid;
		} catch (Exception e) {
			return "false";
		}
	}

	/**
	 * 
	 * @see yssoft.services.IAcConsultService#deleteAcConsultsetByID(int)
	 * 
	 */

	public boolean deleteAcConsultsetByID(int iid) {
		// TODO Auto-generated method stub
		try {
			this.deleteAcConsultclmByPID(iid);
			this.iAcConsultService.deleteAcConsultsetByID(iid);
			return true;
		} catch (Exception e) {
			return false;
		}
	}

	/**
	 * 
	 * @see yssoft.services.IAcConsultService#getAcConsultsetByID(int)
	 * 
	 */

	public List<AcConsultsetVo> getAcConsultsetByID(int iid) {
		// TODO Auto-generated method stub
		 List<AcConsultsetVo> acConsultsetVos=this.iAcConsultService.getAcConsultsetByID(iid);
		for (AcConsultsetVo acConsultsetVo : acConsultsetVos) {
			acConsultsetVo.ctreesql=(acConsultsetVo.ctreesql==null?"":acConsultsetVo.ctreesql).replace("`", "'");
			acConsultsetVo.cgridsql=(acConsultsetVo.cgridsql==null?"":acConsultsetVo.cgridsql).replace("`", "'");
			acConsultsetVo.cconnsql=(acConsultsetVo.cconnsql==null?"":acConsultsetVo.cconnsql).replace("`", "'");
		}
		return acConsultsetVos;
	}
	
	public String get_cname_AcConsultsetByID(int iid)	{
		try
		{
		   return this.iAcConsultService.get_cname_AcConsultsetByID(iid);
		}
		catch(Exception e)
		{
		   return null;
		}
	}
	
	public List<HashMap> get_bdataauth_AcConsultsetByID(int iid)	{
		try
		{
		   return this.iAcConsultService.get_bdataauth_AcConsultsetByID(iid);
		}
		catch(Exception e)
		{
		   return null;
		}
	}
	
	/**
	 * 孙东亚 add 相关对象
	 * @param iid
	 * @return
	 */
	
	public String deleteAcConsultsetByID_Relevance_Object(int iid)	{
		try
		{
		   return this.iAcConsultService.get_cname_AcConsultsetByID_Relevance_Object(iid);
		}
		catch(Exception e)
		{
		   return null;
		}
	}
	
	public List<AcConsultsetVo> getAcConsultsetByCCode(String ccode) {
		 List<AcConsultsetVo> acConsultsetVos=this.iAcConsultService.getAcConsultsetByCCode(ccode);
			for (AcConsultsetVo acConsultsetVo : acConsultsetVos) {
				acConsultsetVo.ctreesql=acConsultsetVo.ctreesql.replace("`", "'");
				acConsultsetVo.cgridsql=acConsultsetVo.cgridsql.replace("`", "'");
				acConsultsetVo.cconnsql=acConsultsetVo.cconnsql.replace("`", "'");
			}
			return acConsultsetVos;
	}
	
	/**
	 * 
	 * 获得树参照数据
	 * 
	 */
	public HashMap<String, Object> getAcConsultTreeData(HashMap hm) {
        int iid = Integer.parseInt(hm.get("iid").toString());
	    HashMap<String, Object> hash=new HashMap<String, Object>();
		try {
            List<AcConsultsetVo> acConsultsetVos = this.iAcConsultService
                    .getAcConsultsetByID(iid);
            AcConsultsetVo acConsultsetVo = acConsultsetVos.get(0);
            String exesql = acConsultsetVo.ctreesql;

            if (hm.get("cconsultedit") != null) {
                String cconsultedit =hm.get("cconsultedit").toString();
                exesql = exesql.replace("@cconsultedit", cconsultedit);
            }else{
                exesql = exesql.replace("@cconsultedit", "");
            }


            hash.put("cname", acConsultsetVo.cname);
		   if (exesql.toLowerCase().indexOf("order by")==-1)
		   {
			   exesql=exesql+" order by ccode";
		   }
		   List<HashMap> list=this.getTestTreeSql(exesql);
		   if (list==null)
		   {
			   hash.put("exception", SysConstant.CONSULT_SQLERR);
		   }
		   else
		   {
		       hash.put("treexml",ToXMLUtil.createTree(list, "iid", "ipid", "-1"));
		   }
		}
		catch (Exception e) {
			hash.put("exception", SysConstant.CONSULT_SQLERR);
		}
		return hash;
	}
	
	/**
	 * 
	 * 获得列表参照数据或执行SQL语句(issql属性不为空且值为1)
	 * 
	 */
	public HashMap<String, Object> getAcConsultListData(HashMap obj) {
		int iid=Integer.valueOf(obj.get("iid").toString());
		List<AcConsultsetVo> acConsultsetVos = this.iAcConsultService
		.getAcConsultsetByID(iid);
		if (acConsultsetVos.size()==0)
		{
			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("exception", SysConstant.CONSULT_SQLERR);
			return map;
		}
		AcConsultsetVo acConsultsetVo = acConsultsetVos.get(0);
		int itype = Integer.valueOf(acConsultsetVo.itype);
		String exesql = null;
		String maintable="";//左树右表时主表名
		HashMap<String, Object> hash = new HashMap<String, Object>() ;
		switch (itype) {
		case 0:
			exesql = acConsultsetVo.ctreesql;
			break;
		case 1:
			exesql = acConsultsetVo.cgridsql;
			break;
		case 2:
			String ccode="";
			if (obj.get("ccode")!=null)
			{
				ccode=obj.get("ccode").toString();
			}
			int p1=acConsultsetVo.cgridsql.indexOf("from")+5;
			int p2=acConsultsetVo.cgridsql.indexOf(" ",p1);
			maintable=acConsultsetVo.cgridsql.substring(p1, p2);
			exesql = acConsultsetVo.cgridsql.replace("@join",acConsultsetVo.cconnsql.replace("@value","'"+ccode+"%'") );
			break;
		}
        if (obj.get("cconsultedit") != null) {
            String cconsultedit =obj.get("cconsultedit").toString();
            exesql = exesql.replace("@cconsultedit", cconsultedit);
        }else{
            exesql = exesql.replace("@cconsultedit", "");
        }

		if (exesql != null) {
			List<AcConsultclmVo> acConsultclmVos = this
			.getAcConsultclmByPID(iid);
			String search = obj.get("search").toString().trim();
			String condition = "";
			if (!search.equals("")) {
				boolean addor=false;
				for (int i = 0; i < acConsultclmVos.size(); i++) {
					AcConsultclmVo acConsultclmVo = acConsultclmVos.get(i);
					if (acConsultclmVo.bsearch == 1) {
						String cfield="";

						//lr add 如果是左树右表类型，并且字段不是由（表名.字段名构成的）  则用算出的表名情况
						if(itype==2&&!acConsultclmVo.cfield.contains(".")){
							cfield=maintable+"."+acConsultclmVo.cfield;								
						}else{
							cfield=acConsultclmVo.cfield;
						}

						if (addor==false) {
							condition = condition + cfield
									+ " like '%" + search + "%'";
							addor=true;
						} else {
							condition = condition + " or "
									+ cfield + " like '%"
									+ search + "%'";
						}
					}
				}

				if (condition != "") {
					if (exesql.toLowerCase().indexOf("where") > -1) {
						exesql = exesql + " and (" + condition + ")";
					} else {
						exesql = exesql + " where " + condition;
					}
				}
			}
			if (obj.get("childsql")!=null)
			{
				if (itype==1 || itype==2)
				{
				   String childsql="";
				   childsql=obj.get("childsql").toString();
				   exesql=exesql.replace("@childsql",childsql);
				}
			}
			if (obj.get("condition")!=null)
			{
				if (itype==1 || itype==2)
				{
				   String conditionsql="";
				   conditionsql=obj.get("condition").toString();
				   exesql=exesql.replace("@condition",conditionsql);
				}
            }
            if (exesql!=null && !exesql.equals(""))
			{
			   exesql=exesql.replace("`", "'");
			}
			if (obj.containsKey("issql"))
			{
				hash.put("success", exesql);
			}
			else
			{
			   hash = this.getTestSql(exesql);
			}
			hash.put("cname", acConsultsetVo.cname);
			hash.put("ipage", acConsultsetVo.ipage);
			hash.put("success2", acConsultclmVos);
			hash.put("cordersql", acConsultsetVo.cordersql);
		}
		return hash;
	}

	/**
	 * 
	 * @see yssoft.services.IAcConsultService#getAllAcConsultset()
	 * 
	 */

	@SuppressWarnings("unchecked")
	public String getAllAcConsultset() {
		// TODO Auto-generated method stub
		/****************************** 创建树 ******************************/
		List<HashMap> list = this.iAcConsultService.getAllAcConsultset();
		if (list.size() == 0) {
			return null;
		} else {
			String xmlstr=ToXMLUtil.createTree(this.iAcConsultService
					.getAllAcConsultset(), "iid", "ipid", "-1");
			return xmlstr;
		}
		/****************************** 创建树 ******************************/
	}

	/**
	 *更新表头和表体
	 * 
	 * 
	 */

	public boolean updateAcConsultset(HashMap obj) {
		// TODO Auto-generated method stub
		try {
            //lr modify
			AcConsultsetVo headvo = (AcConsultsetVo) obj.get("head");
			if (!headvo.ctreesql.equals(""))
			{
			   //headvo.ctreesql=headvo.ctreesql.replace("'","`");
			}
			if (!headvo.cgridsql.equals(""))
			{
			   //headvo.cgridsql=headvo.cgridsql.replace("'","`");
			}
			if (!headvo.cconnsql.equals(""))
			{
			   //headvo.cconnsql=headvo.cconnsql.replace("'","`");
			}
			this.iAcConsultService.updateAcConsultset(headvo);

			List<AcConsultclmVo> bodyvos = (List<AcConsultclmVo>) obj
					.get("body");
			this.deleteAcConsultclmByPID(headvo.iid);
			this.addAllAcConsultclms(bodyvos, headvo.iid);
			return true;
		} catch (Exception e) {
			return false;
		}
	}

	// -------------------------------------------------主子表上下分隔-------------------------------------------------//
	/**
	 * 
	 * @see yssoft.services.IAcConsultService#getAcConsultclmByPID()
	 * 
	 */

	public List<AcConsultclmVo> getAcConsultclmByPID(int iconsult) {
		// TODO Auto-generated method stub
		return this.iAcConsultService.getAcConsultclmByPID(iconsult);
	}

	/**
	 * 
	 * @see yssoft.services.IAcConsultService#getAcConsultclmByCCode()
	 * 
	 */
	public List<AcConsultclmVo> getAcConsultclmByCCode(String ccode) {
		// TODO Auto-generated method stub
		return this.iAcConsultService.getAcConsultclmByCCode(ccode);
	}

	/**
	 * 
	 * @see yssoft.services.IAcConsultService#getAcConsultclmByID(int)
	 * 
	 */

	public List getAcConsultclmByID(int iid) {
		// TODO Auto-generated method stub
		return this.iAcConsultService.getAcConsultclmByID(iid);
	}

	/**
	 * 
	 * @see yssoft.services.IAcConsultService#addAcConsultclm(yssoft.vos.AcConsultclmVo)
	 * 
	 */

	public Object addAcConsultclm(AcConsultclmVo acConsultclmVo) {
		try {
			return this.iAcConsultService.addAcConsultclm(acConsultclmVo);
		} catch (Exception e) {
			return false;
		}
	}

	/**
	 * 
	 * 增加表体所有记录
	 * 
	 */

	public Boolean addAllAcConsultclms(List<AcConsultclmVo> obj, int iid) {
		try {
			List<AcConsultclmVo> acConsultclmVos = obj;
			for (AcConsultclmVo acConsultclmVo : acConsultclmVos) {
				acConsultclmVo.iconsult = iid;
				this.addAcConsultclm(acConsultclmVo);
			}
			return true;
		} catch (Exception e) {
			return false;
		}
	}

	/**
	 * 
	 * 更新表体所有记录
	 * 
	 */

	public Boolean updateAllAcConsultclms(List<AcConsultclmVo> obj, int iid) {
		try {
			List<AcConsultclmVo> acConsultclmVos = obj;
			for (AcConsultclmVo acConsultclmVo : acConsultclmVos) {
				acConsultclmVo.iconsult = iid;
				this.updateAcConsultclm(acConsultclmVo);
			}
			return true;
		} catch (Exception e) {
			return false;
		}
	}

	/**
	 * 
	 * @see yssoft.services.IAcConsultService#updateAcConsultclm(yssoft.vos.AcConsultclmVo)
	 * 
	 */

	public boolean updateAcConsultclm(AcConsultclmVo acConsultclmVo) {
		// TODO Auto-generated method stub
		try {
			return this.iAcConsultService.updateAcConsultclm(acConsultclmVo);
		} catch (Exception e) {
			return false;
		}
	}

	/**
	 * 
	 * @see yssoft.services.IAcConsultService#deleteAcConsultclmByPID(int)
	 * 
	 */

	public boolean deleteAcConsultclmByPID(int iconsult) {
		// TODO Auto-generated method stub
		try {
			return this.iAcConsultService.deleteAcConsultclmByPID(iconsult);
		} catch (Exception e) {
			return false;
		}
	}

	/**
	 * 
	 * @see yssoft.services.IAcConsultService#getTestSql(String)
	 * 
	 */

	public HashMap<String, Object> getTestSql(String sqlstr) {
		// TODO Auto-generated method stub
		try {
			return this.iAcConsultService.getTestSql(sqlstr.replace("`", "'"));
		} catch (Exception e) {
			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("exception", SysConstant.CONSULT_SQLERR);
			return map;
		}
	}
	
	/**
	 *     
	 * @see yssoft.services.IAcConsultService#getTestTreeSql(String) 
	 *   
	 */
	public List<HashMap> getTestTreeSql(String sqlstr){
		// TODO Auto-generated method stub
		try
		{
		   return this.iAcConsultService.getTestTreeSql(sqlstr);
		}
		catch(Exception e)
		{
			return null;
		}
	}
	
	public  HashMap<String, Object> getDataType(){
		// TODO Auto-generated method stub
		try
		{
		   return this.iAcConsultService.getTestSql("select iid,cname from as_datatype");
		}
		catch(Exception e)
		{
			return null;
		}
	}
	
	public HashMap<String, Object> getDAODataType(String sqlstr) {
		// TODO Auto-generated method stub
		try {
			HashMap<String, Object> map=new HashMap<String, Object>();
			map.put("sql",sqlstr);
			map.put("success", mydao.ShowFieldType(sqlstr));
			return map;
		} catch (Exception e) {
			HashMap<String, Object> map = new HashMap<String, Object>();
			map.put("exception", SysConstant.CONSULT_SQLERR);
			return map;
		}
	}
	
	/**
	 * 
	 * @see yssoft.services.IAcConsultService#getTestSql(String)
	 * 
	 */
}