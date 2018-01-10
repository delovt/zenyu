package yssoft.impls;

import com.linkage.netmsg.NetMsgclient;
import com.linkage.netmsg.server.ReceiveMsgImpl;

import yssoft.vos.AbSmsVo;

public class SendMessageTelecomImpl {

	private NetMsgclient smsClient;
	
	public void setSmsClient(NetMsgclient smsClient) {
		this.smsClient = smsClient;
	}
	
	public int conn(String ipAddress, int port, String username, String password) throws Exception {
		int result = 0;
		try {
			if(!ipAddress.equals(smsClient.ipAddress) || port != smsClient.port || !username.equals(smsClient.username) || !password.equals(smsClient.password)) {
				smsClient.initParameters(ipAddress, port, username, password, new ReceiveMsgImpl());
				boolean flag = smsClient.anthenMsg(smsClient);
				if(flag == false) {
					result = 1;
				}
			}else {
				result= 0;
			}
		} catch (Exception e1) {
			e1.printStackTrace();
			result = 1;
		}
		return result;
	}

	public void send(AbSmsVo abSmsVo) throws Exception {
		// TODO Auto-generated method stub
		smsClient.sendMsg(smsClient, 1, abSmsVo.getCmobile(), abSmsVo.getCdetail(), 1);
	}

	public boolean close() throws Exception {
		// TODO Auto-generated method stub
		smsClient.closeConn();
		return true;
	}



}
