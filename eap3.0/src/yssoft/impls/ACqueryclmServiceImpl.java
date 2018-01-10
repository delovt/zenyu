/**
 * 模块名称：ACqueryclmView
 * 模块说明：查询条件配置表操作业务实现类
 * 创建人：	YJ
 * 创建日期：20110815
 * 修改人：
 * 修改日期：
 * 
 */

package yssoft.impls;

import yssoft.daos.BaseDao;
import yssoft.services.IACqueryclmService;

import java.util.HashMap;
import java.util.List;

public class ACqueryclmServiceImpl extends BaseDao implements
		IACqueryclmService {

	public List getAcQueryclmList(int ifuncregedit) {
		return this.queryForList("DatadictionaryDest.getAcQueryclmList",
				ifuncregedit);
	}

	public List getFWFConditionclmList(int ifuncregedit) {
		return this.queryForList("DatadictionaryDest.getFWFConditionclmList",
				ifuncregedit);
	}
	
	/**
	 * 函数名称：addAcqueryclm 函数说明：增加查询条件定制表信息 函数参数：AsACqueryclmVO（查询条件定制表实体对象）
	 * 函数返回：Object 创建人： YJ 创建日期：20110819 修改人： 修改日期：
	 * 
	 */
	public Object addAcqueryclm(HashMap paramMap) {
		List datalist = (List) paramMap.get("datalist");
		Object obj = new Object();
		String strsql = "";
		try {
			for (Object dataItem : datalist) {
				HashMap record = (HashMap) dataItem;// 一条记录

				String ccaption = record.get("ccaption") == null ? "" : record
						.get("ccaption").toString();
				int iconsult = record.get("iconsult") == null
						|| record.get("iconsult").toString().trim().equals("") ? 0
						: Integer.parseInt(record.get("iconsult").toString().trim());
				String cconsultbkfld = record.get("cconsultbkfld") == null ? ""
						: record.get("cconsultbkfld").toString().trim();
				String cconsultswfld = record.get("cconsultswfld") == null ? ""
						: record.get("cconsultswfld").toString().trim();
				int iqryno = record.get("iqryno") == null
						|| record.get("iqryno").toString().trim().equals("") ? 0
						: Integer.valueOf(record.get("iqryno").toString().trim());
				int bcommon = record.get("bcommon") == null
						|| Boolean.valueOf(record.get("bcommon").toString().trim()) == false ? 0
						: 1;
				int isortno = record.get("isortno") == null
						|| record.get("isortno").toString().trim().equals("") ? 0
						: Integer.valueOf(record.get("isortno").toString().trim());
				String cdefault = record.get("cdefault") == null ? "" : record
						.get("cdefault").toString().trim();
				String cfixdefault=record.get("cfixdefault")==null?"":record.get("cfixdefault").toString().trim();
				int bunnull = record.get("bunnull") == null
						|| Boolean.valueOf(record.get("bunnull").toString().trim()) == false ? 0
						: 1;
				int bconsultendbk = record.get("bconsultendbk") == null
						|| Boolean.valueOf(record.get("bconsultendbk")
								.toString()) == false ? 0 : 1;
				String cconsultipvf=record.get("cconsultipvf")==null?"":record.get("cconsultipvf").toString().trim();
				String cconsulttable=record.get("cconsulttable")==null?"":record.get("cconsulttable").toString().trim();
				if (record.get("iid") != null) {
					strsql += "update ac_queryclm set cfield		='"
							+ record.get("cfield") + "'," + "	ccaption	='"
							+ ccaption + "'," + "	ifieldtype	="
							+ record.get("ifieldtype") + "," + "	iconsult	="
							+ iconsult + "," + "	cconsultbkfld='"
							+ cconsultbkfld + "'," + "	cconsultswfld='"
							+ cconsultswfld + "'," + "	iqryno=" + iqryno + ","
							+ "   bcommon=" + bcommon + "," + "   icmtype="
							+ record.get("icmtype") + "," + "   isortno="
							+ isortno + "," + "   isttype="
							+ record.get("isttype") + "," + "   cdefault='"
							+ cdefault + "'," + "   bunnull=" + bunnull + ","
							+ "   bconsultendbk=" + bconsultendbk 
							+",cfixdefault='"+cfixdefault+"',cconsultipvf='"+cconsultipvf+"',cconsulttable='"+cconsulttable+"' "
							+ " where "
							+ "   ifuncregedit=" + paramMap.get("ifuncregedit")
							+ " and " + "   iid=" + record.get("iid") + "  ";
				} else {

					strsql += "insert into ac_queryclm(ifuncregedit,cfield,ccaption,ifieldtype," +
							"iconsult,cconsultbkfld,cconsultswfld,iqryno,bcommon,icmtype," +
							"isortno,isttype,cdefault,bunnull,bconsultendbk,cfixdefault,cconsultipvf,cconsulttable) values("
							+ ""+ paramMap.get("ifuncregedit")
							+ ",'"
							+ record.get("cfield")
							+ "',"
							+ "'"
							+ ccaption
							+ "',"
							+ record.get("ifieldtype")
							+ ","
							+ iconsult
							+ ",'"
							+ cconsultbkfld
							+ "','"
							+ cconsultswfld
							+ "',"
							+ iqryno
							+ ","
							+ bcommon
							+ ","
							+ record.get("icmtype")
							+ ","
							+ isortno
							+ ","
							+ record.get("isttype") + ","

							+ "'"+cdefault + "',"

							+ bunnull + "," + bconsultendbk+",'"+cfixdefault
							+"','"+cconsultipvf+"','"+cconsulttable+ "') ";
				}
			}

			paramMap.put("sqlvalue", strsql);

			obj = this.insert("add_Acqueryclm", paramMap);
			obj = "保存成功！";
		} catch (Exception ex) {
			obj = "保存失败！";
		}
		return obj;
	}

	/**
	 * 函数名称：deleteAcqueryclm 函数说明：删除查询条件定制表信息 函数参数：iid（主键） 函数返回：Object 创建人： YJ
	 * 创建日期：20110819 修改人： 修改日期：
	 * 
	 */
	public Object deleteAcqueryclm(int iid) throws Exception {
		Object obj = new Object();
		try {
			this.delete("delete_Acqueryclm", iid);
			obj = "删除成功!";
		} catch (Exception ex) {
			obj = "删除失败!";
		}
		return obj;
	}

	/**
	 * 函数名称：updateAcqueryclm 函数说明：更新查询条件定制表信息 函数参数：iid（主键） 函数返回：Object 创建人： YJ
	 * 创建日期：20110819 修改人： 修改日期：
	 * 
	 */
	public Object updateAcqueryclm(HashMap paramMap) throws Exception {
		List datalist = (List) paramMap.get("datalist");
		Object obj = new Object();
		String strsql = "";
		try {
			for (Object dataItem : datalist) {
				HashMap record = (HashMap) dataItem;// 一条记录

				String ccaption = record.get("ccaption") == null ? "" : record
						.get("ccaption").toString();
				int iconsult = record.get("iconsult") == null
						|| record.get("iconsult").toString().trim().equals("") ? 0
						: Integer.parseInt(record.get("iconsult").toString().trim());
				String cconsultbkfld = record.get("cconsultbkfld") == null ? ""
						: record.get("cconsultbkfld").toString().trim();
				String cconsultswfld = record.get("cconsultswfld") == null ? ""
						: record.get("cconsultswfld").toString().trim();
				int iqryno = record.get("iqryno") == null
						|| record.get("iqryno").toString().trim().equals("") ? 0
						: Integer.valueOf(record.get("iqryno").toString().trim());
				int bcommon = record.get("bcommon") == null
						|| Boolean.valueOf(record.get("bcommon").toString().trim()) == false ? 0
						: 1;
				int isortno = record.get("isortno") == null
						|| record.get("isortno").toString().trim().equals("") ? 0
						: Integer.valueOf(record.get("isortno").toString().trim());

				String cdefault = record.get("cdefault") == null ? "" : record
						.get("cdefault").toString().trim();
				int bunnull = record.get("bunnull") == null
						|| Boolean.valueOf(record.get("bunnull").toString().trim()) == false ? 0
						: 1;
				int bconsultendbk = record.get("bconsultendbk") == null
						|| Boolean.valueOf(record.get("bconsultendbk")
								.toString().trim()) == false ? 0 : 1;
				
				String cfixdefault=record.get("cfixdefault")==null?"":record.get("cfixdefault").toString().trim();
				String cconsultipvf=record.get("cconsultipvf")==null?"":record.get("cconsultipvf").toString().trim();
				
				String cconsulttable=record.get("cconsulttable")==null?"":record.get("cconsulttable").toString().trim();
				strsql += "update ac_queryclm set cfield		='"
						+ record.get("cfield") + "'," + "	ccaption	='"
						+ ccaption + "'," + "	ifieldtype	="
						+ record.get("ifieldtype") + "," + "	iconsult	="
						+ iconsult + "," + "	cconsultbkfld='" + cconsultbkfld
						+ "'," + "	cconsultswfld='" + cconsultswfld + "',"
						+ "	iqryno=" + iqryno + "," + "   bcommon=" + bcommon
						+ "," + "   icmtype=" + record.get("icmtype") + ","
						+ "   isortno=" + isortno + "," + "   isttype="
						+ record.get("isttype") + "," + "   cdefault='"
						+ cdefault + "'," + "   bunnull=" + bunnull + ","
						+ "   bconsultendbk=" + bconsultendbk +
						" ,cfixdefault='"+cfixdefault+"', cconsultipvf='"+cconsultipvf+"',cconsulttable='"+cconsulttable+"' "+
						" where "
						+ "   ifuncregedit=" + paramMap.get("ifuncregedit")
						+ " and " + "   iid=" + record.get("iid") + "  ";
			}

			paramMap.put("sqlvalue", strsql);

			obj = this.update("update_Acqueryclm", paramMap);
			obj = "更新成功！";
		} catch (Exception ex) {
			ex.printStackTrace();
			obj = "更新失败！";
		}
		return obj;
	}

	/**
	 * 
	 * updateAcqueryclm(修改排序状态) 创建者：zhong_jing 创建时间：2011-8-27 上午10:32:41 修改者：
	 * 修改时间： 修改备注：
	 * 
	 * @param paramMaps
	 *            排序值
	 * @return
	 * @throws Exception
	 *             String
	 * @Exception 异常对象
	 * 
	 */
	public int updateAcqueryclmBySort(HashMap paramMaps) throws Exception {
		return this.update("update_Acqueryclm_sort", paramMaps);
	}
	
	/**
	 * 功能：查询条件设置保存时，更新条件
	 * 作者:XZQWJ
	 * 时间：2013-01-28
	 * 
	 */
	public int updateAcqueryclmByCondition(HashMap paramMaps) throws Exception {
		// TODO Auto-generated method stub
		return this.update("update_Acqueryclm_Condition", paramMaps);
	}
}
