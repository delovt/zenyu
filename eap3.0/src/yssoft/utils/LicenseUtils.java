package yssoft.utils;

import java.io.IOException;
import java.io.InputStream;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Properties;

public class LicenseUtils {

	public  static HashMap getLicenseInfo()
	{
		HashMap map = new HashMap();
		
		//String filepath=this.getClass().getResource("/").getFile();
		//System.out.println(filepath);
		
		InputStream inputStream =LicenseUtils.class.getClassLoader().getResourceAsStream("license.properties");    
		Properties p = new Properties();    
		try
		{    
		   p.load(inputStream);    
		} catch (IOException e) 
		{    
		   e.printStackTrace();    
		}
		
		Enumeration em = p.propertyNames();
		
		while( em.hasMoreElements() )
		{
			String name = "";
			String value = "";
			name = em.nextElement().toString();
			value = p.getProperty(name);
			map.put(name, value);
		}
		
		return map;
	}
	
}
