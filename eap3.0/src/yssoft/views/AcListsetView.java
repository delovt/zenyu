/**    
 *
 * 文件名：ListsetView.java
 * 版本信息：增宇Crm2.0
 * 日期： 2011-8-16    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.views;

import yssoft.services.IAcListsetService;
import yssoft.utils.ToXMLUtil;
import yssoft.vos.AcListclmVo;
import yssoft.vos.AcListsetVo;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;

/**
 * 
 * 项目名称：yscrm 
 * 类名称：ListsetView 
 * 类描述： 
 * 创建人：zhong_jing 
 * 创建时间：2011-8-16 下午04:42:37
 * 
 */
public class AcListsetView {
	private IAcListsetService iAcListsetService;

	public void setiAcListsetService(IAcListsetService iAcListsetService) {
		this.iAcListsetService = iAcListsetService;
	}

	/**
	 * 
	 * getAcListers(更新列) 
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-16 下午05:07:30 
	 * 修改者： 修改时间：
	 * 修改备注：
	 * 
	 * @param sql
	 *            sql语句
	 * @return List<AcListclmVo>
	 * @Exception 异常对象
	 * 
	 */
	public HashMap<String, Object> verificationSql(HashMap paramObje) {
		
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		 try {
			 AcListsetVo acListsetVo =(AcListsetVo)paramObje.get("item");
			 List<AcListclmVo> oldacListclmVos= (List<AcListclmVo>)paramObje.get("oldacListclmVos");
			 List dataType = (List) paramObje.get("dataType");
			 //验证是正确，并把结果集找出来
			 List  test= this.iAcListsetService.queryType(acListsetVo.getCsql1());
			 int count= oldacListclmVos.size()+1;
			 List<AcListclmVo> acListclmVos= new ArrayList<AcListclmVo>();
			//找出第一行记录
			for(int i=0;i<test.size();i++)
			{
				AcListclmVo acListclmVo = new AcListclmVo();
				HashMap<String, Object> map=(HashMap<String, Object>)test.get(i);
				String key= map.get("fieldname").toString();
				acListclmVo.setCfield(key);
				acListclmVo.setIlist(acListsetVo.getIid());
				String typeStr="";
				if(map.get("fieldtype").toString().toLowerCase().equals("bigint")
						||map.get("fieldtype").toString().toLowerCase().equals("smallint")
						||map.get("fieldtype").toString().toLowerCase().equals("int")
						||map.get("fieldtype").toString().toLowerCase().equals("int identity")
						||map.get("fieldtype").toString().toLowerCase().equals("bigint identity")
						||map.get("fieldtype").toString().toLowerCase().equals("smallint identity"))
				{
					typeStr="int";
				}
				else if(map.get("fieldtype").toString().toLowerCase().equals("nvarchar")
						||map.get("fieldtype").toString().toLowerCase().equals("varchar"))
				{
					typeStr="nvarchar";
				}
				else if(map.get("fieldtype").toString().toLowerCase().equals("smalldatetime")
						||map.get("fieldtype").toString().toLowerCase().equals("datetime"))
				{
					typeStr="datetime";
				}
				else if(map.get("fieldtype").toString().toLowerCase().equals("bit"))
				{
					typeStr="bit";
				}
				else if(map.get("fieldtype").toString().toLowerCase().equals("float")
						||map.get("fieldtype").toString().toLowerCase().equals("money")
						||map.get("fieldtype").toString().toLowerCase().equals("numeric"))
				{
					typeStr="float";
				}
				else if(map.get("fieldtype").toString().toLowerCase().equals("text")||
						map.get("fieldtype").toString().toLowerCase().equals("ntext"))
				{
					typeStr="text";
				}
				for(int k=0;k<dataType.size();k++)
				{
					HashMap dataTypeMap =(HashMap)dataType.get(k);
					if(dataTypeMap.get("ctype").toString().equals(typeStr))
					{
						acListclmVo.setIfieldtype(Integer.valueOf(dataTypeMap.get("iid").toString()));
						break;
					}
				}
				if(oldacListclmVos.size()>0)
				{
					boolean isFind=false;
					for (int j = 0; j < oldacListclmVos.size(); j++) {
						AcListclmVo oldacListclmVo = oldacListclmVos.get(j);
						if(oldacListclmVo.getCfield().equals(key))
						{
							isFind=true;
							acListclmVo.setCcaption(oldacListclmVo.getCcaption());
							acListclmVo.setCnewcaption(oldacListclmVo.getCfield());
							acListclmVo.setIcolwidth(oldacListclmVo.getIcolwidth());
							acListclmVo.setIalign(oldacListclmVo.getIalign());
							acListclmVo.setBshow(oldacListclmVo.isBshow());
							acListclmVo.setBlinkfun(oldacListclmVo.isBlinkfun());
							acListclmVo.setIno(oldacListclmVo.getIno());
							acListclmVo.setBsearch(oldacListclmVo.isBsearch());
							
							acListclmVo.setBsum(oldacListclmVo.isBsum());
							acListclmVo.setBfilter(oldacListclmVo.isBfilter());

							break;
						}
					}
					
					if(!isFind)
					{
						acListclmVo.setIcolwidth(80);
						acListclmVo.setCcaption(acListclmVo.getCfield());
						acListclmVo.setCnewcaption(acListclmVo.getCfield());
						acListclmVo.setIno(count);
					}
				}
				else
				{
					acListclmVo.setIcolwidth(80);
					acListclmVo.setCcaption(acListclmVo.getCfield());
					acListclmVo.setCnewcaption(acListclmVo.getCfield());
					acListclmVo.setIno(count);
				}
				acListclmVos.add(acListclmVo);
				count++;
			}
			resultMap.put("resultStr", acListclmVos);
		 } catch (Exception e) {
			 e.printStackTrace();
			 resultMap.put("resultStr", "fail");
		 }
		 return resultMap;
	}

	private List<AcListclmVo> getSql(String sql,int iid) {
		List<AcListclmVo> acListclmVoList = new ArrayList<AcListclmVo>();
		sql = sql.toLowerCase();
		int selectLength = 6;
		int fromIndex = sql.indexOf("from");
		String str = sql.substring(selectLength + 1, fromIndex).trim();
		String[] array = str.split(",");
		int index1 = -1;
		int index2 = -1;
		int index3 = -1;
		for (int i = 0; i < array.length; i++) {
			AcListclmVo acListclmVo = new AcListclmVo();
			String s = array[i].trim();
			index1 = s.indexOf("as");
			index2 = s.indexOf('.');
			index3 = s.indexOf(' ');
			if (index1 != -1) {
				acListclmVo.setCfield(s.substring(index1 + 2).trim());
			} else if (index2 != -1) {
				acListclmVo.setCfield(s.substring(index2 + 1).trim());
			} else if (index3 != -1) {
				acListclmVo.setCfield(s.substring(index3).trim());
			} else {
				acListclmVo.setCfield(s);
			}
			acListclmVo.setIno(i+1);
			acListclmVo.setIcolwidth(80);
			acListclmVo.setCcaption(acListclmVo.getCfield());
			acListclmVo.setCnewcaption(acListclmVo.getCfield());
			acListclmVo.setIlist(iid);
			acListclmVoList.add(acListclmVo);
		}
		return acListclmVoList;
	}
	
	/**
	 * 
	 * getListset(列表配置表)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-17 下午05:12:10
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param id 关联功能注册码
	 * @return AcListsetVo 查询结果
	 *
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public HashMap getListset(AcListclmVo acListclmVo)
	{
		HashMap result = new HashMap();
		//AcListsetVo acListsetVo =this.iAcListsetService.getListset(acListclmVo.getIlist());
        AcListsetVo acListsetVo = getAcListsetVo(acListclmVo);

		List<AcListclmVo> acListclmVos = new ArrayList<AcListclmVo>();
		if(acListsetVo!=null)
		{
			acListclmVo.setIlist(acListsetVo.getIid());
			acListclmVos = this.iAcListsetService.getAcListclm(acListclmVo);
			if(acListclmVos.size()==0&&acListclmVo.getIperson()>0)
			{
				acListclmVo.setIperson(0);
				acListclmVos = this.iAcListsetService.getAcListclm(acListclmVo);
				result.put("isDefault", 0);
			}
		}
		result.put("acListsetVo", acListsetVo);
		result.put("acListclmVos", acListclmVos);
		return result;
	}

    public AcListsetVo getAcListsetVo(AcListclmVo acListclmVo) {
        AcListsetVo acListsetVo = this.iAcListsetService.getListset(acListclmVo.getIlist());
        HashMap getPersonSetParam = new HashMap();
        getPersonSetParam.put("iperson", acListclmVo.getIperson());
        getPersonSetParam.put("ilist", acListsetVo.getIid());
        List list = this.iAcListsetService.getListsetp(getPersonSetParam);
        if (list.size() > 0) {
            HashMap h = (HashMap) list.get(0);
            int ipage = Integer.parseInt(h.get("ipage") + "");
            int ifixnum = Integer.parseInt(h.get("ifixnum") + "");
            if (ipage > 0)
                acListsetVo.setIpage(ipage);
            if (ifixnum > 0)
                acListsetVo.setIfixnum(ifixnum);
        }

        if (acListsetVo != null) {
            String sql = acListsetVo.getCsql1().replace("\"", "'");
            acListsetVo.setCsql1(sql);
        }
        return acListsetVo;
    }

    public HashMap getListsetSet(AcListclmVo acListclmVo)
    {
        HashMap result = new HashMap();
        AcListsetVo acListsetVo = getAcListsetVo(acListclmVo);
        List<AcListclmVo> acListclmVos = new ArrayList<AcListclmVo>();
        if(acListsetVo!=null)
        {
            acListclmVo.setIlist(acListsetVo.getIid());
            acListclmVos = this.iAcListsetService.getAcListclmSet(acListclmVo);
            if(acListclmVos.size()==0&&acListclmVo.getIperson()>0)
            {
                acListclmVo.setIperson(0);
                acListclmVos = this.iAcListsetService.getAcListclmSet(acListclmVo);
                result.put("isDefault", 0);
            }
        }
        result.put("acListsetVo", acListsetVo);
        result.put("acListclmVos", acListclmVos);
        return result;
    }
	
	/**
	 * 
	 * getListsetForServer(列表配置表)服务器设置
	 * 创建者：YJ
	 * 创建时间：2012-04-27
	 * 修改者：
	 * 修改时间：
	 * 修改备注：  主要区分个人设置和服务器设置 
	 * @param id 关联功能注册码
	 * @return AcListsetVo 查询结果
	 *
	 */
	public HashMap getListsetForServer(AcListclmVo acListclmVo)
	{
		HashMap result = new HashMap();
		AcListsetVo acListsetVo =this.iAcListsetService.getListset(acListclmVo.getIlist());
		if(acListsetVo!=null)
		{
			String sql = acListsetVo.getCsql1().replace("\"", "'");
			acListsetVo.setCsql1(sql);
		}
		List<AcListclmVo> acListclmVos = new ArrayList<AcListclmVo>();
		if(acListsetVo!=null)
		{
			acListclmVo.setIlist(acListsetVo.getIid());
			acListclmVos = this.iAcListsetService.getAcListclmForServer(acListclmVo);
			if(acListclmVos.size()==0&&acListclmVo.getIperson()>0)
			{
				acListclmVo.setIperson(0);
				acListclmVos = this.iAcListsetService.getAcListclmForServer(acListclmVo);
				result.put("isDefault", 0);
			}
		}
		result.put("acListsetVo", acListsetVo);
		result.put("acListclmVos", acListclmVos);
		return result;
	}
	
	
	
	/**
	 * 
	 * addObj(保存列表)
	 * 创建者：zhong_jing
	 * 创建时间：2011-8-18 下午02:38:04
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param paramObject 保存
	 * @return int 是否保存成功
	 * @Exception 异常对象    
	 *
	 */
	@SuppressWarnings("unchecked")
	public String addObj(HashMap paramObject)
	{
		List<AcListclmVo> acListclmVos=(List<AcListclmVo>)paramObject.get("acListclmVos");
		AcListsetVo acListsetVo = (AcListsetVo)paramObject.get("acListsetVo");
		
		try {
			if(paramObject.get("iperson")!=null&&paramObject.get("iperson").toString().equals("0"))
			{
				if(paramObject.get("oldacListsetVo")!=null)
				{
					this.iAcListsetService.updateListset(acListsetVo);
				}
				else
				{
					String sql = acListsetVo.getCsql1().replace("'", "\"");
					acListsetVo.setCsql1(sql);
					Object iid = this.iAcListsetService.addListset(acListsetVo);
					acListsetVo.setIid(Integer.valueOf(iid.toString()));
				}
			}
			HashMap paramObj = new HashMap();
			paramObj.put("iperson", paramObject.get("iperson").toString());
			if(paramObject.get("iperson")!=null&&paramObject.get("iperson").toString().equals("0"))
			{
				paramObj.put("ilist", acListsetVo.getIid());
			}
			else
			{
				paramObj.put("ilist", paramObject.get("ilist").toString());
			}
			this.iAcListsetService.removeListclm(paramObj);
			if(paramObject.get("iperson")!=null&&paramObject.get("iperson").toString().equals("0"))
			{
				for (AcListclmVo acListclmVo : acListclmVos) 
				{
					acListclmVo.setIlist(acListsetVo.getIid());
					this.iAcListsetService.addlistclm(acListclmVo);
				} 
				this.iAcListsetService.deleteListclm(acListsetVo.getIid());
			}
			else
			{
				this.iAcListsetService.addlistclmByResume(paramObj);
			}
			
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}
		return "success";
	}
	
	/**
	 * 
	 * updateList(修改列表)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-5 上午08:49:39
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param paramObject
	 * @return String
	 * @Exception 异常对象    
	 *
	 */
	public String updateList(HashMap paramObject)
	{
		List<AcListclmVo> acListclmVos=(List<AcListclmVo>)paramObject.get("acListclmVos");
		AcListsetVo acListsetVo = (AcListsetVo)paramObject.get("acListsetVo");
        AcListsetVo acListsetVoOld = this.iAcListsetService.getListset(acListsetVo.getIfuncregedit());

        acListsetVo.setIfixnum(acListsetVoOld.getIfixnum());
        acListsetVo.setIpage(acListsetVoOld.getIpage());
		try {
			int count= this.iAcListsetService.updateListset(acListsetVo);
			int size =0;
			for (AcListclmVo acListclmVo : acListclmVos) 
			{
				if(acListclmVo.getIperson()>0)
				{
					size+=this.iAcListsetService.updatelistclm(acListclmVo);
				}
				else
				{
					acListclmVo.setIperson(Integer.valueOf(paramObject.get("iperson").toString()));
					this.iAcListsetService.addlistclm(acListclmVo);
					size++;
				}
			}
			if(count==1&&size==acListclmVos.size())
			{
				return "success";
			}
			else
			{
				return "fail";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}
	}
	
	
	public String deleteList(HashMap paramObject)
	{
		try {
			this.iAcListsetService.removeListclm(paramObject);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return "fail";
		}
		return "success";
	}
	
	
	/**
	 * 
	 * getListcd(列表配置常用条件查询)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-20 上午11:35:53
	 * 修改者：Lenovo
	 * 修改时间：2011-9-20 上午11:35:53
	 * 修改备注：   
	 * @return List<HashMap>
	 * @Exception 异常对象    
	 *
	 */
	public String getListcd(HashMap paramObj)
	{
		List<HashMap> list =this.iAcListsetService.getListcd(paramObj);
		String treeXml = null;
		if(list.size()>0){
			treeXml =  ToXMLUtil.createTree(list, "iid", "ipid", "-1");
		}
		return treeXml;
	}

    public String getListStyle(HashMap paramObj)
    {
        List<HashMap> list =this.iAcListsetService.getListStyle(paramObj);
        String treeXml = null;
        if(list.size()>0){
            treeXml =  ToXMLUtil.createTree(list, "iid", "ipid", "-1");
        }
        return treeXml;
    }

    public List<HashMap> getListStyleList(HashMap paramObj)
    {
        List<HashMap> list =this.iAcListsetService.getListStyle(paramObj);
        return list;
    }
	
	
	public List<HashMap> getListcdList(HashMap paramObj)
	{
		List<HashMap> list =this.iAcListsetService.getListcd2(paramObj);
		return list;
	}

	/**
	 * 
	 * addListcd(添加列表配置常用条件)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-20 下午04:41:34
	 * 修改者：
	 * 修改时间：
	 * 修改备注：   
	 * @param listcdVo
	 * @return Object
	 * @Exception 异常对象    
	 *
	 */
	public String addListcd(HashMap paramObj)
	{
		try {
			return this.iAcListsetService.addListcd(paramObj).toString();
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}
	}

    public String saveListStyle(HashMap paramObj)
    {
        try {
            if(paramObj.containsKey("iid"))
                return this.iAcListsetService.updateListStyle(paramObj)+"";
            else
                return this.iAcListsetService.addListStyle(paramObj).toString();
        } catch (Exception e) {
            e.printStackTrace();
            return "fail";
        }
    }
	
	/**
	 * 
	 * updateListcd(修改列表配置常用条件)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-20 下午04:42:38
	 * 修改者：Lenovo
	 * 修改时间：2011-9-20 下午04:42:38
	 * 修改备注：   
	 * @param listcdVo
	 * @return int
	 * @Exception 异常对象    
	 *
	 */
	public String updateListcd(HashMap paramObj)
	{
		try {
			int count = this.iAcListsetService.updateListcd(paramObj);
			if(count ==1)
			{
				return "success";
			}
			else
			{
				return "fail";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}
	}
	
	/**
	 * 
	 * removeListcd(删除列表配置常用条件)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-20 下午04:44:21
	 * 修改者：Lenovo
	 * 修改时间：2011-9-20 下午04:44:21
	 * 修改备注：   
	 * @param iid
	 * @return int
	 * @Exception 异常对象    
	 *
	 */
	public String removeListcd(int iid)
	{
		try {
			int count = this.iAcListsetService.removeListcd(iid);
			if(count ==1)
			{
				return "success";
			}
			else
			{
				return "fail";
			}
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}
	}

    public String deleteListStyle(int iid)
    {
        try {
            int count = this.iAcListsetService.deleteListStyle(iid);
            if(count ==1)
            {
                return "success";
            }
            else
            {
                return "fail";
            }
        } catch (Exception e) {
            e.printStackTrace();
            return "fail";
        }
    }


    /**
	 * 
	 * testSql(验证sql是否正确)
	 * 创建者：zhong_jing
	 * 创建时间：2011-9-20 下午06:26:58
	 * 修改者：Lenovo
	 * 修改时间：2011-9-20 下午06:26:58
	 * 修改备注：   
	 * @param sql
	 * @return String
	 * @Exception 异常对象    
	 *
	 */
	public String testSql(String sql)
	{
		try {
			//验证是正确，并把结果集找出来
			this.iAcListsetService.verificationSql(sql);
			return "success";
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}
	}
	
	public String recentlyEdited(String sql)
	{
		try {
			List<HashMap<String, Object>> zjbj = this.iAcListsetService.verificationSql(sql);
			if(zjbj.size()>0)
			{
				 return ToXMLUtil.createTree(zjbj, "iid", "ipid", "-1");
			}
			return null;
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			return null;
		}
	}
	
	
	public List queryDataType()
	{
		return this.iAcListsetService.queryDataType();
	}
}
