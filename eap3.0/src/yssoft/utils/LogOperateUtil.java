package yssoft.utils;

/**
 * 作者:孙东亚
 * 日期:2011年 10月15日
 * 功能:日志操作记录类
 */

import flex.messaging.FlexContext;
import org.apache.log4j.Logger;
import yssoft.daos.BaseDao;
import yssoft.vos.HrPersonVo;
import yssoft.vos.LogPerateVo;

import javax.servlet.http.HttpServletRequest;
import java.io.Serializable;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
	
	public class LogOperateUtil implements Serializable{
		
		private static Logger logger = Logger.getLogger(LogOperateUtil.class);
		
		public static BaseDao baseDao = BeanFactoryUtil.getBean(BaseDao.class) ;
		
		
		/**
		 * 插入系统操作日志
		 *  
		 * @param params  (operate   操作类型 ; registerId  注册表IID;  result 处理结果)
		 */
		@SuppressWarnings("unchecked")
		public static void  insertLog(HashMap params)throws Exception,RuntimeException
		{
//			try{
			String operate = params.get("operate").toString();    //当前操作
			HashMap map  = (HashMap)params.get("params");
			int iinvoice = params.get("iinvoice")!=null ? Integer.parseInt(params.get("iinvoice").toString()) : 0;
			int registerId = Integer.parseInt(map.get("iifuncregedit").toString());//注册表ID
			
			HrPersonVo person =(HrPersonVo) FlexContext.getFlexSession().getAttribute("HrPerson");
			int userId     = person.getIid(); 
			String userIp = person.getCip();
			
			String chineseOperate = ""; //中文操作
			if( operate.equals("select") )chineseOperate = " 查看 ";
			else if( operate.equals("add") )chineseOperate = " 新增 ";
			else if( operate.equals("update") )chineseOperate = " 修改 ";
			else if( operate.equals("delete")  )chineseOperate = " 删除 ";
			else { chineseOperate = operate ;}

			HashMap resultMap = (HashMap)baseDao.queryForObject("get_single_funcregedit",registerId ); //获取注册表信息
			LogPerateVo logObject = new LogPerateVo();
			
			// -------未实现-------
			logObject.setCnode("用户操作"); //业务节点
		    logObject.setCworkstation(""); //站点机器名
		    logObject.setIinvoice(iinvoice); //操作单据ID
		    
		    //------- 已实现 -------
		    logObject.setIperson(userId); //操作人员ID
		    logObject.setDoperate(getDateTime()); //操作时间
		    logObject.setIfuncregedit(registerId+""); //注册ID
		    logObject.setCfunction(chineseOperate); //操作功能
		    logObject.setCresult(params.get("result").toString() !="fail"?"成功":"失败"); //操作结果
		    logObject.setCip( userIp); 	  //Ip地址
		    
		   baseDao.insert("add_log",logObject );
//			}catch(Exception e){
//				e.printStackTrace();
//				logger.error("----------------insertLog 插入日子出错--------------------");
//			}
		}
		
		
		/**
		 * 获取真实IP
		 * @return
		 */
		private static String getIpAddr() {
			HttpServletRequest request = flex.messaging.FlexContext.getHttpRequest();
			String ip = request.getHeader("x-forwarded-for");
			if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)){
				ip = request.getHeader("Proxy-Client-IP");
			}
		   if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			   	ip = request.getHeader("WL-Proxy-Client-IP");
		   }
		   if(ip == null || ip.length() == 0 || "unknown".equalsIgnoreCase(ip)) {
			   ip = request.getRemoteAddr();
		   }
			return ip;
		}
		
		/**
		 * 获取当前时间
		 * @return
		 */
		private static String getDateTime(){
			Date now = new Date();
		    SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		    String str = format.format(now);
		    return str;
		}

	}
