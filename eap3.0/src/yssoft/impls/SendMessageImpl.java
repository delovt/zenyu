package yssoft.impls;

import com.linkage.netmsg.NetMsgclient;
import com.linkage.netmsg.server.ReceiveMsgImpl;
import yssoft.daos.BaseDao;
import yssoft.utils.DesEncryptUtil;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;

@SuppressWarnings("serial")
public class SendMessageImpl extends BaseDao  {

	public SendMessageImpl(){}
	
	//用于移动短信的连接
//	static String endpoint = "http://221.178.238.6/services/RemoteSendSMS";
//	static Call call = null;
//	static {
//		try {
//			Service service = new Service();
//			call = (Call) service.createCall();
//			call.setOperationName(new QName(endpoint,"sendSMS"));
//			call.setTargetEndpointAddress(new java.net.URL(endpoint));
//		} catch (Exception e) {
//			e.printStackTrace();
//		} 
//	}
		
	private List<HashMap> smssets = null;
	private NetMsgclient smsClient = new NetMsgclient();
	private boolean flag = false;
	public void initConn() {
		HashMap hashmap = new HashMap(); 
		hashmap.put("sqlvalue", "select * from as_smsset");
		smssets = queryForList("SendMessage.search",hashmap);	
		try {
			for(int i=0; i < smssets.size(); i++) {
				if(smssets.get(i).get("cname").toString().equals("1")) {
					smsClient.ipAddress = smssets.get(i).get("caddress").toString();
					smsClient.port = Integer.parseInt(smssets.get(i).get("cport").toString());
					smsClient.username = smssets.get(i).get("cuser").toString();
					smsClient.password = DesEncryptUtil.decodeDes(smssets.get(i).get("cpassword").toString(), DesEncryptUtil.DEFAULT_KEY);
					if(smsClient.socket == null || smsClient.socket.isClosed()) {
						smsClient.initParameters(smsClient.ipAddress, smsClient.port, smsClient.username, smsClient.password, new ReceiveMsgImpl());
						flag = smsClient.anthenMsg(smsClient);
					}
				}
			}		
		} catch (Exception e1) {
			e1.printStackTrace();
		}
	}
	
	//刷新电话前缀
	public void reConn() {
		
	}
	
	//获得电话号码和发送人
	public List onGetMessage(ArrayList<HashMap> param){
		if(param.size() < 1) {
			return null;
		}
		List list = null;
		List listTemp = null;
		String sql = "";
		HashMap hm = new HashMap();
		String iids = "";
		String ccusname = "";
		String cmobile = "";
		try{
			for(int i=0; i<param.size(); i++) {
				sql = "select * from AB_sms where icustperson =" + param.get(i).get("iid").toString() + " and ifuncregedit= " + param.get(i).get("ifuncregedit").toString() + " and istate=0";
				hm.put("sqlvalue", sql);
				listTemp = this.queryForList("SendMessage.search",hm);
				hm.clear();
				sql = "";
				if(listTemp == null || listTemp.size() == 0) {
					if(param.get(i).get("ccusname") != null) {
						ccusname = param.get(i).get("ccusname").toString();
					}
					if(param.get(i).get("cmobile1") != null) {
						cmobile = param.get(i).get("cmobile1").toString();
					}
					sql = "insert into AB_sms (ccusname,icustperson,cpsnname,ctitle,cmobile,istate,imaker,dmaker,ifuncregedit) values ('" + ccusname + "'," + param.get(i).get("iid").toString() + ",'" + param.get(i).get("cname").toString() + "','" + param.get(i).get("cpstname").toString() + "','" + cmobile + "',0," + param.get(i).get("imaker").toString() + ",getdate()," + param.get(i).get("ifuncregedit").toString() + ")";
					hm.put("sqlvalue", sql);
					this.insert("SendMessage.insert", hm);
					hm.clear();
					sql = "";
				}
				listTemp.clear();
				iids += param.get(i).get("iid").toString() + ",";
			}
			iids = iids.substring(0, iids.lastIndexOf(","));
			sql = "select ab.iid,ab.ifuncregedit,ab.iinvoice, ab.ccusname,ab.cpsnname,ab.ctitle,ab.cdetail,ab.cmobile,hp.cname imaker,ab.dmaker,hp2.cname iverify,ab.dverify,ab.istate from AB_sms ab left join hr_person hp on ab.imaker=hp.iid left join hr_person hp2 on ab.iverify=hp2.iid   where ab.icustperson in (" + iids + ") and ab.ifuncregedit=" + param.get(0).get("ifuncregedit").toString() + " and istate=0";
			hm.put("sqlvalue", sql);
			list = this.queryForList("SendMessage.search",hm);
			hm.clear();
		}catch(Exception ex){
			ex.printStackTrace();
		}
		finally{
			
		}
		
		return list;
		
	}
	
	//发送短信
	public String onSendMessage(ArrayList<HashMap> param){
		
		String rstr = "发送成功！";
		String sql  = "";
		HashMap hmp = new HashMap();
		String isOverWrite = param.get(0).get("isOverWrite").toString();
		String cdetailForQuick = param.get(0).get("cdetailForSend").toString();
		String cdetail = "";
		String cmobile = "";
		String type = "";
		for(int i=0;i<param.size();i++){
			
			cmobile = param.get(i).get("cmobile").toString();
			if (cmobile.startsWith("0") || cmobile.startsWith("+860")) {
				cmobile = cmobile.substring(cmobile.indexOf("0") + 1, cmobile.length());
			}
			if(isOverWrite.equals("false")) {
				if(param.get(i).get("cdetail") == null || param.get(i).get("cdetail").toString().equals("")) {
					cdetail = param.get(i).get("cdetailForSend").toString();
				}else {
					cdetail = param.get(i).get("cdetail").toString();
				}
			}else {
				cdetail = cdetailForQuick;
			}
			if(cmobile == null || cmobile == "") {
				rstr = param.get(i).get("cpsnname").toString() + "的手机号为空，请先填写手机号！";
			} else {
				try {
//					type = SendMessageImpl.getMobileType(cmobile);
					for(int j=0; j < smssets.size(); j++) {
						if(smssets.get(j).get("cname").toString().equals("1")) {
							if(smssets.get(j).get("cphoneprefix").toString().contains(cmobile.substring(0, 3)) || smssets.get(j).get("cphoneprefix").toString().contains(cmobile.substring(0, 4))) {
								type = "3";
							}
						}else if(smssets.get(j).get("cname").equals("2") || smssets.get(j).get("cname").equals("3")) {
							if(smssets.get(j).get("cphoneprefix").toString().contains(cmobile.substring(0, 3)) || smssets.get(j).get("cphoneprefix").toString().contains(cmobile.substring(0, 4))) {
								type = "1";
							}
						}
					}
					if(type.equals("2") || type.equals("1")) {
//						SendMessageImpl.sendMesSMPP(cmobile, cdetail);
						return rstr = "还没有配置移动网关！";
					}else if(type.equals("3")) {
						if(flag) {
							smsClient.sendMsg(smsClient, 1, cmobile, cdetail, 1);
						}else {
							return rstr = "连接错误，请稍后再试！";
						}
					}else {
						return rstr = "手机号不在运营商服务范围";
					}
					
					sql = "update AB_sms set cdetail='" + cdetail + "',istate=1,iverify=" + param.get(i).get("iverify").toString() + ",dverify=getdate()   where iid=" + param.get(i).get("iid").toString();
					hmp.put("sqlvalue", sql);
					try{
						this.update("SendMessage.update",hmp);
					}catch(Exception ex){
						rstr = "发送成功，但数据库更新失败！";
						ex.printStackTrace();
					}finally{
						hmp.clear();
						sql = "";
					}
				} catch (Exception e) {
					e.printStackTrace();
					rstr = "发送失败！";
				}
							
			}
			
		}
		return rstr;
	}

	//SMPP协议，用于移动发送短信
//	public static void sendMesSMPP(String phone, String content) throws Exception {
//		String reqXML = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
//			+"<SendSMSReq>"
//			+"<HEAD><AppNumber>111111111</AppNumber>"
//			+"<CertSerialNumber>0000000000</CertSerialNumber></HEAD>"
//			+"<BODY>"
//			+"<Phone>"+phone+"</Phone>"
//			+"<Msg>"+content+"</Msg>"
//			+"<ExNumber>911</ExNumber>"
//			+"<TimeFlag>0</TimeFlag>"
//			+"<SMSTime>"+System.currentTimeMillis()+"</SMSTime>"
//			+"<MsgFlag>backup</MsgFlag>"
//			+"</BODY></SendSMSReq>";
//	    call.invoke(new Object[]{reqXML});
//	}
	
	public List onRefresh(ArrayList<HashMap> param){
		List listparam = null;
		String iids = "";
		for(int i=0; i<param.size(); i++) {
			iids += param.get(i).get("iid") + ",";
		}
		iids = iids.substring(0, iids.lastIndexOf(","));
		String sql = "select ab.iid,ab.ifuncregedit,ab.iinvoice,ab.ccusname,ab.cpsnname,ab.ctitle,ab.cdetail,ab.cmobile,hp.cname imaker,ab.dmaker,hp2.cname iverify,ab.dverify,ab.istate from AB_sms ab left join hr_person hp on ab.imaker=hp.iid left join hr_person hp2 on ab.iverify=hp2.iid   where ab.iid in (" + iids + ")";
		HashMap hsmp = new HashMap();
		hsmp.put("sqlvalue", sql);
		listparam = this.queryForList("SendMessage.search", hsmp);
		return listparam;
	}
	
	public List onInsert(int ifuncregedit) {
		List listparam = null;
		String sql = "select ab.iid,ab.ifuncregedit,ab.iinvoice,ab.ccusname,ab.cpsnname,ab.ctitle,ab.cdetail,ab.cmobile,hp.cname imaker,ab.dmaker,hp2.cname iverify,ab.dverify,ab.istate from AB_sms ab left join hr_person hp on ab.imaker=hp.iid left join hr_person hp2 on ab.iverify=hp2.iid   where ab.ifuncregedit = " + ifuncregedit + " and ab.istate = 0";
		HashMap hsmp = new HashMap();
		hsmp.put("sqlvalue", sql);
		listparam = this.queryForList("SendMessage.search", hsmp);
		return listparam;
	}
	
	//保存要发的短信
	public List onJustSave(ArrayList<HashMap> param) {
		List listparam = null;
		String isOverWrite = param.get(0).get("isOverWrite").toString();
		String imaker = param.get(0).get("imaker").toString();
		String iids = "";
		String sqlUpdate = "";
		HashMap hm = new HashMap();
		for(int i=0; i < param.size(); i++) {
			iids += param.get(i).get("iid") + ",";
			if(isOverWrite.equals("true")) {
				sqlUpdate = "update AB_sms set cdetail='" + param.get(i).get("cdetailForSend").toString() + "' , imaker=" + imaker + " , dmaker=getdate(),istate=0  where iid=" + param.get(i).get("iid").toString();
			}else {
				if(param.get(i).get("cdetail") == null || param.get(i).get("cdetail").toString() == "") {
					sqlUpdate = "update AB_sms set cdetail='" + param.get(i).get("cdetailForSend").toString() + "' , imaker=" + imaker + " , dmaker=getdate(),istate=0 where iid=" + param.get(i).get("iid").toString();
				}else {
					sqlUpdate = "update AB_sms set cdetail='" + param.get(i).get("cdetail").toString() + "' , imaker=" + imaker + " , dmaker=getdate(),istate=0 where iid=" + param.get(i).get("iid").toString();
				}
			}
			hm.put("sqlvalue", sqlUpdate);
			try {
				this.update("SendMessage.update", hm);
			} catch (Exception e) {
				e.printStackTrace();
			}
			hm.clear();
		}
		iids = iids.substring(0, iids.lastIndexOf(","));	
		String sql = "select ab.iid,ab.ifuncregedit,ab.iinvoice,ab.ccusname,ab.cpsnname,ab.ctitle,ab.cdetail,ab.cmobile,hp.cname imaker,ab.dmaker,hp2.cname iverify,ab.dverify,ab.istate from AB_sms ab left join hr_person hp on ab.imaker=hp.iid left join hr_person hp2 on ab.iverify=hp2.iid   where ab.iid in(" + iids + ") and ab.istate = 0";
		HashMap hsmp = new HashMap();
		hsmp.put("sqlvalue", sql);
		listparam = this.queryForList("SendMessage.search", hsmp);
		return listparam;
	}
	
	public String onDelete(ArrayList<HashMap> param) {
		String str = "删除成功";
		String iids = "";
		for(int i=0; i<param.size(); i++) {
			iids += param.get(i).get("iid") + ",";
		}
		iids = iids.substring(0, iids.lastIndexOf(","));
		String sql = "delete from AB_sms where iid in (" + iids + ")";
		HashMap hsmp = new HashMap();
		hsmp.put("sqlvalue", sql);
		try {
			this.delete("SendMessage.delete", hsmp);
		}catch (Exception e) {
			e.printStackTrace();
			str = "删除失败";
		}
		return str;
	}
	
	public List<HashMap> onQuery(int ifuncregedit) {
		String sql = "select ab.iid,ab.ifuncregedit,ab.iinvoice,ab.ccusname,ab.cpsnname,ab.ctitle,ab.cdetail,ab.cmobile,hp.cname imaker,ab.dmaker,hp2.cname iverify,ab.dverify,ab.istate from AB_sms ab left join hr_person hp on ab.imaker=hp.iid left join hr_person hp2 on ab.iverify=hp2.iid   where ab.ifuncregedit in(" + ifuncregedit + ") and ab.istate = 1";
		HashMap hsmp = new HashMap();
		hsmp.put("sqlvalue", sql);
		return this.queryForList("SendMessage.search", hsmp);
	}
	
	//判断号码服务商（已废弃）
	public static String getMobileType(String mobile) {
		if (mobile.startsWith("0") || mobile.startsWith("+860")) {
			mobile = mobile.substring(mobile.indexOf("0") + 1, mobile.length());
		}
		//List chinaUnicom = Arrays.asList(new String[] { "130", "131", "132","133" });
		List chinaUnicom = Arrays.asList(new String[] { "130", "131", "132","155","156","185","186" });
		List chinaUnicom2 = Arrays.asList(new String[] { "1452" });
		List chinaMobile1 = Arrays.asList(new String[] { "135", "136", "137",
				"138",  "139", "147", "150", "151","152","157" ,"158", "159","182","183" ,"187","188"});
		List chinaMobile2 = Arrays.asList(new String[] { "1340", "1341",
				"1342", "1343", "1344", "1345", "1346", "1347", "1348" });

		boolean bolChinaUnicom = (chinaUnicom.contains(mobile.substring(0, 3)));
		boolean bolChinaMobile1 = (chinaMobile1
				.contains(mobile.substring(0, 3)));
		boolean bolChinaMobile2 = (chinaMobile2
				.contains(mobile.substring(0, 4)));
		boolean bolChinaUnicom2 = (chinaUnicom2
				.contains(mobile.substring(0, 4)));
		
		if (bolChinaMobile1 || bolChinaMobile2)
			return "2"; // 移动
		if (bolChinaUnicom || bolChinaUnicom2)
			return "1";// 联通
		return "3"; // 其他为电信
	}
	
}
