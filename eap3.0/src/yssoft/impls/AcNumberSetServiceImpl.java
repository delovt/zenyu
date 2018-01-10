/**
 * 模块名称：AcNumberSetServiceImpl(单据编码实现类)
 * 模块说明：单据编码相关业务操作
 * 创建人：YJ
 * 创建日期：20110828
 * 修改人：
 * 修改日期：
 *
 */
package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IAcNumberSetService;
import yssoft.vos.AcNumberSetVO;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

@SuppressWarnings("serial")
public class AcNumberSetServiceImpl extends BaseDao implements IAcNumberSetService {

	protected AcNumberSetVO acNumberSetVO = new AcNumberSetVO();
	protected String cusdate = "";//客户端日期
	@SuppressWarnings("unchecked")
	protected List frontlist;//前台参与编码前缀的集合(包含主键、字段名称)
	protected int flag = 0;//标记	(0:显示编码，1：保存编码)
	protected int iid = 0;//历史单据编码中主键值
	
	/**
	 * 函数名称：getMenuList
	 * 函数说明：获取菜单列表
	 * 函数参数：无
	 * 函数返回：List
	 * 创建人：	YJ
	 * 创建日期：20110828
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	@SuppressWarnings("unchecked")
	public List<HashMap> getMenuList() {		
		return this.queryForList("NumberSetDest.getMenuList");
	}
	
	
	/**
	 * 函数名称：addNumberSet
	 * 函数说明：添加
	 * 函数参数：无
	 * 函数返回：List
	 * 创建人：	YJ
	 * 创建日期：20110828
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public Object addNumberSet(AcNumberSetVO acNumberSetVO){
		return this.insert("NumberSetDest.addNumberSet",acNumberSetVO);
	}
	
	
	/**
	 * 函数名称：updateNumberSet
	 * 函数说明：更新单据编码
	 * 函数参数：无
	 * 函数返回：List
	 * 创建人：	YJ
	 * 创建日期：20110828
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	public Object updateNumberSet(AcNumberSetVO acNumberSetVO){
		return this.update("NumberSetDest.updateNumberSet",acNumberSetVO);
	}


	/**
	 * 函数名称：getPreFixList
	 * 函数说明：获取编码前缀编码
	 * 函数参数：无
	 * 函数返回：List
	 * 创建人：	YJ
	 * 创建日期：20110828
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	@SuppressWarnings("unchecked")
	@Override
	public List<HashMap> getPreFixList(HashMap paramMap) {
		return this.queryForList("NumberSetDest.getPreFixList",paramMap);
	}

	
	
	/**
	 * 函数名称：getNumberSetListByIfid
	 * 函数说明：获取单据编码信息(注册编码主键)
	 * 函数参数：无
	 * 函数返回：List
	 * 创建人：	YJ
	 * 创建日期：20110828
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	@SuppressWarnings("unchecked")
	public List getNumberSetListByIfid(int ifuncregeidt){
		return this.queryForList("NumberSetDest.getNumberSetListByIfid",ifuncregeidt);
	}
	
	
	/**
	 * 函数名称：getNumberSetListByIfid
	 * 函数说明：获取单据编码信息(注册编码主键)
	 * 函数参数：无
	 * 函数返回：List
	 * 创建人：	YJ
	 * 创建日期：20110828
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	@SuppressWarnings("unchecked")
	public List getNumberHistory(int ifuncregeidt){
		return this.queryForList("NumberSetDest.getNumberHistory",ifuncregeidt);
	}
	
	
	/**
	 * 函数名称：getNumberListByCtable
	 * 函数说明：依据表名获取单据编码(系统自动生成)
	 * 函数参数：paramMap HashMap对象，其包含内容如下：
	 * 		    iid:注册表功能模块主键
	 * 			ctable:程序对应主数据表
	 * 			cusdate:客户端日期
	 * 			frontlist:前台参与编码前缀的集合赋值	Object对象
	 * 					  objv.cfield = "idepartment";//字段名称
	 *					  objv.fieldvalue = "KF";	 //字段值
	 * 
	 * 函数返回：List
	 * 创建人：	YJ
	 * 创建日期：20110828
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	@SuppressWarnings({ "unchecked"})
	public HashMap getNumberListByCtable(HashMap paramMap){
		HashMap<String, Object> resultMap = new HashMap<String, Object>();	
		String strsql = "";

		try{
			//是否参与单据编码管理
			strsql = "select iid from as_funcregedit where iid="+paramMap.get("iid")+" and bnumber=1";
			paramMap.put("sqlValue", strsql);
			Object obj = this.queryForObject("NumberSetDest.getSearchResult",paramMap);

			if(obj != null){//参与了单据编码管理
				
				HashMap hmObj = (HashMap)obj;
				
				cusdate = paramMap.get("cusdate").toString();
				if( paramMap.get("frontlist") != null)
					frontlist = (List)paramMap.get("frontlist");//前台参与编码前缀的集合赋值
				
				resultMap.put("number", this.getNumberSet(Integer.parseInt((hmObj.get("iid")).toString()),paramMap.get("ctable").toString()));
				
			}

		}
		catch(Exception ex){
			ex.printStackTrace();
		}
		return resultMap;
	}
	
	
	/**
	 * 函数名称：getNumberSet
	 * 函数说明：获取编码规则
	 * 函数参数：ifuncregedit：注册表主键
	 * 			ctable:表名
	 * 函数返回：Void
	 * 
	 * 创建人：	YJ
	 * 创建日期：20110902
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	@SuppressWarnings("unchecked")
	private Object getNumberSet(int ifuncregedit,String ctable){
		
		HashMap<String, Object> paramMap = new HashMap<String, Object>();
		String strsql = "";
		Object ccode = null;//最后的编码

		try{
			strsql = "SELECT " +
					"iid,ifuncregedit,itype,bedit,cprefix1,cprefix1value,bprefix1rule," +
					"cprefix2,cprefix2value,bprefix2rule,cprefix3,cprefix3value,bprefix3rule," +
					"ilength,istep,ibegin " +
					"FROM ac_numberset where ifuncregedit="+ifuncregedit;
			
			paramMap.put("sqlValue", strsql);
			List list = this.queryForList("NumberSetDest.getSearchResult",paramMap);//获取编码规则
			
			if(list.size()>0){
				
				HashMap hm = (HashMap)list.get(0);
				
				list.clear();//清空记录集
				
				int itype	= 	Integer.parseInt(hm.get("itype").toString());//单据编码规则类型
				
				
				switch(itype){
					case 0:	//完全手工
						break;
					case 1://纯流水
						Object obj = getNumberHistory(ifuncregedit,1,"",hm);
						ccode = getSwaterNumber(obj,hm);
						if(!ccode.equals("")) return ccode;
						break;
						
					case 2://系统规则
						
						//查询该表中参与编码的字段集合
						list = getFieldList(ctable);
						
						//依据规则生成编码前缀
						String PreFix = getNumberPreFix(list,hm);
						
						//获取流水号
						Object obj2 = getNumberHistory(ifuncregedit,2,PreFix,hm);
						String swaternumbuer = getSwaterNumber(obj2,hm);
						
						//编码前缀 + 流水号
						ccode = PreFix+swaternumbuer;
						
						return ccode;
						
					default:
						break;
				}
				
			}
			
		}
		catch(Exception ex){
			ex.printStackTrace();
		}
		
		return null;
		
	}
	
	
	
	/**
	 * 函数名称：getNumberHistory
	 * 函数说明：获取历史编码
	 * 函数参数：ifuncregedit：注册表主键
	 * 			itype		: 规则类型
	 * 			prefix		: 前缀
	 * 
	 * 函数返回：Void
	 * 
	 * 创建人：	YJ
	 * 创建日期：20110902
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	@SuppressWarnings("unchecked")
	private Object getNumberHistory(int ifuncregedit,int itype,String prefix,HashMap hmnumberset){
		HashMap<String, Object> paramMap = new HashMap<String, Object>();	
		String strsql = "";
		
		try{
			
			//查询历史单据编码
			if(itype == 1)//如是纯流水方案，则依据注册码和流水前缀为空
				strsql = "select iid,ifuncregedit,cprefix,inumber from ac_numberhistory where cprefix='' and ifuncregedit="+ifuncregedit;
			else//如是系统规则，则依据注册码和流水前缀
				strsql = "select iid,ifuncregedit,cprefix,inumber from ac_numberhistory where cprefix='"+prefix+"' and ifuncregedit="+ifuncregedit;
			paramMap.clear();
			paramMap.put("sqlValue", strsql);
			List list = this.queryForList("NumberSetDest.getSearchResult",paramMap);
			
			
			if(list.size()>0){	//历史单据编码存在
				
				HashMap hmlist = (HashMap)list.get(0);
				
				String cprefix	= hmlist.get("cprefix")+"";//流水前缀
				int inumber		= Integer.parseInt(hmlist.get("inumber").toString());//流水号
				iid 	= Integer.parseInt(hmlist.get("iid").toString());//主键值
				int istep	=   Integer.parseInt(hmnumberset.get("istep").toString()); //步长
				int newnumber = inumber + istep;
				
				
				if(flag == 1){//保存状态，需要更新单据历史表记录
					
					strsql = "update ac_numberhistory set ifuncregedit="+ifuncregedit+",cprefix='"+cprefix+"',inumber="+newnumber+" where iid="+iid;
					paramMap.clear();
					paramMap.put("sqlValue", strsql);
					this.update("NumberSetDest.updateNumberhistory",paramMap);
					
				}
				
				if(inumber != 0) return inumber;
				
			}
			else{//历史单据编码不存在
				
				if(flag == 1){//保存状态，需要新增单据历史表记录
					
					int ibegin	=   Integer.parseInt(hmnumberset.get("ibegin").toString());//起始值
					
					strsql = "insert into ac_numberhistory(ifuncregedit,cprefix,inumber) values("+ifuncregedit+",'"+prefix+"',"+ibegin+")";
					paramMap.clear();
					paramMap.put("sqlValue", strsql);
					this.update("NumberSetDest.updateNumberhistory",paramMap);
					
				}
				
			}
		}
		catch(Exception ex){
			ex.printStackTrace();
		}

		return null;
	}
	
	
	
	/**
	 * 函数名称：getSwaterNumber
	 * 函数说明：获取流水编码(最后的纯流水类型的编码)
	 * 函数参数：acNumberSetVO:单据编码规则实体类
	 * 			objHistory:流水历史单据号
	 * 
	 * 函数返回：String(依据流水规则生成的流水编码)
	 * 
	 * 创建人：	YJ
	 * 创建日期：20110902
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	@SuppressWarnings("unchecked")
	private String getSwaterNumber(Object objHistory,HashMap hm){
		
		int ilength	=	Integer.parseInt(hm.get("ilength").toString());//长度
		int istep	=   Integer.parseInt(hm.get("istep").toString()); //步长
		int ibegin	=   Integer.parseInt(hm.get("ibegin").toString());//起始值
		int number = 0;
		String swaterNumber = "";
		
		if(objHistory == null){//历史单据表中不存在，从头开始生成新的流水编码
			
			swaterNumber = String.format("%0" + ilength + "d", ibegin);
			
		}		
		else{//历史单据表中存在，依据流水规则，继续流水下去。
			
			number = Integer.parseInt(objHistory.toString());
			swaterNumber = String.format("%0" + ilength + "d", number + istep);
			
		}
		
		return swaterNumber;
	}
	
	
	/**
	 * 函数名称：getFieldList
	 * 函数说明：获取参与单据编码的字段集合
	 * 函数参数：ctable:表名
	 * 
	 * 函数返回：List(字段集合)
	 * 
	 * 创建人：	YJ
	 * 创建日期：20110902
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	@SuppressWarnings("unchecked")
	private List getFieldList(String ctable){
		
		HashMap<String, Object> paramMap = new HashMap<String, Object>();
		String strsql = "";
		List list = null;
		
		try{
			
			strsql = "select cfield,ccaption,as_datatype.ctype idatatype from ac_datadictionary "+
					"left join as_datatype on ac_datadictionary.idatatype=as_datatype.iid where bprefix=1 and ctable='"+ctable+"'";
			paramMap.clear();
			paramMap.put("sqlValue", strsql);
			list = this.queryForList("NumberSetDest.getSearchResult", paramMap);
			
		}
		catch(Exception ex){
			ex.printStackTrace();
		}
		
		return list;
		
	}
	
	
	
	/**
	 * 函数名称：getNumberPreFix
	 * 函数说明：获取编码前缀
	 * 函数参数：acNumberSetVO:单据编码规则实体类
	 * 			list:参与单据编码的字段集合
	 * 
	 * 函数返回：String(依据流水规则生成的编码前缀)
	 * 
	 * 创建人：	YJ
	 * 创建日期：20110902
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	@SuppressWarnings("unchecked")
	private String getNumberPreFix(List list,HashMap hm){
		
		String cprefix1 	 ="";
		if(null!=hm.get("cprefix1"))
		{
			cprefix1 	 =hm.get("cprefix1").toString();
		}
		 
		String cprefix1value = "";
		if(null!=hm.get("cprefix1value"))
		{
			cprefix1value = hm.get("cprefix1value").toString();
		}
		
		Boolean bprefix1rule =false;
		if(null!=hm.get("bprefix1rule"))
		{
			 bprefix1rule =(Boolean)hm.get("bprefix1rule");
		}
		String cprefix2 	 ="";
		if(null!= hm.get("cprefix2"))
		{
			cprefix2 =hm.get("cprefix2").toString();
		}
		 
		String cprefix2value ="";
		if(null!=hm.get("cprefix2value"))
		{
			cprefix2value = hm.get("cprefix2value").toString();
		}
		
		Boolean bprefix2rule = false;
		if(null!=hm.get("bprefix2rule"))
		{
			bprefix2rule = (Boolean)hm.get("bprefix2rule");
		}
		String cprefix3 	 ="";
		if(null!=hm.get("cprefix3"))
		{
			cprefix3 	 =hm.get("cprefix3").toString();
		}
		 
		String cprefix3value = "";
		if(null!=hm.get("cprefix3value"))
		{
			cprefix3value = hm.get("cprefix3value").toString();
		}
		
		Boolean bprefix3rule =  false;
		if(null!=hm.get("bprefix3rule"))
		{
			bprefix3rule =(Boolean)hm.get("bprefix3rule");
		}
		
		String prefix = "";//前缀值
		
		if(!cprefix1.equals(""))
			prefix += this.getValueByPreFix(cprefix1,cprefix1value,bprefix1rule,list);
		if(!cprefix2.equals(""))
			prefix += this.getValueByPreFix(cprefix2,cprefix2value,bprefix2rule,list);
		if(!cprefix3.equals(""))
			prefix += this.getValueByPreFix(cprefix3,cprefix3value,bprefix3rule,list);
		
		return prefix;
	}
	
	
	
	/**
	 * 函数名称：getValueByPreFix
	 * 函数说明：依据编码前缀获取前缀对应的值
	 * 函数参数：cprefix:前缀类型
	 * 			cprefixvalue：前缀对应的值
	 * 			bprefixrule：是否参与流水依据
	 * 			list:参与单据编码的字段集合
	 * 
	 * 函数返回：String(前缀值)
	 * 
	 * 创建人：	YJ
	 * 创建日期：20110905
	 * 修改人：
	 * 修改日期：
	 * 
	 * " "----------0
	 * 服务器日期----1
	 * 本机日期------2
	 * 固定字符------3
	 */
	@SuppressWarnings("unchecked")
	private String getValueByPreFix(String cprefix,String cprefixvalue,Boolean bprefixrule,List list){
	
		if(cprefix.equals("1")){//服务器日期
			
			Date date = new Date();
			SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
			String sdate = sdf.format(date);
			
			if(cprefixvalue.equals("年")) 	  return sdate.substring(0,4);
			if(cprefixvalue.equals("年月"))   return sdate.substring(0,6);
			if(cprefixvalue.equals("年月日")) return sdate;
			
		}
		else if(cprefix.equals("2")){//客户端日期
			
			if(cprefixvalue.equals("年")) 	  return cusdate.substring(0,4);
			if(cprefixvalue.equals("年月"))   return cusdate.substring(0,6);
			if(cprefixvalue.equals("年月日")) return cusdate;
			
		}
		else if(cprefix.equals("3")){//固定字符
			
			return cprefixvalue;
			 
		}
		else{
			for(int i=0;i<list.size();i++){//包含字段的前缀
				HashMap fields = (HashMap)list.get(i);

				String filedname = fields.get("cfield").toString();//获取字段名称(数据字典中)
				String filedtype = fields.get("idatatype").toString();//获取字段数据类型(数据字典中)

				if(cprefix.equals(filedname)){//单据编码规则中与数据字典中对比，说明该字段参与了单据编码规则，并作为前缀出现

					if(this.frontlist == null) return "";
					
					for(int j=0;j<this.frontlist.size();j++){

						HashMap frontfields = (HashMap)frontlist.get(j);

						String frontfield = frontfields.get("cfield").toString();
						String fieldvalue = frontfields.get("fieldvalue").toString();

						if(frontfield.equals(cprefix)){

							if(filedtype.equals("datetime")){//如果是日期类型做特殊处理

								if(cprefixvalue.equals("年")) 	  return fieldvalue.substring(0,4);
								if(cprefixvalue.equals("年月"))   return fieldvalue.substring(0,6);
								if(cprefixvalue.equals("年月日")) return fieldvalue;

							}
							else{

								return fieldvalue;

							}
						}

					}

				}
			}
		}
		
		return "";
	}
	
	
	/**
	 * 函数名称：showNumber
	 * 函数说明：显示编码，并不保存在数据库中
	 * 函数参数：HashMap paramMap 包含的参数如下：
	 * 			cprefix:前缀类型
	 * 			cprefixvalue：前缀对应的值
	 * 			bprefixrule：是否参与流水依据
	 * 			list:参与单据编码的字段集合
	 * 
	 * 函数返回：String(前缀值)
	 * 
	 * 创建人：	YJ
	 * 创建日期：20110905
	 * 修改人：
	 * 修改日期：
	 */
	@SuppressWarnings("unchecked")
	public HashMap showNumber(HashMap paramMap){
		
		this.flag = 0;
		return this.getNumberListByCtable(paramMap);
		
	}
	
	
	/**
	 * 函数名称：saveNumber
	 * 函数说明：保存编码，将流水号更新至单据历史表中
	 * 函数参数：HashMap paramMap 包含的参数如下：
	 * 			cprefix:前缀类型
	 * 			cprefixvalue：前缀对应的值
	 * 			bprefixrule：是否参与流水依据
	 * 			list:参与单据编码的字段集合
	 * 
	 * 函数返回：String(前缀值)
	 * 
	 * 创建人：	YJ
	 * 创建日期：20110905
	 * 修改人：
	 * 修改日期：
	 */
	@SuppressWarnings("unchecked")
	public HashMap saveNumber(HashMap paramMap){
		
		this.flag = 1;
		return this.getNumberListByCtable(paramMap);
		
	}
	
	
	/**
	 * 函数名称：onUpdateNumber
	 * 函数说明：更新单据历史流水号
	 * 函数参数：HashMap paramMap 包含的参数如下：
	 * 			iid:内码
	 * 			inumber：流水号
	 * 
	 * 函数返回：HashMap (更新是否成功)
	 * 
	 * 创建人：	YJ
	 * 创建日期：20111129
	 * 修改人：
	 * 修改日期：
	 */
	@SuppressWarnings("unchecked")
	public HashMap onUpdateHistoryNumber(HashMap paramMap){
		
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		
		try{
			this.update("NumberSetDest.updateNumberHistory", paramMap);
			resultMap.put("message", "success");
		}
		catch(Exception ex){
			ex.printStackTrace();
			resultMap.put("message", "fail");
		}
		finally{
			paramMap.clear();
		}
		return resultMap;
	}
}



