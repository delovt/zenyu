package yssoft.servlets;

import javax.servlet.ServletConfig;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

public class ExcelExportServlet extends HttpServlet{
	
	
	private static final long serialVersionUID = 1L;
	
	@Override
	public void init(ServletConfig config) throws ServletException {
		super.init(config);
	}
	
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		try {
		String filename = request.getParameter("fn");
		response.sendRedirect("upload/"+filename+"");
		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	
	public void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		System.out.println("abc");
		doGet(request, response);
	}
	
	
}
