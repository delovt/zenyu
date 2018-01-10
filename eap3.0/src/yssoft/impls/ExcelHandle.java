/*
 *	 模块名称：Excel文件操作
 *	 模块简介：JAVA读取Excel文件内容
 *	 创建时间：2010年04月30日
 *	 创建人：尹婕
 */

package yssoft.impls;

import jxl.write.*;
import jxl.write.biff.RowsExceededException;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;
import org.apache.poi.ss.usermodel.Cell;
import org.apache.poi.ss.usermodel.Row;
import org.apache.poi.ss.usermodel.Sheet;
import org.apache.poi.ss.usermodel.Workbook;

import java.io.*;
import java.text.DecimalFormat;
import java.text.SimpleDateFormat;
import java.util.*;

public class ExcelHandle{
	
	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	
	public ExcelHandle() {
	}

	/**
	 * YJ add 2010年05月06日
	 * 
	 * 读取Excel文件
	 * 
	 * @param filepath:文件路径
	 * @param sheetOrder:工作簿索引
	 * @return 数据集合
	 */
	public List<String[]> getDataFromSheet(String filepath, int sheetOrder)
			throws IOException {
		Workbook workbook = new HSSFWorkbook(new POIFSFileSystem(
				new FileInputStream(filepath)));// 以文件流的方式读取文件
		Sheet sheet = workbook.getSheetAt(sheetOrder);// 获取工作簿
		List<String[]> dataList = new ArrayList<String[]>();// 返回值(数据集)

		// 注意得到的行数是基于0的索引 遍历所有的行，根据需求Excel第一行为列名，因此从1开始遍历
		for (int i = 0; i <= sheet.getLastRowNum(); i++) {
			Row rows = sheet.getRow(i);// 当前行
			String[] cellvalue = new String[rows.getLastCellNum()];// 临时变量,存储单元格内容
			// 遍历每一列
			for (int k = 0; k < rows.getLastCellNum(); k++) {
				Cell cell = rows.getCell(k);
				if (cell != null) {
					// 数字类型时,日期格式的也解析成数字类型
					if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
						// 判断是否是日期类型
						if (HSSFDateUtil.isCellDateFormatted(cell)) {
							// 格式化日期格式
							cellvalue[k] = sdf.format(cell.getDateCellValue())
									+ "";
						} else {
							DecimalFormat df = new DecimalFormat("########");
							cellvalue[k] = df
									.format(cell.getNumericCellValue());
						}
					}
					// Boolean类型时
					else if (cell.getCellType() == HSSFCell.CELL_TYPE_BOOLEAN)
						cellvalue[k] = cell.getBooleanCellValue() + "";
					else
						cellvalue[k] = cell.getStringCellValue();// 其他均为字符串类型
				} else
					cellvalue[k] = "";// 单元格为空则赋值为空值

			}
			// 读完一行记录，数据集增加一条记录
			dataList.add(cellvalue);
		}
		return dataList;
	}
	
//	 导出数据至Excel
	@SuppressWarnings("unchecked")
	public HashMap writeExcel(HashMap paraObj) {
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		List list = new ArrayList();
		List fieldslist = new ArrayList();
		Label labelCF = null;

		list = (List) paraObj.get("arr");// 将前台的数据集转换为List类型
		String filetitle="";
		if (paraObj.get("title")!=null)filetitle=paraObj.get("title").toString();// 标题
		fieldslist = (List) paraObj.get("fieldsList");// 包括字段及字段说明的集合
		Object flag = paraObj.get("flag");//是否允许有序号，0：允许，1：不允许

		String filename = UUID.randomUUID().toString()+".xls";
		
		String url = this.getClass().getResource("").getFile();
		url = url.substring(0, url.indexOf("WEB-INF"))+ "/upload/";
		url = url.replaceAll("%20", " ");
		
		File fpath = new File(url);
		
		
		if(fpath.exists() == false){
			fpath.mkdir();
			System.out.println("路径不存在,但是已经成功创建了:->"+fpath);
		}
		String strpath = fpath+"/"+filename;
	   
		try {
			OutputStream os = new FileOutputStream(strpath);// 输出的Excel文件URL
			WritableWorkbook wwb = jxl.Workbook.createWorkbook(os);// 创建可写工作薄
			WritableSheet ws = wwb.createSheet(filetitle, 0);// 创建可写工作表
			
			if (list.size() > 0) {
				// 获取列名
				HashMap record = (HashMap) list.get(0);// 获取一条并记录，得到列名的集合
				String str_columns = record.keySet().toString();// 取出列名，列名以字符串的形式取出
				str_columns = str_columns.substring(0, str_columns
						.lastIndexOf(','));// 由于最后一个字段为自动生成的，因此需要去除最后一个
				str_columns = str_columns.replace("[", "");
				str_columns = str_columns.replace("]", "");
				String[] b = str_columns.split(",");// 列名集合

				//标题
				onWriteTitle(filetitle,ws,fieldslist,labelCF);

				
				//列标题
				onWriteColumns(fieldslist,flag,labelCF,ws,b);
				
				//数据
				onWriteData(list,fieldslist,flag,ws,labelCF,b);
				
			}

			// 现在可以写了
			wwb.write();
			// 写完后关闭
			wwb.close();
			// 关闭流
			os.close();

		} catch (Exception ex) {
			System.out.println(ex.getMessage());
		} finally {
		}

		resultMap.put("filename", filename);
		return resultMap;
	}
	
	//写入标题
	@SuppressWarnings("unchecked")
	protected void onWriteTitle(String filetitle,WritableSheet ws,List fieldslist,Label labelCF) throws WriteException
	{
		// 写标题
		// 设定标题格式,大小：16
		jxl.write.WritableFont wf = new jxl.write.WritableFont(
				WritableFont.createFont("黑体"), 14, WritableFont.BOLD);
		jxl.write.WritableCellFormat wcfF = new jxl.write.WritableCellFormat(
				wf);
		wcfF.setAlignment(jxl.format.Alignment.CENTRE); // 水平对齐方式指定为居中
		wcfF.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);//设置边框
		// 合并单元格
		ws.setRowView(0, 420);// 设置第一行的高度为600
		ws.mergeCells(0, 0, fieldslist.size(), 0);// 合并
		if (filetitle != "")
			labelCF = new Label(0, 0, filetitle, wcfF);// 设置标题
		else {					
			Date dt = new Date();
			labelCF = new Label(0, 0, sdf.format(dt), wcfF);
		}
		ws.addCell(labelCF);
	}
	
	//写入列标题
	@SuppressWarnings("unchecked")
	protected void onWriteColumns(List fieldslist,Object flag,Label labelCF,WritableSheet ws,String[] b) throws WriteException
	{
		// 写列名
		jxl.write.WritableFont wfcolumn = new jxl.write.WritableFont(
				WritableFont.createFont("黑体"), 12, WritableFont.BOLD);
		jxl.write.WritableCellFormat wcfFcolumn = new jxl.write.WritableCellFormat(
				wfcolumn);
		wcfFcolumn.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);//设置边框
		// 开始写列的名称
		if (fieldslist.size() > 0) {// 遍历出字段说明(中文)						
			if(flag != null && flag.toString().equals("0")){//增加序号							
				labelCF = new Label(0, 1, "序号", wcfFcolumn);
				ws.setColumnView(0, 8);// 设置列宽
				ws.addCell(labelCF);
				for (int i = 0; i < fieldslist.size(); i++) {
					Object fieldItem = fieldslist.get(i);
					HashMap fieldrecord = (HashMap) fieldItem;
					String fieldname ="";
					if(fieldrecord.get("cfldcaption") == null){
						fieldname = " ";
					}else
					fieldname = fieldrecord.get("cfldcaption").toString();
					labelCF = new Label(i+1, 1, fieldname, wcfFcolumn);
					ws.setColumnView(i+1, 20);// 设置列宽
					ws.setRowView(i, 420);// 设置行高
					ws.addCell(labelCF);
					
				}
			}
			else{//不增加序号
				for (int i = 0; i < fieldslist.size(); i++) {
					Object fieldItem  = fieldslist.get(i);	
					HashMap fieldrecord = (HashMap) fieldItem;
					String fieldname = fieldrecord.get("cfldcaption").toString();
					labelCF = new Label(i, 1, fieldname, wcfFcolumn);
					ws.setColumnView(i, 20);// 设置列宽
					ws.setRowView(i, 420);// 设置行高
					ws.addCell(labelCF);
				}
			}
		}
		else {
			for (int i = 0; i < b.length; i++) {
				labelCF = new Label(i, 1, b[i].trim(), wcfFcolumn);
				ws.addCell(labelCF);
			}
		}
	}
	
	//写入数据
	@SuppressWarnings("unchecked")
	protected void onWriteData(List list,List fieldslist,Object flag,WritableSheet ws,Label labelCF,String[] b) throws WriteException
	{
		// 写数据
		int t = 2;// 从第三行开始写数据
		jxl.write.WritableFont wfdata = new jxl.write.WritableFont(
				WritableFont.createFont("宋体"), 9, WritableFont.NO_BOLD);
		jxl.write.WritableCellFormat wcfFdata = new jxl.write.WritableCellFormat(
				wfdata);
		wcfFdata.setWrap(true);//单元格允许换行

		wcfFdata.setBorder(jxl.format.Border.ALL,jxl.format.BorderLineStyle.THIN);
		
		for (int j = 0; j < list.size(); j++) {// 共有几条记录
			HashMap record2 = (HashMap) list.get(j);// 一条记录
			
			if (fieldslist.size() > 0) {// 遍历出字段						
				if(flag != null && flag.toString().equals("0")){//增加序号								
					labelCF = new Label(0, t, j+1+"", wcfFdata);									
					ws.addCell(labelCF);// 将Label写入sheet中
				}
				
				onWriteRecord(fieldslist,record2,wcfFdata,labelCF,t,ws);
				
			}
			 else {
				for (int i = 0; i < b.length; i++) {
					if (record2.get(b[i].trim()) != null)
						labelCF = new Label(i, t, record2.get(
								b[i].trim()).toString(), wcfFdata);// 创建写入位置和内容
					else
						labelCF = new Label(i, t, "", wcfFdata);// 创建写入位置和内容							
					ws.addCell(labelCF);// 将Label写入sheet中
				}
			}
			t++;
			ws.setRowView(j, 420);// 设置行高
		}
	}
	
	//向Excel写入数据
	@SuppressWarnings("unchecked")
	protected void onWriteRecord(List fieldslist,HashMap record,jxl.write.WritableCellFormat wcfFdata,Label labelCF,int t,WritableSheet ws)
	{
		for (int i = 0; i < fieldslist.size(); i++) {
			Object fieldItem = fieldslist.get(i);
			HashMap fieldrecord = (HashMap) fieldItem;
			String field=" ";
			if(fieldrecord.get("cfld") != null){
				 field = fieldrecord.get("cfld").toString();
			}
		
			int ifieldtype = 0;
			if(fieldrecord.get("ifieldtype") != null && !fieldrecord.get("ifieldtype").equals(""))
				ifieldtype = Integer.parseInt(fieldrecord.get("ifieldtype")+"");
			
			if(record.get(field.trim()) != null){
				String cellvalue = "";
				if(ifieldtype == 3 && !record.get(field.trim()).equals("")){//日期类型
					cellvalue = sdf.format((Date)record.get(field.trim()));
				}
				else{
					cellvalue = record.get(field.trim())+"";
				}
				labelCF = new Label(i+1, t, cellvalue, wcfFdata);						
			}
			else 
				labelCF = new Label(i+1, t, "", wcfFdata);
			try {
				ws.addCell(labelCF);// 将Label写入sheet中	
			} catch (RowsExceededException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (WriteException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}								
		}
		
	}

	public static void main(String[] args) {
		ExcelHandle e = new ExcelHandle();
		String url = e.getClass().getResource("").getFile();
		System.out.println(url.substring(0, url.indexOf("WEB-INF")));
	}
}