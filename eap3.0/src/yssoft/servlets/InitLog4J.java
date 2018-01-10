package yssoft.servlets;

import org.apache.log4j.PropertyConfigurator;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.Properties;

public class InitLog4J extends HttpServlet{

	
	/**
	 * 
	 */
	private static final long serialVersionUID = 6053683294472684582L;

	public void init(ServletConfig config) throws ServletException {
		  super.init();
		  String prefix = config.getServletContext().getRealPath("/");
		  String file = config.getInitParameter("log4j");
		  String filePath = prefix + file;
		  Properties props = new Properties();
		  try {
		   FileInputStream istream = new FileInputStream(filePath);
		   props.load(istream);
		   istream.close();
		   String logFile = prefix
		     + props.getProperty("log4j.appender.logfile.File");// 设置路径，对应配置文件中的名称
		   props.setProperty("log4j.appender.logfile.File", logFile);
		   // 装入log4j配置信息
		   PropertyConfigurator.configure(props);
		  } catch (IOException e) {
		   System.out.println("Could not read configuration file [" + filePath
		     + "].");
		   System.out.println("Ignoring configuration file [" + filePath
		     + "].");
		   return;
		  }
		 }
}
