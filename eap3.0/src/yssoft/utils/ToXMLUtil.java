/**
 * @author zmm
 * @description list 转化为 xml
 */
package yssoft.utils;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;

public class ToXMLUtil {
	// 拼接 xml 数据
	private static String id="ID";
	private static String pcode="PCODE";
	private static List keys=null;
	private static int keyslen=0;
	/**
	 * @author zmm
	 * @param data 		数据源
	 * @param _id		主键标识
	 * @param _pcode	上级标识
	 * @param pflag     父节点 结束标志 -1
	 * @return string
	 */
	public static String createTree(List data,String id,String pcode,String pflag){
		
		if(data==null || data.size()==0){
			return "<root />";
		}
		//获取 key 值 
		HashMap hmap=(HashMap) data.get(0);
		Iterator iterator=hmap.keySet().iterator();
		
		keys=new ArrayList();
		while(iterator.hasNext()){
			String key = (String)iterator.next();
			keys.add(key);
		}
		keyslen=keys.size();
		
		ToXMLUtil.id=(id==null?"ID":id);
		ToXMLUtil.pcode=(pcode==null?"PCODE":pcode);
		
		StringBuffer buf = new StringBuffer();  
		List root = getRootNode(data,pflag);   
		Iterator it=root.iterator();   
		while(it.hasNext()){   
			HashMap record = (HashMap)it.next();
			createNode(record,data,buf,1); 
		}
		return   "<root>"+buf.toString()+"</root>"; 
	}
	
    public static List getRootNode(List data,String pflag){   
		List root = new ArrayList();   
		Iterator it=data.iterator();   
		while(it.hasNext()){
			HashMap record = (HashMap) it.next(); 
			if(record.get(pcode)==null){
				continue;
			}
			String iparentid=record.get(pcode).toString();
			if(iparentid.equals(pflag)){   
					root.add(record);
				}
		}  
		return root;   
	 }
			  
    public static void createNode(HashMap node,List data,StringBuffer buf,int deep){   
		buf.append("<node ");
		
		int i=0;
		for(i=0;i<keyslen;i++){
			String key = (String)keys.get(i);
			buf.append(" "+key+"='"); 
			if(node.get(key) != null)
				buf.append(node.get(key).toString());
			buf.append("' ");
		}
		
		buf.append(">");
		  
		Iterator it=data.iterator();   
		while(it.hasNext()){   
			HashMap record = (HashMap)it.next();
			if(node.get(id).toString().equals(record.get(pcode).toString())){
				createNode(record,data,buf,deep+1);
			}
		}   
		buf.append("</node>");
   }
    // 没有层次结构的
    public static String createTreeFromList(List data){
    	
    	if(data==null || data.size()==0){
			return "<root />";
		}
		//获取 key 值 
		HashMap hmap=(HashMap) data.get(0);
		Iterator iterator=hmap.keySet().iterator();
		
		keys=new ArrayList();
		while(iterator.hasNext()){
			String key = (String)iterator.next();
			keys.add(key);
		}
		keyslen=keys.size();
		StringBuffer buf = new StringBuffer();  
		int len=data.size();
		for(int j=0;j<len;j++){
			HashMap node = (HashMap) data.get(j);
			buf.append("<node ");
			for(int i=0;i<keyslen;i++){
				String key = (String)keys.get(i);
				buf.append(" "+key+"='"); 
				if(node.get(key) != null)
					buf.append(node.get(key).toString());
				buf.append("' ");
			}
			
			buf.append(" />");	
		}
		return   "<root>"+buf.toString()+"</root>"; 
    }
}
