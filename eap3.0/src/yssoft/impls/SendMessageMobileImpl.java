package yssoft.impls;

import java.util.Iterator;
import java.util.List;

import org.apache.axis.client.Call;
import org.apache.axis.client.Service;
import javax.xml.namespace.QName;

import com.linkage.netmsg.NetMsgclient;
import com.linkage.netmsg.server.ReceiveMsgImpl;

import yssoft.vos.AbSmsVo;

public class SendMessageMobileImpl {
	
	private String ipAddress = "";
	
	private String username = "";
	
	private String reqXML = "";
	
	Call call = null;

	public int conn(String ipAddress, int port, String username, String password) throws Exception {
		int result = 0;
		if(!this.ipAddress.equals(ipAddress) || !this.username.equals(username)) {
			this.ipAddress = ipAddress;
			this.username = username;
			String endpoint = "http://" + ipAddress + "/services/RemoteSendSMS";

			try {
				Service service = new Service();
				call = (Call) service.createCall();
				call.setOperationName(new QName(endpoint,"sendSMS"));
				call.setTargetEndpointAddress(new java.net.URL(endpoint));
			} catch (Exception e) {
				e.printStackTrace();
				result = 1;
			} 
			reqXML = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
					+"<SendSMSReq>"
					+"<HEAD><AppNumber>111111111</AppNumber>"
					+"<CertSerialNumber>0000000000</CertSerialNumber></HEAD>"
					+"<BODY>"
					+"<Phone>cmobile</Phone>"
					+"<Msg>cdetail</Msg>"
					+"<ExNumber>" + username + "</ExNumber>"
					+"<TimeFlag>0</TimeFlag>"
					+"<SMSTime>"+System.currentTimeMillis()+"</SMSTime>"
					+"<MsgFlag>backup</MsgFlag>"
					+"</BODY></SendSMSReq>";
		}else {
			result = 0;
		}	
		return result;
	}

	//MAS用于移动发送短信
	public void sendMessage(AbSmsVo abSmsVo) throws Exception {
		reqXML.replaceAll("cmobile", abSmsVo.getCmobile());
		reqXML.replaceAll("cdetail", abSmsVo.getCdetail());
	    call.invoke(new Object[]{reqXML});
	}

	public boolean close() throws Exception {
		// TODO Auto-generated method stub
		return true;
	}



}
