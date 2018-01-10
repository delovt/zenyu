/**    
 *
 * 文件名：FileUpLoad.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-8-21    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.utils;

import yssoft.daos.BaseDao;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 
 * 项目名称：yscrm 类名称：FileUpLoad 类描述：文件的上传 下载 创建人：zmm 创建时间：2011-2011-8-21 下午05:07:47
 * 
 */
public class FileUtil extends BaseDao {

	private String filePath;

	public void setFilePath(String filePath) {
		this.filePath = filePath;
	}
	public String GetFilePath() {
		return this.filePath;
	}
	
	private String logoFilePath;
	

	public String getLogoFilePath() {
		return logoFilePath;
	}
	public void setLogoFilePath(String logoFilePath) {
		this.logoFilePath = logoFilePath;
	}
	
	private String mainFilePath;
	
	public String getMainFilePath() {
		return mainFilePath;
	}
	public void setMainFilePath(String mainFilePath) {
		this.mainFilePath = mainFilePath;
	}
	/**
	 * uploadFile(上传文件) 
	 * 创建者：zmm 
	 * 创建时间：2011-2011-8-21 下午05:10:32 
	 * 修改者：zmm
	 * 修改时间：2011-2011-8-21 下午05:10:32 
	 * 修改备注：
	 * 
	 * @param fileName 文件名
	 * @param fileType 文件类型
	 * @param uploadType 上传类型 0 用户图像上传，1 用户文件上传
	 * @param content 文件數據
	 * @return String
	 * @Exception 异常对象
	 */
	public String uploadFile(HashMap params) {
		
		String fileName=(String) params.get("fileName");
		String fileType=(String) params.get("fileType");
		String uploadType=(String) params.get("uploadType");
		String oldfilename=(String) params.get("oldfile");
		byte[] content=(byte[]) params.get("content");
		
		String tpFilePath="";
		
		if(uploadType.equals("0")){
			if(fileType==null || fileType==""){
				tpFilePath = filePath + File.separator+ "header"+File.separator + fileName;
			}else{
				tpFilePath = filePath + File.separator+ "header"+File.separator + fileName+"."+fileType;
			}
		}else{
			if(fileType==null || fileType==""){
				tpFilePath = filePath + File.separator+ "file"+File.separator + fileName;
			}else{
				tpFilePath = filePath + File.separator+ "file"+File.separator + fileName+"."+fileType;
			}
		}
		
		File file=new File(tpFilePath);
//		if(uploadType.equals("0")){
//			file = new File(filePath + File.separator+ "header"+File.separator + fileName+"."+fileType);
//		}else{
//			file = new File(filePath + File.separator+ "file"+File.separator + fileName+"."+fileType);
//		}
		
		//System.out.println("文件上传路径:"+file.getAbsolutePath());
		
		FileOutputStream stream=null;
		try {
			//创建目录
			File dir=null;
			
			if(uploadType.equals("0")){
				dir = new File(filePath + File.separator+ "header");
			}else{
				dir = new File(filePath + File.separator+ "file");
			}
			
			if(!dir.exists()){
				dir.mkdirs();
			}
			//创建文件
			if (!file.exists()) { // 文件不存在，就创建
				file.createNewFile();
			}
			
			// 复制文件
			if(oldfilename != null && oldfilename != ""){
				String oldfilePath=file.getPath().substring(0,file.getPath().indexOf(fileName))+oldfilename+"."+fileType;
				File oldfile=new File(oldfilePath);
				try {
					copyFile(oldfile,file);
				} catch (Exception e) {
					e.printStackTrace();
					return "fail";
				}
				return "suc";
			}
			

			stream = new FileOutputStream(file);
			if (content != null) {
				stream.write(content);
			}
			return "suc";
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}finally{
			if(stream != null){
				try {
					stream.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			
		}
	}
	
	/**
	 * uploadFile(上传文件) 
	 * 创建者：zmm 
	 * 创建时间：2011-2011-8-21 下午05:10:32 
	 * 修改者：zmm
	 * 修改时间：2011-2011-8-21 下午05:10:32 
	 * 修改备注：
	 * 
	 * @param fileName 文件名
	 * @param fileType 文件类型
	 * @param uploadType 上传类型 0 用户图像上传，1 用户文件上传
	 * @param content 文件數據
	 * @return String
	 * @Exception 异常对象
	 */
	public String uploadFileLogo(HashMap params) {
		
		String fileName=(String) params.get("fileName");
		String fileType=(String) params.get("fileType");
		String uploadType=(String) params.get("uploadType");
		String oldfilename=(String) params.get("oldfile");
		byte[] content=(byte[]) params.get("content");
		
		String tpFilePath="";
		
		String _filePath=(String)params.get("filePath");
		
		if(uploadType.equals("0")){
			if(fileType==null || fileType==""){
				tpFilePath = _filePath + File.separator+ File.separator + fileName;
			}else{
				tpFilePath = _filePath + File.separator+ File.separator + fileName+"."+fileType;
			}
		}else{
			if(fileType==null || fileType==""){
				tpFilePath = _filePath + File.separator+ File.separator + fileName;
			}else{
				tpFilePath = _filePath + File.separator+ File.separator + fileName+"."+fileType;
			}
		}
		
		File file=new File(tpFilePath);
//		if(uploadType.equals("0")){
//			file = new File(filePath + File.separator+ "header"+File.separator + fileName+"."+fileType);
//		}else{
//			file = new File(filePath + File.separator+ "file"+File.separator + fileName+"."+fileType);
//		}
		
		//System.out.println("文件上传路径:"+file.getAbsolutePath());
		
		FileOutputStream stream=null;
		try {
			//创建目录
			File dir=null;
			
			if(uploadType.equals("0")){
				dir = new File(filePath + File.separator+ "header");
			}else{
				dir = new File(filePath + File.separator+ "file");
			}
			
			if(!dir.exists()){
				dir.mkdirs();
			}
			//创建文件
			if (!file.exists()) { // 文件不存在，就创建
				file.createNewFile();
			}
			
			// 复制文件
			if(oldfilename != null && oldfilename != ""){
				String oldfilePath=file.getPath().substring(0,file.getPath().indexOf(fileName))+oldfilename+"."+fileType;
				File oldfile=new File(oldfilePath);
				try {
					copyFile(oldfile,file);
				} catch (Exception e) {
					e.printStackTrace();
					return "fail";
				}
				return "suc";
			}
			

			stream = new FileOutputStream(file);
			if (content != null) {
				stream.write(content);
			}
			return "suc";
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}finally{
			if(stream != null){
				try {
					stream.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			
		}
	}
	
	/**
	 * downFile(文件下载
	 * 创建者：zmm
	 * 创建时间：2011-2011-8-22 上午10:24:28
	 * 修改者：zmm
	 * 修改时间：2011-2011-8-22 上午10:24:28
	 * 修改备注：   
	 * @param fileName 文件名
	 * @param fileType 文件类型
	 * @param downType 下载类型 0 用户图像下载，1 用户文件下载
	 * @param content 文件數據    
	 * @return byte[]  字节流数组（文件内容）
	 * @Exception 异常对象    
	 *
	 */
	public byte[] downFile(HashMap params){
		String fileName=(String) params.get("fileName");
		String fileType=(String) params.get("fileType");
		String downType=(String) params.get("downType");
		
		String fullPath;
		File file=null;
		FileInputStream fis=null;
		
//		if(downType.equals("0")){
//			fullPath=filePath + File.separator+ "header"+File.separator + fileName+"."+fileType;
//		}else{
//			fullPath=filePath + File.separator+ "file"+File.separator + fileName+"."+fileType;
//		}
		
	    if(downType.equals("0")){
			if(fileType==null || fileType==""){
				fullPath = filePath + File.separator+ "header"+File.separator + fileName;
			}else{
				fullPath = filePath + File.separator+ "header"+File.separator + fileName+"."+fileType;
			}
		}else{
			if(fileType==null || fileType==""){
				fullPath = filePath + File.separator+ "file"+File.separator + fileName;
			}else{
				fullPath = filePath + File.separator+ "file"+File.separator + fileName+"."+fileType;
			}
		}
		
		file = new File(fullPath);
		
		if(file==null || ! file.exists() ){
			return null;
		}
		//System.out.println("文件下载路径:"+fullPath);
		try {
			fis = new FileInputStream(fullPath);
			// fis.available()返回文件的字节长度
            byte[] bytes = new byte[fis.available()];
            // 将文件中的内容读入到数组中
            fis.read(bytes);
			return bytes;
		} catch (Exception e) {
			e.printStackTrace();
			return null;
		} finally{
			if(fis != null){
				try {
					fis.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}
	/**
	 * deleteFile(删除文件)
	 * 创建者：lovecd
	 * 创建时间：2011-2011-9-6 上午09:05:25
	 * 修改者：lovecd
	 * 修改时间：2011-2011-9-6 上午09:05:25
	 * 修改备注：   
	 * @param   name       
	 * @return void
	 * @Exception 异常对象    
	 *
	 */
	public String deleteFile(HashMap params){
		String fileName=(String) params.get("fileName");
		String deleteType=(String) params.get("deleteType");
		String fileType=(String) params.get("fileType");
		
		String fullPath="";
		if(deleteType.equals("0")){
			if(fileType==null || fileType==""){
				fullPath = filePath + File.separator+ "header"+File.separator + fileName;
			}else{
				fullPath = filePath + File.separator+ "header"+File.separator + fileName+"."+fileType;
			}
			
		}else{
			if(fileType==null || fileType==""){
				fullPath = filePath + File.separator+ "file"+File.separator + fileName;
			}else{
				fullPath = filePath + File.separator+ "file"+File.separator + fileName+"."+fileType;
			}
		}
		File file=new File(fullPath);
		if(file != null && file.exists()){
			file.delete();
			return "suc";
		}
		return "fail";
	}
	
	// 复制文件
	public void copyFile(File f1, File f2) throws Exception {
		if (f1 == null || f2 == null) {
			return;
		}
		if (!f1.exists() || !f2.exists()) {
			return;
		}
		int length = 1000;
		FileInputStream in = new FileInputStream(f1);
		FileOutputStream out = new FileOutputStream(f2);
		byte[] buffer = new byte[length];
		while (true) {
			int ins = in.read(buffer);
			if (ins == -1) {
				in.close();
				out.flush();
				out.close();
			} else
				out.write(buffer, 0, ins);
		}
	}
	 
	//上传富文本文档lzx
	public String uploadImage(HashMap params) {
		Date date = new Date();
		String fileName = params.get("fileName") + "_temp_" + date.getTime();
		String fileType = "jpg";
		String oldfilename = (String) params.get("oldfile");
		byte[] content=(byte[]) params.get("content");
		
		String tpFilePath="";
		
		String url = this.getClass().getResource("").getFile();
		
		url = url.replaceAll("%20", " ");
		
		url = url.substring(0, url.indexOf("webapps")+7)+ "/importImage/";
		
		tpFilePath = url + fileName+"."+fileType;
		
		File file=new File(tpFilePath);
		
		FileOutputStream stream=null;
		try {
			//创建目录
			File dir=null;
			
			dir = new File(url);
			
			
			if(!dir.exists()){
				dir.mkdirs();
			}
			//创建文件
			if (!file.exists()) { // 文件不存在，就创建
				file.createNewFile();
			}
			
			// 复制文件
			if(oldfilename != null && oldfilename != ""){
				String oldfilePath=file.getPath().substring(0,file.getPath().indexOf(fileName))+oldfilename+"."+fileType;
				File oldfile=new File(oldfilePath);
				try {
					copyFile(oldfile,file);
				} catch (Exception e) {
					e.printStackTrace();
					return "fail";
				}
				return fileName+"."+fileType;
			}
			
		
			stream = new FileOutputStream(file);
			if (content != null) {
				stream.write(content);
			}
			return fileName+"."+fileType;
		} catch (Exception e) {
			e.printStackTrace();
			return "fail";
		}finally{
			if(stream != null){
				try {
					stream.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
			
		}
	 }
	 
	//lzx 删除富文本图片
	public void deleteImage(HashMap<String, List> params) {
		String status = params.get("status").get(0).toString();
		String userId = "";
		if(params.get("userId") != null) {
			userId = params.get("userId").get(0).toString();
		}
		
		List imagesForDelNew = params.get("imagesForDelNew");
		List imagesForDelOld = params.get("imagesForDelOld");
		if(status.equals("delete")) {
			Iterator it = imagesForDelNew.iterator();
			String filename = "";
			
			String fullPath = "";
			
			String url = this.getClass().getResource("").getFile();

			url = url.replaceAll("%20", " ");

			url = url.substring(0, url.indexOf("webapps")+7) + "/importImage/";
			while(it.hasNext()) {
				filename = it.next().toString();
				String regex =  "img_(\\d+).jpg";
				Pattern pattern = Pattern.compile(regex);
				Matcher matcher = pattern.matcher(filename);
	
				while (matcher.find()) {
					fullPath = url + "img_" + matcher.group(1) + ".jpg";
					File file = new File(fullPath);
					if (file != null && file.exists()) {
						file.delete();
					}
				}
			}
		}else if(status.equals("save")) {
			String fileNameOld = "";
			String fileNameNew = "";
			String fullPath = "";
			
			String fullPathCopy = "";
			
			String delPath = "";

			String url = this.getClass().getResource("").getFile();

			url = url.replaceAll("%20", " ");

			url = url.substring(0, url.indexOf("webapps")+7) + "/importImage/";
			
			String regex = null;
			Pattern pattern = null;
			Matcher matcher = null;
			for(int i=0; i<imagesForDelNew.size(); i++) {
				fileNameNew = imagesForDelNew.get(i).toString();
				regex = userId + "_temp_(\\d+).jpg";
				pattern = Pattern.compile(regex);
				matcher = pattern.matcher(fileNameNew);
				while (matcher.find()) {
					if(fileNameNew.contains(matcher.group(1))) {
						fullPath = url + userId + "_temp_" + matcher.group(1) + ".jpg";
						fullPathCopy = url + "img_" + matcher.group(1) + ".jpg";
						File file = new File(fullPath);
						File fileCopy = new File(fullPathCopy);
						try {
							if(file != null && file.exists()) {
								copyFileForImage(file, fileCopy);
							}					
						} catch (IOException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}					
						if (file != null && file.exists()) {
							file.delete();
						}
						
					}
				}	
			}
			delPath = userId + "_temp_*.jpg";
			File[] files = getFiles(url, delPath);  
			if(files != null) {
				for(int j=0;j<files.length;j++){   
		            System.out.println(files[j]); 
		            if (files[j] != null && files[j].exists()) {
		            	files[j].delete();
					}
		        }
			}
	        
			for(int i=0; i<imagesForDelOld.size(); i++) {
				fileNameNew = imagesForDelNew.get(i).toString();
				fileNameOld = imagesForDelOld.get(i).toString();
				regex = "img_(\\d+).jpg";
				pattern = Pattern.compile(regex);
				matcher = pattern.matcher(fileNameOld);
	
				while (matcher.find()) {
					if(!fileNameNew.contains(matcher.group(1))) {
						fullPath = url + "img_" + matcher.group(1) + ".jpg";
						File file = new File(fullPath);
						if (file != null && file.exists()) {
							file.delete();
						}
					}
				}
			}
		}
	}
	
	// 复制文件lzx
	public static void copyFileForImage(File sourceFile, File targetFile)
			throws IOException {
		BufferedInputStream inBuff = null;
		BufferedOutputStream outBuff = null;
		try {
			// 新建文件输入流并对它进行缓冲
			inBuff = new BufferedInputStream(new FileInputStream(sourceFile));

			// 新建文件输出流并对它进行缓冲
			outBuff = new BufferedOutputStream(new FileOutputStream(targetFile));

			// 缓冲数组
			byte[] b = new byte[1024 * 5];
			int len;
			while ((len = inBuff.read(b)) != -1) {
				outBuff.write(b, 0, len);
			}
			// 刷新此缓冲的输出流
			outBuff.flush();
		} finally {
			// 关闭流
			if (inBuff != null)
				inBuff.close();
			if (outBuff != null)
				outBuff.close();
		}
	}
	

	/**
	 * 创建查询指定目录下文件的方法
	 * 
	 * @author lzx
	 * 
	 * @param allList
	 *            指定目录
	 * @param endName
	 *            指定以“”结尾的文件
	 * @return 得到的文件数目
	 */
	public int findTxtFileCount(File allList, String endName) {
		//
		int textCount = 0;
		// 创建fileArray名字的数组
		File[] fileArray = allList.listFiles();
		// 如果传进来一个以文件作为对象的allList 返回0
		if (null == fileArray) {
			return 0;
		}
		// 偏历目录下的文件
		for (int i = 0; i < fileArray.length; i++) {
			// 如果是个目录
			if (fileArray[i].isDirectory()) {
				// System.out.println("目录: "+fileArray[i].getAbsolutePath());
				// 递归调用
				textCount += findTxtFileCount(fileArray[i].getAbsoluteFile(),
						endName);
				// 如果是文件
			} else if (fileArray[i].isFile()) {
				// 如果是以“”结尾的文件
				if (fileArray[i].getName().endsWith(endName)) {
					// 展示文件
					System.out.println("exe文件: "
							+ fileArray[i].getAbsolutePath());
					// 所有以“”结尾的文件相加
					textCount++;
				}
			}
		}
		return textCount;

	}

	/**
	 * 在本文件夹下查找
	 * 
	 * @author lzx
	 * 
	 * @param s
	 *            String 文件名
	 * @return File[] 找到的文件
	 */
	public static File[] getFiles(String s) {
		return getFiles("./", s);
	}

	/**
	 * 获取文件 可以根据正则表达式查找
	 * 
	 * @author lzx
	 * 
	 * @param dir
	 *            String 文件夹名称
	 * @param s
	 *            String 查找文件名，可带*.?进行模糊查询
	 * @return File[] 找到的文件
	 */
	public static File[] getFiles(String dir, String s) {
		// 开始的文件夹
		File file = new File(dir);

		s = s.replace('.', '#');
		s = s.replaceAll("#", "\\\\.");
		s = s.replace('*', '#');
		s = s.replaceAll("#", ".*");
		s = s.replace('?', '#');
		s = s.replaceAll("#", ".?");
		s = "^" + s + "$";

		System.out.println(s);
		Pattern p = Pattern.compile(s);
		ArrayList list = filePattern(file, p);

		if(list == null) {
			return null;
		}else {
			File[] rtn = new File[list.size()];
			list.toArray(rtn);
			return rtn;
		}
	}

	/**
	 * @author lzx
	 * 
	 * @param file
	 *            File 起始文件夹
	 * @param p
	 *            Pattern 匹配类型
	 * @return ArrayList 其文件夹下的文件夹
	 */

	private static ArrayList filePattern(File file, Pattern p) {
		if (file == null) {
			return null;
		} else if (file.isFile()) {
			Matcher fMatcher = p.matcher(file.getName());
			if (fMatcher.matches()) {
				ArrayList list = new ArrayList();
				list.add(file);
				return list;
			}
		} else if (file.isDirectory()) {
			File[] files = file.listFiles();
			if (files != null && files.length > 0) {
				ArrayList list = new ArrayList();
				for (int i = 0; i < files.length; i++) {
					ArrayList rlist = filePattern(files[i], p);
					if (rlist != null) {
						list.addAll(rlist);
					}
				}
				return list;
			}
		}
		return null;
	}
}
