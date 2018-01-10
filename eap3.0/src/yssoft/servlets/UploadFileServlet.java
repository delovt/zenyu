/**
 * 模块名称：UploadFileServlet
 * 模块说明：上传文件
 * 创建人：	YJ
 * 创建日期：20111021
 * 修改人：
 * 修改日期：
 * 
 */

package yssoft.servlets;

import org.apache.commons.fileupload.FileItem;
import org.apache.commons.fileupload.FileUploadException;
import org.apache.commons.fileupload.disk.DiskFileItemFactory;
import org.apache.commons.fileupload.servlet.ServletFileUpload;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.File;
import java.io.IOException;
import java.util.Iterator;
import java.util.List;

public class UploadFileServlet extends HttpServlet{
	
	
	private static final long serialVersionUID = 1L;
	
	public UploadFileServlet(){super();}
	
	private String uploadPath;   
	
	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException{
		try {
			request.setCharacterEncoding("UTF-8");
			processRequest(request, response);   

		} catch (Exception e) {
			e.printStackTrace();
		}
		
	}
	
	
	public void doPost(HttpServletRequest request, HttpServletResponse response)
	throws ServletException, IOException {
		request.setCharacterEncoding("UTF-8");
		processRequest(request, response);

	}
	
  
	// 限制文件的上传大小   
  
    private int maxPostSize = 100 * 1024 * 1024; 
  
 
    public void destroy() {   
        super.destroy();
    }   
  
	protected void processRequest(HttpServletRequest request, HttpServletResponse response)   
            throws ServletException, IOException {
    	
    	String url = "\\printmodel\\";
    	String param =request.getParameter("param");
    	String fileName = request.getParameter("fileName");
    	if("importdata".equals(param)){
    		url = "\\importdata\\";
    		this.uploadPath = request.getSession().getServletContext().getRealPath("")+url;//获取路径
    	}else{
    		this.uploadPath = request.getSession().getServletContext().getRealPath("");//获取路径
        	int point = this.uploadPath.lastIndexOf("\\");
        	this.uploadPath = this.uploadPath.substring(0, point)+url;
    	}
    		 	
    	System.out.println(uploadPath);
    	
    	//创建目录
		File dir=null;
	    dir = new File(this.uploadPath);
		
		if(!dir.exists()){
			dir.mkdirs();
		}
		
        //保存文件到服务器中   
        DiskFileItemFactory factory = new DiskFileItemFactory();   
        factory.setSizeThreshold(4096);   
        ServletFileUpload upload = new ServletFileUpload(factory);
        upload.setSizeMax(maxPostSize);
        try {   
            List fileItems = (List) upload.parseRequest(request);
            Iterator iter = fileItems.iterator();
            while (iter.hasNext()) {
                FileItem item = (FileItem) iter.next();
                if (!item.isFormField()) {   
                    String name = item.getName();
                    System.out.println(name);   
                    if(fileName!=null && !"".equals(fileName)){
                    	name = fileName;
                    }
                    try { 
                        item.write(new File(uploadPath + name));
                    } catch (Exception e) {   
                        e.printStackTrace();
                    }   
                }   
            }
        } catch (FileUploadException e) {   
            e.printStackTrace();   
            System.out.println(e.getMessage());
        }   
    }   

	
	
}
