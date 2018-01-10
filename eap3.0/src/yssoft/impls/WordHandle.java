/*
 * WordHandle
 * auth:YJ
 * date:2012-05-28
 */
package yssoft.impls;

import com.lowagie.text.*;
import com.lowagie.text.Font;
import com.lowagie.text.rtf.RtfWriter2;

import java.awt.*;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.*;
import java.util.List;

public class WordHandle {

	SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
	
	public WordHandle(){}
	
	/*
	 * onWriteWord(数据写入Word)
	 * auth:YJ
	 * date:2012-05-28
	 */
	@SuppressWarnings("unchecked")
	public HashMap onWriteWord(HashMap paraObj){
		
		HashMap<String, Object> resultMap = new HashMap<String, Object>();
		String filename = UUID.randomUUID().toString()+".doc";
		String filetitle="";
		List list = new ArrayList();
		List fieldslist = new ArrayList();
		
		String url = this.getClass().getResource("").getFile();
		url = url.replace("%20", " ");
		
		File fpath = new File(url.substring(0, url.indexOf("WEB-INF"))+ "/upload/");
		if(fpath.exists() == false){
			fpath.mkdir();
			System.out.println("路径不存在,但是已经成功创建了:->"+fpath);
		}
		String strpath = fpath+"/"+filename;
		
		if (paraObj.get("title")!=null)filetitle=paraObj.get("title").toString();// 标题
		fieldslist = (List) paraObj.get("fieldsList");// 包括字段及字段说明的集合
		list = (List) paraObj.get("arr");// 将前台的数据集转换为List类型
		
		onWrite(strpath,filetitle,fieldslist,list);
		
		resultMap.put("filename", filename);
		return resultMap;
		
	}
	
	@SuppressWarnings("unchecked")
	private void onWrite(String fpath,String title,List fieldslist,List datalist){
		
		Document document = new Document(PageSize.A4);

		try{

			RtfWriter2.getInstance(document,
					new FileOutputStream(fpath));
			document.open(); 

			//写入标题
			Paragraph p = new Paragraph(title, 
					new Font(Font.NORMAL, 18, Font.NORMAL, new Color(0, 0, 0)) );
			p.setAlignment(1);
			document.add(p); 
			
			for(int i=0;i<datalist.size();i++){
				
				HashMap record = (HashMap) datalist.get(i);//一条记录
				if (fieldslist.size() > 0) {// 遍历出字段
					
					String cellvalue = "";
					
					for (int j = 0; j < fieldslist.size(); j++) {
						Object fieldItem = fieldslist.get(j);
						HashMap fieldrecord = (HashMap) fieldItem;
						String field = fieldrecord.get("cfld").toString();
						int ifieldtype = Integer.parseInt(fieldrecord.get("ifieldtype")+"");
						
						if(record.get(field.trim()) != null){
							
							if(ifieldtype == 3){//日期类型
								if(record.get(field.trim()) == null || (record.get(field.trim())+"").equals("")) cellvalue += "  ";
								else cellvalue += sdf.format((Date)record.get(field.trim()))+"  ";
							}
							else{
								cellvalue += record.get(field.trim())+"  ";
							}
							
						}
						
					}
					
					Paragraph tp = new Paragraph(cellvalue, 
							new Font(Font.NORMAL, 10, Font.NORMAL, new Color(0, 0, 0)) );
					document.add(tp);
					
				}
				
			}
			
			
		    document.close(); 

		}catch (FileNotFoundException e) {  
		    e.printStackTrace();  
		}catch (DocumentException e) {  
		    e.printStackTrace();  
	    } catch (Exception e) {  
		    e.printStackTrace();  
	    } 
	}
}
