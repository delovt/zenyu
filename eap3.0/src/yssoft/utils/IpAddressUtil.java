package yssoft.utils;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;


/**
 * IP and 地理位置
 * @author 孙东亚
 *
 */
public class IpAddressUtil {
	
	
	/**
	 * 获取当前用户IP 以及 地理信息
	 * @return 
	 */
	public String getIpAndAddress()
	{
		
		try {
			
			
			URL url = new URL("http://fw.qq.com/ipaddress"); //腾讯接口 http://pv.sohu.com/cityjson?ie=utf-8 搜狐
			
			URLConnection   connection   =   url.openConnection(); 
			connection.connect(); 

			BufferedReader inreader = new BufferedReader( new InputStreamReader(connection.getInputStream(),"GB2312"));
			
			String str = null;
			if(inreader.ready() )
			{
				str = inreader.readLine();
			}
			String[] strArr_0 = str.split("Array");
			str = strArr_0[1].replaceAll("\"","");	
			String[] strArr_1 =str.substring(1,str.length()-2).split(","); 
			String ip = strArr_1[0];
			String province  = strArr_1[2];
			String city = strArr_1[3];
			str = "当前IP："+ip+" 当前地理位置："+province+city;
			
			System.out.println("★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★★"+str);
			
		
		
		} catch (MalformedURLException e) {
			e.printStackTrace();
			System.out.println("解析API地址错误!");
		} catch (IOException e) {
			e.printStackTrace();
			System.out.println("打开链接异常!");
		}
		
		
		return "";
	}
	
	
	
	
	public static void main(String[] args) {
		IpAddressUtil u = new IpAddressUtil();
		u.getIpAndAddress();
	}
	
}
