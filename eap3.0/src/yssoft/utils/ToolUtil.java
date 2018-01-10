/**    
 * 文件名：ToolUtil.java    
 * 版本信息：    
 * 日期：2011-8-2    
 * 版权所有    
 */
package yssoft.utils;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;

import NT124DOG.NT124JNI;


/**
 * 
 * 项目名称：yscrm
 * 类名称：ToolUtil
 * 类描述：存放公共方法
 * 公共方法类
 * 创建人：钟晶
 * 创建时间：2011-8-2 下午04:38:26
 * 修改人：钟晶
 * 修改时间：2011-8-2 下午04:38:26 修改备注：
 * @version
 * 
 */
public class ToolUtil {

	/**
	 * getPid(根据输入，找出pid)    
	 * @param   ccode 编码
	 * @return int 父类编码    
	 * @since  CodingExample　
	 * Ver(编码范例查看) 1.1
	 */
	public static String getPid(String ccode) {
		//截取字符窜
		String[] codes = ccode.split("\\.");
		//初始化pid
		String ipid = null;
		//如果没有输入pid，则设置为父节点
		if (codes.length == 1) {
			return "-1";
		} else {
			int i=ccode.lastIndexOf(".");
			ipid = ccode.substring(0, i);
		}
		return ipid;
	}
	
	/**
	 * 
	 * hasPid(判断父节点是否存在)    
	 * @param   result 查询出来的结果集 
	 * @param  pid    父节点编码
	 * @return boolean  是否存在（true为存在，false为不存在）  
	 * @since  CodingExample　Ver(编码范例查看) 1.1
	 */
	public static boolean hasPid(List result)
	{
		//如果父节点编码为-1,或者父节点存在
		if(result!=null)
		{
			return true;
		}
		return false;
	}
	
	/**
	 * hasCode(判断编码是否存在)    
	 * @param   result 结果集  
	 * @return boolean 是否存在，true为存在,false为不存在   
	 * @since  CodingExample　Ver(编码范例查看) 1.1
	 */
	public static boolean hasCode(List result)
	{
		if(result.size()>0)
		{
			return true;
		}
		return false;
	}
	/**
	 * formatDay(格式化时间)
	 * 创建者：lovecd
	 * 创建时间：2011-2011-8-21 上午10:12:54
	 * 修改者：lovecd
	 * 修改时间：2011-2011-8-21 上午10:12:54
	 * 修改备注：   
	 * @param   date 日期
	 * @param    format  格式化字符串       
	 * @return String
	 * @Exception 异常对象    
	 *
	 */
	public static String formatDay(Date date, String format) {
		if(format == null){
			format="yyyy-MM-dd HH:mm:ss";
		}
		SimpleDateFormat s = new SimpleDateFormat(format);
		return s.format(date);
	}
	
	public static String generateUpLoadFileName(String prex){
		return prex+(new Date()).getTime()+(int)Math.random()*1000;
	}
	//拼接sql，根据字段信息
	public static String combiSql(List list,String table,String value,String key){
		if(key==null || key==""){
			key="iid";
		}
		if(list == null || list.size()==0){
			return "";
		}
		String sql="";
		int len=list.size();
		for (int i=0;i<len;i++){
			HashMap map=(HashMap) list.get(i);
			String candor=(String) map.get("candor");
			String cleftbk=(String) map.get("cleftbk");
			String cfield=(String) map.get("cfield");
			String coperator=(String) map.get("coperator");
			String cvalue=(String) map.get("cvalue");
			String crightbk=(String) map.get("crightbk");
			String str="";
			if("like".equals(coperator)){
                cvalue = "%"+cvalue+"%";
				str = candor+" "+cleftbk+" "+cfield+" "+coperator+" '"+cvalue+"' "+crightbk;
			}else if("is null".equals(coperator.trim())){
				str = candor+" "+cleftbk+" "+cfield+" "+coperator+" "+crightbk;
			}else if("is not null".equals(coperator.trim())){
				str = candor+" "+cleftbk+" "+cfield+" "+coperator+" "+crightbk;
			}else{
				str= candor+" "+cleftbk+" "+cfield+" "+coperator+" '"+cvalue+"' "+crightbk;
			}
			sql +=str;
		}
		sql = "select count(*) from "+table+" where "+key+"='"+value+"' "+sql;
		return sql;
	}
	
	/**
	 * 时间相减得到天数
	 * @param beginDateStr
	 * @param endDateStr
	 * @return
	 */
	public static int getDaySub(String beginDateStr,String endDateStr){
		int day=0;
		java.text.SimpleDateFormat format = new java.text.SimpleDateFormat("yyyy-MM-dd");    
		java.util.Date beginDate;
        java.util.Date endDate;
        
        try {
        	beginDate = format.parse(beginDateStr);
			endDate= format.parse(endDateStr);
			day=Integer.parseInt(String.valueOf((endDate.getTime()-beginDate.getTime())/(24*60*60*1000)));    
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}    
		return day;
	}

    public static Boolean isStringNull(String s) {
        if (s == null || s.trim().equals("") || s.trim().equals("null"))
            return true;
        return false;
    }

    public static Boolean isStringNotNull(String s) {
        return !isStringNull(s);
    }

    public static String toString(Object o) {
        String res = "";

        try {
            if (o == null) {
                res = "";
            } else {
                String s = o + "";
                if (s != null && !"".equals(s) && s != "null" && s.length() > 0
                        && !"null".equals(s)) {
                    res = s.toString();
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return res;
    }

    public static int toInt(Object o) {
        int res = 0;

        try {
            if (null == o) {
                res = 0;
            } else {
                String s = o + "";
                if (s != null && !"".equals(s) && s != "null" && s.length() > 0
                        && !"null".equals(s)) {
                    res = Integer.parseInt(s);
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return res;
    }

}
