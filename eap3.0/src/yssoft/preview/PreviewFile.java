/**    
 *
 * 文件名：PreviewFile.java
 * 版本信息：增宇Crm2.0
 * 日期：2011 2011-12-13    
 * 版权所有  徐州市增宇软件有限公司
 *    
 */
package yssoft.preview;

import com.artofsolving.jodconverter.DefaultDocumentFormatRegistry;
import com.artofsolving.jodconverter.DocumentConverter;
import com.artofsolving.jodconverter.DocumentFormat;
import com.artofsolving.jodconverter.openoffice.connection.OpenOfficeConnection;
import com.artofsolving.jodconverter.openoffice.connection.SocketOpenOfficeConnection;
import com.artofsolving.jodconverter.openoffice.converter.OpenOfficeDocumentConverter;

import java.io.*;
import java.util.HashMap;

/**
 * 
 * 项目名称：rkycrm1.3 类名称：PreviewFile 类描述：预览上传的文件 创建人：朱毛毛 创建时间：2011-2011-12-13
 * 下午04:32:40
 * 
 */
public class PreviewFile {

	private String uploadFilePath; // 文件的真实路径
	private String swfFilePath; // 临时存放 生成swf文件路径
	private String flashPaperPath; // 转化工具的路径

	// doc、xls、docx、ppt、txt、pdf
	private String[] exts = { "doc", "xls", "pdf", "ppt", "txt", "docx", "xlsx" };

	/**
	 * transFileToSwf(这里用一句话描述这个方法的作用) 创建者：Administrator 创建时间：2011-2011-12-13
	 * 下午04:34:27 修改者：Administrator 修改时间：2011-2011-12-13 下午04:34:27 修改备注：
	 * 
	 * @param fileName
	 *            文件名(系统中的)
	 * @return extname 文件扩展名
	 * @Exception 异常对象
	 * @return string 生成后的 swf 路径（包括文件名与扩展名）
	 * 
	 */
	public HashMap<String, String> transFileToSwf(HashMap params) {
		HashMap<String, String> ret = new HashMap<String, String>();

		String filename = (String) params.get("filename");
		String extname = (String) params.get("extname");

		if (filename == null) {
			ret.put("error", "文件名不能为空");
			return ret;
		}
		// 验证文件是不是能给转化，主要根据文件的扩展名
		boolean bool = false;
		for (String ext : exts) {
			if (ext.equals(extname)) {
				bool = true;
				break;
			}
		}
		if (!bool) {
			ret.put("error",
					"该类型的文件不予预览,目前只能预览[doc,xls,pdf,ppt,txt,docx,xlsx,jpg,bmp,png]");
			return ret;
		}
		// 验证相关文件路径是不是真实存在
		if (uploadFilePath == null || uploadFilePath == "") {
			ret.put("error", "文件存放路径不存在，请联系管理员，确认");
			return ret;
		}
		System.out.println("uploadFilePath[" + uploadFilePath + "]");
		if (swfFilePath == null || swfFilePath == "") {
			ret.put("error", "预览文件存放路径不存在，请联系管理员，确认");
			return ret;
		}
		System.out.println("swfFilePath[" + swfFilePath + "]");
		if (flashPaperPath == null || flashPaperPath == "") {
			ret.put("error", "文件转发工具存放路径不存在，请联系管理员，确认");
			return ret;
		}
		System.out.println("flashPaperPath:[" + flashPaperPath + "]");

		// 验证文件
		String filePath = uploadFilePath + File.separator + "file"
				+ File.separator + filename;//
		String srcFilePath = filePath + "." + extname;
		System.out.println("文件路径[" + srcFilePath + "]");
		File file = new File(srcFilePath);
		if (file.exists() == false) {
			ret.put("error", "预览的文件不存在");
			return ret;
		}
		// 判断文件大小，
		if (file.length() <= 0) {
			ret.put("error", "预览的文件,内容不存在");
			return ret;
		}
		System.out.println("文件大小[" + file.length() + "]"); // 14584476 13M
		if (file.length() > 6000000) {
			ret.put("error", "预览的文件过大，请下载后再预览");
			return ret;
		}
		String swfFilePath = this.getClass().getResource("/").getFile();

		swfFilePath = swfFilePath.substring(0, swfFilePath.indexOf("WEB-INF"))
				+ "swf/";
		File realFileDir = new File(swfFilePath); // 判断存放swf文件的路径是否存在
		if (!realFileDir.exists()) {
			realFileDir.mkdirs();
		}
		swfFilePath = swfFilePath.substring(1, swfFilePath.length()); // 出去多余的第一个
																		// "/"
		String realFilePath = swfFilePath + filename + ".swf";
		// 判断文件是不是 已经
		File realFile = new File(realFilePath);
		if (realFile.exists()) {
			ret.put("suc", filename + ".swf");
			return ret;
		}

		try {
			String pdfFilePath = swfFilePath + filename + ".pdf";

			if ("pdf".equals(extname)) { // 如果已经是 pdf
				// realFile.createNewFile(); // 文件不存在，就创建
				// copyFile(file,realFile);
				convertPDF2SWF(srcFilePath.replace("\\", "/"), realFilePath,
						true);
				// Thread.sleep(10000);
				ret.put("suc", filename + ".swf");
				return ret;
			}

			boolean flag = file2pdf(file.getAbsolutePath().toString(), extname,
					pdfFilePath);
			if (!flag) {
				ret.put("error", "文件转换失败，请联系管理员，可能是文件转换服务未启动");
				return ret;
			}

			// file2swf(pdfFilePath,realFilePath);
			convertPDF2SWF(pdfFilePath, realFilePath, false);
			// Thread.sleep(10000);
			ret.put("suc", filename + ".swf");
			return ret;
		} catch (Exception e) {
			e.printStackTrace();
			ret.put("error", "文件预览失败");
			return ret;
		}
	}

	//
	public boolean file2pdf(String inFilePath, String inExt, String outFilePath) {
		File input = new File(inFilePath);
		File output = new File(outFilePath);
		DefaultDocumentFormatRegistry formatReg = new DefaultDocumentFormatRegistry();
		DocumentFormat pdf = formatReg.getFormatByFileExtension("pdf");
		DocumentFormat inExtDF = formatReg.getFormatByFileExtension(inExt); // 输入文件的扩展名
		OpenOfficeConnection ooc = null;
		try {
			ooc = new SocketOpenOfficeConnection(8100);
			ooc.connect();
			DocumentConverter convert = new OpenOfficeDocumentConverter(ooc);
			convert.convert(input, inExtDF, output, pdf);
			return true;
		} catch (Exception e) {
			e.printStackTrace();
			System.out.println("文件转化为pdf失败");
		} finally {
			try {
				if (ooc != null) {
					ooc.disconnect();
					ooc = null;
				}
			} catch (Exception e) {
				e.printStackTrace();
			}
		}
		return false;
	}

	// pdf 转化为 swf
	public String file2swf(String srcPath, String swfPath) {
		try {
			String command = "C:\\SWFTools\\pdf2swf.exe " + srcPath + " "
					+ swfPath;
			System.out.println(command);
			Process pro = Runtime.getRuntime().exec(command);
			return swfPath;
		} catch (Exception e) {
			e.printStackTrace();
			return "";
		}
	}

	public int convertPDF2SWF(String srcPath, String swfPath, boolean isPdf)
			throws IOException {
		// //目标路径不存在则建立目标路径
		// File dest = new File(swfPath);
		// if (!dest.exists()) dest.mkdirs();

		// 源文件不存在则返回
		File source = new File(srcPath);
		if (!source.exists())
			return 0;

		// 调用pdf2swf命令进行转换
		// String command = "D:\\swftools\\pdf2swf.exe" + " -o \"" + destPath +
		// fileName
		// +"\"  <SPAN style='COLOR: #ff0000'>-s languagedir=D:\\xpdf\\xpdf-chinese-simplified</SPAN> -s flashversion=9 \""
		// + sourcePath + "\"";
		// String command = "D:\\swftools\\pdf2swf.exe" + " -o \"" + destPath +
		// fileName +"\" -s flashversion=9 \"" + sourcePath + "\"";
		// String command=
		// "D:/SWFTools/pdf2swf.exe  -t \""+destPath+"\\Java.pdf\" -o  \""+destPath+"\\test.swf\" -s flashversion=9 -s languagedir=D:\\xpdf\\xpdf-chinese-simplified ";
		String command = "C:\\SWFTools\\pdf2swf.exe -t "
				+ srcPath
				+ " "
				+ swfPath
				+ " -s flashversion=9 -s languagedir=C:\\SWFTools\\xpdf-chinese-simplified\\xpdf\\chinese-simplified ";
		// 文件太大，只预览前几页
		// if(isPdf){ // 如果源文件是pdf文件
		// command="";
		// }

		System.out.println("cmd:" + command);
		// Process pro = Runtime.getRuntime().exec(command);
		Process process = Runtime.getRuntime().exec(command); // 调用外部程序
		final InputStream is1 = process.getInputStream();
		new Thread(new Runnable() {
			public void run() {
				BufferedReader br = new BufferedReader(new InputStreamReader(
						is1));
				try {
					while (br.readLine() != null)
						;
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}).start(); // 启动单独的线程来清空process.getInputStream()的缓冲区
		InputStream is2 = process.getErrorStream();
		BufferedReader br2 = new BufferedReader(new InputStreamReader(is2));
		StringBuilder buf = new StringBuilder(); // 保存输出结果流
		String line = null;
		while ((line = br2.readLine()) != null)
			buf.append(line); // 循环等待ffmpeg进程结束
		System.out.println("输出结果为：" + buf);
		while (br2.readLine() != null)
			;

		try {
			process.waitFor();
		} catch (InterruptedException e) {
			e.printStackTrace();
		}

		return process.exitValue();

	}

	public String getUploadFilePath() {
		return uploadFilePath;
	}

	public void setUploadFilePath(String uploadFilePath) {
		this.uploadFilePath = uploadFilePath;
	}

	public String getSwfFilePath() {
		return swfFilePath;
	}

	public void setSwfFilePath(String swfFilePath) {
		this.swfFilePath = swfFilePath;
	}

	public String getFlashPaperPath() {
		return flashPaperPath;
	}

	public void setFlashPaperPath(String flashPaperPath) {
		this.flashPaperPath = flashPaperPath;
	}

	public static void main(String[] args) {
		PreviewFile test = new PreviewFile();
		System.out.print("----测试----");
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
}
