package yssoft.views;

import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import yssoft.services.IAcNumberSetService;
import yssoft.services.UtilService;
import yssoft.utils.ToXMLUtil;

/**
 * 
 * 拉式生单后天在此
 * 
 * @author lzx
 * 
 */
public class UtilView {
	private UtilService utilService;
	private IAcNumberSetService acnumberSet;

	public void setUtilService(UtilService utilService) {
		this.utilService = utilService;
	}

	public void setAcnumberSet(IAcNumberSetService acnumberSet) {
		this.acnumberSet = acnumberSet;
	}

	// 修改物料借用已经归还数量
	public void updateRdrecords(List<HashMap> conditions) {
		try {
			for (int i = 0; i < conditions.size(); i++) {
				HashMap condition = conditions.get(i);
				this.utilService.updateRdrecords(condition);
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
	}

	// 推式生单核心代码， 其实效率可以提高，就是复用几个sql查询之后的结果，以后有话 lr
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public HashMap getPushFormData(HashMap h) throws Exception {
		HashMap returnParam = new HashMap();

		String irelationship = h.get("irelationship").toString();// 单据关系配置主键
		String iid = h.get("iid").toString();// 触发单据内码

		HashMap param = new HashMap();
		param.put("iid", irelationship);
		List relationshipList = this.utilService.getRelationshipByiid(param);

		if (relationshipList.size() > 0) {
			// 单据关系 主表
			HashMap relationship = (HashMap) relationshipList.get(0);
			returnParam.put("relationship", relationship);
			List tableMessage = this.utilService
					.getTableMessageByifuncregedit(relationship);
			returnParam.put("tableMessage", tableMessage);
			Object bpush = relationship.get("bpush");
			if (bpush == null || bpush.toString().equals("false")) {
				returnParam.put("errorStr", "单据关系配置未启用推式生单，请检查。");
				return returnParam;
			} else {
				// 单据关系 子表
				List<HashMap> relationshipsList = this.utilService
						.getRelationshipsByirelationship(h);
				if (relationshipsList.size() > 0) {
					for (HashMap item : relationshipsList) {
						List consultSetList = this.utilService
								.getConsultSet(item.get("ctable") + "");
						if (consultSetList.size() > 0) {
							HashMap consultSet = (HashMap) consultSetList
									.get(0);

							String cconsultbkfld = item.get("cconsultbkfld")
									+ "";
							if (cconsultbkfld.trim().equals("null")
									|| cconsultbkfld.trim().equals(""))
								cconsultbkfld = "iid";

							boolean isMain = false;
							if (relationship.get("imainconsult") != null
									&& relationship.get("imainconsult").equals(
											consultSet.get("iid"))) {
								isMain = true;
							} else {
								isMain = false;
							}

							String sql = (String) consultSet.get("cgridsql");
							sql = sql.replace("@childsql", " and "
									+ cconsultbkfld + "=" + iid);
							String cconsultcondition = relationship
									.get("cconsultcondition") + "";

							if (relationship.get("imainconsult") != null
									&& relationship.get("imainconsult").equals(
											consultSet.get("iid"))
									&& relationship.get("cconsultcondition") != null) {
								sql = sql.replace("@condition",
										cconsultcondition);
							} else {
								sql = sql.replace("@condition", "");
							}
							List formValueList = this.utilService.exeSql(sql);
							if (formValueList.size() > 0) {
								// 像每个单据关系具体记录 添加查询到的数据
								item.put("formValue", formValueList);
							} else if (isMain) {
								returnParam.put("errorStr", "未找到可供生单的数据，请检查。");
								return returnParam;
							}
						} else {
							returnParam.put("errorStr", "单据关系配置配置参照有误，请检查。");
							return returnParam;
						}
					}
					returnParam.put("relationship", relationship);
					returnParam.put("relationshipsList", relationshipsList);
				} else {
					returnParam.put("errorStr", "单据关系配置配置有误，请检查。");
					return returnParam;
				}
			}

		} else {
			returnParam.put("errorStr", "未找到相应的单据关系配置，请检查。");
			return returnParam;
		}

		return returnParam;
	}

	public String buildTreeXML(HashMap hm) throws Exception {
		List list = (List) hm.get("list");
		String xml = ToXMLUtil.createTree(list, "iid", "ipid", "-1");
		return xml;
	}

	/**
	 * 查询该条记录是否被引用
	 * 
	 * @param ifuncregedit
	 *            引用注册码
	 * @param iinvoice
	 *            引用单据编码
	 * @param cfield
	 *            字段名
	 * @return
	 */
	public boolean isRepeatedly(HashMap param) {
		return this.utilService.isRepeatedly(param);
	}

	public HashMap changeLocation(HashMap param) {
		return this.utilService.changeLocation(param);
	}

	/**
	 * 修改合同的利润
	 * 
	 * @param param
	 */
	public HashMap updateOrderFcostForCsn(HashMap param) throws Exception {
		HashMap hm = new HashMap();
		List ac = new ArrayList();
		List asc = new ArrayList();
		ac = (ArrayList) param.get("ac");
		asc = (ArrayList) param.get("asc");
		String optType = (String) param.get("optType");
		Float fcostOld = Float.parseFloat(param.get("fcostOld") + "");
		Float fcost = 0f;
		Float ftaxsum = 0f;
		for (int j = 0; j < asc.size(); j++) {
			HashMap h2 = new HashMap();
			h2 = (HashMap) asc.get(j);
			fcost += Float.parseFloat(h2.get("fcost") + "");
			ftaxsum += Float.parseFloat(h2.get("ftaxsum") + "");
		}
		hm.put("fcost", fcost);
		if (optType.equals("onNew")) {
			for (int i = 0; i < ac.size(); i++) {
				HashMap h1 = new HashMap();
				h1 = (HashMap) ac.get(i);
				if (h1.get("ftax") == null && h1.get("fpremiums") == null
						&& h1.get("ffee") == null) {
					Float forderprofit = Float.parseFloat(h1
							.get("forderprofit") + "")
							- fcost;
					hm.put("forderprofit", forderprofit);
					int iid = Integer.parseInt(h1.get("iid") + "");
					hm.put("iid", iid);
				}
			}
		}
		if (optType.equals("onEdit")) {
			for (int i = 0; i < ac.size(); i++) {
				HashMap h1 = new HashMap();
				h1 = (HashMap) ac.get(i);
				if (h1.get("ftax") == null && h1.get("fpremiums") == null
						&& h1.get("ffee") == null) {
					Float forderprofit = ftaxsum - fcost;
					hm.put("forderprofit", forderprofit);
					int iid = Integer.parseInt(h1.get("iid") + "");
					hm.put("iid", iid);
				}
			}
		}
		int iid = this.utilService.updateOrderFcostForCsn(hm);
		return hm;
	}

	/**
	 * 修改合同的利润，回款利润
	 * 
	 * @param param
	 */
	public void updateOrderFsum(HashMap param) throws Exception {
		HashMap hm = new HashMap();
		List ac = new ArrayList();
		List asc = new ArrayList();
		List aclist = new ArrayList();

		Float fcosts = 0f;
		int iinvoice = Integer.parseInt(param.get("iinvoice") + "");
		String optType = (String) param.get("optType");
		hm.put("iinvoice", iinvoice);
		ac = (ArrayList) param.get("ac");
		asc = (ArrayList) param.get("asc");
		aclist = (ArrayList) param.get("aclist");
		for (int i = 0; i < asc.size(); i++) {
			HashMap h1 = new HashMap();
			h1 = (HashMap) asc.get(i);
			for (int j = 0; j < ac.size(); j++) {
				HashMap h2 = new HashMap();
				h2 = (HashMap) ac.get(j);
				for (int a = 0; a < aclist.size(); a++) {
					HashMap h3 = new HashMap();
					h3 = (HashMap) aclist.get(a);
					if (h2.get("iproduct").equals(h1.get("iproduct"))) {
						fcosts += Float.parseFloat(h2.get("fprice") + "")
								* Float.parseFloat(h1.get("fquantity") + "");
					}
				}
			}
		}
		if (optType.equals("onEdit")) {
			for (int a = 0; a < aclist.size(); a++) {
				HashMap h4 = new HashMap();
				h4 = (HashMap) aclist.get(a);
				if (h4.get("forderprofit") != null) {
					if (h4.get("fcost") != null) {
						Float forderprofit = Float.parseFloat(h4
								.get("forderprofit") + "")
								- fcosts
								+ Float.parseFloat(h4.get("fcost") + "");
						hm.put("forderprofit", forderprofit);
					} else {
						Float forderprofit = Float.parseFloat(h4
								.get("forderprofit") + "")
								- fcosts;
						hm.put("forderprofit", forderprofit);
					}

					int iid = this.utilService.updateOrderFsum(hm);
				} else {
					if (h4.get("fcost") != null) {
						Float forderprofit = Float.parseFloat(h4.get("fsum")
								+ "")
								- fcosts
								+ Float.parseFloat(h4.get("fcost") + "");
						hm.put("forderprofit", forderprofit);
					} else {
						Float forderprofit = Float.parseFloat(h4.get("fsum")
								+ "")
								- fcosts;
						hm.put("forderprofit", forderprofit);
					}
					int iid = this.utilService.updateOrderFsum(hm);
				}
				if (h4.get("fbackprofit") != null) {
					if (h4.get("fcost") != null) {
						Float fbackprofit = Float.parseFloat(h4
								.get("fbackprofit") + "")
								- fcosts
								+ Float.parseFloat(h4.get("fcost") + "");
						hm.put("fbackprofit", fbackprofit);
					} else {
						Float fbackprofit = Float.parseFloat(h4
								.get("fbackprofit") + "")
								- fcosts;
						hm.put("fbackprofit", fbackprofit);
					}
					int iid = this.utilService.updateOrderfbackprofit(hm);
				}
			}
		}
		if (optType.equals("onNew")) {
			for (int a = 0; a < aclist.size(); a++) {
				HashMap h4 = new HashMap();
				h4 = (HashMap) aclist.get(a);
				if (h4.get("forderprofit") != null) {
					Float forderprofit = Float.parseFloat(h4
							.get("forderprofit") + "")
							- fcosts;
					hm.put("forderprofit", forderprofit);
					int iid = this.utilService.updateOrderFsum(hm);
				} else {
					Float forderprofit = Float.parseFloat(h4.get("fsum") + "")
							- fcosts;
					hm.put("forderprofit", forderprofit);
					int iid = this.utilService.updateOrderFsum(hm);
				}
				if (h4.get("fbackprofit") != null) {
					Float fbackprofit = Float.parseFloat(h4.get("fbackprofit")
							+ "")
							- fcosts;
					hm.put("fbackprofit", fbackprofit);
					int iid = this.utilService.updateOrderfbackprofit(hm);
				}
			}
		}
		if (optType.equals("onDelete")) {
			for (int a = 0; a < aclist.size(); a++) {
				HashMap h4 = new HashMap();
				h4 = (HashMap) aclist.get(a);
				if (h4.get("forderprofit") != null) {
					Float forderprofit = Float.parseFloat(h4
							.get("forderprofit") + "")
							+ fcosts;
					hm.put("forderprofit", forderprofit);
					int iid = this.utilService.updateOrderFsum(hm);
				}
				if (h4.get("fbackprofit") != null) {
					Float fbackprofit = Float.parseFloat(h4.get("fbackprofit")
							+ "")
							+ fcosts;
					hm.put("fbackprofit", fbackprofit);
					int iid = this.utilService.updateOrderfbackprofit(hm);
				}
				if (h4.get("fcost") != null) {
					Float fcost = Float.parseFloat(h4.get("fcost") + "")
							- fcosts;
					hm.put("fcost", fcost);
					int iid = this.utilService.updateOrderfcost(hm);
				}
			}
		}
	}

	/**
	 * 隐式推单 其他出库
	 * 
	 * @param param
	 */
	public void setRdrecordOut(HashMap param) throws Exception {
		HashMap hm = new HashMap();
		List sc_transfers = (ArrayList) param.get("sc_transfers");
		List sc_transfersbom = (ArrayList) param.get("sc_transfersbom");
		DateFormat format1 = new SimpleDateFormat("yyyyMMdd");
		String ddate = param.get("ddate") + "";
		int irdtype = 6;
		hm.put("imaker", Integer.parseInt(param.get("imaker") + ""));
		int iwarehouse = Integer.parseInt(param.get("iwarehouse") + "");
		Float fsum = Float.parseFloat(param.get("fsum") + "");
		String cmemo = (String) param.get("cmemo");

		HashMap hm1 = new HashMap();
		hm1.put("icorp", "");
		hm1.put("idepartment", "");
		hm1.put("icustomer", "");
		hm1.put("imaker", Integer.parseInt(param.get("imaker") + ""));
		hm1.put("iid", 175);

		hm1.put("ctable", "sc_rdrecord");
		List frontlist = new ArrayList();
		Date currentTimeInfo = new Date();
		String tcusdate = format1.format(currentTimeInfo);
		hm1.put("frontlist", frontlist);
		hm1.put("cusdate", tcusdate);
		hm1.put("ifuncregedit", 175);
		// 获取单据编码
		HashMap numberMap = acnumberSet.saveNumber(hm1);
		String ccode = numberMap.get("number") == null ? "" : numberMap.get(
				"number").toString();

		hm.put("ddate", ddate);
		hm.put("irdtype", irdtype);
		// hm.put("iperson",iperson);
		// hm.put("ideparment",ideparment);
		hm.put("iwarehouse", iwarehouse);
		hm.put("iproperty", 2);
		hm.put("fsum", fsum);
		hm.put("cmemo", cmemo);
		hm.put("iinvoice", Integer.parseInt(param.get("iid") + ""));
		hm.put("iifuncregedit", 175);
		hm.put("ifuncregedit", 477);
		hm.put("ccode", ccode);
		hm.put("dmaker", tcusdate);
		int iid = this.utilService.setRdrecord(hm);
		int iids = 0;
		for (int i = 0; i < sc_transfers.size(); i++) {
			HashMap h1 = new HashMap();
			HashMap transfers = (HashMap) sc_transfers.get(i);
			h1.put("iproduct", transfers.get("iproduct"));
			h1.put("csn", transfers.get("csn"));
			h1.put("iunit", transfers.get("iunit"));
			h1.put("fquantity", transfers.get("fquantity"));
			h1.put("fstaxprice", transfers.get("fprice"));
			h1.put("fstaxsum", transfers.get("fsum"));
			h1.put("cmemo", transfers.get("cmemo"));
			h1.put("irdrecord", iid);
			iids = this.utilService.setRdrecords(h1);

		}
		for (int j = 0; j < sc_transfersbom.size(); j++) {
			HashMap h2 = new HashMap();
			HashMap transfersbom = (HashMap) sc_transfersbom.get(j);
			h2.put("iproduct", transfersbom.get("iproduct"));
			h2.put("iproductp", transfersbom.get("iproductp"));
			h2.put("fprice", transfersbom.get("fprice"));
			h2.put("fquantity", transfersbom.get("fquantity"));
			h2.put("irdrecords", iids);
			int iidss = this.utilService.setRdrecordsbom(h2);
		}
		HashMap invocieuser = new HashMap();
		invocieuser.put("iinvoice", iid);
		invocieuser.put("ifuncregedit", 175);
		invocieuser.put("irole", 1);
		invocieuser.put("icorp", "");
		invocieuser.put("iperson", Integer.parseInt(param.get("imaker") + ""));
		this.utilService.insertInvoiceuser(invocieuser);
	}

	/**
	 * 隐式推单 其他入库
	 * 
	 * @param param
	 */
	public void setRdrecord(HashMap param) throws Exception {
		HashMap hm = new HashMap();
		List sc_transfers = (ArrayList) param.get("sc_transfers");
		List sc_transfersbom = (ArrayList) param.get("sc_transfersbom");
		DateFormat format1 = new SimpleDateFormat("yyyyMMdd");
		String ddate = param.get("ddate") + "";
		int irdtype = 3;
		hm.put("imaker", Integer.parseInt(param.get("imaker") + ""));
		int iwarehouse = Integer.parseInt(param.get("iwarehousein") + "");
		Float fsum = Float.parseFloat(param.get("fsum") + "");
		String cmemo = (String) param.get("cmemo");

		HashMap hm1 = new HashMap();
		hm1.put("icorp", "");
		hm1.put("idepartment", "");
		hm1.put("icustomer", "");
		hm1.put("imaker", Integer.parseInt(param.get("imaker") + ""));
		hm1.put("iid", 174);

		hm1.put("ctable", "sc_rdrecord");
		List frontlist = new ArrayList();
		Date currentTimeInfo = new Date();
		String tcusdate = format1.format(currentTimeInfo);
		hm1.put("frontlist", frontlist);
		hm1.put("cusdate", tcusdate);
		hm1.put("ifuncregedit", 174);

		// 获取单据编码
		HashMap numberMap = acnumberSet.saveNumber(hm1);
		String ccode = numberMap.get("number") == null ? "" : numberMap.get(
				"number").toString();
		hm.put("ddate", ddate);
		hm.put("irdtype", irdtype);
		// hm.put("iperson",iperson);
		// hm.put("ideparment",ideparment);
		hm.put("iwarehouse", iwarehouse);
		hm.put("fsum", fsum);
		hm.put("iproperty", 1);
		hm.put("cmemo", cmemo);
		hm.put("iinvoice", Integer.parseInt(param.get("iid") + ""));
		hm.put("iifuncregedit", 174);
		hm.put("ifuncregedit", 477);
		hm.put("ccode", ccode);
		hm.put("dmaker", tcusdate);
		int iid = this.utilService.setRdrecord(hm);
		int iids = 0;
		for (int i = 0; i < sc_transfers.size(); i++) {
			HashMap h1 = new HashMap();
			HashMap transfers = (HashMap) sc_transfers.get(i);
			h1.put("iproduct", transfers.get("iproduct"));
			h1.put("csn", transfers.get("csn"));
			h1.put("iunit", transfers.get("iunit"));
			h1.put("fquantity", transfers.get("fquantity"));
			h1.put("fprice", transfers.get("fprice"));
			h1.put("fsum", transfers.get("fsum"));
			h1.put("cmemo", transfers.get("cmemo"));
			h1.put("irdrecord", iid);
			iids = this.utilService.setRdrecordsin(h1);
		}
		for (int j = 0; j < sc_transfersbom.size(); j++) {
			HashMap h2 = new HashMap();
			HashMap transfersbom = (HashMap) sc_transfersbom.get(j);
			h2.put("iproduct", transfersbom.get("iproduct"));
			h2.put("iproductp", transfersbom.get("iproductp"));
			h2.put("fprice", transfersbom.get("fprice"));
			h2.put("fquantity", transfersbom.get("fquantity"));
			h2.put("irdrecords", iids);
			int iidss = this.utilService.setRdrecordsbom(h2);
		}
		HashMap invocieuser = new HashMap();
		invocieuser.put("iinvoice", iid);
		invocieuser.put("ifuncregedit", 174);
		invocieuser.put("irole", 1);
		invocieuser.put("icorp", "");
		invocieuser.put("iperson", Integer.parseInt(param.get("imaker") + ""));
		this.utilService.insertInvoiceuser(invocieuser);
	}

	/**
	 * 隐式推单 进程推进
	 * 
	 * @param param
	 */
	public void setInvoiceprocess(HashMap param) throws Exception {
		HashMap hm = new HashMap();
		hm.put("ifuncregedit", Integer.parseInt(param.get("ifuncregedit") + ""));
		hm.put("iinvoice", Integer.parseInt(param.get("iinvoice") + ""));
		hm.put("icustomer", Integer.parseInt(param.get("icustomer") + ""));
		hm.put("iprocess", Integer.parseInt(param.get("iprocess") + ""));
		hm.put("ddate", (String) param.get("ddate"));
		hm.put("iifuncregedit",
				Integer.parseInt(param.get("iifuncregedit") + ""));
		hm.put("imaker", Integer.parseInt(param.get("imaker") + ""));
		hm.put("dmaker", (String) param.get("dmaker"));
		int iid = this.utilService.setInvoiceprocess(hm);
		HashMap invocieuser = new HashMap();
		invocieuser.put("iinvoice", iid);
		invocieuser.put("ifuncregedit", 258);
		invocieuser.put("irole", 1);
		invocieuser.put("icorp", "");
		invocieuser.put("iperson", Integer.parseInt(param.get("imaker") + ""));
		this.utilService.insertInvoiceuser(invocieuser);
	}


	public int InsertSql(String sql) throws Exception {
		int iid = this.utilService.InsertSql(sql);
		return iid;
	}

	/**
	 * 
	 * @param param
	 */
	public void insertInvoiceuser(HashMap param) throws Exception {
		HashMap invocieuser = new HashMap();
		invocieuser.put("iinvoice",
				Integer.parseInt(param.get("iinvoice") + ""));
		invocieuser.put("ifuncregedit",
				Integer.parseInt(param.get("ifuncregedit") + ""));
		invocieuser.put("irole", Integer.parseInt(param.get("irole") + ""));
		invocieuser.put("icorp", "");
		invocieuser.put("iperson", Integer.parseInt(param.get("iperson") + ""));
		this.utilService.insertInvoiceuser(invocieuser);
	}

	/**
	 * 批量插入活动人员
	 * 
	 * @param param
	 */
	public String insertMarkets(HashMap param) throws Exception {
		String msg = "";
		List allocationList = (ArrayList) param.get("allocationList");
		int iid = Integer.parseInt(param.get("iid") + "");
		int imaker = Integer.parseInt(param.get("imaker") + "");
		for (int i = 0; i < allocationList.size(); i++) {
			HashMap hm = new HashMap();
			HashMap hall = (HashMap) allocationList.get(i);
			int icustomer = Integer.parseInt(hall.get("icustomer") + "");
			String personname = (String) hall.get("personname");
			String cdepartment = (String) hall.get("cdepartment");
			String cpost = (String) hall.get("cpost");
			String ctel = (String) hall.get("ctel");
			String cmoblie1 = (String) hall.get("cmoblie1");
			String chicks = hall.get("chicks") + "";
			if (chicks.equals("1") || chicks.equals("true")) {
				String sql = "select isnull(count(*),0) num from mr_markets where icustomer="
						+ icustomer
						+ " and ccustperson  ='"
						+ personname
						+ "' and iinvoice=" + iid;
				List num = this.utilService.selectNum(sql);
				for (int j = 0; j < num.size(); j++) {
					HashMap h = (HashMap) num.get(j);
					int iNums = Integer.parseInt(h.get("num") + "");
					if (iNums > 0) {
						msg = (String) hall.get("custcname") + " 的 "
								+ personname + " 已经邀请！ ";
						return msg;
					} else {

						String inSql = "insert into mr_markets (iinvoice,icustomer,imaker,dmaker,iifuncregedit) "//ccustperson,cdepartment,cpost,ctel,
								+ " values(" + iid + "," + icustomer;
						inSql += "," + imaker + ",getdate()," + 384 + ");";
						int siid = this.utilService.InsertSql(inSql);
						String inSql1 = "insert into mr_marketsperson (imarkets,ccustperson,cdepartment,cpost,ctel,cmobile)" 
								+ " values(" + siid ;
						if (personname != null) {
							inSql1 += ",'" + personname + "'";
						} else {
							inSql1 += "," + personname;
						}
						if (cdepartment != null) {
							inSql1 += ",'" + cdepartment + "'";
						} else {
							inSql1 += "," + cdepartment;
						}
						if (cpost != null) {
							inSql1 += ",'" + cpost + "'";
						} else {
							inSql1 += "," + cpost;
						}
						if (ctel != null) {
							inSql1 += ",'" + ctel + "'";
						} else {
							inSql1 += "," + ctel;
						}
						if(cmoblie1 != null) {
							inSql1 += ",'" + cmoblie1 + "'";
						} else {
							inSql1 += "," + cmoblie1 +");";
						}
						this.utilService.InsertSql(inSql1);
						HashMap invocieuser = new HashMap();
						invocieuser.put("iinvoice", siid);
						invocieuser.put("ifuncregedit", 384);
						invocieuser.put("irole", 1);
						invocieuser.put("icorp", "");
						invocieuser.put("iperson", imaker);
						this.utilService.insertInvoiceuser(invocieuser);
					}
				}
			}
		}
		msg = "批量插入成功！";
		return msg;
	}

	/**
	 * 批量插入客商计划
	 * 
	 * @param param
	 */
	public String insertOaWorkPlan(HashMap param) throws Exception {
		String msg = "";
		List allocationList = (ArrayList) param.get("allocationList");
		int imaker = Integer.parseInt(param.get("imaker") + "");
		int imakers = Integer.parseInt(param.get("imakers") + "");
		Integer itype=null;
		if(!"NaN".equals(param.get("itype")+"") ){
			itype = Integer.parseInt(param.get("itype") + "");
		}
		String cname = param.get("cname") + "";
		String dbegin = param.get("dbegin") + "";
		String dend = param.get("dend") + "";
		String dmessage = param.get("dmessage") + "";
		String cdetail = param.get("cdetail") + "";
		for (int i = 0; i < allocationList.size(); i++) {
			HashMap hm = new HashMap();
			HashMap hall = (HashMap) allocationList.get(i);
			int icustomer = Integer.parseInt(hall.get("iid") + "");
			String chicks = hall.get("chicks") + "";
			if (chicks.equals("1") || chicks.equals("true")) {
				String inSql = "insert into oa_workplan (icustomer,itype,dbegin,dend,imaker,dmaker,iifuncregedit,istatus,dmessage,bnomessage,cname,cdetail)"
						+ "values("
						+ icustomer
						+ ","+ itype+ ",'"+ dbegin+ "','"+ dend+ "',"+ imaker+ ",getdate(),35,620,'"+ dmessage+ "',0,";
				if(cname!=null && cname!=""){
					inSql+="'"+cname+"',";
				}else{
					inSql+=""+cname+",";
				}
				if(cdetail!=null && cdetail!=""){
					inSql+="'"+cdetail+"')";
				}else{
					inSql+=""+cdetail+")";
				}
				int siid = this.utilService.InsertSql(inSql);
				HashMap invocieuser = new HashMap();
				invocieuser.put("iinvoice", siid);
				invocieuser.put("ifuncregedit", 35);
				invocieuser.put("irole", 1);
				invocieuser.put("icorp", "");
				invocieuser.put("iperson", imakers );
				this.utilService.insertInvoiceuser(invocieuser);
				HashMap invocieuser2 = new HashMap();
				invocieuser2.put("iinvoice", siid);
				invocieuser2.put("ifuncregedit", 35);
				invocieuser2.put("irole", 1);
				invocieuser2.put("icorp", "");
				invocieuser2.put("iperson", imaker);
				this.utilService.insertInvoiceuser(invocieuser2);
			}
		}
		msg = "批量插入客商计划成功！";
		return msg;
	}

	/**
	 * 批量插入服务申请
	 * 
	 * @param param
	 */
	public String insertRequest(HashMap param) throws Exception {
		String msg = "";
		List allocationList = (ArrayList) param.get("allocationList");
		int imaker = Integer.parseInt(param.get("imaker") + "");
		int isolutionIid = Integer.parseInt(param.get("isolutionIid") + "");
		String daskprocess = param.get("daskprocess") + "";
		String dmaker = param.get("dmaker") + "";
		String cdetail = param.get("cdetail") + "";
		List selectList = new ArrayList();
		for (int i = 0; i < allocationList.size(); i++) {
			HashMap hm1 = new HashMap();
			HashMap hall = (HashMap) allocationList.get(i);
			String chicks = hall.get("chicks") + "";
			if (chicks.equals("1") || chicks.equals("true")) {
				selectList.add(allocationList.get(i));
			}
		}
		Boolean flag = false;
        if(selectList.size()==1){
        	flag=true;
        }
		for (int i = 0; i < selectList.size() - 1; i++) {
			HashMap hall = (HashMap) selectList.get(i);
			int icustomer = Integer.parseInt(hall.get("icustomer") + "");
			for (int j = selectList.size() - 1; j > i; j--) {
				HashMap hall2 = (HashMap) selectList.get(j);
				int icustomer1 = Integer.parseInt(hall2.get("icustomer") + "");
				if (icustomer == icustomer1) {
					msg = "同一个客商不能有两个服务申请！";
					selectList = null;
					return msg;
				} else {
					flag = true;
				}
			}
		}
		if (flag) {
			for (int i = 0; i < selectList.size(); i++) {
				HashMap hm1 = new HashMap();
				HashMap hall = (HashMap) selectList.get(i);
				int icustomer = Integer.parseInt(hall.get("icustomer") + "");
				int icustperson = Integer.parseInt(hall.get("iid") + "");
				String caddress = hall.get("cofficeaddress") + "";
				HashMap hm0 = new HashMap();
				DateFormat format1 = new SimpleDateFormat("yyyyMMdd");
				hm0.put("icorp", "");
				hm0.put("idepartment", "");
				hm0.put("icustomer", "");
				hm0.put("imaker", imaker);
				hm0.put("iid", 149);

				hm0.put("ctable", "sr_request");
				List frontlist = new ArrayList();
				Date currentTimeInfo = new Date();
				String tcusdate = format1.format(currentTimeInfo);
				hm0.put("frontlist", frontlist);
				hm0.put("cusdate", tcusdate);
				hm0.put("ifuncregedit", 149);

				// 获取单据编码
				HashMap numberMap = acnumberSet.saveNumber(hm0);
				String ccode = numberMap.get("number") == null ? "" : numberMap
						.get("number").toString();
				String ctel = hall.get("ctel") + "";
				String inSql = "insert into sr_request (icustomer,icustperson,caddress,ctel,cdetail,daskprocess,isolution,imaker,iifuncregedit,ccode,dmaker)"
						+ "values(" + icustomer + "," + icustperson;
				if (caddress != null) {
					inSql += ",'" + caddress + "'";
				} else {
					inSql += "," + caddress;
				}
				if (ctel != null) {
					inSql += ",'" + ctel + "','" + cdetail + "','"
							+ daskprocess + "'," + isolutionIid + "," + imaker
							+ ",149,'"+ccode+"','" + dmaker + "')";
				} else {
					inSql += "," + ctel + ",'" + cdetail + "','" + daskprocess
							+ "'," + isolutionIid + "," + imaker
							+ ",149,'"+ccode+"','" + dmaker + "')";
				}

				int siid = this.utilService.InsertSql(inSql);
				HashMap invocieuser = new HashMap();
				invocieuser.put("iinvoice", siid);
				invocieuser.put("ifuncregedit", 149);
				invocieuser.put("irole", 1);
				invocieuser.put("icorp", "");
				invocieuser.put("iperson", imaker);
				this.utilService.insertInvoiceuser(invocieuser);

			}
			msg = "批量插入服务申请成功！";
		}
		return msg;
	}

	/**
	 * 隐式推单 计划推任务
	 * 
	 * @param param
	 */
	public void setPersonTask(HashMap param) throws Exception {
		HashMap hm = new HashMap();
		List sr_projectjobs = new ArrayList();
		sr_projectjobs = (ArrayList) param.get("sr_projectjobs");
		String imodule = (String) param.get("imodule");
		int iinvoice = (Integer) param.get("iid");
		String iproject = (String) param.get("iproject");
		String itype = (String) param.get("itype");
		String icustomer = (String) param.get("icustomer");
		String imaker = (String) param.get("imaker");
		hm.put("imodule", imodule);
		hm.put("iproject", iproject);
		hm.put("itype", itype);
		hm.put("icustomer", icustomer);
		hm.put("imaker", imaker);
		hm.put("cresult", (String) param.get("cresult"));
		// hm.put("iinvoice",iinvoice);
		for (int i = 0; i < sr_projectjobs.size(); i++) {
			HashMap arr2 = (HashMap) sr_projectjobs.get(i);
			hm.put("ilevel", arr2.get("ilevel"));
			hm.put("cdetail", arr2.get("cdetail"));
			hm.put("cmemo", arr2.get("cmemos"));
			hm.put("iperson", arr2.get("iperson"));
			hm.put("dbegin", arr2.get("dbegin"));
			hm.put("dend", arr2.get("dend"));
			hm.put("iinvoice", arr2.get("iid"));// SZC
			HashMap hm1 = new HashMap();
			hm1.put("icorp", "");
			hm1.put("idepartment", "");
			hm1.put("icustomer", icustomer);
			hm1.put("imaker", arr2.get("iperson"));
			hm1.put("iid", 452);
			hm.put("istatus", 1);// SZC

			hm.put("istatusp", imaker);// SZC
			hm1.put("ctable", "sr_projectjob");
			List frontlist = new ArrayList();
			DateFormat format1 = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
			Date currentTimeInfo = new Date();
			String tcusdate = format1.format(currentTimeInfo);
			hm1.put("frontlist", frontlist);
			hm1.put("cusdate", tcusdate);
			hm1.put("ifuncregedit", 452);
			hm.put("dstatus", tcusdate);// SZC

			// 获取单据编码
			HashMap numberMap = acnumberSet.saveNumber(hm1);
			String ccode = numberMap.get("number") == null ? "" : numberMap
					.get("number").toString();
			hm.put("ccode", ccode);
			String insertInfo = "";
			/*
			 * insertInfo=
			 * "insert into sr_projectTask (iproject,itype,icustomer,ilevel,imodule,cmemo,cdetail,imaker,dmaker,ccode) values("
			 * +iproject+","+itype+","+icustomer+"," +
			 * " "+arr2.get("ilevel")+","
			 * +imodule+","+"'"+arr2.get("cmemos")+"'"+
			 * ","+"'"+arr2.get("cdetail"
			 * )+"'"+","+imaker+",getdate(),"+"'"+ccode+"'"+");";
			 */
			int iid = this.utilService.insertTasks(hm);
			HashMap invocieuser = new HashMap();
			invocieuser.put("iinvoice", iid);
			invocieuser.put("ifuncregedit", 452);
			invocieuser.put("irole", 1);
			invocieuser.put("icorp", "");
			invocieuser.put("iperson", arr2.get("iperson"));
			this.utilService.insertInvoiceuser(invocieuser);
			HashMap invocieuser1 = new HashMap();
			invocieuser1.put("iinvoice", iid);
			invocieuser1.put("ifuncregedit", 452);
			invocieuser1.put("irole", 1);
			invocieuser1.put("icorp", "");
			invocieuser1.put("iperson", imaker);
			this.utilService.insertInvoiceuser(invocieuser1);
		}
	}

    /**
     * feild 子表列名，ctable 子表表名， content 条件
     * @param map
     * @return
     * @throws Exception
     */
    public String change2MainFeild(HashMap map) throws Exception {
        String result = "";
        String feild = map.get("feild") + "";
        String ctable = map.get("ctable") + "";
        String content = map.get("content") + "";
        String sql = "select stuff((select '、'+"+feild+" from "+ctable+" where "+content+" for xml path('')),1,1,'') mainfield";
        List<HashMap> list = this.utilService.exeSql(sql);
        if(list.size() > 0 && list != null){
            result = list.get(0).get("mainfield") + "";
        }
        return result;
    }

}
