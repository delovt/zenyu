/**    
 *
 * 文件名：DownFileServlet.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-9-6    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.servlets;

import org.springframework.web.context.WebApplicationContext;
import org.springframework.web.context.support.WebApplicationContextUtils;
import yssoft.views.WorkFlowView;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.HashMap;

/**    
 *     
 * 项目名称：yscrm    
 * 类名称：DownFileServlet    
 * 类描述：    
 * 创建人：朱毛毛 
 * 创建时间：2011-2011-9-6 上午09:16:45        
 *     
 */
public class DownFileServlet extends HttpServlet {

	WorkFlowView workFlow;
	@Override
	public void init() throws ServletException {
		WebApplicationContext wac=WebApplicationContextUtils.getRequiredWebApplicationContext(getServletContext());  
		workFlow=(WorkFlowView) wac.getBean("workFlowView");
	}

	@Override
	protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		doPost(req,resp);
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
		String fileName=req.getParameter("fileName");
		String isDelete = req.getParameter("isDelete"); // 是否删除 下载的文件
		String deleteType=req.getParameter("type");// 以此 来选择 不同的 文件路径
		String fileType=req.getParameter("fileType");
		String downType=req.getParameter("type");
		String iid=req.getParameter("iid");			// 附件 文件 iid
		
		HashMap params=new HashMap();
		params.put("fileName",fileName);
		params.put("downType",downType);
		params.put("fileType",fileType);
		
		ServletOutputStream out = resp.getOutputStream();   
		
		byte[] fdata=workFlow.downRealFile(params);
		out.write(fdata,0,fdata.length);
		out.flush();
		
		out.close();
	}

}
