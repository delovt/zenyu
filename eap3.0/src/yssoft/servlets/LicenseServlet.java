package yssoft.servlets;

import NT124DOG.NT124JNI;
import yssoft.utils.*;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import java.io.*;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.Properties;

/**
 * 初始化服务器的时候会加载这个类
 * 
 * @author zwl
 * @date 2102-07-08
 * 
 */
public class LicenseServlet extends HttpServlet {

	private boolean Flag = true;
	private static final long serialVersionUID = -5730222790117753932L;
	private static HashMap<String, String> licenseMap = new HashMap<String, String>();

	public static short m_DevNum = 0; // 找到的设备数
	public static int m_handle = -1; // 设备句柄
	public static String m_EVerifyPass = "8888888888888888";// 超级用户密码
	public static short m_st; // 返回状态
	byte[] PidData = new byte[16];
	NT124JNI nt124jni = new NT124JNI();

	public static Date str_date;
	public static Date currDate;
	public static int days;
	Calendar cal = Calendar.getInstance();
	SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");

	public Boolean isFileExit = true;

	// 获取加载的license.properties解密后的内容
	public static HashMap<String, String> getLicenseMap() {
		return licenseMap;
	}

	public LicenseServlet() {
		super();
	}

	/**
	 * 作者：XZQWJ 日期：2012-11-26
	 * ******************************************************************** 功能:
	 * 打开指定索引的的设备 说明:指定相应的产品ID及相应的索引，如果成功则返回相应的句柄
	 * ********************************************************************
	 */
	public void OnButOpen() {
		if (m_DevNum < 1) {
			System.out.println("没有设备，请重新进行查找操作!");
			System.exit(0);
		} else {
			m_handle = nt124jni.NT124OpenDev(PidData, (short) 0);
		}
		if (m_handle < 1) {
			System.out.println("打开设备失败!");
			System.exit(0);
			return;
		} else {

			System.out.println("打开设备成功!");
		}
	}

	/**
	 * 作者：XZQWJ 日期：2012-11-26
	 ********************************************************************* 
	 * 功能: 校验超级用户密码 说明: 校验正确后，反回相应的校验次数，不限制次时则返回255
	 ********************************************************************* 
	 */
	public void OnButVerifySuperPassword() {
		byte[] Password = new byte[16];
		short m_len;
		short VerifyNum;
		m_len = (short) m_EVerifyPass.length();
		for (int i = 0; i < m_len; i++) {
			Password[i] = (byte) m_EVerifyPass.charAt(i);
		}
		VerifyNum = nt124jni
				.NT124VerifySuperPassword(m_handle, Password, m_len);
		System.out.println(VerifyNum);
		if (VerifyNum == 0) {
			System.out.println("对不起，校验失败!");
			System.exit(0);
		}
		if (VerifyNum < 0) {
			System.out.println("对不起，密码错误!");
			// CheckErr(VerifyNum);
			System.exit(0);
		}
		System.out.println("检验成功");

	}

	/**
	 * 作者：XZQWJ 日期：2012-11-26
	 ********************************************************************* 
	 * 功能: 从设备中读取相应的数据 说明:验证密码后就可以读写 默认读写开始地址为0，长度为64 及地址为0-63
	 ********************************************************************* 
	 */
	public String OnButRead() {
		short m_len = 0;
		short m_Add = 0;
		String StrData = "";
		String StrAdd = "0";
		String StrLen = "1024";
		byte[] ReadBuff = new byte[1024];
		m_Add = (short) Integer.parseInt(StrAdd);
		m_len = (short) Integer.parseInt(StrLen);
		if ((m_Add + m_len) > 1024) {
			m_len = (short) (1024 - m_Add);
		}
		m_st = nt124jni.NT124DevRead(m_handle, m_Add, ReadBuff, m_len);
		if (m_st == nt124jni.OP_OK) {
			for (int i = 0; i < m_len; i++) {
				StrData = StrData + (char) ReadBuff[i];
			}
			System.out.println("读到的数据为:" + StrData.trim());
		}
		nt124jni.NT124CloseDev(m_handle);
		return StrData;

	}

	/**
	 * 作者：XZQWJ 日期：2012-11-26
	 ********************************************************************* 
	 * 功能:获取产品编号 说明:无须校验密码直接获取
	 ********************************************************************* 
	 */
	public String OnButProduct() {
		byte[] PidData = new byte[16];
		int i;
		String StrPid = "";

		if (m_handle < 1) {
			System.exit(0);
		}

		m_st = nt124jni.NT124GetPID(m_handle, PidData);
		if (m_st == nt124jni.OP_OK) {
			for (i = 0; i < 16; i++) {
				StrPid = StrPid + (char) PidData[i];
			}
			System.out.println("产品编号为:" + StrPid);
		}
		return StrPid;
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
		}
		return str;
	}

	public void creatFile() {
		Properties properties = new Properties();
		String path = this.getClass().getResource("/").getFile()
				+ "version.properties";
		String filepath = this.getClass().getResource("/").getFile()
				+ "license.properties";
		// Properties properties = new Properties();
		File ff = new File(filepath);
		File f = new File(path);
		currDate = new Date();
		cal.setTimeInMillis(ff.lastModified());
		str_date = cal.getTime();
		days = ToolUtil.getDaySub(String.valueOf(formatter.format(str_date)),
				String.valueOf(formatter.format(currDate)));

		if (days == 0) {
			if (!f.exists()) {// 文件不存在则创建
				try {
					f.createNewFile();
					OutputStream o = new FileOutputStream(path);
					EncryptUtil encryptUtil = new EncryptUtil();// 默认密钥
					String yseap = encryptUtil.encrypt(formatter
							.format(str_date) + "@" + "1");
					properties.setProperty("yseap", yseap);
					properties.store(o, "yseap");
					o.close();
				} catch (IOException e) {
					e.printStackTrace();
				} catch (Exception e) {
					e.printStackTrace();
				}
			} else {
				try {
					FileInputStream fis = new FileInputStream(path);
					Properties p = new Properties();
					p.load(fis);
					String yseap = p.getProperty("yseap");
					EncryptUtil encryptUtil = new EncryptUtil();// 默认密钥
					yseap = encryptUtil.decrypt(yseap);

					fis.close();
					String str[] = yseap.split("@");
					String s_days = str[1].trim();
					days = days + Integer.parseInt(s_days);
				} catch (IOException e) {
					e.printStackTrace();
				} catch (Exception e) {
					e.printStackTrace();
				}
			}
		} else {
			if (!f.exists()) {
				isFileExit = false;
			}
		}
	}

	public void checkEdog() {
		Properties p = new Properties();
		String filepath = this.getClass().getResource("/").getFile()
				+ "license.properties";
		File f = new File(filepath);
		String edog = "";
		edog = CPUSerialUtil.getCCMCode();
		if (edog.equals("")) {
			edog = "0000000000";
		}
		if (!f.exists()) {// 文件不存在则创建
			try {
				f.createNewFile();
				OutputStream o = new FileOutputStream(filepath);
				EncryptUtil encryptUtil = new EncryptUtil();// 默认密钥
				edog = encryptUtil.encrypt(edog);// 加密
				p.setProperty("edog", edog);
				p.store(o, "edog");
				o.close();

			} catch (Exception e) {
				e.printStackTrace();
			}

		} else {
			try {
				FileInputStream fis1 = new FileInputStream(filepath);
				p.load(fis1);
				EncryptUtil encryptUtil = new EncryptUtil();// 默认密钥
				String dog = p.getProperty("edog");// +""
				if ("".equals(dog) || dog == null) {
					OutputStream o = new FileOutputStream(filepath);
					edog = encryptUtil.encrypt(edog);// 加密
					p.setProperty("edog", edog);//"-" + 
					p.store(o, "edog");
					o.close();
				} else {
					edog = encryptUtil.encrypt(edog);// 加密
				}
				String dog1 = p.getProperty("edog");
				if (dog1.equals(edog)) {
					// 相同 
					System.out.println("服务器信息验证成功！");
				} else {
					// 不相同
					System.out.println("服务器信息验证不正确！");
					System.exit(0);
				}

				fis1.close();

			} catch (Exception e) {
				e.printStackTrace();
			}

		}

	}

	public void init() throws ServletException {
		// 获取项目名称
		ServletContext s1 = this.getServletContext();
		// String temp = s1.getRealPath("");
		// String projectName = temp.substring(temp.lastIndexOf("webapps") +
		// 8,temp.length());

		creatFile();
		checkEdog();
		
		HashMap map = LicenseUtils.getLicenseInfo();// 获取licsene.properties返回到一个HashMap
		String signature = (String) map.get("Product.signature");
		String edog = (String) map.get("Product.edog");
		
		String RegisterMac = "";// 机器码
		String RegisterProject = "eap1.0";// 项目名称

		String projectName = "YS" + RegisterProject;

		String RegisterMaxUser = "";// 授权数
		String RegisterCallCenter = "4";// 呼叫中心
		String RegisterMessage = "";// 短信平台 0启用 1不启用
		String RegisterCusterName = "";// 客户名称
		String RegisterMobile = ""; // 手机端许可数

		String RegisterVersion = "";// 正式版或试用版
		String RegisterDays = "";// //试用版天数,如为正式版则该值为0

		// -----开始：XZQWJ 2012-11-26 修改
		// 功能：读取licsene.properties文件，判断是否使用加密狗----------------
		if (signature.split("-").length == 1) {// 加密狗
			if (signature.length() > 16) {
				signature = DesEncryptUtil.decodeDes(signature,
						DesEncryptUtil.DEFAULT_KEY);
			}
			RegisterMac = signature;
			PidData = RegisterMac.trim().getBytes();
			m_DevNum = nt124jni.NT124FindDev(PidData);

			if (m_DevNum == 0) {// 没有找到加密狗
				System.out.println("没有找到加密狗");
				System.exit(0);

			} else {
				OnButOpen();
				OnButVerifySuperPassword();
				String str = OnButRead();
				String[] strs = str.split("\\|");
				RegisterMaxUser = strs[0].trim();
				RegisterCallCenter = strs[1].trim();
				RegisterMessage = strs[2].trim();
				RegisterMobile = strs[3].trim();
				if (strs.length == 5) {
					RegisterCusterName = CharToString(strs[4].trim());
				}

				licenseMap.put("nt124dog", "nt124dog");
				licenseMap.put("RegisterMac", RegisterMac);
				licenseMap.put("RegisterMaxUser", RegisterMaxUser);
				licenseMap.put("RegisterCallCenter", RegisterCallCenter);
				licenseMap.put("RegisterMessage", RegisterMessage);
				licenseMap.put("RegisterProject", RegisterProject);
				licenseMap.put("RegisterCusterName", RegisterCusterName);
				licenseMap.put("RegisterMobile", RegisterMobile);
				licenseMap.put("RegisterExpire", "true");
				System.out.println("加密狗验证成功");
				System.out.println("版权所有：徐州市增宇软件有限公司；" + "授权使用单位："
						+ RegisterCusterName);
				System.out.println(signature);
			}

			// ------结束----------------------------------------------------------------------------------------
		} else {// 注册文件
			// 获取本机的mac地址
			// 修改人：刘磊 2012-8-30 获取机器码
			// String macAddress=MacUtils.getMac();
			String macAddress = CPUSerialUtil.getMachineCode();
			if (macAddress == null || macAddress == "") {// 获取不到的话设置Flag
				Flag = false;
			}
			try {
				Boolean bool = true;
				RegisterVersion = "0";
				RegisterDays = "0";
				RegisterMobile = "0";
				EncryptUtil encryptUtil = new EncryptUtil();// 创建加密解密实例
				// LicenseUtils licenseUtils=new LicenseUtils();//创建license工具类实例
				String[] sign = signature.split("-");
				RegisterMac = encryptUtil.decrypt(sign[0]);
				RegisterProject = encryptUtil.decrypt(sign[1]);
				RegisterMaxUser = encryptUtil.decrypt(sign[2]);
				RegisterMobile = encryptUtil.decrypt(sign[3]);// 获取软加密手机端许可数

				licenseMap.put("RegisterMac", RegisterMac);
				licenseMap.put("RegisterProject", RegisterProject);
				licenseMap.put("RegisterMaxUser", RegisterMaxUser);
				licenseMap.put("RegisterMessage", RegisterMessage);
				licenseMap.put("RegisterCallCenter", RegisterCallCenter);
				licenseMap.put("RegisterMobile", RegisterMobile);

				if (!RegisterMac.equals(".")) {// 正式版本
					licenseMap.put("RegisterVersion", RegisterVersion);
					licenseMap.put("RegisterDays", RegisterDays);
					bool = true;
				}

				if (RegisterMac.equals(".")) {// 试用版本

					RegisterVersion = encryptUtil.decrypt(sign[3]);
					RegisterDays = encryptUtil.decrypt(sign[4]);

					licenseMap.put("RegisterVersion", RegisterVersion);
					licenseMap.put("RegisterDays", RegisterDays);

					if (isFileExit) {// 记录最后一次登录系统的日期文件是否存在
					// int days = currDate.compareTo(str_date) + 1;
						int all_days = Integer.parseInt(RegisterDays);

						if (all_days <= days || days < 0) {// 试用到期
							bool = false;
						}
					} else {
						bool = false;
					}
				}
				licenseMap.put("RegisterExpire", bool.toString());
				// String
				// registerProject=signature.substring(0,2)+signature.substring(58,signature.length());
				// System.out.println("注册项目=="+registerProject);

				if (RegisterMac.equals(".")) {
					System.out.println("试用版本");
				} else {
					// mac地址正确 并且项目名称正确
					if (projectName.equalsIgnoreCase(RegisterProject)
							&& macAddress.equalsIgnoreCase(RegisterMac)) {
						System.out.println("签名正确！");
					} else {
						System.out.println("签名失败！");
						System.exit(0);
						Flag = false;
					}
				}
			} catch (Exception e) {
				Flag = false;
				System.out.println("注册文件不存在或者注册信息不正确！");
				System.exit(0);
				e.printStackTrace();
			}
		}
		// 验证失败关闭服务器
		if (Flag == false) {
			licenseMap.put("RegisterMaxUser", "0");
			// ProcessManager.killProcess();
		}

	}
}