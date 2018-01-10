package yssoft.communication;

import yssoft.impls.UtilServiceImpl;
import yssoft.services.IAs_OptionsService;
import yssoft.vos.HrPersonVo;
import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;

import java.io.InputStreamReader;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.SocketTimeoutException;
import java.net.URL;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;

import flex.messaging.util.URLEncoder;
import net.sf.json.JSONObject;
import net.sf.json.xml.XMLSerializer;
/**
 * Created by ln on 2015/7/16.
 */
public class CommunicateUtil {  
	//private static String appidentify = "041EE18E6C8A2ED586113EDAAD1C0D83";    		//接口公司提供  应用标识
	//private static String appkey_permanent = "DBCD9BB1CCE1A9D6518AF61CB1EBD6D7";    //接口公司提供  应用永久秘钥
	private static String appidentify = "";
	private static String appkey_permanent = "";
	//private static String company_identifer = "ZENYU";   //公司英文简称
	//private static String account_identify = "CE33AD3639951D16D0101807DC50000D"; //账号标识
	//private static String account_key = "DBCD9BB1CCE1A9D6518AF61CB1EBD6D7";//账号永久秘钥
	//private static String key_temp= "DEFBDF9DD430640DA3427FA9FFD60E15";    // 账号临时秘钥     
	    
    private static HrPersonVo user;
    private static String linkPhone = ""; //参与联系人电话,逗号间隔

    private UtilServiceImpl utilService;
    private IAs_OptionsService ipns;

    public void setUtilService(UtilServiceImpl utilService) {
        this.utilService = utilService;
    }

    public UtilServiceImpl getUtilService() {
        return utilService;
    }

    public void setIpns(IAs_OptionsService ipns) {
		this.ipns = ipns;
	}
    
    
    CommunicateUtil() {
        //获取管理员相关信息
    }

    public static String getContent(String htmlurl) {
        URL url;
        String temp;
        StringBuffer sb = new StringBuffer();
        try {
            url = new URL(htmlurl);
            BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream(),"UTF-8"));// 读取网页全部内容
            while ((temp = in.readLine()) != null) {
                sb.append(temp);
            }
            in.close();
        } catch (MalformedURLException me) {
            System.out.println("你输入的URL格式有问题！请仔细输入");
            me.getMessage();
            me.printStackTrace();
        } catch (Exception e) {
            e.printStackTrace();
        }
        String content = sb.toString();
        return content;
    }

    //获取sign值
    public static String SHA1(String paramStr) throws NoSuchAlgorithmException {
        MessageDigest alg = MessageDigest.getInstance("SHA-1");
        alg.update(paramStr.getBytes());
        byte[] bts = alg.digest();
        String result = "";
        String tmp = "";
        for (int i = 0; i < bts.length; i++) {
            tmp = (Integer.toHexString(bts[i] & 0xFF));
            if (tmp.length() == 1) result += "0";
            result += tmp;
        }
        return result;
    }
    //获取认证码  
    private static String getSign(String account_identify,String key,String timestamp) {
    	String sign = "";
    	try {
    		sign = SHA1(account_identify +key +timestamp);
    		//System.out.println("sign ============= "+sign); 
    	} catch (NoSuchAlgorithmException e) {
    		e.printStackTrace();
    	} 
    	return sign;
    }
    public HashMap communicate(HashMap param) {
    	HashMap _h=new HashMap();
    	getPhone(param);//多人电话              
    	_h=getFourth();//多方通话
        return _h;
    } 
    
    //设置多人电话
    private static void getPhone(HashMap param) {
    	//登陆人员id   登陆人员号码    联系人员相关信息列表
        user = (HrPersonVo) param.get("user");
        ArrayList<HashMap> list = new ArrayList<HashMap>();
        list = (ArrayList) param.get("personlist");
        linkPhone="";
        for(HashMap map : list) {
            linkPhone += map.get("cmobile") + ",";
        }
        linkPhone = linkPhone.substring(0,linkPhone.length() - 1);
    }
    
  //发起多方通话接口
    private HashMap  getFourth() { 
    	HashMap _h=new HashMap();
    	
    	String account_identify=ipns.getSysParamterByiid(100);//账号标识
    	String key_temp=ipns.getSysParamterByiid(101);//账号临时秘钥
    	//String account_key="";//永久秘钥---未启用保存
    	//String key_temp=getFirstResult(account_identify,account_key);//需更新临时秘钥时启用--启用后就要保存秘钥了 
    	if(account_identify!="" && key_temp!=""){
        	//String timestamp=new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date());//timestamp时间戳   	
    		String timestamp=new Date().getTime()+"";
    		String fourthsign = getSign(account_identify,key_temp,timestamp);//认证码   
            String strFourth = "http://open.yonyoutelecom.cn/httpIntf/createConference.do?caller="+user.getCmobile1()+"&phones="+linkPhone+
            		"&account_identify="+account_identify+"&userId="+ user.getIid()+"&timestamp="+timestamp+"&sign="+fourthsign;
            //System.out.println(strFourth);
            String rstFourth = getContent(strFourth);
            JSONObject jsonObj = JSONObject.fromObject(rstFourth);
            if("0".equals(jsonObj.getString("result")+"")){
            	 _h.put("result", jsonObj.getString("result"));
                 _h.put("describe", jsonObj.getString("discripe"));
                 String sessionId=jsonObj.getString("sessionId")+"";
                 String inserSql="insert into as_commSessionId(isessionid,iperson) values('"+sessionId+"',"+user.getIid()+");";
                 ipns.InsertCommSessionid(inserSql);//存储sessionId
            }else{
            	_h.put("result","-1");
            	_h.put("describe", jsonObj.getString("describe"));
            }
             return _h;
            //sessionId   会话id  用于邀请、踢人
            
    	}else{
    		System.out.println("未设置标识秘钥信息！");
    		return _h;
    	}
    }
    
 
    //更新组织账号的临时密钥接口
    private static String getFirstResult(String appidentify,String appkey_permanent) {
    	 String key_temp="";
    	 //String timestamp=new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date());//timestamp时间戳 
    	 String timestamp=new Date().getTime()+"";
    	 String sign = getSign(appidentify,appkey_permanent,timestamp);   	
    	 String strFirst ="http://open.yonyoutelecom.cn/httpIntf/getAccountkey.do?account_identify="+ appidentify+
    			 "&sign="+sign+"&timestamp="+timestamp;
    	 String rstFirst = getContent(strFirst);
    	 //System.out.println("JsonObject临时秘钥字符串====="+rstFirst); 
    	 key_temp= rstFirst.substring(rstFirst.lastIndexOf(":")+2,rstFirst.lastIndexOf("\""));   	 
    	return key_temp;
    }
           
    //组织账号注册接口
    public static HashMap<String,Object> getSecondResult(String company_identifer,String name,String telephone){ 
    	File file=new File("D:\\zysoft\\CommunicateUtil.xml");    
    	if(!file.exists())    
    	{    
    	    try {    
    	        file.createNewFile();    
    	    } catch (IOException e) {            	       
    	        e.printStackTrace();    
    	    }    
    	}    	
    	HashMap<String,Object> _map = new HashMap<String,Object>(); 
    	//name=user.getCname();
    	//telephone=user.getCmobile1();
    	//String timestamp=new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date());//timestamp时间戳 
    	String timestamp=new Date().getTime()+"";
    	String appkey_temp=getFirstResult(appidentify,appkey_permanent);//应用标识下的临时秘钥
    	
    	String secondsign=getSign(appidentify,appkey_temp,timestamp);  	
    	String strSecond ="http://open.yonyoutelecom.cn/httpIntf/accountReg.do?account_identifer="+appidentify+"&company_identifer="+company_identifer+
    			"&authData={\"name\":\""+name+"\",\"telephone\":\""+telephone+"\",\"linker\":\"\",\"email\":\"\"}&sign="+
    			secondsign+"&timestamp="+timestamp+"&record_url=&status_url=";
    	//System.out.println(strSecond);
    	String rstSecond = getContent(strSecond);//data  组织名称  账号标识  永久秘钥   临时秘钥
    	System.out.println(rstSecond);
    	//json格式的字符串处理   	  
    	JSONObject jsonObj = JSONObject.fromObject(rstSecond);
    	int result=Integer.parseInt(jsonObj.getString("result"));
    	if(result==0){
    		String data = jsonObj.getString("data");       	 
        	JSONObject jsonObj2 = JSONObject.fromObject(data); 
        	String account_identify = jsonObj2.getString("account_identify");//账号标识
        	String key_temp = jsonObj2.getString("key_temp");//永久秘钥
        	String key_permanent = jsonObj2.getString("key_permanent");//临时秘钥              	      	
        	_map.put("name", name);//申请人
        	_map.put("telephone", telephone);//申请人电话
        	_map.put("company_identifer", company_identifer);//账号唯一名称
        	_map.put("account_identify", account_identify);//账号标识
        	_map.put("key_temp", key_temp);//账号永久秘钥
        	_map.put("key_permanent", key_permanent);//账号临时秘钥
        	_map.put("cmemo", key_permanent);//完整的json字符串          	
        	System.out.println("账号唯一名称:"+account_identify+" 秘钥信息:"+data);//前台打印
        	 
        	//写入xml文件中        	        	        	
        	try { 
        	jsonObj2.put("name",name );	
        	jsonObj2.put("telephone", telephone);//申请人电话
        	jsonObj2.put("company_identifer", company_identifer);//账号唯一名称
        	XMLSerializer xmlSerializer = new XMLSerializer();
        	xmlSerializer.setRootName("user_info");
        	xmlSerializer.setTypeHintsEnabled(false);
        	String xml = xmlSerializer.write(jsonObj2);
        	FileWriter fw=new FileWriter("D:\\zysoft\\CommunicateUtil.xml");
            fw.write(xml);
            fw.flush();
            fw.close();	
        	} catch (IOException e) {            	       
    	        e.printStackTrace();    
    	    } 
    	}else{
    		System.out.println("注册重复=========================");
    	}
    	return _map;   	
    }    
    //通话中邀请参与人接口
    
    public static String addPerson(HashMap h){
    	String result="-1";
    	String sessionId=h.get("isessionid")+"";
    	String cmobile=h.get("cmobile")+"";
    	String tUrl="http://dudu.yonyoutelecom.cn/httpIntf/conferenceAdd.do?sessionid="+sessionId+"&calledNbr="+cmobile;
    	String tdata=getContent(tUrl);
    	JSONObject jsonobj=JSONObject.fromObject(tdata);
    	if(jsonobj.getString("result").equals("0")){//添加成功
    		result="0";
    	}
    	return result;
    }
    
    //通话中踢出参与人接口
    
    public static String deletePerson(HashMap h){
    	String result="-1";
    	String sessionId=h.get("isessionid")+"";
    	String cmobile=h.get("cmobile")+"";
    	String delUrl="http://dudu.yonyoutelecom.cn/httpIntf/conferenceMinus.do?sessionid="+sessionId+"&calledNbr="+cmobile;
    	String deldata=getContent(delUrl);
    	JSONObject jsonobj=JSONObject.fromObject(deldata);
    	if(jsonobj.getString("result").equals("0")){//踢人成功
    		result="0";
    	}
    	return result;
    }
    
    //结束多方通话接口   
    
    public static String telEnd(HashMap h){
    	String result="-1";
    	String sessionId=h.get("isessionid")+"";
    	String delUrl="http://dudu.yonyoutelecom.cn/httpIntf/endConference.do?sessionid="+sessionId;
    	String deldata=getContent(delUrl);
    	JSONObject jsonobj=JSONObject.fromObject(deldata);
    	if(jsonobj.getString("result").equals("0")){//会议结束成功
    		result="0";
    	}
    	return result;
    }
    
    //上传用户
    public  String uploadPerson(HashMap h){
    	int resultV=0;
    	ArrayList ac=(ArrayList)h.get("ac");
    	String account_identify=ipns.getSysParamterByiid(100);
    	String key_temp=ipns.getSysParamterByiid(101);
    	//String timestamp=new java.text.SimpleDateFormat("yyyyMMddHHmmss").format(new java.util.Date());//timestamp时间戳
    	String timestamp=new Date().getTime()+"";
    	String sign=getSign(account_identify,key_temp,timestamp);
    	for (int j = 0; j < ac.size(); j++) {
			HashMap h2 = new HashMap();
			h2 = (HashMap) ac.get(j);
			String userId=h2.get("iid")+"";
			String telephone=h2.get("cmobile1")+"";
			String cname=h2.get("cname")+"";
			String cemail=h2.get("cemail")+"";
			String authDataV="{\"userId\":\""+userId+"\",\"name\":\""+cname+"\",\"telephone\":\""+telephone+"\",\"email\":\""+cemail+"\"}";
			String authData=URLEncoder.encode(authDataV);
			
			String uploadUrl="http://open.yonyoutelecom.cn/user/registerUser.do?"+
                          "account_identify="+account_identify+""+
                          "&timestamp="+timestamp+""+
                          "&sign="+sign+""+
                          "&authData="+authData;
		
	    	String uploadPerson=getContent(uploadUrl);
	    	JSONObject jsonobj=JSONObject.fromObject(uploadPerson);
	    	if(jsonobj.getString("result").equals("0")){
	    		resultV=resultV+1;
	    		System.out.println(resultV+"位");
	    	}
	    	
		}
    	return resultV+"";
    }
    
    //话单接收接口
    
    
    
    //获取账户余额   szc
    public  HashMap orderBalance(HashMap hashmap){
    	HashMap _h=new HashMap();
    	String url = "http://cloud.yonyoutelecom.cn/CombinationServer/ queryAccountInfo";
    	try{
    	JSONObject jsonParam = new JSONObject();
    	jsonParam.put("cust_account", hashmap.get("cust_account")+"");//可以通过String cust_account=ipns.getSysParamterByiid(102)替代
    	
    	String data = postData(url, jsonParam.toString());
    	JSONObject jsonObj = JSONObject.fromObject(data);
    	String flag=jsonObj.getString("flag");
    	if(flag.equals("0000")){
    		JSONObject jsonObj2 = JSONObject.fromObject(jsonObj.getString("data"));
    		_h.put("main_account", jsonObj2.getString("main_account"));//主账户余额
    		_h.put("card_account", jsonObj2.getString("card_account"));//卡账本余额
    		_h.put("account_balance", jsonObj2.getString("account_balance"));//账户余额
    		_h.put("credit_line", jsonObj2.getString("credit_line"));//信用额度
    		_h.put("this_consumption", jsonObj2.getString("this_consumption"));//本期累计消费
    		_h.put("credit_balance", jsonObj2.getString("credit_balance"));//信用余额
    		_h.put("all_resource_num", orderUseTime(hashmap));
    	}else{
    		_h.put("main_account", "0");//主账户余额
    		_h.put("all_resource_num", "0");//剩余通话时长
    	}
    	
    	System.out.println(data);

    	} catch (Exception ex){

    	}
    	return _h;
    	}
    
  //可用时间  szc
    public  String orderUseTime(HashMap hashmap){
    	//HashMap _h=new HashMap();
    	String all_resource_num="0";
    	String app_key=ipns.getSysParamterByiid(103);
    	
    	String url = "http://cloud.yonyoutelecom.cn/CombinationServer/queryResourcesAllNum";
    	try{
    	JSONObject jsonParam = new JSONObject();
    	jsonParam.put("cust_account", ipns.getSysParamterByiid(102));
    	jsonParam.put("app_key",app_key);
    	jsonParam.put("product_key",app_key);
    	String data = postData(url, jsonParam.toString());
    	JSONObject jsonObj = JSONObject.fromObject(data);
    	String flag=jsonObj.getString("flag");
    	if(flag.equals("0000")){
    		JSONObject jsonObj2 = JSONObject.fromObject(jsonObj.getString("data"));
    		all_resource_num= jsonObj2.getString("all_resource_num");//可用时间
    		
    	}
    	
    	System.out.println(data);

    	} catch (Exception ex){

    	}
    	return all_resource_num;
    	}
    
    
  //获取上次通话时长 szc
    public  String orderLastTime(HashMap hashmap){
    	String lastTime="0";
    	//String account_identify=ipns.getSysParamterByiid(100);  account_identify也可以这样去取，建议手机端就可以这样取  
    	String url = "http://open.yonyoutelecom.cn/user/consumeTime.do?account_identify="+hashmap.get("account_identify")+"&userId="+hashmap.get("userId");
    	String data=getContent(url);
    	JSONObject jsonObj = JSONObject.fromObject(data);
    	
    	if(jsonObj.getString("result").equals("0")){//获取成功
    		JSONObject jsonObj2 = JSONObject.fromObject(jsonObj.getString("data"));
    		lastTime=jsonObj2.getString("lastTime");
    	}
    	return lastTime;
    	}
    
    //post请求    szc
    public static String postData(String path,String data){

    	String ret = null;
    	HttpURLConnection conn = null;

    	try {
    	URL url = new URL(path);
    	conn = (HttpURLConnection) url.openConnection();
    	conn.setConnectTimeout(25*1000);
    	conn.setReadTimeout(5*1000);
    	conn.setRequestMethod("POST");
    	conn.setRequestProperty("Accept-Charset", "utf-8");
    	conn.setRequestProperty("Content-Type", "application/json");  
    	//conn.setRequestProperty("Content-Type", "text/xml; charset=utf-8");  
    	    conn.setRequestProperty("Content-Length", String.valueOf(data.getBytes().length)); 
    	        
    	conn.setDoOutput(true);
    	conn.setDoInput(true);  

    	conn.connect();

    	System.out.println("write data to remote");
    	conn.getOutputStream().write(data.getBytes());// 输入参数
    	conn.getOutputStream().flush();

    	if(conn.getResponseCode() == 200) {  
    	 
    	System.out.print("read data from remote");
    	InputStream inStream = conn.getInputStream();
    	 	byte[] data1 = readStream(inStream);
    	 
    	 if(data1 != null){
    	 ret = new String(data1,"utf-8");
    	 }
    	 }
    	 
    	System.out.println("read data  from remote over");

    	//conn.getOutputStream().close();

    	conn.disconnect();

    	} catch (SocketTimeoutException e) {
    	conn.disconnect();
    	e.printStackTrace();
    	} catch (IOException e) {
    	e.printStackTrace();
    	conn.disconnect();
    	}

    	return ret;

    	}
    
    //szc
    public static byte[] readStream(InputStream inStream) throws IOException,SocketTimeoutException{
    	byte[] buffer = new byte[1024];
    	int len = -1;
    	ByteArrayOutputStream outStream = new ByteArrayOutputStream();
    	while ((len = inStream.read(buffer)) != -1) {
    	outStream.write(buffer, 0, len);
    	}
    	byte[] data = outStream.toByteArray();
    	outStream.close();
    	inStream.close();
    	return data;
    	}
    
    
    
	 public static void main(String[] args) throws IOException  {
		//String company_identifer = "ZENYU";//标记组织（个人）的唯一性
		String company_identifer = "ZENYU-cesi8";
		String name="zenyu";//注册人
		String telephone="18914868547";//注册电话号码			
		getSecondResult(company_identifer,name,telephone);//占时打印出来存到excel表中		
		//将数据保存进数据库  组织名称  账号标识  永久秘钥   临时秘钥  添加时间			
		//String key_temp=getFirstResult(account_identify,account_key);//需更新临时秘钥时启用--启用后就要保存秘钥了 账号标识+永久秘钥
		//System.out.println("更新后的临时密钥=="+key_temp);	
	} 

}
