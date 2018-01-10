/**    
 *
 * 文件名：FileUpLoad.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-8-21    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.utils;

import NT124DOG.NT124JNI;
import yssoft.daos.BaseDao;
import yssoft.servlets.LicenseServlet;

import java.util.HashMap;
import java.util.regex.Pattern;

/**
 * 
 * 项目名称：yscrm 类名称：UpdateDogUtil 类描述：站点升级 创建人：XZQWJ 创建时间：2012-12-08
 * 
 */
public class UpdateDogUtil extends BaseDao {

	NT124JNI nt124jni = new NT124JNI();
	byte[] PidData = new byte[16];

	public static short m_DevNum = 0; // 找到的设备数

	public static int m_handle = -1; // 设备句柄

	public static String m_EVerifyPass = "8888888888888888";// 超级用户密码

	public static short m_st; // 返回状态

	public String updateDog(HashMap params) {
		String Message = null;
		String dog = (String) params.get("dog");
		String pid = "";
		String[] ds = dog.split("\\|");
		String username = ds[1];
		String dog_txt = DesEncryptUtil.decodeDes(ds[0],
				DesEncryptUtil.DEFAULT_KEY);
		String StrData = dog_txt + "|" + username;
		if (LicenseServlet.getLicenseMap().containsKey("RegisterMac")) {
			pid = (String) LicenseServlet.getLicenseMap().get("RegisterMac");
		}
		if (!BeforOnButWrite(dog_txt)) {

			PidData = pid.getBytes();
			m_DevNum = nt124jni.NT124FindDev(PidData);
			if (m_DevNum == 0) {
				Message = "没有找到加密狗";
			} else {
				String str_open = OnButOpen();
				if (str_open != null) {
					return str_open;
				}

				String str_pas = OnButVerifySuperPassword();
				if (str_pas != null) {
					return str_pas;
				}
				String check_use =OnButRead(CharToString(username));
				if(check_use!=null){
					return check_use;
				}
				Message = OnButWrite(StrData);

			}

		}
		return Message;
	}

	/**
	 * 功能：将char转换成对应的中文
	 * 
	 * @param charat
	 * @return
	 */
	public String CharToString(String charat) {
		String str = "";
		char[] dd = charat.toCharArray();
		int size = dd.length;
		int l = size / 5;
		for (int i = 0; i < l; i++) {// 0:0,1,2,3,4 1:5,6,7,8,9
			String str_char = String.valueOf(dd[i * 5])
					+ String.valueOf(dd[i * 5 + 1])
					+ String.valueOf(dd[i * 5 + 2])
					+ String.valueOf(dd[i * 5 + 3])
					+ String.valueOf(dd[i * 5 + 4]);
			str = str + String.valueOf((char) (Integer.parseInt(str_char)));
			// System.out.println(str);
		}
		return str;
	}

	/**
	 * ******************************************************************** 功能:
	 * 打开指定索引的的设备 说明:指定相应的产品ID及相应的索引，如果成功则返回相应的句柄
	 * ********************************************************************
	 */
	public String OnButOpen() {
		String Message = null;
		if (m_DevNum < 1) {
			Message = "没有找到加密狗";
		} else {
			m_handle = nt124jni.NT124OpenDev(PidData, (short) 0);
		}
		if (m_handle < 1) {
			Message = "打开加密狗失败";
		}
		return Message;
	}

	/**
	 * 功能：检验加密狗中的客户名称是否同升级文件中的客户信息相同
	 * @param Lis_name
	 * @param dog_name
	 * @return
	 */
	public String CheckUserName(String Lis_name,String dog_name) {
		String Message = null;
		if(Lis_name!=null&&dog_name!=null&&dog_name.equals(Lis_name)){
			
		}else{
			Message="升级文件错误";
		}
		return Message;
	}

	/**
	 * ******************************************************************** 功能:
	 * 从设备中读取相应的数据 说明:验证密码后就可以读写 默认读写开始地址为0，长度为1024 及地址为0-1024
	 * 验证加密狗中的客户信息是否同升级文件中的客户信息相同
	 * ********************************************************************
	 */
	public String OnButRead(String Lis_name) {
		String Message = null;
		short m_len = 0;
		short m_Add = 0;
		String StrData = "";
		String StrAdd = "0";
		String StrLen = "1024";
		byte[] ReadBuff = new byte[1024];

		if (m_handle < 1) {
			Message = "没有找到加密狗";
		} else {
			
			try {
				m_Add = (short) Integer.parseInt(StrAdd);
				m_len = (short) Integer.parseInt(StrLen);

			} catch (Exception ex) {
				System.out.println("输入数据有误,请重新操作!");
			}

			if ((m_Add + m_len) > 1024)
				m_len = (short) (1024 - m_Add);

			m_st = nt124jni.NT124DevRead(m_handle, m_Add, ReadBuff, m_len);
			if (m_st == nt124jni.OP_OK) {
				for (int i = 0; i < m_len; i++) {
					StrData = StrData + (char) ReadBuff[i];
				}
				System.out.println(StrData);
				if (StrData.indexOf("null") == -1) {
					String[] str = StrData.trim().split("\\|");
					if(str.length==3){//早期制作的加密狗中不含有客户名称
						
					}else if(str.length==5){
						StrData = StrData.replace(str[4], "").trim();
						String cus_name = CharToString(str[4].trim());
						Message=CheckUserName(Lis_name.trim(),cus_name);
						StrData = StrData + cus_name;
					}
					System.out.println("读到的数据为:" + StrData.trim());
				}
			}

		}

		return Message;

	}

	/**
	 * ******************************************************************** 功能:
	 * 校验超级用户密码 说明: 校验正确后，反回相应的校验次数，不限制次时则返回255
	 * ********************************************************************
	 */
	public String OnButVerifySuperPassword() {
		String Message = null;
		byte[] Password = new byte[16];
		short m_len;
		short VerifyNum;
		m_len = (short) m_EVerifyPass.length();

		for (int i = 0; i < m_len; i++) {
			Password[i] = (byte) m_EVerifyPass.charAt(i);
		}

		VerifyNum = nt124jni
				.NT124VerifySuperPassword(m_handle, Password, m_len);
		if (VerifyNum == 0) {
			Message = "加密狗超级用户验证失败";
		} else if (VerifyNum < 0) {
			Message = "加密狗超级用户密码错误";
		}
		return Message;
	}

	/**
	 * ******************************************************************** 功能:
	 * 向设备写数据 说明:如果为超级用户则可以任意写数据，如果某块(64字节)设为只读权限， 普通用户则不能对该块进行写操作，只能读操作。
	 * ********************************************************************
	 */
	public String OnButWrite(String StrData) {
		String Message = null;

		short m_len = 0;
		short m_Add = 0;
		short len = 1024;
		String StrAdd = "0";
		byte[] WriteData = new byte[1024];

		if (m_handle < 1) {
			Message = "没有找到加密狗";
		} else {
			m_Add = (short) Integer.parseInt(StrAdd);
			if (StrData.length() > 1024 || StrData.length() < 1) {
				Message = "升级文件出错";
			} else {

				m_len = (short) StrData.length();
				for (int i = 0; i < m_len; i++) {
					WriteData[i] = (byte) StrData.charAt(i);
				}
				m_st = nt124jni.NT124DevWrite(m_handle, m_Add, WriteData, len);

				nt124jni.NT124CloseDev(m_handle);

				String[] strs = StrData.split("\\|");
				LicenseServlet.getLicenseMap().put("RegisterMaxUser",
						strs[0].trim());
				LicenseServlet.getLicenseMap().put("RegisterCallCenter",
						strs[1].trim());
				LicenseServlet.getLicenseMap().put("RegisterMessage",
						strs[2].trim());
                LicenseServlet.getLicenseMap().put("RegisterMobile",
                        CharToString(strs[3].trim()));
				LicenseServlet.getLicenseMap().put("RegisterCusterName",
						CharToString(strs[4].trim()));

				Message = "站点升级成功，请重新登录";
			}
		}

		return Message;
	}

	public boolean BeforOnButWrite(String str) {
		boolean bool = false;
		String[] strs = str.split("\\|");
		if (strs.length != 4) {
			bool = true;
		}
		for (int i = 0; i < strs.length; i++) {
			if (!isNumeric(strs[i])) {
				bool = true;
				break;
			} else {
				int a = Integer.parseInt(strs[i]);
				bool = false;
				switch (i) {
				case 0:

					break;
				case 1:
					if (a > 100) {
						bool = true;
					}
					break;
				case 2:
					if (a > 1) {
						bool = true;
					}
					break;
				}
				if (bool) {
					break;
				}
			}
		}
		return bool;
	}

	public static boolean isNumeric(String str) {
		Pattern pattern = Pattern.compile("[0-9]*");
		return pattern.matcher(str).matches();
	}

}
