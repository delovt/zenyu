package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.Iab_invoiceuserService;
import yssoft.utils.BeanFactoryUtil;

import java.util.HashMap;
import java.util.List;

public class ChildrenDataHandle extends BaseDao{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private Iab_invoiceuserService i_ab_invoiceuserService;

	public void seti_ab_invoiceuserService(
			Iab_invoiceuserService i_ab_invoiceuserService) {
		this.i_ab_invoiceuserService = i_ab_invoiceuserService;
	}


	/**
	 * 函数名称：addChildData
	 * 函数说明：添加子表信息
	 * 函数参数：tablename:子表表名
	 * 			data:子表记录集
	 * 			iid:子表对应的主表主键
	 * 			iid_field:子表中对应的主表字段名称
	 * 
	 * 函数返回：
	 * 创建人：	YJ
	 * 创建日期：20110929
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	@SuppressWarnings("unchecked")
	public  void ChildData(HashMap paramMap,int iid)throws RuntimeException{

		List temp = null;

		Object obj_arrdg = paramMap.get("arr_dg");//获取记录集集合
		if(obj_arrdg != null){

			temp = (List)paramMap.get("arr_dg");

			for(int i=0;i<temp.size();i++){

				HashMap hmobj = (HashMap)temp.get(i);//获取一个数据集
				String tablename = hmobj.get("tablename").toString();//
				List li = (List)hmobj.get("dglist");
				String condition = "";

				if(hmobj.get("condition_iid") != null)
					condition = hmobj.get("condition_iid").toString();//子表iid字符串  例：iid in(1,2,3)


				this.addHandleChildData(tablename, li,condition, iid,paramMap.get("ifuncregedit").toString());

			}
		}

	}


	/**
	 * 函数名称：updateChildData
	 * 函数说明：更新子表信息
	 * 函数参数：tablename:子表表名
	 * 			data:子表记录集
	 * 			iid:子表对应的主表主键
	 * 			iid_field:子表中对应的主表字段名称
	 * 
	 * 函数返回：
	 * 创建人：	YJ
	 * 创建日期：20110929
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	@SuppressWarnings("unchecked")
	public  void addHandleChildData(String tablename,List listdata,String condition,int iid,String ifuncregedit)throws RuntimeException{

		StringBuilder strsql = null;
		StringBuilder strdata = null;
		String sql = "";//最终sql
		HashMap<String, Object> paramMap = new HashMap<String, Object>();
		String foreignkey = "";


		//依据表名查询表结构
		List table_info = BeanFactoryUtil.getBean(BaseDao.class).queryForList("CompetitorDest.getTableFormation",tablename);

		if(table_info.size() > 0) {

			//获取外键字段
			foreignkey = getForeignKey(table_info);

			if(listdata.size()>0){

				for(int j=0;j<listdata.size();j++){

					strdata = new StringBuilder("");

					HashMap hm = (HashMap)listdata.get(j);//获取一条记录集

					if(hm.get("iid") == null || hm.get("iid").toString().trim().equals("")){//需要增加数据

						strsql = new StringBuilder(" insert into " + tablename +"(");

						for(int i=0;i<table_info.size();i++){

							//获取数据字典信息
							HashMap hm_table = (HashMap) table_info.get(i);

							String cfield = hm_table.get("cfield").toString();//字段
							String datatype = hm_table.get("idatatype").toString();//字段类型
							Boolean bchildcn = (Boolean)hm_table.get("bchildcn");//是否主子关联项

							if(!cfield.equals("iid")){
								strsql.append(cfield + ",");

								if(bchildcn){//得到与主表对应的字段,不需要插入数据，只需要获取主表的主键值即可
									strdata.append(iid+",");
									foreignkey = cfield;
								}
								else{
									Object datavalue = hm.get(cfield);

									if(datavalue != null && !datavalue.equals("")){

										if(datatype.equals("int"))//如果数据类型是int，无需添加单引号
											strdata.append(datavalue + ",");
										else 
											strdata.append("'"+datavalue+"',");

									}
									else{
										strdata.append(" NULL,");
									}
								}
							}
						}

						// 截取字符串
						strsql.replace(strsql.lastIndexOf(","), strsql.length(), "");
						strdata.replace(strdata.lastIndexOf(","), strdata.length(), "");

						strsql.append(" ) values (");
						strsql.append(strdata.toString());
						strsql.append(")");




					}
					else {//更新数据
						strsql = new StringBuilder(" update "+tablename + " set ");

						for(int i=0;i<table_info.size();i++){

							//获取数据字典信息
							HashMap hm_table = (HashMap) table_info.get(i);

							String cfield = hm_table.get("cfield").toString();//字段
							String datatype = hm_table.get("idatatype").toString();//字段类型
							Boolean bchildcn = (Boolean)hm_table.get("bchildcn");//是否主子关联项

							if(!cfield.equals("iid")){
								if(bchildcn == false ){
									strsql.append(cfield + "=");

									Object datavalue = hm.get(cfield);//获取某字段值

									if (datavalue != null && !datavalue.equals("")) {
										if(datatype.equals("int"))//如果数据类型是int，无需添加单引号
										{
											strsql.append(datavalue + ",");
										}
										else if(datatype.equals("bit"))
										{
											if(datavalue.equals("true"))
											{
												strsql.append(1 + ",");
											}
											else
											{
												strsql.append(0 + ",");
											}
										}
										else
										{
											strsql.append("'"+datavalue+"',");
										}
									}
									else{
										if(datatype.equals("int"))//如果数据类型是int，无需添加单引号
											strsql.append("0,");
										else if(datatype.equals("bit"))
										{
											strsql.append(0 + ",");
										}
										else 
											strsql.append("'',");
									}
								}
								else
									foreignkey = cfield;
							}
						}

						strsql.replace(strsql.lastIndexOf(","), strsql.length(), "");
						strsql.append(" where iid=");
						strsql.append(hm.get("iid").toString());

					}
					//update by zhong_jing 加入;用于找出每个sql
					sql += strsql.toString()+";";

				}
			}
			if(!condition.equals("")){
				sql += " delete " + tablename + " where iid " + condition;
			}

			paramMap.put("sqlValue", sql);
			System.out.print(sql);

			/************************************ add by zhong_jing 新增相关人 begin*********************************************************************/
			//解析sql，取出单个的sql
			String[] sqlArr = sql.split(";");

			for(int i=0;i<sqlArr.length;i++)
			{
				HashMap sqlmap = new HashMap();
				sqlmap.put("sqlValue", sqlArr[i]);

				//判断如果执行新增的时候，执行以下操作
				if(sqlArr[i].indexOf("insert")!=-1)
				{
					//新增后找出编码
					String iidStr = BeanFactoryUtil.getBean(BaseDao.class).insert("CompetitorDest.add",sqlmap).toString();

					//判断是否是客商档案，如果是，则新增一条相关人操作
					if(ifuncregedit.equals("44"))
					{
						// 插入
						HashMap<String, String> paramStr = new HashMap<String, String>();

						paramStr.put("ifuncregedit", "45");
						paramStr.put("iinvoice", iidStr);
						try {
							BeanFactoryUtil.getBean(ab_invoiceuserImpl.class).add_ab_invoiceuser(paramStr);
						} catch (Exception e) {
							e.printStackTrace();
						}
					}
				}
				//判断是修改，执行以下操作
				else if(sqlArr[i].indexOf("update")!=-1)
				{
					//修改记录
					BeanFactoryUtil.getBean(BaseDao.class).update("CompetitorDest.update",sqlmap);
				}
				//判断是否是删除，执行以下操作
				else if(sqlArr[i].indexOf("delete")!=-1)
				{
					//删除记录
					BeanFactoryUtil.getBean(BaseDao.class).delete("CompetitorDest.del",sqlmap);
					//判断是否是客商档案，如果是，则执行删除相关人操作
					if(ifuncregedit.equals("44"))
					{
						//先取出中间的客商联系人编码
						String conditionStr = condition.substring(condition.indexOf("(")+1, condition.indexOf(")"));
						//遍历成数组
						String[] conditionStrArr =conditionStr.split(",");
						//一条一条删除掉
						for(int j=0;j<conditionStrArr.length;j++)
						{
							HashMap map = new HashMap();
							map.put("iinvoice", conditionStrArr[j]);
							map.put("ifuncregedit", "45");
							BeanFactoryUtil.getBean(ab_invoiceuserImpl.class).pr_execdellinktable(map);
						}
					}
				}
			}
			/************************************ add by zhong_jing 新增相关人 end*********************************************************************/
		}
	}

	//获取子表中关联的外键字段
	@SuppressWarnings("unchecked")
	private String getForeignKey(List tableList){

		String foreignkey = "";
		for(int i=0;i<tableList.size();i++){

			//获取数据字典信息
			HashMap hm_table = (HashMap) tableList.get(i);

			String cfield = hm_table.get("cfield").toString();//字段
			Boolean bchildcn = (Boolean)hm_table.get("bchildcn");//是否主子关联项

			if(bchildcn){//得到与主表对应的字段
				foreignkey = cfield;
				break;
			}
		}

		return foreignkey;

	}


	/**
	 * 函数名称：delChildData
	 * 函数说明：删除子表信息
	 * 函数参数：paraMap(HashMap 参数的数据类型)
	 * 			在paraMap中需要包含的参数如下
	 * 			arr_dg:总的记录集(表名、子表内码集合,特殊业务条件)
	 * 			
	 * 
	 * 函数返回：
	 * 创建人：	YJ
	 * 创建日期：20110929
	 * 修改人：
	 * 修改日期：
	 * 
	 */
	@SuppressWarnings("unchecked")
	public void delChildData(HashMap paraMap){

		Object obj_arrdg = new Object();//承载总的记录集集合
		List  list_arrdg = null;//承载总记录集集合
		String strsql = "";//承载最后的sql语句
		String newsql = "in ()";//承载替换后的sql


		//获取总记录集集合
		obj_arrdg = paraMap.get("arr_dg");

		if(obj_arrdg == null) return;

		list_arrdg = (List) obj_arrdg;

		for(int i=0;i<list_arrdg.size();i++){

			HashMap hm = (HashMap)list_arrdg.get(i);//获取一条记录

			String tablename = hm.get("chidctable").toString();//获取子表表名

			//依据表名查询表结构
			List table_info = BeanFactoryUtil.getBean(BaseDao.class).queryForList("CompetitorDest.getTableFormation",tablename);

			//获取子表对应的主表外键值
			String foreignkey = getForeignKey(table_info);

			//替换sql中iid为外键值
			if(paraMap.get("sql") != null){
				newsql = paraMap.get("sql").toString().replace("iid", foreignkey);
			}

			//拼接sql语句 hm.get("condition")--->条件
			strsql += "  delete "+tablename+" where " +newsql+" "+ hm.get("condition");
		}

		paraMap.put("sqlValue", strsql);

		try{

			BeanFactoryUtil.getBean(BaseDao.class).delete("CompetitorDest.del",paraMap);//执行删除操作；

		}
		catch(Exception ex){
			System.out.println("删除子表时："+ex.getMessage());
		}
		finally{
			//paraMap.clear();
		}

	}
}
