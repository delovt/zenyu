/**    
 *
 * 文件名：PrintServlet.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-10-19    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.servlets;

import net.sf.jasperreports.engine.*;
import net.sf.jasperreports.engine.export.JRHtmlExporter;
import net.sf.jasperreports.engine.export.JRHtmlExporterParameter;
import net.sf.jasperreports.engine.util.JRLoader;
import net.sf.jasperreports.j2ee.servlets.ImageServlet;
import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
import yssoft.services.IPrintService;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import javax.sql.DataSource;
import java.io.File;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.util.HashMap;

/**    
 *     
 * 项目名称：rkycrm_zg    
 * 类名称：PrintServlet    
 * 类描述：    
 * 创建人：朱毛毛 
 * 创建时间：2011-2011-10-19 上午08:43:57        
 *     
 */
public class PrintServlet extends HttpServlet {

	private ServletConfig config=null;
	private DataSource dataSource=null;
	private Connection conn=null;
	
	private IPrintService iPrintService=null;
	
	
	@Override
	public void init(ServletConfig config) throws ServletException {
		super.init(config);
		this.config=config;
		WebApplicationContext wac=WebApplicationContextUtils.getRequiredWebApplicationContext(getServletContext());  
		dataSource = (DataSource)wac.getBean("DataSource");
		iPrintService=(IPrintService) wac.getBean("iPrintService");
	}
	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doPost(req, resp);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		//打印模板路径
		String ifunid=request.getParameter("ifunid");	//功能注册码iid
		String iids=request.getParameter("iids");	//iids 集合
		
		System.out.println("功能注册码ifunid[" + ifunid+"]");
		System.out.println("前台传递的iids集合["+iids+"]");
		
		
		response.setContentType("text/html;charset=UTF-8");
        request.setCharacterEncoding("UTF-8");
		
		PrintWriter out=null;
		HashMap printMap=null;
		try{
			out = response.getWriter();
		if(ifunid==null || ifunid==""){
			getRetInfo("功能注册码参数，传递错误",out);
			return;
		}
		if(iids==null || iids==""){
			getRetInfo("iids集合参数，传递错误",out);
			return;
		}
			
		if(dataSource==null){
			getRetInfo("数据源配置出错，请检查数据源配置！",out);
			return;
		}
		conn=dataSource.getConnection();
		if(conn==null){
			getRetInfo("创建数据库链接出错！",out);
			return;
		}
		if(iPrintService==null){
			getRetInfo("打印服务未启动！",out);
			return;
		}
		//获取 打印模板信息
		HashMap param=new HashMap();
		param.put("ifunid",ifunid);
		printMap=(HashMap) this.iPrintService.print_selete_item(param);
		
		if(printMap==null){
			getRetInfo("没有对应的打印模板，或打印模板为启用",out);
			return;			
		}
		
		String tplname=(String) printMap.get("ctemplate");
		if(tplname==null || tplname==""){
			getRetInfo("未找到对应的模板文件",out);
			return;			
		}
		String filepath=this.config.getServletContext().getRealPath("/template/jasper/"+tplname);
		File reportFile = new File(filepath); 
		System.out.println("报表路径:"+reportFile.getPath());
	    if(!reportFile.exists()){
	    	getRetInfo("对应的打印模板文件不存在！",out);
	    	throw new JRRuntimeException("报表绘制失败，找不到报表配置文件！");
	    }
	    HashMap params=new HashMap();
	    params.put("ids",iids);
	    JasperReport jasperReport = (JasperReport)JRLoader.loadObject(reportFile.getPath());
	    JasperPrint jasperPrint = JasperFillManager.fillReport(jasperReport,params,conn);
	    JRHtmlExporter exporter = new JRHtmlExporter();
        HttpSession session=request.getSession();
        //response.setContentType("text/html;charset=UTF-8");
        //response.setCharacterEncoding("UTF-8");
        //response.setHeader("Content-Disposition","attachment");
        exporter.setParameter(JRExporterParameter.CHARACTER_ENCODING,"UTF-8"); 
        session.setAttribute(ImageServlet.DEFAULT_JASPER_PRINT_SESSION_ATTRIBUTE,jasperPrint);
        exporter.setParameter(JRExporterParameter.JASPER_PRINT,jasperPrint);
        exporter.setParameter(JRExporterParameter.OUTPUT_WRITER,out);
        exporter.setParameter(JRHtmlExporterParameter.IMAGES_URI,"servlets/image?image=");
        exporter.exportReport();
        out.flush();
        out.close();
        
	}catch(Exception e){
		e.printStackTrace();
	}
	}
	
	public void getRetInfo(String info,PrintWriter out){
		System.out.println(info);
		out.write(info);
		out.flush();
		out.close();
	}
}
